package com.kiko.ui
{
	// adobe
	import flash.display.Sprite
	//
	// own
	//
	public class Grabber extends Sprite
	{
		// data
		public var numButtons:uint = 0;
		public var contentWidth:Number = 8;
		public var stack:Array;
		//
		//
		public function Grabber():void
		{
			stack = new Array();
		}
	}//end-class
}//end-pack