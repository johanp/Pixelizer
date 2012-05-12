package pixelizer {
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.LocalConnection;
	import flash.system.System;
	import pixelizer.render.PxDefaultFontGenerator;
	import pixelizer.sound.PxSoundManager;
	import pixelizer.utils.PxLog;
	import pixelizer.utils.PxObjectPool;
	
	/**
	 * Omnipotent class that can be used to take various short cuts. Also holds various useful things.
	 */
	public class Pixelizer {
		public static const MAJOR_VERSION : int = 0;
		public static const MINOR_VERSION : int = 4;
		public static const INTERNAL_VERSION : int = 3;
		 
		public static const COLOR_RED : int = 0xFF5D5D;
		public static const COLOR_GREEN : int = 0x5DFC5D;
		public static const COLOR_BLUE : int = 0x5CBCFC;
		public static const COLOR_WHITE : int = 0xFFFFFF;
 		public static const COLOR_BLACK : int = 0x000000;
		public static const COLOR_LIGHT_GRAY : int = 0xE6E6E6;
		public static const COLOR_GRAY : int = 0xAAAAAA;
		public static const COLOR_DARK_GRAY : int = 0x808080;
		
		public static const LEFT : int = 1;
		public static const RIGHT : int = 2;
		public static const CENTER : int = 3;
		
		static public const NO_FLIP : int = 0;
		static public const H_FLIP : int = 1;
		static public const V_FLIP : int = 2;
		
		static public const COLLISION_LAYER_GRID : int = 0;
		
		/**
		 * Object pool for points.
		 * Fetch and recycle Points here for added performance.
		 */
		public static var matrixPool : PxObjectPool;
		public static var pointPool : PxObjectPool;
		public static var ZERO_POINT : Point;
		
		/**
		 * Reference to the engine.
		 */
		public static var engine : PxEngine;
		/**
		 * Reference to the stage.
		 */
		public static var stage : Stage;
		
		private static var _isInitialized : Boolean = false;
		
		/**
		 * Initializes Pixelizer. Is done automatically when inheriting PxEngine.
		 *
		 * @param	pEngine	Engine which initializes Pixelizer.
		 * @param	pStage	Reference to Flash's stage.
		 */
		public static function init() : void {
			if ( _isInitialized ) {
				PxLog.log( "Pixelizer already initialized.", "[o Pixelizer]", PxLog.WARNING );
				return;
			}
			PxLog.log( "", "[o Pixelizer]", PxLog.INFO );
			PxLog.log( "*** PIXELIZER v " + MAJOR_VERSION + "." + MINOR_VERSION + "." + INTERNAL_VERSION + " ***", "[o Pixelizer]", PxLog.INFO );
			PxLog.log( "", "[o Pixelizer]", PxLog.INFO );
			
			matrixPool = new PxObjectPool( Matrix );
			pointPool = new PxObjectPool( Point );
			ZERO_POINT = pointPool.fetch();
			ZERO_POINT.x = ZERO_POINT.y = 0;
			
			PxDefaultFontGenerator.generateAndStoreDefaultFont();
			
			_isInitialized = true;
		
		}
		
		static public function onEngineAddedToStage( pEngine : PxEngine, pStage : Stage ) : void {
			engine = pEngine;
			stage = pStage;
			
			stage.stageFocusRect = false;
			stage.quality = StageQuality.LOW;
			stage.scaleMode = "noScale";
			
			PxInput.init( stage );
			PxSoundManager.init();
		
		}
		
		/**
		 * Tries to run the garbage collector in all possible ways. May still not work, but most of the time it does.
		 */
		public static function garbageCollect() : void {
			System.gc();
			try {
				new LocalConnection().connect( 'foo' );
				new LocalConnection().connect( 'foo' );
			} catch ( e : * ) {
			}
		}
		
		/**
		 * Checks whether the swf is loaded from an allowed domain.
		 * Use this to site lock your game.
		 * @param	pDomains	Array of allowed hosts.
		 * @return	True if swf is loaded from any of the allowed domains.
		 */
		public static function isAllowedDomain( pDomains : Array ) : Boolean {
			var url : String = Pixelizer.stage.loaderInfo.url;
			
			var startCheck : int = url.indexOf( '://' ) + 3;
			
			if ( url.substr( 0, startCheck ) == 'file://' ) {
				return true;
			}
			
			var len : int = url.indexOf( '/', startCheck ) - startCheck;
			var host : String = url.substr( startCheck, len );
			
			for each ( var domain : String in pDomains ) {
				if ( host.substr( -domain.length, domain.length ) == domain ) {
					return true;
				}
			}
			
			return false;
		}
	
	}
}