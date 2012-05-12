package pixelizer.utils {
	
	public class PxInputSequence {
		
		private var _posts : Array;
		private var _currentPost : PxInputPost = null;
		private var _position : int;
		private var _postPosition : int;
		
		public function PxInputSequence() {
			_posts = new Array();
			_position = 0;
			_postPosition = 0;
			_currentPost = null;
		}
		
		public function reset() : void {
			_position = 0;
			_postPosition = 0;
			_posts = new Array();
			_currentPost = null;
		}
		
		public function restart() : void {
			_position = 0;
			_postPosition = 0;
			_currentPost = null;
		}
		
		public function storePost( pInput : PxInputPost ) : void {
			if ( _currentPost == null ) {
				_currentPost = pInput;
				_posts.push( _currentPost );
			} else {
				if ( _currentPost.equals( pInput ) ) {
					_currentPost.duration++;
				} else {
					_currentPost = pInput;
					_posts.push( _currentPost );
				}
			}
		}
		
		public function fetchPost() : PxInputPost {
			if ( _currentPost == null ) {
				_currentPost = _posts[ _position ];
			} else {
				_postPosition++;
				
				if ( _postPosition > _currentPost.duration ) {
					_postPosition = 0;
					_position++;
					_currentPost = _posts[ _position ];
				}
			}
			
			return _currentPost;
		}
		
		public function getSerialized() : Array {
			var s : Array = [];
			for each ( var p : PxInputPost in _posts ) {
				s.push( p.getSerialized() );
			}
			return s;
		}
		
		public function populateFromSerialized( pSerializedArray : Array ) : void {
			reset();
			for each ( var o : Object in pSerializedArray ) {
				var post : PxInputPost = new PxInputPost();
				post.populateFromSerialized( o );
				storePost( post );
			}
			restart();
		}
		
		public function getAsString() : String {
			var s : String = "";
			for each ( var p : PxInputPost in _posts ) {
				s += p.getAsString() + ":";
			}
			return s;
		}
		
		public function setFromString( pData : String ) : Boolean {
			// RJ;0:R;33:RJ;6:R;8:LJ;3:LRJ;0:RJ;16:R;8:RJ;2:R;5:
			reset();
			var parts : Array = pData.split( ":" );
			for each( var part : String in parts ) {
				if ( part.length > 0 ) {
					var ip : PxInputPost = new PxInputPost();
					if ( !ip.setFromString( part ) ) {
						return false;
					}
					storePost( ip );
				}
			}
			restart();
			return true;
		}
	
	}
}