package pixelizer.utils {
	
	/**
	 * Holder class for info about the latest logic update.
	 * @author Johan Peitz
	 */
	public class PxLogicStats {
		/**
		 * Current frame rate.
		 */
		public var fps : int;
		/**
		 * Time spent doing logic.
		 */
		public var logicTime : int;
		
		/**
		 * Number of entities updated during logic update.
		 */
		public var entitiesUpdated : int;
		
		/**
		 * Minimum amount of memory used in mega bytes.
		 */
		public var minMemory : int = -1;
		/**
		 * Maximum amount of memory used in mega bytes.
		 */
		public var maxMemory : int = -1;
		/**
		 * Current amount of memory used in mega bytes.
		 */
		public var currentMemory : int = -1;
		
		/**
		 * Resets data making it ready for the next update.
		 */
		public function reset() : void {
			entitiesUpdated = 0;
		}
	
	}

}