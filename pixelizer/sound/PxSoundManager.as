package pixelizer.sound {
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	import pixelizer.Pixelizer;
	import pixelizer.PxEntity;
	import pixelizer.utils.PxLog;
	
	/**
	 * Manages all global sound issues.
	 * @author Johan Peitz
	 */
	public class PxSoundManager {
		private static var _storedSounds : Dictionary = new Dictionary();
		
		/**
		 * Sets the distance of where panning starts to occur and for how long until 100% on one end.
		 */
		public static var panRange : Point;
		/**
		 * Sets the distance of where volume starts to drop off how long until 0 left.
		 */
		public static var volumeRange : Point;
		
		/**
		 * Global volume.
		 */
		public static var globalVolume : Number;
		
		/**
		 * Initializes the sound manager. Gets taken care of autmatically.
		 */
		public static function init() : void {
			panRange = new Point( Pixelizer.engine.width * 0.75 / 2, Pixelizer.engine.width * 0.75 / 2 );
			volumeRange = new Point( Pixelizer.engine.width / 2, Pixelizer.engine.width / 2 );
			
			globalVolume = 1;
		}
		
		/**
		 * Pauses all sounds.
		 */
		public static function pause() : void {
			var entities : Vector.<PxEntity> = new Vector.<PxEntity>;
			Pixelizer.engine.currentScene.getEntitesByClass( Pixelizer.engine.currentScene.entityRoot, PxSoundEntity, entities );
			var pos : int = entities.length;
			while ( --pos >= 0 ) {
				( entities[ pos ] as PxSoundEntity ).pause();
			}
		}
		
		/**
		 * Resumes all paused sounds.
		 */
		public static function unpause() : void {
			var entities : Vector.<PxEntity> = new Vector.<PxEntity>;
			Pixelizer.engine.currentScene.getEntitesByClass( Pixelizer.engine.currentScene.entityRoot, PxSoundEntity, entities );
			var pos : int = entities.length;
			while ( --pos >= 0 ) {
				( entities[ pos ] as PxSoundEntity ).unpause();
			}
		}
		
		/**
		 * Mutes all current and future sounds.
		 */
		public static function mute() : void {
			if ( globalVolume > 0 ) {
				globalVolume = 0;
				
				updateAllSoundEntites();
			}
		}
		
		/**
		 * Unmutes all current and future sounds.
		 */
		public static function unmute() : void {
			if ( globalVolume == 0 ) {
				globalVolume = 1;
				
				updateAllSoundEntites();
			}
		}
		
		static private function updateAllSoundEntites() : void {
			var entities : Vector.<PxEntity> = new Vector.<PxEntity>;
			Pixelizer.engine.currentScene.getEntitesByClass( Pixelizer.engine.currentScene.entityRoot, PxSoundEntity, entities );
			var pos : int = entities.length;
			while ( --pos >= 0 ) {
				entities[ pos ].update( 0 );
			}
		}
		
		/**
		 * Returns true if sounds are muted.
		 * @return	True if sounds are muted.
		 */
		public static function isMuted() : Boolean {
			return globalVolume == 0;
		}
		
		/**
		 * Returns a previously stored Sound object.
		 * @param	pHandle	Text identifier of the Sound object to return.
		 * @return	A Sound object or null if no match was found.
		 */
		public static function fetch( pHandle : String ) : Sound {
			var sound : Sound = _storedSounds[ pHandle ];
			if ( sound == null ) {
				PxLog.log( "no sound found with handle '" + pHandle + "'", "[o PxSoundManager]", PxLog.WARNING );
				return null;
			}
			
			return sound;
		}
		
		/**
		 * Stores a Sound object for global use.
		 * @param	pHandle	Text identifier to store the sound with.
		 * @param	pSound	Sound object to store.
		 */
		public static function store( pHandle : String, pSound : Sound ) : void {
			_storedSounds[ pHandle ] = pSound;
			PxLog.log( "sound '" + pHandle + "' stored", "[o PxSoundManager]", PxLog.INFO );
		}
		
		/**
		 * Checks whether a handle is already in use.
		 * @param	pHandle	Identifier to check.
		 * @return True of handle is already used.
		 */
		public static function hasSound( pHandle : String ) : Boolean {
			return _storedSounds[ pHandle ] != null;
		}
		
		/**
		 * Shortcut for quickly playing a sound.
		 * @param	pSound	Sound to play.
		 * @param	pPosition	Where to play it. Pass null for ambient sounds.
		 * @param	pLoop	Whether to loop the sound or not.
		 */
		public static function play( pSound : Sound, pPosition : Point = null, pLoop : Boolean = false ) : void {
			Pixelizer.engine.currentScene.addEntity( new PxSoundEntity( pSound, pPosition, pLoop ) );
		}
	
	}

}