package com.dasflash.soundcloud.scup.events
{
	import flash.events.Event;

	public class MainWindowEvent extends Event
	{
		public static const OPEN_MAIN_WINDOW:String = "openMainWindow";


		public function MainWindowEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new MainWindowEvent(type, bubbles, cancelable);
		}
	}
}