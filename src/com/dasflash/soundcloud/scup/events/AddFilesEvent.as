package com.dasflash.soundcloud.scup.events
{
	import flash.events.Event;
	
	public class AddFilesEvent extends Event
	{
		
		public static const ADD_FILES:String = "addFiles";
		
		public var files:Array;
		

		public function AddFilesEvent(type:String, files:Array, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.files = files;
		}
		
		override public function clone():Event
		{
			return new AddFilesEvent(type, files, bubbles, cancelable);
		}
	}
}