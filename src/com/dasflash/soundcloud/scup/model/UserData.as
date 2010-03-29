package com.dasflash.soundcloud.scup.model
{
	import flash.events.EventDispatcher;
	
	[Bindable]
	public class UserData extends EventDispatcher
	{
		
		public var userId:uint;

		public var userName:String;
		
		public var profileURL:String;
	}
}