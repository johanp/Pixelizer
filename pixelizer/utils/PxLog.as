package pixelizer.utils {
	
	/**
	 * Class used to log messaged to console and other recievers.
	 */
	public class PxLog {
		/**
		 * Denotes a log entry as debug.
		 */
		public static const DEBUG : int = 0;
		/**
		 * Denotes a log entry as information.
		 */
		public static const INFO : int = 1;
		/**
		 * Denotes a log entry as a warning.
		 */
		public static const WARNING : int = 2;
		/**
		 * Denotes a log entry as an error.
		 */
		public static const ERROR : int = 3;
		/**
		 * Denotes a log entry as a fatal error (very bad!).
		 */
		public static const FATAL : int = 4;
		
		private static var _indentation : int = 0;
		private static const _prefix : Array = [ "   ", "---", "???", "!!!", "***" ];
		private static var _outputs : Array = [ trace ];
		
		/**
		 * Sends a string of text to any listening functions. ( At least trace(...). )
		 * @param	pText	String to log.
		 * @param	pCaller	Object that creats the string. Usually pass 'this'.
		 * @param	pLevel	Importance level of message.
		 */
		public static function log( pText : String, pCaller : Object = null, pLevel : int = DEBUG ) : void {
			var str : String = "";
			
			var caller : String = "?";
			if ( pCaller != null ) {
				caller = getObjectString( pCaller );
			}
			
			var spaces : String = "";
			if ( caller.length > _indentation ) {
				_indentation = caller.length;
			}
			var target : int = _indentation - caller.length;
			while ( spaces.length < target ) {
				spaces += " ";
			}
			str = spaces + "[" + caller + "] " + _prefix[ pLevel ] + " " + pText;
			
			for each ( var f : Function in _outputs ) {
				f( str );
			}
		}
		
		/**
		 * Adds a function that will recieve log output everytime PxLog.log is called.
		 * @param	pFunction	Function send log output to.
		 */
		static public function addLogFunction( pFunction : Function ) : void {
			_outputs.push( pFunction );
		}
		
		private static function getObjectString( pObject : Object ) : String {
			var objAsString : String = ( "" + pObject );
			var start : int = objAsString.indexOf( " " ) + 1;
			var end : int = objAsString.indexOf( "]" );
			return objAsString.slice( start, end );
		}
	}
}