package com.dasflash.soundcloud.scup.events
{
	import flash.events.Event;

	public class SetDataEvent extends Event
	{

		public static const COPY_TO_TRACKS:String = "copyToTracks";

		public static const TRACKLIST_CHANGED:String = "tracklistChanged";

		public static const ADD_FILES:String = "addFiles";

		public static const SAVE_SET:String = "saveSet";

		public static const CANCEL_SET:String = "cancelSet";


		public var files:Array;


		public function SetDataEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);

			this.files = files;
		}

		override public function clone():Event
		{
			return new SetDataEvent(type, bubbles, cancelable);
		}
	}
}