package com.sorcerer {
	/**
	 * LevelElementManager V1.04
	 * 
	 * @todo
	 * Multiselect auswahl, kopieren, löschen, bewegen [OK]
	 * Multiselect pixelgenau [OK]
	 * Multiselect alle seiten [OK]
	 * Multi drag & drop
	 * move stage tool
	 * tool box
	 * text menu
	 * zindex elements
	 * levelelement korrekter zindex bei import & export
	 * eigene multidrag klasse/funktionalität
	 * UI immer zu vorderst
	 * BoxManager, der actives der boxen regelt
	 */
	//
	import com.kiko.display.Rect;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.LineScaleMode;
	import flash.display.CapsStyle;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.display.Stage;
	import com.sorcerer.LevelElement;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	//
	public class LevelElementManager {
		// data
		private var stage:Stage;
		//
		public var graphicArray:Array;
		public var collisionArray:Array;
		//
		// graphics
		private var selection:Selection;
		private var focus:DisplayObject;
		//
		public function LevelElementManager(stage:Stage) {
			this.stage = stage;
			//
			graphicArray = new Array();
			collisionArray = new Array();
			//
			selection = new Selection(stage);
			//
			eventListeners();
		}
		private function eventListeners():void {
			stage.addEventListener(MouseEvent.MOUSE_UP, function mouseUp(e:MouseEvent) {
				//stage.removeEventListener(Event.ENTER_FRAME, loop);
				
				if(e.target is Stage){
					for each( var elem1:LevelElement in graphicArray ) {
					elem1.active = false;
					}
					selection.clearElementSelection();
				}
				//
				checkSelection();
				focus = null;
				selection.clearPreSelection();
			});
			stage.addEventListener(MouseEvent.MOUSE_DOWN, function mouseDown(e:MouseEvent) {
				focus = (e.target as DisplayObject);
				if (e.target is Stage) {
					selection.startClickPoint = new Point(stage.mouseX, stage.mouseY);
				}
				stage.addEventListener(Event.ENTER_FRAME, loop);
			});
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function keydown(e:KeyboardEvent) {
				var activeGraphicElements:Array = getActiveGraphicElements();
				if (e.keyCode == Keyboard.D) {
					if (activeGraphicElements.length) {
						for each( var elem:LevelElement in activeGraphicElements ) {
							elem.active = false;
							elem.clone();
						}
					}
				}
				if (e.keyCode == Keyboard.DELETE || e.keyCode == Keyboard.E) {
					for each( var elem3:LevelElement in activeGraphicElements ) {
						removeGraphicElement( elem3 );
					}
					selection.clearElementSelection();
				}
				if(getActiveGraphicElements().length) {
					if (e.keyCode == Keyboard.LEFT) {
						for each( var elem4:LevelElement in activeGraphicElements ) {
							elem4.x -= 10;
						}
					}
					if (e.keyCode == Keyboard.RIGHT) {
						for each( var elem5:LevelElement in activeGraphicElements ) {
							elem5.x += 10;
						}
					}
					if (e.keyCode == Keyboard.UP) {
						for each( var elem6:LevelElement in activeGraphicElements ) {
							elem6.y -= 10;
						}
					}
					if (e.keyCode == Keyboard.DOWN) {
						for each( var elem7:LevelElement in activeGraphicElements ) {
							elem7.y += 10;
						}
					}
				}
			});
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//publics
		
		/**
		 * @param element Speichert ein LevelElement im Array.
		 */
		public function addGraphicElement(element:LevelElement):void {
			var me:LevelElementManager = this;
			element.addEventListener(MouseEvent.MOUSE_DOWN, function mouseDown(e:MouseEvent) {
				//@todo multidrag
				element.startDrag();
				for each( var elem:LevelElement in graphicArray ) {
					elem.active = false;
				}
				element.active = true;
				stage.addEventListener(Event.ENTER_FRAME, loop);
			});
			graphicArray.push(element);
		}
		
		/**
		 * @return Gibt ein Array mit LevelElementn zurück, welche aktiv ist.
		 */
		public function getActiveGraphicElements():Array {
			var out:Array = [];
			for each( var elem:LevelElement in graphicArray ) {
				if (elem.active) out.push(elem);
			}
			return out;
		}
		/**
		 * @param elem Level entfernt ein LevelElement
		 */
		public function removeGraphicElement(elem:LevelElement):void {
			if ( elem == null ) return;
			for (var i:uint = 0; i < graphicArray.length; i++) {
				if (graphicArray[i] == elem) {
					graphicArray.splice(i, 1);
					elem.parent.removeChild(elem);
					break;
				}
			}
		}
		/**
		 * @return Gibt einen Daten LevelElement String zurück
		 */
		public function generateLevelData():String {
			var data:String = "";
			for ( var i:uint = 0; i < graphicArray.length; i++) {
				var elem:LevelElement = graphicArray[i] as LevelElement;
				data +=  elem.path + "," + elem.x + "," + elem.y + "," + stage.getChildIndex(elem);
				if ( i < graphicArray.length -1 ) data += "|";
			}
			data += "";
			return data;
		}
		/**
		 * Schaut welche Elemente von der PreSelection betroffen sind und setzt diese active.
		 */
		private function checkSelection():void {
			var selectionRect:Rectangle = selection.getPreSelection();
			for each ( var elem:LevelElement in graphicArray ) {
				var elemBounds:Rectangle = elem.getRect(stage);
				var bitmapData:BitmapData = new BitmapData( elem.width, elem.height, true, 0 );
				bitmapData.draw(elem);
				if ( bitmapData.hitTest( new Point(elem.x, elem.y), 255, selectionRect, new Point(selectionRect.x, selectionRect.y), 255) ) {
					elem.active = true;
				}
				// faster bounding box collision detection
				//if ( elemBounds.intersects( selectionRect) ) elem.active = true;
			}
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//events
		
		 
		/**
		 * LevelElementManager Loop
		 */
		private function loop(e:Event):void {
			
			//draw preselection
			if (focus is Stage) {
				stage.setChildIndex( selection.preSelection, stage.numChildren - 1);
				selection.drawPreSelection( 
				Math.min(selection.startClickPoint.x, stage.mouseX), 
				Math.min(selection.startClickPoint.y, stage.mouseY),
				Math.abs(stage.mouseX - selection.startClickPoint.x),
				Math.abs(stage.mouseY - selection.startClickPoint.y) );
			}
			//draw element-selection
			if ( getActiveGraphicElements().length) {
				stage.setChildIndex( selection.elementSelection, stage.numChildren-1);
				var bounds:Rectangle = new Rectangle();
				for each ( var elem:LevelElement in getActiveGraphicElements() ) {
					bounds = bounds.union( elem.getBounds(stage) );
				}
				selection.drawElementSelection(bounds.x, bounds.y, bounds.width, bounds.height);
			}
			
		}
		  
		
		/**
		* Speichert ein kollisions Element im Array.
		*/
		public function addCollisionElement(element:Sprite):void {
			collisionArray.push(element);
		}

	}
	
}
