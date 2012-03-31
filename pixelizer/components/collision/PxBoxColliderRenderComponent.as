package pixelizer.components.collision 
{
	import flash.display.BitmapData;
	import pixelizer.components.collision.PxBoxColliderComponent;
	import pixelizer.components.render.PxBlitRenderComponent;
	
	/**
	 * ...
	 * @author Johan Peitz
	 */
	public class PxBoxColliderRenderComponent extends PxBlitRenderComponent 
	{
		private var _boxColliderComp : PxBoxColliderComponent = null;
		private var _renderComp : PxBlitRenderComponent = null;

		public function PxBoxColliderRenderComponent() : void {
			super();
			alpha = 0.5;
		}

		
		override public function dispose() : void {
			_boxColliderComp = null;
			super.dispose();
		}

		override public function update( pDT : Number ) : void {
			// get collider info
			if ( _boxColliderComp == null ) {
				_boxColliderComp = entity.getComponentByClass( PxBoxColliderComponent ) as PxBoxColliderComponent;
			}

			// use collider info
			if ( _boxColliderComp != null ) {
				if ( bitmapData != null ) {
					bitmapData.dispose();
				}
				bitmapData = new BitmapData( _boxColliderComp.collisionBox.halfWidth * 2, _boxColliderComp.collisionBox.halfHeight * 2, false, 0xFF00FF );
				
				/*
				if ( _renderComp == null ) {
					_renderComp = entity.getComponentByClass( PxBlitRenderComponent ) as PxBlitRenderComponent;
				}
				hotspot.x = _renderComp.hotspot.x;
				hotspot.y = _renderComp.hotspot.y;
				*/
			}

			// keep calm and carry on
			super.update( pDT );
		}
		
	}

}