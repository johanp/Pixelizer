package pixelizer.sound {
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	import pixelizer.Pixelizer;
	import pixelizer.prefabs.PxSoundEntity;
	import pixelizer.PxEntity;
	import pixelizer.PxScene;
	import pixelizer.systems.PxSystem;
	import pixelizer.utils.PxLog;
	
	/**
	 * Manages all global sound issues.
	 * @author Johan Peitz
	 */
	public class PxSoundSystem extends PxSystem {
		private var _sounds : Array = [];
		
		/**
		 * Sets the distance of where panning starts to occur and for how long until 100% on one end.
		 */
		public var panRange : Point;
		/**
		 * Sets the distance of where volume starts to drop off how long until 0 left.
		 */
		public var volumeRange : Point;
		
		private var _volume : Number;
		private var _volumeBeforeMute : Number;
		
		
		/**
		 * Initializes the sound system.
		 */
		public function PxSoundSystem( pScene : PxScene, pPriority : int = 0 ) : void {
			super( pScene, pPriority );
			
			panRange = new Point( Pixelizer.engine.width * 0.75 / 2, Pixelizer.engine.width * 0.75 / 2 );
			volumeRange = new Point( Pixelizer.engine.width / 2, Pixelizer.engine.width / 2 );
			_volume = 1;
		}

		/**
		 * Clears all resources used by this system.
		 */
		override public function dispose() : void {
			var pos : int = _sounds.length;
			while ( --pos >= 0 ) {
				( _sounds[ pos ] as PxSoundComponent ).stop();
			}
			_sounds = null;
			super.dispose();
		}
		
		/**
		 * Adds a collider to the system. The collider will now be check for collision against other colliders.
		 * @param	pCollider	Collider to add.
		 */
		public function addSound( pSound : PxSoundComponent ) : void {
			_sounds.push( pSound );
		}
		
		/**
		 * Removes a collider from the system. It will no longer collide with other colliders.
		 * @param	pCollider	Collider to remove.
		 */
		public function removeSound( pSound : PxSoundComponent ) : void {
			_sounds.splice( _sounds.indexOf( pSound ), 1 );
		}
		
		
		/**
		 * Pauses all sounds.
		 */
		public function pause() : void {
			var pos : int = _sounds.length;
			while ( --pos >= 0 ) {
				( _sounds[ pos ] as PxSoundComponent ).pause();
			}
		}
		
		/**
		 * Resumes all paused sounds.
		 */
		public function unpause() : void {
			var pos : int = _sounds.length;
			while ( --pos >= 0 ) {
				( _sounds[ pos ] as PxSoundComponent ).unpause();
			}
		}
		
		/**
		 * Mutes all current and future sounds.
		 */
		public function mute() : void {
			if ( _volume > 0 ) {
				_volumeBeforeMute = _volume;
				_volume = 0;
				
				updateAllSoundEntites();
			}
		}
		
		/**
		 * Unmutes all current and future sounds.
		 */
		public function unmute() : void {
			if ( _volume == 0 ) {
				_volume = _volumeBeforeMute;
				
				updateAllSoundEntites();
			}
		}
		
		
		private function updateAllSoundEntites() : void {
			var pos : int = _sounds.length;
			while ( --pos >= 0 ) {
				_sounds[ pos ].update( 0 );
			}
		}
		
		/**
		 * Returns true if sounds are muted.
		 * @return	True if sounds are muted.
		 */
		public function isMuted() : Boolean {
			return _volume == 0;
		}
		
		
		/**
		 * Shortcut for quickly playing a sound.
		 * @param	pSound	Sound to play.
		 * @param	pPosition	Where to play it. Pass null for ambient sounds.
		 * @param	pLoop	Whether to loop the sound or not.
		 */
		public function play( pSound : Sound, pPosition : Point = null, pLoop : Boolean = false ) : void {
			var soundEntity : PxSoundEntity = new PxSoundEntity( pSound, pPosition, pLoop );
			Pixelizer.engine.currentScene.addEntity( soundEntity );
		}
		
		public function get volume():Number 
		{
			return _volume;
		}
	
	}

}