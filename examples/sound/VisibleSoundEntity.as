package examples.sound {
	import flash.geom.Point;
	import flash.media.Sound;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.Pixelizer;
	import pixelizer.sound.PxSoundEntity;
	import pixelizer.utils.PxImageUtil;
	
	/**
	 * ...
	 * @author Johan Peitz
	 */
	public class VisibleSoundEntity extends PxSoundEntity {
		
		public function VisibleSoundEntity( pSound : Sound, pPosition : Point = null, pLoop : Boolean = false ) {
			super( pSound, pPosition, pLoop );
			// simple graphics
			( addComponent( new PxBlitRenderComponent( PxImageUtil.createCircle( 16, Pixelizer.COLOR_BLACK ) ) ) as PxBlitRenderComponent ).alpha = 0.5;
		}
		
		override public function update( pDT : Number ) : void {
			transform.scale = 0.1 + 1.9 * Math.max( _soundChannel.leftPeak, _soundChannel.rightPeak );
			
			super.update( pDT );
		}
	
	}

}