package com.dasflash.soundcloud.scup.model
{
	import flash.events.EventDispatcher;
	import flash.filesystem.File;

	[Bindable] 
	public class TrackData extends EventDispatcher
	{
		// SC internal id that is assigned after upload
		public var id:int;
		public var permalink:String;
		
		// editable fields
	 	public var title:String;
		public var description:String;
		public var asset_data:File; // the audio file
/*		public var artwork_data:File;	// the artwork file
		public var bpm:Number;
		public var downloadable:Boolean;
		public var genre:String; 			//a comma separated list of genres
		public var isrc:String;
		public var key_signature:String; 	// enumeration
		public var label_id:uint;
		public var label_name:String;
		public var purchase_url:String;
		public var release:String;
		public var release_day:uint;
		public var release_month:uint;
		public var release_year:uint;
		public var sharing:String			= "private"; // "public" or "private"
		public var streamable:Boolean
		public var tag_list:String; 		//a space separated list of tags
		public var track_type:String; 		// "cover”, “demo”, “djset”, “in progress”, “live”, “mashup”, “original”, “part”, “podcast”, “reedit”, “remix” or “sample”
		public var video_url:String;
		public var license:String; 			// see SetData
		public var shared_to:String; 		// array of emails
*/		
		// scup internal fields
		public var index:uint; // index of this item within the tracklist
		public var isUploading:Boolean;
		public var uploadComplete:Boolean;
		public var uploadFailed:Boolean;
		public var isDirty:Boolean = true; // TODO set by details panel
	}
}

/*
 writable fields for "track":
	bpm
	description
	downloadable
	genre
	isrc
	key_signature
	label_id
	label_name
	purchase_url
	release
	release_day
	release_month
	release_year
	sharing
	streamable
	tag_list
	title
	track_type
	video_url
 */