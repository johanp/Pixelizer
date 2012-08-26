package pixelizer.sound {
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	import pixelizer.Pixelizer;
	import pixelizer.PxEntity;
	import pixelizer.PxScene;
	import pixelizer.systems.PxSystem;
	import pixelizer.utils.PxLog;
	
	/**
	 * Manages all global sound issues.
	 * @author Johan Peitz
	 */
	public class PxSoundSystem extends PxSystem {
		private var _storedSounds : Dictionary = new Dictionary();
		
		/**
		 * Sets the distance of where panning starts to occur and for how long until 100% on one end.
		 */
		public var panRange : Point;
		/**
		 * Sets the distance of where volume starts to drop off how long until 0 left.
		 */
		public var volumeRange : Point;
		
		
		/**
		 * Initializes the sound manager. Gets taken care of autmatically.
		 */
		public function PxSoundSystem( pScene : PxScene, pPriority : int = 0 ) : void {
			super( pScene, pPriority );
			panRange = new Point( Pixelizer.engine.width * 0.75 / 2, Pixelizer.engine.width * 0.75 / 2 );
			volumeRange = new Point( Pixelizer.engine.width / 2, Pixelizer.engine.width / 2 );
			
		}
		
		/**
		 * Pauses all sounds.
		 */
		public function pause() : void {
			var entities : Vector.<PxEntity> = new Vector.<PxEntity>;
			scene.getEntitesByClass( scene.entityRoot, PxSoundEntity, entities );
			var pos : int = entities.length;
			while ( --pos >= 0 ) {
				( entities[ pos ] as PxSoundEntity ).pause();
			}
		}
		
		/**
		 * Resumes all paused sounds.
		 */
		public function unpause() : void {
			var entities : Vector.<PxEntity> = new Vector.<PxEntity>;
			scene.getEntitesByClass( scene.entityRoot, PxSoundEntity, entities );
			var pos : int = entities.length;
			while ( --pos >= 0 ) {
				( entities[ pos ] as PxSoundEntity ).unpause();
			}
		}
		
		/**
		 * Mutes all current and future sounds.
		 */
		public function mute() : void {
			if ( Pixelizer.globalVolume > 0 ) {
				Pixelizer.globalVolume = 0;
				
				updateAllSoundEntites();
			}
		}
		
		/**
		 * Unmutes all current and future sounds.
		 */
		public function unmute() : void {
			if ( Pixelizer.globalVolume == 0 ) {
				Pixelizer.globalVolume = 1;
				
				updateAllSoundEntites();
			}
		}
		
		private function updateAllSoundEntites() : void {
			var entities : Vector.<PxEntity> = new Vector.<PxEntity>;
			scene.getEntitesByClass( scene.entityRoot, PxSoundEntity, entities );
			var pos : int = entities.length;
			while ( --pos >= 0 ) {
				entities[ pos ].update( 0 );
			}
		}
		
		/**
		 * Returns true if sounds are muted.
		 * @return	True if sounds are muted.
		 */
		public function isMuted() : Boolean {
			return Pixelizer.globalVolume == 0;
		}
		
		
		/**
		 * Shortcut for quickly playing a sound.
		 * @param	pSound	Sound to play.
		 * @param	pPosition	Where to play it. Pass null for ambient sounds.
		 * @param	pLoop	Whether to loop the sound or not.
		 */
		public function play( pSound : Sound, pPosition : Point = null, pLoop : Boolean = false ) : void {
			Pixelizer.engine.currentScene.addEntity( new PxSoundEntity( pSound, pPosition, pLoop ) );
		}
	
	}

}