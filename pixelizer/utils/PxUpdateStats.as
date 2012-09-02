package pixelizer.utils {
	import pixelizer.systems.PxSystemStats;
	
	/**
	 * Holder class for info about the latest logic update.
	 * @author Johan Peitz
	 */
	public class PxUpdateStats extends PxSystemStats {
		/**
		 * Number of entities updated during logic update.
		 */
		public var entitiesUpdated : int;
		
		/**
		 * Resets data making it ready for the next update.
		 */
		override public function reset() : void {
			entitiesUpdated = 0;
		}
		
		override public function toString() : String {
			return "Entities: " + entitiesUpdated;
		}
	
	}

}