package com.kiko.ui.buttons
{
	/**
	 * Version 1.04
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
		public var ico:Image;
		public var overlay:DisplayObject;
		public var background:DisplayObject;
		/**
		 * 
		 * @param	imgPath Pfad zum Icon (.swf, .jpg, .png ...)
		 * @param	onComplete Funktion wenn fertig geladen.
		 * @param	centerIcon Einmitten des Icons im overlay.
		 * @param	overlay Ein Objekt das über das Icon gelegt wird. Es wird automatisch unsichtbar gemacht und wird als Klickfläche gebraucht.
		 * @param	background Ein Objekt das hinter das Icon gelegt wird.
		 */
		public function IconButton(imgPath:String, onComplete:Function, centerIcon:Boolean = false, overlay:DisplayObject = null, background:DisplayObject = null  ):void {
			this.overlay = overlay;
			this.background = background;
			var bg:Rect;
			var me:IconButton = this;
			ico = new Image(imgPath, function() {
				if (overlay) {
					addChild(overlay);
					if (centerIcon) {
						ico.x = overlay.width / 2 - ico.width/2;
						ico.y = overlay.height / 2 - ico.height / 2;
					}
					overlay.alpha = 0.0;
				}
				else {
					bg = new Rect(ico.width, ico.height, 0x000000);
					addChild(bg);
					setChildIndex(bg, 0);
					bg.alpha = 0.1;
				}
				if (background) {
					addChild(background);
					me.setChildIndex(background, 0);
				}
				onComplete();
			}, false);
			addChild(ico);
		}
	}//end-class
}//end-pack