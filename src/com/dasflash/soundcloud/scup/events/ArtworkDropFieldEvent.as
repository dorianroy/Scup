package com.dasflash.soundcloud.scup.events
{
	import flash.events.Event;
	import flash.filesystem.File;

	public class ArtworkDropFieldEvent extends Event
	{
		public static const DROP_FILE:String = "dropFile";

		public static const REMOVE_FILE:String = "removeFile";

		public var file:File;


		public function ArtworkDropFieldEvent(type:String, droppedFile:File=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);

			this.file = droppedFile;
		}

		override public function clone():Event
		{
			return new ArtworkDropFieldEvent(type, file, bubbles, cancelable);
		}
	}
}

