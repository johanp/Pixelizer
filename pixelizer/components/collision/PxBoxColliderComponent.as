package pixelizer.components.collision {
	import pixelizer.physics.PxAABB;
	
	/**
	 * Collider consiting of a simple box.
	 */
	public class PxBoxColliderComponent extends PxColliderComponent {
		/**
		 * Axis Aliged Bounding Box for this collider.
		 */
		public var collisionBox : PxAABB = null;
		
		/**
		 * Constructs a new box collider.
		 * @param	pWidth	Width of box.
		 * @param	pHeight	Height of box.
		 * @param	pSolid	Specifies whether collider should be solid or not.
		 */
		public function PxBoxColliderComponent( pWidth : Number, pHeight : Number, pSolid : Boolean = true ) {
			super( pSolid );
			collisionBox = new PxAABB( pWidth, pHeight, pWidth / 2, pHeight / 2 );
			collisionLayer = 2;
			collisionLayerMask = 1 + 2;
		}
		
		/**
		 * Clears all resources used by collider.
		 */
		override public function dispose() : void {
			collisionBox = null;
			
			super.dispose();
		}
		
		/**
		 * Sets the size of the collision box.
		 * @param	pWidth	Width of box.
		 * @param	pHeight	Height of box.
		 */
		public function setSize( pWidth : Number, pHeight : Number ) : void {
			collisionBox.halfWidth = pWidth / 2;
			collisionBox.halfHeight = pHeight / 2;
		
		}
	
	}
}