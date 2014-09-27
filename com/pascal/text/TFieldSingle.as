package com.pascal.text
{
	/**
	 * Version 1.05
	 */
	// adobe
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	//
	//
	public class TFieldSingle extends Sprite
	{
		//
		public var tField:TextField;
		private var centered:Boolean;
		private var currentFormat:TextFormat;
		//
		//
		public function TFieldSingle(centered:Boolean = false):void
		{
			this.centered = centered;
			this.currentFormat = new TextFormat("Arial", 10, 0x000000);
			tField = new TextField();
			addChild(tField);
			tField.text = "tFieldSingle";
			tField.autoSize = TextFieldAutoSize.LEFT;
			if (centered) centerTF();
		}
		public function centerTF():void {
			tField.x = -tField.textWidth / 2;
			tField.y = -tField.textHeight / 2;
		}
		public function get text () : String {
			return tField.text;
		};
		public function set text (value:String) : void {
			tField.text = value;
			this.setTextFormat(currentFormat);
		};
		public function setTextFormat (format:TextFormat, beginIndex:int = -1, endIndex:int = -1) : void {
			this.currentFormat = format;
			tField.setTextFormat(format, beginIndex, endIndex);
			if (centered) this.centerTF();
		};
		
		//override public function setTextFormat (format:TextFormat, beginIndex:int=-1, endIndex:int=-1) : void;
		
	}//end-class
}//end-pack