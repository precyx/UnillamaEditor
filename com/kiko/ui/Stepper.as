package com.kiko.ui
{
	/**
	 * Version 1.03
	* todo:
		 * kommastellige Zahlen unterstützen
		 * 
	 */
	// adobe
	import com.kiko.display.Image;
	import com.kiko.ui.buttons.IconButton;
	import flash.automation.Configuration;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.LineScaleMode;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.KeyboardEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	//
	// own
	import com.kiko.display.Rect;
	//
	public class Stepper extends Sprite
	{
		// data
		private var _value:Number;
		private var _text:String;
		private var minVal:int;
		private var maxVal:int;
		//
		// flags
		private var _confirm:Boolean;
		//
		// graphics
		private var bg:Sprite;
		private var boundaryLine:Sprite;
		private var format:TextFormat;
		private var tf:TextField;
		private var value_tf:TextField;
		private var upButton:IconButton;
		private var downButton:IconButton;
		private var confirmButton:IconButton;
		//
		//
		public function Stepper(text:String, minVal:int, maxVal:int, startVal:int, stepVal:int, width:uint ):void
		{
			if (startVal < minVal) startVal = minVal;
			if (startVal > maxVal) startVal = maxVal;
			this.minVal = minVal;
			this.maxVal = maxVal;
			_value = startVal;
			_text = text;
			
			var me:Stepper = this;
			
			bg = new Sprite();
			drawBg(width);
			addChild(bg);
			
			boundaryLine = new Sprite();
			boundaryLine.graphics.lineStyle(1, 0x999999, 1, false, LineScaleMode.NONE);
			boundaryLine.graphics.moveTo(0, 0);
			boundaryLine.graphics.lineTo(0, bg.height-1	);
			boundaryLine.x = bg.width - 40;
			addChild(boundaryLine);
			
			// confirm button
			confirmButton = new IconButton("resources/swf/confirm_icon.swf", function() {
				confirmButton.x = bg.width - confirmButton.width - 1;
			}, true, new Rect(40 - 1, bg.height - 1, 0xff00aa));
			addChild(confirmButton);
			confirmButton.buttonMode = true;
			confirmButton.visible = false;
			confirmButton.addEventListener(MouseEvent.MOUSE_OVER, function() {
				var ct:ColorTransform = new ColorTransform();
				ct.color = 0x1DE235;
				confirmButton.ico.transform.colorTransform = ct;
			});
			confirmButton.addEventListener(MouseEvent.MOUSE_OUT, function() {
				var ct:ColorTransform = new ColorTransform();
				ct.color = 0x8C8C8C;
				confirmButton.ico.transform.colorTransform = ct;
			});
			confirmButton.addEventListener(MouseEvent.CLICK, function() {
				confirm = false;
				value = Number(value_tf.text);
			});
			
			format = new TextFormat("Arial", 12, 0x656565);
			tf = new TextField();
			tf.text = _text + ": ";
			addChild(tf);
			tf.setTextFormat(format);
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.x = 10;
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.y = bg.height / 2 - tf.height / 2;
			
			value_tf = new TextField();
			value_tf.text = String(value);
			addChild(value_tf);
			value_tf.setTextFormat(format);
			value_tf.restrict = "0-9\\.\\-";
			value_tf.autoSize = TextFieldAutoSize.RIGHT;
			value_tf.type = TextFieldType.INPUT;
			value_tf.x = this.width - value_tf.width - 40 - 5;
			value_tf.y = bg.height / 2 - tf.height / 2;
			value_tf.addEventListener(TextEvent.TEXT_INPUT, function() {
				confirm = true;
			});
			
			// up down buttons
			upButton = new IconButton("resources/swf/up_icon.swf", function(){
				upButton.x = bg.width - upButton.width-1;
				upButton.y = 0;
			}, true, new Rect(40 - 1, 20, 0xff0000) );
			addChild(upButton);
			upButton.buttonMode = true;
			upButton.addEventListener(MouseEvent.MOUSE_OVER, overButton);
			upButton.addEventListener(MouseEvent.MOUSE_OUT, outButton);
			upButton.addEventListener(MouseEvent.CLICK, function() {
				value += stepVal;
			});
			downButton = new IconButton("resources/swf/down_icon.swf", function(){
				downButton.x = bg.width - downButton.width-1;
				downButton.y = bg.height - downButton.height-1;
			}, true, new Rect(40 - 1, 20 - 1, 0xff0000) );
			addChild(downButton);
			downButton.buttonMode = true;
			downButton.addEventListener(MouseEvent.MOUSE_OVER, overButton);
			downButton.addEventListener(MouseEvent.MOUSE_OUT, outButton);
			downButton.addEventListener(MouseEvent.CLICK, function() {
				value -= stepVal;
			});
			
			// listeners
			addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent) {
				if(e.keyCode == Keyboard.ENTER){
					if (confirm) {
						value = Number(value_tf.text);
						confirm = false;
					}
				}
				if (e.keyCode == Keyboard.BACKSPACE) {
					confirm = true;
				}
				value_tf.setTextFormat(format);
			});
			addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent) {
				value_tf.setTextFormat(format);
			});
			
			// display list
			setChildIndex(confirmButton, numChildren-1);
		}
		
		
		// privates
		private function drawBg(width:uint):void {
			bg.graphics.clear();
			bg.graphics.lineStyle(1, 0x999999, 1, false, LineScaleMode.NONE);
			bg.graphics.beginFill(0xffffff);
			bg.graphics.drawRoundRect(0, 0, width, 35, 4, 4);
		}
		private function overButton(e:MouseEvent):void {
			(e.currentTarget as IconButton).alpha = 0.5;
		}
		private function outButton(e:MouseEvent):void {
			(e.currentTarget as IconButton).alpha = 1;
		}

		// getters/setters
		override public function set width (value:Number) : void {
			var minWidth:Number = tf.width + value_tf.width + upButton.width + 15 + 15 + 30;
			if ( value <  minWidth) value = minWidth;
			drawBg(value);
			boundaryLine.x = value - 40;
			confirmButton.x = value - confirmButton.width - 1;
			value_tf.x = value - value_tf.width - 40 - 5;
			upButton.x = value - upButton.width - 1;
			downButton.x = value - downButton.width-1;
		}
		public function get value():Number {
			return _value;
		}
		public function set value(v:Number):void {
			if(!isNaN(v)){
			if (v < minVal) v = minVal;
			if (v > maxVal) v = maxVal;
			_value = v;
			}
			value_tf.text = String(_value);
			value_tf.setTextFormat(format);
		}
		public function set confirm(val:Boolean):void {
			_confirm = val;
			confirmButton.visible = confirm ? true : false;
			upButton.visible = confirm ? false : true;
			downButton.visible = confirm ? false : true;
		}
		public function get confirm():Boolean {
			return _confirm;
		}
	
		
	}//end-class
}//end-pack