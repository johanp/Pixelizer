package pixelizer.prefabs.gui {
	import pixelizer.components.collision.PxBoxColliderComponent;
	import pixelizer.components.collision.PxBoxColliderRenderComponent;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.components.render.PxTextFieldComponent;
	import pixelizer.physics.PxCollisionData;
	import pixelizer.Pixelizer;
	import pixelizer.PxEntity;
	import pixelizer.PxInput;
	import pixelizer.render.PxBitmapFont;
	import pixelizer.utils.PxImageUtil;
	
	/**
	 * Contains a simple button which can be clicked. A PxMouseEntity must be on the scene in order for
	 * the clicking to work.
	 * @author Johan Peitz
	 */
	public class PxGUIButton extends PxEntity {
		private var _label : String;
		private var _onClickedFunction : Function;
		
		private var _textField : PxTextFieldComponent;
		private var _mouseIsOver : Boolean = false;
		
		/**
		 * Creates a new button with the specified label and callback.
		 * @param	pLabel	Initial text of button.
		 * @param	pOnClickedFunction	Function to call when button is clicked.
		 */
		public function PxGUIButton( pLabel : String, pOnClickedFunction : Function = null ) {
			_label = pLabel;
			_onClickedFunction = pOnClickedFunction;
			
			_textField = new PxTextFieldComponent();
			_textField.width = PxBitmapFont.fetch( "default" ).getTextWidth( pLabel );
			_textField.text = _label;
			_textField.padding = 4;
			_textField.background = true;
			_textField.backgroundColor = Pixelizer.COLOR_GRAY;
			_textField.update( 0 );
			addComponent( _textField );
			
			var collider : PxBoxColliderComponent = new PxBoxColliderComponent( _textField.bitmapData.width, _textField.bitmapData.height, false );
			collider.registerCallbacks( onMouseOver, null, onMouseOut );
			collider.collisionLayer = 1 << 15;
			collider.collisionLayerMask = 1 << 16;
			addComponent( collider );
		}
		
		/**
		 * Clears all resources used by button.
		 */
		override public function dispose() : void {
			_textField = null;
			_onClickedFunction = null;
			super.dispose();
		}
		
		/**
		 * Updates the entity.
		 * @param	pDT	Time step.
		 */
		override public function update( pDT : Number ) : void {
			if ( _mouseIsOver ) {
				if ( _onClickedFunction != null && PxInput.mousePressed ) {
					_onClickedFunction( this );
				}
			}
			super.update( pDT );
		}
		
		/**
		 * Set what text to show on the button.
		 * @param pLabel	Text to show.
		 */
		public function set label( pLabel : String ) : void {
			_label = pLabel;
			_textField.text = _label;
		}
		
		/**
		 * Returns current label.
		 */
		public function get label() : String {
			return _label;
		}
		
		protected function onMouseOver( pCollisionData : PxCollisionData ) : void {
			_mouseIsOver = true;
			_textField.backgroundColor = Pixelizer.COLOR_GREEN;
		}
		
		protected function onMouseOut( pCollisionData : PxCollisionData ) : void {
			_mouseIsOver = false;
			_textField.backgroundColor = Pixelizer.COLOR_GRAY;
		}
	
	}

}