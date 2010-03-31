package com.dasflash.soundcloud.scup.events
{
	import flash.events.Event;

	
	public class ThrobberEvent extends Event
	{
		
		public static const SHOW_THROBBER:String = "showThrobber";

		public static const HIDE_THROBBER:String = "hideThrobber";


		public function ThrobberEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new ThrobberEvent(type, bubbles, cancelable);
		}
	}
}