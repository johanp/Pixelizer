package pixelizer.utils {
	import pixelizer.systems.PxSystemStats;
	
	/**
	 * Holder for stats collected during the collision phase.
	 * @author Johan Peitz
	 */
	public class PxCollisionStats extends PxSystemStats {
		/**
		 * Amount of collider objects there are.
		 */
		public var colliderObjects : int;
		/**
		 * Amount of tests where started.
		 */
		public var collisionTests : int;
		/**
		 * Amount of tests which passed the mask test.
		 */
		public var collisionMasks : int;
		/**
		 * Amount of tests which detected a collision.
		 */
		public var collisionHits : int;
		
		/**
		 * Resets the stats for a new round of testing.
		 */
		override public function reset() : void {
			colliderObjects = 0;
			collisionTests = 0;
			collisionMasks = 0;
			collisionHits = 0;
		}

		
		override public function toString() : String {
			var s : String = "";
			s += "Colliders: " + colliderObjects + "\n";
			s += "Collisions: " + collisionHits + "/" + collisionMasks + "/" + collisionTests;
			return s;
			
		}		
	}

}