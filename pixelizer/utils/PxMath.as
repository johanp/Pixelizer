package pixelizer.utils {
	
	/**
	 * Contains various mathematical functions and structures.
	 * @author Johan Peitz
	 */
	public final class PxMath {
		/**
		 * A half PI.
		 */
		public static const HALF_PI : Number = Math.PI / 2;
		/**
		 * The whole PI.
		 */
		public static const PI : Number = Math.PI;
		/**
		 * A double PI.
		 */
		public static const TWO_PI : Number = PI * 2;
		/**
		 * Multiply with this to convert radians to degrees.
		 */
		public static const RAD_TO_DEG : Number = 180 / Math.PI;
		/**
		 * Multiply with this to convert degrees to radians.
		 */
		public static const DEG_TO_RAD : Number = Math.PI / 180;
		
		/**
		 * Converts an angle to fit within the unit circle.
		 * @param	pRadians	Angle to convert.
		 * @return	Converted angle.
		 */
		public static function wrapAngle( pRadians : Number ) : Number {
			while ( pRadians < -PI ) {
				pRadians += TWO_PI;
			}
			while ( pRadians > PI ) {
				pRadians -= TWO_PI;
			}
			return pRadians;
		}
		
		/**
		 * Returns the shortest angle between two angles.
		 * @param	pRadians1	Angle 1.
		 * @param	pRadians2	Angle 2.
		 * @return	The shortest angle.
		 */
		public static function deltaAngle( pRadians1 : Number, pRadians2 : Number ) : Number {
			return Math.abs( wrapAngle( pRadians1 - pRadians2 ) );
		}
		
		/**
		 * Returns the sign of a number.
		 * @param	pValue	Number to check.
		 * @return	Sign of number. ( -1, 0, or 1 )
		 */
		public static function sign( pValue : Number ) : int {
			return ( pValue > 0 ? 1 : ( pValue < 0 ? -1 : 0 ) );
		}
		
		/**
		 * Returns a random number within a scope.
		 * @param	pMin	Minimum result (inclusive).
		 * @param	pMax	Maximum result (exclusive).
		 * @return	A random number.
		 */
		public static function randomNumber( pMin : Number, pMax : Number ) : Number {
			return pMin + ( pMax - pMin ) * Math.random();
		}
		
		/**
		 * Returns a random int within a scope.
		 * @param	pMin	Minimum result (inclusive).
		 * @param	pMax	Maximum result (exclusive).
		 * @return	A random int.
		 */
		public static function randomInt( pMin : int, pMax : int ) : int {
			return pMin + ( pMax - pMin ) * Math.random();
		}
		
		/**
		 * Returns a random boolean.
		 * @return	True or false.
		 */
		public static function randomBoolean() : Boolean {
			return Math.random() < 0.5;
		}
		
		/**
		 * Uses quick and approximate algorithm to get sin value.
		 * @see http://lab.polygonal.de/?p=205
		 * @param	pRaidans	Angle to use for calculation.
		 * @return	Approximative sin value.
		 */
		/*
		public static function sin( pRaidans : Number ) : Number {
			var result : Number;
			
			pRaidans = wrapAngle( pRaidans );
			
			//compute sine
			if ( pRaidans < 0 ) {
				result = 1.27323954 * pRaidans + .405284735 * pRaidans * pRaidans;
				
				if ( result < 0 )
					result = .225 * ( result * -result - result ) + result;
				else
					result = .225 * ( result * result - result ) + result;
			} else {
				result = 1.27323954 * pRaidans - 0.405284735 * pRaidans * pRaidans;
				
				if ( result < 0 )
					result = .225 * ( result * -result - result ) + result;
				else
					result = .225 * ( result * result - result ) + result;
			}
			
			return result;
		}
		*/
		
		/**
		 * Uses quick and approximate algorithm to get cos value.
		 * @see http://lab.polygonal.de/?p=205
		 * @param	pRaidans	Angle to use for calculation.
		 * @return	Approximative cos value.
		 */
		/*
		public static function cos( pRaidans : Number ) : Number {
			var result : Number;
			
			// only difference from sin is start angle
			pRaidans += HALF_PI;
			pRaidans = wrapAngle( pRaidans );
			
			//compute cosine
			if ( pRaidans < 0 ) {
				result = 1.27323954 * pRaidans + 0.405284735 * pRaidans * pRaidans;
				
				if ( result < 0 )
					result = .225 * ( result * -result - result ) + result;
				else
					result = .225 * ( result * result - result ) + result;
			} else {
				result = 1.27323954 * pRaidans - 0.405284735 * pRaidans * pRaidans;
				
				if ( result < 0 )
					result = .225 * ( result * -result - result ) + result;
				else
					result = .225 * ( result * result - result ) + result;
			}
			return result;
		}
		*/
		
	
	}

}