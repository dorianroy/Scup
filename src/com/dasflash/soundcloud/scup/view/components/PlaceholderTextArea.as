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
	import flash.events.FocusEvent;

	import spark.components.Label;
	import spark.components.TextArea;

	/**
	 * TextArea component with a HTML5-like placeholder text
	 *
	 * @author Dorian Roy
	 *
	 */
	public class PlaceholderTextArea extends TextArea
	{

		[Bindable]
		/**
		 * A string that will be displayed when the text field
		 * has no text entered and is not focussed
		 */
		public var placeholder:String;

		[SkinPart(required="false")]
		/**
		 * @private
		 */
		public var placeholderDisplay:Label;


		/**
		 * @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);

			if (instance == placeholderDisplay) {

				placeholderDisplay.visible = !text && placeholder;
			}
		}

		/**
		 * @private
		 */
		override protected function focusInHandler(event:FocusEvent):void
		{
			super.focusInHandler(event);

			if (placeholderDisplay)
				placeholderDisplay.visible = false;
		}

		/**
		 * @private
		 */
		override protected function focusOutHandler(event:FocusEvent):void
		{
			super.focusOutHandler(event);

			if (placeholderDisplay)
				placeholderDisplay.visible = !text && placeholder;
		}

		/**
		 * @copy spark.components.TextInput#text
		 */
		override public function set text(value:String):void
		{
			super.text = value;

			if (placeholderDisplay && !isOurFocus(textDisplay)) {
				placeholderDisplay.visible = !text && placeholder;
			}
		}
	}
}

