package com.pascal.ui.glowui
{
	// adobe
	import flash.display.Sprite
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	//
	// own
	import com.pascal.ui.glowui.Content;
	//
	public class TextContent extends Content
	{
		// graphics
		private var _format:TextFormat;
		public var _tf:TextField;
		//
		// data temp
		private var _prev_text:String;
		private var _multiple_text_counter:uint = 1;
		//
		//
		public function TextContent(initText:String = ""):void
		{
			_format = new TextFormat("Segoe UI", 12, 0xdddddd);
			_format.leading = 3;
			_tf = new TextField();
			addChild(_tf);
			_tf.setTextFormat(_format);
			_tf.defaultTextFormat = _format;
			_tf.backgroundColor = 0x333333;
			_tf.background = true;
			_tf.multiline = true;
			_tf.wordWrap = true;
			_tf.height = 200;
			_tf.width = 200;
			_tf.text = initText;
		}
		
		
		// publics
		public function appendText(text:String, scroller:ScrollElement):void {
			if ( text == _prev_text ) {
				_multiple_text_counter++;
				text = text + "  " + String(_multiple_text_counter) + "  ";
				
			}
			else {
				_multiple_text_counter = 1;
				_prev_text = text;
			}
			
			
			_tf.appendText("\n" + text);
			_tf.scrollV += 999;
			scroller.scrollerYToMax();
			
			
			if ( _multiple_text_counter > 1 ) {
				var numlength = String(_multiple_text_counter).length
				var txlength = _tf.text.length;
				var format:TextFormat = new TextFormat("Arial", 8, 0xaaff00);
				format.align = TextFormatAlign.RIGHT;
				
				_tf.setTextFormat( format, txlength - 3 - numlength, txlength - 1);
			}
		}
		
		// getters/setters
		override public function set width (value:Number) : void {
			this._tf.width = value;
		}
		override public function set height (value:Number) : void {
			this._tf.height = value;
		}
		
		
		
		
	}//end-class
}//end-pack