package com.kiko.ui
{
	// adobe
	import flash.display.Sprite
	import flash.events.Event;
	//
	// own
	import com.kiko.display.*;
	import com.kiko.text.*;
	//
	public class TextMenu extends Sprite
	{
		//
		//
		//
		public function TextMenu():void {
			addEventListener(Event.ADDED_TO_STAGE, toStage);
		}
		
		private function toStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, toStage);
			create();
		}
		
		private function create():void {
		}
	}//end-class
}//end-pack
