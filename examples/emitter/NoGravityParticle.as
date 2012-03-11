package examples.emitter {
	import pixelizer.components.PxBodyComponent;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.Pixelizer;
	import pixelizer.PxEntity;
	import pixelizer.utils.PxImageUtil;
	import pixelizer.utils.PxMath;
	
	public class NoGravityParticle extends PxEntity {
		private var _body : PxBodyComponent;
		
		public function NoGravityParticle() {
			var colors : Array = [ Pixelizer.COLOR_RED, Pixelizer.COLOR_GREEN, Pixelizer.COLOR_BLUE ];
			addComponent( new PxBlitRenderComponent( PxImageUtil.createCircle( 4, colors[ PxMath.randomInt( 0, 3 ) ] ) ) );
			_body = addComponent( new PxBodyComponent( 0 ) ) as PxBodyComponent;
		}
		
		override public function dispose() : void {
			_body = null;
			super.dispose();
		}
		
		override public function update( pDT : Number ) : void {
			// add some friction to speeds
			_body.velocity.x *= 0.85;
			_body.velocity.y *= 0.85;
			//
			super.update( pDT );
		}
	}

}