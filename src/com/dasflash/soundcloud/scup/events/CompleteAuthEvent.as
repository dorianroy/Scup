package com.dasflash.soundcloud.scup.events
{
	import flash.events.Event;
	
	public class CompleteAuthEvent extends Event
	{
		
		public static const COMPLETE_AUTH:String = "completeAuth";
		
		public var verificationCode:String;
		
		
		public function CompleteAuthEvent(type:String, verificationCode:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.verificationCode = verificationCode;
		}
		
		override public function clone():Event
		{
			return new CompleteAuthEvent(type, verificationCode, bubbles, cancelable);
		}
	}
}