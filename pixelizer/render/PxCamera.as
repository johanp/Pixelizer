package pixelizer.render {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import pixelizer.Pixelizer;
	import pixelizer.PxEntity;
	
	/**
	 * The camera decides what part and size of the scene will be rendered.
	 * @author Johan Peitz
	 */
	public class PxCamera {
		private var _view : Rectangle = null;
		private var _bounds : Rectangle = null;
		private var _lookAt : Point = null;
		private var _lookOffset : Point = null;
		private var _targetEntity : PxEntity = null;
		
		/**
		 * Current center of camera.
		 */
		public var center : Point;
		
		/**
		 * Creates a new camera.
		 * @param	pWidth	Width of view.
		 * @param	pHeight	Height of view.
		 * @param	pOffsetX	Amount to offset the camera along th X axis.
		 * @param	pOffsetY	Amount to offset the camera along th Y axis.
		 */
		public function PxCamera( pWidth : int = 0, pHeight : int = 0, pOffsetX : int = 0, pOffsetY : int = 0 ) {
			if ( pWidth == 0 || pHeight == 0 ) {
				pWidth = Pixelizer.engine.width;
				pHeight = Pixelizer.engine.height;
			}
			_view = new Rectangle( 0, 0, pWidth, pHeight );
			_bounds = null;
			_lookAt = new Point();
			_lookOffset = new Point( pOffsetX, pOffsetY );
			center = new Point();
		}
		
		/**
		 * Clears all resources used by the camera.
		 */
		public function dispose() : void {
			_view = null;
			_bounds = null;
			_lookAt = null;
			_targetEntity = null;
			center = null;
		}
		
		/**
		 * Sets the bounding rectangle for the camera. The camera will not be able to move outside the bounds.
		 * @param	pTopLeft	Top left corner of restricting rectangle.
		 * @param	pBottomRight	Bottom right corner of restricting rectangle.
		 */
		public function setBounds( pTopLeft : Point, pBottomRight : Point ) : void {
			_bounds = new Rectangle( pTopLeft.x, pTopLeft.y, pBottomRight.x - pTopLeft.x, pBottomRight.y - pTopLeft.y );
		}
		
		/**
		 * Sets the camera to track a certain entity.
		 * @param	pEntity
		 */
		public function track( pEntity : PxEntity ) : void {
			_targetEntity = pEntity;
		}
		
		/**
		 * Invoked regularly by the scene the camera belogns to. Updates camera postion.
		 * @param	pDT
		 */
		public function update( pDT : Number ) : void {
			if ( _targetEntity != null ) {
				_lookAt.x = Math.round( _targetEntity.transform.position.x );
				_lookAt.y = Math.round( _targetEntity.transform.position.y );
				lookAt( _lookAt );
			}
			
			center.x = _view.x - _lookOffset.x;
			center.y = _view.y - _lookOffset.y;
		}
		
		/**
		 * Sets the camera to look at a specific position.
		 * @param	pPos	Position to look at.
		 */
		public function lookAt( pPos : Point ) : void {
			_view.x = int( pPos.x + _lookOffset.x );
			_view.y = int( pPos.y + _lookOffset.y );
			
			if ( _bounds != null ) {
				if ( _view.x < _bounds.x )
					_view.x = _bounds.x;
				if ( _view.right > _bounds.right )
					_view.x = _bounds.right - _view.width;
				
				if ( _view.y < _bounds.y )
					_view.y = _bounds.y;
				if ( _view.bottom > _bounds.bottom )
					_view.y = _bounds.bottom - _view.height;
			}
		}
		
		/**
		 * Returns the camera's current view.
		 * @return The current view.
		 */
		public function get view() : Rectangle {
			return _view;
		}
	
	}
}