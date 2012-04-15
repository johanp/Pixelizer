package pixelizer.components.render {
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import pixelizer.components.PxComponent;
	import pixelizer.Pixelizer;
	import pixelizer.utils.PxRenderStats;
	
	/**
	 * Allows for graphical output using the blit renderer.
	 * Can be animated using animation components.
	 */
	public class PxBlitRenderComponent extends PxComponent {
		
		private var _bufferTopLeft_ : Point;
		private var _globalTopLeft_ : Point;
		
		private var _alpha : Number = 1;
		
		private var _matrix : Matrix = null;
		private var _colorTransform : ColorTransform = null;
		private var _useColorTransform : int = 0;
		
		/**
		 * Offsets the bitmap data from the entities postion.
		 */
		public var hotspot : Point = null;
		/**
		 * Used by the animation component to allow for hotspots for different frames.
		 */
		public var renderOffset : Point = null;
		/**
		 * Bitmap data of this component. Holds the graphics.
		 */
		public var bitmapData : BitmapData = null;
		/**
		 * Specifies whether this bitmap data should render at all.
		 */
		public var visible : Boolean = true;
		
		/**
		 * Construcs a new blit render component.
		 * @param	pBitmapData	Bitmap data to use.
		 * @param	pHotspot	Initial hotspot.
		 */
		public function PxBlitRenderComponent( pBitmapData : BitmapData = null, pHotspot : Point = null ) : void {
			_bufferTopLeft_ = Pixelizer.pointPool.fetch();
			_globalTopLeft_ = Pixelizer.pointPool.fetch();
			
			renderOffset = Pixelizer.pointPool.fetch();
			renderOffset.x = renderOffset.y = 0;
			
			_matrix = Pixelizer.matrixPool.fetch();
			_colorTransform = new ColorTransform( );
			
			bitmapData = pBitmapData;
			
			hotspot = Pixelizer.pointPool.fetch();
			hotspot.x = hotspot.y = 0;

			if ( pBitmapData != null ) {
				hotspot.x = pBitmapData.width / 2;
				hotspot.y = pBitmapData.height / 2;
			}

			if ( pHotspot != null ) {
				hotspot.x = pHotspot.x;
				hotspot.y = pHotspot.y;
			} 
		
		}
		
		/**
		 * Clears all resources used.
		 */
		override public function dispose() : void {
			bitmapData = null;
			_colorTransform = null;
			
			Pixelizer.matrixPool.recycle( _matrix );
			_matrix = null;
			
			Pixelizer.pointPool.recycle( renderOffset )
			Pixelizer.pointPool.recycle( hotspot )
			Pixelizer.pointPool.recycle( _bufferTopLeft_ )
			Pixelizer.pointPool.recycle( _globalTopLeft_ )
			
			renderOffset = null;
			hotspot = null;
			_bufferTopLeft_ = null;
			_globalTopLeft_ = null;
			
			super.dispose();
		}
		
		/**
		 * Renders the component.
		 * @param	pView	Current scene view.
		 * @param	pBitmapData	Bitmap data to render on.
		 * @param	pOffset	Offset from top left.
		 * @param	pRenderStats	Render stats to update.
		 */
		public function render( pView : Rectangle, pBitmapData : BitmapData, pPosition : Point, pRotation : Number, pScaleX : Number, pScaleY : Number, pRenderStats : PxRenderStats ) : void {
			if ( !visible )
				return;
			
			pRenderStats.totalObjects++;
			
			_globalTopLeft_.x = pPosition.x - ( hotspot.x + renderOffset.x );
			_globalTopLeft_.y = pPosition.y - ( hotspot.y + renderOffset.y );
			
			// draw self
			if ( bitmapData != null ) {
				if ( _globalTopLeft_.x < pView.right ) {
					if ( _globalTopLeft_.x + bitmapData.width >= pView.left ) {
						if ( _globalTopLeft_.y < pView.bottom ) {
							if ( _globalTopLeft_.y + bitmapData.height >= pView.top ) {
								_bufferTopLeft_.x = _globalTopLeft_.x - pView.x;
								_bufferTopLeft_.y = _globalTopLeft_.y - pView.y;
								if ( _alpha < 1 || pRotation != 0 || pScaleX != 1 || pScaleY != 1 ) {
									_matrix.identity();
									_matrix.translate( -( hotspot.x + renderOffset.x ), -( hotspot.y + renderOffset.y ) );
									if ( pScaleX != 1 || pScaleY != 1 )
										_matrix.scale( pScaleX, pScaleY );
									if ( pRotation != 0 ) {
										_matrix.translate( -entity.transform.pivotOffset.x, -entity.transform.pivotOffset.y );
										_matrix.rotate( pRotation );
										_matrix.translate( entity.transform.pivotOffset.x, entity.transform.pivotOffset.y );
									}
									_matrix.translate( _bufferTopLeft_.x + hotspot.x + renderOffset.x, _bufferTopLeft_.y + hotspot.y + renderOffset.y );
									if ( _alpha < 1 ) {
										pBitmapData.draw( bitmapData, _matrix, _colorTransform );
									} else {
										pBitmapData.draw( bitmapData, _matrix );
									}
								} else {
									pBitmapData.copyPixels( bitmapData, bitmapData.rect, _bufferTopLeft_, null, null, true );
								}
								pRenderStats.renderedObjects++;
							}
						}
					}
				}
			}
		
		}
		
		/**
		 * Sets the alpha for this component.
		 */
		public function set alpha( a : Number ) : void {
			_alpha = a;
			_colorTransform.alphaOffset = 255 * ( _alpha - 1 );
		}
		
		/**
		 * Returns the alpha for this component.
		 */
		public function get alpha() : Number {
			return _alpha;
		}
		
		/**
		 * Updates the hotspot's position.
		 * @param	pX	X position.
		 * @param	pY	Y position.
		 */
		public function setHotspot( pX : int, pY : int ) : void {
			hotspot.x = pX;
			hotspot.y = pY;
		}
	
	}
}