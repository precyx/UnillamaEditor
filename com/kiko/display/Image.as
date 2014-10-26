package com.kiko.display
{
	// adobe
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.events.Event;
	//
	//
	public class Image extends Sprite
	{
		//
		public var loader:Loader;
		private var info:LoaderInfo;
		private var onComplete:Function;
		private var centered:Boolean;
		//
		//
		/**
		 * @param	source Pfad zur Datei, die geladen werden soll, zB: (.swf, .jpg, .png, .mov)
		 * @param	onComplete Funktion die bei fertig geladener Datei aufgerufen wird.
		 * @param	centered Bestimmt ob das Bild eingemittet wird. Hilfreich zum mittig platzieren oder rotieren.
		 */
		public function Image(source:String, onComplete:Function, centered:Boolean = false):void
		{
			loader = new Loader();
			this.onComplete = onComplete;
			this.centered = centered;
			this.info = loader.contentLoaderInfo;
			//
			info.addEventListener( Event.COMPLETE, imgLoaded );
			loader.load( new URLRequest(source) );
			addChild(loader);
		}
		private function imgLoaded(e:Event):void  {
			//info.removeEventListener( Event.COMPLETE, imgLoaded );
			onComplete();
			if ( centered ) { 
				loader.x = -loader.width / 2;
				loader.y = -loader.height / 2;
			}
		}
		public function dispose():void {
			loader.unloadAndStop();
		}
	}//end-class
}//end-pack