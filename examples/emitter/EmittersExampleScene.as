package examples.emitter {
	import pixelizer.components.PxEmitterComponent;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.Pixelizer;
	import pixelizer.PxEntity;
	import pixelizer.PxInput;
	import pixelizer.PxScene;
	import pixelizer.utils.PxImageUtil;
	import pixelizer.utils.PxMath;
	
	public class EmittersExampleScene extends PxScene {
		
		public function EmittersExampleScene() {
			var emitterComp : PxEmitterComponent;
			var emitter : PxEntity;
			
			backgroundColor = Pixelizer.COLOR_WHITE;
			
			// type a
			emitterComp = new PxEmitterComponent( GravityParticle, this );
			emitterComp.setNumSimulEntities( -1 );
			emitterComp.setEmitDelayRange( 0, 0.3 );
			emitterComp.setEmitForceRange( 8, 12 );
			emitterComp.setEmitLifeRange( 0.7, 0.8 );
			emitterComp.setEmitAngleRange( -PxMath.PI * 3 / 4, -PxMath.PI * 1 / 4 );
			
			emitter = new PxEntity();
			emitter.addComponent( new PxBlitRenderComponent( PxImageUtil.createCircle( 8, Pixelizer.COLOR_GRAY ) ) );
			emitter.addComponent( emitterComp );
			emitter.transform.setPosition( 80, 120 );
			addEntity( emitter );
			
			// type b
			emitterComp = new PxEmitterComponent( NoGravityParticle, this );
			emitterComp.setNumSimulEntities( -1 );
			emitterComp.setEmitDelayRange( 0, 0 );
			emitterComp.setEmitForceRange( 10, 10 );
			emitterComp.setEmitLifeRange( 4, 4 );
			emitterComp.setEmitAngleRange( 0, PxMath.TWO_PI );
			
			emitter = new PxEntity();
			emitter.addComponent( new PxBlitRenderComponent( PxImageUtil.createCircle( 8, Pixelizer.COLOR_GRAY ) ) );
			emitter.addComponent( emitterComp );
			emitter.transform.setPosition( 240, 120 );
			addEntity( emitter );
		
		}
		
		override public function update( pDT : Number ) : void {
			super.update( pDT );
			
			if ( PxInput.isPressed( PxInput.KEY_ESC ) ) {
				engine.popScene();
			}
		}
	
	}

}