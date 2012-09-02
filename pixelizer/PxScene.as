package pixelizer {
	import __AS3__.vec.Vector;
	import flash.system.System;
	import pixelizer.components.collision.PxColliderComponent;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.IPxEntityContainer;
	import pixelizer.physics.PxCollisionSystem;
	import pixelizer.render.PxBlitRenderSystem;
	import pixelizer.render.PxCamera;
	import pixelizer.sound.PxSoundSystem;
	import pixelizer.systems.PxSystem;
	import pixelizer.systems.PxUpdateSystem;
	import pixelizer.utils.PxMath;
	
	/**
	 * The scene holds and manages all entities. Scenes are updated by the engine.
	 *
	 * @author Johan Peitz
	 */
	public class PxScene implements IPxEntityContainer {
		private var _entityRoot : PxEntity;
		
		/**
		 * Systems running on current scene.
		 */
		private var _systems : Array;
		protected var _renderSystem : PxBlitRenderSystem;
		protected var _collisionSystem : PxCollisionSystem;
		protected var _soundSystem : PxSoundSystem;
		protected var _inputSystem: PxInputSystem;
		
		private var _mainCamera : PxCamera;
		
		public var framesPassed  : int;
		public var secondsPassed : Number;
		
		/**
		 * Specifies whether the scene has a background fill.
		 */
		public var background : Boolean = true;
		/**
		 * The color of the backround, if any.
		 */
		public var backgroundColor : int = 0xFFFFFF;
		/**
		 * Engine scene is added to.
		 */
		public var engine : PxEngine = null;
		
		/**
		 * Constructs a new scene.
		 * @param	pTransparent	Sets wether underlying scenes will be visible or not.
		 */
		public function PxScene( pTransparent : Boolean = false ) {
			_entityRoot = new PxEntity();
			_entityRoot.scene = this;
			
			_systems = [];
			_renderSystem = addSystem( new PxBlitRenderSystem( this, 1000, pTransparent ) ) as PxBlitRenderSystem;
			_inputSystem = addSystem( new PxInputSystem( this, 100 ) ) as PxInputSystem;
			addSystem( new PxUpdateSystem( this, 150 ) );
			_collisionSystem = addSystem( new PxCollisionSystem( this, 200 ) ) as PxCollisionSystem;
			_soundSystem = addSystem( new PxSoundSystem( this, 300 ) ) as PxSoundSystem;
			
			_mainCamera = new PxCamera( Pixelizer.engine.width, Pixelizer.engine.height, -Pixelizer.engine.width / 2, -Pixelizer.engine.height / 2 );
			
			framesPassed = 0;
			secondsPassed = 0;
		}
		
		/**
		 * Cleans up all resources used by the scene, including any added entities which will also be disposed.
		 */
		public function dispose() : void {

			_entityRoot.dispose();
			_entityRoot = null;
			
			_mainCamera.dispose();
			_mainCamera = null;
			
			for each ( var s : PxSystem in _systems ) {
				s.dispose();
			}
			_systems = null;

			engine = null;
		}
		
		/**
		 * Invoked when the scene is added to the engine.
		 * @param	pEngine	The engine the scene is added to.
		 */
		public function onAddedToEngine( pEngine : PxEngine ) : void {
			engine = pEngine;
		}
		
		/**
		 * Invoked when the scene is remove from an engine. Disposes the scene.
		 */
		public function onRemovedFromEngine() : void {
			engine = null;
			dispose();
		}
		
		public function onActivated():void 
		{
			_soundSystem.unpause();
			_inputSystem.reset();
		}
		
		public function onDeactivated():void 
		{
			_soundSystem.pause();
		}
		
		
		/**
		 * Invoked regularly by the engine. Updates all entities and subsystems.
		 * @param	pDT	Time step in number of seconds.
		 */
		public function update( pDT : Number ) : void {
			var s : PxSystem;
			// update all systems
			for each ( s in _systems ) {
				s.beforeUpdate( );
			}

			// update entities
			// TODO: this should also be a system!
			//updateEntityTree( _entityRoot, pDT );
			
			for each ( s in _systems ) {
				s.update( pDT );
			}
			
			if ( _mainCamera != null ) {
				_mainCamera.update( pDT );
			}
		
			for each ( s in _systems ) {
				s.afterUpdate( );
			}
			
			secondsPassed += pDT;
			framesPassed ++;
			
		}
		
		
		public function render() : void {
			var s : PxSystem;
			for each ( s in _systems ) {
				s.beforeRender( );
			}
			
			for each ( s in _systems ) {
				s.render( );
			}
			
			for each ( s in _systems ) {
				s.afterRender( );
			}
			
		}

		
		/**
		 * Returns the camera for this scene.
		 */
		public function get camera() : PxCamera {
			return _mainCamera;
		}
		
		/**
		 * Returns the root entity to which all other entities are added.
		 * @return 	The root entity.
		 */
		public function get entityRoot() : PxEntity {
			return _entityRoot;
		}
		
		public function get collisionSystem() : PxCollisionSystem {
			return _collisionSystem;
		}
		
		public function get soundSystem() : PxSoundSystem {
			return _soundSystem;
		}
		
		public function get inputSystem():PxInputSystem 
		{
			return _inputSystem;
		}
		
		public function get renderSystem():PxBlitRenderSystem 
		{
			return _renderSystem;
		}
		
		/**
		 * Adds and entity to the scene.
		 * @param	pEntity The entity to add.
		 * @return	The entity parameter passed as argument.
		 */
		public function addEntity( pEntity : PxEntity, pHandle : String = "" ) : PxEntity {
			return _entityRoot.addEntity( pEntity, pHandle );
		}
		
		/**
		 * Removes an entity from the scene. The entity will be disposed.
		 * @param	pEntity	The entity to remove.
		 * @return	The entity parameter passed as argument.
		 */
		public function removeEntity( pEntity : PxEntity ) : PxEntity {
			return _entityRoot.removeEntity( pEntity );
		}
		
		/**
		 * Adds entities of the desired class to the specified vector.
		 * @param	pRootEntity		Root entity of where to start the search. ( E.g. scene.entityRoot )
		 * @param	pEntityClass	The entity class to look for.
		 * @param	pEntityVector	Vector to populate with the results.
		 */
		public function getEntitesByClass( pRootEntity : PxEntity, pEntityClass : Class, pEntityVector : Vector.<PxEntity> ) : void {
			return _entityRoot.getEntitesByClass( pRootEntity, pEntityClass, pEntityVector );
		}
		
		/**
		 * Adds entities with the specified handle to the specified vector.
		 * @param	pRootEntity	Root entity of where to start the search. ( E.g. scene.entityRoot )
		 * @param	pHandle	Handle to look for.
		 * @param	pEntityVector	Vector to populate with the results.
		 */
		public function getEntitiesByHandle( pRootEntity : PxEntity, pHandle : String, pEntityVector : Vector.<PxEntity> ) : void {
			return _entityRoot.getEntitiesByHandle( pRootEntity, pHandle, pEntityVector );
		}
		
		public function forEachEntity( pEntityRoot : PxEntity, pFunction : Function ) : void {
			pFunction( pEntityRoot );
			for each ( var e : PxEntity in pEntityRoot.entities ) {
				forEachEntity( e, pFunction );
			}
		}
		
		public function removeSystem( pSystem : PxSystem ) : PxSystem {
			_systems.splice( _systems.indexOf( pSystem ), 1 );
			return pSystem;
		}
	
		public function addSystem( pSystem : PxSystem ) : PxSystem {
			_systems.push( pSystem );
			_systems.sort( PxSystem.sortOnPriority );
			return pSystem;
		}
		
		public function getSystems():Array 
		{
			return _systems;
		}
		
		
	
	}
}