package examples.sound {
	import flash.geom.Point;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.components.render.PxTextFieldComponent;
	import pixelizer.Pixelizer;
	import pixelizer.prefabs.gui.PxTextFieldEntity;
	import pixelizer.PxEntity;
	import pixelizer.PxInput;
	import pixelizer.PxScene;
	import pixelizer.sound.PxSoundManager;
	import pixelizer.utils.PxImageUtil;
	
	public class SoundExampleScene extends PxScene {
		[Embed( source="../assets/sheep.mp3" )]
		private static var sheepSoundCls : Class;
		
		public function SoundExampleScene() {
			
			// bg color of scene
			backgroundColor = Pixelizer.COLOR_WHITE;
			
			// change sound rules so the fit on screen
			PxSoundManager.panRange = new Point( 120, 40 );
			PxSoundManager.volumeRange = new Point( 80, 80 );
			
			var e : PxEntity;
			var text : PxTextFieldEntity;
			
			// show pan range
			e = addEntity( new PxEntity( 160, 120 ) );
			e.addComponent( new PxBlitRenderComponent( PxImageUtil.createRect( 2 * PxSoundManager.panRange.x, 240, Pixelizer.COLOR_GREEN ), new Point( PxSoundManager.panRange.x, 120 ) ) );
			
			text = addEntity( new PxTextFieldEntity( " left                                       center                                       right", Pixelizer.COLOR_BLACK ) ) as PxTextFieldEntity;
			text.textField.alignment = Pixelizer.CENTER;
			text.textField.width = 320;
			text.transform.position.y = 220;
			
			// show volume range 
			e = addEntity( new PxEntity( 160, 120 ) );
			e.addComponent( new PxBlitRenderComponent( PxImageUtil.createCircle( PxSoundManager.volumeRange.x, Pixelizer.COLOR_RED ), new Point( PxSoundManager.volumeRange.x, PxSoundManager.volumeRange.x ) ) );
			
			text = addEntity( new PxTextFieldEntity( "min                                     max volume                                     min", Pixelizer.COLOR_BLACK ) ) as PxTextFieldEntity;
			text.textField.alignment = Pixelizer.CENTER;
			text.textField.width = 320;
			text.transform.position.y = 160;
			
			// show info
			text = addEntity( new PxTextFieldEntity( "Turn your speakers on! Click to make more sounds. M toggles mute on/off.", Pixelizer.COLOR_BLACK ) ) as PxTextFieldEntity;
			text.textField.alignment = Pixelizer.CENTER;
			text.textField.width = 320;
			text.transform.position.y = 10;
			
			addEntity( new SoundMaker() );
		}
		
		override public function update( pDT : Number ) : void {
			if ( PxInput.mousePressed ) {
				addEntity( new VisibleSoundEntity( new sheepSoundCls(), PxInput.mousePosition ) );
					// could also have been
					// PxSoundManager.play( new _sheepSound(), PxInput.mousePosition );
					// but then we wouldn't see it
			}
			
			if ( PxInput.isPressed( PxInput.KEY_M ) ) {
				if ( PxSoundManager.isMuted() ) {
					PxSoundManager.unmute();
				} else {
					PxSoundManager.mute();
				}
			}
			
			super.update( pDT );
			
			if ( PxInput.isPressed( PxInput.KEY_ESC ) ) {
				engine.popScene();
			}
		
		}
	
	}

}

