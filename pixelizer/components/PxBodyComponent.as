package pixelizer.components {
	import flash.geom.Point;
	import pixelizer.Pixelizer;
	
	/**
	 * Allows an entity to respond to gravity, have velocity and location.
	 */
	public class PxBodyComponent extends PxComponent {
		/**
		 * Denotes that the body is on ground.
		 */
		public static const ON_GROUND : int = 0;
		/**
		 * Denotes that the body is in the air.
		 */
		public static const IN_AIR : int = 1;
		
		/**
		 * Current velocity of this body.
		 */
		public var velocity : Point;
		/**
		 * Mass of this body.
		 */
		public var mass : Number = 1;
		
		/**
		 * The location from last frame.
		 */
		public var lastLocation : int;
		/**
		 * Position from last frame.
		 */
		public var lastPosition : Point;
		
		private var _location : int = IN_AIR;
		private var _gravity : Point;
		
		/**
		 * Creates a new body component.
		 * @param	pMass	Mass of this body.
		 */
		public function PxBodyComponent( pMass : Number = 1 ) {
			mass = pMass;
			
			velocity = Pixelizer.pointPool.fetch();
			velocity.x = velocity.y = 0;
			
			lastPosition = Pixelizer.pointPool.fetch();
			lastPosition.x = lastPosition.y = 0;
			
			_gravity = Pixelizer.pointPool.fetch();
			_gravity.x = 0;
			_gravity.y = 1;
		}
		
		/**
		 * Clears all resources used.
		 */
		override public function dispose() : void {
			super.dispose();
			
			Pixelizer.pointPool.recycle( velocity );
			Pixelizer.pointPool.recycle( lastPosition );
			Pixelizer.pointPool.recycle( _gravity );
			
			velocity = null;
			lastPosition = null;
			_gravity = null;
		}
		
		/**
		 * Updates the entity with the velocity in the body.
		 * @param	pDT	Time step.
		 */
		override public function update( pDT : Number ) : void {
			super.update( pDT );
			
			lastLocation = _location;
			
			// gravity
			if ( location == IN_AIR ) {
				velocity.x += _gravity.x * mass;
				velocity.y += _gravity.y * mass;
			}
			
			// move in y
			lastPosition.y = entity.transform.position.y;
			entity.transform.position.y += velocity.y;
			
			// move in x
			lastPosition.x = entity.transform.position.x;
			entity.transform.position.x += velocity.x;
		}
		
		/**
		 * Returns location of this body.
		 * IN_AIR, ON_GROUND.
		 */
		public function get location() : int {
			return _location;
		}
		
		/**
		 * Sets the location of this body.
		 * IN_AIR, ON_GROUND.
		 */
		public function set location( value : int ) : void {
			lastLocation = _location;
			_location = value;
		}
		
		/**
		 * Sets the gravity for this body.
		 * @param	pX	Gravity along X.
		 * @param	pY	Gravity along Y.
		 */
		public function setGravity( pX : Number, pY : Number ) : void {
			_gravity.x = pX;
			_gravity.y = pY;
		}
		
		/**
		 * Sets the velocity for this body.
		 * @param	pVelX	X velocity.
		 * @param	pVelY	Y velocity.
		 */
		public function setVelocity( pVelX : Number, pVelY : Number ) : void {
			velocity.x = pVelX;
			velocity.y = pVelY;
		}
	
	}
}