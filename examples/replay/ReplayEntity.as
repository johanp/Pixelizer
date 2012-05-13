package examples.replay {
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.Pixelizer;
	import pixelizer.PxEntity;
	import pixelizer.PxInput;
	import pixelizer.utils.PxImageUtil;
	import pixelizer.utils.PxInputPost;
	import pixelizer.utils.PxInputSequence;
	
	/**
	 * ...
	 * @author Johan Peitz
	 */
	public class ReplayEntity extends PxEntity {
		
		private var _recordInput : Boolean = false;
		private var _inputSequence : PxInputSequence;
		
		public function ReplayEntity() {
			addComponent( new PxBlitRenderComponent( PxImageUtil.createRect( 16, 16 ) ) );
			
			transform.setPosition( 160, 120 );
			
			_recordInput = true;
			_inputSequence = new PxInputSequence();
		}
		
		override public function update( pDT : Number ) : void {
			var input : PxInputPost = new PxInputPost();
			
			if ( _recordInput ) {
				input = new PxInputPost();
				input.left = PxInput.isDown( PxInput.KEY_LEFT );
				input.right = PxInput.isDown( PxInput.KEY_RIGHT );
				input.up = PxInput.isDown( PxInput.KEY_UP );
				input.down = PxInput.isDown( PxInput.KEY_DOWN );
				_inputSequence.storePost( input );
			} else {
				input = _inputSequence.fetchPost();
				if ( input == null ) {
					input = new PxInputPost()
					replay();
				}
			}
			
			var speed : Number = 60;
			if ( input.up ) {
				transform.position.y -= speed * pDT;
			}
			if ( input.down ) {
				transform.position.y += speed * pDT;
			}
			if ( input.left ) {
				transform.position.x -= speed * pDT;
			}
			if ( input.right ) {
				transform.position.x += speed * pDT;
			}
			
			super.update( pDT );
		}
		
		public function replay() : void {
			_recordInput = false;
			transform.setPosition( 160, 120 );
			_inputSequence.restart();
		}
	
	}

}