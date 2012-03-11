package pixelizer {
	import __AS3__.vec.Vector;
	import flash.events.EventDispatcher;
	import pixelizer.components.PxComponent;
	import pixelizer.components.PxTransformComponent;
	import pixelizer.IPxEntityContainer;
	import pixelizer.PxScene;
	
	/**
	 * Base base class for all entities. Entites have to be added to scenes
	 * in order to be updated. Entities can also be nested.
	 *
	 * @author Johan Peitz
	 */
	public class PxEntity extends EventDispatcher implements IPxEntityContainer {
		private var _destroyInSeconds : Number = -1;
		private var _destroy : Boolean = false;
		
		/**
		 * Scene this entity is added to.
		 */
		public var scene : PxScene;
		
		/**
		 * Transform of this entity.
		 */
		public var transform : PxTransformComponent;
		
		/**
		 * Parent of entity in tree hierarchy.
		 */
		public var parent : IPxEntityContainer = null;
		/**
		 * Handle for quick access.
		 */
		public var handle : String;
		
		private var _components : Vector.<PxComponent>;
		private var _entities : Vector.<PxEntity>;
		private var _entitiesToAdd : Vector.<PxEntity>;
		private var _entitiesToRemove : Vector.<PxEntity>;
		
		private var _onRemovedCallbacks : Vector.<Function>;
		
		/**
		 * Creates a new entity at desired postion.
		 *
		 * @param	pX	X position of entity.
		 * @param	pY	Y position of entity.
		 */
		public function PxEntity( pX : int = 0, pY : int = 0 ) {
			_components = new Vector.<PxComponent>;
			_entities = new Vector.<PxEntity>;
			_entitiesToAdd = new Vector.<PxEntity>;
			_entitiesToRemove = new Vector.<PxEntity>;
			//_entitiesByHandle = new Dictionary();
			
			_onRemovedCallbacks = new Vector.<Function>;
			
			transform = addComponent( new PxTransformComponent( pX, pY ) ) as PxTransformComponent;
		}
		
		/**
		 * Disposes the entity and it's components. All nested entites are also disposed.
		 */
		public function dispose() : void {
			
			removeEntitiesFromQueue();
			_entitiesToRemove = null;
			
			addEntitiesFromQueue();
			_entitiesToAdd = null;
			
			for each ( var e : PxEntity in _entities ) {
				e.dispose();
			}
			
			for each ( var c : PxComponent in _components ) {
				c.dispose();
			}
			_components = null;
			
			scene = null;
			
			_onRemovedCallbacks = null;
		
		}
		
		/**
		 * Invoked when entity is added to a scene.
		 *
		 * @param	pScene	Scene which the entity was just added to.
		 */
		public function onAddedToScene( pScene : PxScene ) : void {
			scene = pScene;
			for each ( var c : PxComponent in _components ) {
				c.onEntityAddedToScene( scene );
			}
			
			for each ( var e : PxEntity in _entities ) {
				e.onAddedToScene( scene );
			}
		
		}
		
		/**
		 * Invoked when entity is removed from a scene.
		 */
		public function onRemovedFromScene() : void {
			for each ( var f : Function in _onRemovedCallbacks ) {
				f( this );
			}
			_onRemovedCallbacks = new Vector.<Function>;
			
			for each ( var c : PxComponent in _components ) {
				c.onEntityRemovedFromScene();
			}
			
			for each ( var e : PxEntity in _entities ) {
				e.onRemovedFromScene();
			}
			
			scene = null;
		}
		
		/**
		 * Tells the entity to destroy itself in x number of seconds.
		 * Once destroyed the entity will be disposed.
		 *
		 * @param	pSeconds	Number of second until destruction.
		 */
		public function destroyIn( pSeconds : Number ) : void {
			if ( _destroyInSeconds < 0 ) {
				_destroyInSeconds = pSeconds;
			}
		}
		
		/**
		 * Adds a component to the entity.
		 *
		 * @param	pComponent	Component to add.
		 * @return	The component parameter passed as argument.
		 */
		public function addComponent( pComponent : PxComponent ) : PxComponent {
			_components.push( pComponent );
			_components.sort( sortOnPriority );
			pComponent.onAddedToEntity( this );
			
			if ( scene != null ) {
				pComponent.onEntityAddedToScene( scene );
			}
			
			return pComponent;
		}
		
		/**
		 * Removes a component from the entity. The component will NOT be disposed.
		 * @param	pComponent	Component to remove.
		 * @return	The component paramater passed as argument.
		 */
		public function removeComponent( pComponent : PxComponent ) : PxComponent {
			if ( scene != null ) {
				pComponent.onEntityRemovedFromScene();
			}
			
			_components.splice( _components.indexOf( pComponent ), 1 );
			pComponent.onRemovedFromEntity();
			
			return pComponent;
		}
		
		private function sortOnPriority( a : PxComponent, b : PxComponent ) : int {
			return a.priority - b.priority;
		}
		
		/**
		 * Adds an entity to the entity, extending the entity tree hierarchy.
		 * @param	pEntity	Entity to add.
		 * @return	The entity parameter passed as argument.
		 */
		public function addEntity( pEntity : PxEntity, pHandle : String = "" ) : PxEntity {
			pEntity.handle = pHandle;
			_entitiesToAdd.push( pEntity );
			
			return pEntity;
		}
		
		/**
		 * Removes an entity from the entity.
		 * @param	pEntity Entity to remove. The entity will be disposed.
		 * @return	The entity parameter passed as argument.
		 */
		public function removeEntity( pEntity : PxEntity ) : PxEntity {
			_entitiesToRemove.push( pEntity );
			
			return pEntity;
		}
		
		/**
		 * Adds entities with the specified handle to the specified vector.
		 * @param	pRootEntity	Root entity of where to start the search. ( E.g. scene.entityRoot )
		 * @param	pHandle	Handle to look for.
		 * @param	pEntityVector	Vector to populate with the results.
		 */
		public function getEntitiesByHandle( pRootEntity : PxEntity, pHandle : String, pEntityVector : Vector.<PxEntity> ) : void {
			if ( pRootEntity.handle == pHandle ) {
				pEntityVector.push( pRootEntity );
			}
			for each ( var e : PxEntity in pRootEntity.entities ) {
				getEntitiesByHandle( e, pHandle, pEntityVector );
			}
		}
		
		/**
		 * Adds entities of the desired class to the specified vector.
		 * @param	pRootEntity		Root entity of where to start the search. ( E.g. scene.entityRoot )
		 * @param	pEntityClass	The entity class to look for.
		 * @param	pEntityVector	Vector to populate with the results.
		 */
		public function getEntitesByClass( pRootEntity : PxEntity, pEntityClass : Class, pEntityVector : Vector.<PxEntity> ) : void {
			if ( pRootEntity is pEntityClass ) {
				pEntityVector.push( pRootEntity );
			}
			for each ( var e : PxEntity in pRootEntity.entities ) {
				getEntitesByClass( e, pEntityClass, pEntityVector );
			}
		}
		
		/**
		 * Invoked regularly by the scene. Updates all components and nested entities in the entity.
		 * @param	pDT	Time step in number of seconds.
		 */
		public function update( pDT : Number ) : void {
			var pos : int;
			var c : PxComponent;
			
			// add entities
			addEntitiesFromQueue();
			
			pos = _components.length;
			while ( --pos >= 0 ) {
				c = _components[ pos ];
				c.update( pDT );
			}
			
			// remove entities
			removeEntitiesFromQueue();
			
			// destroy entity
			if ( _destroyInSeconds >= 0 ) {
				_destroyInSeconds -= pDT;
				if ( _destroyInSeconds <= 0 ) {
					_destroy = true;
				}
			}
		}
		
		private function addEntitiesFromQueue() : void {
			var e : PxEntity;
			if ( _entitiesToAdd.length > 0 ) {
				for each ( e in _entitiesToAdd ) {
					_entities.push( e );
					e.parent = this;
					if ( scene != null ) {
						e.onAddedToScene( scene );
					}
				}
				_entitiesToAdd = new Vector.<PxEntity>;
			}
		}
		
		private function removeEntitiesFromQueue() : void {
			var pos : int = _entitiesToRemove.length;
			var e : PxEntity;
			if ( pos > 0 ) {
				while ( --pos >= 0 ) {
					e = _entitiesToRemove[ pos ];
					_entities.splice( _entities.indexOf( e ), 1 );
					e.onRemovedFromScene();
					e.dispose();
				}
				_entitiesToRemove = new Vector.<PxEntity>;
			}
		}
		
		/**
		 * Tells wether the entity already has a component of a certain class.
		 * @param	pClass	Component class to check.
		 * @return	True if the entity has a component of this class. False otherwise.
		 */
		public function hasComponentByClass( pClass : Class ) : Boolean {
			for each ( var c : PxComponent in _components ) {
				if ( c is pClass ) {
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * Returns the first found (if any) component of a certain class.
		 * @param	pClass	Component class to look for.
		 * @return	First instance found of requested class. Or null if no such class found.
		 */
		public function getComponentByClass( pClass : Class ) : PxComponent {
			for each ( var c : PxComponent in _components ) {
				if ( c is pClass ) {
					return c;
				}
			}
			
			return null;
		}
		
		/**
		 * Returns all components of a certain class.
		 * @param	pClass	Component class to look for.
		 * @return	Vector of components.
		 */
		public function getComponentsByClass( pClass : Class ) : Vector.<PxComponent> {
			var v : Vector.<PxComponent> = new Vector.<PxComponent>;
			for each ( var c : PxComponent in _components ) {
				if ( c is pClass ) {
					v.push( c );
				}
			}
			
			return v;
		}
		
		/**
		 * Adds a function which will be called when this entity is removed from the scene.
		 * @param	pFunction	Function to call.
		 */
		public function addOnRemovedCallback( pFunction : Function ) : void {
			_onRemovedCallbacks.push( pFunction );
		}
		
		/**
		 * Returns all entities added to this entity.
		 * @return	Vector of entities.
		 */
		public function get entities() : Vector.<PxEntity> {
			return _entities;
		}
		
		/**
		 * Checks if entity wants to be destroyed or not.
		 * @return True if entity is listed to be destroyed.
		 */
		public function get destroy() : Boolean {
			return _destroy;
		}
	
	}
}

