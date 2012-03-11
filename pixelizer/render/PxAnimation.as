package pixelizer.render {
	
	/**
	 * Holds all information regarding an animation.
	 * @author Johan Peitz
	 */
	public class PxAnimation {
		/**
		 * Animation should stop on last from on completion.
		 */
		public static const ANIM_STOP : int = 1;
		/**
		 * Animation should restart after completion.
		 */
		public static const ANIM_LOOP : int = 2;
		/**
		 * Animation should continue into a different animation on completion.
		 */
		public static const ANIM_GOTO : int = 3;
		
		/**
		 * Identifier for this animation.
		 */
		public var label : String;
		/**
		 * Array of frames this animation consists of.
		 */
		public var frames : Array;
		/**
		 * On completion behaviour.
		 * ANIM_STOP, ANIM_LOOP, ANIM_GOTO
		 */
		public var onComplete : int;
		/**
		 * What animation to continue into on ANIM_GOTO.
		 */
		public var gotoLabel : String;
		/**
		 * Frame rate of this animation.
		 */
		public var fps : Number;
		
		/**
		 * Creates a new animation.
		 * @param	pLabel	Identifier for this animation.
		 * @param	pFrames	Array of frames this animation consists of.
		 * @param	pFramesPerSecond	Frame rate of this animation.
		 * @param	pOnComplete	On completion behaviour.
		 * @param	pGotoLabel	What animation to continue into on ANIM_GOTO.
		 */
		public function PxAnimation( pLabel : String, pFrames : Array, pFramesPerSecond : int = 10, pOnComplete : int = ANIM_STOP, pGotoLabel : String = "" ) {
			label = pLabel;
			frames = pFrames;
			fps = pFramesPerSecond;
			onComplete = pOnComplete;
			gotoLabel = pGotoLabel;
		}
	
	}
}