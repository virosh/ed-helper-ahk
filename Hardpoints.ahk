; This script will make the fliping trigger on your VIRPIL Constellation ALPHA grip to be used as a deploy/retract hardpoints toggle in Elite Dangerous game.
; The original script was written by Markus for his dual HOSAS setup and can be found on his GitHub repo: https://github.com/markus-i/AHK-EDToggle
; In order to run this or the original scripts you will need tha AHK JSON library downloaded in your scripts directory.
; You can download the JSON library from here: https://github.com/cocobelgica/AutoHotkey-JSON
; Since i used HOTAS and do not have second joystick flip trigger to be used for Combat/Analysis mode switch i have removed this part of the code.
; If you are using HOSAS and you need it - please use the original script.
; The original script also uses the flip trigger to enter Turret mode when you are in SRV. I use a separate button for that as i use the turret mode rarely.
; Because of that i added one additional configuration, so if you wish to switch to Turret mode in SRV just set the variable TurretMode to 1.
; Please note that in order for the script to work you need to set your Working dir, the correct path to ED Status.json, and the correct joystick number for yours.
; Currently it is setup to 3Joy1 as my joystick is reported as #3. You can use the Joystick Test script from AutoHotKey site to find the correct number of your joystick.
; Also you will need to set Deploy Hardpoints and Toggle SRV Turret (if you want to use the flip trigger for that) binding in ED to Ctrl+Shift+h.


#NoEnv                             ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn                              ; Enable warnings to assist with detecting common errors.
#SingleInstance force              ; Make sure only one instance of this script is running.
SendMode Input                     ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir G:\AHK\scripts       ; Set this to your scripts directory.
#Include JSON.ahk

;yes, all these need to be global
global StatusFilePath := "C:\Users\<USERNAME>\Saved Games\Frontier Developments\Elite Dangerous\Status.json" ; Set this to your ED Status.json.

global TurretMode	:= 0 ; Set this to 1 if you wish to switch to turret mode in SRV.
global oldEDFlags 	:= 0
global EDFlags		:= 0

global Docked 		:= 0
global Landed 		:= 0
global GearDown	 	:= 0
global ShieldsUp	:= 0
global Supercruise	:= 0
global FAOff		:= 0
global Hardpoints	:= 0
global InWing		:= 0
global LightsOn	 	:= 0
global CargoScoop	:= 0
global Silent		:= 0
global Scooping	 	:= 0
global SRV_Brake	:= 0
global SRV_Turret	:= 0
global SRV_TurrDn	:= 0
global SRV_Assist   := 0
global Masslocked   := 0
global FSDCharging  := 0
global FSDCooldown	:= 0
global LowFuel		:= 0
global OverHeating  := 0
global HasLatLon	:= 0
global IsInDanger	:= 0
global Interdicted	:= 0
global InMainShip	:= 0
global InFighter	:= 0
global InSRV		:= 0
global AnalysisMde  := 0
global NightVsn	 	:= 0
global AvgAltitude  := 0
global FsdJump		:= 0
global SRVHighBeam  := 0

