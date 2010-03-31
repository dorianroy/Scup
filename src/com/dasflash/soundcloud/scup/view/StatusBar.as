package com.dasflash.soundcloud.scup.view
{
	import com.dasflash.soundcloud.scup.events.AddFilesEvent;
	import com.dasflash.soundcloud.scup.events.SetEvent;
	
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import spark.components.supportClasses.SkinnableComponent;

	
	[Event(type="com.dasflash.soundcloud.scup.events.AddFilesEvent",name="addFiles")]
	[Event(type="com.dasflash.soundcloud.scup.events.SetEvent",name="saveSet")]
	[Event(type="com.dasflash.soundcloud.scup.events.SetEvent",name="cancelSet")]
	

	[Bindable]
	public class StatusBar extends SkinnableComponent
	{
		[Inject(source="setData.allUploadsCompleted")]
		public var allUploadsCompleted:Boolean;


		public function browseFiles():void
		{
			var file:File = new File();

			file.addEventListener(FileListEvent.SELECT_MULTIPLE, fileSelectHandler);

			// limit to .ogg, .mp3, .mp4 .flac, .aac, .wav(e) .aif(f) 
			var soundFilesFilter:FileFilter = new FileFilter("Sound files", "*.ogg;*.mp3;*.mp4;*.flac;*.aac;*.wav;*.wave;*.aif;*.aiff");

			file.browseForOpenMultiple("Select Tracks", [soundFilesFilter]);
		}

		protected function fileSelectHandler(event:FileListEvent):void
		{
			dispatchEvent(new AddFilesEvent(AddFilesEvent.ADD_FILES, event.files));
		}

		public function saveSet():void
		{
			dispatchEvent(new SetEvent(SetEvent.SAVE_SET));
		}

		public function cancelSet():void
		{
			dispatchEvent(new SetEvent(SetEvent.CANCEL_SET));
		}

	}
}

