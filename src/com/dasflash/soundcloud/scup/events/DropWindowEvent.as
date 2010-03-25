package com.dasflash.soundcloud.scup.events
{
	import flash.events.Event;
	
	
	public class DropWindowEvent extends Event
	{
		
		public static const DROP_FILE:String = "dropFile";
		
		public static const OPEN_MAIN_WINDOW:String = "openMainWindow";
		
		public static const OPEN_AUTH_PAGE:String = "openAuthPage";
		
		public static const RESET_APP:String = "resetApp";
		
		public static const SWITCH_USER:String = "switchUser";
		
		public var droppedFiles:Array;
		
		
		public function DropWindowEvent(type:String, droppedFiles:Array=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.droppedFiles = droppedFiles;
		}
		
		override public function clone():Event
		{
			return new DropWindowEvent(type, droppedFiles, bubbles, cancelable);
		}
	}
}
