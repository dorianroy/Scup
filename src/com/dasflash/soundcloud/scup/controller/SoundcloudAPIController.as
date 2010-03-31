package com.dasflash.soundcloud.scup.controller
{
	import com.dasflash.soundcloud.as3api.SoundcloudClient;
	import com.dasflash.soundcloud.as3api.SoundcloudDelegate;
	import com.dasflash.soundcloud.as3api.SoundcloudResponseFormat;
	import com.dasflash.soundcloud.as3api.events.SoundcloudAuthEvent;
	import com.dasflash.soundcloud.as3api.events.SoundcloudEvent;
	import com.dasflash.soundcloud.as3api.events.SoundcloudFaultEvent;
	import com.dasflash.soundcloud.scup.controller.delegate.SetDelegate;
	import com.dasflash.soundcloud.scup.controller.delegate.TrackDelegate;
	import com.dasflash.soundcloud.scup.events.AddFilesEvent;
	import com.dasflash.soundcloud.scup.events.AppEvent;
	import com.dasflash.soundcloud.scup.events.AuthWindowEvent;
	import com.dasflash.soundcloud.scup.events.CompleteAuthEvent;
	import com.dasflash.soundcloud.scup.events.MainWindowEvent;
	import com.dasflash.soundcloud.scup.events.ThrobberEvent;
	import com.dasflash.soundcloud.scup.events.TrackListEvent;
	import com.dasflash.soundcloud.scup.model.ScupConstants;
	import com.dasflash.soundcloud.scup.model.SetData;
	import com.dasflash.soundcloud.scup.model.TrackData;
	import com.dasflash.soundcloud.scup.model.UserData;
	
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import org.iotashan.oauth.OAuthToken;
	import org.swizframework.core.IDispatcherAware;

//	import org.swizframework.storage.EncryptedLocalStorageBean;
	
	[Event(type="com.dasflash.soundcloud.scup.events.MainWindowEvent", name="openMainWindow")]
	[Event(type="com.dasflash.soundcloud.scup.events.AuthWindowEvent", name="openAuthPage")]
	[Event(type="com.dasflash.soundcloud.scup.events.AuthWindowEvent", name="openAuthFailPage")]
	[Event(type="com.dasflash.soundcloud.scup.events.AuthWindowEvent", name="openUserInvalidPage")]
	[Event(type="com.dasflash.soundcloud.scup.events.AuthWindowEvent", name="openNoConnectionPage")]
	[Event(type="com.dasflash.soundcloud.scup.events.AuthWindowEvent", name="hideAuthWindow")]
	[Event(type="com.dasflash.soundcloud.scup.events.ThrobberEvent", name="showThrobber")]
	[Event(type="com.dasflash.soundcloud.scup.events.ThrobberEvent", name="hideThrobber")]
	[Event(type="com.dasflash.soundcloud.scup.events.AppEvent", name="initApp")]

	/**
	 * Controls communication with the SoundCloud API using an instance
	 * of the SoundcloudClient API wrapper class
	 * 
	 * @author Dorian Roy
	 * http://dasflash.com
	 */
	public class SoundcloudAPIController implements IDispatcherAware
	{
		private var _dispatcher:IEventDispatcher;
		 
		/**
		 * IDispatcherAware implementation. Will be automatically set from Swiz.
		 * Use this dispatcher instance to dispatch events Swiz should handle.
		 *
		 * @param dispatcher Swiz dispatcher.
		 *
		 */
		public function set dispatcher(dispatcher:IEventDispatcher):void
		{
			_dispatcher = dispatcher;
		}
		
		/**
		 * User data bean
		 */
	 	[Inject]
		public var userData:UserData;
		/**
		 * Set data bean
		 */
	 	[Inject]
		public var setData:SetData;
		
		/**
		 *  EncryptedLocalStorageController bean
		 */		
		[Inject]
		public var localStorage:EncryptedLocalStorageController;
		
		/**
		 * Instance of Soundcloud API wrapper
		 */
		protected var soundcloudClient:SoundcloudClient;
		
		
		// AUTHENTICATION STEP 1
		// check for a previously saved access token
		
		[Mediate(event="initApp")]
		public function initAppHandler(event:Event):void
		{
//			deleteAccessToken();// TODO temp

			// look for saved token
			var savedToken:OAuthToken = getAccessToken();
			
			// if soundcloud api consumer doesn't already exist
			if (!soundcloudClient) {
				
				// create it
				soundcloudClient = new SoundcloudClient(ScupConstants.CONSUMER_KEY,
														ScupConstants.CONSUMER_SECRET,
														savedToken,
														false,
														SoundcloudResponseFormat.XML);
			}
			
			// if a saved access token exists
			if (savedToken) {
				
				// check if token is valid
				getMe();
			
			// else start authentication process to get an access token
			} else {
				getRequestToken();
			}
		}
		
		// check saved token is valid by calling "me"
		protected function getMe():void
		{
			var delegate:SoundcloudDelegate = soundcloudClient.sendRequest("me", URLRequestMethod.GET);
			delegate.addEventListener(SoundcloudEvent.REQUEST_COMPLETE, getMeCompleteHandler);
			delegate.addEventListener(SoundcloudFaultEvent.FAULT, getMeFaultHandler);
		}
		
		// if request is successfully completed token is valid
		protected function getMeCompleteHandler(event:SoundcloudEvent):void
		{
			// save user data from response body
			userData.userId = event.data["id"];
			userData.userName = event.data["username"];
			userData.profileURL = event.data["permalink-url"];
			
			// open drop window to start uploading files
//			windowController.openAuthWindow();
			
			setData.resetData();
			
			_dispatcher.dispatchEvent(new AuthWindowEvent(AuthWindowEvent.HIDE_AUTH_WINDOW));
			
			_dispatcher.dispatchEvent(new MainWindowEvent(MainWindowEvent.OPEN_MAIN_WINDOW));
		}
		
		// if me request fails 
		protected function getMeFaultHandler(event:SoundcloudFaultEvent):void
		{
			// look at the cause of this fault
			switch (event.errorCode) {
				
				// if "Unauthorized"
				case 401:
					
					// open "invalid user" screen
					_dispatcher.dispatchEvent(new AuthWindowEvent(AuthWindowEvent.OPEN_USER_INVALID_PAGE));
					break;
				
				// else this is most likely a missing internet connection
				default:
					
					// show message "can't access soundcloud"
					_dispatcher.dispatchEvent(new AuthWindowEvent(AuthWindowEvent.OPEN_NO_CONNECTION_PAGE));
			}
			
			// remove listener for subsequent fault events this call may cause.
			// usually after a http status error there's an additional io error
			// coming up which we can discard here
			SoundcloudDelegate(event.target).removeEventListener(SoundcloudFaultEvent.FAULT, getMeFaultHandler);
		}
		
		// AUTHENTICATION STEP 2
		// get request token
		
		protected function getRequestToken():void
		{
			soundcloudClient.addEventListener(SoundcloudAuthEvent.REQUEST_TOKEN, requestTokenSuccessHandler);
			soundcloudClient.addEventListener(SoundcloudFaultEvent.REQUEST_TOKEN_FAULT, requestTokenFaultHandler);
			soundcloudClient.getRequestToken();
		}
		
		/**
		 *  This is bad. Can only reset app in this case.
		 * @private
		 */
		protected function requestTokenFaultHandler(event:SoundcloudFaultEvent):void
		{
			// re-init app
			_dispatcher.dispatchEvent(new AppEvent(AppEvent.INIT_APP));
		}
		

		// AUTHENTICATION STEP 3
		// open authentication window
		
		protected function requestTokenSuccessHandler(event:SoundcloudAuthEvent):void
		{
			_dispatcher.dispatchEvent(new AuthWindowEvent(AuthWindowEvent.OPEN_AUTH_PAGE));
		}
		
		
		// AUTHENTICATION STEP 4
		// navigate to authentication page
		
		[Mediate(event="openAuthPage")]
		public function openAuthPageHandler(event:AuthWindowEvent):void
		{
			soundcloudClient.authorizeUser();
		}
		
		
		// AUTHENTICATION STEP 5
		// trade authenticated request token for access token
		
		[Mediate(event="completeAuth")]
		public function completeAuthHandler(event:CompleteAuthEvent):void
		{
			soundcloudClient.addEventListener(SoundcloudAuthEvent.ACCESS_TOKEN, accessTokenSuccessHandler);
			soundcloudClient.addEventListener(SoundcloudFaultEvent.ACCESS_TOKEN_FAULT, accessTokenFaultHandler);
			soundcloudClient.getAccessToken(event.verificationCode);
		}
		
		protected function accessTokenFaultHandler(event:SoundcloudFaultEvent):void
		{
			_dispatcher.dispatchEvent(new AuthWindowEvent(AuthWindowEvent.OPEN_AUTH_FAIL_PAGE));
		}
		
		
		// AUTHENTICATION STEP 6
		// save access token in encrypted local store
		
		protected function accessTokenSuccessHandler(event:SoundcloudAuthEvent):void
		{
			saveAccessToken(event.token);
			
			setData.resetData();
			
			_dispatcher.dispatchEvent(new AuthWindowEvent(AuthWindowEvent.HIDE_AUTH_WINDOW));
			
			_dispatcher.dispatchEvent(new MainWindowEvent(MainWindowEvent.OPEN_MAIN_WINDOW));
		}
		
		
		// UPLOAD TRACKS
		
		/**
		 * Cycle through queued tracks and start the next upload(s)
		 */
		public function uploadTracks():void
		{
			// get list of tracks
			var tracks:IList = setData.trackCollection;
			
			// this will count running uploads
			var uploadCount:int = 0;
			
			// this will determine if there is at least one queued track left
			var allUploadsCompleted:Boolean = true;
			
			// cycle through tracks
			for (var i:int=0; i<tracks.length; ++i) {
				
				// get track data
				var track:TrackData = tracks.getItemAt(i) as TrackData;
				
				// if track is currently uploading
				if (track.isUploading) {
					
					// increase count
					uploadCount++;
					
					// note that queue is not completed
					allUploadsCompleted = false;
				
				// else if track is still waiting to be uploaded
				} else if (!track.uploadComplete) {
				
					// if max. number of simultaneous uploads is not reached
					if (uploadCount < ScupConstants.CONCURRENT_UPLOADS) {
					
						// create a delegate object to handle the upload request
						// I could have executed the upload without this additional class,
						// but the delegate can hold state of the upload process and that makes
						// it easier to save the returned track id in the corresponding TrackData					
						var trackDelegate:TrackDelegate = new TrackDelegate(soundcloudClient, track);
						trackDelegate.addEventListener(SoundcloudEvent.REQUEST_COMPLETE, trackUploadCompleteHandler);
//						trackDelegate.addEventListener(SoundcloudFaultEvent.FAULT, trackUploadFaultHandler);
						trackDelegate.startUpload();
						
						// count this upload
						uploadCount++;
					}
					
					// note that queue is not completed
					allUploadsCompleted = false;
				}
			}
			
			// tell set data if queue has run empty
			setData.allUploadsCompleted = allUploadsCompleted;
		}
		
		protected function trackUploadCompleteHandler(event:SoundcloudEvent):void
		{
			// continue with the next uploads
			uploadTracks();
		}
		
		[Mediate(event="retryTrack")]
		public function retryTrackHandler(event:TrackListEvent):void
		{
			// restart queue
			event.trackData.uploadComplete = false;
			
			uploadTracks();
		}
		
		[Mediate(event="deleteTrack")]
		public function deleteTrackHandler(event:TrackListEvent):void
		{
			var track:TrackData = event.trackData;
			
			// abort upload
			if (track.isUploading) {
				track.asset_data.cancel();
				
			// if track is already uploaded
			} else if (track.id) {
				
				// delete track on server
				var delegate:SoundcloudDelegate = soundcloudClient.sendRequest("tracks/"+track.id, URLRequestMethod.DELETE);
				delegate.addEventListener(SoundcloudEvent.REQUEST_COMPLETE, onDeleteComplete);
				delegate.addEventListener(SoundcloudFaultEvent.FAULT, onDeleteFault);
			}
			
			//delete track from set
			var tracks:IList = setData.trackCollection;
			tracks.removeItemAt(tracks.getItemIndex(event.trackData));
			
			// continue with the next uploads
			uploadTracks();
		}
		
		private function onDeleteComplete(event:SoundcloudEvent):void
		{
		}
		
		private function onDeleteFault(event:SoundcloudFaultEvent):void
		{
			Alert.show("Sorry, the track couldn't be deleted from the server." +
				"Please go to your SoundCloud account and try to delete it manually.");
		}
		
		[Mediate(event="addFiles")]
		public function addFilesHandler(event:AddFilesEvent):void
		{
			if (setData.trackCollection.length == 0) {
				//setData.resetData();
			}
			
			addTracks(event.files);
		}
		
		protected function addTracks(files:Array):void
		{
			// collect selected file(s) in a collection
			// var tracks:ArrayCollection = new ArrayCollection();
			
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
			
			// process queue
			uploadTracks();
		}
		
		// SAVE SET
		
		[Mediate(event="saveSet")]
		public function saveSetHandler(event:AppEvent):void
		{
			if (!setData.title) {
				
				Alert.show("Please enter a title for your set");
				
			} else if (setData.ean && setData.ean.length < 13) {
				
				Alert.show("Please enter a valid 13-digit EAN code or leave the field blank");
				
			} else {
				
				_dispatcher.dispatchEvent(new ThrobberEvent(ThrobberEvent.SHOW_THROBBER));
				
				saveSet();
			}
		}
		
		/**
		 * creates or modifies a playlist resource on the server
		 * (sets are called "playlist" in the SC API spec)
		 */
		public function saveSet():void
		{
			// create a delegate object to handle the upload request
			// I could have executed the upload without this additional class,
			// but the delegate can hold state of the upload process and that makes
			// it easier to save the returned set id in the SetData				
			var setDelegate:SetDelegate = new SetDelegate(soundcloudClient, setData);
			setDelegate.addEventListener(SoundcloudEvent.REQUEST_COMPLETE, saveSetCompleteHandler);
			setDelegate.addEventListener(SoundcloudFaultEvent.FAULT, saveSetFaultHandler);
			setDelegate.postSet();
		}
		
		protected function saveSetCompleteHandler(event:SoundcloudEvent):void
		{
			trace("save set complete");
			
			updateSet();
		}
		
		protected function saveSetFaultHandler(event:SoundcloudFaultEvent):void
		{
			Alert.show("Sorry, the set couldn't be saved. Please try again.");
			
			_dispatcher.dispatchEvent(new ThrobberEvent(ThrobberEvent.HIDE_THROBBER));
		}
		
		protected function updateSet():void
		{
			var setDelegate:SetDelegate = new SetDelegate(soundcloudClient, setData);
			setDelegate.addEventListener(SoundcloudEvent.REQUEST_COMPLETE, updateSetCompleteHandler);
			setDelegate.addEventListener(SoundcloudFaultEvent.FAULT, updateSetFaultHandler);
			setDelegate.updateSet();
		}
		
		protected function updateSetCompleteHandler(event:SoundcloudEvent):void
		{
			trace("update set complete");
			
			updateTracks();
		}
		
		protected function updateSetFaultHandler(event:SoundcloudFaultEvent):void
		{
			Alert.show("Sorry, the set couldn't be saved. Please try again.");
			
			_dispatcher.dispatchEvent(new ThrobberEvent(ThrobberEvent.HIDE_THROBBER));
		}
		
		protected function updateTracks():void
		{
			// get list of tracks
			var tracks:IList = setData.trackCollection;
			
			// this will count running uploads
			var uploadCount:int = 0;
			
			// this will determine if there is at least one queued track left
			var allUploadsCompleted:Boolean = true;
			
			// cycle through tracks
			for (var i:int=0; i<tracks.length; ++i) {
				
				// get track data
				var track:TrackData = tracks.getItemAt(i) as TrackData;
				
				// if track is currently uploading
				if (track.isUploading) {
					
					// increase count
					uploadCount++;
					
					// note that queue is not completed
					allUploadsCompleted = false;
					
					// else if track is still waiting to be uploaded
				} else if (track.isDirty) {
					
					// if max. number of simultaneous uploads is not reached
					if (uploadCount < ScupConstants.CONCURRENT_UPLOADS) {
						
						// create a delegate object to handle the upload request
						// I could have executed the upload without this additional class,
						// but the delegate can hold state of the upload process and that makes
						// it easier to save the returned track id in the corresponding TrackData					
						var trackDelegate:TrackDelegate = new TrackDelegate(soundcloudClient, track);
						trackDelegate.addEventListener(SoundcloudEvent.REQUEST_COMPLETE, trackUpdateCompleteHandler);
						trackDelegate.addEventListener(SoundcloudFaultEvent.FAULT, trackUpdateFaultHandler);
						trackDelegate.putTrackData(setData);
						
						// count this upload
						uploadCount++;
					}
					
					// note that queue is not completed
					allUploadsCompleted = false;
				}
			}
			
			// when the save set sequnce has finished
			if (allUploadsCompleted) {
				
				var alertText:String = "Your set has been saved. Do you want to view it in the browser now?";
				
				Alert.show(alertText, "Save set complete", Alert.YES | Alert.NO, null, saveSetAlertCloseHandler, null, Alert.NO);
			}
			
		}
		
		protected function saveSetAlertCloseHandler(event:CloseEvent):void
		{
			if (event.detail == Alert.YES) {
				navigateToURL(new URLRequest(setData.permalink));
			}
			
			// clear set data
			setData.resetData();
			
			// hide throbber
			_dispatcher.dispatchEvent(new ThrobberEvent(ThrobberEvent.HIDE_THROBBER));
		}
		
		protected function trackUpdateCompleteHandler(event:SoundcloudEvent):void
		{
			// continue with the next track update
			updateTracks();
		}
		
		protected function trackUpdateFaultHandler(event:SoundcloudFaultEvent):void
		{
			Alert.show("The set has been saved, but the settings for some tracks couldn't be updated. Please review the tracks online at "+
			setData.permalink+". Sorry!");
			
			_dispatcher.dispatchEvent(new ThrobberEvent(ThrobberEvent.HIDE_THROBBER));
		}
		
		// CANCEL SET
		[Mediate(event="cancelSet")]
		public function cancelSetHandler(event:AppEvent):void
		{
			Alert.show("If you continue, the already uploaded tracks will not be deleted but all the settings you just made will be lost.",
				"", Alert.CANCEL|Alert.OK, null, cancelAlertCloseHandler);
		}
		
		protected function cancelAlertCloseHandler(event:CloseEvent):void
		{
			switch (event.detail) {
				
				case Alert.OK:
					cancelSet();
					break;
			}
		}
		
		public function cancelSet():void
		{
			// cancel all running uploads
			for each (var track:TrackData in setData.trackCollection) {
				
				if (track.isUploading) {
					track.asset_data.cancel();
				}
			}
			
			// clear data
			setData.resetData();
		}
		
		
		// SAVE SET COMPLETE
		[Mediate(event="resetApp")]
		public function resetAppHandler(event:AuthWindowEvent):void
		{
			initAppHandler(event);
		}
		
		// SWITCH USER 
		[Mediate(event="switchUser")]
		public function switchUser(event:AuthWindowEvent):void
		{
			// delete old credentials
			deleteAccessToken();
			
			// re-init app
			_dispatcher.dispatchEvent(new AppEvent(AppEvent.INIT_APP));
		}
		
		
		// TOKEN STORAGE API
		
		public function getAccessToken():OAuthToken
		{
			var obj:Object = localStorage.getObject("accessToken");
			var token:OAuthToken = obj && obj.key && obj.secret ? new OAuthToken(obj.key, obj.secret) : null;
			return token;
			
			/*var obj:Object = encryptedLocalStorage.getObject("accessToken");
			var token:OAuthToken = obj && obj.key && obj.secret ? new OAuthToken(obj.key, obj.secret) : null;
			return token;*/
//			return null;
		}
		
		public function saveAccessToken(token:OAuthToken):void
		{
			localStorage.setObject("accessToken", token);
			/*encryptedLocalStorage.setObject("accessToken", token);*/
		}
		
		protected function deleteAccessToken():void
		{
			localStorage.removeItem("accessToken");
			/*encryptedLocalStorage.removeItem("accessToken");*/
		}
		
	}
}
