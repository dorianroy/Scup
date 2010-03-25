package com.dasflash.soundcloud.scup.controller
{
	import com.dasflash.soundcloud.scup.events.DropWindowEvent;
	import com.dasflash.soundcloud.scup.model.SetData;
	import com.dasflash.soundcloud.scup.model.TrackData;
	
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.swizframework.core.IDispatcherAware;

	public class DropWindowController implements IDispatcherAware
	{
		private var _dispatcher:IEventDispatcher;
		 
		/**
		 * IDispatcherAware implementation. Will be automatically set from Swiz.
		 * Use this dispatcher instance to dispatch events Swiz should handle
		 *
		 * @param dispatcher Swiz dispacther.
		 *
		 */
		public function set dispatcher(dispatcher:IEventDispatcher):void
		{
			_dispatcher = dispatcher;
		}
		
		[Inject]
		public var windowController:WindowController;

		[Inject]
		public var apiController:SoundcloudAPIController;
		
		[Inject]
		public var model:SetData;
		
		
		/**
		 * Handler for "dropFile" event
		 * Invoked by dropping file(s) on the DropWindow
		 * Switches from DropWindow to main window, adds dropped files
		 * to the model and initiates the upload
		 * 
		 * @param event
		 */
		[Mediate(event="DropWindowEvent.DROP_FILE")]
		public function fileDropHandler(event:DropWindowEvent):void
		{
			// clear model data
			model.resetData();
			
			// collect dropped file(s) in a collection
			var tracks:ArrayCollection = new ArrayCollection();
			
			for each (var file:File in event.droppedFiles) {
				var track:TrackData = new TrackData();
				track.asset_data = file;
				track.title = file.name;
				tracks.addItem(track);
			}
			
			// add tracks to model
			model.trackCollection.addAll(tracks);
			
			// switch view to main window
			windowController.openMainWindow();
			
			// initiate upload
			apiController.uploadTracks();
		}
	}
}

