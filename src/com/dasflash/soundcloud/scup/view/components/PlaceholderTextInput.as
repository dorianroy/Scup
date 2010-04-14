package com.dasflash.soundcloud.scup.view.components
{
	import flash.events.FocusEvent;

	import spark.components.Label;
	import spark.components.TextInput;


	/**
	 * TextInput component with a HTML5-like placeholder text
	 *
	 * @author Dorian Roy
	 *
	 */
	public class PlaceholderTextInput extends TextInput
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
