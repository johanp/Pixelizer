package examples.collision {
	import pixelizer.Pixelizer;
	import pixelizer.PxEntity;
	import pixelizer.PxInput;
	import pixelizer.PxScene;
	import pixelizer.utils.PxMath;
	
	public class CollisionExampleScene extends PxScene {
		
		private var _controllableEntity : PxEntity;
		
		public function CollisionExampleScene() {
			// bg color of scene
			backgroundColor = Pixelizer.COLOR_WHITE;
			
			_controllableEntity = addEntity( new VisualCollisionEntity( true ) );
			
			for ( var i : int = 0; i < 40; i++ ) {
				var e : VisualCollisionEntity = new VisualCollisionEntity( PxMath.randomBoolean() );
				e.transform.setPosition( PxMath.randomInt( 40, 264 ), PxMath.randomInt( 40, 184 ) );
				addEntity( e );
			}
		
		}
		
		override public function update( pDT : Number ) : void {
			_controllableEntity.transform.setPosition( PxInput.mouseX, PxInput.mouseY );
			
			super.update( pDT );
			
			if ( PxInput.isPressed( PxInput.KEY_ESC ) ) {
				engine.popScene();
			}
		}
	
	}

}