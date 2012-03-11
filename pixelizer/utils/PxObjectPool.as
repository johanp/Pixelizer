package pixelizer.utils {
	
	/**
	 * A standard object pool to get rid of inefficient instanciation.
	 * @author Johan Peitz
	 */
	public class PxObjectPool {
		private var _objectClass : Class;
		private var _objects : Array;
		
		/**
		 * Constructs a new object pool of the desired type.
		 * @param	pClass	The class that this pool should keep.
		 * @param	pInitialSize	Initial size of pool.
		 */
		public function PxObjectPool( pClass : Class, pInitialSize : int = 0 ) {
			_objectClass = pClass;
			_objects = [];
			for ( var i : int = 0; i < pInitialSize; i++ ) {
				_objects.push( new _objectClass() );
			}
		}
		
		/**
		 * Returns an instanciated class. If the pool is empty, a new instance will be created.
		 * If there are instances in the pool, one of them will be returned.
		 * @param	pFunction	Function to apply to object. Can be used to reset values.
		 * @param	pArgs	Arguments to pass to above function.
		 * @return	An instanciated class of the pool's type.
		 */
		public function fetch( pFunction : String = null, pArgs : Array = null ) : * {
			var obj : *;
			
			if ( _objects.length > 0 ) {
				obj = _objects.pop();
			} else {
				obj = new _objectClass();
			}
			
			if ( pFunction != null ) {
				obj[ pFunction ].apply( obj, pArgs );
			}
			
			return obj;
		}
		
		/**
		 * Recycles an object. Usually it was fetched from the pool earlier, but that's not needed.
		 * @param	pObject
		 */
		public function recycle( pObject : * ) : void {
			_objects.push( pObject );
		}
		
		/**
		 * Clears the pool of all instances. No dispose or any other functions are applied to the objects.
		 */
		public function purge() : void {
			_objects = [];
		}
		
		/**
		 * Returns the size of the pool.
		 * @return Size of pool.
		 */
		public function get size() : int {
			return _objects.length;
		}
	
	}
}

