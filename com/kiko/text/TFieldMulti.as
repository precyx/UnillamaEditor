package com.kiko.text
{
	// adobe
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	//
	//
	public class TFieldMulti extends Sprite
	{
		//
		public var tField:TextField;
		//
		//
		public function TFieldMulti(width:Number, height:Number, centered:Boolean = false):void
		{
			tField = new TextField();
			addChild(tField);
			tField.width = width;
			tField.height = height;
			tField.text = "tFieldMulti multi multi multi multi multi";
			tField.multiline = true;
			tField.wordWrap = true;
			if (centered) {
				tField.x = -tField.width / 2;
				tField.y = -tField.height / 2;
			}
		}
	}//end-class
}//end-pack