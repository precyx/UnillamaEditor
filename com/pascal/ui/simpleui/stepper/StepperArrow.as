package com.pascal.ui.simpleui.stepper
{
	// adobe
	import flash.display.Sprite
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	//
	// own
	import com.pascal.display.Rect;
	import com.pascal.display.Triangle;
	//
	public class StepperArrow extends Sprite
	{
		// graphics
		private var bg:Rect;
		private var tria:Triangle;
		//
		// data
		private var _width:Number;
		private var _height:Number;
		private var _color:Number;
		//
		public function StepperArrow(width:Number, height:Number, color:uint):void {
			this._width = width;
			this._height = height;
			this._color = color;
			createElements();
		}
		private function createElements():void {
			bg = new Rect(_width, _height, _color);
			addChild(bg);
			//
			tria = new Triangle( new Point(0, _height/2.5), new Point(_width/5, 0), new Point(_width/2.5, _height/2.5), 0xFFFFFF);
			addChild(tria);
			tria.x = bg.width / 2 - tria.width / 2;
			tria.y = bg.height / 2 - tria.height / 2;
		}
		public function overState():void {
			var c:ColorTransform = new ColorTransform(1.2, 1.2, 1.2);
			bg.transform.colorTransform = c;
		}
		public function outState():void {
			var c:ColorTransform = new ColorTransform(1.0, 1.0, 1.0);
			bg.transform.colorTransform = c;
		}
	}//end-class
}//end-pack