package com.kiko.display
{
	//
	import flash.display.Sprite;
	// 
	//
	public class Circle extends Sprite
	{
		//
		//
		public function Circle(radius:Number, color:uint, regX:Number = 0, regY:Number = 0):void
		{
			this.graphics.beginFill(color);
			this.graphics.drawCircle(regX, regY, radius);
			this.graphics.endFill();
		}
	}//end-class
}//end-pack