package com.kiko.display
{
	// adobe
	import flash.display.DisplayObject;
	import flash.display.Sprite
	import flash.events.Event;
	//
	// own
	import com.kiko.display.*;
	import com.kiko.text.*;
	//
	public class MultiImage extends Sprite
	{
		//
		private var stack:Array;
		//
		//
		public function MultiImage():void {
			addEventListener(Event.ADDED_TO_STAGE, toStage);
		}
		
		private function toStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, toStage);
			stack = new Array();
		}
		
		private function create():void {
		}
		
		public function loadImage(img:DisplayObject):void {
			
		}
	}//end-class
}//end-pack
