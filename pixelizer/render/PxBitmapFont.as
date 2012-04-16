package pixelizer.render {
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import pixelizer.utils.PxLog;
	
	/**
	 * Holds information and bitmap glpyhs for a bitmap font.
	 * @author Johan Peitz
	 */
	public class PxBitmapFont {
		private static var ZERO_POINT : Point = new Point();
		
		private var _glyphs : Array;
		private var _glyphString : String;
		private var _maxHeight : int = 0;
		
		private var _matrix : Matrix = new Matrix();
		private var _colorTransform : ColorTransform = new ColorTransform();
		private var _point : Point = new Point();
		
		/**
		 * Creates a new bitmap font using specified bitmap data and letter input.
		 * @param	pBitmapData	The bitmap data to copy letters from.
		 * @param	pLetters	String of letters available in the bitmap data.
		 */
		public function PxBitmapFont( pBitmapData : BitmapData, pLetters : String ) {
			_glyphs = [];
			_glyphString = pLetters;
			
			// fill array with nulls
			for ( var i : int = 0; i < 256; i++ ) {
				_glyphs.push( null );
			}
			
			if ( pBitmapData != null ) {
				var fontData : Dictionary = new Dictionary();
				
				// get glyphs from bitmap
				var bgColor : uint = pBitmapData.getPixel( 0, 0 );
				var letterID : int = 0;
				for ( var cy : int = 0; cy < pBitmapData.height; cy++ ) {
					var rowHeight : int = 0;
					for ( var cx : int = 0; cx < pBitmapData.width; cx++ ) {
						if ( pBitmapData.getPixel( cx, cy ) != bgColor ) {
							// found non bg pixel
							var gx : int = cx;
							var gy : int = cy;
							// find width and height of glyph
							while ( pBitmapData.getPixel( gx, cy ) != bgColor )
								gx++;
							while ( pBitmapData.getPixel( cx, gy ) != bgColor )
								gy++;
							var gw : int = gx - cx;
							var gh : int = gy - cy;
							
							// create glyph
							var bd : BitmapData = new BitmapData( gw, gh, true, 0x0 );
							bd.copyPixels( pBitmapData, new Rectangle( cx, cy, gw, gh ), ZERO_POINT, null, null, true );
							
							// store glyph
							setGlyph( _glyphString.charCodeAt( letterID ), bd );
							letterID++;
							
							// store max size
							if ( gh > rowHeight ) {
								rowHeight = gh;
							}
							if ( gh > _maxHeight ) {
								_maxHeight = gh;
							}
							
							// go to next glyph
							cx += gw;
						}
					}
					// next row
					cy += rowHeight;
				}
			}
		
		}
		
		/**
		 * Clears all resources used by the font.
		 */
		public function dispose() : void {
			var bd : BitmapData;
			for ( var i : int = 0; i < _glyphs.length; i++ ) {
				bd = _glyphs[ i ];
				if ( bd != null ) {
					_glyphs[ i ].dispose();
				}
			}
			_glyphs = null;
		}
		
		/**
		 * Serializes font data to cryptic bit string.
		 * @return	Cryptic string with font as bits.
		 */
		public function getFontData() : String {
			var output : String = "";
			for ( var i : int = 0; i < _glyphString.length; i++ ) {
				var charCode : int = _glyphString.charCodeAt( i );
				var glyph : BitmapData = _glyphs[ charCode ];
				output += _glyphString.substr( i, 1 );
				output += glyph.width;
				output += glyph.height;
				for ( var py : int = 0; py < glyph.height; py++ ) {
					for ( var px : int = 0; px < glyph.width; px++ ) {
						output += ( glyph.getPixel32( px, py ) != 0 ? "1" : "0" );
					}
				}
			}
			return output;
		}
		
		private function setGlyph( pCharID : int, pBitmapData : BitmapData ) : void {
			if ( _glyphs[ pCharID ] != null ) {
				_glyphs[ pCharID ].dispose();
			}
			
			_glyphs[ pCharID ] = pBitmapData;
			
			if ( pBitmapData.height > _maxHeight ) {
				_maxHeight = pBitmapData.height;
			}
		}
		
		/**
		 * Renders a string of text onto bitmap data using the font.
		 * @param	pBitmapData	Where to render the text.
		 * @param	pText	Test to render.
		 * @param	pColor	Color of text to render.
		 * @param	pOffsetX	X position of thext output.
		 * @param	pOffsetY	Y position of thext output.
		 */
		public function render( pBitmapData : BitmapData, pText : String, pColor : uint, pOffsetX : int, pOffsetY : int ) : void {
			_point.x = pOffsetX;
			_point.y = pOffsetY;
			var glyph : BitmapData;
			
			for ( var i : int = 0; i < pText.length; i++ ) {
				var charCode : int = pText.charCodeAt( i );
				glyph = _glyphs[ charCode ];
				if ( glyph != null ) {
					_matrix.identity();
					_matrix.translate( _point.x, _point.y );
					_colorTransform.color = pColor;
					pBitmapData.draw( glyph, _matrix, _colorTransform );
					_point.x += glyph.width;
				}
			}
		
		}
		
		/**
		 * Returns the width of a certain test string.
		 * @param	pText	String to measure.
		 * @return	Width in pixels.
		 */
		public function getTextWidth( pText : String ) : int {
			var w : int = 0;
			
			for ( var i : int = 0; i < pText.length; i++ ) {
				var charCode : int = pText.charCodeAt( i );
				var glyph : BitmapData = _glyphs[ charCode ];
				if ( glyph != null ) {
					w += glyph.width;
				}
			}
			
			return w;
		}
		
		/**
		 * Returns height of font in pixels.
		 * @return Height of font in pixels.
		 */
		public function getFontHeight() : int {
			return _maxHeight;
		}
		
		/**
		 * Returns number of letters available in this font.
		 * @return Number of letters available in this font.
		 */
		public function get numLetters() : int {
			return _glyphs.length;
		}
		
	
	}
}

