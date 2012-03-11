package examples.platformer {
	import pixelizer.components.PxBodyComponent;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.PxEntity;
	import pixelizer.utils.PxImageUtil;
	import pixelizer.utils.PxMath;
	
	/**
	 * ...
	 * @author Johan Peitz
	 */
	public class ExplosionParticle extends PxEntity {
		private var _body : PxBodyComponent;
		
		public function ExplosionParticle( pLifeTime : Number = 1, pColor : int = -1 ) {
			addComponent( new PxBlitRenderComponent( PxImageUtil.createRect( 4, 4, pColor ) ) );
			_body = addComponent( new PxBodyComponent( 0 ) ) as PxBodyComponent;
			
			var a : Number = Math.random() * PxMath.TWO_PI;
			var f : Number = 5 + Math.random() * 2;
			_body.velocity.x = f * PxMath.cos( a );
			_body.velocity.y = f * PxMath.sin( a );
			
			// don't live longer than this!
			destroyIn( pLifeTime );
		}
		
		override public function dispose() : void {
			_body = null;
			super.dispose();
		}
		
		public function setVelocity( pVX : Number, pVY : Number ) : void {
			_body.velocity.x = pVX;
			_body.velocity.y = pVY;
		}
		
		override public function update( pDT : Number ) : void {
			_body.velocity.x *= 0.95;
			_body.velocity.y *= 0.95;
			
			super.update( pDT );
		}
	}

}