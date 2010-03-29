	package com.dasflash.soundcloud.scup.controller
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
	public class SetDelegate extends EventDispatcher
	{
		protected var client:SoundcloudClient;
		protected var setData:SetData;
			
		
		/**
		 * @param trackData
		 */
		public function SetDelegate(client:SoundcloudClient, setData:SetData)
		{
			this.client = client;
			this.setData = setData;
		}
		
		public function postSet():void
		{
			// create track parameters object
			var params:Object = {};
			params["playlist[title]"] = setData.title;
			if (setData.artwork_data) params["playlist[artwork_data]"] = setData.artwork_data;
			
			// create playlist via POST
			var delegate:SoundcloudDelegate;
			delegate = client.sendRequest("playlists", URLRequestMethod.POST, params);
			delegate.addEventListener(SoundcloudEvent.REQUEST_COMPLETE, postSetCompleteHandler);
			delegate.addEventListener(SoundcloudFaultEvent.FAULT, postSetFaultHandler);
			
			setData.isUploading = true;
		}
		
		protected function postSetCompleteHandler(event:SoundcloudEvent):void
		{
			setData.isUploading = false;
			
			// save id assigned by SoundCloud in TrackData
			setData.setId = event.data.id;
			setData.permalink = event.data["permalink-url"];
			
			// redispatch this event 
			dispatchEvent(event);
		}
		
		protected function postSetFaultHandler(event:SoundcloudFaultEvent):void
		{
			setData.isUploading = false;
			
			// redispatch this event
			dispatchEvent(event);
		}
		
		public function updateSet():void
		{
			/*
			* Send parameters as XML because using URL-parameters would require to add 
			* the same parameter name for each track which isn't supported by URLVariables
			*/
			
			var data:XML = <playlist/>;
										data.title			 = setData.title;
			if (setData.description)	data.description	 = setData.description;
			if (setData.tag_list)		data.tag_list		 = setData.tag_list;
			if (setData.ean)			data.ean			 = setData.ean;
			if (setData.genre)			data.genre			 = setData.genre;
			if (setData.label_name)		data.label_name		 = setData.label_name;
			if (setData.playlist_type)	data.playlist_type	 = setData.playlist_type;
			if (setData.purchase_url)	data.purchase_url	 = setData.purchase_url;
			if (setData.release)		data.release		 = setData.release;
			if (setData.release_day)	data.release_day	 = setData.release_day;
			if (setData.release_month)	data.release_month	 = setData.release_month;
			if (setData.release_year)	data.release_year	 = setData.release_year;
										data.streamable		 = setData.streamable;
										data.sharing		 = setData.sharing;
										data.downloadable	 = setData.downloadable;
			if (setData.license)		data.license		 = setData.license;
			
			// add array of email addresses
			if (setData.shared_to) {
				
				var emailsXML:XML = <shared-to><emails type="array"/></shared-to>;
				
				var addresses:Array = setData.shared_to.split(",");
				
				for each (var address:String in addresses) {
					
					var addressXML:XML = new XML("<email><address>"+address+"</address></email>");
					// remove whitespace
					emailsXML.emails.appendChild(addressXML);
				}
				
				data.appendChild(emailsXML);
			}
			
			// add list of tracks
			if (setData.trackCollection.length > 0) {
				
				// add all tracks
				// TOOD make sure the order is correct
				for each (var track:TrackData in setData.trackCollection) {
					
					// if track has been uploaded and assigned a soundcloud id
					if (track.id) {
						
						// create XML list
						if (!data.hasOwnProperty("tracks")) {
							data.appendChild(<tracks type="array"/>);
						}
						
						// add track
						var trackXML:XML = new XML("<track><id>"+track.id+"</id></track>");
						data.tracks.appendChild(trackXML);
					}
				}
			}
			
			var delegate:SoundcloudDelegate;
			delegate = client.sendRequest("playlists/" + setData.setId, URLRequestMethod.PUT, data);
			delegate.addEventListener(SoundcloudEvent.REQUEST_COMPLETE, updateSetCompleteHandler);
			delegate.addEventListener(SoundcloudFaultEvent.FAULT, updateSetFaultHandler);
		}
		
		protected function updateSetCompleteHandler(event:SoundcloudEvent):void
		{
			// redispatch this event
			dispatchEvent(event);
		}
		
		protected function updateSetFaultHandler(event:SoundcloudFaultEvent):void
		{
			// redispatch this event
			dispatchEvent(event);
		}
		
	}
}
