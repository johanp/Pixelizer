package examples.camera {
	import flash.display.Bitmap;
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import pixelizer.Pixelizer;
	import pixelizer.PxScene;
	import pixelizer.systems.PxSystem;
	
	/**
	 * ...
	 * @author Johan Peitz
	 */
	public class BlurSystem extends PxSystem {
		
		private var _blurFilter : BlurFilter;
		private var _bounds : Rectangle;
		
		public function BlurSystem( pScene : PxScene, pPriority : int ) {
			super( pScene, pPriority );
			
			_blurFilter = new BlurFilter( 2, 2, 2 );
			_bounds = new Rectangle( 0, 0, Pixelizer.engine.width, Pixelizer.engine.height );
		}
		
		override public function beforeRender() : void {
			var bmp : Bitmap = ( scene.renderSystem.displayObject as Bitmap );
			
			bmp.bitmapData.applyFilter( bmp.bitmapData, _bounds, Pixelizer.ZERO_POINT, _blurFilter );
			var m : Array = new Array();
			m = m.concat([ 1, 0, 0, 0, 0 ] ); // red
			m = m.concat([ 0, 1, 0, 0, 0 ] ); // green
			m = m.concat([ 0, 0, 1, 0, 0 ] ); // blue
			m = m.concat([ 0, 0, 0, 0.9, 0 ] ); // alpha        
			bmp.bitmapData.applyFilter( bmp.bitmapData, _bounds, Pixelizer.ZERO_POINT, new ColorMatrixFilter( m ) );
		
		}
	
	}

}