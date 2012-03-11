package pixelizer.utils {
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	/**
	 * Utility class for quick creation of bitmap data.
	 */
	public class PxImageUtil {
		
		/**
		 * Creates a filled rectangle of the desired size and color.
		 * @param	pWidth	Width of rectangle.
		 * @param	pHeight	Height of rectangle.
		 * @param	pColor	Color of rectangle. Will be random if left out.
		 * @return	BitmapData containing a filled rectangle.
		 */
		public static function createRect( pWidth : int, pHeight : int, pColor : int = -1 ) : BitmapData {
			if ( pColor == -1 ) {
				pColor = Math.random() * 0xFFFFFF
			}
			
			return new BitmapData( pWidth, pHeight, false, pColor );
		}
		
		/**
		 * Creates a filled circle of the desired size and color.
		 * @param	pRadius	Radius of circle.
		 * @param	pColor	Color of circle. Will be random if left out.
		 * @return	BitmapData containing a filled rectangle.
		 */
		public static function createCircle( pRadius : int, pColor : int = -1 ) : BitmapData {
			if ( pColor == -1 ) {
				pColor = Math.random() * 0xFFFFFF
			}
			
			var bd : BitmapData = new BitmapData( pRadius * 2, pRadius * 2, true, pColor );
			
			var s : Sprite = new Sprite();
			s.graphics.lineStyle( 0, 0, 0 );
			s.graphics.beginFill( pColor );
			s.graphics.drawCircle( pRadius, pRadius, pRadius );
			s.graphics.endFill();
			bd.draw( s );
			
			return bd;
		}
	
	}
}