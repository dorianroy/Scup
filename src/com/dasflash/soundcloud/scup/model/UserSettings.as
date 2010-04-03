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

