package com.kiko.ui.buttons
{
	/**
	 * Version 1.02
	 */
	// adobe
	import com.kiko.display.Image;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	//
	// own
	import com.kiko.display.Rect;
	//
	public class IconButton extends Sprite
	{
		// data
		public var toggleOn:Boolean;
		//
		// graphics
		private var ico:Image;
		//
		//
		public function IconButton(imgPath:String, onComplete:Function, hitTest:DisplayObject = null, centerHitTest:Boolean = false ):void
		{
			var bg:Rect;
			
			ico = new Image(imgPath, function() {
				if (hitTest) {
					addChild(hitTest);
					if (centerHitTest) {
						ico.x = hitTest.width / 2 - ico.width/2;
						ico.y = hitTest.height / 2 - ico.height / 2;
						hitTest.alpha = 0.0;
					}
				}
				else {
					bg = new Rect(ico.width, ico.height, 0x000000);
					addChild(bg);
					setChildIndex(bg, 0);
					bg.alpha = 0.2;
				}
				onComplete();
				
			}, false);
			addChild(ico);
		}
	}//end-class
}//end-pack