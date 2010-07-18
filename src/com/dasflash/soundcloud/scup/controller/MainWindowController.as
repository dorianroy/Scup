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
	import flash.display.NativeWindow;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.core.FlexGlobals;
	
	import org.swizframework.core.IDispatcherAware;
	
	import spark.components.WindowedApplication;
	
	
	public class MainWindowController implements IDispatcherAware
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
		
		/**
		 * Opens the main window.
		 */
		[Mediate(event="openMainWindow")]
		public function openMainWindow():void
		{
			var mainWindow:NativeWindow = WindowedApplication(FlexGlobals.topLevelApplication).nativeWindow;
			
			mainWindow.addEventListener(Event.CLOSE, windowCloseHandler);
			
			// make main window visible 
			WindowedApplication(FlexGlobals.topLevelApplication).visible = true;
		}
		
		/**
		 * Exits application on window close.
		 * 
		 * @param event
		 */
		protected function windowCloseHandler(event:Event):void
		{
			WindowedApplication(FlexGlobals.topLevelApplication).exit();
		}
	}
}