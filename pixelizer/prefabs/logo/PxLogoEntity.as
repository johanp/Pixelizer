package pixelizer.prefabs.logo {
	import pixelizer.components.render.PxBlitRenderComponent;
	import pixelizer.components.render.PxTextFieldComponent;
	import pixelizer.Pixelizer;
	import pixelizer.prefabs.gui.PxTextFieldEntity;
	import pixelizer.PxEntity;
	import pixelizer.utils.PxImageUtil;
	import pixelizer.PxInputSystem;
	
	/**
	 * Entity displaying animated Pixelizer logo.
	 * @author Johan Peitz
	 */
	public class PxLogoEntity extends PxEntity {
		
		private var _logoData : String = "0111111111111111111111111100" + "1000000000000000000000000010" + "1022034042223004222333440015" + "1020204042003000002300404015" + "1020230402203004020330404015" + "1022034042003004200300440015" + "1020034042223334222333404015" + "1000000000000000000000000015" + "0111111111111111111110011155" + "0055555555555555555510155550" + "0000000000000000000011550000" + "0000000000000000000015500000" + "0000000000000000000005000000";
		
		private var _logoColors : Array = [ Pixelizer.COLOR_WHITE, Pixelizer.COLOR_BLACK, Pixelizer.COLOR_RED, Pixelizer.COLOR_GREEN, Pixelizer.COLOR_BLUE, Pixelizer.COLOR_LIGHT_GRAY ]
		private var _timePassed : Number;
		private var _fadeOut : Boolean = false;
		private var _bg : PxBlitRenderComponent;
		private var _textComp : PxTextFieldComponent;
		private var _versionEntity : PxTextFieldEntity;
		
		private var _onLogoComplete : Function;
		
		private var _pixelSize : int = 5;
		
		public function PxLogoEntity( pOnCompleteCallback : Function = null ) {
			_onLogoComplete = pOnCompleteCallback;
			// big white background
			_bg = addComponent( new PxBlitRenderComponent( PxImageUtil.createRect( Pixelizer.engine.width, Pixelizer.engine.height, 0xFFFFFF ) ) ) as PxBlitRenderComponent;
			//_bg =  new PxBlitRenderComponent( PxImageUtil.createRect( Pixelizer.engine.width, Pixelizer.engine.height, 0xFFFFFF ) ) ;
			// create pixel entities
			for ( var y : int = 0; y < 13; y++ ) {
				for ( var x : int = 0; x < 28; x++ ) {
					var c : int = parseInt( _logoData.substr( x + y * 28, 1 ) );
					if ( c > 0 ) {
						var z : Number = -x * 10 + y * 10 - 200 - 30 * Math.random();
						var e : PxLogoPixelEntity = new PxLogoPixelEntity(( x - 14 ) * _pixelSize, ( y - 10 ) * _pixelSize, z, _pixelSize - 1, _logoColors[ c ] );
						e.fallIn( 3 + x / 20 + ( 13 - y ) / 30 + Math.random() / 5 );
						addEntity( e );
					}
				}
			}
			
			transform.setPosition( Pixelizer.engine.width / 2, Pixelizer.engine.height / 2 );
			
			_textComp = new PxTextFieldComponent();
			_textComp.text = "POWERED BY";
			_textComp.color = Pixelizer.COLOR_GRAY;
			_textComp.setHotspot( -9, 60 );
			_textComp.alpha = 0;
			addComponent( _textComp );
			
			_versionEntity = new PxTextFieldEntity();
			_versionEntity.textField.text = "v" + Pixelizer.MAJOR_VERSION + "." + Pixelizer.MINOR_VERSION + "." + Pixelizer.INTERNAL_VERSION;
			_versionEntity.textField.color = Pixelizer.COLOR_GRAY;
			_versionEntity.textField.alpha = 0;
			_versionEntity.transform.setPosition( Pixelizer.engine.width / 2 - 26, - Pixelizer.engine.height / 2 + 2);
			addEntity( _versionEntity );
			
			_timePassed = 0;
			Pixelizer.engine.resetTimers();
		}
		
		override public function dispose() : void {
			_bg = null;
			_textComp = null;
			_versionEntity = null;
			super.dispose();
		}
		
		override public function update( pDT : Number ) : void {
			_timePassed += pDT;
			
			if ( !_fadeOut ) {
				if ( _timePassed > 1 && _timePassed < 2 ) {
					if ( _textComp.alpha < 1 ) {
						_textComp.alpha += 0.05;
						_versionEntity.textField.alpha += 0.05;
					}
				}
				if ( _timePassed > 3.5 && _timePassed < 4.5 ) {
					if ( _textComp.alpha > 0 ) {
						_textComp.alpha -= 0.05;
						_versionEntity.textField.alpha -= 0.05;
					}
				}
			}
			
			if ( _fadeOut ) {
				if ( _bg.alpha > 0 ) {
					_bg.alpha -= pDT * 10;
				}
			} else {
				if ( scene.inputSystem.isPressed( PxInputSystem.KEY_ESC ) || scene.inputSystem.mousePressed ) {
					_textComp.alpha = 0;
					_versionEntity.textField.alpha = 0;
					_fadeOut = true;
					for each ( var e : PxEntity in entities ) {
						e.destroyIn( 0 );
					}
					destroyIn( 1 );
					if ( _onLogoComplete != null ) {
						_onLogoComplete();
					}
				} else if ( _timePassed > 5.2 && !_fadeOut ) {
					_fadeOut = true;
					destroyIn( 1 );
					if ( _onLogoComplete != null ) {
						_onLogoComplete();
					}
				}
			}
			
			super.update( pDT );
		
		}
	
	}

}