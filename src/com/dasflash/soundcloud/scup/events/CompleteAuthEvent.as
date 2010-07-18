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

	public class CompleteAuthEvent extends Event
	{

		public static const COMPLETE_AUTH:String = "completeAuth";

		public var verificationCode:String;


		public function CompleteAuthEvent(type:String, verificationCode:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);

			this.verificationCode = verificationCode;
		}

		override public function clone():Event
		{
			return new CompleteAuthEvent(type, verificationCode, bubbles, cancelable);
		}
	}
}