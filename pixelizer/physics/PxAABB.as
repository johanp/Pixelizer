package pixelizer.physics {
	import flash.geom.Point;
	
	/**
	 * An Axis Aligned Boundinx Box. Can also be offsetted.
	 * @author Johan Peitz
	 */
	public class PxAABB {
		
		/**
		 * Half the with of box.
		 */
		public var halfWidth : Number;
		/**
		 * Half the height of box.
		 */
		public var halfHeight : Number;
		
		/**
		 * X offset from whatever collider this box belongs to.
		 */
		public var offsetX : Number;
		/**
		 * Y offset from whatever collider this box belongs to.
		 */
		public var offsetY : Number;
		
		/**
		 * Constructs a new Axis Aligned Bounding box.
		 * @param	pWidth	Width of box;
		 * @param	pHeight	Height of box.
		 * @param	pOffsetX	X offset for box.
		 * @param	pOffsetY	Y offset for box.
		 */
		public function PxAABB( pWidth : Number = 0, pHeight : Number = 0, pOffsetX : Number = 0, pOffsetY : Number = 0 ) {
			halfWidth = pWidth / 2;
			halfHeight = pHeight / 2;
			offsetX = pOffsetX;
			offsetY = pOffsetY;
		}
	
	}
}