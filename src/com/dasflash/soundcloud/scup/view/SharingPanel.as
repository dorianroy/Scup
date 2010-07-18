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

package com.dasflash.soundcloud.scup.view
{
	import com.dasflash.soundcloud.scup.events.SetDataEvent;

	import mx.collections.ArrayCollection;
	import mx.states.State;

	import spark.components.supportClasses.SkinnableComponent;


	[SkinState("collapsed")]

	[SkinState("expanded")]


	[Bindable]
	public class SharingPanel extends SkinnableComponent
	{
		[Inject(source="setData.sharingTypes")]
		public var sharingTypes:ArrayCollection;

		[Inject(source="setData.selectedSharingIndex", twoWay="true")]
		public var selectedSharingIndex:int = 1;

		[Inject(source="setData.downloadable", twoWay="true")]
		public var downloadable:Boolean;

		[Inject(source="setData.streamable", twoWay="true")]
		public var streamable:Boolean;

		[Inject(source="setData.shared_to", twoWay="true")]
		public var sharedTo:String;

		[Inject(source="setData.allUploadsCompleted")]
		public var allUploadsCompleted:Boolean;


		public function SharingPanel()
		{
			super();

			states = [new State({name: "collapsed"}), new State({name: "expanded"})];
		}

		/**
		 * Overridden to sync skin state to component state
		 */
		override protected function getCurrentSkinState():String
		{
			return currentState;
		}

		/**
		 * Overridden to sync skin state to component state
		 */
		override protected function stateChanged(oldState:String, newState:String, recursive:Boolean):void
		{
			super.stateChanged(oldState, newState, recursive);

			invalidateSkinState();
		}

		public function saveSet():void
		{
			dispatchEvent(new SetDataEvent(SetDataEvent.SAVE_SET));
		}

		public function cancelSet():void
		{
			dispatchEvent(new SetDataEvent(SetDataEvent.CANCEL_SET));
		}

	}
}

