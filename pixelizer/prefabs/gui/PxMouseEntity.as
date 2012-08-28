package pixelizer.prefabs.gui {
	import pixelizer.components.collision.PxBoxColliderComponent;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.PxEntity;
	
	/**
	 * Simple entity which allows the mouse to interact with other GUI elements.
	 * Add a render component in order to see it.
	 */
	public class PxMouseEntity extends PxEntity {
		
		/**
		 * Creates a new mouse entity.
		 */
		public function PxMouseEntity() {
			var mouseCollider : PxBoxColliderComponent = new PxBoxColliderComponent( 1, 1, false );
			mouseCollider.collisionLayer = 1 << 16;
			mouseCollider.collisionLayerMask = 0;
			addComponent( mouseCollider );
		}
		
		/**
		 * Updates the entity. Sets the position to the mouse position.
		 * @param	pDT	Time step.
		 */
		override public function update( pDT : Number ) : void {
			transform.setPosition( scene.inputSystem.mouseX, scene.inputSystem.mouseY );
			
			super.update( pDT );
		}
	
	}

}