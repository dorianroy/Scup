package com.dasflash.soundcloud.scup.controller
{
	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;
	
	/**
	 * Handles storing the access token in AIR's EncryptedLocalStore
	 * within the users local data
	 */
	public class EncryptedLocalStorageController
	{
		
		public function removeItem(name:String):void
		{
			EncryptedLocalStore.removeItem(name);
		}
		
		public function getObject(name:String):Object {
			var ba:ByteArray = EncryptedLocalStore.getItem(name);
			if (ba != null)
				return ba.readObject();
			return null;
		}
		
		public function setObject(name:String, o:Object, stronglyBound:Boolean = false) : void {
			var ba:ByteArray = new ByteArray();
			ba.writeObject(o);
			EncryptedLocalStore.setItem(name, ba, stronglyBound);
		}
	}
}

