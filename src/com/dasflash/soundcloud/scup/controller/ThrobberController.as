package com.dasflash.soundcloud.scup.controller
{
	import com.dasflash.soundcloud.scup.events.ThrobberEvent;
	import com.dasflash.soundcloud.scup.view.components.Throbber;

	import flash.events.EventDispatcher;

	import mx.managers.PopUpManager;
	import mx.managers.SystemManager;


	public class ThrobberController extends EventDispatcher
	{
		// THROBBER
		private var throbber:Throbber;

		[Mediate(event="showThrobber")]
		public function showThrobberHandler(event:ThrobberEvent):void
		{
			if (!throbber) {
				throbber = PopUpManager.createPopUp(SystemManager.getSWFRoot(this), Throbber, true) as Throbber;
				throbber.play();
				PopUpManager.centerPopUp(throbber);
			}
		}

		[Mediate(event="hideThrobber")]
		public function hideThrobberHandler(event:ThrobberEvent):void
		{
			if (throbber) {
				PopUpManager.removePopUp(throbber);
				throbber = null;
			}
		}
	}
}