package pixelizer.utils {
	import pixelizer.components.collision.PxBoxColliderComponent;
	
	public class PxInputPost {
		public var left : Boolean = false;
		public var right : Boolean = false;
		public var up : Boolean = false;
		public var down : Boolean = false;
		public var jump : Boolean = false;
		public var action : Boolean = false;
		
		public var duration : int = 0;
		
		public function equals( pIP : PxInputPost ) : Boolean {
			if ( pIP.left != left )
				return false;
			if ( pIP.right != right )
				return false;
			if ( pIP.up != up )
				return false;
			if ( pIP.down != down )
				return false;
			if ( pIP.action != action )
				return false;
			if ( pIP.jump != jump )
				return false;
			
			return true;
		}
		
		public function getSerialized() : Object {
			return { left: left, right: right, up: up, down: down, jump: jump, action: action, duration: duration };
		}
		
		public function populateFromSerialized( o : Object ) : void {
			left = o.left;
			right = o.right;
			up = o.up;
			down = o.down;
			jump = o.jump;
			action = o.action;
			duration = o.duration;
		}
		
		public function toString() : String {
			return "" + ( left ? "L" : " " ) + ( right ? "R" : " " ) + ( up ? "U" : " " ) + ( down ? "D" : " " ) + ( jump ? "J" : " " ) + ( action ? "A" : " " ) + " " + duration + " ";
			;
		}
		
		public function getAsString() : String {
			return ( left ? "L" : "" ) + ( right ? "R" : "" ) + ( up ? "U" : "" ) + ( down ? "D" : "" ) + ( jump ? "J" : "" ) + ( action ? "A" : "" ) + ";" + duration;
			;
		}
		
		public function setFromString( pData : String ) : Boolean {
			var parts : Array = pData.split( ";" );
			
			if ( parts.length != 2 ) return false;
			
			duration = parseInt( parts[ 1 ] );
			
			left = parts[ 0 ].indexOf( "L" ) != -1;
			right = parts[ 0 ].indexOf( "R" ) != -1;
			up = parts[ 0 ].indexOf( "U" ) != -1;
			down = parts[ 0 ].indexOf( "D" ) != -1;
			jump = parts[ 0 ].indexOf( "J" ) != -1;
			action = parts[ 0 ].indexOf( "A" ) != -1;
			
			
			
			return true;
		}
	
	}
}