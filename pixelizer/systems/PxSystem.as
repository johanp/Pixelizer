package pixelizer.systems {
	import pixelizer.components.PxComponent;
	import pixelizer.PxScene;
	
	/**
	 * ...
	 * @author Johan Peitz
	 */
	public class PxSystem {
		
		private var _priority : int;
		public var scene : PxScene;
		
		public function PxSystem( pScene : PxScene, pPriority : int = 0 ) {
			scene = pScene;
			_priority = pPriority;
		}
		
		public function dispose() : void {
			scene = null;
		}
		
		public function update( pDT : Number ) : void {
		
		}
		
		static public function sortOnPriority( pSystemA : PxSystem, pSystemB : PxSystem ) : int {
			return pSystemA.priority - pSystemB.priority;
		}
		
		public function get priority() : int {
			return _priority;
		}
	}

}