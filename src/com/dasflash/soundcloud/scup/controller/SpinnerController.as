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