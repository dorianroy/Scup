package com.dasflash.soundcloud.scup.events
{
	import flash.events.Event;


	public class AuthWindowEvent extends Event
	{

		public static const STATE_AUTH:String = "stateAuth";

		public static const STATE_AUTH_FAIL:String = "stateAuthFail";

		public static const STATE_USER_INVALID:String = "stateUserInvalid";

		public static const STATE_NO_CONNECTION:String = "stateNoConnection";

		public static const STATE_BUSY:String = "stateBusy";

		public static const HIDE_AUTH_WINDOW:String = "hideAuthWindow";

		public static const GOTO_AUTH_PAGE:String = "gotoAuthPage";



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
