package pixelizer.components.render 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import pixelizer.utils.PxRenderStats;
	
	/**
	 * ...
	 * @author Johan Peitz
	 */
	public interface IPxRenderableComponent 
	{
		function render( pView : Rectangle, pBitmapData : BitmapData, pPosition : Point, pRotation : Number, pScaleX : Number, pScaleY : Number, pRenderStats : PxRenderStats ) : void ;
	}
	
}