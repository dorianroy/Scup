package com.dasflash.soundcloud.scup.controller
{
	import com.dasflash.soundcloud.scup.events.CompleteAuthEvent;
	import com.dasflash.soundcloud.scup.events.DropWindowEvent;
	import com.dasflash.soundcloud.scup.model.SetData;
	import com.dasflash.soundcloud.scup.view.DropWindow;
	
	import flash.display.NativeWindow;
	import flash.display.NativeWindowType;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.core.FlexGlobals;
	
	import org.swizframework.core.IDispatcherAware;
	
	import spark.components.Window;
	import spark.components.WindowedApplication;

	public class WindowController implements IDispatcherAware
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
		
		[Inject]
		public var apiController:SoundcloudAPIController;
		
		/*[Autowire]
		public var setData:SetData;*/
		
		/**
		 * reference to the drop window instance
		 */
		protected var dropWindow:DropWindow;
		
		
		/**
		 * Opens the drop window and hides the main window
		 * @param state the state in which the drop window should be opened
		 */
		public function openDropWindow(state:String="dropPage"):void
		{
			// hide main window
			var mainWindow:NativeWindow = WindowedApplication(FlexGlobals.topLevelApplication).nativeWindow;
			mainWindow.visible = false;
			
			// if drop window is opened for the first time
			if (!dropWindow) {
				
				// create drop window
				dropWindow = new DropWindow();
				dropWindow.type = NativeWindowType.UTILITY;
				dropWindow.maximizable = false;
				dropWindow.open();
				
				// redirect events from window to Swiz framework
				redirectEvent(dropWindow, DropWindowEvent.DROP_FILE);
				redirectEvent(dropWindow, DropWindowEvent.OPEN_MAIN_WINDOW);
				redirectEvent(dropWindow, DropWindowEvent.OPEN_AUTH_PAGE);
				redirectEvent(dropWindow, DropWindowEvent.RESET_APP);
				redirectEvent(dropWindow, DropWindowEvent.SWITCH_USER);
				redirectEvent(dropWindow, CompleteAuthEvent.COMPLETE_AUTH);
				
				// add a listener to exit the app when closing the drop window
				dropWindow.addEventListener(Event.CLOSE, windowCloseHandler);
			}
			
			// TODO WORKAROUND: since swiz can't autowire into Window instances for now
			// we pass the setURL here
			/*if(state=="saveSetCompletePage"){
				dropWindow.setURL = setData.permalink;
			}*/
			
			// show drop window with the specified state
			dropWindow.currentState = state;
			dropWindow.visible = true;
		}
		
		/**
		 *  Shortcut method for opening the drop window in authentication state
		 */
		public function openAuthenticationWindow():void
		{
			openDropWindow("authStartPage");
		}
		
		/**
		 * Opens the main window and hides the drop window 
		 */
		[Mediate(event="openMainWindow")]
		public function openMainWindow():void
		{
			if (dropWindow) {
				dropWindow.visible = false;
			}
			
			var mainWindow:NativeWindow = WindowedApplication(FlexGlobals.topLevelApplication).nativeWindow;
			mainWindow.addEventListener(Event.CLOSE, windowCloseHandler);
			
			// make main window visible 
			WindowedApplication(FlexGlobals.topLevelApplication).visible = true;
		}
		
		/**
		 * Exits application on window close
		 * 
		 * @param event
		 */
		protected function windowCloseHandler(event:Event):void
		{
			WindowedApplication(FlexGlobals.topLevelApplication).exit();
		}
		
		/**
		 * redirects event from a sub window to Swiz because Swiz cannot catch
		 * events from another the display list of other windows than the main one
		 * 
		 * @param window 
		 * @param eventType
		 */
		protected function redirectEvent(window:Window, eventType:String):void
		{
			window.addEventListener(eventType, dispatchSwizEvent);
		}
		
		protected function dispatchSwizEvent(event:Event):void
		{
			_dispatcher.dispatchEvent(event);
		}
		
	}
}

