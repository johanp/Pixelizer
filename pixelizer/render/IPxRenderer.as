package pixelizer.render {
	import flash.display.DisplayObject;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.PxScene;
	import pixelizer.utils.PxRenderStats;
	
	/**
	 * Defines the behaviour of a Pixelizer renderer.
	 * @author Johan Peitz
	 */
	public interface IPxRenderer {
		/**
		 * Renders a scene.
		 * @param	pScene	Scene to render.
		 */
		function render( pScene : PxScene, pComponentToRender : Class = null ) : void;
		
		/**
		 * Returns the display object for the renderer. The display object contains the visible result of each render pass.
		 */
		function get displayObject() : DisplayObject;
		
		/**
		 * Returns the stats of the render pass.
		 */
		function get renderStats() : PxRenderStats;
		
		/**
		 * Invoked before rendering starts.
		 */
		function beforeRendering() : void;
		/**
		 * Invoked after all rendering is done.
		 */
		function afterRendering() : void;
	}

}