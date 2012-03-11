package pixelizer.components {
	import flash.geom.Point;
	import pixelizer.Pixelizer;
	
	/**
	 * Holds each entites transform data such as position, rotation and scale.
	 * Every entity has one of there by default.
	 * @author Johan Peitz
	 */
	public class PxTransformComponent extends PxComponent {
		/**
		 * Local position in relation to the entitie's parent. (The scene, or another entity.(
		 */
		public var position : Point;
		/**
		 * Position on the scene.
		 */
		public var globalPosition : Point;
		/**
		 * Local position from last frame.
		 */
		public var lastPosition : Point;
		/**
		 * The entity's rotation in radians.
		 */
		public var rotation : Number = 0;
		/**
		 * What offset from hotspot to rotate the around.
		 */
		public var pivotOffset : Point = null;
		/**
		 * The entity's X scale.
		 */
		public var scaleX : Number = 1;
		/**
		 * The entity's Y scale.
		 */
		public var scaleY : Number = 1;
		
		public var scrollFactorX : Number = 1;
		public var scrollFactorY : Number = 1;
		
		/**
		 * Constructs a new transform component and sets the postion.
		 * @param	pX	X position.
		 * @param	pY	Y position.
		 */
		public function PxTransformComponent( pX : int = 0, pY : int = 0 ) {
			super();
			globalPosition = Pixelizer.pointPool.fetch();
			globalPosition.x = globalPosition.y = 0;
			
			pivotOffset = Pixelizer.pointPool.fetch();
			pivotOffset.x = pivotOffset.y = 0;
			
			position = Pixelizer.pointPool.fetch();
			position.x = pX;
			position.y = pY;
			
			lastPosition = Pixelizer.pointPool.fetch();
			lastPosition.x = pX;
			lastPosition.y = pY;
		}
		
		/**
		 * Clears all resources used by this component.
		 */
		override public function dispose() : void {
			Pixelizer.pointPool.recycle( globalPosition );
			globalPosition = null;
			
			Pixelizer.pointPool.recycle( lastPosition );
			lastPosition = null;
			
			Pixelizer.pointPool.recycle( position );
			position = null;
			
			Pixelizer.pointPool.recycle( pivotOffset )
			pivotOffset = null;
			
			super.dispose();
		}
		
		/**
		 * Sets the postion in the transform.
		 * @param	pX	X position.
		 * @param	pY	Y position.
		 */
		public function setPosition( pX : Number, pY : Number ) : void {
			position.x = pX;
			position.y = pY;
		}
		
		/**
		 * Sets the scale for both X and Y.
		 */
		public function set scale( pScale : Number ) : void {
			scaleX = scaleY = pScale;
		}
	
	}

}