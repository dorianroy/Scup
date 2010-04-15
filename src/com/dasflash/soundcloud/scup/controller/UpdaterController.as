package com.dasflash.soundcloud.scup.controller
{
	import air.update.ApplicationUpdaterUI;

	import com.dasflash.soundcloud.scup.events.AppEvent;

	import flash.events.EventDispatcher;
	import flash.filesystem.File;


	public class UpdaterController extends EventDispatcher
	{

		public static const UPDATE_CONFIG_FILE:String = "app:/updateConfig.xml";


		[Mediate(event="checkForUpdate")]
		public function checkForUpdate(event:AppEvent):void
		{
			// initialize updater gui
			var updater:ApplicationUpdaterUI = new ApplicationUpdaterUI();

			// assign config file
			updater.configurationFile = new File(UPDATE_CONFIG_FILE);

			// check for updates
			updater.checkNow();
		}

	}
}

