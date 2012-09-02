package pixelizer.systems {
	import pixelizer.components.PxComponent;
	import pixelizer.PxScene;
	
	/**
	 * A system lives in a scene and is updated every frame.
	 * It can do pretty much anything from handling collisions to rendering stuff.
	 * Change the priority on each system to decide in which order they update. There are two main areas, update and render.
	 * Update is called every frame, and render when time permits.
	 * @author Johan Peitz
	 */
	public class PxSystem {
		
		protected var _priority : int;
		protected var _stats : PxSystemStats;
		
		/**
		 * The scene on which the system operates.
		 */
		public var scene : PxScene;
		
		
		/**
		 * Creates a new system.
		 * @param	pScene	The scene which the system should operate on.
		 * @param	pPriority	When to update in relation to any other systems.
		 */
		public function PxSystem( pScene : PxScene, pPriority : int = 0 ) {
			scene = pScene;
			_priority = pPriority;
		}
		
		/**
		 * Clears up any resources used by the system.
		 */
		public function dispose() : void {
			scene = null;
			_stats = null;
		}
		
		/**
		 * Invoked before this and any other systems are updated.
		 */
		public function beforeUpdate( ) : void {
		
		}
		/**
		 * Invoked once every frame.
		 * @param	pDT	Time to spend in this frame.
		 */
		public function update( pDT : Number ) : void {
		
		}
		/**
		 * Invoked after this and any other systems are updated.
		 */
		public function afterUpdate( ) : void {
		
		}
		
		/**
		 * Invoked before this and any other systems are rendered.
		 */		
		public function beforeRender( ) : void {
		
		}
		/**
		 * Invoked when it is rendering time.
		 */
		public function render( ) : void {
		
		}
		/**
		 * Invoked after this and any other systems are rendered.
		 */		
		public function afterRender( ) : void {
		
		}
		
		/**
		 * Returns the priority set to this system.
		 */
		public function get priority() : int {
			return _priority;
		}
		
		/**
		 * Returns any stats generated.
		 */
		public function get stats() : PxSystemStats {
			return _stats;
		}
		
		/**
		 * Helper function to sort systems by priority. Used internally.
		 * @param	pSystemA
		 * @param	pSystemB
		 * @return
		 */
		static public function sortOnPriority( pSystemA : PxSystem, pSystemB : PxSystem ) : int {
			return pSystemA.priority - pSystemB.priority;
		}
		
	}

}