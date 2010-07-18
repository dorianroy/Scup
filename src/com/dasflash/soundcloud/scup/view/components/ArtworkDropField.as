/*

   Copyright 2010 (c) Dorian Roy - dorianroy.com

   This file is part of Scup.

   Scup is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Scup is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Scup. If not, see <http://www.gnu.org/licenses/>.

 */

package com.dasflash.soundcloud.scup.view.components
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
						case "jpg":
							break;
						case "jpeg":
							break;
						case "png":
							break;
						case "gif":
							break;
						case "tif":
							break;
						case "tiff":
							break;

						// if none of the file extensions is met, return
						default:
							return;
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

			dispatchEvent(new ArtworkDropFieldEvent(ArtworkDropFieldEvent.DROP_FILE, file));
		}

		public function removeFile():void
		{
			artworkFileURL = null;

			dispatchEvent(new ArtworkDropFieldEvent(ArtworkDropFieldEvent.REMOVE_FILE, null, true))
		}

	}
}