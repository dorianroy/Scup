// Copyright (c) 2007 Regents of the University of Minnesota.
// All rights reserved.
//
// Please email Reid Priedhorsky, reid@umn.edu, with comments or questions.
//
// NOTE: This particular file is licensed differently, as follows.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright notice,
//      this list of conditions and the following disclaimer.
//
//    * Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//
//    * Neither the name of the University of Minnesota nor the names of its
//      contributors may be used to endorse or promote products derived from
//      this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

package com.dasflash.soundcloud.scup.view {

   // This class implements a throbber.

   // Set DEGREES_PER_TICK to slightly less than 360/BALL_COUNT and you will
   // get an effect of the ring rotating slowly counterclockwise while balls
   // grow rapidly in turn clockwise. Set DEGREES_PER_TICK to a small positive
   // or negative number to get a less busy ring that rotates clockwise or
   // counterclockwise, respectively.

   // You can also get an interesting effect by removing the Timer
   // infrastructure and instead using callLater(this.tick) in tick(). This
   // results in a rather spastic throbber that behaves differently at
   // different times.

   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.utils.Timer;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;

   public class Throbber extends UIComponent {

      // *** Config

      protected static const TIMER_INTERVAL:Number = (1000.0/24);
      protected static const DEGREES_PER_TICK:int = 30;
      protected static const BALL_COUNT:int = 11;
      protected static const BALL_RADIUS_SMALL:Number = 2.5;
      protected static const BALL_RADIUS_LARGE:Number = 3.5;
      protected static const CIRCLE_RADIUS:int = 13;
      protected static const BALL_COLOR:int = 0xAAAAAA; 


      // *** Instance variables

      protected var timer:Timer;
      protected var sprite:Sprite;

      // *** Constructor

      public function Throbber()
      {
         this.timer = new Timer(TIMER_INTERVAL);
         this.timer.addEventListener(TimerEvent.TIMER, this.tick,
                                     false, 0, true);

         this.draw();
      }

      // *** Getters and setters

      override public function get measuredHeight() :Number
      {
         return 2 * (CIRCLE_RADIUS + BALL_RADIUS_LARGE);
      }

      override public function get measuredWidth() :Number
      {
         return height;
      }


      // *** Instance methods

      // Draw myself. The Sprite child is a hack because I couldn't get
      // Matrix.translate() to work, and I need to rotate around the center of
      // the object, not the upper left corner.
      protected function draw() :void
      {
         var i:int;
         var x:Number;
         var y:Number;
         var r:Number;
         var gr:Graphics;

         this.sprite = new Sprite();
         this.sprite.x = CIRCLE_RADIUS + BALL_RADIUS_LARGE;
         this.sprite.y = this.sprite.x;
         this.addChild(this.sprite);

         gr = this.sprite.graphics;

         gr.beginFill(BALL_COLOR);
         gr.drawCircle(CIRCLE_RADIUS, 0, BALL_RADIUS_LARGE);
         
         for (i = 1; i < BALL_COUNT; i++) {
            r = i * (2 * Math.PI / BALL_COUNT);
            x = Math.cos(r) * CIRCLE_RADIUS;
            y = Math.sin(r) * CIRCLE_RADIUS;
            gr.drawCircle(x, y, BALL_RADIUS_SMALL);
         }
      }

      public function play() :void
      {
         this.timer.start();
      }

      public function stop() :void
      {
         this.timer.stop();
      }

      protected function tick(ev:TimerEvent) :void
      {
         this.sprite.rotation += DEGREES_PER_TICK;
      }

   }
}
