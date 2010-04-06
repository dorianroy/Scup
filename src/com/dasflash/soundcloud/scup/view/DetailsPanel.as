package com.dasflash.soundcloud.scup.view
{
	import flash.filesystem.File;

	import mx.collections.ArrayCollection;
	import mx.events.StateChangeEvent;
	import mx.states.State;

	import spark.components.supportClasses.SkinnableComponent;


	[SkinState("collapsed")]

	[SkinState("expanded")]


	[Bindable]
	public class DetailsPanel extends SkinnableComponent
	{
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

		[Inject(source="setData.playlistTypes", twoWay="true")]
		public var playlistTypes:ArrayCollection;

		[Inject(source="setData.selectedLicenseIndex", twoWay="true")]
		public var selectedLicenseIndex:int;


		public function DetailsPanel()
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

	}
}
