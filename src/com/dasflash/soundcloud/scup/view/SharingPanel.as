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

