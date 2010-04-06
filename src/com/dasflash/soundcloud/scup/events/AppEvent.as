package com.dasflash.soundcloud.scup.events
{
	import flash.events.Event;

	public class AppEvent extends Event
	{
		/**
		 * Initializes the view and model data and starts
		 * the OAuth authentication sequence.
		 */
		public static const INIT_APP:String = "initApp";

		/**
		 * This event will clear the local user credentials
		 * and then initialize the app.
		 */
		public static const RESET_APP:String = "resetApp";

		/**
		 * Checks for an updated version of the app.
		 */
		public static const CHECK_FOR_UPDATE:String = "checkForUpdate";



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

