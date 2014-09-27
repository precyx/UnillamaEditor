package com.kiko.ui
{
	/**
	 * ScrollElement - Version 1.47 (~)
	 * 
	 * todos
	 * 	scrollbar mit mausrad
	 * 	mindest hoehe/breite einbauen.
	 * 
	 * infos
	 * 	Variablen: .x, .y, .width, .height sind auf Genauigkeit von zwei Stellen begrenzt, zB. 8.74.
	 * 
	 */
	
	// adobe
	import flash.display.Sprite
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	//
	// own
	//
	public class ScrollElement extends Sprite
	{
		// graphics
		public var scrollBackground:Sprite;
		public var scroller:Sprite;
		//
		// data
		private var _scrollMode:String;
		public var isFocused:Boolean;
		//
		// statics
		public static const VERTICAL_SCROLL:String = "vertical_scroll";
		public static const HORIZONTAL_SCROLL:String = "horizontal_scroll";
		public static const BOTH_SCROLL:String = "both_scroll";
		//
		//
		public function ScrollElement(stageReference:Stage, bgColor:uint = 0x0000ff, scrollerColor:uint = 0xaaff00):void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, toStage);
			
			_scrollMode = ScrollElement.BOTH_SCROLL;
			
			function toStage(e:Event):void 
			{
			removeEventListener(Event.ADDED_TO_STAGE, toStage);
			scrollBackground = new Sprite();
			scrollBackground.graphics.beginFill(bgColor);
			scrollBackground.graphics.drawRect(0, 0, 1, 1);
			addChild(scrollBackground);
			
			scrollBackground.width = 500;
			scrollBackground.height = 200;
			
			scroller = new Sprite();
			scroller.graphics.beginFill(scrollerColor);
			scroller.graphics.drawRect(0, 0, 1, 1);
			addChild(scroller);
			
			
			scroller.x = 100;
			scroller.width = 100;
			scroller.height = 100;
			
			scroller.addEventListener(MouseEvent.MOUSE_DOWN, scrollerMouseDown);
			scroller.addEventListener(MouseEvent.MOUSE_OVER, scrollerMouseOver);
			scroller.addEventListener(MouseEvent.MOUSE_OUT, scrollerMouseOut);
			stage.addEventListener(MouseEvent.MOUSE_UP, scrollerMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			}
		}
		
		
		//events
		private function scrollerMouseUp(e:MouseEvent):void {
			scroller.stopDrag();
			//scroller.alpha = 1;
		}
		private function scrollerMouseDown(e:MouseEvent):void {
			scroller.startDrag(false, new Rectangle(0, 0, scrollBackgroundWidth - scrollerWidth, scrollBackgroundHeight - scrollerHeight) );
			//scroller.alpha = 0.7;
		}
		private function mouseWheel(e:MouseEvent):void {
			if( isFocused ) this.scrollerY -= e.delta * 5;
		}
		private function scrollerMouseOut(e:MouseEvent):void {
			//scroller.alpha = 1;
		}
		private function scrollerMouseOver(e:MouseEvent):void {
			//scroller.alpha = 0.7;
		}
		
		//publics
		public function scrollerXToMax():void {
			scroller.x = this.scrollBackgroundWidth - this.scrollerWidth;
		}
		public function scrollerXToMin():void {
			scroller.x = 0
		}
		public function scrollerYToMax():void {
			scroller.y = scrollBackgroundHeight - scrollerHeight;
		}
		public function scrollerYToMin():void {
			scroller.y = 0
		}
		public function dispose():void {
			scroller.removeEventListener(MouseEvent.MOUSE_DOWN, scrollerMouseDown);
			scroller.removeEventListener(MouseEvent.MOUSE_OVER, scrollerMouseOver);
			scroller.removeEventListener(MouseEvent.MOUSE_OUT, scrollerMouseOut);
			stage.removeEventListener(MouseEvent.MOUSE_UP, scrollerMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			
			removeChild(scrollBackground);
			removeChild(scroller);
			scrollBackground = null;
			scroller = null;
			
			this.parent.removeChild(this);
		}
		
		
		
		
		// getters setters
		/**
		 * Die Breite des scrollBackground.
		 */
		public function set scrollBackgroundWidth(val:Number):void {
			var xratio = scrollerX / (scrollBackground.width - scroller.width);
			var wratio = scroller.width / scrollBackground.width;
			
			// min width
			if ( val <= 5) val = 5;
			
			// set bg width
			scrollBackground.width = val;
			
			//set scroller width and x
			scrollerWidth = scrollBackground.width * wratio;
			scrollerX = (scrollBackground.width - scroller.width) * xratio;
			
		}
		public function get scrollBackgroundWidth():Number {
			return this.scrollBackground.width;
		}
		
		/**
		 * Die Höhe des scrollBackground.
		 */
		public function set scrollBackgroundHeight(val:Number):void {
			var yratio = scrollerY / (scrollBackground.height - scroller.height);
			var hratio = scroller.height / scrollBackground.height;
			
			// min height
			if ( val <= 5) val = 5;
			
			// set bg height
			scrollBackground.height = val;
			
			//set scroller height and y
			scrollerHeight = scrollBackground.height * hratio;
			scrollerY = (scrollBackground.height - scroller.height) * yratio;
		}
		public function get scrollBackgroundHeight():Number {
			return scrollBackground.height;
		}
		
		
		/**
		 * Die Breite des scroller.
		 */
		public function set scrollerWidth(val:Number):void {
			if (val > scrollBackgroundWidth) val = scrollBackgroundWidth;
			this.scroller.width = val;
			scrollerX = this.scroller.x;
		}
		public function get scrollerWidth():Number {
			return this.scroller.width;
		}
		
		/**
		 * Die Höhe des scroller.
		 */
		public function set scrollerHeight(val:Number):void {
			if (val > scrollBackgroundHeight) val = scrollBackgroundHeight;
			scroller.height = val;
			scrollerY = scroller.y;
		}
		public function get scrollerHeight():Number {
			return scroller.height;
		}
		
		/**
		 * Die X-Koordiate des scroller.
		 */
		public function set scrollerX(val:Number):void {
			scroller.x = val;
			if (val < 0) scrollerXToMin();
			if (val > scrollBackgroundWidth - scrollerWidth) scrollerXToMax();
		}
		public function get scrollerX():Number {
			return scroller.x;
		}
		
		/**
		 * Die Y-Koordiate des scroller.
		 */
		public function set scrollerY(val:Number):void {
			scroller.y = val;
			if (val < 0) scrollerYToMin();
			if (val > scrollBackgroundHeight - scrollerHeight) scrollerYToMax();
		}
		public function get scrollerY():Number {
			return scroller.y;
		}
		
		
		/**
		 * Das Verhältnis auf der X-Achse vom scroller zum scrollBackground von 0 - 1.
		 */
		public function get positionX():Number {
			return scrollerX / (scrollBackgroundWidth - scrollerWidth);
		}
		
		
		/**
		 * Das Verhältnis auf der Y-Achse vom scroller zum scrollBackground von 0 - 1.
		 */
		public function get positionY():Number {
			return scrollerY / (scrollBackgroundHeight - scrollerHeight);
		}
		
		/**
		 * Den Scroll-Modus, also X-Achse, Y-Achse oder beide scrollen.
		 */
		public function set scrollMode(val:String):void {
			_scrollMode = val;
		}
		public function get scrollMode():String {
			return _scrollMode;
		}
		
		
		
	}//end-class
}//end - pack






