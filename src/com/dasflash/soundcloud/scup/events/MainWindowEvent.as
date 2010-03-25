package com.dasflash.soundcloud.scup.events
{
	import flash.events.Event;
	
	public class MainWindowEvent extends Event
	{
		public static const ADD_FILES:String = "addFiles";
		
		public var files:Array;
		
		
		public function MainWindowEvent(type:String, files:Array=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.files = files;
		}
		
		override public function clone():Event
		{
			return new MainWindowEvent(type, files, bubbles, cancelable);
		}
	}
}