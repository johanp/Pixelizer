package examples.gui {
	import pixelizer.PxInputSystem;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.Pixelizer;
	import pixelizer.prefabs.gui.PxGUIButton;
	import pixelizer.prefabs.gui.PxMouseEntity;
	import pixelizer.prefabs.gui.PxTextFieldEntity;
	import pixelizer.PxScene;
	import pixelizer.utils.PxImageUtil;
	import pixelizer.utils.PxLog;
	
	/**
	 * ...
	 * @author Johan Peitz
	 */
	public class GUIExampleScene extends PxScene {
		
		private var _button : PxGUIButton;
		private var _buttonClicks : int = 0;
		
		public function GUIExampleScene() {
			_button = new PxGUIButton( "Click me!", onButtonClicked );
			_button.transform.setPosition( 100, 100 );
			addEntity( _button );
			
			var mouseEnt : PxMouseEntity = new PxMouseEntity();
			mouseEnt.addComponent( new PxBlitRenderComponent( PxImageUtil.createRect( 3, 3, Pixelizer.COLOR_RED ) ) );
			addEntity( mouseEnt );
		
		}
		
		override public function dispose() : void {
			_button = null;
			super.dispose();
		}
		
		public function onButtonClicked( pBbutton : PxGUIButton ) : void {
			_buttonClicks++;
			_button.label = _buttonClicks + " clicks";
		}
		
		override public function update( pDT : Number ) : void {
			
			if ( inputSystem.isPressed( PxInputSystem.KEY_ESC ) ) {
				engine.popScene();
			}
			
			super.update( pDT );
		}
	
	}

}