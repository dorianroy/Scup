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
package com.dasflash.soundcloud.scup.events
{
	import flash.events.Event;


	public class AuthWindowEvent extends Event
	{

		public static const STATE_AUTH:String = "stateAuth";

		public static const STATE_AUTH_FAIL:String = "stateAuthFail";

		public static const STATE_USER_INVALID:String = "stateUserInvalid";

		public static const STATE_NO_CONNECTION:String = "stateNoConnection";

		public static const STATE_BUSY:String = "stateBusy";

		public static const HIDE_AUTH_WINDOW:String = "hideAuthWindow";

		public static const GOTO_AUTH_PAGE:String = "gotoAuthPage";



		public function AuthWindowEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new AuthWindowEvent(type, bubbles, cancelable);
		}
	}
}
