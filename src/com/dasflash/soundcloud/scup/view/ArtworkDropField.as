package com.dasflash.soundcloud.scup.view
{
	import com.dasflash.soundcloud.scup.events.ArtworkDropFieldEvent;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.InteractiveObject;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	
	[Event(type="com.dasflash.soundcloud.scup.events.ArtworkDropFieldEvent", name="dropFile")]
	[Event(type="com.dasflash.soundcloud.scup.events.ArtworkDropFieldEvent", name="removeFile")]
	
	
	public class ArtworkDropField extends SkinnableComponent
  	{
		[Bindable]
		public var artworkFileURL:String;
		
		
		public function ArtworkDropField()
		{
			addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, nativeDragEnterHandler);
			addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, nativeDragDropHandler);
		}
		
		protected function nativeDragEnterHandler(event:NativeDragEvent):void
		{
			if (event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT)) {
				
				//  check file extension
				var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
				
				for each (var file:File in files) {
					
					// limit to jpg, png, gif, tiff
					switch (file.extension.toLowerCase()) {
						case "jpg": break;
						case "jpeg": break;
						case "png": break;
						case "gif": break;
						case "tif": break;
						case "tiff": break;
						
						// if none of the file extensions is met, return
						default: return;
					}
				}
			}
			
			var iobject:* = InteractiveObject(this);
			NativeDragManager.acceptDragDrop(iobject);
		}
		
		protected function nativeDragDropHandler(event:NativeDragEvent):void
		{
			var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			
			var file:File = files[0] as File;
			
			artworkFileURL = file.url;
			
			dispatchEvent( new ArtworkDropFieldEvent(ArtworkDropFieldEvent.DROP_FILE, file) );
		}
		
	}
}