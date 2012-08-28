package examples.replay {
	import pixelizer.PxInputSystem;
	import pixelizer.Pixelizer;
	import pixelizer.prefabs.gui.PxTextFieldEntity;
	import pixelizer.PxScene;
	
	/**
	 * ...
	 * @author Johan Peitz
	 */
	public class ReplayExampleScene extends PxScene {

		private var _currentEntity : ReplayEntity;
		
		public function ReplayExampleScene() {
			var text : PxTextFieldEntity = new PxTextFieldEntity( "Arrows to move box. SPACE to create new box." );
			text.textField.alignment = Pixelizer.CENTER;
			text.textField.width = 320;
			text.transform.position.y = 10;
			addEntity( text );

			spawnEntity();
		}
		
		private function spawnEntity() : void {
			if ( _currentEntity != null ) {
				_currentEntity.replay();
			}
			_currentEntity = new ReplayEntity( );
			addEntity( _currentEntity );
		}
		
		override public function update( pDT : Number ) : void {
			if ( inputSystem.isPressed( PxInputSystem.KEY_SPACE ) ) {
				spawnEntity();
			}
			
			if ( inputSystem.isPressed( PxInputSystem.KEY_ESC ) ) {
				engine.popScene();
			}
			
			
			super.update( pDT );
		}

	
	}

}