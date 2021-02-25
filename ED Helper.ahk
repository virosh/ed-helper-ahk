; This AHK script will start EDdiscover, Elite Observatory and ED Launcher.
; It will create keybindings for VIRPIL MongoosT-50CM3 Throttle so you will be able to create screenshots and use nVIDIA Shadowplay in Elite Dangerous.
; It will also run (DISABLED by default) the JoyFocus, AHK-EDToggle and the Hardpoints Toggle scripts.
; The JoyFocus will make sure that your Elite Dangerous window is always on focus by watching your joystick axis for movements.
; The AHK-EDToggle script will add support for using the VIRPIL Constellation ALPHA flip trigger as a deploy/retract hardpoints and combat/analysis mode switch.
; Use the AHK-EDToggle if you are using two ALPHA joysticks setup.
; The Hardpoint Toggle is a customized version of the AHK-EDToggle script to be used with only one ALPHA joystick.
; All three scripts above needs separate configuration. If you want to use them - please review their configuration and update it accordingly.
; You can download the JoyFocus script from: https://github.com/RetroRodent/joyfocus
; You can download the AHK-EDToggle script from: https://github.com/markus-i/AHK-EDToggle
; This script will close itself and all child scripts once the Elite Dangerous game (not ED Launcher) is closed.

#NoEnv                      ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn                       ; Enable warnings to assist with detecting common errors.
SendMode Input              ; Recommended for new scripts due to its superior speed and reliability.
#Persistent
#SingleInstance force
StringCaseSense On
DetectHiddenWindows, On
SetTitleMatchMode, 2
	
; ---- USER DEFINED SETTINGS ----
SetWorkingDir C:\AHK\scripts  ; Set this to your scripts directory.

; Elite Observatory binary and working dir:
EO_bin := "C:\Users\<USERNAME>\AppData\Local\Elite Observatory\Observatory.exe"
EO_WD := "C:\Users\<USERNAME>\AppData\Local\Elite Observatory"

; EDDiscovery binary and working dir:
EDD_bin := "C:\Program Files\EDDiscovery\EDDiscovery.exe"
EDD_WD := "C:\Users\melkor\AppData\Local\EDDiscovery"

; Elite Dangerous Launcher binary and working dir:
EDL_bin := "E:\EDLaunch\EDLaunch.exe"
EDL_WD := "E:\EDLaunch"
; ---- END OF USER DEFINED SETTINGS ----

; The two functions below will manage the stopping of JoyFocus script once this script exits.
OnExit("KillScripts")
KillScripts(ExitReason, ExitCode)
{
	; Handle the joyfocus.ahk script.
	if WinExist("joyfocus")
		WinClose ; Try to exit gracefully.
	Sleep 1000 ; Wait for the window to close.
	if WinExist("joyfocus")
		WinKill ; If the above did not work - kill it.
	; Handle the readstatus.ahk script.
	if WinExist("readstatus")
		Send ^{x}
	; Handle the Hardpoints.ahk script.
	if WinExist("Hardpoints")
		Send ^{x}
	return
}

; Check and start the needed programs.
if FileExist(EO_bin)                         ; Check if the binary exist.
  if not WinExist("ahk_exe Observatory.exe") ; Check if it's already started.
    Run % EO_bin, % EO_WD                    ; If not - start it.
	
if FileExist(EDD_bin)                        ; Check if the binary exist.
  if not WinExist("ahk_exe EDDiscovery.exe") ; Check if it's already started.
    Run % EDD_bin, % EDD_WD                  ; If not - start it.
	
if not WinExist("ahk_exe EDLaunch.exe")      ; Check if it's already started.
  Run % EDL_bin, % EDL_WD                    ; If not - start it.

; Run the joyfocus script. Please note that this script require separate configuration!
; Remove the comment to enable this script only after downloading it in your scripts directory!
;Run joyfocus.ahk

; Run the readstatus script. Note that this script require separate configuration!
; Remove the comment to enable this script only after downloading it in your scripts directory!
;Run readstatus.ahk

; Run the hardpoints script. Note that this script require separate configuration!
;Run Hardpoints.ahk

; This will handle the clousure of this script once the Elite Dangerous game client is closed.
WinWaitActive, Elite - Dangerous (CLIENT)
  WinWaitClose, Elite - Dangerous (CLIENT)
    ExitApp
 
; Buttons mapping on My MongoosT-50CM3 Throttle at Mode 5:
; B1 = , B2 = . B3 = /
; B4 = F1 B5 = F2 B6 = F3
; Please note that your mappings will probably be different. You will need to find and use the correct ones.
; You will need to change the keys/combinations below according to your setup.
; Unfortunately this cannot be done with variables. Due to that it is not in the settings above.
SetKeyDelay, 10, 20  ; ED needs some delay between keys and some tangible duration. So far, these values work on my rig
#IfWinActive ahk_exe EliteDangerous64.exe
,::
Send {F10 down}{F10 up} ; Take a normal screenshot
return

#IfWinActive ahk_exe EliteDangerous64.exe
F1::
Send !{F10 down}!{F10 up} ; Hi-Res Screenshot
return

#IfWinActive ahk_exe EliteDangerous64.exe
.::
Send !{F9 down}!{F9 up} ; Start/Stop Video recording
return

#IfWinActive ahk_exe EliteDangerous64.exe
F2::
Send !{F11} ; Save the last 6 minutes
return
