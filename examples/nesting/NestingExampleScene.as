package examples.nesting {
	import flash.geom.Point;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.Pixelizer;
	import pixelizer.PxEntity;
	import pixelizer.PxInput;
	import pixelizer.PxScene;
	import pixelizer.utils.PxImageUtil;
	
	public class NestingExampleScene extends PxScene {
		
		private var _timePassed : Number = 0;
		
		private var _localToGlobalEntity : PxEntity;
		private var _lastNestedEntity : PxEntity;
		
		public function NestingExampleScene() {
			// bg color of scene
			backgroundColor = Pixelizer.COLOR_WHITE;
			
			var i : int;
			var e : PxEntity;

			e = addEntity( new RotatingEntity( Pixelizer.COLOR_RED, 2 ) );
			e.transform.setPosition( 100, 60 );
			for ( i = 0; i < 4; i++ ) {
				e = e.addEntity( new RotatingEntity( Pixelizer.COLOR_RED, 2 ) );
				e.transform.setPosition( 14, 0 );
			}
			
			e = addEntity( new RotatingEntity( Pixelizer.COLOR_GREEN, 1 ) );
			e.transform.setPosition( 200, 120 );
			for ( i = 0; i < 6; i++ ) {
				e = e.addEntity( new RotatingEntity( Pixelizer.COLOR_GREEN, 1 ) );
				e.transform.setPosition( 14, 0 );
				_lastNestedEntity = e;
			}
			
			
			e = addEntity( new RotatingEntity( Pixelizer.COLOR_BLUE, 0.2 ) );
			e.transform.setPosition( 100, 180 );
			for ( i = 0; i < 20; i++ ) {
				e = e.addEntity( new RotatingEntity( Pixelizer.COLOR_BLUE, 0.2 ) );
				e.transform.setPosition( 14, 0 );
			}
			
			
			_localToGlobalEntity = new PxEntity( );
			_localToGlobalEntity.addComponent( new PxBlitRenderComponent( PxImageUtil.createRect( 50, 1, Pixelizer.COLOR_BLACK ), new Point() ) );
			addEntity( _localToGlobalEntity );
		
		}
		
		override public function dispose() : void {
			_localToGlobalEntity = null;
			_lastNestedEntity = null;
			super.dispose();
		}
		
		override public function update( pDT : Number ) : void {
			
			_timePassed += pDT;
			
			if ( PxInput.isPressed( PxInput.KEY_ESC ) ) {
				engine.popScene();
			}
			
			super.update( pDT );
			
			_localToGlobalEntity.transform.position.x = _lastNestedEntity.transform.positionOnScene.x;
			_localToGlobalEntity.transform.position.y = _lastNestedEntity.transform.positionOnScene.y;
			_localToGlobalEntity.transform.rotation = _lastNestedEntity.transform.rotationOnScene;
			
			
			trace( _lastNestedEntity.transform.position, _lastNestedEntity.transform.positionOnScene );
		}
	
	}

}