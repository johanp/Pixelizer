package pixelizer.components.collision 
{
	import flash.display.BitmapData;
	import pixelizer.components.collision.PxBoxColliderComponent;
	import pixelizer.components.render.PxBlitRenderComponent;
	
	/**
	 * Renders a box collider. Add this component to an entity to have it's box collider render automatically.
	 * @author Johan Peitz
	 */
	public class PxBoxColliderRenderComponent extends PxBlitRenderComponent 
	{
		private var _boxColliderComp : PxBoxColliderComponent = null;

		/**
		 * Constructs a new PxBoxColliderRenderComponent.
		 */
		public function PxBoxColliderRenderComponent() : void {
			super();
			alpha = 0.5;
		}

		/**
		 * Disposes all resources used by component.
		 */
		override public function dispose() : void {
			_boxColliderComp = null;
			super.dispose();
		}

		/**
		 * Updates the component.
		 * @param	pDT	Time step in seconds.
		 */
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
			
			}

			// keep calm and carry on
			super.update( pDT );
		}
		
	}

}