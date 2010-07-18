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

package com.dasflash.soundcloud.scup.controller
{
	import com.dasflash.soundcloud.scup.events.SetDataEvent;
	import com.dasflash.soundcloud.scup.events.TrackListEvent;
	import com.dasflash.soundcloud.scup.model.SetData;
	import com.dasflash.soundcloud.scup.model.TrackData;
	
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	
	import mx.collections.IList;
	
	import org.swizframework.core.IDispatcherAware;
	
	
	[Event(name="tracklistChanged",type="com.dasflash.soundcloud.scup.events.SetDataEvent")]
	
	
	public class SetDataController implements IDispatcherAware
	{
		
		private var _dispatcher:IEventDispatcher;
		 
		/**
		 * IDispatcherAware implementation. Will be automatically set from Swiz.
		 * Use this dispatcher instance to dispatch events Swiz should handle.
		 *
		 * @param dispatcher Swiz dispatcher.
		 */
		public function set dispatcher(dispatcher:IEventDispatcher):void
		{
			_dispatcher = dispatcher;
		}
		
		/**
		 * SetData bean
		 */
		[Inject]
		public var setData:SetData;
		
		
		// COPY SET FIELDS TO TRACKS
		
		[Mediate(event="copyToTracks")]
		/**
		 * Copies mutual data fields from set to each track
		 *  
		 * @param event
		 */
		public function copyToTracksHandler(event:SetDataEvent):void
		{
			for each (var track:TrackData in setData.trackCollection) {
				track.genre = setData.genre;
				track.label_name = setData.label_name;
				track.purchase_url = setData.purchase_url;
				track.release = setData.release;
				track.release_day = setData.release_day;
				track.release_month = setData.release_month;
				track.release_year = setData.release_year;
				track.tag_list = setData.tag_list;
				track.license = setData.license;
				track.track_type = setData.track_type;
			}
		}
		
		
		// ADD TRACKS
		
		[Mediate(event="addFiles")]
		public function addFilesHandler(event:SetDataEvent):void
		{
			addTracks(event.files);
		}
		
		protected function addTracks(files:Array):void
		{
			// cycle through array of selected files
			for (var i:int=0; i<files.length; ++i) {
				
				// get file reference
				var file:File = files[i] as File;
				
				// create new track data
				var track:TrackData = new TrackData();
				track.asset_data = file;
				track.title = file.name;
				
				// add track to collection
				setData.trackCollection.addItem(track);
			}
			
			// trigger process queue
			_dispatcher.dispatchEvent(new SetDataEvent(SetDataEvent.TRACKLIST_CHANGED));
		}
		
		
		// DELETE TRACKS
		
		[Mediate(event="deleteTrack")]
		public function removeTrackFromList(event:TrackListEvent):void
		{
			var track:TrackData = event.trackData;
			
			//delete track from setdata
			var tracks:IList = setData.trackCollection;
			tracks.removeItemAt(tracks.getItemIndex(track));
			
			// trigger process queue
			_dispatcher.dispatchEvent(new SetDataEvent(SetDataEvent.TRACKLIST_CHANGED));
		}
		
	}
}