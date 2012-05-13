package examples.text {
	import pixelizer.components.PxTransformComponent;
	import pixelizer.components.render.PxTextFieldComponent;
	import pixelizer.Pixelizer;
	import pixelizer.prefabs.gui.PxTextFieldEntity;
	import pixelizer.PxEntity;
	import pixelizer.PxInput;
	import pixelizer.PxScene;
	import pixelizer.render.PxBitmapFont;
	
	public class TextExampleScene extends PxScene {
		
		[Embed( source="../assets/round_font.png" )]
		private static var roundFontCls : Class;

		private var _fieldCount : int = 0;
		
		
		
		public function TextExampleScene() {
			// bg color of scene
			backgroundColor = Pixelizer.COLOR_WHITE;
			
			var textEntity : PxTextFieldEntity;
			
			// plain text
			textEntity = new PxTextFieldEntity( "A basic text field." );
			addTextEntity( textEntity );
			
			// text with background
			textEntity = new PxTextFieldEntity( "This text field has background set to true.", Pixelizer.COLOR_BLACK );
			textEntity.textField.background = true;
			textEntity.textField.backgroundColor = Pixelizer.COLOR_RED;
			addTextEntity( textEntity );
			
			// text with background and padding
			textEntity = new PxTextFieldEntity( "Text fields can also be padded,", Pixelizer.COLOR_BLACK );
			textEntity.textField.background = true;
			textEntity.textField.backgroundColor = Pixelizer.COLOR_GREEN;
			textEntity.textField.padding = 5;
			addTextEntity( textEntity );
			
			// shadowed text
			textEntity = new PxTextFieldEntity( "and have a dramatic shadow.", Pixelizer.COLOR_LIGHT_GRAY );
			textEntity.textField.shadow = true;
			textEntity.textField.shadowColor = Pixelizer.COLOR_BLUE;
			addTextEntity( textEntity );
			
			// aligned text
			textEntity = new PxTextFieldEntity( "Align text to the left,", Pixelizer.COLOR_RED );
			textEntity.textField.width = 200;
			textEntity.textField.alignment = Pixelizer.LEFT;
			textEntity.textField.padding = 1;
			textEntity.textField.background = true;
			textEntity.textField.backgroundColor = Pixelizer.COLOR_BLACK;
			addTextEntity( textEntity );
			
			textEntity = new PxTextFieldEntity( "to the right,", Pixelizer.COLOR_GREEN );
			textEntity.textField.width = 200;
			textEntity.textField.alignment = Pixelizer.RIGHT;
			textEntity.textField.padding = 1;
			textEntity.textField.background = true;
			textEntity.textField.backgroundColor = Pixelizer.COLOR_BLACK;
			addTextEntity( textEntity );
			
			textEntity = new PxTextFieldEntity( "OR CENTER IT!", Pixelizer.COLOR_BLUE );
			textEntity.textField.width = 200;
			textEntity.textField.alignment = Pixelizer.CENTER;
			textEntity.textField.padding = 1;
			textEntity.textField.background = true;
			textEntity.textField.backgroundColor = Pixelizer.COLOR_BLACK;
			addTextEntity( textEntity );
			
			// outline
			textEntity = new PxTextFieldEntity( "Maybe an outline for that special occasion?", Pixelizer.COLOR_WHITE );
			textEntity.textField.outline = true;
			textEntity.textField.outlineColor = Pixelizer.COLOR_BLACK;
			addTextEntity( textEntity );
			
			// text with other font
			var letters : String = " !\"#$%&'()*+,-./" + "0123456789:;<=>?" + "@ABCDEFGHIJKLMNO" + "PQRSTUVWXYZ[}]^_" + "'abcdefghijklmno" + "pqrstuvwxyz{|}~\\";
			var font : PxBitmapFont = new PxBitmapFont( new roundFontCls().bitmapData, letters );
			textEntity = new PxTextFieldEntity( "OH! A different font! Very fancy.", Pixelizer.COLOR_BLUE );
			textEntity.textField.font = font;
			textEntity.textField.shadow = true;
			textEntity.textField.shadowColor = Pixelizer.COLOR_RED;
			addTextEntity( textEntity );
			
			// multi line
			textEntity = new PxTextFieldEntity( "If you try to put a lot of text into a text field with a limited width, you can break it into multiple lines.", Pixelizer.COLOR_BLACK );
			textEntity.textField.width = 100;
			textEntity.textField.multiLine = true;
			addTextEntity( textEntity );
		
		}
		
		private function addTextEntity( pEntity : PxEntity ) : void {
			
			pEntity.transform.position.x = 100;
			pEntity.transform.position.y = 10 + _fieldCount * 20;
			addEntity( pEntity );
			
			_fieldCount++;
		}
		
		override public function update( pDT : Number ) : void {
			super.update( pDT );
			
			if ( PxInput.isPressed( PxInput.KEY_ESC ) ) {
				engine.popScene();
			}
		}
	
	}

}