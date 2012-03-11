package examples.emitter {
	import pixelizer.components.PxBodyComponent;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.Pixelizer;
	import pixelizer.PxEntity;
	import pixelizer.utils.PxImageUtil;
	import pixelizer.utils.PxMath;
	
	public class GravityParticle extends PxEntity {
		private var _body : PxBodyComponent;
		private var _roundsPerSecond : Number;
		
		public function GravityParticle() {
			var colors : Array = [ Pixelizer.COLOR_RED, Pixelizer.COLOR_GREEN, Pixelizer.COLOR_BLUE ];
			addComponent( new PxBlitRenderComponent( PxImageUtil.createRect( 8, 8, colors[ PxMath.randomInt( 0, 3 ) ] ) ) );
			_body = addComponent( new PxBodyComponent( 1 ) ) as PxBodyComponent;
			_roundsPerSecond = PxMath.TWO_PI * PxMath.randomNumber( -10, 10 );
		}
		
		override public function dispose() : void {
			_body = null;
			super.dispose();
		}
		
		override public function update( pDT : Number ) : void {
			// add some friction to speeds
			_body.velocity.x *= 0.9;
			
			transform.rotation += pDT * _roundsPerSecond;
			
			super.update( pDT );
		}
	}

}