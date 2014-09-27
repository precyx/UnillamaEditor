package com.kiko.display
{
	//
	import flash.display.Shape;
	import flash.geom.Point;
	// 
	//
	public class Triangle extends Shape
	{
		//
		//
		public function Triangle(p1:Point, p2:Point, p3:Point, color:uint):void
		{
			var v:Vector.<Number> = Vector.<Number>([p1.x, p1.y, p2.x, p2.y, p3.x, p3.y]);
			this.graphics.beginFill(color);
			this.graphics.drawTriangles(v);
			this.graphics.endFill();
		}
	}//end-class
}//end-pack