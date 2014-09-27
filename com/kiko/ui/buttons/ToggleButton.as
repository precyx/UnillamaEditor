package com.kiko.ui.buttons
{
	/**
	 * Version 1.01
	 */
	// adobe
	import com.kiko.display.Image;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	//
	// own
	import com.kiko.display.Rect;
	//
	public class ToggleButton extends Sprite
	{
		// data
		public var toggleOn:Boolean;
		//
		// graphics
		private var toggler:Sprite;
		private var active:Sprite;
		private var active_icon:Image;
		//
		//
		public function ToggleButton(text:String, toggleColor:uint = 0x8ee800):void
		{
			toggler = new Sprite();
			toggler.graphics.beginFill(0x000000, 0);
			toggler.graphics.lineStyle(1, 0xcccccc);
			
			drawToggler();
			addChild(toggler);
			
			active = new Sprite();
			active.graphics.lineStyle(1, 0xcccccc);
			active.graphics.beginFill(toggleColor);
			active.graphics.drawRoundRect(0, 0, 7, 7, 2, 2);
			addChild(active);
			active.x = toggler.width / 2 - active.width / 2;
			active.y = toggler.height / 2 - active.height / 2;
			active.visible = false;
			
			active_icon = new Image("resources/swf/cross_icon.swf", function() {
				active_icon.scaleX = active_icon.scaleY = 0.7;
				active_icon.x = toggler.width / 2 - active_icon.width / 2;
				active_icon.y = toggler.height / 2 - active_icon.height / 2;
				
			});
			addChild(active_icon);
			active_icon.visible = false;
			
			
			var format:TextFormat = new TextFormat("Arial", 12, 0x656565);
			var tf:TextField = new TextField();
			tf.text = text;
			addChild(tf);
			tf.setTextFormat(format);
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.x = 22;
			tf.y = toggler.height / 2 - tf.height / 2;
			tf.selectable = false;
			tf.mouseEnabled = false;
			
			var hit:Rect = new Rect(tf.x + tf.width, toggler.height, 0xff00aa);
			hit.alpha = 0;
			addChild(hit);
			hit.buttonMode = true;
			
			hit.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent) {
				toggler.graphics.clear();
				toggler.graphics.lineStyle(1, 0xE4E4E4);
				drawToggler();
				tf.textColor = 0x969696;
				
			});
			hit.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent) {
				toggler.graphics.lineStyle(1, 0xcccccc);
				toggler.graphics.beginFill(0xffffff);
				drawToggler();
				tf.textColor = 0x656565;
				
			});
			hit.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
				toggleOn = !toggleOn;
				active_icon.visible = toggleOn ? true : false;
				
			});
			
		}
		// privates
		private function drawToggler() {
			toggler.graphics.drawRoundRect(0, 0, 16, 16, 4, 4);
		}
		
		
	}//end-class
}//end-pack