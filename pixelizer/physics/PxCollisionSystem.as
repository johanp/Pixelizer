package pixelizer.physics {
	import flash.geom.Point;
	import pixelizer.components.collision.PxBoxColliderComponent;
	import pixelizer.components.collision.PxColliderComponent;
	import pixelizer.components.collision.PxGridColliderComponent;
	import pixelizer.components.PxBodyComponent;
	import pixelizer.physics.PxCollisionSolver;
	import pixelizer.physics.PxCollisionData;
	import pixelizer.PxScene;
	import pixelizer.systems.PxSystem;
	import pixelizer.utils.PxCollisionStats;
	
	/**
	 * Manages collision between colliders of all types. Each scene has their own collision manager.
	 * @author Johan Peitz
	 */
	public class PxCollisionSystem extends PxSystem {
		
		private var _colliders : Array = [];
		private var _overlap : Point = new Point();
		
		/**
		 * Stats collected during collision tests.
		 */
		public var collisionStats : PxCollisionStats;
		
		/**
		 * Creates a new collision system.
		 */
		public function PxCollisionSystem( pScene : PxScene, pPriority : int = 0 ) : void {
			super( pScene, pPriority );
			
			collisionStats = new PxCollisionStats();
		}
		
		/**
		 * Clears all resources used by this system.
		 */
		override public function dispose() : void {
			_colliders = null;
			super.dispose();
		}
		

		/**
		 * Adds a collider to the system. The collider will now be check for collision against other colliders.
		 * @param	pCollider	Collider to add.
		 */
		public function addCollider( pCollider : PxColliderComponent ) : void {
			_colliders.push( pCollider );
		}
		
		/**
		 * Removes a collider from the system. It will no longer collide with other colliders.
		 * @param	pCollider	Collider to remove.
		 */
		public function removeCollider( pCollider : PxColliderComponent ) : void {
			_colliders.splice( _colliders.indexOf( pCollider ), 1 );
		}
		
		
		/**
		 * Invoked regularly by the scene. Detects and responds to all collisions between colliders.
		 * @param	pDT
		 */
		override public function update( pDT : Number ) : void {
			var a : PxColliderComponent;
			var b : PxColliderComponent;
			var len : int = _colliders.length;
			var collisionDataA : PxCollisionData = new PxCollisionData();
			var collisionDataB : PxCollisionData = new PxCollisionData();
			
			collisionStats.reset();
			collisionStats.colliderObjects = len;
			
			for ( var i : int = 0; i < len; i++ ) {
				a = _colliders[ i ];
				for ( var j : int = i + 1; j < len; j++ ) {
					b = _colliders[ j ];
					collisionStats.collisionTests++;
					
					if (( a.collisionLayerMask & b.collisionLayer ) || ( a.collisionLayer & b.collisionLayerMask ) ) {
						collisionStats.collisionMasks++;
						
						collisionDataA.myCollider = a;
						collisionDataA.otherCollider = b;
						collisionDataA.overlap = detectAndResolveCollision( a, b );
						
						collisionDataB.myCollider = b;
						collisionDataB.otherCollider = a;
						collisionDataB.overlap = collisionDataA.overlap;
						
						if ( collisionDataA.overlap != null ) {
							collisionStats.collisionHits++;
							if ( a.hasCollidingCollider( b ) ) {
								a.onCollisionOngoing( collisionDataA );
								b.onCollisionOngoing( collisionDataB );
							} else {
								a.onCollisionStart( collisionDataA );
								b.onCollisionStart( collisionDataB );
								
								a.addCollidingCollider( b );
								b.addCollidingCollider( a );
							}
						} else {
							if ( a.hasCollidingCollider( b ) ) {
								a.onCollisionEnd( collisionDataA );
								b.onCollisionEnd( collisionDataB );
								
								a.removeCollidingCollider( b );
								b.removeCollidingCollider( a );
							}
						}
					}
				}
			}
			
			collisionDataA.dispose();
			collisionDataB.dispose();
		}
		
		protected function detectAndResolveCollision( a : PxColliderComponent, b : PxColliderComponent ) : Point {
			var c : PxColliderComponent;
			if ( a is PxGridColliderComponent ) {
				c = a;
				a = b;
				b = c;
			}
			
			if ( a is PxBoxColliderComponent ) {
				if ( b is PxBoxColliderComponent ) {
					return boxToBox( a as PxBoxColliderComponent, b as PxBoxColliderComponent );
				} else if ( b is PxGridColliderComponent ) {
					return boxToGrid( a as PxBoxColliderComponent, b as PxGridColliderComponent );
				}
			}
			
			return null;
		}
		
		private function boxToBox( a : PxBoxColliderComponent, b : PxBoxColliderComponent ) : Point {
			var _overlap : Point = PxCollisionSolver.boxBoxOverlap( a, b );
			if ( _overlap.x == 0 || _overlap.y == 0 ) {
				// overlaps only on one axis, no collision!
				return null;
			}
			
			// push in the smallest direction (if both boxes are solid)
			if ( a.solid && b.solid ) {
				if ( Math.abs( _overlap.x ) > Math.abs( _overlap.y ) ) {
					a.entity.transform.position.y -= _overlap.y / 2;
					b.entity.transform.position.y += _overlap.y / 2;
				} else {
					a.entity.transform.position.x -= _overlap.x / 2;
					b.entity.transform.position.x += _overlap.x / 2;
				}
			}
			
			return _overlap;
		}
		
		private function boxToGrid( a : PxBoxColliderComponent, b : PxGridColliderComponent ) : Point {
			var collision : Boolean = false;
			var bodyComp : PxBodyComponent;
			
			var overlap : Point;
			
			var nextPosition : Point = a.entity.transform.position.clone();
			
			var resolveCollision : Boolean = a.solid && b.solid;
			
			if ( resolveCollision ) {
				bodyComp = a.entity.getComponentByClass( PxBodyComponent ) as PxBodyComponent;
				if ( bodyComp != null ) {
					a.entity.transform.position.x = bodyComp.lastPosition.x;
				}
			}
			
			_overlap.x = _overlap.y = 0;
			
			// vertical test
			overlap = PxCollisionSolver.boxGridOverlap( a, b, PxCollisionSolver.VERTICAL );
			if ( overlap.y != 0 ) {
				collision = true;
				_overlap.y = overlap.y;
				
				if ( resolveCollision ) {
					a.entity.transform.position.y += overlap.y;
					if ( bodyComp != null ) {
						bodyComp.velocity.y = 0;
					}
				}
			}
			
			// horizontal test
			a.entity.transform.position.x = nextPosition.x;
			overlap = PxCollisionSolver.boxGridOverlap( a, b, PxCollisionSolver.HORIZONTAL );
			if ( overlap.x != 0 ) {
				collision = true;
				_overlap.x = overlap.x;
				
				if ( resolveCollision ) {
					a.entity.transform.position.x += overlap.x;
					if ( bodyComp != null ) {
						bodyComp.velocity.x = 0;
					}
				}
			}
			
			if ( collision ) {
				return _overlap;
			}
		
			return null;
		}	
	}

}