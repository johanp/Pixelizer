package examples.platformer {
	import examples.assets.AssetFactory;
	import pixelizer.components.collision.PxBoxColliderComponent;
	import pixelizer.components.PxBodyComponent;
	import pixelizer.components.render.PxAnimationComponent;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.physics.PxCollisionData;
	import pixelizer.prefabs.PxActorEntity;
	import pixelizer.PxEntity;
	import pixelizer.render.PxSpriteSheet;
	import pixelizer.sound.PxSoundManager;
	
	/**
	 * ...
	 * @author Johan Peitz
	 */
	public class BadPickup extends PxActorEntity {
		
		public function BadPickup() {
			super();
			
			// anim comp, to handle animations
			animComp.spriteSheet = PxSpriteSheet.fetch( "pickups" );
			animComp.gotoAndPlay( "bad" );
			
			bodyComp.mass = 0;
			
			boxColliderComp.setSize( 16, 16 );
			boxColliderComp.solid = false;
			boxColliderComp.collisionLayerMask = 0;
			boxColliderComp.registerCallbacks( onCollisionStart );
		
		}
		
		override public function dispose() : void {
			super.dispose();
		}
		
		public function addVelocity( pVX : Number, pVY : Number ) : void {
			bodyComp.velocity.x += pVX;
			bodyComp.velocity.y += pVY;
		}
		
		override public function update( pDT : Number ) : void {
			bodyComp.velocity.x *= 0.95;
			bodyComp.velocity.y *= 0.95;
			
			// explode if outside map
			if ( transform.position.x < 0 || transform.position.x > 624 || transform.position.y < 0 || transform.position.y > 224 ) {
				explode();
			}
			
			super.update( pDT );
		}
		
		// player has collided with entity
		private function onCollisionStart( pCollisionData : PxCollisionData ) : void {
			explode();
		}
		
		// launch particles and destroy self
		private function explode() : void {
			var colors : Array = [ 0x211421, 0x463947, 0x736973, 0x0 ];
			// emit particles
			for ( var i : int = 0; i < 50; i++ ) {
				var p : ExplosionParticle = new ExplosionParticle( 0.7 + Math.random() * 0.4, colors[( int )( Math.random() * 4 ) ] );
				p.transform.position.x = transform.position.x;
				p.transform.position.y = transform.position.y;
				parent.addEntity( p );
			}
			
			PxSoundManager.play( AssetFactory.explosionSound, transform.position );
			
			destroyIn( 0 );
		}
	
	}

}