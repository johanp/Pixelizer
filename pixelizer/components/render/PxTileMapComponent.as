package pixelizer.components.render {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import pixelizer.Pixelizer;
	import pixelizer.render.PxSpriteSheet;
	import pixelizer.utils.PxGrid;
	import pixelizer.utils.PxRenderStats;
	
	/**
	 * Renders tiles using a sprite sheet.
	 * @author Johan Peitz
	 */
	public class PxTileMapComponent extends PxBlitRenderComponent {
		private var _grid : PxGrid;
		
		private var _numTiles : int = 0;
		
		private var _tileBounds : Rectangle;
		private var _tileSheet : PxSpriteSheet;
		
		/**
		 * Constructs a new tile map.
		 * @param	pWidth	Width of map in tiles.
		 * @param	pHeight	Height of map in tiles.
		 * @param	pSpriteSheet	Sprite sheet to use for tiles.
		 */
		public function PxTileMapComponent( pWidth : int, pHeight : int, pSpriteSheet : PxSpriteSheet ) {
			super();
			
			_tileSheet = pSpriteSheet;
			_tileBounds = new Rectangle( 0, 0, _tileSheet.spriteWidth, _tileSheet.spriteHeight );
			
			_grid = new PxGrid( pWidth, pHeight, -1 );
		}
		
		/**
		 * Clears all resources used by tile map.
		 */
		override public function dispose() : void {
			_tileBounds = null;
			_grid.dispose();
			_grid = null;
			_tileSheet = null;
			
			super.dispose();
		}
		
		/**
		 * Sets a tile on the map to use a specific frame from the sprite sheet.
		 * @param	pTX	X position of tile.
		 * @param	pTY	Y position of tile.
		 * @param	pTileID	Frame to use.
		 */
		public function setTile( pTX : int, pTY : int, pTileID : int ) : void {
			var prevTileID : int = _grid.getCell( pTX, pTY );
			_grid.setCell( pTX, pTY, pTileID );
			
			if ( prevTileID > 0 ) {
				_numTiles += ( pTileID == 0 ? -1 : 0 );
			} else {
				_numTiles += ( pTileID == 0 ? 0 : 1 );
			}
		}
		
		/**
		 * Returns the grid that holds tile values.
		 * @return The tile grid.
		 */
		public function get grid() : PxGrid {
			return _grid;
		}
		
		/**
		 * Returns number of tiles in the map.
		 * @return Amount of tiles in map.
		 */
		public function get numTiles() : int {
			return _numTiles;
		}
		
		/**
		 * Populates the map from XML. XML should look like this.
		 * <data>
		 * 		<tile x="12" y="23" id="2" />
		 * </data>
		 *
		 * @param	pXML XML to use.
		 */
		public function populateFromXML( pXML : XML ) : void {
			for each ( var node : XML in pXML.elements() ) {
				setTile( node.@x, node.@y, node.@id );
			}
		}
		
		/**
		 * Renders the tilemap onto bitmap data.
		 * @param	pView	Part of scene to render.
		 * @param	pBitmapData	Bitmap data to render on.
		 * @param	pOffset		Offset from top left corner.
		 * @param	pRenderStats	Render stats to update.
		 */
		override public function render( pView : Rectangle, pBitmapData : BitmapData, pOffset : Point, pRotation : Number, pScaleX : Number, pScaleY : Number, pRenderStats : PxRenderStats ) : void {
			if ( !visible )
				return;

			var tileSize : int = _tileSheet.spriteWidth;
			
			var objsRendered : int = 0;
			
			var dest : Point = Pixelizer.pointPool.fetch();
			
			var len : int = grid.width * grid.height;
			var pos : int = 0;
			
			var tx : int;
			var ty : int;
			
			var x1 : int = Math.max( pView.x / tileSize, 0 );
			var x2 : int = Math.min(( pView.x + pView.width ) / tileSize + 1, grid.width );
			
			var y1 : int = Math.max( pView.y / tileSize, 0 );
			var y2 : int = Math.min(( pView.y + pView.height ) / tileSize + 1, grid.height );
			
			for ( ty = y1; ty < y2; ty++ ) {
				pos = ty * grid.width + x1;
				for ( tx = x1; tx < x2; tx++ ) {
					var id : int = grid.getCell( tx, ty );
					if ( id > -1 ) {
						dest.x = pOffset.x + tx * tileSize - pView.x;
						dest.y = pOffset.y + ty * tileSize - pView.y;
						
						pBitmapData.copyPixels( _tileSheet.getFrame( id, 0 ), _tileBounds, dest, null, null, true );
						
						objsRendered++;
					}
					pos++;
				}
			}
			
			Pixelizer.pointPool.recycle( dest );
			
			pRenderStats.renderedObjects += objsRendered;
			pRenderStats.totalObjects += numTiles;
		}
	
	}
}