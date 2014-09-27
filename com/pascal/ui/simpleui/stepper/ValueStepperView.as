package com.pascal.ui.simpleui.stepper
{
	// adobe
	import flash.display.Sprite
	import flash.text.TextFormat;
	//
	// own
	import com.pascal.display.Rect;
	import com.pascal.text.TFieldSingle;
	//
	public class ValueStepperView extends Sprite
	{
		// graphics
		private var bg:Rect;
		private var label:TFieldSingle;
		private var textFormat:TextFormat;
		public var valueInput:TFieldSingle;
		public var upStepper:StepperArrow;
		public var downStepper:StepperArrow;
		//
		// data
		private var _labelText:String;
		private var _width:Number;
		private var _height:Number;
		private var _color:Number;
		private var _roundCount:uint;
		//
		//
		public function ValueStepperView(labelText:String, width:Number, height:Number, color:uint, roundCount:uint):void {
			this._labelText = labelText;
			this._width = width;
			this._height = height;
			this._color = color;
			this._roundCount = roundCount;
			//
			createElements();
		}
		private function createElements():void {
			// bg
			bg = new Rect(_width, _height, _color);
			addChild(bg);
			//
			// label
			label = new TFieldSingle();
			label.tField.text = _labelText;
			label.tField.setTextFormat( new TextFormat(TextLayout.FONT, TextLayout.SIZE, TextLayout.COLOR));
			//label.tField.background = true;
			//label.tField.backgroundColor = 0x000000;
			label.tField.selectable = false;
			addChild(label);
			label.y = bg.height/2 - label.height/2;
			label.x = TextLayout.MARGIN
			//
			// value input
			textFormat = new TextFormat(TextLayout.FONT, TextLayout.SIZE, TextLayout.COLOR);
			valueInput = new TFieldSingle(false);
			valueInput.tField.setTextFormat(textFormat);
			valueInput.tField.type = "input";
			valueInput.tField.autoSize = "right";
			//valueInput.tField.background = true;
			//valueInput.tField.backgroundColor = 0x000000;
			valueInput.tField.restrict = "0-9.";
			addChild(valueInput);
			valueInput.y = bg.height/2 - valueInput.height/2;
			valueInput.x = bg.width - valueInput.width - valueInput.width/2 - TextLayout.MARGIN;
			//
			// up stepper
			upStepper = new StepperArrow( _height, _height/2, _color);
			upStepper.buttonMode = true;
			addChild(upStepper);
			upStepper.x = bg.width + ElementLayout.MARGIN;
			//
			// down stepper
			downStepper = new StepperArrow( _height, _height/2, _color);
			downStepper.buttonMode = true;	
			addChild(downStepper);
			downStepper.x = bg.width + downStepper.width + ElementLayout.MARGIN;
			downStepper.y = downStepper.height + downStepper.height;
			downStepper.rotation = 180;
		}
		public function updateTextFormat():void {
			valueInput.tField.setTextFormat(textFormat);
		}
		/////// GETTERS SETTERS //////////////////////////////////////
		public function set value( v:Number ):void {
			valueInput.tField.text = String(v.toFixed(_roundCount));
		}
		public function get value():Number {
			return Number(valueInput.tField.text);
		}
	}//end-class
}//end - pack

class TextLayout {
	internal static const FONT:String 	= "Segoe UI";
	internal static const SIZE:uint 		= 12;
	internal static const COLOR:uint 		= 0xFFFFFF;
	internal static const MARGIN:Number 	= 5;
}
class ElementLayout {
	internal static const MARGIN:Number 	= 5;
}








