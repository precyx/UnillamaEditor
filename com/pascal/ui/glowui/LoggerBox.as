package com.pascal.ui.glowui
{
	/**
	 * LoggerBox - Version 1.02
	 */
	// adobe
	import flash.display.Sprite
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	//
	// own
	import com.pascal.ui.glowui.ContentBox;
	import com.pascal.ui.glowui.TextContent;
	//
	public class LoggerBox extends ContentBox
	{
		//
		//
		//
		public function LoggerBox(textContent:TextContent):void
		{
			super(textContent);
			this.addEventListener(Event.ADDED_TO_STAGE, toStage); 
			
		}
		private function toStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, toStage);
			super.addTabheaderButton(clearText, 0xffffff );
		}
		
		// loop
		override protected function loop(e:Event):void {
			super.loop(e);
			
			
			_content.width = TextContent(_content)._tf.textWidth +20; // +20 buffer
			_content.height = TextContent(_content)._tf.textHeight +20; // +20 buffer
			
			if (this.outerContentWidth > this._content.width) {
				_content.width = this.outerContentWidth;
			}
			if (this.outerContentHeight > this._content.height) {
				_content.height = this.outerContentHeight;
			}
		}
		
		// privates
		private function clearText(e:MouseEvent):void {
			TextContent(_content)._tf.text = "";
		}
		
		// publics
		/**
		 * Gibt den eingegebenen Text auf einer neuen Zeile aus. (logt den Text).
		 */
		public function log(text:String):void {
			
			TextContent(_content).appendText(text, ScrollElement(scroller_y));
			
		}
		
	}//end-class
}//end-pack