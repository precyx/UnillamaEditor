package com.pascal.ui.glowui
{
	// adobe
	import flash.events.Event;
	//
	// own
	//
	public class ContentBoxEvent extends Event
	{
		// data
		public static const CLOSE:String = "close";
		public static const CONTENT_SELECT:String = "content_select";
		//
		//
		public function ContentBoxEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type);
		}
	}//end-class
}//end-pack