package pixelizer.utils {
	import __AS3__.vec.Vector;
	
	/**
	 * Representation of a 2D grid. Each grid can hold any int value.
	 */
	public class PxGrid {
		private var _grid : Vector.<int>;
		private var _width : int;
		private var _height : int;
		
		/**
		 * Creates a new grid.
		 * @param	pWidth	Width of grid.
		 * @param	pHeight	Height of grid.
		 * @param	pDefaultValue	Default value for each cell to hold.
		 */
		public function PxGrid( pWidth : int, pHeight : int, pDefaultValue : int = 0 ) : void {
			
			_width = pWidth;
			_height = pHeight;
			
			_grid = new Vector.<int>();
			
			for ( var i : int = 0; i < _width * _height; i++ ) {
				_grid.push( pDefaultValue );
			}
		}
		
		/**
		 * Clears all resources used by this grid.
		 */
		public function dispose() : void {
			_grid = null;
		}
		
		/**
		 * Sets the value of a cell.
		 * @param	pX	X position of cell.
		 * @param	pY	Y position of cell.
		 * @param	pCellID	value of cell.
		 */
		public function setCell( pX : int, pY : int, pCellID : int ) : void {
			_grid[ pX + pY * _width ] = pCellID;
		}
		
		/**
		 * Returns the value of a cell.
		 * @param	pX	X position of cell.
		 * @param	pY	Y position of cell.
		 * @return	Value of cell at X,Y location.
		 */
		public function getCell( pX : int, pY : int ) : int {
			if ( pX < 0 || pX >= width || pY < 0 || pY >= height ) {
				return 0;
			}
			return _grid[ pX + pY * _width ];
		}
		
		/**
		 * Returns width of grid.
		 * @return Width of grid.
		 */
		public function get width() : int {
			return _width;
		}
		
		/**
		 * Returns height of grid.
		 * @return Height of grid.
		 */
		public function get height() : int {
			return _height;
		}
		
		/**
		 * Populates the grid using a bit string. ("1101010010101...").
		 * Very convenient to use together with for instance the OGMO editor.
		 * If the string is bigger than the grid size, it is likely to crash.
		 * @param	pBitString	Source string to use for population.
		 * @param	pValue	Value to store for each "1".
		 * @param	pZerosOverwriteValues	Specifies whether a "0" should overwrite a previous value in the grid or not.
		 */
		public function populateFromBitString( pBitString : String, pValue : int = 1, pZerosOverwriteValues : Boolean = true ) : void {
			var tx : int = 0;
			var ty : int = 0;
			for ( var i : int = 0; i < pBitString.length; i++ ) {
				var c : String = pBitString.substr( i, 1 );
				if ( c == "1" || c == "0" ) {
					if ( c == "1" ) {
						setCell( tx, ty, pValue );
					} else if ( c == "0" && pZerosOverwriteValues ) {
						setCell( tx, ty, 0 );
					}
					tx++;
				}
			}
		}
	
	}
}