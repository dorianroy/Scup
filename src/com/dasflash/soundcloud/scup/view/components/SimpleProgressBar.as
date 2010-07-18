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

package com.dasflash.soundcloud.scup.view.components
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;

	import spark.components.supportClasses.SkinnableComponent;


	/**
	 *  Dispatched when the maximum value changed.
	 */
	[Event(name="maximumChanged", type="flash.events.Event")]

	/**
	 *  Dispatched when the load completes.
	 *  @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]

	/**
	 *  Dispatched when an object's state changes from visible to invisible.
	 *  @eventType mx.events.FlexEvent.HIDE
	 */
	[Event(name="hide", type="mx.events.FlexEvent")]

	/**
	 *  Dispatched as content loads
	 *  @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]

	/**
	 *  Dispatched when the component becomes visible.
	 *  @eventType mx.events.FlexEvent.SHOW
	 */
	[Event(name="show", type="mx.events.FlexEvent")]

	/**
	 * Simple, skinnable version of the halo ProgressBar
	 * It has no label and always acts as in ProgressBar's "event" mode
	 * i.e. you have to set an object in the source parameter that
	 * dispatches progress events
	 */
	public class SimpleProgressBar extends SkinnableComponent
	{

		public function SimpleProgressBar()
		{
			super();
		}

		/**
		 *  @private
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();

			if (_source is IEventDispatcher) {
				addSourceListeners();

			} else {
				// the Loader object is not yet initialized properly,
				// as it is put on stage after the progressbar
				// so make it go thru the source re-setting in draw
				_source = null;
			}
		}

		//  minimum / maximum
		private var _minimum:Number = 0;

		/**
		 *  @private
		 *  Storage for the maximum property.
		 */
		private var _maximum:Number = 0;

		[Bindable("maximumChanged")]
		[Inspectable(category="General", defaultValue="0")]

		/**
		 *  Largest progress value for the ProgressBar. Read-only.
		 */
		public function get maximum():Number
		{
			return _maximum;
		}

		//  percentComplete
		[Bindable("progress")]

		/**
		 *  Percentage of process that is completed.The range is 0 to 100.
		 *  Use the <code>setProgress()</code> method to change the percentage.
		 */
		public function get percentComplete():Number
		{
			if (_value < _minimum || _maximum < _minimum)
				return 0;

			// Avoid divide by zero fault.
			if ((_maximum - _minimum) == 0)
				return 0;

			var perc:Number = 100 * (_value - _minimum) / (_maximum - _minimum);

			if (isNaN(perc) || perc < 0)
				return 0;
			else if (perc > 100)
				return 100;
			else
				return perc;
		}

		//  source property
		/**
		 *  @private
		 *  Storage for the source property.
		 */
		private var _source:Object;

		/**
		 *  @private
		 */

		[Bindable]
		[Inspectable(category="General")]

		/**
		 *  Refers to the control that the ProgressBar is measuring the progress of
		 */
		public function get source():Object
		{
			return _source;
		}

		/**
		 *  @private
		 */
		public function set source(value:Object):void
		{
			if (_source && _source is IEventDispatcher)
				removeSourceListeners();

			if (value) {
				_source = value;
				invalidateProperties();
				invalidateSkinState();
				invalidateDisplayList();
			} else if (_source != null) {
				_source = null;
				invalidateProperties();
				invalidateSkinState();
				invalidateDisplayList();
			}
		}

		/**
		 *  @private
		 */
		private function addSourceListeners():void
		{
			_source.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_source.addEventListener(Event.COMPLETE, completeHandler);
		}

		/**
		 *  @private
		 */
		private function removeSourceListeners():void
		{
			_source.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			_source.removeEventListener(Event.COMPLETE, completeHandler);
		}

		/**
		 *  @private
		 *  "progress" event handler for event mode
		 */
		private function progressHandler(event:ProgressEvent):void
		{
			setProgress(event.bytesLoaded, event.bytesTotal);
		}

		/**
		 *  @private
		 *  "complete" event handler for event mode
		 */
		private function completeHandler(event:Event):void
		{
			dispatchEvent(event);
			invalidateDisplayList();
		}

		/**
		 *  @private
		 *  Changes the value and the maximum properties.
		 */
		private function setProgress(loaded:Number, total:Number):void
		{
			if (enabled && !isNaN(loaded) && !isNaN(total)) {
				if (_maximum != total) {
					_maximum = total;
					dispatchEvent(new Event("maximumChanged"));
				}

				_value = loaded;

				// Dipatch an Event of type "change".
				dispatchEvent(new Event(Event.CHANGE));

				// Dispatch a Progress
				var progressEvent:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
				progressEvent.bytesLoaded = loaded;
				progressEvent.bytesTotal = total;
				dispatchEvent(progressEvent);

				invalidateDisplayList();
			}
		}

		//  value

		/**
		 *  @private
		 *  Storage for the value property.
		 */
		private var _value:Number = 0;

		[Bindable("change")]

		/**
		 *  Read-only property that contains the amount of progress
		 */
		public function get value():Number
		{
			return _value;
		}

	}
}
