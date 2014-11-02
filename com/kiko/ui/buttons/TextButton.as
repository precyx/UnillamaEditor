package com.kiko.ui.buttons
{
	/**
	 * Version 1.04
	 */
	// adobe
	import com.kiko.display.Image;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.LineScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	//import com.greensock.*;
	//import com.greensock.easing.*;
	//
	// own
	import com.kiko.display.Rect;
	//
	public class TextButton extends Sprite
	{
		// data
		private var btnwidth:Number;
		private var btnheight:Number;
		//
		public var textColor:uint;
		public var borderColor:uint;
		public var hoverColor:uint;
		public var bgColor:uint;
		public var bgAlpha:Number;
		
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
			this.textColor = textColor;
			this.borderColor = borderColor;
			this.hoverColor = hoverColor;
			this.bgColor = 0xFFFFFF;
			this.bgAlpha = 0;
			
			bg = new Sprite();
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
			
			var me:TextButton = this;
			hit.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent) {
			// tweenlite
			/*TweenLite.to(me, 0.3, { _hoverAlpha:1, ease:Circ.easeOut, onUpdate:function() {
				drawBg(hoverColor, hoverColor, _hoverAlpha);
			} } );
			tf.textColor = 0xffffff;*/
			bgColor = hoverColor;
			bgAlpha = 1;
			drawBg();
			tf.textColor = 0xFFFFFF;
			});
			hit.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent) {
				// tweenlite
				/*TweenLite.killTweensOf(me);
				TweenLite.to(me, 0.5, { _hoverAlpha:0, ease:Circ.easeOut, onUpdate:function() {
					drawBg(hoverColor, hoverColor, _hoverAlpha);
				} } );
				tf.textColor = textColor;*/
				bgColor = 0xFFFFFF;
				bgAlpha = 0;
				drawBg();
				tf.textColor = textColor;
			});
		}
		// privates
		private function drawBg() {
			bg.graphics.clear();
			bg.graphics.lineStyle(1, borderColor, 1, true, LineScaleMode.NONE );
			bg.graphics.beginFill(bgColor, bgAlpha);
			bg.graphics.drawRoundRect(0, 0, btnwidth, btnheight, 4, 4);
		}
		
		
		//getters/setters
		override public function get width () : Number {
			return bg.width;
		}
		override public function set width (value:Number) : void {
			if (value < tf.x + tf.width) value = tf.x*2 + tf.width;
			btnwidth = value;
			drawBg();
			hit.width = value;
		}
		override public function set height(value:Number):void {
			btnheight = value;
			drawBg();
			tf.y = bg.height / 2 - tf.height / 2;
			hit.height = bg.height;
		}
		
		
	}//end-class
}//end-pack