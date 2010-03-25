package com.dasflash.soundcloud.scup.view.skins
{

	import flash.display.Graphics;
	import mx.skins.ProgrammaticSkin;

	/**
	 *  The Spark skin for the mask of the Halo ProgressBar component's determinate and indeterminate bars.
	 *  The mask defines the area in which the progress bar or 
	 *  indeterminate progress bar is displayed.
	 *  By default, the mask defines the progress bar to be inset 1 pixel from the track.
	 *
	 *  @see mx.controls.ProgressBar
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class ProgressBarMaskSkin extends ProgrammaticSkin
	{        
	     //--------------------------------------------------------------------------
	    //
	    //  Overridden methods
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     *  @private
	     */        
	    override protected function updateDisplayList(w:Number, h:Number):void
	    {
	        super.updateDisplayList(w, h);
	
	        // draw the mask
	        var g:Graphics = graphics;
	        g.clear();
	        g.beginFill(0xFFFF00);
	        g.drawRect(0, 0, w, h);
	        g.endFill();
	    }
	
	
	}

}       
