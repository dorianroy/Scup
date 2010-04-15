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
	import com.dasflash.soundcloud.scup.events.*;
	import com.dasflash.soundcloud.scup.model.ScupConstants;
	import com.dasflash.soundcloud.scup.model.SetData;
	import com.dasflash.soundcloud.scup.model.TrackData;
	import com.dasflash.soundcloud.scup.model.UserData;
	import com.dasflash.soundcloud.scup.model.UserSettings;
	
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
	[Event(type="com.dasflash.soundcloud.scup.events.AuthWindowEvent", name="stateAuth")]
	[Event(type="com.dasflash.soundcloud.scup.events.AuthWindowEvent", name="stateAuthFail")]
	[Event(type="com.dasflash.soundcloud.scup.events.AuthWindowEvent", name="stateUserInvalid")]
	[Event(type="com.dasflash.soundcloud.scup.events.AuthWindowEvent", name="stateNoConnection")]
	[Event(type="com.dasflash.soundcloud.scup.events.AuthWindowEvent", name="stateBusy")]
	[Event(type="com.dasflash.soundcloud.scup.events.AuthWindowEvent", name="hideAuthWindow")]
	[Event(type="com.dasflash.soundcloud.scup.events.AuthWindowEvent", name="gotoAuthPage")]
	[Event(type="com.dasflash.soundcloud.scup.events.AppEvent", name="initApp")]

	/**
	 * Controls communication with the SoundCloud API using an instance
	 * of the SoundcloudClient API wrapper class. This class handles 
	 * OAuth authentication as well as uploading tracks and artwork 
	 * and saving meta data.
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
		 */
		public function set dispatcher(dispatcher:IEventDispatcher):void
		{
			_dispatcher = dispatcher;
		}
		
		/**
		 * UserSettings Bean
		 */
		[Inject]
		public var userSettings:UserSettings;
		
		/**
		 * UserData bean
		 */
	 	[Inject]
		public var userData:UserData;
		
		/**
		 * SetData bean
		 */
	 	[Inject]
		public var setData:SetData;
		
		/**
		 * Instance of Soundcloud API wrapper
		 */
		protected var soundcloudClient:SoundcloudClient;
		
		
		// AUTHENTICATION STEP 1
		// check for a previously saved access token
			
		[Mediate(event="initApp")]
		public function initAppHandler(event:Event):void
		{
//			userSettings.accessToken = null;// TODO temp

			// look for saved token
			var savedToken:OAuthToken = userSettings.accessToken;
			
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
			
			// show to main window
			showMainView();
		}
		
		// if me request failed
		protected function getMeFaultHandler(event:SoundcloudFaultEvent):void
		{
			// look at the cause of this fault
			switch (event.errorCode) {
				
				// if "Unauthorized"
				case 401:
					
					// open "invalid user" screen
					_dispatcher.dispatchEvent(new AuthWindowEvent(AuthWindowEvent.STATE_USER_INVALID));
					break;
				
				// else this is most likely missing internet connection
				default:
					
					// show message "can't access soundcloud"
					_dispatcher.dispatchEvent(new AuthWindowEvent(AuthWindowEvent.STATE_NO_CONNECTION));
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
			_dispatcher.dispatchEvent(new AuthWindowEvent(AuthWindowEvent.STATE_BUSY));
			
			soundcloudClient.addEventListener(SoundcloudAuthEvent.REQUEST_TOKEN, requestTokenSuccessHandler, false, 0, true);
			soundcloudClient.addEventListener(SoundcloudFaultEvent.REQUEST_TOKEN_FAULT, requestTokenFaultHandler, false, 0, true);
			soundcloudClient.getRequestToken();
		}
		
		/**
		 * Couldn't retrieve a request token. This is bad. Either SoundCloud
		 * is down or there's no internet connection.
		 * @private
		 */
		protected function requestTokenFaultHandler(event:SoundcloudFaultEvent):void
		{
			// show message "can't access soundcloud"
			_dispatcher.dispatchEvent(new AuthWindowEvent(AuthWindowEvent.STATE_NO_CONNECTION));
		}
		

		// AUTHENTICATION STEP 3
		// open authentication window
		
		protected function requestTokenSuccessHandler(event:SoundcloudAuthEvent):void
		{
			// open auth window
			_dispatcher.dispatchEvent(new AuthWindowEvent(AuthWindowEvent.STATE_AUTH));
		}
		
		
		// AUTHENTICATION STEP 4
		// navigate to authentication page
		
		[Mediate(event="gotoAuthPage")]
		public function stateAuthHandler(event:AuthWindowEvent):void
		{
			// open login page in browser
			soundcloudClient.authorizeUser();
		}
		
		
		// AUTHENTICATION STEP 5
		// trade authenticated request token for access token
		
		[Mediate(event="completeAuth")]
		public function completeAuthHandler(event:CompleteAuthEvent):void
		{
			if (!event.verificationCode) {
				
				_dispatcher.dispatchEvent(new AuthWindowEvent(AuthWindowEvent.STATE_AUTH_FAIL));
				
				return;
			}
			
			_dispatcher.dispatchEvent(new AuthWindowEvent(AuthWindowEvent.STATE_BUSY));
			
			// request access token and pass verification code
			soundcloudClient.addEventListener(SoundcloudAuthEvent.ACCESS_TOKEN, accessTokenSuccessHandler, false, 0, true);
			soundcloudClient.addEventListener(SoundcloudFaultEvent.ACCESS_TOKEN_FAULT, accessTokenFaultHandler, false, 0, true);
			soundcloudClient.getAccessToken(event.verificationCode);
		}
		
		protected function accessTokenFaultHandler(event:SoundcloudFaultEvent):void
		{
			// show error message
			_dispatcher.dispatchEvent(new AuthWindowEvent(AuthWindowEvent.STATE_AUTH_FAIL));
		}
		
		
		// AUTHENTICATION STEP 6
		// save access token in encrypted local store
		
		protected function accessTokenSuccessHandler(event:SoundcloudAuthEvent):void
		{
			// save token locally
			userSettings.accessToken = event.token;
			
			// get user data
			getMe();
		}
		
		
		// SHOW MAIN VIEW
		protected function showMainView():void
		{
			// set setdata to default values
			setData.resetData();
			
			// hide auth window
			_dispatcher.dispatchEvent(new AuthWindowEvent(AuthWindowEvent.HIDE_AUTH_WINDOW));
			
			// show main window
			_dispatcher.dispatchEvent(new MainWindowEvent(MainWindowEvent.OPEN_MAIN_WINDOW));
		}
		
		
		// UPLOAD TRACKS
		
		[Mediate(event="tracklistChanged")]
		public function tracklistChangedHandler(event:SetDataEvent):void
		{
			processTrackQueue();
		}
		
		/**
		 * Cycle through queued tracks and start the next upload(s).
		 * The queue is capable of uploading multiple tracks simultaneously,
		 * though the number of concurrent uploads is set to 1 by default.
		 */
		public function processTrackQueue():void
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
			processTrackQueue();
		}
		
		[Mediate(event="retryTrack")]
		public function retryTrackHandler(event:TrackListEvent):void
		{
			// restart queue
			event.trackData.uploadComplete = false;
			
			processTrackQueue();
		}
		
		
		// DELETE TRACKS
		
		[Mediate(event="deleteTrack")]
		public function deleteTrackHandler(event:TrackListEvent):void
		{
			deleteTrackOnServer(event.trackData);
		}
		
		protected function deleteTrackOnServer(track:TrackData):void
		{
			// abort upload
			if (track.isUploading) {
				track.asset_data.cancel();
				
				// if track is already uploaded
			} else if (track.id) {
				
				// delete track on server
				var trackDelegate:TrackDelegate = new TrackDelegate(soundcloudClient, track);
				trackDelegate.addEventListener(SoundcloudFaultEvent.FAULT, onDeleteFault);
				trackDelegate.deleteTrack();
			}
		}
		
		private function onDeleteFault(event:SoundcloudFaultEvent):void
		{
			var trackTitle:String = TrackDelegate(event.target).trackData.title;
			
			Alert.show("Sorry, the track \""+trackTitle+"\" couldn't be deleted from the server." +
				"Please go to your SoundCloud account and try to delete it manually.");
		}
		
		
		// SAVE SET
		
		[Mediate(event="saveSet")]
		public function saveSetHandler(event:SetDataEvent):void
		{
			if (!setData.title) {
				
				Alert.show("Please enter a title for your set");
				
			} else if (setData.ean && setData.ean.length < 13) {
				
				Alert.show("Please enter a valid 13-digit EAN code or leave the field blank");
				
			} else {
				
				_dispatcher.dispatchEvent(new SpinnerEvent(SpinnerEvent.SHOW_SPINNER));
				
				saveSet();
			}
		}
		
		/**
		 * Creates or modifies a playlist resource on the server
		 * (sets are called "playlist" in the SC API spec).
		 */
		public function saveSet():void
		{
			// create a delegate object to handle the upload request
			// I could have executed the upload without this additional class,
			// but the delegate can hold state of the upload process which makes
			// it easier to save the returned set id in the SetData				
			var setDelegate:SetDelegate = new SetDelegate(soundcloudClient, setData);
			setDelegate.addEventListener(SoundcloudEvent.REQUEST_COMPLETE, saveSetCompleteHandler);
			setDelegate.addEventListener(SoundcloudFaultEvent.FAULT, saveSetFaultHandler);
			setDelegate.postSet();
		}
		
		protected function saveSetCompleteHandler(event:SoundcloudEvent):void
		{
			updateSet();
		}
		
		protected function saveSetFaultHandler(event:SoundcloudFaultEvent):void
		{
			Alert.show("Sorry, the set couldn't be saved. Please try again.");
			
			_dispatcher.dispatchEvent(new SpinnerEvent(SpinnerEvent.HIDE_SPINNER));
		}
		
		
		// UPDATE DATA
		
		protected function updateSet():void
		{
			var setDelegate:SetDelegate = new SetDelegate(soundcloudClient, setData);
			setDelegate.addEventListener(SoundcloudEvent.REQUEST_COMPLETE, updateSetCompleteHandler);
			setDelegate.addEventListener(SoundcloudFaultEvent.FAULT, updateSetFaultHandler);
			setDelegate.updateSet();
		}
		
		protected function updateSetCompleteHandler(event:SoundcloudEvent):void
		{
			updateTracks();
		}
		
		protected function updateSetFaultHandler(event:SoundcloudFaultEvent):void
		{
			Alert.show("Sorry, the set couldn't be saved. Please try again.");
			
			_dispatcher.dispatchEvent(new SpinnerEvent(SpinnerEvent.HIDE_SPINNER));
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
			
			// when the save set sequence has finished
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
			
			// hide spinner
			_dispatcher.dispatchEvent(new SpinnerEvent(SpinnerEvent.HIDE_SPINNER));
		}
		
		protected function trackUpdateCompleteHandler(event:SoundcloudEvent):void
		{
			// continue with the next track update
			updateTracks();
		}
		
		protected function trackUpdateFaultHandler(event:SoundcloudFaultEvent):void
		{
			Alert.show("The set has been saved, but the settings for some tracks " +
				"could not be updated. Please review the tracks online at "+
				setData.permalink);
			
			_dispatcher.dispatchEvent(new SpinnerEvent(SpinnerEvent.HIDE_SPINNER));
		}
		
		
		// CANCEL SET
		
		/*[Mediate(event="cancelSet")]
		public function cancelSetHandler(event:SetDataEvent):void
		{
			Alert.show("If you continue all uploaded tracks will be deleted from " +
				"the server and all data you've entered will be lost.",
				"", Alert.CANCEL|Alert.OK, null, cancelAlertCloseHandler);
		}*/
		
		protected function cancelAlertCloseHandler(event:CloseEvent):void
		{
			switch (event.detail) {
				
				case Alert.OK:
					cancelSet();
			}
		}
		
		public function cancelSet():void
		{
			// delete all tracks
			for each (var track:TrackData in setData.trackCollection) {
				deleteTrackOnServer(track);
			}
			
			// clear setdata
			setData.resetData();
		}
		
		
		// RESET APP
		
		[Mediate(event="resetApp")]
		public function resetApp(event:AppEvent):void
		{
			// delete old credentials
			userSettings.accessToken = null;
			
			// re-init app
			_dispatcher.dispatchEvent(new AppEvent(AppEvent.INIT_APP));
		}
		
	}
}
