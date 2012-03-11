package pixelizer.utils {
	
	/**
	 * Holder for stats collected during the rendering.
	 * @author Johan Peitz
	 */
	public class PxRenderStats {
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
		public function reset() : void {
			renderedObjects = 0;
			totalObjects = 0;
			renderTime = 0;
		}
	
	}
}