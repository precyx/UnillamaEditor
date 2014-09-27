package com.pascal.ui.glowui
{
	/**
	 * ContentBox - Version 1.35 (~)
	 * 
	 * todos:
		 * SHIFT zum horizontal scrollen
		 * Smooth scroll mit easing
		 * Rechter unterer Ecken verschoenern.
	 * 
	 */
	// adobe
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	//
	// green
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	//
	//
	// own
	import com.pascal.display.Rect;
	//
	public class ContentBox extends Sprite
	{
		// data
		private var _minWidth:Number;
		private var _minHeight:Number;
		private var _isOpen:Boolean;
		//
		private var _backupResizer:BackupPropertyObject;
		private var _resizing:Boolean;
		private var _focus:Boolean;
		//
		protected var _content:DisplayObject;
		//
		private var _contentMode:String; 
		//
		// 
		/* public var numContentElements:uint;
		private var screenWidth:Number;
		private var screenHeight:Number; */
		//
		// graphics
		private var _deco_tab_header:Rect;
		private var background_rect:Rect;
		private var tab_header:Rect;
		protected var scroller_y:ScrollElement;
		protected var scroller_x:ScrollElement;
		private var scroll_content:ScrollContent;
		private var minimize_button:SimpleButton;
		private var close_button:SimpleButton;
		private var move_away_button:SimpleButton;
		protected var _tab_header_buttons:Array;
		private var resizer:Rect;
		//
		// objects
		private var moveAwayButtonProperties:MoveAwayButtonProperties;
		protected var settings:SettingsObject;
		//
		//
		public function ContentBox(content:DisplayObject):void {
			this._content = content;
			_content.addEventListener(ContentBoxEvent.CONTENT_SELECT, selectContentEvent);
			this.addEventListener(Event.ADDED_TO_STAGE, toStage); 
		}
		
		private function toStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, toStage);
			//
			minWidth = 50;
			minHeight = 50;
			_isOpen = true;
			moveAwayButtonProperties = new MoveAwayButtonProperties();
			settings = new SettingsObject();
			_contentMode = ContentMode.FIXED;
			_tab_header_buttons = new Array();
			//
			drawElements();
			
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
			this.addEventListener(Event.ENTER_FRAME, loop);
			this.addEventListener(MouseEvent.MOUSE_DOWN, thisMouseDown, true); //@note -> useCapture is true.
			
		}
		
		
		private function drawElements():void {
			//
			background_rect = new Rect(200, 200, 0x303030);
			addChild(background_rect);
			
			tab_header = new Rect( background_rect.width, settings.tabHeaderSize, settings.tabHeaderBgColor);
			addChild(tab_header);
			tab_header.filters = [ new DropShadowFilter(7, 90, 0x000000, 0.23, 6, 6,1,3) ];
			tab_header.addEventListener(MouseEvent.MOUSE_DOWN, clickMouseHeader);
			
			_deco_tab_header = new Rect( background_rect.width, settings.tabHeaderSize, settings.tabHeaderBgColor);
			addChild(_deco_tab_header);
			_deco_tab_header.mouseEnabled = false;
			
			scroller_y = new ScrollElement(stage, settings.scrollBarBgColor, settings.scrollBarColor);
			addChild(scroller_y);
			scroller_y.scrollMode = ScrollElement.VERTICAL_SCROLL;
			scroller_y.scrollBackgroundWidth = settings.scrollBarSize;
			scroller_y.scrollerWidth = settings.scrollBarSize;
			scroller_y.scrollBackgroundHeight = background_rect.height - tab_header.height - settings.scrollBarSize;
			scroller_y.y = tab_header.height;
			scroller_y.x = background_rect.x - scroller_y.scrollBackgroundWidth;
			//scroller_y.filters = [ new DropShadowFilter(7, -135, 0x000000, 0.63, 6, 6, 1, 3) ];
			
			scroller_x = new ScrollElement(stage,  settings.scrollBarBgColor, settings.scrollBarColor);
			addChild(scroller_x);
			scroller_x.scrollMode = ScrollElement.HORIZONTAL_SCROLL;
			scroller_x.scrollBackgroundHeight = settings.scrollBarSize;
			scroller_x.scrollerHeight = settings.scrollBarSize;
			scroller_x.scrollBackgroundWidth = background_rect.width - scroller_y.width;
			scroller_x.y = background_rect.height - scroller_x.height;
			scroller_x.x = 0;
			//scroller_x.filters = [ new DropShadowFilter(7, -135, 0x000000, 0.63, 6, 6, 1, 3) ];
			
			
			//scroll_content = new ScrollContent(new Rect(background_rect.width - scroller.width, background_rect.height - tab_header.height, 0xAAbb33), scroller);
			scroll_content = new ScrollContent( _content, new <ScrollElement>[scroller_y, scroller_x], 0x111111);
			addChild(scroll_content);
			scroll_content.y = settings.tabHeaderSize;
			
			var minimize_up:Rect = new Rect(5, 5, 0xffffff, 3, 3); 
			var minimize_over:Rect = new Rect(5, 5, 0xffffff, 3, 3);
			var minimize_hittest:Rect = new Rect(15, 20, 0xff00aa, -2.5, -5);
			minimize_up.filters = [new GlowFilter(0xffffff, 0.5, 4, 4, 1, 3), new GlowFilter(0xFF9900, 0.5, 5, 5, 2, 3)];
			minimize_over.filters = [new GlowFilter(0xffffff, 1, 4, 4, 1, 3), new GlowFilter(0xFF9900, 1, 5, 5, 2, 3)];
			minimize_button = new SimpleButton( minimize_up, minimize_over, minimize_over, minimize_hittest);
			addChild(minimize_button);
			minimize_button.x = 20;
			minimize_button.y = 5;
			minimize_button.addEventListener(MouseEvent.CLICK, clickMinimizeButton);
			
			
			var close_up:Rect = new Rect(5, 5, 0xffffff, 3, 3); 
			var close_over:Rect = new Rect(5, 5, 0xffffff, 3, 3);
			var close_hittest:Rect = new Rect(15, 20, 0xff00aa, -2.5, -5);
			close_up.filters = [new GlowFilter(0xffffff, 0.5, 4, 4, 1.5, 3), new GlowFilter(0xff0000, 0.5, 5, 5, 2, 3)];
			close_over.filters = [new GlowFilter(0xffffff, 1, 4, 4, 1.5, 3), new GlowFilter(0xff0000, 1, 5, 5, 2, 3)];
			close_button = new SimpleButton(close_up, close_over, close_over, close_hittest); 
			addChild(close_button);
			close_button.y = 5;
			close_button.x = 5;
			close_button.addEventListener(MouseEvent.CLICK, clickCloseButton);
			
			var move_away_up:Rect = new Rect(5, 5, 0xffffff, 3, 3); 
			var move_away_over:Rect = new Rect(5, 5, 0xffffff, 3, 3);
			var move_away_hittest:Rect = new Rect(15, 20, 0xff00aa, -2.5, -5);
			move_away_up.filters = [new GlowFilter(0xffffff, 0.5, 4, 4, 1.5, 3), new GlowFilter(0x00ff00, 0.5, 5, 5, 2, 3)];
			move_away_over.filters = [new GlowFilter(0xffffff, 1, 4, 4, 1.5, 3), new GlowFilter(0x00ff00, 1, 5, 5, 2, 3)];
			move_away_button = new SimpleButton(move_away_up, move_away_over, move_away_over, move_away_hittest); 
			addChild(move_away_button);
			move_away_button.y = 5;
			move_away_button.x = 35;
			move_away_button.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownMoveAwayButton, false, 0, true);
			move_away_button.addEventListener(MouseEvent.CLICK, clickDownMoveAwayButton, false, 0, true);
			 
			
			resizer = new Rect(5, 5, 0xffffff, -3, -3);
			resizer.filters = [new GlowFilter(0xffffff, 1, 4, 4, 1, 3), new GlowFilter(0x6699FF, 1, 5, 5, 1.8, 3)];
			addChild(resizer);
			resizer.visible = false;
			resizer.mouseEnabled = false;
			
			
			this.setChildIndex( tab_header, this.numChildren - 1);
			this.setChildIndex( scroller_y, this.numChildren - 1);
			this.setChildIndex( scroller_x, this.numChildren - 1);
			this.setChildIndex( _deco_tab_header, this.numChildren - 1);
			this.setChildIndex( close_button, this.numChildren - 1);
			this.setChildIndex( minimize_button, this.numChildren - 1);
			this.setChildIndex( move_away_button, this.numChildren - 1);
			this.setChildIndex( resizer, this.numChildren - 1);
			
			this.filters = [ new DropShadowFilter(5, 90, 0x000000, 0.77, 10, 10, 1,3) ];
			
			
			this.outerContentWidth = _content.width;
			this.outerContentHeight = _content.height + tab_header.height;
			
		}
		
		
		
		
		
		
		
		
		
		
		
		// events
		private function thisMouseDown(e:MouseEvent):void {
			parent.setChildIndex(this, parent.numChildren - 1); //trace("Set index box - ContentBox");
		}
		private function clickMouseHeader(e:MouseEvent):void {
			this.startDrag();
			move_away_button.x = 35;
			move_away_button.y = 5;
		}
		private function mouseUp(e:MouseEvent):void {
			this.stopDrag();
		}
		private function clickMinimizeButton(e:MouseEvent):void {
			if (_isOpen) this.minimize();
			else if (!_isOpen) this.maximaze();	
		}
		private function clickCloseButton(e:MouseEvent):void {
			this.dispose();
		}
		private function mouseDownMoveAwayButton(e:MouseEvent):void {
			fadeOutAllElements();
			moveAwayButtonProperties.isDragging = true;
			moveAwayButtonProperties.startPoint = new Point(mouseX, mouseY);
		}
		private function clickDownMoveAwayButton(e:MouseEvent):void {
			if (moveAwayButtonProperties.hiddenContentFlag) {
				fadeInAllElements();
				moveAwayButtonProperties.hiddenContentFlag = false;
			}
			else {
				moveAwayButtonProperties.hiddenContentFlag = true;
			}
			trace(moveAwayButtonProperties.hiddenContentFlag);
		}
		private function stageMouseUp(e:MouseEvent):void {
			moveAwayButtonProperties.isDragging = false;
			moveAwayButtonProperties.releasePoint = new Point(this.mouseX, this.mouseY);
			//trace(moveAwayButtonProperties.startPoint);
			//trace(moveAwayButtonProperties.releasePoint);
		}
		protected function loop(e:Event):void {
			
			//end - updateResizing
			//	(this.mouseX + " :mx", this.mouseY + " :my");
			var inner_padding:Number = 0;
			var outer_padding:Number = 10;
			var mx:Number = this.mouseX;
			var minx:Number = outerContentWidth - inner_padding;
			var maxx:Number = outerContentWidth + outer_padding;
			var my:Number = this.mouseY;
			var miny:Number = outerContentHeight - inner_padding;
			var maxy:Number = outerContentHeight + outer_padding;
			
			resizer.x = this.mouseX;
			resizer.y = this.mouseY;
			
			if (  isValBetween( mx, minx, maxx ) && isValBetween(my, 0, maxy) || isValBetween( my, miny, maxy ) && isValBetween(mx, 0, maxx)  ) {
				resizer.visible = true;
				stage.addEventListener(MouseEvent.MOUSE_DOWN, resizerMouseDown);
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp2);
			}
			else {
				if (stage.hasEventListener(MouseEvent.MOUSE_DOWN)) stage.removeEventListener(MouseEvent.MOUSE_DOWN, resizerMouseDown);
				
				if(!_resizing) resizer.visible = false;
			}
			if (_resizing) {
				this.outerContentWidth = this.mouseX - (_backupResizer.mouseX - _backupResizer.outerContentWidth);
				this.outerContentHeight = this.mouseY - (_backupResizer.mouseY - _backupResizer.outerContentHeight);
			}
			
			// scroller visibility
			if ( scroller_x.scrollerWidth == scroller_x.scrollBackgroundWidth ) scroller_x.visible = false;
			else if(_isOpen) scroller_x.visible = true;
			
			if ( scroller_y.scrollerHeight == scroller_y.scrollBackgroundHeight ) scroller_y.visible = false;
			else if(_isOpen) scroller_y.visible = true;
			
			//move away dragging
			if ( moveAwayButtonProperties.isDragging == true ) {
				move_away_button.x = mouseX - move_away_button.width/2;
				move_away_button.y = mouseY - move_away_button.height/2;
			}
			
		}
		
		
		
		
		private function resizerMouseDown(e:MouseEvent):void 
		{
			_backupResizer = new BackupPropertyObject(mouseX, mouseY, outerContentWidth, outerContentHeight);
			_resizing = true;
			//trace("activated - resizer...");
		}
		private function mouseUp2(e:MouseEvent):void {
			if(stage.hasEventListener(MouseEvent.MOUSE_DOWN)) stage.removeEventListener(MouseEvent.MOUSE_DOWN, resizerMouseDown);
			resizer.visible = false;
			_resizing = false;
			//
			//trace("deactivated - resizer...");
		}
		private function selectContentEvent(e:ContentBoxEvent):void {
			//parent.setChildIndex(this, parent.numChildren -1); 
			//trace("Event fired - select content. (from ContentBox)");
		}
		
		
		
		// publics
		public function show():void {
			
		}
		public function hide():void {
			
		}
		public function minimize():void {
			//this.removeEventListener(Event.ENTER_FRAME, loop);
			trace("minimaze");
			tab_header.filters = [];
			this.filters = [ new DropShadowFilter(5, 90, 0x000000, 0.77, 10, 10, 1,3) ];
			resizer.visible = false;
			_deco_tab_header.visible = false;
			background_rect.visible = false;
			scroller_x.visible = false;
			scroller_y.visible = false;
			scroll_content.visible = false;
			_isOpen = false;
		}
		public function maximaze():void {
			//this.addEventListener(Event.ENTER_FRAME, loop);
			trace("maximaze");
			tab_header.filters = [ new DropShadowFilter(7, 90, 0x000000, 0.23, 6, 6, 1, 3) ];
			this.filters = [ new DropShadowFilter(4, 90, 0x000000, 0.77, 10, 10, 1,3) ];
			resizer.visible = true;
			_deco_tab_header.visible = true;
			background_rect.visible = true;
			scroller_x.visible = true;
			scroller_y.visible = true;
			scroll_content.visible = true;
			_isOpen = true;
		}
		/**
		 * Richtet die ContentBox am alignContext aus.
		 * @param	alignContext Das Objekt, an dem die CB ausgerichtet wird. Meistens stage.
		 * @param	position zb: left, right, bottom, top, topLeft, topRight, bottomRight, bottomLeft
		 */
		public function alignTo(alignContext:DisplayObjectContainer, position:String) {
			var ow = alignContext.width;
			var oh = alignContext.height;
			if (alignContext is Stage) {
				ow = Stage(alignContext).stageWidth;
				oh = Stage(alignContext).stageHeight;
			}
			if (position == "right" || position == "bottomRight" || position == "topRight") this.x = ow - this.outerContentWidth;
			if (position == "left" || position == "topLeft" || position == "bottomLeft") this.x = 0;
			if (position == "bottom" || position == "bottomLeft" || position == "bottomRight") this.y = oh - this.outerContentHeight;
			if (position == "top" || position == "topLeft" || position == "topRight") this.y = 0;
		}
		public function dispose():void {
		//
		dispatchEvent( new ContentBoxEvent( ContentBoxEvent.CLOSE ) );
			
		this.removeEventListener(Event.ENTER_FRAME, loop);
		this.removeEventListener(MouseEvent.MOUSE_DOWN, thisMouseDown);
		
		minimize_button.removeEventListener(MouseEvent.CLICK, clickMinimizeButton);
		close_button.removeEventListener(MouseEvent.CLICK, clickCloseButton);
		move_away_button.removeEventListener(MouseEvent.CLICK, mouseDownMoveAwayButton);
		tab_header.removeEventListener(MouseEvent.MOUSE_DOWN, clickMouseHeader);
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, resizerMouseDown);
		stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp2);
			
		removeChild(minimize_button);
		removeChild(close_button);
		removeChild(move_away_button);
		removeChild(resizer);
		removeChild(_deco_tab_header);
		removeChild(background_rect);
		removeChild(tab_header);
		scroller_y.dispose();
		scroller_x.dispose();
		scroll_content.dispose();
		
		_deco_tab_header = null;
		background_rect = null;
		tab_header = null;
		scroller_y = null;
		scroller_x = null;
		scroll_content = null;
		minimize_button = null;
		move_away_button = null;
		close_button = null;
		resizer = null;
		_backupResizer = null;
		
		parent.removeChild(this);
		
		
		
		}
		
		
		
		// private helpers 
		private function isValBetween(val:Number, min:Number, max:Number):Boolean {
			if (val >= min && val <= max) return true;
			else return false;
		}
		
		// private actions
		private function fadeOutAllElements():void {
			for (var i:uint = 0; i < this.numChildren; i++) {
				var child:DisplayObject = this.getChildAt(i);
				TweenLite.to(child,  0.5, { alpha:0, ease:Circ.easeOut } );
				child.visible = false;
			}
			TweenLite.killTweensOf(move_away_button);
			move_away_button.alpha = 1;
			move_away_button.visible = true;
		}
		private function fadeInAllElements():void {
			for (var i:uint = 0; i < this.numChildren; i++) {
				var child:DisplayObject = this.getChildAt(i);
				TweenLite.to(child, 0.5, { alpha:1, ease:Circ.easeIn } );
				child.visible = true;
			}
		}
		protected function addTabheaderButton(clickAction:Function, glowColor:uint = 0xffffff ):void {
			var img_up:Rect = new Rect(5, 5, 0xffffff, 3, 3); 
			var img_over:Rect = new Rect(5, 5, 0xffffff, 3, 3);
			var img_hittest:Rect = new Rect(15, 20, 0xff00aa, -2.5, -5);
			img_up.filters = [new GlowFilter(0xffffff, 0.5, 4, 4, 1.5, 3), new GlowFilter(glowColor, 0.5, 5, 5, 2, 3)];
			img_over.filters = [new GlowFilter(0xffffff, 1, 4, 4, 1.5, 3), new GlowFilter(glowColor, 1, 5, 5, 2, 3)];
			var button:SimpleButton;
			button = new SimpleButton(img_up, img_over, img_over, img_hittest); 
			addChild(button);
			button.y = 5;
			button.x = 50;
			button.addEventListener(MouseEvent.CLICK, clickAction);
			_tab_header_buttons.push(button);
		}
		
		
		
		// getters/setters
		
		/**
		 * Breite der ganzen ContentBox.
		 */
		public function get outerContentWidth():Number {
			return background_rect.width;
		}
		public function set outerContentWidth(val:Number):void {
			val = Math.max(val, minWidth);
			background_rect.width = val;
			_deco_tab_header.width = val;
			tab_header.width = val;
			scroller_y.x = val - scroller_y.scrollBackgroundWidth;
			scroller_x.scrollBackgroundWidth = outerContentWidth - scroller_y.scrollBackgroundWidth;
			scroll_content.displayWidth = val;
		}
		
		/**
		 * Höhe der ganzen ContentBox.
		 */
		public function get outerContentHeight():Number {
			return background_rect.height;
		}
		public function set outerContentHeight(val:Number):void {
			val = Math.max(val, minHeight);
			background_rect.height = val;
			scroller_y.scrollBackgroundHeight = outerContentHeight - tabHeaderHeight - settings.scrollBarSize;
			scroller_x.y = outerContentHeight - scroller_x.scrollBackgroundHeight;
			scroll_content.displayHeight = val - tabHeaderHeight;
		}
		
		/**
		 * Höhe des tab_header.
		 */
		public function get tabHeaderHeight():Number {
			return tab_header.height;
		}
		
		
		/**
		 * Mindest-Breite der ganzen ContentBox.
		 */
		public function get minWidth():Number {
			return _minWidth;
		}
		public function set minWidth(val:Number):void {
			_minWidth = val;
		}
		
		/**
		 * Mindest-Höhe der ganzen ContentBox.
		 */
		public function get minHeight():Number {
			return _minHeight;
		}
		public function set minHeight(val:Number):void {
			_minHeight = val;
		}
		
		public function get focus():Boolean {
			return _focus;
		}
		public function set focus(val:Boolean):void{
			this._focus = val;
			scroller_x.isFocused = val;
			scroller_y.isFocused = val;
		}
		
		/*
		public function get innerContentWidth():Number {return 0;}
		public function get innerContentHeight():Number {return 0; }
		
		public function get minWidt():Number {return 0;}
		public function set minWidth():Number { }
		
		*/
	}//end-class
}//end - pack



class BackupPropertyObject {
	public var mouseX:Number;
	public var mouseY:Number;
	public var outerContentWidth:Number;
	public var outerContentHeight:Number;
	public function BackupPropertyObject(mouseX:Number, mouseY:Number, outerContentWidth:Number, outerContentHeight:Number):void {
		this.mouseX = mouseX;
		this.mouseY = mouseY;
		this.outerContentWidth = outerContentWidth;
		this.outerContentHeight = outerContentHeight;
	}
}
import flash.geom.Point;
class MoveAwayButtonProperties {
	public var startPoint:Point; 
	public var releasePoint:Point;
	public var isDragging:Boolean;
	public var hiddenContentFlag:Boolean;
}
class SettingsObject {
	// scroll bars
	public var scrollBarSize:uint = 12; //std:12
	public var scrollBarColor:uint = 0xc4c4c4; //std:0xc4c4c4
	public var scrollBarBgColor:uint = 0x303030; //std:0x303030
	//
	public var tabHeaderSize:uint = 20; //std:20
	public var tabHeaderBgColor:uint = 0x303030; //std:0x303030
}
class ContentMode {
	public static const STRECHED:String = "strechted";
	public static const FIXED:String = "fixed";
}



