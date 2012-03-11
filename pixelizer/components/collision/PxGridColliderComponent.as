package pixelizer.components.collision {
	import pixelizer.utils.PxGrid;
	
	/**
	 * A collider consiting of a number of cells in a grid. Each cell holds it's own collision data.
	 * Useful for tilemap collisions.
	 */
	public class PxGridColliderComponent extends PxColliderComponent {
		private var _grid : PxGrid = null;
		private var _cellSize : int = 16;
		
		private var _height : int;
		private var _width : int;
		
		/**
		 * Constructs a new grid collider.
		 * @param	pWidth	Number of cells across.
		 * @param	pHeight	Number of cells along.
		 * @param	pCellSize	Size of each cell.
		 */
		public function PxGridColliderComponent( pWidth : int, pHeight : int, pCellSize : int = 16 ) {
			super();
			
			collisionLayer = 1;
			collisionLayerMask = 0;
			
			_cellSize = pCellSize;
			_width = pWidth;
			_height = pHeight;
			_grid = new PxGrid( _width, _height );
		}
		
		/**
		 * Returns the value of a specific cell.
		 * @param	pTX	X position of cell.
		 * @param	pTY	Y position of cell.
		 * @return	Calue of cell at location.
		 */
		public function getCell( pTX : int, pTY : int ) : int {
			return _grid.getCell( pTX, pTY );
		}
		
		/**
		 * Sets the value of a specific cell.
		 * @param	pTX	X position of cell.
		 * @param	pTY	Y position of cell.
		 */
		public function setCell( pTX : int, pTY : int, pTileID : int ) : void {
			_grid.setCell( pTX, pTY, pTileID );
		}
		
		/**
		 * Returns the grid data used for this collider.
		 * @return Grid instance.
		 */
		public function get grid() : PxGrid {
			return _grid;
		}
		
		/**
		 * Returns the size of each cell.
		 * @return Cell size.
		 */
		public function get cellSize() : int {
			return _cellSize;
		}
		
		/**
		 * Returns the height of the grid in cells.
		 * @return Height in cells.
		 */
		public function get height() : int {
			return _height;
		}
		
		/**
		 * Returns the width of the grid in cells.
		 * @return Width in cells.
		 */
		public function get width() : int {
			return _width;
		}
	
	}
}