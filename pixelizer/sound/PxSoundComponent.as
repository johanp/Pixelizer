package pixelizer.sound {
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import pixelizer.components.PxComponent;
	import pixelizer.Pixelizer;
	import pixelizer.PxEntity;
	import pixelizer.PxScene;
	import pixelizer.utils.PxLog;
	
	/**
	 * Entity that plays a sound.
	 * @author Johan Peitz
	 */
	public class PxSoundComponent extends PxComponent {
		private var _sound : Sound;
		protected var _soundTransform : SoundTransform;
		protected var _soundChannel : SoundChannel = null;
		
		private var _isLooping : Boolean;
		
		private var _isAmbient : Boolean;
		
		private var _paused : Boolean;
		
		private var _pausePosition : Number;
		
		private var _onCompleteCallback : Function;
		
		/**
		 * Constructs a new component with specified sound.
		 * @param	pSound	Sound to play.
		 * @param	pPosition	Position to play sound at. Pass null for ambient sound.
		 * @param	pLoop	Whether too loop sound or not.
		 */
		public function PxSoundComponent( pSound : Sound, pAmbient : Boolean = false, pLoop : Boolean = false ) {
			_sound = pSound;
			_isLooping = pLoop;
			_paused = true;
			_isAmbient = pAmbient;
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
		
		/**
		 * Invoked when sound's entity is added to scene.
		 * Automatically adds the sound to the scene's sound system.
		 * @param	pScene	Scene entity was added to.
		 */
		override public function onEntityAddedToScene( pScene : PxScene ) : void {
			entity.scene.soundSystem.addSound( this );
			
			if ( _isAmbient ) {
				_soundTransform = new SoundTransform( entity.scene.soundSystem.volume * Pixelizer.globalVolume );
			} else {
				_soundTransform = new SoundTransform( 0, 0 );
			}
			
			// play the sound
			play();
		}
		
		/**
		 * Invoked when sound's entity is removed from scene.
		 * Automatically removes the sound from the scene's sound systemmanager.
		 * @param	pScene	Scene entity was removed from.
		 */
		override public function onEntityRemovedFromScene() : void {
			entity.scene.soundSystem.removeSound( this );
		}
		
		private function play( pPosition : Number = 0 ) : void {
			_paused = false;
			_soundChannel = _sound.play( pPosition, 0, _soundTransform );
			if ( _soundChannel != null ) {
				_soundChannel.addEventListener( Event.SOUND_COMPLETE, onSoundComplete );
			} else {
				PxLog.log( "out of sound channels, skipping sound '" + _sound + "'", this, PxLog.WARNING );
			}
		
		}
		
		/**
		 * Updates the sound and changes it's sound transform depending on position.
		 * @param	pDT
		 */
		override public function update( pDT : Number ) : void {
			if ( entity.parent != null && !_isAmbient ) {
				if ( _soundChannel != null ) {
					updateSoundTransform( entity.transform.positionOnScene );
					_soundChannel.soundTransform = _soundTransform;
				}
			}
			if ( _isAmbient ) {
				if ( _soundChannel != null ) {
					_soundTransform.pan = 0;
					_soundTransform.volume = entity.scene.soundSystem.volume * Pixelizer.globalVolume;
					_soundChannel.soundTransform = _soundTransform
				}
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
		
		/**
		 * Stops the sound.
		 */
		public function stop() : void {
			if ( _paused )
				return;
			if ( _soundChannel != null ) {
				_soundChannel.stop();
			}
		}
		
		private function updateSoundTransform( pScenePosition : Point ) : void {
			var camCenter : Point = entity.scene.camera.center;
			var volDistToCam : Number = Point.distance( pScenePosition, camCenter );
			
			var vol : Number = 1;
			if ( volDistToCam > entity.scene.soundSystem.volumeRange.x + entity.scene.soundSystem.volumeRange.y ) {
				vol = 0;
			} else if ( volDistToCam > entity.scene.soundSystem.volumeRange.x ) {
				vol = 1 - ( volDistToCam - entity.scene.soundSystem.volumeRange.x ) / ( entity.scene.soundSystem.volumeRange.y );
			}
			
			_soundTransform.volume = vol * entity.scene.soundSystem.volume * Pixelizer.globalVolume;
			
			var panDistToCam : Number = Math.abs( pScenePosition.x - camCenter.x );
			var pan : Number = 0;
			
			if ( panDistToCam > entity.scene.soundSystem.panRange.x + entity.scene.soundSystem.panRange.y ) {
				pan = 1;
			} else if ( panDistToCam > entity.scene.soundSystem.panRange.x ) {
				pan = Math.abs( panDistToCam - entity.scene.soundSystem.panRange.x ) / ( entity.scene.soundSystem.panRange.y );
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
				if ( _onCompleteCallback != null ) {
					_onCompleteCallback( this );
				}
			}
		}
		
		/**
		 * Returns the sound channel for this sound.
		 */
		public function get soundChannel() : SoundChannel {
			return _soundChannel;
		}
		
		public function set onCompleteCallback(pCallback:Function):void 
		{
			_onCompleteCallback = pCallback;
		}
	
	}

}