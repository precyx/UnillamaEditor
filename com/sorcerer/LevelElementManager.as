package com.sorcerer {
	/**
	 * LevelElementManager V1.05
	 * 
	 * @todo
	 * Multiselect auswahl, kopieren, löschen, bewegen [OK]
	 * Multiselect pixelgenau [OK]
	 * Multiselect alle seiten [OK]
	 * Multi drag & drop [OK] -> bugs
	 * tool box
	 * move stage tool
	 * collision rect und cirlce tool
	 * text menu
	 * ViewManager der z-index probleme löst.
	 * levelelement korrekter zindex bei import & export
	 * UI immer zu vorderst
	 * BoxManager, der actives der boxen regelt
	 * UI List zum auswählen von levelElements, anstatt jedesmal browse
	 * Zoom Regler, der eine Kleinansicht des ganzen Levels möglich macht.
	 * Elemente spiegeln.
	 * 
	 * 
	 * @bug 
	 * mehrmals aufs gleiche element klicken, füllt den activeArray immer mehr [OK]
	 * bei mehrerern einzelnen auswahlen werden die zusammengezählt, es sollte aber einzelauswahlen geben [OK]
	 * beim dragen kann man nicht dublizieren
	 * bei einer multiselection wird bei anschliessender singleselection diese zur multiselection zusammengefügt. [OK]
	 * beim gehaltenen dublizieren werden zu viele elemente geklont.
	 * 
	 * 
	 * 
	 * @features[DONE]
	 * Pixelgenaure Multiauswahl
	 * Elemente klonen
	 * Elemente löschen
	 * Elemente Z-Index
	 * Alle Element bewegen mit Space und MausDown
	 * Export in Array
	 * Import und Level-Generierung
	 * 
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
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
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
		public var activeArray:Array;
		//
		// flags
		private var keys:Object = { };
		private var mouseDown:Boolean;
		//
		// graphics
		private var selection:Selection;
		private var focus:DisplayObject; // Definiert, welcher Typ als letztes angeklick wurde. (Stage, LevelElement)
		//
		public function LevelElementManager(stage:Stage) {
			this.stage = stage;
			//
			graphicArray = new Array();
			collisionArray = new Array();
			activeArray = new Array();
			//
			keys = { };
			keys[Keyboard.SPACE] = false;
			//
			selection = new Selection(stage);
			selection.startClickPoint = new Point();
			//
			eventListeners();
		}
		//@todo listeners in controller auslagern
		private function eventListeners():void {
			stage.addEventListener(MouseEvent.MOUSE_UP, function mouseUp(e:MouseEvent) {
				//stage.removeEventListener(Event.ENTER_FRAME, loop);
				stage.removeEventListener(Event.ENTER_FRAME, elementDragLoop);
				// create elemselection
				createElementSelection();
				// clear preselection
				selection.clearPreSelection();
				focus = null;
				mouseDown = false;
			});
			stage.addEventListener(MouseEvent.MOUSE_DOWN, function mouseDown(e:MouseEvent) {
				focus = (e.target as DisplayObject);
				selection.startClickPoint = new Point(stage.mouseX, stage.mouseY);
				stage.addEventListener(Event.ENTER_FRAME, loop);
				mouseDown = true;
				// @feature all element drag
				// x, y von jedem element zwischenspeichern
				if( keys[Keyboard.SPACE]){
					for each( var elem:LevelElement in graphicArray) {
						elem.startDragElementPoint = new Point( elem.x, elem.y);
					}
				}
			});
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function keydown(e:KeyboardEvent) {
				var elem:LevelElement;
				keys[e.keyCode] = true;
				//duplicate
				if (e.keyCode == Keyboard.D) {
					if (activeArray.length) {
						for each( elem in activeArray ) {
							elem.active = false;
							elem.clone();
						}
					}
				}
				// rotate
				if (e.keyCode == Keyboard.O) {
					for each( elem in graphicArray ) {
						if(elem.active) elem.scaleX -= 0.02;
						if(elem.active) elem.scaleY -= 0.02;
					}
				}
				if (e.keyCode == Keyboard.P) {
					for each( elem in graphicArray ) {
						if(elem.active) elem.scaleX += 0.02;
						if(elem.active) elem.scaleY += 0.02;
					}
				}
				//delete
				if (e.keyCode == Keyboard.DELETE || e.keyCode == Keyboard.E) {
					for each( elem in activeArray ) {
						removeGraphicElement( elem );
					}
					activeArray = [];
					selection.clearElementSelection();
				}
				//zindex
				if (e.keyCode == Keyboard.B) {
					for each( elem in activeArray) {
						var index:uint = stage.getChildIndex(elem);
						if( index-1 > 0 ) stage.setChildIndex(elem, stage.getChildIndex(elem) - 1);
					}
				}
				if (e.keyCode == Keyboard.V) {
					for each( elem in activeArray) {
						var index2:uint = stage.getChildIndex(elem);
						if( index2+1 < stage.numChildren ) stage.setChildIndex(elem, stage.getChildIndex(elem) + 1);
					}
				}
				// move
				if(activeArray.length) {
					if (e.keyCode == Keyboard.LEFT) {
						for each( elem in activeArray ) {
							elem.x -= 10;
						}
					}
					if (e.keyCode == Keyboard.RIGHT) {
						for each( elem in activeArray ) {
							elem.x += 10;
						}
					}
					if (e.keyCode == Keyboard.UP) {
						for each( elem in activeArray ) {
							elem.y -= 10;
						}
					}
					if (e.keyCode == Keyboard.DOWN) {
						for each( elem in activeArray ) {
							elem.y += 10;
						}
					}
				}
				// space
				if (e.keyCode == Keyboard.SPACE ) {
					Mouse.cursor = MouseCursor.HAND;
					selection.clearElementSelection();				
				}
			});
			stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent) {
				keys[e.keyCode] = false;
				Mouse.cursor = MouseCursor.AUTO;
			});
		}
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//publics
		
		/**
		 * @param element Speichert ein LevelElement im Array.
		 */
		public function addGraphicElement(element:LevelElement):void {
			var me:LevelElementManager = this;
			var elem:LevelElement;
			element.addEventListener(MouseEvent.MOUSE_DOWN, function mouseDown(e:MouseEvent) {
				// different selection
				var sameSelection:Boolean;
				for each( elem in activeArray) {
					if (elem == element) sameSelection = true;
				}
				if (!sameSelection) {
					for each(elem in activeArray) {
						elem.active = false;
					}
					activeArray = [];
				}
				// no double selection
				if(!element.active && !keys[Keyboard.SPACE]){
					element.active = true;
					activeArray.push(element);
				}
				// init drag
				for each(elem in activeArray) {
					elem.startDragMousePoint = new Point( stage.mouseX, stage.mouseY);
					elem.startDragElementPoint = new Point( elem.x, elem.y);
				}
				stage.addEventListener(Event.ENTER_FRAME, elementDragLoop);
			});
			graphicArray.push(element);
		}
		
		/**
		 * @param elem Level entfernt ein LevelElement
		 */
		public function removeGraphicElement(elem:LevelElement):void {
			if ( elem == null ) return;
			graphicArray.splice( graphicArray.indexOf(elem), 1)
			elem.parent.removeChild(elem);
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
		private function createElementSelection():void {
			var selectionRect:Rectangle = selection.getPreSelection();
			var elem:LevelElement;
			// clear elementselection
			if ( focus is Stage ) {
				for each( elem in activeArray ) {
					elem.active = false;
				}
				selection.clearElementSelection();
				activeArray = [];
			}
			// create new selection
			for each ( elem in graphicArray ) {
				var elemBounds:Rectangle = elem.getRect(stage);
				var bitmapData:BitmapData = new BitmapData( elem.width, elem.height, true, 0 );
				bitmapData.draw(elem);
				if ( bitmapData.hitTest( new Point(elem.x, elem.y), 255, selectionRect, new Point(selectionRect.x, selectionRect.y), 255) ) {
					elem.active = true;
					activeArray.push(elem);
				}
				// faster bounding box collision detection
				//if ( elemBounds.intersects( selectionRect) ) elem.active = true;
			}
		}
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//events
		
		 
		/**
		 * @loop
		 * LevelElementManager Loop
		 */
		private function loop(e:Event):void {
			
			//@feature - draw preselection
			if (focus is Stage && !keys[Keyboard.SPACE]) {
				stage.setChildIndex( selection.preSelection, stage.numChildren - 1);
				selection.drawPreSelection( 
				Math.min(selection.startClickPoint.x, stage.mouseX), 
				Math.min(selection.startClickPoint.y, stage.mouseY),
				Math.abs(stage.mouseX - selection.startClickPoint.x),
				Math.abs(stage.mouseY - selection.startClickPoint.y) );
			}
			//@feature - draw element-selection
			if ( activeArray.length && !keys[Keyboard.SPACE]) {
				stage.setChildIndex( selection.elementSelection, stage.numChildren-1);
				var bounds:Rectangle = new Rectangle();
				for each ( var elem:LevelElement in activeArray ) {
					bounds = bounds.union( elem.getBounds(stage) );
				}
				selection.drawElementSelection(bounds.x, bounds.y, bounds.width, bounds.height);
			}
			
			//move elements
			if (keys[Keyboard.SPACE] && mouseDown) {
				for each ( var elem:LevelElement in graphicArray) {
					elem.x = stage.mouseX - (selection.startClickPoint.x - elem.startDragElementPoint.x);
					elem.y = stage.mouseY - (selection.startClickPoint.y - elem.startDragElementPoint.y);
				}
			}
		}
		/**
		 * @loop
		 */
		private function elementDragLoop(e:Event):void {
			for each( var elem:LevelElement in activeArray) {
				elem.x = stage.mouseX - (elem.startDragMousePoint.x - elem.startDragElementPoint.x);
				elem.y = stage.mouseY - (elem.startDragMousePoint.y - elem.startDragElementPoint.y);
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
