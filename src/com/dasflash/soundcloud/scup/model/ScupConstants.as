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

	public class ScupConstants
	{
		// You need to fill in the api key of your own app here
		public static const CONSUMER_KEY:String = "";
		public static const CONSUMER_SECRET:String = "";

		// number of simultaneous uploads
		// the first releases of Scup had this set to 2 but after
		// experiencing failed uploads I set it back to 1
		public static const CONCURRENT_UPLOADS:int = 1;
	}
}