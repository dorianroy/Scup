package com.dasflash.soundcloud.scup.events
{
	import flash.events.Event;


	public class SpinnerEvent extends Event
	{

		public static const SHOW_SPINNER:String = "showSpinner";

		public static const HIDE_SPINNER:String = "hideSpinner";


		public function SpinnerEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new SpinnerEvent(type, bubbles, cancelable);
		}
	}
}