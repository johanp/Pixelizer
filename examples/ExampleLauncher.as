package examples {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import pixelizer.Pixelizer;
	import pixelizer.PxEngine;
	
	/**
	 *
	 * @author Johan Peitz
	 */
	[SWF( width="640",height="480" )]
	public class ExampleLauncher extends Sprite {
		
		public function ExampleLauncher() {
			
			var engine : PxEngine = new PxEngine( 320, 240, 2 );
			addChild( engine );
			// engine.showPerformance = true;
			// engine.pauseOnFocusLost = false;
			
			engine.pushScene( new MenuScene() );
		}
	
	}

}