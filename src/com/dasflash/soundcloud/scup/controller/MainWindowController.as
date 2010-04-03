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