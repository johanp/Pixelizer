package pixelizer.sound {
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import pixelizer.PxEntity;
	import pixelizer.utils.PxLog;
	
	/**
	 * Entity the plays a sound.
	 * @author Johan Peitz
	 */
	public class PxSoundEntity extends PxEntity {
		private var _sound : Sound;
		protected var _soundTransform : SoundTransform;
		protected var _soundChannel : SoundChannel = null;
		
		private var _isLooping : Boolean;
		
		private var _isGlobal : Boolean;
		
		private var _paused : Boolean;
		
		private var _pausePosition : Number;
		
		/**
		 * Constructs a new entity with specified sound.
		 * @param	pSound	Sound to play.
		 * @param	pPosition	Position to play sound at. Pass null for ambient sound.
		 * @param	pLoop	Whether too loop sound or not.
		 */
		public function PxSoundEntity( pSound : Sound, pPosition : Point = null, pLoop : Boolean = false ) {
			_sound = pSound;
			_isLooping = pLoop;
			_paused = false;
			
			if ( pPosition != null ) {
				transform.position.x = pPosition.x;
				transform.position.y = pPosition.y;
				_isGlobal = false;
			} else {
				_isGlobal = true;
			}
			
			if ( _isGlobal ) {
				_soundTransform = new SoundTransform( PxSoundManager.globalVolume );
			} else {
				_soundTransform = new SoundTransform( 0, 0 );
			}
			
			// start playing the sound
			play();
		
		}
		
		/**
		 * Disposes entity and stops sound.
		 */
		override public function dispose() : void {
			if ( _soundChannel != null ) {
				_soundChannel.removeEventListener( Event.SOUND_COMPLETE, onSoundComplete );
				_soundChannel.stop();
				_soundChannel = null;
			}
			
			_sound = null;
			_soundTransform = null;
			
			super.dispose();
		}
		
		private function play( pPosition : Number = 0 ) : void {
			_soundChannel = _sound.play( pPosition, 0, _soundTransform );
			if ( _soundChannel != null ) {
				_soundChannel.addEventListener( Event.SOUND_COMPLETE, onSoundComplete );
			} else {
				PxLog.log( "out of sound channels, skipping sound '" + _sound + "'", this, PxLog.WARNING );
				destroyIn( 0 );
			}
		
		}
		
		/**
		 * Updates the sound and changes it's sound transform depending on position.
		 * @param	pDT
		 */
		override public function update( pDT : Number ) : void {
			if ( parent != null && !_isGlobal ) {
				if ( _soundChannel != null ) {
					updateSoundTransform( transform.positionOnScene );
					_soundChannel.soundTransform = _soundTransform;
				}
			}
			if ( _isGlobal ) {
				setVolumeToGlobalVolume();
			}
			
			super.update( pDT );
		}
		
		/**
		 * Pauses the sound.
		 */
		public function pause() : void {
			if ( _paused )
				return;
			if ( _soundChannel != null ) {
				_paused = true;
				_pausePosition = _soundChannel.position;
				_soundChannel.removeEventListener( Event.SOUND_COMPLETE, onSoundComplete );
				_soundChannel.stop();
				_soundChannel = null;
			}
		
		}
		
		/**
		 * Resumes the sound.
		 */
		public function unpause() : void {
			if ( !_paused )
				return;
			_paused = false;
			play( _pausePosition );
		}
		
		private function updateSoundTransform( pScenePosition : Point ) : void {
			var camCenter : Point = scene.camera.center;
			var volDistToCam : Number = Point.distance( pScenePosition, camCenter );
			
			var vol : Number = 1;
			if ( volDistToCam > PxSoundManager.volumeRange.x + PxSoundManager.volumeRange.y ) {
				vol = 0;
			} else if ( volDistToCam > PxSoundManager.volumeRange.x ) {
				vol = 1 - ( volDistToCam - PxSoundManager.volumeRange.x ) / ( PxSoundManager.volumeRange.y );
			}
			
			_soundTransform.volume = vol * PxSoundManager.globalVolume;
			
			var panDistToCam : Number = Math.abs( pScenePosition.x - camCenter.x );
			var pan : Number = 0;
			
			if ( panDistToCam > PxSoundManager.panRange.x + PxSoundManager.panRange.y ) {
				pan = 1;
			} else if ( panDistToCam > PxSoundManager.panRange.x ) {
				pan = Math.abs( panDistToCam - PxSoundManager.panRange.x ) / ( PxSoundManager.panRange.y );
			}
			
			if ( pScenePosition.x < camCenter.x ) {
				pan = -pan;
			}
			
			_soundTransform.pan = pan;
		
		}
		
		private function onSoundComplete( pEvent : Event ) : void {
			_soundChannel.removeEventListener( Event.SOUND_COMPLETE, onSoundComplete );
			if ( _isLooping ) {
				play();
			} else {
				destroyIn( 0 );
			}
		}
		
		public function setVolumeToGlobalVolume() : void {
			if ( _soundChannel != null ) {
				_soundTransform.pan = 0;
				_soundTransform.volume = PxSoundManager.globalVolume;
				_soundChannel.soundTransform = _soundTransform
			}
		}
	
	}

}