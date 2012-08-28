package pixelizer {
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import pixelizer.systems.PxSystem;
	import pixelizer.utils.PxLog;
	
	/**
	 * Manages keyboard and mouse input.
	 * @author Johan Peitz
	 */
	public class PxInputSystem extends PxSystem {
		private var _stage : Stage;
		private var _keysDown : Array = [];
		
		/**
		 * Specifies whether the mouse button is down.
		 */
		public var mouseDown : Boolean = false;
		/**
		 * Specifies whether the mouse button was just pressed.
		 */
		public var mousePressed : Boolean = false;
		
		/**
		 * Specifies whether the mouse button is up.
		 */
		public var mouseUp : Boolean = true;
		/**
		 * Specifies whether the mouse button was just released.
		 */
		public var mouseReleased : Boolean = false;
		/**
		 * Position of the mouse.
		 */
		public var mousePosition : Point;
		
		/**
		 * Specifies how much the mouse wheel changed.
		 */
		public var mouseDelta : int = 0;
		
		
		/**
		 * Initializes the input manager.
		 * @param	pStage The Flash stage. Needed to listed for keyboard events.
		 */
		public function PxInputSystem( pScene : PxScene, pPriority : int = 0 ) : void {
			super( pScene, pPriority );
			
			_stage = Pixelizer.stage;
			
			
			_stage.addEventListener( KeyboardEvent.KEY_DOWN, keyPressed );
			_stage.addEventListener( KeyboardEvent.KEY_UP, keyReleased );
			_stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			_stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			_stage.addEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheel );
			
			mousePosition = new Point();
			
			for ( var i : int = 0; i <= 255; i++ ) {
				_keysDown.push( 0 );
			}
			
		}
		
		/**
		 * Disposes of all resources used by the input manager.
		 */
		override public function dispose() : void {
			_stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyPressed );
			_stage.removeEventListener( KeyboardEvent.KEY_UP, keyReleased );
			_stage.removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			_stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			_stage.removeEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheel );
			_keysDown = null;
		}
		
		/**
		 * Returns the mouse's X position.
		 * @return	The mouse's X position.
		 */
		public function get mouseX() : int {
			return mousePosition.x;
		}
		
		/**
		 * Returns the mouse's Y position.
		 * @return	The mouse's Y position.
		 */
		public function get mouseY() : int {
			return mousePosition.y;
		}
		
		/**
		 * Resets the status of the mouse button.
		 */
		public function resetMouseButton() : void {
			mouseDown = false;
			mousePressed = false;
			mouseUp = true;
			mouseReleased = false;
		}
		
		private function onMouseDown( e : MouseEvent ) : void {
			if ( !mouseDown ) {
				mouseDown = true;
				mouseUp = false;
				mousePressed = true;
				mouseReleased = false;
			}
		}
		
		private function onMouseUp( e : MouseEvent ) : void {
			mouseDown = false;
			mouseUp = true;
			mousePressed = false;
			mouseReleased = true;
		}
		
		private function onMouseWheel( e : MouseEvent ) : void {
			mouseDelta += e.delta;
		}
		
		/**
		 * Resets all input.
		 */
		public function reset() : void {
			resetMouseButton();
			var pos : int = _keysDown.length;
			while( -- pos >= 0 ) {
				_keysDown[ pos ] = 0;
			}
		}
		
		/**
		 * Invoked by the engine at regular intervals. Synchronizes internal data with Flash's.
		 * @param	pDT	Time step in seconds.
		 */
		override public function update( pDT : Number ) : void {
			mousePosition.x = _stage.mouseX / Pixelizer.engine.scale;
			mousePosition.y = _stage.mouseY / Pixelizer.engine.scale;
		}
		
		/**
		 * Invoked by the engine after each logic cycle. Cleans up what needs to be cleaned up.
		 */
		override public function afterUpdate() : void {
			if ( mousePressed )
				mousePressed = false;
			if ( mouseReleased )
				mouseReleased = false;
			
			mouseDelta = 0;
		}
		
		/**
		 * Checks wether a certain key is up or not.
		 * @param	keyCode	The key code of the desired key.
		 * @return	True if the key is up.
		 */
		public function isUp( keyCode : uint ) : Boolean {
			return _keysDown[ keyCode ] <= 0;
		}
		
		/**
		 * Checks wether a certain key is down or not.
		 * @param	keyCode	The key code of the desired key.
		 * @return	True if the key is down.
		 */
		public function isDown( keyCode : uint ) : Boolean {
			return _keysDown[ keyCode ] > 0;
		}
		
		/**
		 * Checks wether a certain key was just pressed.
		 * @param	keyCode	The key code of the desired key.
		 * @return	True if the key was just pressed.
		 */
		public function isPressed( keyCode : uint ) : Boolean {
			var p : Boolean = _keysDown[ keyCode ] == 1;
			if ( p )
				_keysDown[ keyCode ] = 2;
			return p;
		}
		
		public function isReleased( keyCode : uint ) : Boolean {
			var p : Boolean = _keysDown[ keyCode ] == -1;
			if ( p )
				_keysDown[ keyCode ] = -2;
			return p;
		}
		
		/**
		 * Fakes a key press of a certain key.
		 * @param	keyCode	The key code of the desired key.
		 */
		public function fakeKeyPress( keyCode : uint ) : void {
			_keysDown[ keyCode ]++;
		}
		
		private function keyPressed( evt : KeyboardEvent ) : void {
			if ( _keysDown[ evt.keyCode ] <= 0 ) {
				_keysDown[ evt.keyCode ] = 1;
			}
		}
		
		private function keyReleased( evt : KeyboardEvent ) : void {
			_keysDown[ evt.keyCode ] = -1;
		}
		
		public static const KEY_BACKSPACE : int = 8;
		public static const KEY_ENTER : int = 13;
		
		public static const KEY_SHIFT : int = 16;
		public static const KEY_CONTROL : int = 17;
		
		public static const KEY_ESC : int = 27;
		
		public static const KEY_SPACE : int = 32;
		public static const KEY_PGUP : int = 33;
		public static const KEY_PGDN : int = 34;
		public static const KEY_END : int = 35;
		public static const KEY_HOME : int = 36;
		public static const KEY_LEFT : int = 37;
		public static const KEY_UP : int = 38;
		public static const KEY_RIGHT : int = 39;
		public static const KEY_DOWN : int = 40;
		
		public static const KEY_DELETE : int = 46;
		public static const KEY_INSERT : int = 45;
		
		public static const KEY_0 : int = 48;
		public static const KEY_1 : int = 49;
		public static const KEY_2 : int = 50;
		public static const KEY_3 : int = 51;
		public static const KEY_4 : int = 52;
		public static const KEY_5 : int = 53;
		public static const KEY_6 : int = 54;
		public static const KEY_7 : int = 55;
		public static const KEY_8 : int = 56;
		public static const KEY_9 : int = 57;
		
		public static const KEY_A : int = 65;
		public static const KEY_B : int = 66;
		public static const KEY_C : int = 67;
		public static const KEY_D : int = 68;
		public static const KEY_E : int = 69;
		public static const KEY_F : int = 70;
		public static const KEY_G : int = 71;
		public static const KEY_H : int = 72;
		public static const KEY_I : int = 73;
		public static const KEY_J : int = 74;
		public static const KEY_K : int = 75;
		public static const KEY_L : int = 76;
		public static const KEY_M : int = 77;
		public static const KEY_N : int = 78;
		public static const KEY_O : int = 79;
		public static const KEY_P : int = 80;
		public static const KEY_Q : int = 81;
		public static const KEY_R : int = 82;
		public static const KEY_S : int = 83;
		public static const KEY_T : int = 84;
		public static const KEY_U : int = 85;
		public static const KEY_V : int = 86;
		public static const KEY_W : int = 87;
		public static const KEY_X : int = 88;
		public static const KEY_Y : int = 89;
		public static const KEY_Z : int = 90;
		
		public static const KEY_F1 : int = 112;
		public static const KEY_F2 : int = 113;
		public static const KEY_F3 : int = 114;
		public static const KEY_F4 : int = 115;
		public static const KEY_F5 : int = 116;
		public static const KEY_F6 : int = 117;
		public static const KEY_F7 : int = 118;
		public static const KEY_F8 : int = 119;
	
	}
}