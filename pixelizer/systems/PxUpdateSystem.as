package pixelizer.systems {
	import pixelizer.PxEntity;
	import pixelizer.PxScene;
	import pixelizer.utils.PxMath;
	import pixelizer.utils.PxUpdateStats;
	
	/**
	 * The update system updates all entities in a scene.
	 * @author Johan Peitz
	 */
	public class PxUpdateSystem extends PxSystem {
		private var _updateStats : PxUpdateStats;
		
		/**
		 * Creates a new update system.
		 * @param	pScene	Scene on which to operate.
		 * @param	pPriority	When to be invoked in relation to other sytems.
		 */
		public function PxUpdateSystem( pScene : PxScene, pPriority : int = 0 ) {
			super( pScene, pPriority );
			_stats = _updateStats = new PxUpdateStats();
		}
		
		/**
		 * Resets update sats. Invoked automatically.
		 */
		override public function beforeUpdate() : void {
			_updateStats.reset();
		}
		
		/**
		 * Updates all entities.
		 * @param	pDT	Time passed.
		 */
		override public function update( pDT : Number ) : void {
			updateEntityTree( scene.entityRoot, pDT );
		}
		
		private function updateEntityTree( pEntity : PxEntity, pDT : Number ) : void {
			_updateStats.entitiesUpdated++;
			
			pEntity.update( pDT );
			
			for each ( var e : PxEntity in pEntity.entities ) {
				e.transform.rotationOnScene = pEntity.transform.rotationOnScene + e.transform.rotation;
				
				e.transform.scaleXOnScene = pEntity.transform.scaleXOnScene * e.transform.scaleX;
				e.transform.scaleYOnScene = pEntity.transform.scaleYOnScene * e.transform.scaleY;
				
				e.transform.positionOnScene.x = pEntity.transform.positionOnScene.x;
				e.transform.positionOnScene.y = pEntity.transform.positionOnScene.y;
				
				if ( e.transform.rotationOnScene == 0 ) {
					e.transform.positionOnScene.x += e.transform.position.x * pEntity.transform.scaleXOnScene;
					e.transform.positionOnScene.y += e.transform.position.y * pEntity.transform.scaleXOnScene;
				} else {
					var d : Number = Math.sqrt( e.transform.position.x * e.transform.position.x + e.transform.position.y * e.transform.position.y );
					var a : Number = Math.atan2( e.transform.position.y, e.transform.position.x ) + pEntity.transform.rotationOnScene;
					e.transform.positionOnScene.x += d * Math.cos( a ) * pEntity.transform.scaleXOnScene;
					e.transform.positionOnScene.y += d * Math.sin( a ) * pEntity.transform.scaleYOnScene;
				}
				
				updateEntityTree( e, pDT );
			}
			
			if ( pEntity.destroy ) {
				pEntity.parent.removeEntity( pEntity );
			}
		}
	
	}

}