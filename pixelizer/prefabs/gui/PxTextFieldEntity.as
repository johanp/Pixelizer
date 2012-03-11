package pixelizer.prefabs.gui {
	import pixelizer.components.render.PxTextFieldComponent;
	import pixelizer.PxEntity;
	
	/**
	 * An entity containing a text field component only.
	 * Useful for quickly displaying text.
	 * @author Johan Peitz
	 */
	public class PxTextFieldEntity extends PxEntity {
		public var textField : PxTextFieldComponent;
		
		/**
		 * Creates a new entity with a text field component.
		 * @param	pText	Initial text to show.
		 * @param	pColor	Color of text.
		 */
		public function PxTextFieldEntity( pText : String = "", pColor : int = 0x0 ) {
			super();
			
			textField = addComponent( new PxTextFieldComponent() ) as PxTextFieldComponent;
			textField.color = pColor;
			textField.text = pText;
		}
		
		/**
		 * Clears all resources used by entity.
		 */
		override public function dispose() : void {
			textField = null;
			super.dispose();
		}
	
	}

}