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
			if (event.data && event.data.hasOwnProperty("id"))
			{
				trackData.id = event.data.id;
				trackData.permalink = event.data["permalink-url"];

			}
			else
			{
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
			var data:XML = <track/>;
			data.id = trackData.id;
			data.id.@type = "integer";
			data.title = trackData.title;
			if (trackData.description)
				data.description = trackData.description;

			// copy settings from set
			if (setData.tag_list)
				data.tag_list = setData.tag_list;
			if (setData.genre)
				data.genre = setData.genre;
			if (setData.label_name)
				data.label_name = setData.label_name;
			if (setData.purchase_url)
				data.purchase_url = setData.purchase_url;
			if (setData.release)
				data.release = setData.release;
			if (setData.release_day)
				data.release_day = setData.release_day;
			if (setData.release_month)
				data.release_month = setData.release_month;
			if (setData.release_year)
				data.release_year = setData.release_year;
			data.streamable = setData.streamable;
			data.sharing = setData.sharing;
			data.downloadable = setData.downloadable;
			if (setData.license)
				data.license = setData.license;
			
			// update track via PUT
			var delegate:SoundcloudDelegate;
			delegate = client.sendRequest("tracks/" + trackData.id, URLRequestMethod.PUT, data);

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

