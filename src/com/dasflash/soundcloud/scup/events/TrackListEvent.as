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
	import com.dasflash.soundcloud.scup.model.TrackData;

	import flash.events.Event;


	public class TrackListEvent extends Event
	{

		public static const RETRY_TRACK:String = "retryTrack";

		public static const DELETE_TRACK:String = "deleteTrack";


		public var trackData:TrackData;


		public function TrackListEvent(type:String, trackData:TrackData, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);

			this.trackData = trackData;

		}

		override public function clone():Event
		{
			return new TrackListEvent(type, trackData, bubbles, cancelable);
		}
	}
}