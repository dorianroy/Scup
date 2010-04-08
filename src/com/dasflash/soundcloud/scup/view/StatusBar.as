package com.dasflash.soundcloud.scup.view
{
	import com.dasflash.soundcloud.scup.events.SetDataEvent;

	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;

	import spark.components.supportClasses.SkinnableComponent;


	[Event(type="com.dasflash.soundcloud.scup.events.SetDataEvent", name="addFiles")]
	[Event(type="com.dasflash.soundcloud.scup.events.SetDataEvent", name="saveSet")]
	[Event(type="com.dasflash.soundcloud.scup.events.SetDataEvent", name="cancelSet")]


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
			var setDataEvent:SetDataEvent = new SetDataEvent(SetDataEvent.ADD_FILES);
			setDataEvent.files = event.files;
			dispatchEvent(setDataEvent);
		}

		public function saveSet():void
		{
			dispatchEvent(new SetDataEvent(SetDataEvent.SAVE_SET));
		}

		public function cancelSet():void
		{
			dispatchEvent(new SetDataEvent(SetDataEvent.CANCEL_SET));
		}

	}
}

