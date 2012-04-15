package pixelizer.components.render {
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	import pixelizer.components.PxComponent;
	import pixelizer.PxEntity;
	import pixelizer.render.PxAnimation;
	import pixelizer.render.PxSpriteSheet;
	
	/**
	 * Handles animation of a blit render component using sprite sheets.
	 * @author Johan Peitz
	 */
	public class PxAnimationComponent extends PxComponent {
		private var _spriteSheet : PxSpriteSheet = null;
		private var _renderComponentRef : PxBlitRenderComponent = null;
		private var _currentAnimation : PxAnimation = null;
		private var _currentAnimationFrame : int;
		private var _currentSpriteSheetFrame : int;
		private var _animationPlaying : Boolean = false;
		private var _frameTimer : Number;
		private var _frameDuration : Number = 0.1;
		
		private var _flipFlags : int = 0;
		private var _lastFlipFlags : int = 0;
		private var _currentAnimationLabel : String;
		private var _renderComponentNeedsUpdate : Boolean = false;
		
		/**
		 * Creates a new component.
		 * @param	pSpriteSheet	Sprite sheet to use.
		 */
		public function PxAnimationComponent( pSpriteSheet : PxSpriteSheet = null ) {
			_spriteSheet = pSpriteSheet;
		}
		
		/**
		 * Clears all resources used by component.
		 */
		override public function dispose() : void {
			super.dispose();
			
			_spriteSheet = null;
			_renderComponentRef = null;
		}
		
		/**
		 * Invoked when added to an entity. Acquires link to entitie's render component.
		 * @param	pEntity	Entity added to.
		 */
		override public function onAddedToEntity( pEntity : PxEntity ) : void {
			super.onAddedToEntity( pEntity );
			_renderComponentRef = entity.getComponentByClass( PxBlitRenderComponent ) as PxBlitRenderComponent;
		}
		
		/**
		 * Stops any playing animation.
		 */
		public function stop() : void {
			_animationPlaying = false;
		}
		
		/**
		 * Sets a specific frame and stops.
		 * @param	pFrame
		 */
		public function gotoAndStop( pFrame : int ) : void {
			_animationPlaying = false;
			_currentSpriteSheetFrame = pFrame;
			_renderComponentNeedsUpdate = true;
		}
		
		/**
		 * Starts an animation.
		 * @param	pLabel	Animation to start.
		 * @param	pRestart	Specifies whether to restart the animation if it is already playing.
		 */
		public function gotoAndPlay( pLabel : String, pRestart : Boolean = true ) : void {
			if ( !pRestart && _currentAnimationLabel == pLabel && _flipFlags == _lastFlipFlags )
				return;
			_currentAnimationLabel = pLabel;
			
			_currentAnimation = _spriteSheet.getAnimation( _currentAnimationLabel );
			_currentAnimationFrame = 0;
			_animationPlaying = true;
			_frameTimer = 0;
			_frameDuration = 1 / _currentAnimation.fps;
			
			// show first frame
			_currentSpriteSheetFrame = _currentAnimation.frames[ _currentAnimationFrame ];
			_renderComponentNeedsUpdate = true;
		
		}
		
		/**
		 * Updates which frame to show depending on animation data.
		 * Invoked regularly by the entity.
		 * @param	pDT	Time step.
		 */
		override public function update( pDT : Number ) : void {
			super.update( pDT );
			
			if ( _animationPlaying ) {
				_frameTimer += pDT;
				
				if ( _frameTimer > _frameDuration ) {
					_frameTimer -= _frameDuration;
					_currentAnimationFrame++;
					if ( _currentAnimationFrame >= _currentAnimation.frames.length ) {
						switch ( _currentAnimation.onComplete ) {
							case PxAnimation.ANIM_LOOP: 
								_currentAnimationFrame = 0;
								break;
							
							case PxAnimation.ANIM_STOP: 
								_animationPlaying = false;
								_currentAnimationFrame--; // stay on last frame
								break;
							
							case PxAnimation.ANIM_GOTO: 
								gotoAndPlay( _currentAnimation.gotoLabel );
								break;
						}
					}
					
					_currentSpriteSheetFrame = _currentAnimation.frames[ _currentAnimationFrame ];
					_renderComponentNeedsUpdate = true;
				
				}
			}
			
			if ( _renderComponentNeedsUpdate ) {
				updateRenderComponent();
			}
			
			_lastFlipFlags = _flipFlags;
		}
		
		/**
		 * Sets which sprite sheet to use.
		 */
		public function set spriteSheet( pSpriteSheet : PxSpriteSheet ) : void {
			_spriteSheet = pSpriteSheet;
			_currentSpriteSheetFrame = 0;
			_renderComponentNeedsUpdate = true;
		}
		
		/**
		 * Returns which sprite sheet that is currently used.
		 * @return Current sprite sheet.
		 */
		public function get spriteSheet() : PxSpriteSheet {
			return _spriteSheet;
		}
		
		/**
		 * Sets whether to use flipped frames or not.
		 */
		public function set flip( pFlipFlags : int ) : void {
			_lastFlipFlags = _flipFlags;
			_flipFlags = pFlipFlags;
		}
		
		private function updateRenderComponent() : void {
			if ( _renderComponentRef != null ) {
				_renderComponentRef.bitmapData = _spriteSheet.getFrame( _currentSpriteSheetFrame, _flipFlags );
				var offset : Point = _spriteSheet.getFrameOffset( _currentSpriteSheetFrame, _flipFlags );
				_renderComponentRef.renderOffset.x = offset.x;
				_renderComponentRef.renderOffset.y = offset.y;
				
				_renderComponentNeedsUpdate = false;
			}
		}
		
		/**
		 * Returns the label of the current animation.
		 * @return Current animation label.
		 */
		public function get currentLabel() : String {
			return _currentAnimationLabel;
		}
	
	}
}