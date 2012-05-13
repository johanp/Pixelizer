package examples.platformer {
	import pixelizer.components.render.PxTextFieldComponent;
	import pixelizer.Pixelizer;
	import pixelizer.prefabs.gui.PxTextFieldEntity;
	import pixelizer.PxInput;
	import pixelizer.PxScene;
	import pixelizer.render.PxAnimation;
	import pixelizer.render.PxBlitRenderer;
	import pixelizer.render.PxSpriteSheet;
	import pixelizer.utils.PxRepository;
	
	public class PlatformerTitleScene extends PxScene {

		[Embed( source="../assets/tiles.png" )]
		private static var tilesBitmapCls : Class;
		
		[Embed( source="../assets/player.png" )]
		private static var playerBitmapCls : Class;
		
		[Embed( source="../assets/pickups.png" )]
		private static var pickupsBitmapCls : Class;
		
		public function PlatformerTitleScene() {
			if ( PxRepository.fetch( "tiles" ) == null ) {
				PxRepository.store( "tiles", new PxSpriteSheet() ).addFramesFromBitmapData( new tilesBitmapCls().bitmapData, 16, 16 );
				PxRepository.store( "player", new PxSpriteSheet() ).addFramesFromBitmapData( new playerBitmapCls().bitmapData, 16, 16, Pixelizer.H_FLIP );
				PxRepository.store( "pickups", new PxSpriteSheet() ).addFramesFromBitmapData( new pickupsBitmapCls().bitmapData, 16, 16, Pixelizer.H_FLIP );
				
				// set up animations
				PxRepository.fetch( "player" ).addAnimation( new PxAnimation( "idle", [ 0 ] ) );
				PxRepository.fetch( "player" ).addAnimation( new PxAnimation( "walk", [ 1, 0 ], 10, PxAnimation.ANIM_LOOP ) );
				PxRepository.fetch( "player" ).addAnimation( new PxAnimation( "jump", [ 2 ] ) );
				PxRepository.fetch( "player" ).addAnimation( new PxAnimation( "die", [ 3, 4 ], 5, PxAnimation.ANIM_LOOP ) );
				
				PxRepository.fetch( "pickups" ).addAnimation( new PxAnimation( "good", [ 0, 0, 0, 0, 0, 1 ], 5, PxAnimation.ANIM_LOOP ) );
				PxRepository.fetch( "pickups" ).addAnimation( new PxAnimation( "bad", [ 2, 2, 2, 2, 2, 2, 3 ], 5, PxAnimation.ANIM_LOOP ) );
			}
			
			// background color of scene
			backgroundColor = Pixelizer.COLOR_WHITE;
			
			var title : PxTextFieldEntity = new PxTextFieldEntity( "ACTS OF KINDNESS", Pixelizer.COLOR_WHITE );
			title.textField.width = 80;
			title.textField.alignment = Pixelizer.CENTER;
			title.textField.outline = true;
			title.textField.outlineColor = Pixelizer.COLOR_RED;
			title.textField.padding = 3;
			title.textField.background = true;
			title.textField.backgroundColor = Pixelizer.COLOR_BLUE;
			title.transform.scale = 4;
			title.transform.setPosition( -3 * 4, 50 );
			addEntity( title );
			
			var message : PxTextFieldEntity = new PxTextFieldEntity( "ARROWS TO MOVE AND JUMP\n\nPRESS SPACE TO START", Pixelizer.COLOR_BLACK );
			message.textField.width = 320;
			message.textField.alignment = Pixelizer.CENTER;
			message.transform.position.y = 150;
			addEntity( message );
		
		}
		
		override public function update( pDT : Number ) : void {
			super.update( pDT );
			
			if ( PxInput.isPressed( PxInput.KEY_SPACE ) ) {
				engine.pushScene( new PlatformerScene() );
			}
			
			if ( PxInput.isPressed( PxInput.KEY_ESC ) ) {
				engine.popScene();
			}
		
		}
	
	}

}