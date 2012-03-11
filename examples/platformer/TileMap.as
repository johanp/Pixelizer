package examples.platformer {
	import pixelizer.components.collision.PxGridColliderComponent;
	import pixelizer.components.render.PxTileMapComponent;
	import pixelizer.PxEntity;
	import pixelizer.render.PxSpriteSheet;
	
	/**
	 * Shows tiled graphics and holds the collision for the tilemap
	 *
	 * @author Johan Peitz
	 */
	public class TileMap extends PxEntity {
		private var _width : int;
		private var _height : int;
		
		private var _gridComponent : PxGridColliderComponent;
		
		public function TileMap( pLevelXML : XML ) {
			_width = pLevelXML.@width;
			_height = pLevelXML.@height;
			
			// add collision
			_gridComponent = new PxGridColliderComponent( _width, _height );
			_gridComponent.grid.populateFromBitString( pLevelXML[ "solid" ][ 0 ], 1 );
			_gridComponent.grid.populateFromBitString( pLevelXML[ "jump_through" ][ 0 ], 2, false );
			addComponent( _gridComponent );
			
			// add tiled graphics
			var tileMapComp : PxTileMapComponent = new PxTileMapComponent( _width, _height, PxSpriteSheet.fetch( "tiles" ) );
			tileMapComp.populateFromXML( pLevelXML[ "background" ][ 0 ] );
			addComponent( tileMapComp );
		}
		
		override public function dispose() : void {
			_gridComponent = null;
			super.dispose();
		}
		
		public function get width() : int {
			return _width;
		}
		
		public function get height() : int {
			return _height;
		}
	
	}

}