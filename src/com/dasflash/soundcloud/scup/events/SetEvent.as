package com.dasflash.soundcloud.scup.events
{
	import flash.events.Event;

	
	public class SetEvent extends Event
	{
		
		public static const SAVE_SET:String = "saveSet";

		public static const CANCEL_SET:String = "cancelSet";


		public function SetEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new SetEvent(type, bubbles, cancelable);
		}
	}
}