; read out ED's Status.json and (for now) extract the flag bits. There's more useful information in that file,
; see https://elite-journal.readthedocs.io/en/latest/Status%20File/ - I just don't know what else I could/should use
GetEDStatus()
{
	FileRead, EDstring, % StatusFilePath
	EDStatus := JSON.load(EDstring)

	Docked 		:= EDStatus.Flags & 0x00000001
	Landed 		:= EDStatus.Flags & 0x00000002
	GearDown	:= EDStatus.Flags & 0x00000004
	ShieldsUp	:= EDStatus.Flags & 0x00000008
	Supercruise	:= EDStatus.Flags & 0x00000010
	FAOff		:= EDStatus.Flags & 0x00000020
	Hardpoints	:= EDStatus.Flags & 0x00000040
	InWing		:= EDStatus.Flags & 0x00000080
	LightsOn	:= EDStatus.Flags & 0x00000100
	CargoScoop	:= EDStatus.Flags & 0x00000200
	Silent		:= EDStatus.Flags & 0x00000400
	Scooping	:= EDStatus.Flags & 0x00000800
	SRV_Brake	:= EDStatus.Flags & 0x00001000
	SRV_Turret	:= EDStatus.Flags & 0x00002000
	SRV_TurrDn	:= EDStatus.Flags & 0x00004000
	SRV_Assist  := EDStatus.Flags & 0x00008000
	Masslocked  := EDStatus.Flags & 0x00010000
	FSDCharging := EDStatus.Flags & 0x00020000
	FSDCooldown	:= EDStatus.Flags & 0x00040000
	LowFuel		:= EDStatus.Flags & 0x00080000
	OverHeating := EDStatus.Flags & 0x00100000
	HasLatLon	:= EDStatus.Flags & 0x00200000
	IsInDanger	:= EDStatus.Flags & 0x00400000
	Interdicted	:= EDStatus.Flags & 0x00800000
	InMainShip	:= EDStatus.Flags & 0x01000000
	InFighter	:= EDStatus.Flags & 0x02000000
	InSRV		:= EDStatus.Flags & 0x04000000
	AnalysisMde := EDStatus.Flags & 0x08000000
	NightVsn	:= EDStatus.Flags & 0x10000000
	AvgAltitude := EDStatus.Flags & 0x20000000
	FsdJump		:= EDStatus.Flags & 0x40000000
	SRVHighBeam := EDStatus.Flags & 0x80000000
	
	EDFlags := EDStatus.Flags
}

; check the status and switch position for hardpoints and trigger ED if they don't match
checkHardpoints(flipstate)
{
	GetEDStatus()
	if( Docked )	; can't deploy hardpoints while docked
		return
	if( Landed )	; can't deploy hardpoints while landed
		return
	if( InFighter )	; can't retract hardpoints while in the fighter
		return
	if( TurretMode )
	{
		if( InSRV )		; SRV: flip switches between main view and turret view, hardpoints are always deployed
		{
			if( (!flipstate) && SRV_Turret )	; flip is down, turret is active -> ok
				return
			if( flipstate && (!SRV_Turret) )	; flip is up, turret is inactive -> ok
				return
			send ^H								; send toggle
			return
		}
	}
	if( InMainShip )	; in the ship (and not docked or landed), flip deploys/retracts hardpoints
	{
		if( (!flipstate) && Hardpoints )	; flip is down, hardpoints deployed -> ok
			return
		if( flipstate && (!Hardpoints) )	; flip is up, hardpoints retracted -> ok
			return
		send ^H								; send toggle
		return
	}
	return
}

;initialize: read out current flags and button states, send commands if they don't match
SetKeyDelay, 10, 20		; ED needs some delay between keys and some tangible duration. So far, these values work on my rig

^x::ExitApp ; This needs to be initialized before the loop or it will not work.

WinWaitActive, Elite - Dangerous (CLIENT) ; Wait until ED is started and initialize.
	GetEDStatus()
	oldEDFlags := EDFlags
	checkHardpoints(GetKeyState("3Joy1"))
	;MsgBox, % "EDFlags = " . EdFlags
	setTimer, WaitForStatusChange, 100			; start monitoring status.json for changes

;now run the loop

; 3joy1 is the flip switch on the right stick -> hardpoints
#IfWinActive Elite - Dangerous (CLIENT)
3Joy1::
	;MsgBox, 3Joy1 up
	checkHardpoints(1)
	setTimer, WaitForHardpointsDn, 20
	return

; flip is up -> poll status
WaitForHardpointsDn:
	if not WinActive("Elite - Dangerous (CLIENT)") ; ED client is not on focus, do nothing.
		return
	if (GetKeyState("3joy1"))	; trigger still up, do nothing
		return
	; flip trigger is down
	;MsgBox, 3joy1 dn
	checkHardpoints(0)
	setTimer, WaitForHardpointsDn, off
	return
	
; monitor status.json for change - since we're only checking the flags right now, I use the flags as cnage indicator
; may need to switch to include other indicators if necessary - timestamp only has a one second resolution	
WaitForStatusChange:
	if not WinActive("Elite - Dangerous (CLIENT)") ; ED client is not on focus, do nothing.
		return
	GetEDStatus()
	if( oldEDFlags == EDFlags )
		return						; nothing changed
	checkHardpoints(GetKeyState("3Joy1"))
	oldEDFlags := EDFlags
	return
