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

package com.dasflash.soundcloud.scup.model
{
	import flash.events.EventDispatcher;

	import org.iotashan.oauth.OAuthToken;

	[Bindable]

	/**
	 * Stores data of the logged on SoundCloud user.
	 *
	 * @author Dorian Roy
	 */
	public class UserData extends EventDispatcher
	{

		/**
		 * The SoundCloud Id of the logged on user
		 */
		public var userId:uint;

		/**
		 * The SoundCloud username of the logged on user
		 */
		public var userName:String;

		/**
		 * Permalink URL of the SoundCloud home page of the logged on user
		 */
		public var profileURL:String;

	}
}