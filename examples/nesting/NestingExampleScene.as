package examples.nesting {
	import pixelizer.Pixelizer;
	import pixelizer.PxEntity;
	import pixelizer.PxInput;
	import pixelizer.PxScene;
	
	public class NestingExampleScene extends PxScene {
		
		private var _timePassed : Number = 0;
		
		public function NestingExampleScene() {
			// bg color of scene
			backgroundColor = Pixelizer.COLOR_WHITE;
			
			var i : int;
			var e : PxEntity;
			
			e = addEntity( new RotatingEntity( Pixelizer.COLOR_RED, 1 ) );
			e.transform.setPosition( 100, 60 );
			for ( i = 0; i < 4; i++ ) {
				e = e.addEntity( new RotatingEntity( Pixelizer.COLOR_RED, 1 ) );
				e.transform.setPosition( 14, 0 );
			}
			
			e = addEntity( new RotatingEntity( Pixelizer.COLOR_GREEN, 2 ) );
			e.transform.setPosition( 200, 120 );
			for ( i = 0; i < 6; i++ ) {
				e = e.addEntity( new RotatingEntity( Pixelizer.COLOR_GREEN, 2 ) );
				e.transform.setPosition( 14, 0 );
			}
			
			e = addEntity( new RotatingEntity( Pixelizer.COLOR_BLUE, 0.2 ) );
			e.transform.setPosition( 100, 180 );
			for ( i = 0; i < 20; i++ ) {
				e = e.addEntity( new RotatingEntity( Pixelizer.COLOR_BLUE, 0.2 ) );
				e.transform.setPosition( 14, 0 );
			}
		
		}
		
		override public function dispose() : void {
			
			super.dispose();
		}
		
		override public function update( pDT : Number ) : void {
			
			_timePassed += pDT;
			
			if ( PxInput.isPressed( PxInput.KEY_ESC ) ) {
				engine.popScene();
			}
			
			super.update( pDT );
		
		}
	
	}

}