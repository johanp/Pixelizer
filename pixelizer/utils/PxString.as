package pixelizer.utils {
	
	/**
	 * Utility class for string functions.
	 * @author Johan Peitz
	 */
	public class PxString {
		
		/**
		 * Trims a string from whitespace.
		 * @param	s	String to trim.
		 * @return	Trimmed string.
		 */
		static public function trim( s : String ) : String {
			return s.replace( /^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2" );
		}
	
	}

}