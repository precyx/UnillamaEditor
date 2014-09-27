package com.pascal.ui.glowui
{
	/**
	 * Content - Version 0.01
	 */
	// adobe
	import flash.display.Sprite;
	import flash.events.Event;
	//
	// own
	//
	//
	public class Content extends Sprite
	{
		// data
		//
		// graphics
		//
		// elements
		//
		// flags
		//
		//
		/**
		 * 
		 */
		public function Content():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, toStage);
		}
		
		// events
		protected function toStage(e:Event):void {
			
		}
		
		// publics
		public function addContent():void {
			
		}
		
		
		//override public function get width () : Number{};
		//override public function set width(val:uint) {}
			
		
	}//end-class
}//end-pack