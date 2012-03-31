package pixelizer.render {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import pixelizer.components.collision.PxColliderComponent;
	import pixelizer.components.PxComponent;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.Pixelizer;
	import pixelizer.PxEntity;
	import pixelizer.PxScene;
	import pixelizer.utils.PxMath;
	import pixelizer.utils.PxRenderStats;
	
	/**
	 * Pixelizer renderer that uses blitting to position bitmap data onto a destination bitmap.
	 * @author Johan Peitz
	 */
	public class PxBlitRenderer implements IPxRenderer {
		private var _surface : Bitmap;
		private var _renderStats : PxRenderStats;
		
		private var _view : Rectangle;
		
		/**
		 * Construcs a new blit renderer.
		 * @param	pWidth	Width of output bitmap.
		 * @param	pHeight	Height of output bitmap.
		 * @param	pScale	Scale of output bitmap.
		 */
		public function PxBlitRenderer( pWidth : int, pHeight : int, pScale : int = 1 ) {
			_surface = new Bitmap( new BitmapData( pWidth, pHeight, false, 0xFFFFFF ) );
			_surface.scaleX = _surface.scaleY = pScale;
			_surface.smoothing = false;
			
			_renderStats = new PxRenderStats();
			
			_view = new Rectangle();
		}
		
		/**
		 * Clears all used resources.
		 */
		public function dispose() : void {
			if ( _surface.parent != null ) {
				_surface.parent.removeChild( _surface );
			}
			_surface.bitmapData.dispose();
			_surface = null;
			_view = null;
		
		}
		
		/**
		 * Invoked before rendering starts.
		 */
		public function beforeRendering() : void {
			_renderStats.reset();
			_renderStats.renderTime = getTimer();
			_surface.bitmapData.lock();
		}
		
		/**
		 * Renders a scene. The renderer will go through the entity tree in order and render
		 * any PxBlitRenderComponents found.
		 * @param	pScene	Scene to render.
		 */
		public function render( pScene : PxScene ) : void {
			// clear bitmap data
			if ( pScene.background ) {
				_surface.bitmapData.fillRect( _surface.bitmapData.rect, pScene.backgroundColor );
			}
			
			if ( pScene.camera != null ) {
				_view.width = pScene.camera.view.width;
				_view.height = pScene.camera.view.height;
				
				renderComponents( pScene.entityRoot, pScene, pScene.entityRoot.transform.position, pScene.entityRoot.transform.rotation, pScene.entityRoot.transform.scaleX, pScene.entityRoot.transform.scaleY );
			}
		}
		
		private function renderComponents( pEntity : PxEntity, pScene : PxScene, pPosition : Point, pRotation : Number, pScaleX : Number, pScaleY : Number ) : void {
			_view.x = pScene.camera.view.x * pEntity.transform.scrollFactorX;
			_view.y = pScene.camera.view.y * pEntity.transform.scrollFactorY;
			
			for each ( var e : PxEntity in pEntity.entities ) {
				var pos : Point = Pixelizer.pointPool.fetch();
				if ( pRotation != 0 ) {
					// TODO: find faster versions of sqrt and atan2
					var d : Number = Math.sqrt( e.transform.position.x * e.transform.position.x + e.transform.position.y * e.transform.position.y );
					var a : Number = Math.atan2( e.transform.position.y, e.transform.position.x ) + pRotation;
					pos.x = pPosition.x + d * PxMath.cos( a ) * pScaleX;
					pos.y = pPosition.y + d * PxMath.sin( a ) * pScaleY;
				} else {
					pos.x = pPosition.x + e.transform.position.x * pScaleX;
					pos.y = pPosition.y + e.transform.position.y * pScaleY;
				}
				
				var renderableComponents : Vector.<PxComponent> = e.getComponentsByClass( PxBlitRenderComponent );
				for each ( var renderableComponent : PxBlitRenderComponent in renderableComponents ) {
					renderableComponent.render( _view, _surface.bitmapData, pos, pRotation + e.transform.rotation, pScaleX * e.transform.scaleX, pScaleY * e.transform.scaleY, _renderStats );
				}
				
				renderComponents( e, pScene, pos, pRotation + e.transform.rotation, pScaleX * e.transform.scaleX, pScaleY * e.transform.scaleY );
				Pixelizer.pointPool.recycle( pos );
			}
		}
		
		/**
		 * Invoked before when rendering is completed.
		 */
		public function afterRendering() : void {
			_surface.bitmapData.unlock();
			_renderStats.renderTime = getTimer() - _renderStats.renderTime;
		}
		
		/**
		 * Returns the display object for this renderer.
		 * @return Display object for this renderer.
		 */
		public function get displayObject() : DisplayObject {
			return _surface;
		}
		
		/**
		 * Returns the latest stats for the rendering.
		 * @return Stats of the latest rendering.
		 */
		public function get renderStats() : PxRenderStats {
			return _renderStats;
		}
	
	}
}
