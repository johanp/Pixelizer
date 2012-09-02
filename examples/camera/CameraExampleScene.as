package examples.camera {
	import flash.geom.Point;
	import pixelizer.prefabs.gui.PxTextFieldEntity;
	import pixelizer.PxEntity;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.Pixelizer;
	import pixelizer.PxInputSystem;
	import pixelizer.PxScene;
	import pixelizer.utils.PxImageUtil;
	import pixelizer.utils.PxMath;
	
	/**
	 * ...
	 * @author Johan Peitz
	 */
	public class CameraExampleScene extends PxScene {
		
		public function CameraExampleScene() {
			background = false;
			
			addSystem( new BlurSystem( this, 2000 ) );
			
			for ( var i : int = 0; i < 1000; i++ ) {
				var z : int = 1 + i / 100;
				var e : PxEntity = new PxEntity( 10 * PxMath.randomInt( -16, 48 ), 10 * PxMath.randomInt( -12, 36 ) );
				e.addComponent( new PxBlitRenderComponent( PxImageUtil.createRect( 2 * z, 2 * z, 0xFFFFFF - 0x111111 * z ) ) );
				
				// set scrollFactor to decide how much of the camera movement that actually is used when positioning the entity
				e.transform.scrollFactorX = e.transform.scrollFactorY = z / 5;
				addEntity( e );
			}
		
			
			var textEntity : PxTextFieldEntity = new PxTextFieldEntity( "Move mouse to see parallax effect.", Pixelizer.COLOR_GREEN );
			textEntity.textField.outline = true;
			textEntity.transform.setPosition( 160, 120 );
			addEntity( textEntity );
			
			// TODO: toggle tracking / manual
			// TOOD: bounds
			
		}
		
		override public function dispose() : void {
			super.dispose();
		}
		
		override public function update( pDT : Number ) : void {
			
			camera.lookAt( new Point( _inputSystem.mouseX, _inputSystem.mouseY ) );
			
			if ( inputSystem.isPressed( PxInputSystem.KEY_ESC ) ) {
				engine.popScene();
			}
			
			super.update( pDT );
		}
	
	}

}