package pixelizer.utils {
	import pixelizer.systems.PxSystemStats;
	
	/**
	 * Holder for stats collected during the rendering.
	 * @author Johan Peitz
	 */
	public class PxRenderStats extends PxSystemStats {
		/**
		 * Amount of objects actually rendered.
		 */
		public var renderedObjects : int = 0;
		/**
		 * Total amount of objects.
		 */
		public var totalObjects : int = 0;
		
		/**
		 * Render time in seconds.
		 */
		public var renderTime : int = 0;
		
		/**
		 * Resets the render stats before each run.
		 */
		override public function reset() : void {
			renderedObjects = 0;
			totalObjects = 0;
			renderTime = 0;
		}
		
		/**
		 * Returns stats as readable string.
		 * @return	Stats as readable string.
		 */
		override public function toString() : String {
			var s : String = "";
			s += "Render: " + renderTime + " ms" + "\n";
			s += "RendObjs: " + renderedObjects + "/" + totalObjects;
			return s;
		}
	
	}
}