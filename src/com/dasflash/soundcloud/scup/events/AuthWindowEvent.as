package com.dasflash.soundcloud.scup.events
{
	import flash.events.Event;


	public class AuthWindowEvent extends Event
	{

		public static const OPEN_AUTH_PAGE:String = "openAuthPage";

		public static const OPEN_AUTH_FAIL_PAGE:String = "openAuthFailPage";

		public static const OPEN_USER_INVALID_PAGE:String = "openUserInvalidPage";

		public static const OPEN_NO_CONNECTION_PAGE:String = "openNoConnectionPage";

		public static const HIDE_AUTH_WINDOW:String = "hideAuthWindow";



		public function AuthWindowEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new AuthWindowEvent(type, bubbles, cancelable);
		}
	}
}
