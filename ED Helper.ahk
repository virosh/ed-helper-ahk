; This AHK script will start EDdiscover, Elite Observatory and ED Launcher.
; It will create keybindings for VIRPIL MongoosT-50CM3 Throttle so you will be able to create screenshots and use nVIDIA Shadowplay in Elite Dangerous.
; It will also include and load (DISABLED by default) the joyfocus AHK script which will focus the window to Elite Dangerous when you move a certain joystick axis.
; If you wish to use the joyfocus script you will need to download it from: https://github.com/RetroRodent/joyfocus
; You will also find more info on their GitHub repo.
; This script will close itself and the JoyFocus script once the Elite Dangerous game (not ED Launcher) is closed.

#Persistent
#SingleInstance force
StringCaseSense On

; ---- USER DEFINED SETTINGS ----

; Elite Observatory binary and working dir:
EO_bin := "C:\Users\<USERNAME>\AppData\Local\Elite Observatory\Observatory.exe"
EO_WD := "C:\Users\<USERNAME>\AppData\Local\Elite Observatory"

; EDDiscovery binary and working dir:
EDD_bin := "C:\Program Files\EDDiscovery\EDDiscovery.exe"
EDD_WD := "C:\Users\<USERNAME>\AppData\Local\EDDiscovery"

; Elite Dangerous Launcher binary and working dir:
EDL_bin := "E:\EDLaunch\EDLaunch.exe"
EDL_WD := "E:\EDLaunch"

; ---- END OF USER DEFINED SETTINGS ----

; The two functions below will manage the stopping of JoyFocus script once this script exits.
OnExit("KillJoy")
KillJoy(ExitReason, ExitCode)
{
	DetectHiddenWindows, On
	SetTitleMatchMode, 2

	if WinExist("joyfocus")
        WinClose ; Try to exit gracefully.
	
	Sleep 1000 ; Wait for the window to close.
	
	if WinExist("joyfocus")
        WinKill ; If the above did not work - kill it.
	return
}

; Check and start the needed programs.
if not WinExist("ahk_exe Observatory.exe")
  if FileExist(EO_bin)
    Run % EO_bin, % EO_WD
	
if not WinExist("ahk_exe EDDiscovery.exe")
  if FileExist(EDD_bin)
    Run % EDD_bin, % EDD_WD
	
if not WinExist("ahk_exe EDLaunch.exe")
  Run % EDL_bin, % EDL_WD

; Run the joyfocus script. Please note that this script may require separate configuration!
Run joyfocus.ahk

; This will handle the clouse of this script once the Elite Dangerous game client is closed.
WinWaitActive, Elite - Dangerous (CLIENT)
  WinWaitClose, Elite - Dangerous (CLIENT)
    ExitApp
 
; Buttons mapping on MongoosT-50CM3 Throttle at Mode 5:
; B1 = , B2 = . B3 = /
; B4 = F1 B5 = F2 B6 = F3
; You will need to change the keys/combinations below according to your setup.
; Unfortunately this cannot be done with variables. Due to that it is not in the settings above.
#IfWinActive ahk_exe EliteDangerous64.exe
,::
SetKeyDelay 50, 50
Send {F10 down}{F10 up} ; Take a normal screenshot
return

#IfWinActive ahk_exe EliteDangerous64.exe
F1::
SetKeyDelay 50, 50
Send !{F10 down}!{F10 up} ; Hi-Res Screenshot
return

#IfWinActive ahk_exe EliteDangerous64.exe
.::
SetKeyDelay 50, 50
Send !{F9 down}!{F9 up} ; Start/Stop Video recording
return

#IfWinActive ahk_exe EliteDangerous64.exe
F2::
SetKeyDelay 50, 50
Send !{F11} ; Save the last 6 minutes
return
