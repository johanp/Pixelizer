package examples.platformer {
	import flash.geom.Point;
	import pixelizer.components.collision.PxBoxColliderComponent;
	import pixelizer.components.PxBodyComponent;
	import pixelizer.components.render.PxAnimationComponent;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.physics.PxCollisionData;
	import pixelizer.prefabs.PxActorEntity;
	import pixelizer.PxEntity;
	import pixelizer.render.PxSpriteSheet;
	import pixelizer.utils.PxMath;
	import pixelizer.utils.PxRepository;
	
	/**
	 * ...
	 * @author Johan Peitz
	 */
	public class GoodPickup extends PxActorEntity {
		
		[Embed( source="../assets/heart.mp3" )]
		private static var heartSoundCls : Class;

		public function GoodPickup() {
			super();
			
			animComp.spriteSheet = PxRepository.fetch( "pickups" );
			animComp.gotoAndPlay( "good" );
			
			// the body handles velocities 
			bodyComp.mass = 0;
			
			boxColliderComp.setSize( 16, 16 );
			boxColliderComp.solid = false;
			boxColliderComp.addToCollisionLayer( 1 );// pick ups
			boxColliderComp.registerCallbacks( onCollisionStart );
		
		}
		
		override public function dispose() : void {
			super.dispose();
		}
		
		override public function update( pDT : Number ) : void {
			bodyComp.velocity.x *= 0.9;
			bodyComp.velocity.y *= 0.9;
			
			super.update( pDT );
		}
		
		// collided with player
		private function onCollisionStart( pCollisionData : PxCollisionData ) : void {
			var dist : Number;
			var f : Number;
			var a : Number;
			var colors : Array = [ 0xFF5750, 0xCC2E29, 0xFFA9A6, 0xFFFFFF ];
			
			scene.soundSystem.play( new heartSoundCls(), transform.position );
			
			// emit particles
			for ( var i : int = 0; i < 50; i++ ) {
				var p : ExplosionParticle = new ExplosionParticle( 0.7 + Math.random() * 0.4, colors[( int )( Math.random() * 4 ) ] );
				p.transform.position.x = transform.position.x;
				p.transform.position.y = transform.position.y;
				parent.addEntity( p );
			}
			
			// push away bad pickups
			var bads : Vector.<PxEntity> = new Vector.<PxEntity>;
			scene.getEntitesByClass( scene.entityRoot, BadPickup, bads );
			for each ( var b : BadPickup in bads ) {
				dist = Point.distance( b.transform.position, transform.position );
				if ( dist < 150 ) {
					a = Math.atan2( b.transform.position.y - transform.position.y, b.transform.position.x - transform.position.x );
					f = 10000 / ( dist * dist );
					b.addVelocity( f * Math.cos( a ), f * Math.sin( a ) );
				}
			}
			
			// attract good pickups
			var goods : Vector.<PxEntity> = new Vector.<PxEntity>;
			scene.getEntitesByClass( scene.entityRoot, GoodPickup, goods );
			for each ( var g : GoodPickup in goods ) {
				dist = Point.distance( g.transform.position, transform.position );
				
				a = Math.atan2( g.transform.position.y - transform.position.y, g.transform.position.x - transform.position.x );
				f = 10000 / ( dist * dist );
				g.addVelocity( -f * Math.cos( a ), -f * Math.sin( a ) );
			}
			
			destroyIn( 0 );
		}
		
		public function addVelocity( pVX : Number, pVY : Number ) : void {
			bodyComp.velocity.x += pVX;
			bodyComp.velocity.y += pVY;
		}
	
	}

}