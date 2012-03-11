package pixelizer.components {
	
	import pixelizer.PxEntity;
	import pixelizer.PxScene;
	
	/**
	 * Base class for all components.
	 * @author Johan Peitz
	 */
	public class PxComponent {
		/**
		 * Entity which this component is added to.
		 */
		public var entity : PxEntity;
		/**
		 * Update priority for this component.
		 */
		public var priority : int = 0;
		
		/**
		 * Clears all resources used by this component.
		 */
		public function dispose() : void {
			entity = null;
		}
		
		/**
		 * Invoked when added to an entity.
		 * @param	pEntity	Entity added to.
		 */
		public function onAddedToEntity( pEntity : PxEntity ) : void {
			entity = pEntity;
		}
		
		/**
		 * Invoked when removed from an entity.
		 */
		public function onRemovedFromEntity() : void {
			entity = null;
		}
		
		/**
		 * Invoked when the entity the component belongs to is added to a scene.
		 * @param	pScene	Scene the entity was added to.
		 */
		public function onEntityAddedToScene( pScene : PxScene ) : void {
		}
		
		/**
		 * Invoked when the entity the component belongs to is removed from a scene.
		 */
		public function onEntityRemovedFromScene() : void {
		}
		
		/**
		 * Invoked regularly by the entity.
		 * @param	pDT	Time step.
		 */
		public function update( pDT : Number ) : void {
		}
	
	}
}