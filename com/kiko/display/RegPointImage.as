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
	public class RegPointImage extends Sprite 
	{
		//
		private var loader:Loader;
		//
		//
		public function RegPointImage():void {
			loader = new Loader();
			addChild(loader);
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, imgLoaded );
			loader.load( new URLRequest("pic.png") );
		}
		private function imgLoaded(e:Event):void  {
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, imgLoaded );
			loader.x = -loader.width / 2;
			loader.y = -loader.width / 2;
		}
	}//end-class
}//end-pack