package com.dasflash.soundcloud.scup.model
{
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class TrackData extends EventDispatcher
	{
		// track types
		public var trackTypes:ArrayCollection = new ArrayCollection(
			[
			{label: "None", data: ""},
			{label: "Loop", data: "loop"},
			{label: "Part", data: "part"},
			{label: "Podcast", data: "podcast"},
			{label: "Demo", data: "demo"},
			{label: "DJ Set", data: "djset"},
			{label: "Sample", data: "sample"},
			{label: "Cover", data: "cover"},
			{label: "Mashup", data: "mashup"},
			{label: "Re-edit", data: "reedit"},
			{label: "Remix", data: "remix"},
			{label: "Work in progress", data: "in progress"},
			{label: "Live", data: "live"},
			{label: "Original", data: "original"}
			]
			);

		public var selectedTrackTypeIndex:int = -1;

		public function get track_type():String
		{
			try {
				return trackTypes.getItemAt(selectedTrackTypeIndex).data;
			} catch (error:Error) {
			}

			return null;
		}

		public function set track_type(value:String):void
		{
			for (var i:int = 0; i < trackTypes.length; i++) {
				if (trackTypes.getItemAt(i).data == value) {
					selectedTrackTypeIndex = i;
					return;
				}
			}
			throw(new Error("unknown track type selected"));
		}

		public var selectedLicenseIndex:int;


		// SC internal id that is assigned after upload
		public var id:int;
		public var permalink:String;

		// editable fields
		public var title:String;
		public var asset_data:File; // the audio file
//		public var artwork_data:File; // the artwork file
		public var bpm:Number;
		public var description:String;
		public var downloadable:Boolean;
		public var genre:String; //a comma separated list of genres
//		public var isrc:String;
//		public var key_signature:String; 	// enumeration
//		public var label_id:uint;
		public var label_name:String;
		public var purchase_url:String;
		public var release:String;
		private var _release_day:uint = new Date().date;
		private var _release_month:uint = new Date().month+1;
		private var _release_year:uint = new Date().fullYear;
//		public var sharing:String			= "private"; // "public" or "private"
//		public var streamable:Boolean
		public var tag_list:String; //a space separated list of tags
		public var video_url:String;

		public function get license():String
		{
			return SetData.LICENSE_TYPES.getItemAt(selectedLicenseIndex).data;
		}

		public function set license(value:String):void
		{
			for (var i:int = 0; i < SetData.LICENSE_TYPES.length; i++) {
				if (SetData.LICENSE_TYPES.getItemAt(i).data == value) {
					selectedLicenseIndex = i;
					return;
				}
			}
			throw(new Error("unknown license type selected"));
		}
//		public var shared_to:String; 		// array of emails

		// scup internal fields
		public var index:uint; // index of this item within the tracklist
		public var isUploading:Boolean;
		public var uploadComplete:Boolean;
		public var uploadFailed:Boolean;
		public var isDirty:Boolean = true; // TODO set by details panel

		// release date fields
		public var releaseDate:Date = new Date();

		public function get release_year():uint
		{
			return releaseDate.fullYear;
		}

		public function set release_year(value:uint):void
		{
			releaseDate.fullYear = value;
		}

		public function get release_month():uint
		{
			return releaseDate.month;
		}

		public function set release_month(value:uint):void
		{
			releaseDate.month = value - 1;
		}

		public function get release_day():uint
		{
			return releaseDate.date;
		}

		public function set release_day(value:uint):void
		{
			releaseDate.date = value;
		}

	}
}

