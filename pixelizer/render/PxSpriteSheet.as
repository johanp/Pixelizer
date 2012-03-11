package pixelizer.render {
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import pixelizer.Pixelizer;
	import pixelizer.utils.PxLog;
	
	/**
	 * Holds information and bitmap data for a set of sprites.
	 * Sprite sheets are used for both animated sprites and tilemaps.
	 * @author Johan Peitz
	 */
	public class PxSpriteSheet {
		private static var _storedSheets : Dictionary = new Dictionary();
		
		private var _frameOffsets : Array;
		private var _framesDefault : Array;
		private var _framesHFlip : Array;
		private var _framesVFlip : Array;
		private var _spriteWidth : int;
		private var _spriteHeight : int;
		private var _totalFrames : int;
		
		private var _animations : Dictionary;
		
		/**
		 * Constructs a new sprite sheet.
		 */
		public function PxSpriteSheet() {
			_framesDefault = [];
			_frameOffsets = [];
			_framesHFlip = [];
			_framesVFlip = [];
			
			_animations = new Dictionary();
		
		}
		
		/**
		 * Adds frames to the sheet using bitmap data.
		 * @param	pBitmapData	Bitmap data to copy data from.
		 * @param	pSpriteWidth	Width of each sprite.
		 * @param	pSpriteHeight	Height of each sprite.
		 * @param	pFlipFlags	Specifies whether to store flipped versions of each sprite.
		 * @return Number of frames added.
		 */
		public function addFramesFromBitmapData( pBitmapData : BitmapData, pSpriteWidth : int, pSpriteHeight : int, pFlipFlags : int = 0 ) : int {
			var framesCreated : int = 0;
			
			_spriteWidth = pSpriteWidth;
			_spriteHeight = pSpriteHeight;
			
			var rect : Rectangle = new Rectangle( 0, 0, _spriteWidth, _spriteHeight );
			
			var rows : int = pBitmapData.height / _spriteHeight;
			var framesPerRow : int = pBitmapData.width / _spriteWidth;
			var currentFrame : int = 0;
			while ( currentFrame < rows * framesPerRow ) {
				rect.x = _spriteWidth * ( currentFrame % framesPerRow );
				rect.y = _spriteHeight * int( currentFrame / framesPerRow );
				var bd : BitmapData = new BitmapData( _spriteWidth, _spriteHeight, true, 0x0 );
				var matrix : Matrix = new Matrix( 1, 0, 0, 1, -rect.x, -rect.y );
				
				bd.draw( pBitmapData, matrix );
				_framesDefault.push( bd );
				_frameOffsets.push( new Point( 0, 0 ) );
				
				if ( pFlipFlags & Pixelizer.H_FLIP ) {
					bd = new BitmapData( _spriteWidth, _spriteHeight, true, 0x0 );
					matrix = new Matrix( -1, 0, 0, 1, rect.x + _spriteWidth, -rect.y );
					bd.draw( pBitmapData, matrix );
					_framesHFlip.push( bd );
				}
				
				if ( pFlipFlags & Pixelizer.V_FLIP ) {
					bd = new BitmapData( _spriteWidth, _spriteHeight, true, 0x0 );
					matrix = new Matrix( 1, 0, 0, -1, -rect.x, rect.y + _spriteHeight );
					bd.draw( pBitmapData, matrix );
					_framesVFlip.push( bd );
				}
				
				currentFrame++;
				
				framesCreated++;
			}
			
			return framesCreated;
		}
		
		/**
		 * Adds frames to the sheet using movieclip frames.
		 * @param pMC	Movieclip to copy data from.
		 * @param pQuality	Quality to use while rendering frames.
		 * @return Number of frames added.
		 */
		public function addFramesFromMovieClip( pMC : MovieClip, pQuality : String = StageQuality.LOW ) : int {
			var currentQuality : String = Pixelizer.stage.quality;
			Pixelizer.stage.quality = pQuality;
			
			for ( var f : int = 1; f <= pMC.totalFrames; f++ ) {
				pMC.gotoAndStop( f );
				
				var bounds : Rectangle = pMC.getBounds( pMC );
				
				var bd : BitmapData = new BitmapData( Math.ceil( bounds.width ), Math.ceil( bounds.height ), true, 0x0 );
				var matrix : Matrix = new Matrix( 1, 0, 0, 1, -bounds.x, -bounds.y );
				
				bd.draw( pMC, matrix );
				_framesDefault.push( bd );
				_frameOffsets.push( new Point( int( -bounds.x ), int( -bounds.y ) ) );
			}
			
			// revert quality settings
			Pixelizer.stage.quality = currentQuality;
			
			return pMC.totalFrames;
		}
		
		/**
		 * Clears all resources used.
		 */
		public function dispose() : void {
			for each ( var bd : BitmapData in _framesDefault ) {
				bd.dispose();
			}
			_framesDefault = null;
		}
		
		/**
		 * Adds an animation to this sprite sheet.
		 * @param	pAnimation Animation to store.
		 */
		public function addAnimation( pAnimation : PxAnimation ) : void {
			_animations[ pAnimation.label ] = pAnimation;
		}
		
		/**
		 * Sets frame offsets for the specified frames.
		 * This is useful if different frames have different hotspots.
		 * @param	pOffsets	Array of objects with offset information.
		 */
		public function setOffsets( pOffsets : Array ) : void {
			for each ( var o : Object in pOffsets ) {
				_frameOffsets[ o.id ].x = o.x;
				_frameOffsets[ o.id ].y = o.y;
			}
		}
		
		/**
		 * Returns the height of a sprite.
		 * @return Height of sprite.
		 */
		public function get spriteHeight() : int {
			return _spriteHeight;
		}
		
		/**
		 * Returns the width of a sprite.
		 * @return Width of sprite.
		 */
		public function get spriteWidth() : int {
			return _spriteWidth;
		}
		
		/**
		 * Returns a specific animation.
		 * @param	pLabel	Label of animation to return.
		 * @return	Found animation, or null.
		 */
		public function getAnimation( pLabel : String ) : PxAnimation {
			if ( _animations[ pLabel ] == null ) {
				PxLog.log( "no such label '" + pLabel + "'", this, PxLog.WARNING );
			}
			return _animations[ pLabel ];
		}
		
		/**
		 * Returns the frame offset of a certain frame.
		 * @param	pFrameID	ID of frame to check.
		 * @param	pHFlip	Specifies wether to take into calculation if the sprite is horizontally flipped.
		 * @return	Point with offset data.
		 */
		public function getFrameOffset( pFrameID : int, pFlipFlags : int ) : Point {
			var pt : Point = new Point();
			pt.x = _frameOffsets[ pFrameID ].x * ( pFlipFlags & Pixelizer.H_FLIP ? -1 : 1 );
			pt.y = _frameOffsets[ pFrameID ].y * ( pFlipFlags & Pixelizer.V_FLIP ? -1 : 1 );
			return pt;
		}
		
		/**
		 * Returns the bitmap data for a specific frame.
		 * @param	pFrameID	ID of frame.
		 * @param	pHFlip	Specifies whether frame should be horizontally flipper.
		 * @return	Bitmap data for frame.
		 */
		public function getFrame( pFrameID : int, pFlipFlags : int ) : BitmapData {
			if ( pFlipFlags & Pixelizer.H_FLIP ) {
				return _framesHFlip[ pFrameID ];
			}
			if ( pFlipFlags & Pixelizer.V_FLIP ) {
				return _framesVFlip[ pFrameID ];
			}
			
			return _framesDefault[ pFrameID ];
		}
		
		/**
		 * Stores a sprite sheet for global use.
		 * @param	pHandle	Identifier for the sprite sheet.
		 * @param	pSheet	The sprite sheet to store.
		 * @return	Stored sheet.
		 */
		public static function store( pHandle : String, pSheet : PxSpriteSheet ) : PxSpriteSheet {
			_storedSheets[ pHandle ] = pSheet;
			return pSheet;
		}
		
		/**
		 * Retrieves a sprite sheet previously stored.
		 * @param	pHandle	Identifier of sprite sheet to fetch.
		 * @return	Stored sprite sheet, or null if no sprite sheet was found.
		 */
		public static function fetch( pHandle : String ) : PxSpriteSheet {
			if ( _storedSheets[ pHandle ] == null ) {
				PxLog.log( "no sprite sheet found with handle '" + pHandle + "'", "[o PXSpriteSheet]", PxLog.WARNING );
			}
			return _storedSheets[ pHandle ];
		}
	}
}