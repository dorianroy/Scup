package com.dasflash.soundcloud.scup.model
{
	import flash.events.EventDispatcher;
	
	[Bindable]
	
	/**
	 * Stores data of the logged on SoundCloud user.
	 * 
	 * @author Dorian Roy
	 */
	public class UserData extends EventDispatcher
	{
		
		/**
		 * The SoundCloud Id of the logged on user
		 */
		public var userId:uint;

		/**
		 * The SoundCloud username of the logged on user
		 */
		public var userName:String;
		
		/**
		 * Permalink URL of the SoundCloud home page of the logged on user
		 */
		public var profileURL:String;
	}
}