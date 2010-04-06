package com.dasflash.soundcloud.scup.controller.delegate
{
	import com.dasflash.soundcloud.as3api.SoundcloudClient;
	import com.dasflash.soundcloud.as3api.SoundcloudDelegate;
	import com.dasflash.soundcloud.as3api.events.SoundcloudEvent;
	import com.dasflash.soundcloud.as3api.events.SoundcloudFaultEvent;
	import com.dasflash.soundcloud.scup.model.SetData;
	import com.dasflash.soundcloud.scup.model.TrackData;

	import flash.events.EventDispatcher;
	import flash.net.URLRequestMethod;


	[Event(type="com.dasflash.soundcloud.as3api.events.SoundcloudEvent", name="requestComplete")]
	[Event(type="com.dasflash.soundcloud.as3api.events.SoundcloudFaultEvent", name="fault")]


	/**
	 * Handles upload of a single track
	 */
	public class TrackDelegate extends EventDispatcher
	{
		protected var client:SoundcloudClient;
		private var _trackData:TrackData;


		/**
		 * @param trackData
		 */
		public function TrackDelegate(client:SoundcloudClient, trackData:TrackData)
		{
			this.client = client;
			_trackData = trackData;
		}

		public function get trackData():TrackData
		{
			return _trackData;
		}

		public function startUpload():void
		{
			// create track parameters object
			var params:Object = {};
			params["track[title]"] = trackData.title;
			params["track[asset_data]"] = trackData.asset_data;
			params["track[sharing]"] = "private"; // make private until set is saved

			var delegate:SoundcloudDelegate = client.sendRequest("tracks", URLRequestMethod.POST, params);
			delegate.addEventListener(SoundcloudEvent.REQUEST_COMPLETE, uploadCompleteHandler);
			delegate.addEventListener(SoundcloudFaultEvent.FAULT, uploadFaultHandler);

			trackData.isUploading = true;
			trackData.uploadFailed = false;
		}

		protected function uploadCompleteHandler(event:SoundcloudEvent):void
		{
			trackData.isUploading = false;
			trackData.uploadComplete = true;

			// save id assigned by SoundCloud in TrackData
			if (event.data && event.data.hasOwnProperty("id")) {
				trackData.id = event.data.id;
				trackData.permalink = event.data["permalink-url"];

			} else {
				trackData.uploadFailed = true;
			}

			// redispatch this event 
			dispatchEvent(event);
		}

		protected function uploadFaultHandler(event:SoundcloudFaultEvent):void
		{
			trackData.isUploading = false;
			trackData.uploadComplete = true;

			trackData.uploadFailed = true;

			// redispatch this event
			dispatchEvent(event);
		}

		public function putTrackData(setData:SetData):void
		{
			// create XML data
			var data:XML = <track/>;

			// add id
			data.id = trackData.id;
			data.id.@type = "integer";

			// add user defined fields
			data.title = data.title;
			if (trackData.bpm)
				data.bpm = trackData.bpm;
			if (trackData.description)
				data.description = trackData.description;
			if (trackData.genre)
				data.genre = trackData.genre;
			if (trackData.label_name)
				data.label_name = trackData.label_name;
			if (trackData.purchase_url)
				data.purchase_url = trackData.purchase_url;
			if (trackData.release_day)
				data.release_day = trackData.release_day;
			if (trackData.release_month)
				data.release_month = trackData.release_month;
			if (trackData.release_year)
				data.release_year = trackData.release_year;
			if (trackData.tag_list)
				data.tag_list = trackData.tag_list;
			if (trackData.track_type)
				data.track_type = trackData.track_type;
			if (trackData.video_url)
				data.video_url = trackData.video_url;
			if (trackData.license)
				data.license = trackData.license;

			// copy some fields from set data
			data.streamable = setData.streamable;
			data.sharing = setData.sharing;
			data.downloadable = setData.downloadable;

			// update track via PUT
			var delegate:SoundcloudDelegate;
			delegate = client.sendRequest("tracks/" + trackData.id, URLRequestMethod.PUT, data);

			// listen to server response
			delegate.addEventListener(SoundcloudEvent.REQUEST_COMPLETE, putTrackCompleteHandler);
			delegate.addEventListener(SoundcloudFaultEvent.FAULT, putTrackFaultHandler);

			trackData.isUploading = true;
		}

		protected function putTrackCompleteHandler(event:SoundcloudEvent):void
		{
			trackData.isUploading = false;
			trackData.isDirty = false;

			// redispatch this event 
			dispatchEvent(event);
		}

		protected function putTrackFaultHandler(event:SoundcloudFaultEvent):void
		{
			trackData.isUploading = false;

			// redispatch this event
			dispatchEvent(event);
		}

		public function deleteTrack():void
		{
			var delegate:SoundcloudDelegate = client.sendRequest("tracks/" + trackData.id, URLRequestMethod.DELETE);
			delegate.addEventListener(SoundcloudEvent.REQUEST_COMPLETE, deleteTrackCompleteHandler);
			delegate.addEventListener(SoundcloudFaultEvent.FAULT, deleteTrackFaultHandler);
		}

		private function deleteTrackFaultHandler(event:SoundcloudFaultEvent):void
		{
			dispatchEvent(event);
		}

		private function deleteTrackCompleteHandler(event:SoundcloudEvent):void
		{
			dispatchEvent(event);
		}
	}
}

