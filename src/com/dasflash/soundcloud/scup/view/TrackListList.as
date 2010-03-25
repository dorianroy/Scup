package com.dasflash.soundcloud.scup.view
{
	import com.dasflash.soundcloud.scup.events.MainWindowEvent;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.InteractiveObject;
	import flash.events.KeyboardEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	
	import spark.components.List;
	
	/**
	 * This class provides a hotfix for a bug in Flex 4 SDK
	 * that prevents blanks to show up in input fields inside
	 * a list
	 * @see https://bugs.adobe.com/jira/browse/SDK-22598
	 * 
	 * @author Dorian
	 */
	public class TrackListList extends List
	{
		public function TrackListList()
		{
			super();
		}
		
		// override default handler 
		override protected function keyDownHandler(event:KeyboardEvent) : void
		{
			// only call super handler if key is not SPACE
			if (event.keyCode != 32) {
				super.keyDownHandler(event);
			}
		}
		
	}
}