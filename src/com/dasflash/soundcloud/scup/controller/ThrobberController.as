package com.dasflash.soundcloud.scup.controller
{
	import com.dasflash.soundcloud.scup.events.ScupEvent;
	import com.dasflash.soundcloud.scup.view.Throbber;
	
	import flash.events.EventDispatcher;
	
	import mx.managers.PopUpManager;
	import mx.managers.SystemManager;
	
	public class ThrobberController extends EventDispatcher
	{
		// THROBBER
		private var throbber:Throbber;
		
		[Mediate(event="ScupEvent.SHOW_THROBBER")]
		public function showThrobberHandler(event:ScupEvent):void
		{
			if (!throbber) {
				throbber = PopUpManager.createPopUp(SystemManager.getSWFRoot(this), Throbber, true) as Throbber;
				throbber.play();
				PopUpManager.centerPopUp(throbber);
			}
		}
		
		[Mediate(event="ScupEvent.HIDE_THROBBER")]
		public function hideThrobberHandler(event:ScupEvent):void
		{
			if (throbber) {
				PopUpManager.removePopUp(throbber);
				throbber = null;
			}
		}
	}
}