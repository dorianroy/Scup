package com.dasflash.soundcloud.scup.controller
{
	import com.dasflash.soundcloud.scup.events.SpinnerEvent;
	import com.dasflash.soundcloud.scup.view.components.Spinner;

	import flash.events.EventDispatcher;

	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	import mx.managers.SystemManager;

	import spark.components.WindowedApplication;


	public class SpinnerController extends EventDispatcher
	{
		private var spinner:Spinner;

		[Mediate(event="showSpinner")]
		public function showSpinnerHandler(event:SpinnerEvent):void
		{
			if (!spinner) {
				spinner = PopUpManager.createPopUp(SystemManager.getSWFRoot(this), Spinner, true) as Spinner;
				spinner.alpha = 0.5;
				spinner.play();
				PopUpManager.centerPopUp(spinner);

				WindowedApplication(FlexGlobals.topLevelApplication).backgroundFrameRate = -1;
			}
		}

		[Mediate(event="hideSpinner")]
		public function hideSpinnerHandler(event:SpinnerEvent):void
		{
			if (spinner) {
				PopUpManager.removePopUp(spinner);
				spinner = null;
			}

			WindowedApplication(FlexGlobals.topLevelApplication).backgroundFrameRate = 1;
		}
	}
}