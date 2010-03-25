package com.dasflash.soundcloud.scup.events
{
	import com.dasflash.soundcloud.scup.model.TrackData;
	
	import flash.events.Event;
	
	public class TrackListEvent extends Event
	{
		public static const RETRY_TRACK:String = "retryTrack";
		
		public static const DELETE_TRACK:String = "deleteTrack";
		
		public var trackData:TrackData;
		
		
		public function TrackListEvent(type:String, trackData:TrackData, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.trackData = trackData;
			
		}
		
		override public function clone():Event
		{
			return new TrackListEvent(type, trackData, bubbles, cancelable);
		}
	}
}