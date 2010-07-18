/*

   Copyright 2010 (c) Dorian Roy - dorianroy.com

   This file is part of Scup.

   Scup is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Scup is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Scup. If not, see <http://www.gnu.org/licenses/>.

 */
package com.dasflash.soundcloud.scup.controller
{
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;

	import com.dasflash.soundcloud.scup.events.AppEvent;

	import flash.events.EventDispatcher;
	import flash.filesystem.File;


	public class UpdaterController extends EventDispatcher
	{
		// this config file is not published, you have to roll your own to
		// point to your update server. See docs for air.update.ApplicationUpdaterUI
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

