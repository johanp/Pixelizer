package pixelizer.prefabs.logo {
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.PxEntity;
	import pixelizer.utils.PxImageUtil;
	
	/**
	 * Entity used in animating the Pixelizer logo. Displays a colored square.
	 * @author Johan Peitz
	 */
	public class PxLogoPixelEntity extends PxEntity {
		
		private var _x : Number;
		private var _y : Number;
		private var _z : Number;
		private var _3DFactor : Number;
		private var _rendComp : PxBlitRenderComponent;
		private var _fall : Boolean = false;
		private var _fallTimer : Number = 0;
		private var _vy : Number = 0;
		
		public function PxLogoPixelEntity( pX : int, pY : int, pZ : Number, pSize : int, pColor : int ) {
			super( pX, pY );
			
			_x = pX;
			_y = pY;
			_z = pZ;
			
			_3DFactor = 256;
			
			_rendComp = addComponent( new PxBlitRenderComponent( PxImageUtil.createRect( pSize, pSize, pColor ) ) ) as PxBlitRenderComponent;
			
			calcPseudo3DTransform();
		}
		
		override public function dispose() : void {
			_rendComp = null;
			super.dispose();
		}
		
		override public function update( pDT : Number ) : void {
			if ( _z < _3DFactor ) {
				_z += 360 * pDT;
			}
			if ( _z > _3DFactor ) {
				_z = _3DFactor;
			}
			
			if ( _fallTimer > 0 ) {
				_fallTimer -= pDT;
				if ( _fallTimer <= 0 ) {
					_fall = true;
					_vy = -90 - Math.random() * 30;
				}
			}
			if ( _fall ) {
				_vy += 720 * pDT;
			}
			
			_y += _vy * pDT;
			
			calcPseudo3DTransform();
			super.update( pDT );
		}
		
		private function calcPseudo3DTransform() : void {
			_rendComp.visible = ( _z > 0 );
			if ( _rendComp.visible ) {
				transform.position.x = ( _x * _3DFactor ) / _z;
				transform.position.y = ( _y * _3DFactor ) / _z;
				transform.scale = 1 * _3DFactor / _z;
			}
		}
		
		public function fallIn( pSeconds : Number ) : void {
			_fallTimer = pSeconds;
		}
	
	}

}