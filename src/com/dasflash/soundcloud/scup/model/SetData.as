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

package com.dasflash.soundcloud.scup.model
{
	import flash.events.EventDispatcher;
	import flash.filesystem.File;

	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;

	[Bindable]
	public class SetData extends EventDispatcher
	{
		// SC internal id that is assigned after creating this set on the server
		public var setId:int;

		// fields that are going to be saved only for the set
		public var title:String;

		public var description:String;
		public var ean:String;

		// playlist_type
		public var playlistTypes:ArrayCollection = new ArrayCollection(
			[
			{label: "None", data: ""},
			{label: "Album", data: "album"},
			{label: "Compilation", data: "compilation"},
			{label: "Demo", data: "demo"},
			{label: "EP", data: "ep"},
			{label: "Playlist", data: "playlist"},
			{label: "Sample Collection", data: "sample collection"},
			{label: "Showcase", data: "showcase"},
			{label: "Single", data: "single"}
			]
			);

		public var selectedPlaylistTypeIndex:int;

		public function get playlist_type():String
		{
			try {
				return playlistTypes.getItemAt(selectedPlaylistTypeIndex).data;
			} catch (error:Error) {
			}

			return null;
		}

		public function set playlist_type(value:String):void
		{
			for (var i:int = 0; i < playlistTypes.length; i++) {
				if (playlistTypes.getItemAt(i).data == value) {
					selectedPlaylistTypeIndex = i;
					return;
				}
			}
			throw(new Error("unknown set type selected"));
		}

		public var selectedTrackTypeIndex:int = -1;

		public function get track_type():String
		{
			try {
				return TrackData.TRACK_TYPES.getItemAt(selectedTrackTypeIndex).data;
			} catch (error:Error) {
			}

			return null;
		}

		public function set track_type(value:String):void
		{
			for (var i:int = 0; i < TrackData.TRACK_TYPES.length; i++) {
				if (TrackData.TRACK_TYPES.getItemAt(i).data == value) {
					selectedTrackTypeIndex = i;
					return;
				}
			}
			throw(new Error("unknown track type selected"));
		}

		// get ordered list of track ids
		public function get tracks():Array
		{
			// TODO make sure the order is correct
			var trackIds:Array = new Array();
			for each (var track:TrackData in trackCollection) {
				if (track.id)
					trackIds.push(track.id);
			}
			return trackIds;
		}

		// fields that will be applied to the set and all tracks
		public var artwork_data:File;
		public var genre:String; // max 40 chars.
		public var label_name:String;
		public var purchase_url:String;
		public var release:String
		public var release_day:int;
		public var release_month:int;
		public var release_year:int;
		public var streamable:Boolean;
		public var tag_list:String; //a space separated list of tags
		public var shared_to:String;

		// license 	
		public static const LICENSE_TYPES:ArrayCollection = new ArrayCollection(
			[
			{label: "All rights reserved", data: "all-rights-reserved"},
			{label: "The work is in the public domain", data: "no-rights-reserved"},
			{label: "CC Attribution", data: "cc-by"},
			{label: "CC Attribution Noncommercial", data: "cc-by-nc"},
			{label: "CC Attribution No Derivative Works", data: "cc-by-nd"},
			{label: "CC Attribution Share Alike", data: "cc-by-sa"},
			{label: "CC Attribution Noncommercial Non Derivate Works", data: "cc-by-nc-nd"},
			{label: "CC Attribution Noncommercial Share Alike", data: "cc-by-nc-sa"}
			]
			);
		public var selectedLicenseIndex:int;

		public function get license():String
		{
			return LICENSE_TYPES.getItemAt(selectedLicenseIndex).data;
		}

		public function set license(value:String):void
		{
			for (var i:int = 0; i < LICENSE_TYPES.length; i++) {
				if (LICENSE_TYPES.getItemAt(i).data == value) {
					selectedLicenseIndex = i;
					return;
				}
			}
			throw(new Error("unknown license type selected"));
		}

		// fields that apply only to tracks
		public var downloadable:Boolean;
		// sharing
		public var sharingTypes:ArrayCollection = new ArrayCollection(
			[
			{label: "Private", data: "private"},
			{label: "Public", data: "public"}
			]
			);

		public var selectedSharingIndex:int;

		public function get sharing():String
		{
			return sharingTypes.getItemAt(selectedSharingIndex).data;
		}

		public function set sharing(value:String):void
		{
			for (var i:int = 0; i < sharingTypes.length; i++) {
				if (sharingTypes.getItemAt(i).data == value) {
					selectedSharingIndex = i;
					return;
				}
			}
			throw(new Error("unknown sharing type selected"));
		}


		// scup internal fields
		public var trackCollection:ArrayCollection = new ArrayCollection();
		public var isUploading:Boolean;
		public var allUploadsCompleted:Boolean;
		public var permalink:String;


		// init all values
		public function resetData():void
		{
			trackCollection.removeAll();

			trackCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);

			title = "";
			description = "";
			// artwork_data = null; // don't reset artwork to be able to reuse it
			ean = "";
			downloadable = false;
			genre = "";
			label_name = "";
			purchase_url = "";
			release = "";
			var releaseDate:Date = new Date();
			release_day = releaseDate.date;
			release_month = releaseDate.month + 1;
			release_year = releaseDate.fullYear;
			selectedSharingIndex = 0;
			selectedLicenseIndex = 0;
			selectedPlaylistTypeIndex = -1;
			selectedTrackTypeIndex = -1;
			tag_list = "";
			streamable = true;
			shared_to = "";
			// shared_to = ""; // don't reset invites to quickly post another set to the same folks

			isUploading = false;
			allUploadsCompleted = false;
			permalink = "";
		}

		// keep the index property of the track data elements in sync with the collection order
		protected function collectionChangeHandler(event:CollectionEvent):void
		{
			for each (var trackData:TrackData in trackCollection) {
				trackData.index = trackCollection.getItemIndex(trackData);
			}
		}

	}
}
