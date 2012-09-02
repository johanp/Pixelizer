package pixelizer.utils {
	import pixelizer.systems.PxSystemStats;
	
	/**
	 * Holder class for info about the latest logic update.
	 * @author Johan Peitz
	 */
	public class PxLogicStats extends PxSystemStats{
		/**
		 * Current frame rate.
		 */
		public var fps : int;
		/**
		 * Time spent doing logic.
		 */
		public var logicTime : int;
		
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
			
		override public function toString() : String {
			var text : String = "";
			text += "FPS: " + fps + "\n";
			text += "Logic: " + logicTime + " ms" + "\n";
			text += "Memory: " + minMemory + "/" + currentMemory + "/" + maxMemory + " MB";
			return text;
		}
	}

}