package com.dasflash.soundcloud.scup.events
{
	import flash.events.Event;
	
	public class ScupEvent extends Event
	{
		public static const INIT_APP:String = "initApp";
		
		public static const SWITCH_USER:String = "switchUser";
		
		public static const SAVE_SET:String = "saveSet";
		
		public static const CANCEL_SET:String = "cancelSet";
		
		public static const BROWSE_FILES:String = "browseFiles";
		
		public static const SHOW_THROBBER:String = "showThrobber";
		
		public static const HIDE_THROBBER:String = "hideThrobber";
		
		public static const CHECK_FOR_UPDATE:String = "checkForUpdate";
		
		
		
		public function ScupEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new ScupEvent(type, bubbles, cancelable);
		}
	}
}