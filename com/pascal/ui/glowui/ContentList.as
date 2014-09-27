package com.pascal.ui.glowui
{
	/**
	 * ContentList - Version 1.01
	 */
	// adobe
	import flash.display.DisplayObject;
	import flash.display.Sprite
	import flash.events.Event;
	//
	// own
	import com.pascal.ui.glowui.Content;
	//
	public class ContentList extends Content
	{
		// data
		private var _contentArray:Array;
		//
		// properties
		private var _gapY:Number;
		//
		//
		public function ContentList(gapY:Number = 10 ):void{
			this._gapY = gapY;
			_contentArray = new Array();
		}
		public function appendContent(content:DisplayObject):void {
			if(_contentArray.length > 0) content.y = this.height + _gapY;
			this.addChild(content);
			_contentArray.push(content);
			
		}
		
	}//end-class
}//end-pack