package com.kiko.ui.buttons
{
	/**
	 * Version 1.03
	 */
	// adobe
	import com.kiko.display.Image;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.LineScaleMode;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	//
	// own
	import com.kiko.display.Rect;
	//
	public class TextButton extends Sprite
	{
		// data
		private var btnwidth:Number;
		private var btnheight:Number;
		private var borderColor:uint;
		//
		// graphics
		private var bg:Sprite;
		private var hit:Rect;
		private var tf:TextField;
		//
		//
		public function TextButton(text:String, width:Number, height:Number = 25, textColor:uint = 0x656565, borderColor:uint = 0xcccccc, hoverColor:uint = 0x656565):void
		{
			this.btnwidth = width;
			this.btnheight = height;
			this.borderColor = borderColor;
			
			bg = new Sprite();
			bg.graphics.lineStyle(1, borderColor, 1, true, LineScaleMode.NONE );
			bg.graphics.beginFill(0xffffff);
			drawBg();
			addChild(bg);
			
			var format:TextFormat = new TextFormat("Arial", 12, textColor);
			tf = new TextField();
			tf.text = text;
			addChild(tf);
			tf.setTextFormat(format);
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.x = 10;
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.y = bg.height / 2 - tf.height / 2;
			
			hit = new Rect(bg.width, bg.height, 0xff00aa);
			hit.alpha = 0;
			addChild(hit);
			hit.buttonMode = true;
			
			hit.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent) {
				bg.graphics.clear();
				bg.graphics.lineStyle(1, hoverColor, 1, true, LineScaleMode.NONE );
				bg.graphics.beginFill(hoverColor);
				drawBg();
				tf.textColor = 0xffffff;
			});
			hit.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent) {
				
				bg.graphics.clear();
				bg.graphics.lineStyle(1, borderColor, 1, true, LineScaleMode.NONE );
				bg.graphics.beginFill(0xffffff);
				drawBg();
				tf.textColor = textColor;
			});
		}
		// privates
		private function drawBg() {
			bg.graphics.drawRoundRect(0, 0, btnwidth, btnheight, 4, 4);
		}
		
		
		//getters/setters
		override public function get width () : Number {
			return bg.width;
		}
		override public function set width (value:Number) : void {
			if (value < tf.x + tf.width) value = tf.x*2 + tf.width;
			bg.graphics.clear();
			btnwidth = value;
			bg.graphics.lineStyle(1, borderColor, 1, true, LineScaleMode.NONE );
			bg.graphics.beginFill(0xffffff);
			drawBg();
			hit.width = value;
		}
		
		
	}//end-class
}//end-pack