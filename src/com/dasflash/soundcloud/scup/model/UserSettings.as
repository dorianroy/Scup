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
	import com.dasflash.soundcloud.scup.events.AppEvent;
	import com.dasflash.soundcloud.scup.events.AuthWindowEvent;

	import flash.data.EncryptedLocalStore;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;

	import org.iotashan.oauth.OAuthToken;

	/**
	 * This class is actually a proxy that stores/reads user settings
	 * to/from AIR's EncryptedLocalStore
	 *
	 * It is planned to use Swiz's EncryptedLocalStorageBean as soon as it
	 * is officially released
	 */
	public class UserSettings
	{

		public function get accessToken():OAuthToken
		{
			var obj:Object = getObject("accessToken");
			var token:OAuthToken = obj && obj.key && obj.secret ? new OAuthToken(obj.key, obj.secret) : null;
			return token;

		/*var obj:Object = encryptedLocalStorage.getObject("accessToken");
		   var token:OAuthToken = obj && obj.key && obj.secret ? new OAuthToken(obj.key, obj.secret) : null;
		 return token;*/
			 //			return null;
		}

		public function set accessToken(token:OAuthToken):void
		{
			if (token) {
				setObject("accessToken", token);

			} else {
				removeItem("accessToken");
			}
		/*encryptedLocalStorage.setObject("accessToken", token);*/
		}

		protected function removeItem(name:String):void
		{
			EncryptedLocalStore.removeItem(name);
		}

		protected function getObject(name:String):Object
		{
			var ba:ByteArray = EncryptedLocalStore.getItem(name);
			if (ba != null)
				return ba.readObject();
			return null;
		}

		protected function setObject(name:String, o:Object, stronglyBound:Boolean=false):void
		{
			var ba:ByteArray = new ByteArray();
			ba.writeObject(o);
			EncryptedLocalStore.setItem(name, ba, stronglyBound);
		}
	}
}

