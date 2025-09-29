; =============== WpnCtrl_Do ===============
; Handles player controls for the currently active weapon.
WpnCtrl_Do:
	
	;
	; First, read out the current weapon's properties to a temporary area.
	; Curiously done here all the time rather than only when selecting a weapon,
	; but this way it does account for some edge cases (ie: start of the level).
	;
	ld   hl, Wpn_PropTbl	; HL = Property table
	ld   a, [wWpnId]		; BC = wWpnId * 4
	add  a
	add  a
	ld   b, $00
	ld   c, a
	add  hl, bc				; Index it
	ldi  a, [hl]			; Read out all of its 4 bytes
	ld   [wWpnColiBoxH], a
	ldi  a, [hl]
	ld   [wWpnColiBoxV], a
	ldi  a, [hl]
	ld   [wWpnShotCost], a
	ld   a, [hl]
	ld   [wWpnPierceLvl], a
	
	; Execute weapon-specific controls code
	ld   a, [wWpnId]
	rst  $00 ; DynJump
	dw WpnCtrl_Default       ; WPN_P
	dw WpnCtrl_RushCoil      ; WPN_RC
	dw WpnCtrl_RushMarine    ; WPN_RM
	dw WpnCtrl_RushJet       ; WPN_RJ
	dw WpnCtrl_TopSpin       ; WPN_TP
	dw WpnCtrl_AirShooter    ; WPN_AR
	dw WpnCtrl_LeafShield    ; WPN_WD
	dw WpnCtrl_MetalBlade    ; WPN_ME
	dw WpnCtrl_CrashBomb     ; WPN_CR
	dw WpnCtrl_NeedleCannon  ; WPN_NE
	dw WpnCtrl_HardKnuckle   ; WPN_HA
	dw WpnCtrl_MagnetMissile ; WPN_MG
	dw WpnCtrl_Sakugarne     ; WPN_SG

; =============== COMMON SUBROUTINES ===============

; =============== WpnCtrlS_End ===============
; Common actions to execute at the end of every weapon control code.
; All this does is handle timing for the player's shooting animation.
WpnCtrlS_End:
	; Don't do anything if the timer is already elapsed
	ld   a, [wPlShootTimer]
	or   a
	ret  z
	; Otherwise, decrement it
	dec  a						
	ld   [wPlShootTimer], a
	; If it elapsed now, reset wPlShootType.
	; This will cause Rockman to stop being in the shooting pose.
	ret  nz
	ld   [wPlShootType], a
	ret
	
; =============== WpnCtrlS_StartShootAnim ===============
; Starts the player's shooting animation.
WpnCtrlS_StartShootAnim:
	;
	; The shooting animation is the pose where Rockman holds his hand forward while shooting.
	; Depending on the weapon, different frames may be used (shooting or throwing), which
	; is set to wPlShootType and directly affects the sprite mapping used by the player.
	;
	; Note that this animation does *not* affect how often shots can be fired, as long
	; as we're under the on-screen shot limit, a new shot can always be fired.
	;
	
	; Regardless of the weapon, this animation always lasts $0C frames
	ld   a, $0C
	ld   [wPlShootTimer], a
	
	; Index the shoot animation type off Wpn_ShootTypeTbl
	; wPlShootType = Wpn_ShootTypeTbl[wWpnId]
	ld   hl, Wpn_ShootTypeTbl
	ld   a, [wWpnId]
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ld   [wPlShootType], a
	
	; Play shoot sound
	ld   c, SFX_LIGHT
	mPlaySFX
	ret
	
; =============== WEAPON FIRE CODE ===============
; Most weapons follow a similar pattern, this is detailed in WpnCtrl_Default.

