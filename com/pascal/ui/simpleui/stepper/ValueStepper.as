package com.pascal.ui.simpleui.stepper
{
	// adobe
	import flash.display.Sprite
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	//
	// own
	import com.pascal.ui.simpleui.stepper.ValueStepperView;
	import com.pascal.ui.simpleui.stepper.StepperArrow;
	//
	public class ValueStepper extends Sprite
	{
		// graphics
		private var valueStepper:ValueStepperView;
		//
		// data
		private var _startValue:Number;
		private var _valueStep:Number;
		private var _maxValue:Number;
		private var _minValue:Number;
		private var _roundCount:uint;
		private var _maxChars:uint;
		//
		// control
		private var _timeID:uint;
		private var _fastUpActi:Boolean;
		private var _fastDownActi:Boolean;
		//
		//
		public function ValueStepper(labelText:String, width:Number, height:Number = 30, color:uint = 0xd04f00, startValue:Number = 10, valueStep:Number = 1, maxValue:Number = 999, minValue:Number = 0, roundCount:uint = 0, maxChars:uint = 3):void {
			this._startValue 	= startValue;
			this._valueStep 	= valueStep;
			this._maxValue 		= maxValue;
			this._minValue 		= minValue;
			this._roundCount 	= roundCount;
			this._maxChars 		= maxChars;
			//
			valueStepper = new ValueStepperView(labelText,width,height,color, roundCount);
			addChild(valueStepper);
			initValueStepper();
			
		}
		private function initValueStepper():void {
			//
			valueStepper.valueInput.tField.text = String(_startValue);
			valueStepper.valueInput.tField.maxChars = _maxChars;
			trace(_maxChars);
			valueStepper.updateTextFormat();
			//
			valueStepper.upStepper.addEventListener(MouseEvent.MOUSE_OVER, mouseOver, false, 0, true);
			valueStepper.upStepper.addEventListener(MouseEvent.MOUSE_OUT, mouseOut, false, 0, true);
			valueStepper.upStepper.addEventListener(MouseEvent.CLICK, clickUpStepper, false, 0, true);
			valueStepper.upStepper.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownUpStepper, false, 0, true);
			valueStepper.upStepper.addEventListener(MouseEvent.MOUSE_OUT, mouseOutUpStepper, false, 0, true);
			//
			valueStepper.downStepper.addEventListener(MouseEvent.MOUSE_OVER, mouseOver, false, 0, true);
			valueStepper.downStepper.addEventListener(MouseEvent.MOUSE_OUT, mouseOut, false, 0, true);
			valueStepper.downStepper.addEventListener(MouseEvent.CLICK, clickDownStepper, false, 0, true);
			valueStepper.downStepper.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownDownStepper, false, 0, true);
			valueStepper.downStepper.addEventListener(MouseEvent.MOUSE_OUT, mouseOutDownStepper, false, 0, true);
			//
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		////////// EVENT HANDLERS ////////////////////////////////////
		private function mouseOutUpStepper(e:MouseEvent):void {
			_fastUpActi = false;
			if ( this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, loop, false);
		}
		private function mouseOutDownStepper(e:MouseEvent):void {
			_fastDownActi = false;
			if ( this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, loop, false);
		}
		private function mouseUp(e:MouseEvent):void {
			resetSpeedMode();
		}
		private function resetSpeedMode():void {
			clearTimeout(_timeID);
			_fastUpActi = false;
			_fastDownActi = false;
			if ( this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, loop, false);
		}
		private function mouseDownUpStepper(e:MouseEvent):void {
			_timeID = setTimeout(speedValuingUp, 200);
		}
		private function mouseDownDownStepper(e:MouseEvent):void {
			_timeID = setTimeout(speedValuingDown, 200);
		}
		private function speedValuingUp():void {
			_fastUpActi = true;
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
		private function speedValuingDown():void {
			_fastDownActi = true;
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
		private function loop(e:Event):void {
			if (_fastUpActi) 	changeValue("+");
			if (_fastDownActi) 	changeValue("-");
			//trace("any" + getTimer());
		}
		private function mouseOver(e:MouseEvent):void {
			var v:StepperArrow = StepperArrow(e.currentTarget);
			v.overState();
		}
		private function mouseOut(e:MouseEvent):void {
			var v:StepperArrow = StepperArrow(e.currentTarget);
			v.outState();
		}
		private function clickDownStepper(e:MouseEvent):void {
			changeValue("-");
		}
		private function clickUpStepper(e:MouseEvent):void {
			changeValue("+");
		}
		private function changeValue(operation:String):void {
			if(operation == "+") valueStepper.value += _valueStep;
			if(operation == "-") valueStepper.value -= _valueStep;
			if ( valueStepper.value < _minValue) valueStepper.value = _minValue; 
			if ( valueStepper.value > _maxValue) valueStepper.value = _maxValue;
			valueStepper.updateTextFormat();
		}
		/////////// GETTERS SETTERS //////////////////////////////////
		public function set value(v:Number):void {
			valueStepper.value = v;
			valueStepper.updateTextFormat();
		}
		public function get value():Number {
			return valueStepper.value;
		}
		public function set valueStep( v:Number ):void {
			this._valueStep = v;
		}
		public function get valueStep():Number {
			return _valueStep;
		}
		public function set maxValue( v:Number ):void {
			this._maxValue = v;
		}
		public function get maxValue():Number {
			return _maxValue;
		}
		public function set minValue( v:Number ):void {
			this._minValue = v;
		}
		public function get minValue():Number {
			return _minValue;
		}
	}//end-class
}//end-pack