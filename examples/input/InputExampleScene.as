package examples.input {
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.Pixelizer;
	import pixelizer.prefabs.gui.PxMouseEntity;
	import pixelizer.prefabs.gui.PxTextFieldEntity;
	import pixelizer.PxInput;
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
			var keyCodes : Array = [ PxInput.KEY_UP, PxInput.KEY_DOWN, PxInput.KEY_LEFT, PxInput.KEY_RIGHT ];
			var keyNames : Array = [ "UP ARROW", "DOWN ARROW", "LEFT ARROW", "RIGHT ARROW" ];
			var keyString : String = "Press some keys:\n\n";
			for ( var i : int = 0; i < 4; i++ ) {
				keyString += keyNames[ i ] + ": ";
				if ( PxInput.isDown( keyCodes[ i ] ) )
					keyString += " DOWN ";
				if ( PxInput.isUp( keyCodes[ i ] ) )
					keyString += " UP ";
				if ( PxInput.isPressed( keyCodes[ i ] ) )
					keyString += " PRESSED ";
				if ( PxInput.isReleased( keyCodes[ i ] ) )
					keyString += " RELEASED ";
				keyString += "\n";
			}
			_keys.textField.text = keyString;
			
			var mouseString : String = "Use the mouse:\n\n";
			mouseString += "position: " + PxInput.mousePosition + "\n";
			mouseString += "button: ";
			if ( PxInput.mouseDown )
				mouseString += " DOWN ";
			if ( !PxInput.mouseDown )
				mouseString += " UP ";
			if ( PxInput.mousePressed )
				mouseString += " PRESSED ";
			if ( PxInput.mouseReleased )
				mouseString += " RELEASED ";
			mouseString += "\nwheel: " + PxInput.mouseDelta;
			
			_mouse.textField.text = mouseString;
			
			if ( PxInput.isPressed( PxInput.KEY_ESC ) ) {
				engine.popScene();
			}
			
			super.update( pDT );
		}
	
	}

}