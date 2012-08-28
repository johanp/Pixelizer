package examples.transform {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.components.render.PxTextFieldComponent;
	import pixelizer.Pixelizer;
	import pixelizer.prefabs.gui.PxTextFieldEntity;
	import pixelizer.PxEntity;
	import pixelizer.PxInputSystem;
	import pixelizer.PxScene;
	import pixelizer.utils.PxMath;
	
	public class TransformExampleScene extends PxScene {
		[Embed( source="../assets/box.png" )]
		private static var boxCls : Class;

		private var _yScaleEntity : PxEntity;
		private var _xScaleEntity : PxEntity;
		private var _rotatingEntity : PxEntity;
		private var _pivotingEntity : PxEntity;
		private var _stillEntity : PxEntity;
		private var _movingEntity : PxEntity;
		
		private var _timePassed : Number = 0;
		
		public function TransformExampleScene() {
			// bg color of scene
			backgroundColor = Pixelizer.COLOR_WHITE;
			
			var textEntity : PxTextFieldEntity;
			
			// plain text
			textEntity = new PxTextFieldEntity( "position                              rotation                              scaling" );
			textEntity.textField.width = 320;
			textEntity.textField.alignment = Pixelizer.CENTER;
			textEntity.transform.setPosition( 0, 10 );
			addEntity( textEntity );
			
			// image to use
			var bd : BitmapData = new boxCls().bitmapData;
			
			// position examples
			_stillEntity = new PxEntity( 40, 80 );
			_stillEntity.addComponent( new PxBlitRenderComponent( bd ) );
			addEntity( _stillEntity );
			
			_movingEntity = new PxEntity( 40, 160 );
			_movingEntity.addComponent( new PxBlitRenderComponent( bd ) );
			addEntity( _movingEntity );
			
			// rotation examples
			_rotatingEntity = new PxEntity( 160, 80 );
			_rotatingEntity.addComponent( new PxBlitRenderComponent( bd ) );
			addEntity( _rotatingEntity );
			
			_pivotingEntity = new PxEntity( 160, 160 );
			_pivotingEntity.addComponent( new PxBlitRenderComponent( bd ) );
			_pivotingEntity.transform.pivotOffset = new Point( -16, -8 );
			addEntity( _pivotingEntity );
			
			// scale examples
			_xScaleEntity = new PxEntity( 280, 80 );
			_xScaleEntity.addComponent( new PxBlitRenderComponent( bd ) );
			addEntity( _xScaleEntity );
			
			_yScaleEntity = new PxEntity( 280, 160 );
			_yScaleEntity.addComponent( new PxBlitRenderComponent( bd ) );
			addEntity( _yScaleEntity );
		
		}
		
		override public function dispose() : void {
			_stillEntity = _movingEntity = _rotatingEntity = _pivotingEntity = _xScaleEntity = _yScaleEntity = null;
			
			super.dispose();
		}
		
		override public function update( pDT : Number ) : void {
			super.update( pDT );
			
			_timePassed += pDT;
			
			_movingEntity.transform.position.x = 40 + 20 * PxMath.cos( _timePassed );
			_movingEntity.transform.position.y = 160 + 40 * PxMath.sin( _timePassed * 2 );
			
			_rotatingEntity.transform.rotation = _timePassed * 2;
			_pivotingEntity.transform.rotation = _timePassed * 2;
			
			_xScaleEntity.transform.scaleX = 2 * PxMath.cos( _timePassed * 2 );
			_yScaleEntity.transform.scaleY = 2 * PxMath.sin( _timePassed * 2 );
			
			if ( inputSystem.isPressed( PxInputSystem.KEY_ESC ) ) {
				engine.popScene();
			}
		}
	
	}

}