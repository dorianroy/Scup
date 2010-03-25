package com.dasflash.soundcloud.scup.controller
{
	import air.update.ApplicationUpdaterUI;
	
	import com.dasflash.soundcloud.scup.events.ScupEvent;
	
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	/**
	 * This command controls the auto update mechanism.
	 * 
	 * It uses Jens Krause's Custom ApplicationUpdater UI to get around 
	 * a bug in Flex 4 beta SDK
	 * @see http://www.websector.de/blog/2009/09/09/custom-applicationupdaterui-for-using-air-updater-framework-in-flex-4/
	 * 
	 * @author Dorian
	 */
	public class UpdaterController extends EventDispatcher
	{

		public static const UPDATE_CONFIG_FILE:String = "app:/updateConfig.xml";
		
		
		[Mediate(event="ScupEvent.CHECK_FOR_UPDATE")]
		public function checkForUpdate(event:ScupEvent):void
		{
			// initialize updater gui
			var updater: ApplicationUpdaterUI = new ApplicationUpdaterUI();
			
			// assign config file
			updater.configurationFile = new File(UPDATE_CONFIG_FILE);
			
			// check for updates
			updater.checkNow();
		}
		
	}
}

