package com.kiko.display
{
	//
	import flash.display.Shape;
	// 
	//
	public class RoundRect extends Shape
	{
		//
		//
		public function RoundRect(width:Number, height:Number, round:Number, color:uint, regX:Number = 0, regY:Number = 0):void
		{
			this.graphics.beginFill(color);
			this.graphics.drawRoundRect(regX, regY, width, height, round, round);
			this.graphics.endFill();
		}
	}//end-class
}//end-pack