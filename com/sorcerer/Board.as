package com.sorcerer
{
	//
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import com.pascal.display.Rect;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	// 
	//
	public class Board extends Sprite
	{
		//graphics
		private var objLayer:Sprite;
		private var bg:Rect;
		private var m:Sprite;
		private var deleter:Rect;
		//
		// data
		private var _focus:Boolean;
		//
		// references
		private var manager:BoardManager;
		//
		public function Board(manager:BoardManager):void
		{
			this.manager = manager;
			drawGraphics();
		}
		
		private function drawGraphics(){
			bg = new Rect(700, 550, 0xffffff);
			addChild(bg);
			bg.filters = [new DropShadowFilter(0, 0, 0, 0.5, 30, 30, 1, 3)];
			
			
			objLayer = new Sprite();
			addChild(objLayer);
			
			/*
			var drager:Rect = new Rect(30,30, 0x222222);
			addChild(drager);
			drager.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownDrager);
			drager.addEventListener(MouseEvent.MOUSE_UP, mouseUpDrager);
			*/
			
			deleter = new Rect(20, 20, 0xB4B4B4);
			deleter.buttonMode = true;
			addChild(deleter);
			deleter.x = bg.width - deleter.width;
			deleter.addEventListener(MouseEvent.CLICK, clickDeleter);
			
			m = new Sprite();
			m.graphics.beginFill(0xbb99aa);
			m.graphics.drawRect(0,0, 50,50);
			m.width = bg.width;
			m.height = bg.height;
			addChild(m);
			
			objLayer.mask = m;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownBoard);
			bg.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownBG);
			
			this.addEventListener(Event.ADDED_TO_STAGE, toStage);
		}
		
		private function toStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, toStage);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpStage);
		}
		
		private function mouseDownBoard(e:MouseEvent):void {
			manager.focusSingle(this);
		}
		private function mouseDownBG(e:MouseEvent):void {
			this.startDrag();
		}
		private function mouseUpStage(e:MouseEvent):void {
			this.stopDrag();
		}
		private function clickDeleter(e:MouseEvent) {
			manager.remove(this);
		}
		/*
		private function mouseDownDrager(e:MouseEvent){
			this.startDrag();
		}
		private function mouseUpDrager(e:MouseEvent){
			this.stopDrag();
		}
		*/
		
		
		//publics / getters/setters
		public function setChild(element:Sprite){
			objLayer.addChild(element);
			element.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent){
				Sprite(e.currentTarget).startDrag();
			});
			element.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent){
				Sprite(e.currentTarget).stopDrag();
			});
		}
		
		public function set focus(value:Boolean):void {
			this._focus = value;
			if (value) {
				bg.filters = [new DropShadowFilter(0, 0, 0x000000, 0.5, 50, 50, 1, 3)];
				//parent.setChildIndex(this, parent.numChildren - 1);
			}
			else {
				bg.filters = [new DropShadowFilter(0, 0, 0x000000, 0.5, 15, 15, 0.7, 3)];
			}
		}
		public function get focus():Boolean {
			return _focus;
		}
		
		override public function set width(value:Number):void{
			bg.width = value;
			m.width = value;
			deleter.x = bg.width - deleter.width;
		}
		override public function get width():Number{
			return bg.width;
		}
		override public function set height(value:Number):void{
			bg.height = value;
			m.height = value;
		}
		override public function get height():Number{
			return bg.height;
		}
	}//end-class
}//end-pack