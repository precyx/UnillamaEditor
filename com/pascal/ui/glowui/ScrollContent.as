package com.pascal.ui.glowui
{
	/**
	 * ScrollContent - Version 1.14 (~)
	 */
	// adobe
	import flash.display.DisplayObject;
	import flash.display.Sprite
	import flash.events.Event;
	//
	// own
	import com.pascal.display.Rect;
	//
	public class ScrollContent extends Sprite
	{
		//
		private var displayBackground:Rect;
		private var displayRect:Rect;
		private var contentRect:Sprite;
		private var visualElement:DisplayObject;
		//
		private var scrollElementReferences:Vector.<ScrollElement>;
		//
		//
		public function ScrollContent(visualElement:DisplayObject, scrollElementReferences:Vector.<ScrollElement> = null, bgColor:uint = 0x00FFFF):void
		{
			this.visualElement = visualElement;
			this.scrollElementReferences = scrollElementReferences;
			
			
			displayBackground =  new Rect(300, 300, bgColor);
			addChild(displayBackground);
			
			displayRect = new Rect(300, 300, bgColor);
			addChild(displayRect);
			
			contentRect = new Sprite();
			addChild(contentRect);
			contentRect.addChild(visualElement);
			contentRect.mask = displayRect;
			
			
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(e:Event):void 
		{
			var array:Vector.<ScrollElement> = this.scrollElementReferences;
			
			if (array != null) {
				//trace(array.length);
				for ( var i:uint = 0; i < array.length; i++) {
					var scroller:ScrollElement = array[i];
					
					//
					if (scroller.scrollMode == ScrollElement.BOTH_SCROLL ||
						scroller.scrollMode == ScrollElement.VERTICAL_SCROLL) {
						this.contentY = scroller.positionY * (this.displayHeight - this.contentHeight);
						scroller.scrollerHeight = scroller.scrollBackgroundHeight * ( this.displayHeight / this.contentHeight );
					}
					if (scroller.scrollMode == ScrollElement.BOTH_SCROLL ||
						scroller.scrollMode == ScrollElement.HORIZONTAL_SCROLL) {
						this.contentX = scroller.positionX * (this.displayWidth - this.contentWidth);
						scroller.scrollerWidth = scroller.scrollBackgroundWidth * ( this.displayWidth / this.contentWidth );
					}
				}
				
			}
		}
		
		
		
		// publics
		public function connectScrollElement(scrollElementReferences:Vector.<ScrollElement>):void {
			this.scrollElementReferences = scrollElementReferences;
		}
		public function disconnectScrollElement():void {
			this.scrollElementReferences = null;
		}
		public function dispose():void {
			this.removeEventListener(Event.ENTER_FRAME, loop);
			removeChild(displayBackground);
			removeChild(displayRect);
			removeChild(contentRect);
			displayBackground = null;
			contentRect = null;
			visualElement = null;
			scrollElementReferences = null;
			this.parent.removeChild(this);
		}
		
		
		// getters / setters
		
		/**
		 * Die Höhe des Sichtbaren Scrollbereichs.
		 */
		public function set displayHeight(val:Number):void {
			displayRect.height = val;
			displayBackground.height = val;
		}
		public function get displayHeight():Number { 
			return displayRect.height;
		}
		
		/**
		 * Die Breite des Sichtbaren Scrollbereichs.
		 */
		public function set displayWidth(val:Number):void {
			displayRect.width = val;
			displayBackground.width = val;
		}
		public function get displayWidth():Number { 
			return displayRect.width;
		}
		
		/**
		 * Die X-Koordinate des contentRect.
		 */
		public function set contentX(val:Number):void {
			contentRect.x = val;
		}
		public function get contentX():Number { 
			return contentRect.x;
		}
		
		/**
		 * Die Y-Koordinate des contentRect.
		 */
		public function set contentY(val:Number):void {
			contentRect.y = val;
		}
		public function get contentY():Number {
			return contentRect.y;
		}
		
		/**
		 * Breite des contentRect.
		 */
		public function get contentWidth():Number {
			return contentRect.width;
		}
		/**
		 * Höhe des contentRect.
		 */
		public function get contentHeight():Number {
			return contentRect.height;
		}
		
		/**
		 * Das Anzeigeobjekt das im contentRect ist.
		 */
		public function set newVisualElement( element:DisplayObject ):void {
			if( visualElement && contentRect.contains(visualElement)){
			contentRect.removeChild( visualElement );
			}
			visualElement = element;
			contentRect.addChild(visualElement);
		}
		
		
	}//end-class
}//end-pack