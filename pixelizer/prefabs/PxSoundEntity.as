package pixelizer.prefabs {
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import pixelizer.Pixelizer;
	import pixelizer.PxEntity;
	import pixelizer.sound.PxSoundComponent;
	import pixelizer.utils.PxLog;
	
	/**
	 * Entity that plays a sound.
	 * @author Johan Peitz
	 */
	public class PxSoundEntity extends PxEntity {
		protected var _soundComp:PxSoundComponent;
		
		/**
		 * Constructs a new entity with specified sound.
		 * @param	pSound	Sound to play.
		 * @param	pPosition	Position to play sound at. Pass null for ambient sound.
		 * @param	pLoop	Whether too loop sound or not.
		 */
		public function PxSoundEntity( pSound : Sound, pPosition : Point, pLoop : Boolean = false, pDestroyOnComplete : Boolean = true ) {
			if ( pPosition != null ) {
				transform.position.x = pPosition.x;
				transform.position.y = pPosition.y;
			}
			
			
			_soundComp = new PxSoundComponent( pSound, pPosition == null, pLoop );

			if ( pDestroyOnComplete ) {
				_soundComp.onCompleteCallback = onSoundComplete;
			}
			
			addComponent( _soundComp );
		}
		
		
		/**
		 * Disposes entity and stops sound.
		 */
		override public function dispose() : void {
			_soundComp = null;
			
			super.dispose();
		}
		
		
		private function onSoundComplete( pSoundComponent : PxSoundComponent ):void 
		{
			destroyIn( 0 );
		}
		
		/**
		 * Pauses the sound.
		 */
		public function pause() : void {
			_soundComp.pause();
		}
		
		/**
		 * Resumes the sound.
		 */
		public function unpause() : void {
			_soundComp.unpause();
		}
		
	
	}

}