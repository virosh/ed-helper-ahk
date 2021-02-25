# ED Helper
ED Helper is a small AHK ([AutoHotKey](https://www.autohotkey.com/)) script for starting 
[Elite Dangerous](https://www.elitedangerous.com/), [Elite Observatory](https://github.com/Xjph/EliteObservatory) and 
[ED Discovery](https://github.com/EDDiscovery/EDDiscovery) and fixing some joytick bindings.

## Installation and Setup
  * Download and install [AutoHotKey](https://www.autohotkey.com/).
  * Download `ED Helper.ahk` and `Hardpoints.ahk`.
  * Configure the scripts by adding the correct program paths and button bindings.
  * Download [JSON.ahk](https://github.com/cocobelgica/AutoHotkey-JSON) library if you want to use AHK-EDToggle or Hardpoints scripts.
  * Download and configure [AHK-EDToggle](https://github.com/markus-i/AHK-EDToggle) if you want to use it.
  * Download and configure [JoyFocus](https://github.com/RetroRodent/joyfocus) script if you want to use it.
  * Double click on the script to run it or use the AHK to compile it to an executable.

## Info
The script was created by me after upgrading my controls from X55 Rhino to VPC VIRPIL. 

The issue was that since i play using VR i have mapped some buttons to my X55 HOTAS in order to be able to create screenshots and start/stop nVIDIA Shadowplay if i want to make a video. 
However because VIRPIL hardware and software works in a different way, there is no way to remap the keys or bind them to a macros or a key combination. 
So i started looking for options, found [AutoHotKey](https://www.autohotkey.com/) and started experimenting to see will it work.

Fortunately for me - it did work and i also found that i can use it to script the starting of all additional tools i use to play ED. 
As a bonus i found the [JoyFocus](https://github.com/RetroRodent/joyfocus) script, which is prety useful if you play with joysticks and in VR as it makes sure that your game window is always on focus.

I also found the [AHK-EDToggle](https://github.com/markus-i/AHK-EDToggle) script which makes use of the flip trigger on ALPHA grips and binds it as a Hardpoints deploy/retract or/and Combat/Analysis mode switch.
The EDToggle script is probably more usefull for players with HOSAS (two joysticks) setup. However the flip trigger functionality for me is a very good addition so i modified the script a little to be 
used for one joystick. That's the new `Hardpoints.ahk` scrript.

## History

v1.0
  * Initial release
v1.1
  * Added support for [AHK-EDToggle](https://github.com/markus-i/AHK-EDToggle) integration.
  * Added `Hardpoints.ahk` script based on AHK-EDToggle.
  * Some small optimizations have been made.
  * Fixed typos and updated comments inside the scripts.
  