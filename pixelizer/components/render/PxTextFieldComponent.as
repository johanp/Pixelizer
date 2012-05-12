package pixelizer.components.render {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import pixelizer.Pixelizer;
	import pixelizer.render.PxBitmapFont;
	import pixelizer.utils.PxRepository;
	
	/**
	 * Renders a text field.
	 * @author Johan Peitz
	 */
	public class PxTextFieldComponent extends PxBlitRenderComponent {
		protected var _font : PxBitmapFont = null;
		protected var _text : String = "";
		protected var _color : int = 0x0;
		protected var _outline : Boolean = false;
		protected var _outlineColor : int = 0x0;
		protected var _shadow : Boolean = false;
		protected var _shadowColor : int = 0x0;
		protected var _shadowOffset : Point;
		protected var _background : Boolean = false;
		protected var _backgroundColor : int = 0xFFFFFF;
		protected var _alignment : int = Pixelizer.LEFT;
		protected var _padding : int = 0;
		
		private var _pendingTextChange : Boolean = false;
		private var _fieldWidth : int = 1;
		private var _multiLine : Boolean = false;
		
		/**
		 * Constructs a new text field component.
		 */
		public function PxTextFieldComponent() : void {
			super();
			_font = PxRepository.fetch( "_pixelizer_font" );
			_shadowOffset = Pixelizer.pointPool.fetch();
			_shadowOffset.x = 1;
			_shadowOffset.y = 1;
		}
		
		/**
		 * Clears all resources used.
		 */
		override public function dispose() : void {
			_font = null;
			Pixelizer.pointPool.recycle( _shadowOffset );
			_shadowOffset = null;
			super.dispose();
		}
		
		/**
		 * Sets which text to display.
		 * @param pText	Text to display.
		 */
		public function set text( pText : String ) : void {
			_text = pText;
			_text = _text.split( "\\n" ).join( "\n" );
			_pendingTextChange = true;
		}
		
		protected function updateBitmapData() : void {
			if ( _font == null )
				return;
			if ( _text == "" )
				return;
			
			var calcFieldWidth : int = _fieldWidth;
			var rows : Array = [];
			var fontHeight : int;
			var alignment : int = _alignment;
			
			fontHeight = _font.getFontHeight();
			
			// cut text into pices
			var lineComplete : Boolean;
			
			// get words
			var lines : Array = _text.split( "\n" );
			var i : int = -1;
			while ( ++i < lines.length ) {
				lineComplete = false;
				var words : Array = ( lines[ i ] as String ).split( " " );
				if ( words.length > 0 ) {
					var wordPos : int = 0;
					var txt : String = "";
					while ( !lineComplete ) {
						var changed : Boolean = false;
						
						var currentRow : String = txt + words[ wordPos ] + " ";
						
						if ( _multiLine ) {
							if ( _font.getTextWidth( currentRow ) > _fieldWidth ) {
								rows.push( txt.substring( 0, txt.length - 1 ) );
								txt = "";
								changed = true;
							}
						}
						
						txt += words[ wordPos ] + " ";
						wordPos++;
						
						if ( wordPos >= words.length ) {
							if ( !changed ) {
								var subText : String = txt.substring( 0, txt.length - 1 );
								calcFieldWidth = Math.max( calcFieldWidth, _font.getTextWidth( subText ) );
								rows.push( subText );
							}
							lineComplete = true;
						}
					}
				}
			}
			
			var finalWidth : int = calcFieldWidth + _padding * 2 + ( _outline ? 2 : 0 );
			var finalHeight : int = _padding * 2 + Math.max( 1, rows.length * fontHeight + ( _shadow ? 1 : 0 ) ) + ( _outline ? 2 : 0 );
			
			if ( bitmapData != null ) {
				if ( finalWidth != bitmapData.width || finalHeight != bitmapData.height ) {
					bitmapData.dispose();
					bitmapData = null;
				}
			}
			
			if ( bitmapData == null ) {
				bitmapData = new BitmapData( finalWidth, finalHeight, !_background, _backgroundColor );
			} else {
				bitmapData.fillRect( bitmapData.rect, _backgroundColor );
			}
			
			// render text
			var row : int = 0;
			bitmapData.lock();
			for each ( var t : String in rows ) {
				var ox : int = 0; // LEFT
				var oy : int = 0;
				if ( alignment == Pixelizer.CENTER ) {
					ox = ( _fieldWidth - _font.getTextWidth( t ) / 2 ) - _fieldWidth / 2;
				}
				if ( alignment == Pixelizer.RIGHT ) {
					ox = _fieldWidth - _font.getTextWidth( t );
				}
				if ( _outline ) {
					for ( var py : int = 0; py <= 2; py++ ) {
						for ( var px : int = 0; px <= 2; px++ ) {
							_font.render( bitmapData, t, _outlineColor, px + ox + _padding, py + row * fontHeight + _padding );
						}
					}
					ox += 1;
					oy += 1;
				}
				if ( _shadow ) {
					_font.render( bitmapData, t, _shadowColor, _shadowOffset.x + ox + _padding, _shadowOffset.y + oy + row * fontHeight + _padding );
				}
				_font.render( bitmapData, t, _color, ox + _padding, oy + row * fontHeight + _padding );
				row++;
			}
			bitmapData.unlock();
			
			_pendingTextChange = false;
		}
		
		/**
		 * Updates the bitmap data for the text field if any changes has been made.
		 * @param	pDT
		 */
		override public function update( pDT : Number ) : void {
			super.update( pDT );
			
			if ( _pendingTextChange ) {
				updateBitmapData();
			}
		}
		
		/**
		 * Specifies whether the text field should have a filled background.
		 */
		public function set background( value : Boolean ) : void {
			_background = value;
			_pendingTextChange = true;
		}
		
		/**
		 * Specifies the color of the text field background.
		 */
		public function set backgroundColor( value : int ) : void {
			_backgroundColor = value;
			_pendingTextChange = true;
		}
		
		/**
		 * Specifies whether the text should have a shadow.
		 */
		public function set shadow( value : Boolean ) : void {
			_shadow = value;
			
			if ( _shadow ) {
				_outline = false;
			}
			
			_pendingTextChange = true;
		}
		
		/**
		 * Specifies the color of the text field shadow.
		 */
		public function set shadowColor( value : int ) : void {
			_shadowColor = value;
			_pendingTextChange = true;
		}
		
		/**
		 * Sets the padding of the text field. This is the distance between the text and the border of the background (if any).
		 */
		public function set padding( value : int ) : void {
			_padding = value;
			_pendingTextChange = true;
		}
		
		/**
		 * Sets the color of the text.
		 */
		public function set color( value : int ) : void {
			_color = value;
			_pendingTextChange = true;
		}
		
		/**
		 * Sets the width of the text field. If the text does not fit, it will spread on multiple lines.
		 */
		public function set width( pWidth : int ) : void {
			_fieldWidth = pWidth;
			if ( _fieldWidth < 1 ) {
				_fieldWidth = 1;
			}
			_pendingTextChange = true;
		}
		
		/**
		 * Specifies how the text field should align text.
		 * LEFT, RIGHT, CENTER.
		 */
		public function set alignment( pAlignment : int ) : void {
			_alignment = pAlignment;
			_pendingTextChange = true;
		}
		
		/**
		 * Specifies whether the text field will break into multiple lines or not on overflow.
		 */
		public function set multiLine( pMultiLine : Boolean ) : void {
			_multiLine = pMultiLine;
			_pendingTextChange = true;
		}
		
		/**
		 * Specifies whether the text should have an outline.
		 */
		public function set outline( value : Boolean ) : void {
			_outline = value;
			if ( _outline ) {
				_shadow = false;
			}
			_pendingTextChange = true;
		}
		
		/**
		 * Specifies whether color of the text outline.
		 */
		public function set outlineColor( value : int ) : void {
			_outlineColor = value;
			_pendingTextChange = true;
		}
		
		/**
		 * Sets which font to use for rendering.
		 */
		public function set font( pFont : PxBitmapFont ) : void {
			_font = pFont;
			_pendingTextChange = true;
		}
		
		/**
		 * Returns the offset parameter for text shadows.
		 * @return a point
		 */
		public function get shadowOffset() : Point {
			return _shadowOffset;
		}
	
	}
}