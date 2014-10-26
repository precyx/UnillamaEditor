package com.kiko.ui
{
	// adobe
	import com.kiko.ui.buttons.IconButton;
	import flash.display.Sprite
	//
	// own
	//
	public class Grabber extends Sprite
	{
		// data
		public var startX:Number = 8;
		public var buttons:Array;
		//
		//
		public function Grabber():void{
			buttons = new Array();
		}
		
		//publics
		public function addButton(but:IconButton):void {
			buttons.push(but);
		}
		public function get numButtons():uint {
			return buttons.length;
		}
	}//end-class
}//end-pack