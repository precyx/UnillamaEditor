package com.kiko.ui
{
	/**
	 * Version 1.03
	 */
	// adobe
	import com.kiko.display.Image;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.CapsStyle;
	import flash.display.Stage;
	import flash.display.LineScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	//
	// own
	import com.kiko.display.Rect;
	//
	public class Slider extends Sprite
	{
		// data
		private var value:Number;
		//
		// graphics
		private var line:Sprite;
		private var active:Sprite;
		private var grabber:Sprite;
		private var mintf:TextField;
		private var maxtf:TextField;
		private var dragRect:Rectangle;
		//
		//
		public function Slider(stage:Stage, text:String, minVal:int, maxVal:int, startVal:int, width:uint ):void
		{
			
			line = new Sprite();
			line.graphics.lineStyle(1, 0x999999, 1, false, LineScaleMode.NONE, CapsStyle.SQUARE);
			line.graphics.moveTo(0, 0);
			line.graphics.lineTo(width, 0);
			addChild(line);
			line.x = 0;
			line.y = 25;
			
			active = new Sprite();
			active.graphics.lineStyle(1, 0x8ee800, 1, false, LineScaleMode.NONE, CapsStyle.SQUARE);
			active.graphics.moveTo(0, 0);
			active.graphics.lineTo(width / 2, 0);
			addChild(active);
			active.x = 0;
			active.y = 25;
			
			var format:TextFormat = new TextFormat("Arial", 12, 0x999999);
			var format2:TextFormat = new TextFormat("Arial", 12, 0x656565);
			
			var valuetf:TextField = new TextField();
			valuetf.text = text;
			addChild(valuetf);
			valuetf.setTextFormat(format2);
			valuetf.background = false;
			valuetf.backgroundColor = 0xff00aa;
			valuetf.autoSize = TextFieldAutoSize.LEFT;
			valuetf.selectable = false;
			valuetf.mouseEnabled = false;
			valuetf.y = 0;

			
			mintf = new TextField();
			mintf.text = String(minVal);
			addChild(mintf);
			mintf.setTextFormat(format);
			mintf.background = false;
			mintf.backgroundColor = 0xff00aa;
			mintf.autoSize = TextFieldAutoSize.LEFT;
			mintf.selectable = false;
			mintf.mouseEnabled = false;
			mintf.y = 32;
			
			maxtf = new TextField();
			maxtf.text = String(maxVal);
			addChild(maxtf);
			maxtf.setTextFormat(format);
			maxtf.background = false;
			maxtf.backgroundColor = 0xff00aa;
			maxtf.autoSize = TextFieldAutoSize.RIGHT;
			maxtf.x = width - maxtf.width;
			maxtf.selectable = false;
			maxtf.mouseEnabled = false;
			maxtf.y = 32;
			
			trace(this.height);
			
			grabber = new Sprite();
			grabber.graphics.lineStyle(1, 0x999999);
			grabber.graphics.beginFill(0xffffff);
			grabber.graphics.drawCircle(0, 0, 8);
			addChild(grabber);
			grabber.y = 25;
			grabber.x = 8;
			updateGrabber(active, grabber, line, valuetf, text, format2, minVal, maxVal);
			grabber.buttonMode = true;
			dragRect = new Rectangle(8, 25, width - 15, 0);
			var loop:Function;
			grabber.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent) {
				var t:Sprite = Sprite(e.target);
				t.startDrag(false, dragRect);
				t.addEventListener(Event.ENTER_FRAME, loop = function() {
					updateGrabber(active, grabber, line, valuetf, text, format2, minVal, maxVal);
				});
				
			});
			stage.addEventListener(MouseEvent.MOUSE_UP, function() {
				grabber.stopDrag();
				if (grabber.hasEventListener(Event.ENTER_FRAME)) grabber.removeEventListener(Event.ENTER_FRAME, loop);
				updateGrabber(active, grabber, line, valuetf, text, format2, minVal, maxVal);
			});
			
			//test loop
			addEventListener(Event.ENTER_FRAME, function() {
				//trace(grabber.hasEventListener(Event.ENTER_FRAME));
				//trace(value);
			});

		}
		// privates
		private function updateGrabber(active, grabber, line, valuetf, text, format2, minVal, maxVal):void {
			active.graphics.clear();
			active.graphics.lineStyle(1, 0x8ee800, 1, false, "normal", CapsStyle.SQUARE);
			active.graphics.moveTo(0, 0);
			active.graphics.lineTo(grabber.x, 0);
			value = Math.round((grabber.x - 8) / (line.width - 16) * (maxVal - minVal) + minVal);
			valuetf.text = text + ": " +String(value);
			valuetf.setTextFormat(format2);
		}
		
		// getters/setters
		override public function set width (value:Number) : void {
			line.width = value;
			maxtf.x = line.width - maxtf.width;
			dragRect = new Rectangle(8, 25, line.width - 15, 0);
		}

		
	}//end-class
}//end-pack