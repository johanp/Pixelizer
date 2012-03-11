package examples.platformer {
	import examples.assets.AssetFactory;
	import pixelizer.components.render.PxTextFieldComponent;
	import pixelizer.Pixelizer;
	import pixelizer.prefabs.gui.PxTextFieldEntity;
	import pixelizer.PxInput;
	import pixelizer.PxScene;
	import pixelizer.render.PxAnimation;
	import pixelizer.render.PxBlitRenderer;
	import pixelizer.render.PxSpriteSheet;
	
	public class PlatformerTitleScene extends PxScene {
		
		public function PlatformerTitleScene() {
			if ( PxSpriteSheet.fetch( "tiles" ) == null ) {
				PxSpriteSheet.store( "tiles", new PxSpriteSheet() ).addFramesFromBitmapData( AssetFactory.tiles, 16, 16 );
				PxSpriteSheet.store( "player", new PxSpriteSheet() ).addFramesFromBitmapData( AssetFactory.player, 16, 16, Pixelizer.H_FLIP );
				PxSpriteSheet.store( "pickups", new PxSpriteSheet() ).addFramesFromBitmapData( AssetFactory.pickups, 16, 16, Pixelizer.H_FLIP );
				
				// set up animations
				PxSpriteSheet.fetch( "player" ).addAnimation( new PxAnimation( "idle", [ 0 ] ) );
				PxSpriteSheet.fetch( "player" ).addAnimation( new PxAnimation( "walk", [ 1, 0 ], 10, PxAnimation.ANIM_LOOP ) );
				PxSpriteSheet.fetch( "player" ).addAnimation( new PxAnimation( "jump", [ 2 ] ) );
				PxSpriteSheet.fetch( "player" ).addAnimation( new PxAnimation( "die", [ 3, 4 ], 5, PxAnimation.ANIM_LOOP ) );
				
				PxSpriteSheet.fetch( "pickups" ).addAnimation( new PxAnimation( "good", [ 0, 0, 0, 0, 0, 1 ], 5, PxAnimation.ANIM_LOOP ) );
				PxSpriteSheet.fetch( "pickups" ).addAnimation( new PxAnimation( "bad", [ 2, 2, 2, 2, 2, 2, 3 ], 5, PxAnimation.ANIM_LOOP ) );
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