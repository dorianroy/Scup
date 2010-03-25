package com.dasflash.soundcloud.scup.view
{
	import spark.components.supportClasses.SkinnableComponent;


	[Bindable]
	public class StatusBar extends SkinnableComponent
	{
		[Inject(source="setData.allUploadsCompleted")]
		public var allUploadsCompleted:Boolean;
		
	}
}