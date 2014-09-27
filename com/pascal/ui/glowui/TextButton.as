package com.pascal.ui.glowui
{
	/**
	 * Version 1.1
	 */
	// adobe
	import flash.display.Sprite
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	//
	// own
	import com.pascal.display.Rect;
	import com.pascal.text.TFieldSingle;
	//
	public class TextButton extends Sprite
	{
		//graphics
		private var bg:Rect;
		//
		//
		public function TextButton(bw:Number, bh:Number, text:String, bgColor:uint = 0x333333  ):void
		{
			bg = new Rect(bw, bh, bgColor);
			addChild(bg);
			
			
			var format:TextFormat = new TextFormat("Arial", 12, 0xffffff);
			//format.align = "center";
	
			var tx:TFieldSingle = new TFieldSingle(false);
			
			addChild(tx);
			//tx.tField.background = true;
			tx.tField.backgroundColor = 0x0000aa;
			tx.text = text;
			tx.setTextFormat(format);
			
			tx.tField.width = bg.width;
			tx.tField.autoSize = TextFieldAutoSize.CENTER;
			tx.y = bg.height / 2 - tx.tField.height / 2;
			tx.tField.mouseEnabled = false;
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		}
		
		// events
		private function mouseOver(e:MouseEvent):void {
			bg.alpha = 0.65;
		}
		private function mouseOut(e:MouseEvent):void {
			bg.alpha = 1;
		}
		
		
	}//end-class
}//end-pack