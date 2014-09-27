package com.pascal.ui.glowui
{
	/**
	 * ContentBoxManager - Version 1.01
	 */
	// adobe
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.engine.ContentElement;
	//
	// own
	//
	public class ContentBoxManager
	{
		// data
		private var contentBoxes:Vector.<ContentBox>;
		//
		//
		public function ContentBoxManager( contentBoxes:Vector.<ContentBox> = null ):void
		{
			if (contentBoxes == null) contentBoxes = new <ContentBox>[];
			this.contentBoxes = contentBoxes;
			for ( var i:uint = 0; i < contentBoxes.length; i++) {
				var box:ContentBox = contentBoxes[i];
				box.addEventListener(ContentBoxEvent.CLOSE, closeBox);
				box.addEventListener(MouseEvent.MOUSE_DOWN, clickBox);
			}
		}
		
		
		// events
		private function clickBox(e:MouseEvent):void {
			setFocusAll(false);
			var clickedBox:ContentBox = ContentBox(e.currentTarget);
			clickedBox.focus = true;	
		}
		private function closeBox(e:ContentBoxEvent):void {
			var closedBox:ContentBox = ContentBox(e.target);
			closedBox.removeEventListener(MouseEvent.MOUSE_DOWN, clickBox);
			// remove box from array
			for (var i:uint = 0; i < contentBoxes.length; i++) {
				var curBox:ContentBox = contentBoxes[i];
				if ( curBox == closedBox ) {
					contentBoxes.splice(i, 1);
					break;
				}
			}
			closedBox = null;
		}

		//helpers
		/**
		 * Setzt bei allen Boxen den Fokus, das heisst sie sind ausgewählt und man kann mit dem Mausrad scrollen.
		 * @param	val - Fokus setzten oder nicht. (true, false)
		 */
		private function setFocusAll(val:Boolean):void {
			for ( var i:uint = 0; i < contentBoxes.length; i++) {
				var box:ContentBox = contentBoxes[i];
				box.focus = val;
			}
		}
		
		
		//publics
		/**
		 * Fügt eine neue ContentBox in den Manager( ContentBox-Array ).
		 * @param	contentBox
		 */
		public function add(contentBox:ContentBox):void {
			contentBox.addEventListener(ContentBoxEvent.CLOSE, closeBox);
			contentBox.addEventListener(MouseEvent.MOUSE_DOWN, clickBox);
			contentBoxes.push(contentBox);
		}
		
		/**
		 * Entfernt eine ContentBox aus dem Manager( ContentBox-Array ).
		 * @param	contentBox
		 */
		public function release(contentBox:ContentBox):void {
			for ( var i:uint = 0; i < contentBoxes.length; i++) {
				var cb:ContentBox = contentBoxes[i];
				if ( cb == contentBox) {
					contentBoxes.splice(i, 1);
					break;
				}
			}
		}
		/** Anzahl Boxen im Manager. */
		public function getCount():uint {
			return contentBoxes.length;
		}
		
	}//end-class
}//end-pack