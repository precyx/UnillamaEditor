package com.pascal.text
{
	// adobe
	import flash.display.Sprite;
	import flash.text.TextField;
	//
	//
	public class TField extends Sprite
	{
		//
		private var tField:TextField;
		//
		//
		public function TField(centered:Boolean = false):void
		{
			tField = new TextField();
			addChild(tField);
			tField.text = "tField";
			if (centered) {
				tField.x = -tField.width / 2;
				tField.y = -tField.height / 2;
			}
		}
	}//end-class
}//end-pack