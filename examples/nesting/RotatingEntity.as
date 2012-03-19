package examples.nesting {
	import flash.geom.Point;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.Pixelizer;
	import pixelizer.PxEntity;
	import pixelizer.utils.PxImageUtil;
	import pixelizer.utils.PxMath;
	
	/**
	 * ...
	 * @author Johan Peitz
	 */
	public class RotatingEntity extends PxEntity {
		private var _timePassed : Number = 0;
		private var _rotSpeed : Number = 1;
		private var _color : int = 0;
		
		public function RotatingEntity( pColor : int, pRotSpeed : Number ) {
			_color = pColor;
			_rotSpeed = pRotSpeed;
			transform.scale = 0.95;
			addComponent( new PxBlitRenderComponent( PxImageUtil.createRect( 16, 8, _color ), new Point( 0, 4 ) ) );
		}
		
		override public function update( pDT : Number ) : void {
			_timePassed += pDT * _rotSpeed;
			transform.rotation = PxMath.sin( _timePassed * 2 ) * 0.7;
			
			super.update( pDT );
		}
	
	}

}