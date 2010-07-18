
*** SCUP SOUNDCLOUD UPLOADER ***

[![Flattr this](http://api.flattr.com/button/button-compact-static-100x17.png)](http://flattr.com/thing/2620/Scup-The-SoundCloud-Uploader)

Scup is a little AIR program that allows you to upload tracks to
SoundCloud from your desktop. You can get the current release 
version at http://scup.dasflash.com

I created Scup to demo the SoundCloud-AS3-API and play around with 
Flex 4 Spark components and the Swiz Framework. Feel free to do the same
with this code. However, if you want to use it in your own project, you
have to comply with the GNU license, especially publish your code 
under the same license.


*** License ***

Copyright 2010 (c) Dorian Roy

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


*** Setup instructions ***

In order to compile and run it, you'll need:

- Flash Builder 4 or another IDE that supports AIR and Flex 4 SDK

- The Soundcloud-AS3-API library
  http://github.com/dasflash/Soundcloud-AS3-API
  
- The Swiz Framework library
  http://github.com/swiz/swiz-framework
  
- Register your app at http://soundcloud.com/you/apps/new
  to get a API key which you need to enter in
  com.dasflash.soundcloud.scup.model.ScupConstants.as
   
- In case you want to use the auto-update feature: set up a directory
  on a server to host your update files and put a updateConfig.xml
  file in the project root that points to your update URL. See Adobe's
  docs for details.
  
  
*** Feedback ***

Please use github's issues management if you encounter any bugs in
the code. For user feedback and feature requests, please use the
feedback forum at http://getsatisfaction.com/scup/

For everything else, feel free to contact me at dori[at]nroy[dot]de
or via twitter.com/dorianroy

Read more about Scup and the Soundcloud-AS3-API here:
* dasflash.com
* twitter.com/dasflash

