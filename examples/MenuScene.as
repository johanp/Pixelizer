package examples {
	import examples.assets.AssetFactory;
	import examples.benchmark.BenchmarkExampleScene;
	import examples.collision.CollisionExampleScene;
	import examples.emitter.EmittersExampleScene;
	import examples.gui.GUIExampleScene;
	import examples.input.InputExampleScene;
	import examples.nesting.NestingExampleScene;
	import examples.platformer.PlatformerTitleScene;
	import examples.sound.SoundExampleScene;
	import examples.spritesheet.SpriteSheetExampleScene;
	import examples.text.TextExampleScene;
	import examples.transform.TransformExampleScene;
	import pixelizer.Pixelizer;
	import pixelizer.prefabs.gui.PxGUIButton;
	import pixelizer.prefabs.gui.PxMouseEntity;
	import pixelizer.prefabs.gui.PxTextFieldEntity;
	import pixelizer.PxEntity;
	import pixelizer.PxInput;
	import pixelizer.PxScene;
	import pixelizer.sound.PxSoundManager;
	
	public class MenuScene extends PxScene {
		
		private var _timeActive : Number = 0;
		private var _clock : PxTextFieldEntity
		private var _examples : Array;
		
		public function MenuScene() {
			// specify bg color
			backgroundColor = Pixelizer.COLOR_WHITE;
			
			addEntity( new PxMouseEntity() );
			
			_examples = [];
			_examples.push({ lbl: "Transforms", cls: TransformExampleScene } );
			_examples.push({ lbl: "Nested Entities", cls: NestingExampleScene } );
			_examples.push({ lbl: "Text Fields", cls: TextExampleScene } );
			_examples.push({ lbl: "Input", cls: InputExampleScene } );
			_examples.push({ lbl: "GUI", cls: GUIExampleScene } );
			_examples.push({ lbl: "Sprite Sheets", cls: SpriteSheetExampleScene } );
			_examples.push({ lbl: "Playing Sounds", cls: SoundExampleScene } );
			_examples.push({ lbl: "Collisions", cls: CollisionExampleScene } );
			_examples.push({ lbl: "Emitters", cls: EmittersExampleScene } );
			_examples.push({ lbl: "Platform Game", cls: PlatformerTitleScene } );
			_examples.push({ lbl: "Benchmark", cls: BenchmarkExampleScene } );
			
			var menu : String = "PIXELIZER EXAMPLES\n---------------------\n";
			menu += "At any time, ESC will return to this menu.";
			
			var textEntity : PxTextFieldEntity = new PxTextFieldEntity( menu, 0x555555 );
			addEntity( textEntity );
			textEntity.transform.setPosition( 0, 10 );
			textEntity.textField.width = 320;
			textEntity.textField.alignment = Pixelizer.CENTER;
			
			var by : int = 0;
			var bx : int = 0;
			for each ( var o : Object in _examples ) {
				addEntity( new PxGUIButton( o.lbl, onButtonClicked ) ).transform.setPosition( 40 + bx, 40 + by );
				by += 18;
				if ( by > 160 ) {
					by = 0;
					bx += 100;
				}
			}
			
			_clock = addEntity( new PxTextFieldEntity( "", Pixelizer.COLOR_GRAY ) ) as PxTextFieldEntity;
			_clock.transform.setPosition( 10, 220 );
		}
		
		override public function update( pDT : Number ) : void {
			_timeActive += pDT;
			_clock.textField.text = "Time active: " + int( _timeActive * 10 ) / 10 + " s";
			
			super.update( pDT );
		}
		
		private function onButtonClicked( pButton : PxGUIButton ) : void {
			for each ( var o : Object in _examples ) {
				if ( o.lbl == pButton.label ) {
					engine.pushScene( new o.cls() );
					break;
				}
			}
		}
	
	}

}