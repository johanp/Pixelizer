package examples.assets {
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import pixelizer.render.PxBitmapFont;
	
	/**
	 * A nice place to store all bitmap assets so they're only instanciated oncel
	 * @author Johan Peitz
	 */
	public class AssetFactory {
		
		[Embed( source="sheep.mp3" )]
		private static var sheepCls : Class;
		private static var sheep : Sound = null;
		
		public static function get sheepSound() : Sound {
			if ( sheep == null ) {
				sheep = new sheepCls();
			}
			
			return sheep;
		}
		
		[Embed( source="bird_song.mp3" )]
		private static var birdCls : Class;
		private static var bird : Sound = null;
		
		public static function get birdSound() : Sound {
			if ( bird == null ) {
				bird = new birdCls();
			}
			
			return bird;
		}
		
		[Embed( source="heart.mp3" )]
		private static var heartCls : Class;
		private static var heart : Sound = null;
		
		public static function get heartSound() : Sound {
			if ( heart == null ) {
				heart = new heartCls();
			}
			
			return heart;
		}
		
		[Embed( source="explosion.mp3" )]
		private static var explosionCls : Class;
		private static var explosion : Sound = null;
		
		public static function get explosionSound() : Sound {
			if ( explosion == null ) {
				explosion = new explosionCls();
			}
			
			return explosion;
		}
		
		[Embed( source="jump.mp3" )]
		private static var jumpCls : Class;
		private static var jump : Sound = null;
		
		public static function get jumpSound() : Sound {
			if ( jump == null ) {
				jump = new jumpCls();
			}
			
			return jump;
		}
		
		[Embed( source="music_loop.mp3" )]
		private static var musicCls : Class;
		private static var music : Sound = null;
		
		public static function get musicSound() : Sound {
			if ( music == null ) {
				music = new musicCls();
			}
			
			return music;
		}
		
		[Embed( source="tiles.png" )]
		private static var tilesCls : Class;
		private static var tilesBitmapData : BitmapData = null;
		
		public static function get tiles() : BitmapData {
			if ( tilesBitmapData == null ) {
				tilesBitmapData = new tilesCls().bitmapData;
			}
			
			return tilesBitmapData;
		}
		
		[Embed( source="player.png" )]
		private static var playerCls : Class;
		private static var playerBitmapData : BitmapData = null;
		
		public static function get player() : BitmapData {
			if ( playerBitmapData == null ) {
				playerBitmapData = new playerCls().bitmapData;
			}
			
			return playerBitmapData;
		}
		
		[Embed( source="pickups.png" )]
		private static var pickupsCls : Class;
		private static var pickupsBitmapData : BitmapData = null;
		
		public static function get pickups() : BitmapData {
			if ( pickupsBitmapData == null ) {
				pickupsBitmapData = new pickupsCls().bitmapData;
			}
			
			return pickupsBitmapData;
		}
		
		[Embed( source="box.png" )]
		private static var boxCls : Class;
		private static var boxBitmapData : BitmapData = null;
		
		public static function get box() : BitmapData {
			if ( boxBitmapData == null ) {
				boxBitmapData = new boxCls().bitmapData;
			}
			
			return boxBitmapData;
		}
		
		[Embed( source="round_font.png" )]
		private static var rfCls : Class;
		private static var rfBitmapData : BitmapData = null;
		private static var rfFont : PxBitmapFont = null;
		
		public static function get roundFont() : PxBitmapFont {
			if ( rfFont == null ) {
				if ( rfBitmapData == null ) {
					rfBitmapData = new rfCls().bitmapData;
				}
				var letters : String = " !\"#$%&'()*+,-./" + "0123456789:;<=>?" + "@ABCDEFGHIJKLMNO" + "PQRSTUVWXYZ[}]^_" + "'abcdefghijklmno" + "pqrstuvwxyz{|}~\\";
				rfFont = new PxBitmapFont( rfBitmapData, letters );
			}
			
			return rfFont;
		}
		
		[Embed( source="animation.swf",symbol="animation" )]
		private static var mcClass : Class;
		private static var mcInstance : MovieClip = null;
		
		public static function get mc() : MovieClip {
			if ( mcInstance == null ) {
				mcInstance = new mcClass();
			}
			
			return mcInstance;
		}
	
	}

}