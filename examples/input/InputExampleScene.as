package examples.input {
	import pixelizer.PxInputSystem;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.Pixelizer;
	import pixelizer.prefabs.gui.PxMouseEntity;
	import pixelizer.prefabs.gui.PxTextFieldEntity;
	import pixelizer.PxScene;
	import pixelizer.utils.PxImageUtil;
	
	/**
	 * ...
	 * @author Johan Peitz
	 */
	public class InputExampleScene extends PxScene {
		
		private var _keys : PxTextFieldEntity;
		private var _mouse : PxTextFieldEntity;
		
		public function InputExampleScene() {
			_keys = new PxTextFieldEntity();
			_keys.transform.setPosition( 100, 20 );
			addEntity( _keys );
			
			_mouse = new PxTextFieldEntity();
			_mouse.transform.setPosition( 100, 100 );
			addEntity( _mouse );
			
			var mouseEnt : PxMouseEntity = new PxMouseEntity();
			mouseEnt.addComponent( new PxBlitRenderComponent( PxImageUtil.createRect( 3, 3, Pixelizer.COLOR_RED ) ) );
			addEntity( mouseEnt );
		}
		
		override public function dispose() : void {
			_keys = null;
			_mouse = null;
			super.dispose();
		}
		
		override public function update( pDT : Number ) : void {
			var keyCodes : Array = [ PxInputSystem.KEY_UP, PxInputSystem.KEY_DOWN, PxInputSystem.KEY_LEFT, PxInputSystem.KEY_RIGHT ];
			var keyNames : Array = [ "UP ARROW", "DOWN ARROW", "LEFT ARROW", "RIGHT ARROW" ];
			var keyString : String = "Press some keys:\n\n";
			for ( var i : int = 0; i < 4; i++ ) {
				keyString += keyNames[ i ] + ": ";
				if ( inputSystem.isDown( keyCodes[ i ] ) )
					keyString += " DOWN ";
				if ( inputSystem.isUp( keyCodes[ i ] ) )
					keyString += " UP ";
				if ( inputSystem.isPressed( keyCodes[ i ] ) )
					keyString += " PRESSED ";
				if ( inputSystem.isReleased( keyCodes[ i ] ) )
					keyString += " RELEASED ";
				keyString += "\n";
			}
			_keys.textField.text = keyString;
			
			var mouseString : String = "Use the mouse:\n\n";
			mouseString += "position: " + inputSystem.mousePosition + "\n";
			mouseString += "button: ";
			if ( inputSystem.mouseDown )
				mouseString += " DOWN ";
			if ( inputSystem.mouseUp )
				mouseString += " UP ";
			if ( inputSystem.mousePressed )
				mouseString += " PRESSED ";
			if ( inputSystem.mouseReleased )
				mouseString += " RELEASED ";
			mouseString += "\nwheel: " + inputSystem.mouseDelta;
			
			_mouse.textField.text = mouseString;
			
			if ( inputSystem.isPressed( PxInputSystem.KEY_ESC ) ) {
				engine.popScene();
			}
			
			super.update( pDT );
		}
	
	}

}