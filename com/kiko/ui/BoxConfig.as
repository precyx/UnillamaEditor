package com.kiko.ui
{
	/**
	 * BoxConfig - Version 1.02
	 */
	public class BoxConfig extends Object
	{
		// graphical
		public var backgroundColor:uint = 0xffffff; //0xffffff
		public var grabberColor:uint = 0xffffff; // 0xffffff
		public var lineColor:uint = 0xdedede; // 0xdedede
		public var titleColor:uint = 0x555555; // 0x555555
		public var dropShadow:Boolean = true; // true
		public var title:Boolean = true; // true
		public var titleFont:String = "Arial"; // Arial
		public var elementGap:Number = 8; // 8
		//
		// sizes
		public var startWidth:Number = 200; // 200
		public var startHeight:Number = 300; // 300
		public var minWidth:Number = 120; // 120
		public var minHeight:Number = 60; // 60
		public var grabberHeight:Number = 35; // 35
		//
		// usability
		public var scrollAmount:Number = 2.5; // 2.5
		public var circleMode:Boolean = true; // true
		public var minimizeMode:Boolean = false; // false
		public var resizeMode:Boolean = true; // true
		public var contentMode:String = BoxConfig.CONTENT_FIX;
		//
		// consts
		public static const CONTENT_FIX:String = "content_fix";
		public static const CONTENT_FILL:String = "content_fill";
		public static const CONTENT_SINGLE:String = "content_single";
		//
		//
		//
		public function BoxConfig(props:Object = null):void
		{
			if (props) {
				for (var property:String in props){
					if (this.hasOwnProperty(property)) this[property] = props[property];
				}
			}
		}
	}//end-class
}//end-pack