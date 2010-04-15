package com.dasflash.soundcloud.scup.controller
{
	import com.dasflash.soundcloud.scup.events.AppEvent;
	import com.dasflash.soundcloud.scup.events.AuthWindowEvent;
	import com.dasflash.soundcloud.scup.events.CompleteAuthEvent;
	import com.dasflash.soundcloud.scup.events.MainWindowEvent;
	import com.dasflash.soundcloud.scup.model.SetData;
	import com.dasflash.soundcloud.scup.view.AuthWindow;
	
	import flash.display.NativeWindow;
	import flash.display.NativeWindowType;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.core.FlexGlobals;
	
	import org.swizframework.core.IDispatcherAware;
	
	import spark.components.Window;
	import spark.components.WindowedApplication;
	

	public class AuthWindowController implements IDispatcherAware
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
		
		/**
		 * reference to the drop window instance
		 */
		protected var authWindow:AuthWindow;
		
		
		/**
		 * Opens the drop window and hides the main window
		 * @param state the state in which the drop window should be opened
		 */
		public function openAuthWindow(state:String):void
		{
			// hide main window
			var mainWindow:NativeWindow = WindowedApplication(FlexGlobals.topLevelApplication).nativeWindow;
			mainWindow.visible = false;
			
			// if drop window is opened for the first time
			if (!authWindow) {
				
				// create drop window
				authWindow = new AuthWindow();
				authWindow.type = NativeWindowType.UTILITY;
				authWindow.maximizable = false;
				authWindow.open();
				
				// redirect events from window to Swiz framework
				
				redirectEvent(authWindow, MainWindowEvent.OPEN_MAIN_WINDOW);
				redirectEvent(authWindow, AuthWindowEvent.STATE_AUTH);
				redirectEvent(authWindow, AuthWindowEvent.STATE_NO_CONNECTION);
				redirectEvent(authWindow, AuthWindowEvent.GOTO_AUTH_PAGE);
				redirectEvent(authWindow, AppEvent.INIT_APP);
				redirectEvent(authWindow, AppEvent.RESET_APP);
				redirectEvent(authWindow, CompleteAuthEvent.COMPLETE_AUTH);
				
				// add a listener to exit the app when closing the drop window
				authWindow.addEventListener(Event.CLOSE, windowCloseHandler);
			}
			
			// show drop window with the specified state
			authWindow.currentState = state;
			authWindow.visible = true;
		}
		
		/**
		 * Shortcut method for opening the drop window in a state
		 * according to the event type
		 */
		[Mediate(event="stateAuth")]
		[Mediate(event="stateAuthFail")]
		[Mediate(event="stateNoConnection")]
		[Mediate(event="stateUserInvalid")]
		[Mediate(event="stateBusy")]
		public function openAuthenticationWindow(event:AuthWindowEvent):void
		{
			openAuthWindow(event.type);
		}
		
		/**
		 * Hides the AuthWindow.
		 */
		[Mediate(event="hideAuthWindow")]
		public function hideAuthWindow(event:AuthWindowEvent):void
		{
			if (authWindow) {
				authWindow.visible = false;
			}
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
		 * Redirects event from a sub window to Swiz because Swiz cannot catch
		 * events from other windows than the main one at the time of this writing.
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

