package examples.benchmark {
	import examples.collision.CollisionExampleScene;
	import examples.emitter.EmittersExampleScene;
	import examples.input.InputExampleScene;
	import examples.platformer.PlatformerTitleScene;
	import examples.sound.SoundExampleScene;
	import examples.text.TextExampleScene;
	import examples.transform.TransformExampleScene;
	import flash.display.BitmapData;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.physics.PxCollisionSolver;
	import pixelizer.Pixelizer;
	import pixelizer.prefabs.gui.PxTextFieldEntity;
	import pixelizer.PxEngine;
	import pixelizer.PxEntity;
	import pixelizer.PxInput;
	import pixelizer.PxScene;
	import pixelizer.utils.PxMath;
	
	public class BenchmarkExampleScene extends PxScene {
		
		[Embed( source="../assets/pickups.png" )]
		private static var pickupsCls : Class;

		private var _testEntities : Array = [];
		private var _infoText : PxTextFieldEntity;
		private var _mode : int = 0;
		
		public function BenchmarkExampleScene() {
			// specify bg color
			backgroundColor = Pixelizer.COLOR_WHITE;
			
			// image to use
			var bd : BitmapData = new pickupsCls().bitmapData;
			
			// position examples
			for ( var i : int = 0; i < 500; i++ ) {
				var e : PxEntity = new PxEntity( PxMath.randomInt( 0, 320 ), PxMath.randomInt( 0, 240 ) );
				e.addComponent( new PxBlitRenderComponent( bd ) );
				addEntity( e );
				_testEntities.push( e );
			}
			
			_infoText = new PxTextFieldEntity();
			_infoText.transform.setPosition( 0, 100 );
			_infoText.textField.padding = 2;
			_infoText.textField.background = true;
			addEntity( _infoText );
		
		}
		
		override public function dispose() : void {
			_testEntities = null;
			_infoText = null;
			super.dispose();
		}
		
		override public function update( pDT : Number ) : void {
			var e : PxEntity;
			
			if ( PxInput.isPressed( PxInput.KEY_ESC ) ) {
				engine.popScene();
			}
			
			if ( PxInput.isPressed( PxInput.KEY_Q ) ) {
				if ( _mode & 1 ) {
					_mode &= ~1;
					for each ( e in _testEntities ) {
						e.transform.scaleY = 1;
					}
				} else {
					_mode |= 1;
					for each ( e in _testEntities ) {
						e.transform.scaleY = -1;
						
					}
				}
			}
			
			if ( PxInput.isPressed( PxInput.KEY_W ) ) {
				if ( _mode & 2 ) {
					_mode &= ~2;
					for each ( e in _testEntities ) {
						e.transform.rotation = 0;
					}
				} else {
					_mode |= 2;
					for each ( e in _testEntities ) {
						e.transform.rotation = PxMath.HALF_PI / 2;
					}
				}
			}
			
			if ( PxInput.isPressed( PxInput.KEY_E ) ) {
				if ( _mode & 4 ) {
					_mode &= ~4;
					for each ( e in _testEntities ) {
						( e.getComponentByClass( PxBlitRenderComponent ) as PxBlitRenderComponent ).alpha = 1;
					}
				} else {
					_mode |= 4;
					for each ( e in _testEntities ) {
						( e.getComponentByClass( PxBlitRenderComponent ) as PxBlitRenderComponent ).alpha = 0.5;
					}
				}
			}
			
			var renderStr : String = "Press Q,W,E to toggle modes.\n\n";
			if ( _mode & 1 )
				renderStr += "[ SCALE FLIP ] ";
			if ( _mode & 2 )
				renderStr += "[ ROTATION ] ";
			if ( _mode & 4 )
				renderStr += "[ ALPHA ] ";
			_infoText.textField.text = renderStr + "\n\nRendering " + engine.renderer.renderStats.renderedObjects + " objects in " + engine.renderer.renderStats.renderTime + " ms";
			
			super.update( pDT );
		}
	
	}

}