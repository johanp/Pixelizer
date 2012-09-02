package pixelizer {
	import examples.spritesheet.SpriteSheetExampleScene;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.System;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import pixelizer.components.collision.PxColliderComponent;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.components.render.PxTextFieldComponent;
	import pixelizer.prefabs.gui.PxTextFieldEntity;
	import pixelizer.prefabs.logo.PxLogoEntity;
	import pixelizer.systems.PxSystem;
	import pixelizer.utils.PxCollisionStats;
	import pixelizer.utils.PxImageUtil;
	import pixelizer.utils.PxLog;
	import pixelizer.utils.PxLogicStats;
	import pixelizer.utils.PxRenderStats;
	import pixelizer.utils.PxString;
	
	/**
	 * The engine manages and updates scenes. Inherit the engine with your document class to get rolling!
	 * @author	Johan Peitz
	 */
	public class PxEngine extends Sprite {
		private var _pauseOnFocusLost : Boolean = true;
		
		//private var _renderer : IPxRenderer;
		private var _logicStats : PxLogicStats;
		
		private var _currentScene : PxScene;
		private var _sceneStack : Vector.<PxScene>;
		private var _sceneChanges : Array;
		
		private var _renderClass : Class;
		
		private var _internalScene : PxScene;
		private var _performaceView : PxTextFieldEntity = null;
		private var _logView : PxTextFieldEntity = null;
		private var _logTexts : Array = [];
		
		private var _targetFPS : int = 0;
		
		private var _frameCount : int = 0;
		private var _fpsTimer : Timer = null;
		private var _internalTimer : Timer = null;
		
		private var _timeStepS : Number = 0;
		private var _timeStepMS : Number = 0;
		private var _currentTimeMS : Number = 0;
		private var _lastTimeMS : Number = 0;
		private var _deltaTimeMS : Number = 0;
		
		private var _width : int;
		private var _height : int;
		private var _scale : int;
		private var _showingLogo : Boolean = true;
		private var _hasFocus : Boolean = true;
		private var _noFocusEntity : PxEntity;
		
		private var _sceneContainer : Sprite;
		
		/**
		 * Constructs a new engine. Automatically initializes Pixelizer. Sets the dimensions for the renderer.
		 * The size of the renderer and the scale should match the size of the application.
		 *
		 * @param	pWidth	Width of renderer.
		 * @param	pHeight	Height of renderer.
		 * @param	pScale	How much to scale the renderer.
		 * @param	pFPS	Target Frames Per Seconds.
		 * @param	pRendererClass	What renderer to use.
		 * @param 	pShowLogo	Specifies whether to show Pixelizer logo at start or not.
		 */
		public function PxEngine( pWidth : int, pHeight : int, pScale : int = 1, pFPS : int = 30, pShowLogo : Boolean = true ) {
			_showingLogo = pShowLogo;
			_targetFPS = pFPS;
			_width = pWidth;
			_height = pHeight;
			_scale = pScale;
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		private function onAddedToStage( pEvent : Event ) : void {
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			Pixelizer.onEngineAddedToStage( this, stage );
			
			_sceneContainer = new Sprite();
			addChild( _sceneContainer );
			
			_logicStats = new PxLogicStats();
			
			_currentScene = null;
			_sceneStack = new Vector.<PxScene>;
			_sceneChanges = [];
			
			_internalScene = new PxScene( true );
			_internalScene.onAddedToEngine( this );
			addChild( _internalScene.renderSystem.displayObject );
			
			PxLog.addLogFunction( logListener );
			PxLog.log( "size set to " + _width + "x" + _height + ", " + _scale + "x", this, PxLog.INFO );
			
			if ( _showingLogo ) {
				_internalScene.addEntity( new PxLogoEntity( onLogoComplete ) );
			}
			
			_timeStepMS = 1000 / _targetFPS;
			_timeStepS = _timeStepMS / 1000;
			_lastTimeMS = _currentTimeMS = getTimer();
			
			_fpsTimer = new Timer( 1000 );
			_fpsTimer.addEventListener( TimerEvent.TIMER, onFpsTimer );
			_fpsTimer.start();
			
			_internalTimer = new Timer( 10 );
			_internalTimer.addEventListener( TimerEvent.TIMER, internalUpdate );
			_internalTimer.start();
			
			stage.focus = this;
			stage.addEventListener( Event.ACTIVATE, onFocusIn );
			stage.addEventListener( Event.DEACTIVATE, onFocusOut );
		
		}
		
		/**
		 * Cleans up after the engine. Freeing resources.
		 */
		public function dispose() : void {
			if ( _internalTimer != null ) {
				_internalTimer.stop();
				_internalTimer.addEventListener( TimerEvent.TIMER, internalUpdate );
				_internalTimer = null;
			}
			
			if ( _internalTimer != null ) {
				_fpsTimer.stop();
				_fpsTimer.addEventListener( TimerEvent.TIMER, onFpsTimer );
				_fpsTimer = null;
			}
			
			stage.removeEventListener( FocusEvent.FOCUS_IN, onFocusIn );
			stage.removeEventListener( FocusEvent.FOCUS_OUT, onFocusOut );
		
		}
		
		private function logListener( pMessage : String ) : void {
			_logTexts.push( pMessage );
			if ( _logTexts.length > 3 ) {
				_logTexts.shift();
			}
			
			if ( _logView ) {
				_logView.textField.text = getLogText();
			}
		}
		
		private function getLogText() : String {
			var s : String = "";
			for each ( var txt : String in _logTexts ) {
				s += PxString.trim( txt ) + "\n";
			}
			return s;
		}
		
		private function onFocusIn( evt : Event ) : void {
			if ( !_pauseOnFocusLost )
				return;
			
			if ( _hasFocus )
				return;
			
			if ( !_internalTimer.running ) {
				_internalTimer.start();
				_lastTimeMS = getTimer();
				_hasFocus = true;
			}
			
			if ( _noFocusEntity != null ) {
				_internalScene.removeEntity( _noFocusEntity );
				_noFocusEntity = null;
			}
			
			_currentScene.onActivated();
		}
		
		private function onFocusOut( evt : Event ) : void {
			if ( !_pauseOnFocusLost )
				return;
			
			if ( !_hasFocus )
				return;
			
			_hasFocus = false;
			
			_noFocusEntity = new PxEntity();
			_noFocusEntity.transform.scale = 2;
			var blocker : PxBlitRenderComponent = new PxBlitRenderComponent( PxImageUtil.createRect( _width / 2, _height / 2, Pixelizer.COLOR_LIGHT_GRAY ), new Point() );
			blocker.alpha = 0.5;
			_noFocusEntity.addComponent( blocker );
			var message : PxTextFieldComponent = new PxTextFieldComponent();
			message.text = "*** PAUSED ***\n\nClick to resume.";
			message.background = true;
			message.alignment = Pixelizer.CENTER;
			message.padding = 10;
			message.width = _width / 2 - 20;
			message.setHotspot( 0, -height / 4 + 30 );
			
			_noFocusEntity.addComponent( message );
			_internalScene.addEntity( _noFocusEntity );
		
		}
		
		/**
		 * Resets the engine's timers.
		 * Should be called after time consuming algorithms so that the engine does not skip frames afterwards.
		 */
		public function resetTimers() : void {
			_lastTimeMS = _currentTimeMS = getTimer();
		}
		
		private function onFpsTimer( evt : TimerEvent ) : void {
			_logicStats.fps = _frameCount;
			_frameCount = 0;
			
			if ( _performaceView != null ) {
				_logicStats.currentMemory = System.totalMemory / 1024 / 1024;
				if ( _logicStats.maxMemory < _logicStats.currentMemory ) {
					_logicStats.maxMemory = _logicStats.currentMemory;
				}
				if ( _logicStats.minMemory == -1 || _logicStats.minMemory > _logicStats.currentMemory ) {
					_logicStats.minMemory = _logicStats.currentMemory;
				}
				var text : String = _logicStats.toString() + "\n";
				for each( var s : PxSystem in _currentScene.getSystems() ) {
					if ( s.stats != null ) {
						text += s.stats.toString() + "\n";
					}
				}
				_performaceView.textField.text = text;
			}
		}
		
		private function internalUpdate( evt : TimerEvent ) : void {
			var logicTime : int;
			
			_currentTimeMS = getTimer();
			_deltaTimeMS += _currentTimeMS - _lastTimeMS;
			_lastTimeMS = _currentTimeMS;
			
			if ( _deltaTimeMS >= _timeStepMS ) {
				// do logic
				while ( _deltaTimeMS >= _timeStepMS ) {
					_logicStats.reset();
					
					_deltaTimeMS -= _timeStepMS;
					
					// track logic performance
					logicTime = getTimer();
					
					// update current scene
					if ( _currentScene != null && _showingLogo == false ) {
						_currentScene.update( _timeStepS );
					}
					
					// update internal scene
					_internalScene.update( _timeStepS );
					
					// calc logic time					
					_logicStats.logicTime = getTimer() - logicTime;
				}
				
				// count fps
				_frameCount++;
				
				// render
				if ( _currentScene != null ) {
					_currentScene.render();
				}
				_internalScene.render();
				
				// make changes to scenes
				if ( _sceneChanges.length > 0 ) {
					for each ( var o : Object in _sceneChanges ) {
						switch ( o.action ) {
							case "pop": 
								internalPopScene();
								break;
							case "push": 
								internalPushScene( o.scene );
								break;
						}
					}
					_sceneChanges = [];
				}
				
				// stop the internal timer if we lost focus
				if ( !_hasFocus ) {
					_internalTimer.stop();
					_currentScene.onDeactivated();
				}
				
				// move on as fast as possible
				evt.updateAfterEvent();
			}
		}
		
		/**
		 * Adds a scene to the top of the scene stack. The added scene will now be the current scene.
		 * @param	pScene
		 */
		public function pushScene( pScene : PxScene ) : void {
			_sceneChanges.push({ action: "push", scene: pScene } );
		}
		
		private function internalPushScene( pScene : PxScene ) : void {
			PxLog.log( "pushing scene '" + pScene + "' on stack", this, PxLog.INFO );
			_sceneStack.push( pScene );
			
			if ( _currentScene != null ) {
				_currentScene.onDeactivated();
			}
			
			_currentScene = pScene;
			_sceneContainer.addChild( _currentScene.renderSystem.displayObject );
			_currentScene.onAddedToEngine( this );
		}
		
		/**
		 * Removes to top most scene from the stack and sets the scene below to become the current scene.
		 * The popped scene will be disposed.
		 */
		public function popScene() : void {
			_sceneChanges.push({ action: "pop", scene: null } );
		}
		
		private function internalPopScene() : void {
			PxLog.log( "popping scene '" + _currentScene + "' from stack", this, PxLog.INFO );
			
			var lastScene : PxScene = _sceneStack.pop();
			_sceneContainer.removeChild( lastScene.renderSystem.displayObject );
			lastScene.onRemovedFromEngine();
			
			if ( _sceneStack.length > 0 ) {
				_currentScene = _sceneStack[ _sceneStack.length - 1 ];
				_currentScene.onActivated();
			} else {
				_currentScene = null;
			}
			
			PxLog.log( "current scene is '" + _currentScene + "'", this, PxLog.INFO );
		}
		
		/**
		 * Returns whether the engine is showing the performance info or not.
		 * @return True is performance info is currently shown.
		 */
		public function get showPerformance() : Boolean {
			return _performaceView != null;
		}
		
		/**
		 * Specifies whether to show performance info or not.
		 */
		public function set showPerformance( pShowPerformance : Boolean ) : void {
			if ( _performaceView == null && pShowPerformance ) {
				PxLog.log( "turning performance view ON", "[o Pixelizer]", PxLog.DEBUG );
				_performaceView = new PxTextFieldEntity( "", Pixelizer.COLOR_BLACK );
				_performaceView.textField.background = true;
				_performaceView.textField.backgroundColor = Pixelizer.COLOR_LIGHT_GRAY;
				_performaceView.textField.padding = 2;
				_performaceView.textField.alpha = 0.8;
				_internalScene.entityRoot.addEntity( _performaceView );
				
				_logView = new PxTextFieldEntity( "", Pixelizer.COLOR_BLACK );
				_logView.textField.background = true;
				_logView.textField.backgroundColor = Pixelizer.COLOR_LIGHT_GRAY;
				_logView.textField.padding = 2;
				_logView.textField.alpha = 0.8;
				_logView.textField.width = _width;
				_logView.transform.position.y = _height - 25;
				_logView.textField.text = getLogText();
				_internalScene.entityRoot.addEntity( _logView );
			}
			
			if ( _performaceView != null && !pShowPerformance ) {
				PxLog.log( "turning performance view OFF", "[o Pixelizer]", PxLog.DEBUG );
				_internalScene.entityRoot.removeEntity( _performaceView );
				_performaceView.dispose();
				_performaceView = null;
				
				_internalScene.entityRoot.removeEntity( _logView );
				_logView.dispose();
				_logView = null;
			}
		
		}
		
		private function onLogoComplete() : void {
			_showingLogo = false;
		}
		
		/**
		 * Returns the width of the engine.
		 * @return	Width of the engine.
		 */
		override public function get width() : Number {
			return _width;
		}
		
		/**
		 * Returns the height of the engine.
		 * @return	Height of the engine.
		 */
		override public function get height() : Number {
			return _height;
		}
		
		/**
		 * Returns the scale set in the engine.
		 * @return The scale.
		 */
		public function get scale() : int {
			return _scale;
		}
		
	
		
		/**
		 * Returns the latest stats from the logic loop.
		 * @return The stats.
		 */
		public function get logicStats() : PxLogicStats {
			return _logicStats;
		}
		
		
		/**
		 * Returns the current scene.
		 * @return The current scene or null if there is none.
		 */
		public function get currentScene() : PxScene {
			return _currentScene;
		}
		
		/**
		 * Decides wether to pause the application if focus is lost.
		 */
		public function set pauseOnFocusLost( pPause : Boolean ) : void {
			_pauseOnFocusLost = pPause;
		}
	
	}
}