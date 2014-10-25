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
		public var borderColor:uint;
		public var _hoverAlpha:Number = 0;
		
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
			drawBg(borderColor, 0xffffff);
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
			drawBg(hoverColor, hoverColor);
			tf.textColor = 0xffffff;
			});
			hit.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent) {
				// tweenlite
				/*TweenLite.killTweensOf(me);
				TweenLite.to(me, 0.5, { _hoverAlpha:0, ease:Circ.easeOut, onUpdate:function() {
					drawBg(hoverColor, hoverColor, _hoverAlpha);
				} } );
				tf.textColor = textColor;*/
				_hoverAlpha = 0;
				drawBg(borderColor, 0xffffff);
				tf.textColor = textColor;
			});
		}
		// privates
		private function drawBg(lineColor:uint, fillColor:uint = 0xffffff, fillAlpha:Number = 1) {
			bg.graphics.clear();
			bg.graphics.lineStyle(1, borderColor, 1, true, LineScaleMode.NONE );
			bg.graphics.beginFill(fillColor, fillAlpha);
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
			drawBg(borderColor, 0xffffff);
			hit.width = value;
		}
		override public function set height(value:Number):void {
			btnheight = value;
			drawBg(borderColor);
			tf.y = bg.height / 2 - tf.height / 2;
			hit.height = bg.height;
		}
		
		
	}//end-class
}//end-pack