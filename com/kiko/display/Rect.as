package com.kiko.display
{
	//
	import flash.display.Shape;
	import flash.display.Sprite;
	// 
	//
	public class Rect extends Sprite
	{
		//
		//
		public function Rect(width:Number, height:Number, color:uint, regX:Number = 0, regY:Number = 0):void
		{
			this.graphics.beginFill(color);
			this.graphics.drawRect(regX, regY, width, height);
			this.graphics.endFill();
		}
	}//end-class
}//end-pack