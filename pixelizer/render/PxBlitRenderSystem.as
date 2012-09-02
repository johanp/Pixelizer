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
	import pixelizer.systems.PxSystem;
	import pixelizer.utils.PxMath;
	import pixelizer.utils.PxRenderStats;
	
	/**
	 * Rendering system that uses blitting to position bitmap data onto a destination bitmap.
	 * @author Johan Peitz
	 */
	public class PxBlitRenderSystem extends PxSystem {
		private var _surface : Bitmap;
		
		private var _view : Rectangle;
		
		private var _renderStats : PxRenderStats;
		
		/**
		 * Creates a new blit rendering system.
		 * @param	pScene	Scene to which the system belongs.
		 * @param	pPriority	Priority towards other systems.
		 * @param	pTransparent	Whether the render surface should be transparent or not.
		 */
		public function PxBlitRenderSystem( pScene : PxScene, pPriority : int = 0, pTransparent : Boolean = false ) {
			super( pScene, pPriority );
			
			_surface = new Bitmap( new BitmapData( Pixelizer.engine.width, Pixelizer.engine.height, pTransparent, 0xFFFFFF ) );
			_surface.scaleX = _surface.scaleY = Pixelizer.engine.scale;
			_surface.smoothing = false;
			
			_stats = _renderStats = new PxRenderStats();
			
			_view = new Rectangle();
		}
		
		/**
		 * Clears all used resources.
		 */
		override public function dispose() : void {
			if ( _surface.parent != null ) {
				_surface.parent.removeChild( _surface );
			}
			_surface.bitmapData.dispose();
			_surface = null;
			_view = null;
			_renderStats = null;
			
			super.dispose();
		}
		
		/**
		 * Invoked before rendering starts. Clears stats and locks bitmap.
		 */
		override public function beforeRender() : void {
			_stats.reset();
			_renderStats.renderTime = getTimer();
			_surface.bitmapData.lock();
		}
		
		/**
		 * Renders a scene. The renderer will go through the entity tree in order and render
		 * any PxBlitRenderComponents found.
		 * @param	pScene	Scene to render.
		 */
		override public function render() : void {
			// clear bitmap data
			if ( scene.background ) {
				_surface.bitmapData.fillRect( _surface.bitmapData.rect, scene.backgroundColor );
			}
			
			if ( scene.camera != null ) {
				_view.width = scene.camera.view.width;
				_view.height = scene.camera.view.height;
				
				renderComponents( scene.entityRoot, scene, scene.entityRoot.transform.position, scene.entityRoot.transform.rotation, scene.entityRoot.transform.scaleX, scene.entityRoot.transform.scaleY );
			}
		}
		
		private function renderComponents( pEntity : PxEntity, pScene : PxScene, pPosition : Point, pRotation : Number, pScaleX : Number, pScaleY : Number ) : void {
			for each ( var e : PxEntity in pEntity.entities ) {
				var pos : Point = Pixelizer.pointPool.fetch();
				// adjust to scroll factor
				_view.x = pScene.camera.view.x * e.transform.scrollFactorX;
				_view.y = pScene.camera.view.y * e.transform.scrollFactorY;
				
				if ( pRotation != 0 ) {
					var d : Number = Math.sqrt( e.transform.position.x * e.transform.position.x + e.transform.position.y * e.transform.position.y );
					var a : Number = Math.atan2( e.transform.position.y, e.transform.position.x ) + pRotation;
					pos.x = pPosition.x + d * Math.cos( a ) * pScaleX;
					pos.y = pPosition.y + d * Math.sin( a ) * pScaleY;
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
		override public function afterRender() : void {
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
	
	}
}
