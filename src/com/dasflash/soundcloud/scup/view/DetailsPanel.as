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
	import com.dasflash.soundcloud.scup.model.SetData;

	import flash.filesystem.File;

	import mx.collections.ArrayCollection;
	import mx.events.StateChangeEvent;
	import mx.states.State;

	import spark.components.supportClasses.SkinnableComponent;


	[Event(name="copyToTracks", type="com.dasflash.soundcloud.scup.events.SetDataEvent")]


	[SkinState("collapsed")]

	[SkinState("expanded")]


	[Bindable]
	public class DetailsPanel extends SkinnableComponent
	{

		[Inject]
		public var setData:SetData;

		[Inject(source="setData.title", twoWay="true")]
		public var title:String;

		[Inject(source="setData.description", twoWay="true")]
		public var description:String;

		[Inject(source="setData.artwork_data", twoWay="true")]
		public var artwork_data:File;

		[Inject(source="setData.genre", twoWay="true")]
		public var genre:String;

		[Inject(source="setData.tag_list", twoWay="true")]
		public var tag_list:String;

		[Inject(source="setData.purchase_url", twoWay="true")]
		public var purchase_url:String;

		[Inject(source="setData.label_name", twoWay="true")]
		public var label_name:String;

		[Inject(source="setData.release", twoWay="true")]
		public var release:String;

		[Inject(source="setData.release_day", twoWay="true")]
		public var release_day:int;

		[Inject(source="setData.release_month", twoWay="true")]
		public var release_month:int;

		[Inject(source="setData.release_year", twoWay="true")]
		public var release_year:int;

		[Inject(source="setData.ean", twoWay="true")]
		public var ean:String;

		[Inject(source="setData.selectedPlaylistTypeIndex", twoWay="true")]
		public var selectedPlaylistTypeIndex:int;

		[Inject(source="setData.playlistTypes")]
		public var playlistTypes:ArrayCollection;

		[Inject(source="setData.selectedTrackTypeIndex", twoWay="true")]
		public var selectedTrackTypeIndex:int;

		//[Inject(source="setData.trackTypes")]
		//public var trackTypes:ArrayCollection;

		[Inject(source="setData.selectedLicenseIndex", twoWay="true")]
		public var selectedLicenseIndex:int;


		public function DetailsPanel()
		{
			super();

			states = [new State({name: "collapsed"}), new State({name: "expanded"})];
		}

		public function copyToTracks():void
		{
			dispatchEvent(new SetDataEvent(SetDataEvent.COPY_TO_TRACKS))
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

	}
}
