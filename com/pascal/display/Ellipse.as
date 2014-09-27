package com.pascal.display
{
	//
	import flash.display.Shape;
	// 
	//
	public class Ellipse extends Shape
	{
		//
		//
		public function Ellipse(width:Number, height:Number, color:uint, regX:Number = 0, regY:Number = 0):void
		{
			this.graphics.beginFill(color);
			this.graphics.drawEllipse(regX, regX, width, height);
			this.graphics.endFill();
		}
	}//end-class
}//end-pack