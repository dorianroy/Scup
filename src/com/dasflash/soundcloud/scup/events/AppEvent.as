package com.dasflash.soundcloud.scup.events
{
	import flash.events.Event;

	public class AppEvent extends Event
	{
		public static const INIT_APP:String = "initApp";

		public static const RESET_APP:String = "resetApp";

		public static const CHECK_FOR_UPDATE:String = "checkForUpdate";

		public static const SWITCH_USER:String = "switchUser";


		public function AppEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new AppEvent(type, bubbles, cancelable);
		}

	}
}

