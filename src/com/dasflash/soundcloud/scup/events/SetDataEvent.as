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