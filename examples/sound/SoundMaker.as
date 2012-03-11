package examples.sound {
	import examples.assets.AssetFactory;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.Pixelizer;
	import pixelizer.PxEntity;
	import pixelizer.utils.PxImageUtil;
	
	/**
	 * ...
	 * @author Johan Peitz
	 */
	public class SoundMaker extends PxEntity {
		
		private var _timePassed : Number = 0;
		
		public function SoundMaker() {
			super( 160, 120 );
			addComponent( new PxBlitRenderComponent( PxImageUtil.createRect( 32, 32, Pixelizer.COLOR_BLUE ) ) );
			
			addEntity( new VisibleSoundEntity( AssetFactory.birdSound, Pixelizer.ZERO_POINT, true ) );
		}
		
		override public function update( pDT : Number ) : void {
			// rotate for fun
			_timePassed += pDT;
			transform.position.x = 160 + 160 * Math.sin( _timePassed / 2 );
			transform.rotation = _timePassed * 4;
			
			super.update( pDT );
		}
	
	}

}