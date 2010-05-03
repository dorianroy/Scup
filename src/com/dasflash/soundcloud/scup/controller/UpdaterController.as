package com.dasflash.soundcloud.scup.controller
{
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;

	import com.dasflash.soundcloud.scup.events.AppEvent;

	import flash.events.EventDispatcher;
	import flash.filesystem.File;


	public class UpdaterController extends EventDispatcher
	{

		public static const UPDATE_CONFIG_FILE:String = "app:/updateConfig.xml";

		protected var updater:ApplicationUpdaterUI;


		[Mediate(event="checkForUpdate")]
		public function checkForUpdate(event:AppEvent):void
		{
			// initialize updater gui
			updater = new ApplicationUpdaterUI();

			updater.addEventListener(UpdateEvent.INITIALIZED, onInitialized);

			updater.isCheckForUpdateVisible = false;

			// assign config file
			updater.configurationFile = new File(UPDATE_CONFIG_FILE);

			updater.initialize();
		}

		private function onInitialized(event:UpdateEvent):void
		{
			// check for updates
			updater.checkNow();
		}

	}
}

