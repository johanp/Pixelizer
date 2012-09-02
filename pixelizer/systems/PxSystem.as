package pixelizer.systems {
	import pixelizer.components.PxComponent;
	import pixelizer.PxScene;
	
	/**
	 * ...
	 * @author Johan Peitz
	 */
	public class PxSystem {
		
		protected var _priority : int;
		protected var _stats : PxSystemStats;
		
		public var scene : PxScene;
		
		public function PxSystem( pScene : PxScene, pPriority : int = 0 ) {
			scene = pScene;
			_priority = pPriority;
		}
		
		public function dispose() : void {
			scene = null;
			_stats = null;
		}
		
		public function beforeUpdate( ) : void {
		
		}
		public function update( pDT : Number ) : void {
		
		}
		public function afterUpdate( ) : void {
		
		}
		public function beforeRender( ) : void {
		
		}
		public function render( ) : void {
		
		}
		public function afterRender( ) : void {
		
		}
		
		public function get priority() : int {
			return _priority;
		}
		
		public function get stats() : PxSystemStats {
			return _stats;
		}
		
		static public function sortOnPriority( pSystemA : PxSystem, pSystemB : PxSystem ) : int {
			return pSystemA.priority - pSystemB.priority;
		}
		
	}

}