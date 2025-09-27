; =============== Pl_DoWpnCtrl ===============
; Handles player controls for the currently active weapon.
Pl_DoWpnCtrl:
	
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
	ld   a, SFX_SHOOT
	ldh  [hSFXSet], a
	ret
	
; =============== WEAPON FIRE CODE ===============
; Most weapons follow a similar pattern, this is detailed in WpnCtrl_Default.

; =============== WpnCtrl_Default ===============
; The default weapon, a small shot that travels forward.
; Items such as Rush Coil reuse this for actual player shots.
WpnCtrl_Default:
	; Keep track of the weapon unlock bit for this shot. 
	; This value is only ever written to though.
	xor  a
	ld   [wWpnUnlockMask], a
	
	; If the player isn't pressing B, just exit (only process the shooting animation, if one is set)
	ldh  a, [hJoyNewKeys]
	bit  KEYB_B, a			; Pressed B?
	jp   z, WpnCtrlS_End	; If not, we're done
	
	; Otherwise, find a free slot to spawn a shot. At most 3 shots can be on screen.
	; There's no special weapon property marking the number of on-screen shots,
	; this is all handled by repeated checks.
	ld   hl, wShot0
	ld   a, [hl]
	or   a					; Is there an active shot in the first slot?
	jr   z, .spawn			; If not, spawn it here
	ld   hl, wShot1
	ld   a, [hl]
	or   a					; "" second slot?
	jr   z, .spawn			; If not, spawn it here
	ld   hl, wShot2
	ld   a, [hl]
	or   a					; "" third slot?
	jp   nz, WpnCtrlS_End	; If so, all three shots are on-screen, return
	
.spawn:
	ld   a, SHOT0_PROC|WPN_P ; Shot ID
	ld   c, SHOTSPR_P ; Sprite ID
	; Fall-through
	
; =============== WpnCtrlS_SpawnShotFwd ===============
; Spawns a projectile that (initially) moves forward, starting from the player's hands.
; IN
; - A: Shot ID
; - C: Sprite ID
; - HL: Ptr to shot slot
WpnCtrlS_SpawnShotFwd:
	; Set the shot ID, which determines the code to execute for it.
	ldi  [hl], a	; iShotId
	
	; Shot-specific timer
	xor  a
	ldi  [hl], a	; iShotWkTimer
	
	; To move forward, the shot needs to face the same direction as the player.
	ld   a, [wPlDirH]
	and  $01		; Filter out other bits
	ldi  [hl], a	; iShotDir
	
	;
	; Make the shot originate from the player's hands.
	; This point is in front of the player, vertically centered.
	;
	
	; HORIZONTAL OFFSET - 14px in front of the player
	; The +1 discrepancy when facing right is due to the player sprite being visually offset 1 pixel there.
	ld   b, -PLCOLI_H-$08	; B = 14px to the left
	or   a ; DIR_L		; Facing left?
	jr   z, .setShot3		; If so, skip
	ld   b, PLCOLI_H+$08+1	; B = 15px to the right
.setShot3:
	; Not deflected
	xor  a
	ldi  [hl], a		; iShotFlags
	
	; Set the X coordinate, offsetted by the previously calculated value
	ldi  [hl], a		; iActXSub
	ld   a, [wPlRelX]
	add  b				; + offset
	ldi  [hl], a		; iShotX
	
	; VERTICAL OFFSET - Middle of the player
	; It's not possible to shoot while sliding, so this can always point to 12px above the origin.
	xor  a
	ldi  [hl], a		; iShotYSub
	ld   a, [wPlRelY]	; From origin (bottom)
	sub  PLCOLI_V		; - v radius (middle)
	ldi  [hl], a		; iShotY
	
	; Set specified sprite mapping ID
	ld   [hl], c		; iShotSprId
	
	jr   WpnCtrlS_StartShootAnim
	
; =============== WpnCtrl_RushCoil ===============
; Rush Coil.
; This and other items have execution fall back to WpnCtrl_Default,
; which is what allows to fire normal shots while using items.
WpnCtrl_RushCoil:
	; Uses normal shot
	xor  a
	ld   [wWpnUnlockMask], a
	
	; When an item "weapon" is selected, firing a shot will try to spawn its respective helper actor if one is not active already.
	; In this case, it spawns, well, the Rush Coil.
	; All helper actors are spawned the same way, as they teleport in from the top of the screen in front of the player.
	ld   a, ACT_WPN_RC
	ld   [wActSpawnId], a
	call WpnCtrl_ChkSpawnHelper
	
	; Additionally, they also all allow firing normal shots.
	; This behaviour is separate from the helper actor spawning one, so pressing the B button to spawn one also fires a normal
	; shot at the same time.
	jp   WpnCtrl_Default
	
; =============== WpnCtrl_RushMarine ===============
; Rush Marine.
; Underwater version of Rush Jet.
WpnCtrl_RushMarine:
	xor  a
	ld   [wWpnUnlockMask], a
	ld   a, ACT_WPN_RM
	ld   [wActSpawnId], a
	call WpnCtrl_ChkSpawnHelper
	jp   WpnCtrl_Default
	
; =============== WpnCtrl_RushJet ===============
; Rush Jet.
; The broken free-roaming RM3 variant.
WpnCtrl_RushJet:
	xor  a
	ld   [wWpnUnlockMask], a
	ld   a, ACT_WPN_RJ
	ld   [wActSpawnId], a
	call WpnCtrl_ChkSpawnHelper
	jp   WpnCtrl_Default
	
; =============== WpnCtrl_Sakugarne ===============
; Sakugarne.
; Useless pogo stick.
WpnCtrl_Sakugarne:
	xor  a
	ld   [wWpnUnlockMask], a
	ld   a, ACT_WPN_SG
	ld   [wActSpawnId], a
	call WpnCtrl_ChkSpawnHelper
	
	; If the player isn't riding the Sakugarne yet, don't do anything special.
	ld   a, [wWpnSGRide]
	or   a
	jp   z, WpnCtrl_Default
	
	;
	; When riding it and moving downwards, make the bottom of the Sakugarne deal damage.
	; This is done by attaching an invisible weapon shot with an hysterically small hitbox.
	; 
	ld   hl, wShot3		; Special purpose shot
	
	; If the player isn't falling, don't deal damage.
	ld   a, [wPlMode]
	cp   PL_MODE_FALL	; Is the player falling?
	jr   z, .dmg		; If so, jump
.noDmg:
	xor  a				; Despawn the shot
	ld   [hl], a
	ret
.dmg:
	; Spawn the shot
	ld   a, SHOT0_PROC|WPN_SG
	ldi  [hl], a		; iShotId
	xor  a
	ldi  [hl], a ; iShotWkTimer
	ldi  [hl], a ; iShotDir
	ldi  [hl], a ; iShotFlags
	
	; Centered to the player
	; XPos = PlX
	ldi  [hl], a ; iShotXSub
	ld   a, [wPlRelX]
	ldi  [hl], a ; iShotX
	
	; 4 pixels below the player
	; XPos = PlY + 4
	xor  a
	ldi  [hl], a ; iShotYSub
	ld   a, [wPlRelY]
	add  $04
	ldi  [hl], a ; iShotY
	
	; Use an invisible sprite
	ld   a, SHOTSPR_SG
	ldi  [hl], a ; iShotSprId
	
	; [POI] These are never used
	xor  a
	ldi  [hl], a ; iShot9
	ldi  [hl], a ; iShotA
	ldi  [hl], a ; iShotB
	ld   [hl], a ; iShotRealEnd
	ret
	
; =============== WpnCtrl_ChkSpawnHelper ===============
; Tries to spawn an item helper actor. (Rush, Sakugarne)
; IN
; - wActSpawnId: Actor ID
WpnCtrl_ChkSpawnHelper:
	; If there's not enough ammo to jump on Rush Coil, don't even bother calling him in
	call WpnS_HasAmmoForShot
	ret  c
	
	; If we didn't press B to call in Rush/Sakugarne, there's nothing to spawn
	ldh  a, [hJoyNewKeys]
	bit  KEYB_B, a
	ret  z
	
	; Don't spawn it if one is already active.
	; (this includes different helpers when teleporting out)
	ld   a, [wWpnHelperWarpRtn]
	or   a ; AHW_NONE
	ret  nz
	
	;
	; Passed the checks.
	; Spawn the actor from the top of the screen, as they teleport in to the player's vertical position.
	;
	
	xor  a					; Not part of the actor layout
	ld   [wActSpawnLayoutPtr], a
	
	; Spawn immediately offscreen above
	ld   a, OBJ_OFFSET_Y-1	; 1 pixel above the edge of the screen
	ld   [wActSpawnY], a
	
	; Spawn 24 pixels in front of the player
	ld   b, $18				; B = 24px to the right
	ld   a, [wPlDirH]
	and  DIR_R			; Facing right?
	jr   nz, .setX			; If so, skip
	ld   b, $E8				; B = 24px to the left
.setX:
	ld   a, [wPlRelX]		; XPos = PlX + B
	add  b
	ld   [wActSpawnX], a
	
	call ActS_Spawn			; Did it spawn?
	ret  c					; If not, return
	ld   a, AHW_WARPIN_INIT	; Otherwise, flag that an helper is onscreen, so no more can spawn
	ld   [wWpnHelperWarpRtn], a
	ret
	
; =============== WpnCtrl_TopSpin ===============
; Top Spin.
; Melee weapon activated in the air.
WpnCtrl_TopSpin:
	ld   a, WPU_TP
	ld   [wWpnUnlockMask], a
	
	; Top Spin is activated by pressing B in the air.
	; It will then stay active for the remainder of the jump.
	ldh  a, [hJoyNewKeys]
	bit  KEYB_B, a				; Pressed B?
	jp   z, WpnCtrlS_End			; If not, return
	
	; Only allowed when the player is in the air ($01-$03)
	; (PL_MODE_JUMP, PL_MODE_FULLJUMP, PL_MODE_FALL)
	ld   a, [wPlMode]
	or   a ; PL_MODE_GROUND	; wPlMode == $00?
	jp   z, WpnCtrlS_End		; If so, return
	cp   PL_MODE_FALL+1		; wPlMode >= $04?
	jp   nc, WpnCtrlS_End	; If so, return
	
	; If it's already active, don't reactivate it
	ld   a, [wWpnTpActive]
	or   a
	jp   nz, WpnCtrlS_End
	
	; If there isn't enough ammo to use it, don't do it either.
	; Note that Top Spin only uses up ammo on contact, not on activation.
	call WpnS_HasAmmoForShot
	jp   c, WpnCtrlS_End
	
	;
	; If we got here, we can activate Top Spin.
	; This will visually cause Rockman to spin, and his whole body will deal damage to enemies weak to it.
	;
	; What *actually* happens is that the player sprite is hidden and a weapon shot is spawned
	; to the player's location, which has a sprite showing the player spinning, will track the
	; player's position on its own, and is the part that deals damage.
	;
	ld   hl, wShot0					; Fixed slot
	ld   a, SHOT0_PROC|WPN_TP
	ld   [wWpnTpActive], a			; Enable Top Spin mode, which hides the normal player sprite
	ldi  [hl], a ; iShotId
	xor  a
	ldi  [hl], a ; iShotWkTimer
	
	; Face same direction as player
	ld   a, [wPlDirH]
	and  DIR_R
	ldi  [hl], a ; iShotDir
	
	; Not deflected
	xor  a
	ldi  [hl], a ; iShotFlags
	
	; XPos: PlX
	inc  hl ; iShotXSub
	ld   a, [wPlRelX]
	ldi  [hl], a ; iShotX
	
	; YPos: PlY - 8
	inc  hl ; iShotYSub
	ld   a, [wPlRelY]
	sub  $08
	ldi  [hl], a ; iShotY
	
	; Set initial Top Spin sprite
	ld   a, SHOTSPR_TP0
	ld   [hl], a ; iShotSprId
	
	jp   WpnCtrlS_StartShootAnim
	
; =============== WpnCtrl_AirShooter ===============
; Air Shooter.
; Spreadshot made up of 3 whirlwinds, travels diagonally up.
WpnCtrl_AirShooter:
	ld   a, WPU_AR
	ld   [wWpnUnlockMask], a
	
	; Shoot on B
	ldh  a, [hJoyNewKeys]
	bit  KEYB_B, a
	jp   z, WpnCtrlS_End
	
	; All of the three individual shots must be despawned.
	; This gives a real limit of 1 shot onscreen.
	ld   hl, wShot0
	ld   a, [hl]
	ld   hl, wShot1
	or   [hl]
	ld   hl, wShot2
	or   [hl]
	jp   nz, WpnCtrlS_End
	
	; Use up ammo, if there isn't enough don't spawn any shots
	call WpnS_UseAmmo
	jp   c, WpnCtrlS_End
	
	;
	; Spawn the three shots in a loop.
	;
	ld   c, $03			; C = Shots left
	ld   hl, wShot0		; HL = From the first slot
.loop:
	ld   a, SHOT0_PROC|WPN_AR
	ldi  [hl], a ; iShotId
	
	; Set the shot number, needed to help distinguish between the three as each travels at its own speed. 
	ld   a, c
	ldi  [hl], a ; iShotWkTimer
	
	ld   a, [wPlDirH]
	and  DIR_R	; A = Shot direction
	ldi  [hl], a ; iShotDir
	
	; Spawn 14 pixels in front of the player
	ld   b, -$0E		; B = 14px to the left
	or   a				; Facing right?
	jr   z, .setX		; If not, jump
	ld   b, $0E+1		; B = 14px to the right
.setX:
	; Not deflected
	xor  a
	ldi  [hl], a ; iShotFlags
	
	; Set X position
	ldi  [hl], a ; iShotXSub
	ld   a, [wPlRelX]
	add  b
	ldi  [hl], a ; iShotX
	
	; Spawn 13 pixels above the player
	xor  a
	ldi  [hl], a ; iShotYSub
	ld   a, [wPlRelY]
	sub  $0B
	ldi  [hl], a ; iShotY
	
	; Set sprite
	ld   [hl], SHOTSPR_AR0 ; iShotSprId
	
	; Seek to next slot
	ld   a, l
	and  $F0		; Seek back to iShotId
	add  iShotEnd	; Next slot
	ld   l, a
	
	dec  c			; Done spawning all shots?
	jr   nz, .loop	; If not, loop
	
	jp   WpnCtrlS_StartShootAnim
	
; =============== WpnCtrl_LeafShield ===============
; Leaf Shield.
; Four leaves that rotate around the player and can never be destroyed (but can be deflected).
WpnCtrl_LeafShield:
	ld   a, WPU_WD
	ld   [wWpnUnlockMask], a
	
	; Return if not pressing B
	ldh  a, [hJoyNewKeys]
	bit  KEYB_B, a
	jp   z, WpnCtrlS_End
	
	; Leaf Shield is made up of four leaves, each being its own individual shot.
	; This is necessary since each leaf can get deflected without affecting the others.
	; Only spawn a new shield if all of the leaves are despawned.
	ld   hl, wShot0
	ld   a, [hl]
	ld   hl, wShot1
	or   [hl]
	ld   hl, wShot2
	or   [hl]
	ld   hl, wShot3
	or   [hl]
	jp   nz, WpnCtrlS_End
	
	; Don't spawn if there isn't enough ammo
	call WpnS_HasAmmoForShot
	jp   c, WpnCtrlS_End
	
	; Use up ammo when throwing the shield
	ld   a, $01
	ld   [wWpnWdUseAmmoOnThrow], a
	
	;
	; Spawn the four leaves.
	;
	ld   c, $04			; C = Leaves left
	ld   hl, wShot0		; From the first slot...
.loop:
	ld   a, SHOT0_PROC|WPN_WD
	ldi  [hl], a ; iShotId
	
	; iShotWkTimer = C - 1
	ld   a, c
	dec  a
	ldi  [hl], a ; iShotWkTimer
	
	; Direction is irrelevant until the shield is thrown
	inc  hl ; iShotDir
	
	; Not deflected
	xor  a
	ldi  [hl], a ; iShotFlags
	
	; Place the shield at the center of the player
	ldi  [hl], a ; iShotX
	ld   a, [wPlRelX]
	ldi  [hl], a ; iShotX
	xor  a
	ldi  [hl], a ; iShotYSub
	ld   a, [wPlRelY]
	sub  PLCOLI_V-1
	ldi  [hl], a ; iShotY
	
	; Set sprite
	ld   [hl], SHOTSPR_WD ; iShotSprId
	
	; Seek to next slot
	ld   a, l
	and  $F0
	add  iShotEnd
	ld   l, a
	
	dec  c			; Spawned all leaves?
	jr   nz, .loop	; If not, loop
	jp   WpnCtrlS_StartShootAnim
	
; =============== WpnCtrl_MetalBlade ===============
; Metal Blade.
; 8-way buster replacement.
WpnCtrl_MetalBlade:
	ld   a, WPU_ME
	ld   [wWpnUnlockMask], a
	
	; Check for shoot button
	ldh  a, [hJoyNewKeys]
	bit  KEYB_B, a
	jp   z, WpnCtrlS_End
	
	; Max 3 shots on screen
	ld   hl, wShot0
	ld   a, [hl]
	or   a
	jr   z, .chkAmmo
	ld   hl, wShot1
	ld   a, [hl]
	or   a
	jr   z, .chkAmmo
	ld   hl, wShot2
	ld   a, [hl]
	or   a
	jp   nz, WpnCtrlS_End
	
.chkAmmo:
	; Use up ammo, if there isn't enough don't spawn the shot
	call WpnS_UseAmmo
	jp   c, WpnCtrlS_End
	
.spawn:
	; Spawn the Metal Blade projectile.
	ld   a, SHOT0_PROC|WPN_ME
	ldi  [hl], a ; iShotId
	
	xor  a
	ldi  [hl], a ; iShotWkTimer
	
	;
	; Metal Blades can be thrown in all 8 directions.
	; Check which one to set.
	;
	
	; If not holding any key, shoot forward like other weapons.
	; This also filters out non-directional keys for the detailed check.
	ldh  a, [hJoyKeys]
	and  KEY_DOWN|KEY_UP|KEY_LEFT|KEY_RIGHT	; Holding a directional key?
	jr   nz, .chkDirEx						; If so, jump
.chkDir:
	; Forward depends on the player's direction
	ld   a, [wPlDirH]	; C = wPlDirH & DIR_R
	and  DIR_R
	ld   c, a
	jr   .setDir
.chkDirEx:
	; Otherwise, perform the detailed check starting from diagonals.
	ld   c, DIR_DR			; C = DIR_DR
	cp   KEY_DOWN|KEY_RIGHT		; Holding Down-Right?
	jr   z, .dirFound			; If so, jump (key found)
	dec  c 						; C = DIR_DL
	cp   KEY_DOWN|KEY_LEFT		; ...
	jr   z, .dirFound
	dec  c						; C = DIR_UR
	cp   KEY_UP|KEY_RIGHT
	jr   z, .dirFound
	dec  c						; C = DIR_UL
	cp   KEY_UP|KEY_LEFT
	jr   z, .dirFound
	
	; Then all individual directions, bit by bit
	dec  c						; C = DIR_D
	rla  ; KEYB_DOWN			; Shift KEYB_DOWN into the carry
	jr   c, .dirFound			; Is it set? If so, jump
	dec  c						; C = DIR_U
	rla  ; KEYB_UP
	jr   c, .dirFound
	
	; The bits here are stored in a different order between DIR_* and KEY_*,
	; requiring a small switchup.
	dec  c						; C = DIR_R
	rla  ; KEYB_LEFT			; Is the left button pressed set?
	jr   nc, .dirFound			; If *NOT*, we're holding right (keep DIR_R)
	dec  c						; Otherwise, C = DIR_L
.dirFound:
	ld   a, c
.setDir:
	ldi  [hl], a ; iShotDir
	
	; Not deflected
	xor  a
	ldi  [hl], a ; iShotFlags
	
	;
	; Each direction uses different spawn coordinates for the shot.
	;
	
	; X POSITION
	ldi  [hl], a ; iShotXSub	; No subpixels
	; Index Wpn_MePosXTbl by direction and read out the offset to B
	ld   a, LOW(Wpn_MePosXTbl)	; E = LOW(Wpn_MePosXTbl) + C
	add  c
	ld   e, a
	ld   a, HIGH(Wpn_MePosXTbl)	; D = HIGH(Wpn_MePosXTbl)	+ (Carry)
	adc  $00
	ld   d, a
	ld   a, [de]				; B = X Offset
	ld   b, a
	; That offset is relative to the player, as usual
	ld   a, [wPlRelX]
	add  b
	ldi  [hl], a ; iShotX
	
	; Y POSITION
	; Same thing, but with a different table.
	xor  a
	ldi  [hl], a ; iShotYSub
	ld   a, LOW(Wpn_MePosYTbl)
	add  c
	ld   e, a
	ld   a, HIGH(Wpn_MePosYTbl)
	adc  $00
	ld   d, a
	ld   a, [de]
	ld   b, a
	ld   a, [wPlRelY]
	add  b
	ldi  [hl], a ; iShotY
	
	; Set sprite
	ld   [hl], SHOTSPR_ME0 ; iShotSprId
	
	; [POI] For some reason, this does not go through WpnCtrlS_StartShootAnim, opting to manually set the fields.
	;       In doing so, it forgets to play a sound effect and it also sets the wrong shooting animation,
	;       which WpnCtrlS_StartShootAnim/Wpn_ShootTypeTbl would have gotten right.
	ld   a, $0C					; Same timing as WpnCtrlS_StartShootAnim 
	ld   [wPlShootTimer], a
	ld   a, PSA_SHOOT
	ld   [wPlShootType], a
	ret
	
; =============== WpnCtrl_CrashBomb ===============
; Crash Bomb.
; A shot fired forward that eats up copious amounts of energy with an explosion just for show.
WpnCtrl_CrashBomb:
	ld   a, WPU_CR
	ld   [wWpnUnlockMask], a
	
	; Check for shoot button
	ldh  a, [hJoyNewKeys]
	bit  KEYB_B, a
	jp   z, WpnCtrlS_End
	
	; Max 1 shot on-screen
	ld   hl, wShot0
	ld   a, [hl]
	or   a
	jp   nz, WpnCtrlS_End
	
	; Eat up wild amountx of ammo, chances are there's not enough to spawn a shot
	call WpnS_UseAmmo
	jp   c, WpnCtrlS_End
	
	; Only fired forward
	ld   a, SHOT0_PROC|WPN_CR ; Shot ID
	ld   c, SHOTSPR_CRMOVE ; Sprite ID
	jp   WpnCtrlS_SpawnShotFwd
	
; =============== WpnCtrl_NeedleCannon ===============
; Needle Cannon.
; Rapid-fire weapon with shots that alternate between two vertical positions.
WpnCtrl_NeedleCannon:
	ld   a, WPU_NE
	ld   [wWpnUnlockMask], a
	
	; Needle cannon has autofire, the B button can be held.
	ldh  a, [hJoyKeys]
	bit  KEYB_B, a			; Holding B?
	jp   z, WpnCtrlS_End	; If not, return
	
	;
	; Max 3 shots on-screen
	;
	ld   hl, wShot0
	ld   a, [hl]
	or   a					; Is the first slot empty?
	jr   z, .chkCooldown			; If so, jump
	ld   hl, wShot1
	ld   a, [hl]
	or   a
	jr   z, .chkCooldown
	ld   hl, wShot2
	ld   a, [hl]
	or   a
	jp   nz, WpnCtrlS_End
	
	;
	; Enforce a cooldown period of 10 frames between shots.
	; 
	; However, the way the cooldown timer is handled is... weird. 
	; It would have made sense to have it as a global variable, instead it makes use of the shot-specific timer in iShotNeTimer.
	; 
	; This means we have to loop through all shots and check if any have spawned in the last 10 frames.
	; If any did, return and don't spawn a new one.
	;
.chkCooldown:
	ld   de, wShot0			; DE = First slot
	ld   b, $03				; B = Slots left
.loopCo:
	; Ignore empty slots
	ld   a, [de]
	or   a					; Is the slot free?
	jr   z, .nextCo			; If so, skip
	; If the shot is too new, return
	inc  e					; Seek to iShotNeTimer
	ld   a, [de]
	cp   $0A				; iShotNeTimer < $0A?
	jp   c, WpnCtrlS_End	; If so, return
	dec  e
.nextCo:
	; Seek to next slot
	ld   a, e				; DE += $10
	add  iShotEnd
	ld   e, a
	dec  b					; Checked all slots?
	jr   nz, .loopCo		; If not, loop
	
	; Check for ammo
	call WpnS_UseAmmo
	jp   c, WpnCtrlS_End
	
.spawn:
	; Spawn the shot.
	ld   a, SHOT0_PROC|WPN_NE
	ldi  [hl], a ; iShotId
	xor  a
	ldi  [hl], a ; iShotNeTimer
	
	; Face same direction as player
	ld   a, [wPlDirH]
	and  DIR_R
	ldi  [hl], a ; iShotDir
	
	; X POSITION
	; Spawn 14px in front of the player
	ld   b, -$0E	; B = 14px to the left
	or   a			; Facing right?
	jr   z, .setX	; If not, jump
	ld   b, $0E+1	; B = 14px to the right
.setX:
	; Not deflected
	xor  a
	ldi  [hl], a ; iShotFlags
	
	; XPos = PlX + B
	ldi  [hl], a ; iShotXSub
	ld   a, [wPlRelX]
	add  b
	ldi  [hl], a ; iShotX
	
	; Y POSITION
	; The vertical position alternates between 9px and 14px every other shot,
	; starting with 9px (wWpnNePos is initialized to 0, which gets flipped to 1)
	xor  a		
	ldi  [hl], a ; iShotYSub
	
	ld   a, [wWpnNePos]	; # Flip direction marker in bit0
	xor  $01
	ld   [wWpnNePos], a
	rra  				; # C Flag = wWpnNePos % 2
	ld   a, [wPlRelY]	; A = PlY
	jr   c, .y0			; # Every other frame alternate between...
.y1:
	sub  $0E			; ...14px above 
	jr   .setY
.y0:
	sub  $09			; ...9px above
.setY:
	ldi  [hl], a ; iShotY
	
	; Set sprite
	ld   a, SHOTSPR_NE
	ld   [hl], a ; iShotSprId
	
	jp   WpnCtrlS_StartShootAnim
	
; =============== WpnCtrl_HardKnuckle ===============
; Hard Knuckle
; Large fist fired forward, its vertical position can be adjusted over time.
WpnCtrl_HardKnuckle:
	ld   a, WPU_HA
	ld   [wWpnUnlockMask], a
	
	; Check for shoot button
	ldh  a, [hJoyNewKeys]
	bit  KEYB_B, a
	jp   z, WpnCtrlS_End
	
	; Max 1 shot on-screen
	ld   hl, wShot0
	ld   a, [hl]
	or   a
	jp   nz, WpnCtrlS_End
	
	; Use up ammo, if there isn't enough don't spawn the shot
	call WpnS_UseAmmo
	jp   c, WpnCtrlS_End
	
	;--
	; Freeze the player for 16 frames after firing the shot.
	; This countdown timer is global, ticking down every time shots are processed in WpnS_Do.
	ld   a, PL_MODE_FROZEN
	ld   [wPlMode], a		; Freeze player
	ld   a, $10
	ld   [wWpnHaFreezeTimer], a	; Return to PL_MODE_GROUND after $10 frames
	;--
	
	; Shoot the fist forward
	ld   a, SHOT0_PROC|WPN_HA ; Shot ID
	ld   c, SHOTSPR_HA ; Sprite ID
	jp   WpnCtrlS_SpawnShotFwd
	
; =============== WpnCtrl_MagnetMissile ===============
; Magnet Missile.
; A magnet fired forward, it can rotate 90° towards enemies.
WpnCtrl_MagnetMissile:
	ld   a, WPU_MG
	ld   [wWpnUnlockMask], a
	
	; Check for shoot button
	ldh  a, [hJoyNewKeys]
	bit  KEYB_B, a
	jp   z, WpnCtrlS_End
	
	; Max 2 shots on-screen
	ld   hl, wShot0
	ld   a, [hl]
	or   a
	jr   z, .chkAmmo
	ld   hl, wShot1
	ld   a, [hl]
	or   a
	jp   nz, WpnCtrlS_End
	
.chkAmmo:
	; Use up (more) ammo (than you'd think), if there isn't enough don't spawn the shot
	call WpnS_UseAmmo
	jp   c, WpnCtrlS_End
	
	; This is fired forward
	ld   a, SHOT0_PROC|WPN_MG ; A = Shot ID
	ld   c, SHOTSPR_MGH ; C = Sprite ID
	jp   WpnCtrlS_SpawnShotFwd

; =============== WpnS_Do ===============
; Processes all active weapon shots.
WpnS_Do:

	; Return to the idle state when the freeze timer elapses.
	; This is exclusively used by Hard Knucle to freeze the player after shooting (see WpnCtrl_HardKnuckle),
	; and it's up to us to re-enable the player controls here.
	; It's also notoriously buggy, but... the location of the bug is elsewhere (see Game_StartRoomTrs & ScrEv_LvlScrollH)
	ld   a, [wWpnHaFreezeTimer]
	or   a					; Is the timer already elapsed?
	jr   z, .chkSlots		; If so, skip
	dec  a					; Otherwise, timer--
	ld   [wWpnHaFreezeTimer], a
	jr   nz, .chkSlots		; Did it elapse *now*? (A = 0)
	ld   [wPlMode], a		; If so, unlock the player's controls (A = PL_MODE_GROUND)
	
.chkSlots:
	; Check each of the individual shot slots, processing all that are active.
	ld   hl, wShot0		; HL = Ptr to slot
	ld   a, [hl]		; Read iShotId
	or   a				; Is the slot active?
	call nz, WpnS_ProcSlot	; If so, process it
	
	ld   hl, wShot1		; Do the same for the other shots
	ld   a, [hl]
	or   a
	call nz, WpnS_ProcSlot
	
	ld   hl, wShot2
	ld   a, [hl]
	or   a
	call nz, WpnS_ProcSlot
	
	ld   hl, wShot3
	ld   a, [hl]
	or   a
	call nz, WpnS_ProcSlot
	
	ret
	
; =============== WpnS_ProcSlot ===============
; Processes a weapon shot slot.
; IN
; - HL: Ptr to slot
WpnS_ProcSlot:
	push hl	; Save slot ptr (source)
	
		;
		; Copy the shot to a working area for processing.
		; That's the same area used by actors, since it's free space at this point.
		;
		
		; Worth noting the slot struct is only $0D bytes long, but it is aligned to a $10-byte boundary for convenience.
		ld   de, hShotCur	; DE = Working area (destination)
		ld   b, iShotRealEnd		; B = Bytes to copy
	.wkInLoop:
		ldi  a, [hl]		; Read byte from slot, SlotPtr++
		ld   [de], a		; Copy over to wk
		inc  de				; WkPtr++
		dec  b				; Are we done?
		jr   nz, .wkInLoop	; If not, loop
		;--
		
		; Execute the weapon-specific code
		call WpnS_ExecCode
		
		; Deflected shots deal no damage
		ldh  a, [hShotCur+iShotFlags]
		bit  SHOT3B_DEFLECT, a	; Is the shot deflected?
		call z, Wpn_DoActColi	; If not, check for collision against all actors
	;--
	
	; 
	; Save back the changes made to the working area into the slot.
	;
	pop  de 			; DE = Slot ptr (destination)
	ld   hl, hShotCur	; HL = Working area (source)
	ld   b, iShotRealEnd		; B = Bytes to copy
.wkOutLoop:
	ldi  a, [hl]		; Read byte from wk, WkPtr++
	ld   [de], a		; Copy back to slot
	inc  de				; SlotPtr++
	dec  b				; Are we done?
	jr   nz, .wkOutLoop	; If not, loop
	
	ret
	
; =============== WpnS_ExecCode ===============
; Executes weapon-specific shot code.
WpnS_ExecCode:

	; If a shot is deflected, execute the generic deflect code
	ldh  a, [hShotCur+iShotFlags]
	bit  SHOT3B_DEFLECT, a		; Is the shot deflected
	jr   nz, Wpn_Deflected		; If so, jump
	
	; Otherwise, execute the normal shot's code
	ldh  a, [hShotCur+iShotId]	; A = iShotId
	and  $FF^SHOT0_PROC			; Filter out flag
	rst  $00 ; DynJump
	dw Wpn_Default       ; WPN_P 
	dw Wpn_Default       ; WPN_RC ;X
	dw Wpn_Default       ; WPN_RM ;X
	dw Wpn_Default       ; WPN_RJ ;X
	dw Wpn_TopSpin       ; WPN_TP
	dw Wpn_AirShooter    ; WPN_AR
	dw Wpn_LeafShield    ; WPN_WD
	dw Wpn_MetalBlade    ; WPN_ME
	dw Wpn_CrashBomb     ; WPN_CR
	dw Wpn_NeedleCannon  ; WPN_NE
	dw Wpn_HardKnuckle   ; WPN_HA
	dw Wpn_MagnetMissile ; WPN_MG
	dw Wpn_Default       ; WPN_SG

; =============== Wpn_Deflected ===============
; Deflected shot.
; Moves diagonally up.
Wpn_Deflected:

	; Move upwards ~2.lpx/frame
	ldh  a, [hShotCur+iShotYSub]
	sub  $1C
	ldh  [hShotCur+iShotYSub], a
	ldh  a, [hShotCur+iShotY]
	sbc  $02
	ldh  [hShotCur+iShotY], a
	
	; If the shot went off-screen to the top, despawn it.
	; Specifically, if its Y position is between $00-$0F, it's treated as off-screen.
	; Not particularly necessary, given WpnS_DrawSprMap performs an offscreen check on its own. 
	and  $F0			; Check 16px ranges
	cp   $00			; In the topmost range? (offscreen)
	jr   nz, .moveH		; If not, jump
.despawn:
	xor  a				; Otherwise, clear iShotId. This despawns the shot by marking the slot as free. 
	ldh  [hShotCur+iShotId], a
	ret
	
.moveH:
	; Move backwards ~2.lpx/frame
	ldh  a, [hShotCur+iShotDir]
	or   a						; Facing right?
	jr   z, .moveR				; If not, jump
.moveL:
	; Facing right -> move left
	ldh  a, [hShotCur+iShotXSub]
	sub  $1C
	ldh  [hShotCur+iShotXSub], a
	ldh  a, [hShotCur+iShotX]
	sbc  $02
	ldh  [hShotCur+iShotX], a
	jp   WpnS_DrawSprMap
.moveR:
	; Facing left -> move right
	ldh  a, [hShotCur+iShotXSub]
	add  $1C
	ldh  [hShotCur+iShotXSub], a
	ldh  a, [hShotCur+iShotX]
	adc  $02
	ldh  [hShotCur+iShotX], a
	jp   WpnS_DrawSprMap
	
; =============== Wpn_Default ===============
; Default weapon.
; A small shot moving forwards at 2px/frame.
Wpn_Default:
	ld   hl, hShotCur+iShotX	; HL = Ptr to X pos
	ldh  a, [hShotCur+iShotDir]
	or   a						; Facing right?
	jr   nz, .moveR				; If so, jump
.moveL:
	dec  [hl]					; Move left 2px
	dec  [hl]
	jp   WpnS_DrawSprMap
.moveR:
	inc  [hl]					; Move right 2px
	inc  [hl]
	jp   WpnS_DrawSprMap
	
; =============== Wpn_TopSpin ===============
; Top Spin.
; Weapon code for Top Spin when activated, which makes the player spin, making the whole body damage enemies.
;
; The "spinning player" is internally a weapon shot that tracks the player's position, giving the illusion
; of the player himself spinning.
; To go with it, the normal player's sprite is hidden during this.
Wpn_TopSpin:
	; If the player is hurt, cancel out of the attack
	ld   a, [wPlHurtTimer]
	or   a						; Did the player get hit?
	jr   z, .spin				; If not, jump
.abort:
	xor  a						; Otherwise, despawn the shot
	ldh  [hShotCur+iShotId], a
	ld   [wWpnTpActive], a		; and enable the normal player sprite
	ret
.spin:

	; Sync direction from player.
	; The effects of doing this are basically unnoticeable due to the very fast animation.
	ld   a, [wPlDirH]
	and  DIR_R				; Filter L/R bit
	ldh  [hShotCur+iShotDir], a
	
	; Sync position
	ld   a, [wPlRelX]			; iShotX = PlX (middle)
	ldh  [hShotCur+iShotX], a
	ld   a, [wPlRelY]			; iShotY = PlY (low)
	sub  $08					; (consistent with init code at WpnCtrl_TopSpin)
	ldh  [hShotCur+iShotY], a
	
	; Tick animation timer (cycles from 0 to 7)
	ldh  a, [hShotCur+iShotTpAnimTimer]
	inc  a								; Timer++
	and  $07							; Timer %= 8
	ldh  [hShotCur+iShotTpAnimTimer], a	; Save back
	
	; Use the timer as offset to the sprite mapping.
	; This has the effect of cycling the animation from SHOTSPR_TP0 to SHOTSPR_TP3
	srl  a						; Slowed down x2 (each sprite lasts 2 frames, 4 sprites)
	add  SHOTSPR_TP0				; Add base frame
	ldh  [hShotCur+iShotSprId], a
	
	jp   WpnS_DrawSprMap		; Draw the sprite
	
; =============== Wpn_AirShooter ===============
; Air Shooter.
; The weapon fires three whirlwinds at once that rise upwards.
; This is the code for an individual whirlwind.
Wpn_AirShooter:

	;
	; Each of the three shots has its own horizontal speed:
	; - 0: 1.0px/frame
	; - 1: 1.5px/frame
	; - 2: 2.0px/frame
	;
	; BC = Speed for the current shot
	;
	ldh  a, [hShotCur+iShotArNum]
	ld   bc, $0100		; BC = 1px/frame
	dec  a				; ShotNum == 0?
	jr   z, .moveH		; If so, jump
	ld   c, $80			; ...
	dec  a
	jr   z, .moveH
	ld   bc, $0200
	
.moveH:
	;
	; Move forward by the aforemented speed.
	;
	ld   hl, hShotCur+iShotXSub
	ldh  a, [hShotCur+iShotDir]	; # Get direction
	or   a						; # Facing right? (iShotDir != DIR_L)
	ld   a, [hl]				; Read cur subpixels
	jr   nz, .moveR				; # If so, jump
.moveL:
	; iShotX -= BC
	sub  c
	ldi  [hl], a ; iShotXSub
	ld   a, [hl] ; iShotX
	sbc  b
	ldi  [hl], a ; iShotX
	jr   .setY
.moveR:
	; iShotX += BC
	add  c						
	ldi  [hl], a ; iShotXSub
	ld   a, [hl] ; iShotX
	adc  b
	ldi  [hl], a ; iShotX
.setY:

	;
	; Move upwards at a fixed speed of 2px/frame
	;
	inc  hl ; iShotYSub
	dec  [hl]	; iShotY -= 2
	dec  [hl]
	
	;
	; Cycle between sprite mappings $01-$02
	; [TCRF] Off by one, this animation has a third frame that gets cut off.
	;
	inc  hl ; iShotSprId
	ld   a, [hl]		; A = iShotSprId++
	inc  a
	cp   SHOTSPR_AR2		; Reached the last frame? (should have been cp SHOTSPR_AR2+1)
	jr   c, .setSpr		; If not, jump
	ld   a, SHOTSPR_AR0	; Otherwise, reset to the first one
.setSpr:
	ld   [hl], a		; Save to iShotSprId
	
	jp   WpnS_DrawSprMap
	
; =============== Wpn_LeafShield ===============
; Leaf Shield.
; A shield made of 4 leaves that pierces through everything (but can get deflected).
; This is the code for an individual leaf.
; Code for all leaves is executed on the same frame, making sure they don't get misaligned.
Wpn_LeafShield:
	ldh  a, [hShotCur+iShotWdAnim]
	bit  SHOTWDB_ROTATE, a			; Intro anim done?
	jr   nz, Wpn_LeafShield_Main	; If so, jump
	; Fall-through
	
; =============== Wpn_LeafShield_Intro ===============
; When Leaf Shield spawns, the four leaves move into position from (what they intended to be) the center of the player.
; The animation goes by so quickly it's hard to notice without frame by frame, and the bugs don't help.
Wpn_LeafShield_Intro:


	
	ld   c, a ; Save iShotWdAnim
		;--
		;
		; Determine the leaf position, relative to the player.
		; B = 3 + (iShotWdAnim / 4) * 3
		;     IF (B >= $0C) B--
		;
		; bits2-3 of iShotWdAnim are used a timer for this animation.
		; With the above formula, for each frame of the animation, the leaves will be diagonally offset by:
		; Timer - Offset
		;     0 - $06
		;     1 - $09
		;     2 - $0B
		;     3 - $0E
		;
		; This gives the effect of the leaves moving, over time, from the player's origin to one of the four corners.
		;
		
		; A = 3 + (iShotWdAnim / 4) * 3
		; The lower 2 bits are unrelated to the timer.
		srl  a		; >> 2
		srl  a		;
		; Multiply it by 3
		ld   b, a	; Save this
		add  a		; A *= 2
		add  b		; A += B (*3)
		; Add base offset
		add  $03	; A += 3
		
		; To "slow down" the movement speed by the end, decrement any offset that would be >= $0C, which triggers once the timer ticks to 2.
		; Needless to say, it doesn't quite work when the whole animation is 4 frames long.
		cp   $0C		; A < $0C?
		jr   c, .setOff	; If so, jump
		dec  a			; Otherwise, A--
	.setOff:
		ld   b, a
		;--
		
	; The last two bits of iShotWdAnim identify the leaf number.
	; Each leaf moves to a particular corner.
	ld   a, c 	; A = iShotWdAnim
	and  %11	; Filter leaf number
	rst  $00 ; DynJump
	dw .moveUR
	dw .moveDR
	dw .moveDL
	dw .moveUL
.moveUR:
	; Set the leaf <B> pixels to the top-right of the player.
	; Will move to the top-right corner over time.
	ld   hl, hShotCur+iShotX
	ld   a, [wPlRelX]	; iShotX = wPlRelX + B
	add  b
	ldi  [hl], a
	inc  hl
	; [BUG] All of these intro movement routines target the wrong Y position.
	;       They intended to target the center of the player, but that requires subtracting
	;       the player's vertical radius (PLCOLI_V) to get there.
	;       (The main rotation code gets it right)
	ld   a, [wPlRelY]	; iShotY = wPlRelY - B
	sub  b
	ld   [hl], a
	jr   .nextTick
.moveDR:
	; See above, but to the bottom-right
	ld   hl, hShotCur+iShotX
	ld   a, [wPlRelX]
	add  b
	ldi  [hl], a
	inc  hl
	ld   a, [wPlRelY]
	add  b
	ld   [hl], a
	jr   .nextTick
.moveDL:
	; ... bottom-left
	ld   hl, hShotCur+iShotX
	ld   a, [wPlRelX]
	sub  b
	ldi  [hl], a
	inc  hl
	ld   a, [wPlRelY]
	add  b
	ld   [hl], a
	jr   .nextTick
.moveUL:
	; ... top-left
	ld   hl, hShotCur+iShotX
	ld   a, [wPlRelX]
	sub  b
	ldi  [hl], a
	inc  hl
	ld   a, [wPlRelY]
	sub  b
	ld   [hl], a
.nextTick:

	; Advance the animation timer.
	; Keep in mind the lower two bits are unrelated, hence the << 2's
	ldh  a, [hShotCur+iShotWdAnim]
	add  $01<<2			; Timer++
	cp   $04<<2			; Timer < $04?
	jr   c, .setAnim	; If so, just update the timer
	
	; Otherwise, prepare for the main rotation animation.
	
	; Calculate the rotation position index from the leaf number,
	; to evenly distribute the leaves around the circle.
	; PosId = LeafNum * $10 + 8 
	and  $03			; Get the leaf number
	swap a				; * 10
	add  $08			; + 8
	; Mark the intro as finished
	or   SHOTWD_ROTATE
.setAnim:
	ldh  [hShotCur+iShotWdAnim], a
	jp   WpnS_DrawSprMap
	
; =============== Wpn_LeafShield_Main ===============
; Main rotation state.
Wpn_LeafShield_Main:

	ld   d, a ; Save iShotWdAnim
	
		;
		; Rotate the leaf around a circle path.
		;
	
		; BC = Position index
		and  $FF^(SHOTWD_THROW|SHOTWD_ROTATE)
		ld   b, $00
		ld   c, a
		
		bit  SHOTWDB_THROW, d		; Is the shield thrown?
		jr   nz, .rotSelf			; If so, jump
		
	.rotPl:
		;
		; When the shield isn't thrown yet, rotate the leaf around the player.
		;
		ld   hl, Wpn_WdSinePat.x	; iShotX = wPlRelX + Wpn_WdSinePat.x[BC]
		add  hl, bc
		ld   a, [wPlRelX]			; From origin (horizontally centered)
		add  [hl]					; + offset
		ldh  [hShotCur+iShotX], a
		
		ld   hl, Wpn_WdSinePat.y	; iShotY = wPlRelY + Wpn_WdSinePat.y[BC] - PLCOLI_V
		add  hl, bc
		ld   a, [wPlRelY]			; From origin (bottom)
		add  [hl]					; + offset
		sub  PLCOLI_V				; Vertically centered
		ldh  [hShotCur+iShotY], a
		
		jr   .nextPos
	.rotSelf:
		;
		; When the shield is thrown, still rotate the leaves, but not around the player anymore.
		; This means the offsets used are relative to the previous position, necessitating
		; the use of a different set of tables.
		;
		ld   hl, Wpn_WdSelfPat.x	; iShotX += Wpn_WdSelfPat.x[BC]
		add  hl, bc
		ldh  a, [hShotCur+iShotX]
		add  [hl]
		ldh  [hShotCur+iShotX], a
		
		ld   hl, Wpn_WdSelfPat.y	; iShotY += Wpn_WdSelfPat.y[BC]
		add  hl, bc
		ldh  a, [hShotCur+iShotY]
		add  [hl]
		ldh  [hShotCur+iShotY], a
		
	.nextPos:
		; Increment the position index, cycling between $00 - $3F.
		ld   a, c
		inc  a		; PosId++
		and  $3F	; Loop around $40 to $00
		ld   c, a
		
	; Save back the updated index into iShotWdAnim
	ld   a, d							; A = iShotWdAnim
	and  SHOTWD_THROW|SHOTWD_ROTATE		; Keep flags
	or   c								; Merge with new index
	ldh  [hShotCur+iShotWdAnim], a		; Save back
	
.chkThrowCtrl:

	;
	; Pressing any directional key while the shield is around the player will throw it
	; to that particular direction.
	;

	; If the shield was already thrown, keep moving it to the previous direction
	bit  SHOTWDB_THROW, a
	jr   nz, .thrown
	
	
	; If no directional keys are being held, don't throw it
	ldh  a, [hJoyKeys]
	and  KEY_DOWN|KEY_UP|KEY_LEFT|KEY_RIGHT
	jp   z, WpnS_DrawSprMap
	
	; Otherwise, throw the shield in the respective direction.
	; Check the individual direction by shifting key bits into the carry.
	ld   b, DIR_D		; B = DIR_D
	rla 				; KEY_DOWN is set?
	jr   c, .setDir		; If so, move down
	dec  b				; B = DIR_U
	rla  				; KEY_UP is set?
	jr   c, .setDir		; If so, move up
	dec  b				; B = DIR_R
	rla  				; KEY_LEFT is set?
	jr   nc, .setDir	; If *NOT*, move right (B = DIR_R confirmed)
	dec  b				; Otherwise, B = DIR_L
.setDir:
	ld   a, b
	ldh  [hShotCur+iShotDir], a
	
	; Flag the shield has having been thrown
	ldh  a, [hShotCur+iShotWdAnim]
	or   SHOTWD_THROW
	ldh  [hShotCur+iShotWdAnim], a
	
	; [POI] Why does wWpnWdUseAmmoOnThrow exist?
	;       This could be speculated on but what we do know is that its value will always be $01 when we get here.
	ld   hl, wWpnWdUseAmmoOnThrow
	dec  [hl]					; UseLeft--
	call z, WpnS_UseAmmo		; Is it 0? If so, use up ammo (always taken)
	
.thrown:
	; The shield moves at 2px/frame in a straight line
	ldh  a, [hShotCur+iShotDir]
	rst  $00 ; DynJump
	dw .throwL
	dw .throwR
	dw .throwU
	dw .throwD
.throwL:
	ld   hl, hShotCur+iShotX
	dec  [hl]
	dec  [hl]
	jp   WpnS_DrawSprMap
.throwR:
	ld   hl, hShotCur+iShotX
	inc  [hl]
	inc  [hl]
	jp   WpnS_DrawSprMap
.throwU:
	ld   hl, hShotCur+iShotY
	dec  [hl]
	dec  [hl]
	jp   WpnS_DrawSprMap
.throwD:
	ld   hl, hShotCur+iShotY
	inc  [hl]
	inc  [hl]
	jp   WpnS_DrawSprMap
	
; =============== Wpn_MetalBlade ===============
; Metal Blade.
; 8-way shot replacement.
Wpn_MetalBlade:

	; Alternate between two animation frames (SHOTSPR_ME0, SHOTSPR_ME1)
	ldh  a, [hShotCur+iShotMeAnimTimer]
	xor  $01
	ldh  [hShotCur+iShotMeAnimTimer], a
	add  SHOTSPR_ME0
	ldh  [hShotCur+iShotSprId], a
	
	; Move 2px/frame according to its direction
	ldh  a, [hShotCur+iShotDir]
	rst  $00 ; DynJump
	dw .moveL ; DIR_L
	dw .moveR ; DIR_R
	dw .moveU ; DIR_U
	dw .moveD ; DIR_D
	dw .moveUL ; DIR_UL
	dw .moveUR ; DIR_UR
	dw .moveDL ; DIR_DL
	dw .moveDR ; DIR_DR

.moveL:
	ld   hl, hShotCur+iShotX	; iShotX -= 2
	dec  [hl]
	dec  [hl]
	jp   WpnS_DrawSprMap
	
.moveR:
	ld   hl, hShotCur+iShotX	; iShotX += 2
	inc  [hl]
	inc  [hl]
	jp   WpnS_DrawSprMap
	
.moveU:
	ld   hl, hShotCur+iShotY	; iShotY -= 2
	dec  [hl]
	dec  [hl]
	jp   WpnS_DrawSprMap
	
.moveD:
	ld   hl, hShotCur+iShotY	; iShotY += 2
	inc  [hl]
	inc  [hl]
	jp   WpnS_DrawSprMap
	
.moveUL:
	ld   hl, hShotCur+iShotX	; iShotX += 2
	dec  [hl]
	dec  [hl]
	inc  hl ; iShotYSub
	inc  hl ; iShotY
	dec  [hl]					; iShotY -= 2
	dec  [hl]
	jp   WpnS_DrawSprMap
	
.moveUR:
	ld   hl, hShotCur+iShotX	; iShotX += 2
	inc  [hl]
	inc  [hl]
	inc  hl ; iShotYSub
	inc  hl ; iShotY
	dec  [hl]					; iShotY -= 2
	dec  [hl]
	jp   WpnS_DrawSprMap
	
.moveDL:
	ld   hl, hShotCur+iShotX	; iShotX -= 2
	dec  [hl]
	dec  [hl]
	inc  hl ; iShotYSub
	inc  hl ; iShotY
	inc  [hl]					; iShotY += 2
	inc  [hl]
	jp   WpnS_DrawSprMap
	
.moveDR:
	ld   hl, hShotCur+iShotX	; iShotX += 2
	inc  [hl]
	inc  [hl]
	inc  hl ; iShotYSub
	inc  hl ; iShotY
	inc  [hl]					; iShotY += 2
	inc  [hl]
	jp   WpnS_DrawSprMap
	
; =============== Wpn_CrashBomb ===============
; Crash Bomb
; A medium-sized projectile that sticks to walls, then explodes.
Wpn_CrashBomb:

	ldh  a, [hShotCur+iShotCrTimer]
	or   a					; Hit a solid block already?
	jr   nz, .solidHit		; If so, jump
	
	;
	; Move the bomb 2px/frame forward, while checking for collision with any solid blocks in the way.
	;
	
	; Y COLLISION TARGET = ShotY
	ldh  a, [hShotCur+iShotY]	
	ld   [wTargetRelY], a
	
	; X COLLISION TARGET = 1px in front of iShotX
	ld   hl, hShotCur+iShotX	
	ldh  a, [hShotCur+iShotDir]
	or   a						; # Facing right?
	ld   b, -$01				; B = 1px to the left
	jr   z, .chkMove			; # If not, jump
	ld   b, +$01				; B = 1px to the right
.chkMove:
	; Move 1px to the right twice, aborting early in case of collision
	call .moveFwd				; Move 1px right
	call c, .moveFwd			; Hit a solid block? If not, move again
	jp   c, WpnS_DrawSprMap		; Hit a solid block? If not, return
	
.solidHit:
	ld   hl, hShotCur+iShotCrTimer
	inc  [hl]			; Timer++
	
	;
	; After hitting a solid block, perform these actions in sequence:
	; - Flash for around 2.1 seconds ($00-$7F, after which it overflows to SHOTCR_EXPLODE)
	; - Exploding for 1 second ($80-$BC)
	; - Despawn
	;
	
	ld   a, [hl]
	cp   SHOTCR_EXPLODE+$3C		; Timer < $BC?
	jr   c, .chkFlash			; If so, jump
.despawn:						; Otherwise, despawn the shot
	xor  a
	ldh  [hShotCur+iShotId], a
	ret
	
.chkFlash:
	cp   SHOTCR_EXPLODE			; Timer >= $80?
	jr   nc, .explode			; If so, jump
.flash:
	; Flash the bomb by alternating between SHOTSPR_CRFLASH0 and SHOTSPR_CRFLASH1 every 8 frames.
	srl  a						; A = Timer / 8
	srl  a
	srl  a
	and  $01					; Filter valid range
	add  SHOTSPR_CRFLASH0		; Add base sprite
	ldh  [hShotCur+iShotSprId], a
	jp   WpnS_DrawSprMap
	
.explode:
	; Animate the explosion.
	; The explosion is not a separate object that deals damage, it's simply the Crash Bomb going
	; through a list of sprite mappings that have no effect on gameplay.
	; As a result, keeps the same collision box as before, making it very weak.
	;
	; Worth noting this could have been amended by simply adjusting the current shot's collision box
	; and flags right here.
	
	; Get table index
	and  $FF^SHOTCR_EXPLODE		; Remove MSB (as A is always >= $80)
	srl  a						; Slowed down x2
	
	; Read out sprite mapping ID from  .explTbl
	ld   hl, .explTbl			; Index .explTbl with it
	ld   b, $00
	ld   c, a			
	add  hl, bc
	ld   a, [hl]		
	ldh  [hShotCur+iShotSprId], a	; And set it as sprite
	jp   WpnS_DrawSprMap
	
; =============== .explTbl ===============
; Animation cycle for the Crash Bomb explosions.
; Needs to have as many entries as the amount of frames / 2 it executes .explode.
; The explosion lasts 1 second ($3C frames), so this table should have 30 entries.
.explTbl: 
	db SHOTSPR_CREXPL2 ; $00
	db SHOTSPR_CREXPL1 ; $02
	db SHOTSPR_CREXPL0 ; $04
	db SHOTSPR_CREXPL1 ; $06
	db SHOTSPR_CREXPL2 ; $08
	db SHOTSPR_CREXPL5 ; $0A
	db SHOTSPR_CREXPL4 ; $0C
	db SHOTSPR_CREXPL3 ; $0E
	db SHOTSPR_CREXPL4 ; $10
	db SHOTSPR_CREXPL5 ; $12
	db SHOTSPR_CREXPL8 ; $14
	db SHOTSPR_CREXPL7 ; $16
	db SHOTSPR_CREXPL6 ; $18
	db SHOTSPR_CREXPL7 ; $1A
	db SHOTSPR_CREXPL8 ; $1C
	db SHOTSPR_CREXPL2 ; $1E
	db SHOTSPR_CREXPL1 ; $20
	db SHOTSPR_CREXPL0 ; $22
	db SHOTSPR_CREXPL1 ; $24
	db SHOTSPR_CREXPL2 ; $26
	db SHOTSPR_CREXPL5 ; $28
	db SHOTSPR_CREXPL4 ; $2A
	db SHOTSPR_CREXPL3 ; $2C
	db SHOTSPR_CREXPL4 ; $2E
	db SHOTSPR_CREXPL5 ; $30
	db SHOTSPR_CREXPL8 ; $32
	db SHOTSPR_CREXPL7 ; $34
	db SHOTSPR_CREXPL6 ; $36
	db SHOTSPR_CREXPL7 ; $38
	db SHOTSPR_CREXPL8 ; $3A
	                  
; =============== .moveFwd ===============
; Moves the shot forward.
; IN
; - HL: Ptr to iShotX
; - B: Movement speed (1 or -1, depending on the direction)
; - wTargetRelY: iShotY
; OUT
; - C Flag: If set, it didn't hit a solid wall
.moveFwd:
	; Move shot forward
	ld   a, [hl]	; iShotX += B
	add  b
	ld   [hl], a
	
	; Perform the collision check at this new position
	ld   [wTargetRelX], a
	push bc
	push hl
		call Lvl_GetBlockId	; C Flag = Is empty?
	pop  hl
	pop  bc
	ret
	
; =============== Wpn_NeedleCannon ===============
; Needle Cannon.
; A normal shot that can be rapid-fired.
Wpn_NeedleCannon:
	
	; And due to the rapid-fire, for cooldown purposes it has to keep track
	; of how many frames have passed since the shot was spawned.
	ld   hl, hShotCur+iShotNeTimer
	inc  [hl]
	
	; Move forward 2px/frame, like a normal shot
	ld   l, LOW(hShotCur+iShotX)
	ldh  a, [hShotCur+iShotDir]
	or   a				; Facing right?
	jr   nz, .moveR		; If so, jump
.moveL:
	dec  [hl]
	dec  [hl]
	jp   WpnS_DrawSprMap
.moveR:
	inc  [hl]
	inc  [hl]
	jp   WpnS_DrawSprMap
	
; =============== Wpn_HardKnuckle ===============
; Hard Knuckle
; Slow moving fist which can be vertically adjusted.
Wpn_HardKnuckle:

	;
	; VERTICAL MOVEMENT
	; 
	; On its own, the fist moves only horizontally, not vertically.
	; By holding UP or DOWN, its vertical position be adjusted, at
	; the low speed of 0.125px/frame.
	;
	ldh  a, [hJoyKeys]
	rla 				; Holding DOWN?
	jr   c, .moveD		; If so, move up
	rla  				; Holding UP?
	jr   nc, .moveH	; If not, jump
.moveU:					; Otherwise, move down
	; Move 0.125px/frame up
	ld   hl, hShotCur+iShotYSub
	ld   a, [hl]
	sub  $20
	ldi  [hl], a
	ld   a, [hl]
	sbc  $00
	ld   [hl], a
	jr   .moveH
.moveD:
	; Move 0.125px/frame down
	ld   hl, hShotCur+iShotYSub
	ld   a, [hl]
	add  $20
	ldi  [hl], a
	ld   a, [hl]
	adc  $00
	ld   [hl], a
	
.moveH:
	;
	; HORIZONTAL MOVEMENT
	;
	; The fist speeds up over time.
	; Specifically, it has two movement phases depending on how much time has passed since it has spawned:
	; - The first 16 frames, it moves forward at 1px/frame
	; - From the 17th frame onwards, it moves at 1.5px/frame
	;
	
	ld   hl, hShotCur+iShotHaTimer
	ld   a, [hl]
	cp   $10				; Timer >= 16?
	jr   nc, .moveFastH		; If so, use fast movement
.moveSlowH:
	inc  [hl]				; Timer++
	
	ld   hl, hShotCur+iShotX
	ldh  a, [hShotCur+iShotDir]
	or   a					; Facing right?
	jr   nz, .moveSlowR		; If so, jump
.moveSlowL:
	dec  [hl]				; Facing left: Move left 1px
	jp   WpnS_DrawSprMap
.moveSlowR:
	inc  [hl]				; Facing right: Move right 1px
	jp   WpnS_DrawSprMap
	
.moveFastH:
	ld   hl, hShotCur+iShotXSub
	ldh  a, [hShotCur+iShotDir]
	or   a					; Facing right?
	jr   nz, .moveFastR		; If so, jump
.moveFastL:
	ld   a, [hl]			; Facing left: Move left 1.5px
	sub  $80
	ldi  [hl], a
	ld   a, [hl] ; iShotX
	sbc  $01
	ld   [hl], a
	jp   WpnS_DrawSprMap
.moveFastR:
	ld   a, [hl]			; Facing right: Move right 1.5px
	add  $80
	ldi  [hl], a
	ld   a, [hl] ; iShotX
	adc  $01
	ld   [hl], a
	jp   WpnS_DrawSprMap
	
; =============== Wpn_MagnetMissile ===============
; Magnet Missile.
; A magnet fired forward, which can lock in vertically once to any actor.
Wpn_MagnetMissile:

	; If we locked on to something before, continue moving vertically
	ldh  a, [hShotCur+iShotMgMoveV]
	or   a				; Moving vertically?
	jr   nz, .moveV		; If so, jump
	
.scanAct:

	;
	; Find if there any suitable actor to vertically lock on at the current horizontal location.
	;
	
	ldh  a, [hShotCur+iShotX]	; B = X Position searched for
	ld   b, a
	

	ld   hl, wAct		; From the first actor...
.loopAct:
	; Ignore empty slots
	ldi  a, [hl]		; A = iActId, seek to iActRtnId
	or   a				; Is the slot empty?
	jr   z, .nextAct	; If so, skip to the next one
	
	; Only try to target actors that aren't fully invulnerable.
	; Unfortunately, this has both a bug and a design flaw.
	; - This does not actually check if the actor is *immune* to Magnet Missile,
	;   so it may target otherwise defeatable actors that reflect Magnet Missile.
	; - It tries to target invulnerable enemies (see below)
	ld   e, l			; DE = Ptr to iActRtnId
	ld   d, h
	inc  d				; Seek to iActColiBoxV
	inc  e				; Seek to iActColiType
	ld   a, [de]		; Read iActColiType
	
	; Actors with collision types >= $80 are partially vulnerable on top (see Wpn_OnActColi.typePartial),
	; which is good enough for us.
	; [POI] Note that this isn't the full range of values for this collision type.
	;       The actual range is $08-$FF, and as a result Magnet Missile won't target partially vulnerable
	;       actors in ranges $08-$7F. The actors using this collision type don't use that range though.
	bit  ACTCOLIB_PARTIAL, a	; Is this a partially vulnerable actor?
	jr   nz, .calcDistX		; If so, jump (ok)
	
	; Target vulnerable enemies
	cp   ACTCOLI_ENEMYHIT		; iActColiType == ACTCOLI_ENEMYHIT?
	jr   z, .calcDistX	; If so, jump (ok)
	
	; [BUG] Target invulnerable enemies
	; This is pretty egregious, it's specifically checking if the actor uses the collision type for
	; invulnerable enemies (ie: Hanging battons or Mets hiding) and... only skips targeting it if that's not the case.
	; What this should have done instead is jumping unconditionally to .nextAct.
	cp   ACTCOLI_ENEMYREFLECT		; iActColiType == ACTCOLI_ENEMYREFLECT?
	jr   nz, .nextAct	; If not, seek to the next slot
	
.calcDistX:
	inc  l ; iActSprMap
	inc  l ; iActLayoutPtr
	inc  l ; iActXSub
	inc  l ; iActX
	
	; If the shot is within 5 pixels from the actor, we found a target
	ldi  a, [hl] 		; A = iActX, seek to iActYSub
	sub  b				; Find distance (-= iShotX)
	; Distance should be absolute
	jr   nc, .chkDistX	; Did we underflow? If not, skip
	cpl  				; Otherwise, force positive sign
	inc  a
.chkDistX:
	cp   $05			; Distance < 5?
	jr   c, .foundAct	; If so, jump
	
.nextAct:
	; Seek to the next slot
	ld   a, l
	and  $F0			; Move back to iActId
	add  iActEnd		; To next slot
	ld   l, a			; Overflowed back to the first slot? (all 16 slots checked)
	jr   nz, .loopAct	; If not, loop
	
	; No suitable actor found, keep moving forward
	jr   .moveH
	
.foundAct:
	;
	; Found a suitable actor to lock on to.
	; Determine if it's above or below us, and set the shot's direction accordingly.
	;
	ldh  a, [hShotCur+iShotY]	; A = iShotY
	inc  l 						; Seek HL to iActY
	cp   [hl]					; iShotY > iActY? (Shot is below actor?)
	ld   a, DIR_U				; # A = DIR_U
	jr   nc, .setDirV			; If so, jump (shot should move up, keep DIR_U)
	inc  a						; # A = DIR_D (the actor is below, move shot down)
.setDirV:
	ldh  [hShotCur+iShotDir], a
	
	; Flag that we're moving vertically now
	ld   hl, hShotCur+iShotMgMoveV
	inc  [hl]
	
	; Immediately start moving vertically
	jr   .moveV
	
.moveH:
	;
	; Not locked in to anything yet.
	; Move forwards 2px/frame.
	;
	ld   hl, hShotCur+iShotX	; Seek HL to iShotX
	ldh  a, [hShotCur+iShotDir]
	or   a						; Facing right?
	jr   nz, .moveR				; If so, jump
.moveL:
	ld   a, [hl]
	sub  $02
	ld   [hl], a
	jp   WpnS_DrawSprMap
.moveR:
	ld   a, [hl]
	add  $02
	ld   [hl], a
	jp   WpnS_DrawSprMap
	
.moveV:
	;
	; Locked in to an actor above or below.
	; Move vertically 2px/frame.
	;
	ld   hl, hShotCur+iShotY	; Seek HL to iShotY
	ldh  a, [hShotCur+iShotDir]
	rra							; DIR_D is $03, when >> 1'd it will set the carry
	jr   c, .moveD				; Is it set? If so, jump
.moveU:
	dec  [hl]					; iShotY -= 2
	dec  [hl]
	ld   a, SHOTSPR_MGU
	ldh  [hShotCur+iShotSprId], a
	jp   WpnS_DrawSprMap
.moveD:
	inc  [hl]					; iShotY += 2
	inc  [hl]
	ld   a, SHOTSPR_MGD
	ldh  [hShotCur+iShotSprId], a
	jp   WpnS_DrawSprMap
	
; =============== WpnS_DrawSprMap ===============
; Draws the sprite mapping for the shot.
WpnS_DrawSprMap:

	; Adjust the shot's X position in case of screen scrolling
	ld   a, [wActScrollX]		; iShotX += wActScrollX
	ld   b, a
	ldh  a, [hShotCur+iShotX]
	add  b
	ldh  [hShotCur+iShotX], a
	
.chkOffscrX:
	; Check if the movement made it go off-screen horizontally.
	; Despawn anything in the $A8-$F7 range.
	cp   SCREEN_H+$08	; iShotY < $A8?
	jr   c, .chkOffscrY	; If so, jump
	cp   -$08			; iShotY < $F8?
	jr   c, .despawn	; If so, jump
	
.chkOffscrY:
	; Also do a vertical off-screen check.
	; Despawn anything in the $98-$F7 range.
	ldh  a, [hShotCur+iShotY]
	cp   SCREEN_V+$08	; iShotY < $98?
	jr   c, .getPtr		; If so, jump
	cp   -$08			; iShotY < $F8?
	jr   c, .despawn	; If so, jump
	
.getPtr:
	; DE = Ptr to current wWorkOAM location
	ld   d, HIGH(wWorkOAM)
	ldh  a, [hWorkOAMPos]
	ld   e, a
	
	; Read out the sprite definition off the table
	; HL = WpnS_SprMapPtrTbl[iShotSprId*2]
	ldh  a, [hShotCur+iShotSprId]
	add  a				; *2 for word table
	ld   hl, WpnS_SprMapPtrTbl	; HL = Table base
	ld   b, $00			; BC = Offset
	ld   c, a
	add  hl, bc			; Index it
	ldi  a, [hl]		; Read out the pointer to HL
	ld   h, [hl]
	ld   l, a
	
	;
	; Write the sprite mapping to the OAM mirror.
	; See also: Relevant code in ActS_DrawSprMap since it's pretty much the same.
	;
	; This appears to be a little less optimized than the player and actor variants,
	; as it merges the two flip loops in a single path.
	;
	
	; Ignore blank sprite mappings
	ldi  a, [hl]
	or   a				; OBJCount == 0?
	ret  z				; If so, we're done
	
	ld   b, a			; B = OBJCount
.loop:					; For each individual OBJ...
	
	; YPos = iShotY + byte0
	ldh  a, [hShotCur+iShotY]	; A = Absolute Y
	add  [hl]					; += Relative Y (byte0)
	inc  hl						; Seek to byte1
	ld   [de], a				; Write to OAM mirror
	inc  de						; Seek to XPos
	
	; X POSITION
	; This is affected by the horizontal direction, since if it's facing right,
	; the whole sprite mapping needs to get flipped.
	;
	; XPos = iShotX + byte1 (facing left)
	; XPos = iShotX - byte1 - 8 (facing right)
	
	; Determine the shot's direction
	ldh  a, [hShotCur+iShotDir]	; # Read direction
	dec  a						; # Z Flag = Facing right? (DIR_R decremented to 0)
	ldi  a, [hl]				; Read byte1 while we're here
	jr   nz, .setX				; # If not, jump (facing left, keep raw byte1)
.invX:
	cpl  						; Otherwise, invert the rel. X position
	inc  a
	sub  TILE_H					; Account for tile width
.setX:
	; Set the X position
	ld   c, a					; C = Relative X
	ldh  a, [hShotCur+iShotX]	; A = Absolute X
	add  c						; Get final pos
	ld   [de], a				; Write to OAM mirror
	inc  de
	
	; TileID = byte2
	ldi  a, [hl]
	ld   [de], a
	inc  de
	
	; Flags = (byte3 | wPlSprFlags) (facing left)
	; Flags = (byte3 | wPlSprFlags) ^ SPR_XFLIP (facing right)
	ldh  a, [hShotCur+iShotDir]	; # Read direction
	dec  a						; # Z Flag = Facing right? (DIR_R decremented to 0)
	ldi  a, [hl]				; Read byte3 while we're here
	jr   nz, .setFlags			; # If not, jump (facing left, keep raw byte3)
	xor  SPR_XFLIP				; Horizontally flip the individual tile
.setFlags:
	ld   c, a					; C = Tile flags
	ld   a, [wPlSprFlags]		; A = BG priority flag for stage
	or   c						; Merge them
	ld   [de], a				; Write to OAM mirror 
	inc  de						; to next OBJ entry
	
	dec  b						; Finished copying all OBJ?
	jr   nz, .loop				; If not, loop
	
	ld   a, e					; Save back current OAM ptr
	ldh  [hWorkOAMPos], a
	ret
	
.despawn:
	xor  a
	ldh  [hShotCur+iShotId], a
	ret
	
; =============== WpnS_SprMapPtrTbl ===============
; Points to all weapon shot sprite mappings.
WpnS_SprMapPtrTbl:
	dw SprMap_WpnP        ; SHOTSPR_P
	dw SprMap_WpnAr0      ; SHOTSPR_AR0
	dw SprMap_WpnAr1      ; SHOTSPR_AR1
	dw SprMap_WpnAr2      ; SHOTSPR_AR2 ; [TCRF] Unused sprite mapping
	dw SprMap_WpnWd       ; SHOTSPR_WD
	dw SprMap_WpnMe0      ; SHOTSPR_ME0
	dw SprMap_WpnMe1      ; SHOTSPR_ME1
	dw SprMap_WpnCrMove   ; SHOTSPR_CRMOVE
	dw SprMap_WpnCrFlash0 ; SHOTSPR_CRFLASH0
	dw SprMap_WpnCrFlash1 ; SHOTSPR_CRFLASH1
	dw SprMap_WpnCrExpl0  ; SHOTSPR_CREXPL0
	dw SprMap_WpnCrExpl1  ; SHOTSPR_CREXPL1
	dw SprMap_WpnCrExpl2  ; SHOTSPR_CREXPL2
	dw SprMap_WpnCrExpl3  ; SHOTSPR_CREXPL3
	dw SprMap_WpnCrExpl4  ; SHOTSPR_CREXPL4
	dw SprMap_WpnCrExpl5  ; SHOTSPR_CREXPL5
	dw SprMap_WpnCrExpl6  ; SHOTSPR_CREXPL6
	dw SprMap_WpnCrExpl7  ; SHOTSPR_CREXPL7
	dw SprMap_WpnCrExpl8  ; SHOTSPR_CREXPL8
	dw SprMap_WpnNe       ; SHOTSPR_NE
	dw SprMap_WpnHa       ; SHOTSPR_HA
	dw SprMap_WpnMgH      ; SHOTSPR_MGH
	dw SprMap_WpnMgU      ; SHOTSPR_MGU
	dw SprMap_WpnMgD      ; SHOTSPR_MGD
	dw SprMap_WpnTp0      ; SHOTSPR_TP0
	dw SprMap_WpnTp1      ; SHOTSPR_TP1
	dw SprMap_WpnTp2      ; SHOTSPR_TP2
	dw SprMap_WpnTp1      ; SHOTSPR_TP3
	dw SprMap_WpnSg       ; SHOTSPR_SG
	
; =============== SHOT SPRITE MAPPINGS ===============
INCLUDE "data/wpn/p_spr.asm"
INCLUDE "data/wpn/tp_spr.asm"
INCLUDE "data/wpn/ar_spr.asm"
INCLUDE "data/wpn/wd_spr.asm"
INCLUDE "data/wpn/me_spr.asm"
INCLUDE "data/wpn/cr_spr.asm"
INCLUDE "data/wpn/ne_spr.asm"
INCLUDE "data/wpn/ha_spr.asm"
INCLUDE "data/wpn/mg_spr.asm"
INCLUDE "data/wpn/sg_spr.asm"

;================ Wpn_MePosXTbl / Wpn_MePosYTbl ================
; Spawn coordinates for each Metal Blade direction, relative to the player's origin.
;       L     R     U     D     UL    UR    DL    DR
Wpn_MePosXTbl:
	db -$08, +$07, +$00, +$00, -$08, +$07, -$08, +$07
Wpn_MePosYTbl:
	db -$0B, -$0B, -$10, +$00, -$0B, -$0B, -$0B, -$0B
	
;================ Wpn_WdSinePat ================
; Leaf positions, relative to the player's origin.
; Used when the shield rotates around the player.
; Identical table to Act_WoodManLeafShield_SinePat, used for the same purpose.
Wpn_WdSinePat:
.y: db -$10,-$10,-$10,-$0F,-$0F,-$0E,-$0D,-$0C,-$0B,-$0A,-$09,-$08,-$06,-$05,-$03,-$02 ; $00 ;
.x:	db +$00,+$02,+$03,+$05,+$06,+$08,+$09,+$0A,+$0B,+$0C,+$0D,+$0E,+$0F,+$0F,+$10,+$10 ; $10 ; $00
	db +$10,+$10,+$10,+$0F,+$0F,+$0E,+$0D,+$0C,+$0B,+$0A,+$09,+$08,+$06,+$05,+$03,+$02 ; $20 ; $10
	db +$00,-$02,-$03,-$05,-$06,-$08,-$09,-$0A,-$0B,-$0C,-$0D,-$0E,-$0F,-$0F,-$10,-$10 ; $30 ; $20
	db -$10,-$10,-$10,-$0F,-$0F,-$0E,-$0D,-$0C,-$0B,-$0A,-$09,-$08,-$06,-$05,-$03,-$02 ;     ; $30

;================ Wpn_WdSelfPat ================
; Leaf positions, relative to the previous one.
; Used when the shield rotates on its own.
Wpn_WdSelfPat:
.y:	db +$00,+$00,+$01,+$00,+$01,+$01,+$01,+$01,+$01,+$01,+$01,+$02,+$01,+$02,+$01,+$02 ; $00 ;
.x:	db +$02,+$01,+$02,+$01,+$02,+$01,+$01,+$01,+$01,+$01,+$01,+$01,+$00,+$01,+$00,+$00 ; $10 ; $00
	db +$00,+$00,-$01,+$00,-$01,-$01,-$01,-$01,-$01,-$01,-$01,-$02,-$01,-$02,-$01,-$02 ; $20 ; $10
	db -$02,-$01,-$02,-$01,-$02,-$01,-$01,-$01,-$01,-$01,-$01,-$01,+$00,-$01,+$00,+$00 ; $30 ; $20
	db +$00,+$00,+$01,+$00,+$01,+$01,+$01,+$01,+$01,+$01,+$01,+$02,+$01,+$02,+$01,+$02 ;     ; $30

; =============== Wpn_ShootTypeTbl ===============
; Shooting animations used by the player for each weapon.
Wpn_ShootTypeTbl: 
	db PSA_SHOOT ; WPN_P  
	db PSA_SHOOT ; WPN_RC 
	db PSA_SHOOT ; WPN_RM 
	db PSA_SHOOT ; WPN_RJ 
	db PSA_NONE  ; WPN_TP 
	db PSA_THROW ; WPN_AR 
	db PSA_NONE  ; WPN_WD 
	db PSA_THROW ; WPN_ME ; [TCRF] The correct value, unreferenced because for some reason the Metal Blade ctrl code doesn't go through WpnCtrlS_StartShootAnim
	db PSA_THROW ; WPN_CR 
	db PSA_SHOOT ; WPN_NE 
	db PSA_SHOOT ; WPN_HA 
	db PSA_SHOOT ; WPN_MG 
	db PSA_SHOOT ; WPN_SG 

; =============== Wpn_PropTbl ===============
; Weapon properties table, indexed by weapon ID.
; Each entry is 4 bytes long.
;
; FORMAT
; - 0: Collision box, horizontal radius (origin: center)
; - 1: Collision box, vertical radius (origin: center)
; - 2: Ammo cost, out of $98.
;      Most weapons use up ammo (ie: call WpnS_UseAmmo) when firing them, but nothing 
;      prevents you from using different logic, which a few of the weapons do.
; - 3: "Piercing level" of the current weapon (WPNPIERCE_*)
Wpn_PropTbl:
	;  H    V   COST  PIERCE LEVEL      ; ID     ; Use ammo when...
	db $02, $02, $00, WPNPIERCE_NONE    ; WPN_P  ; N/A
	db $02, $02, $18, WPNPIERCE_NONE    ; WPN_RC ; Jumping on it
	db $02, $02, $01, WPNPIERCE_NONE    ; WPN_RM ; 1 unit / 16 frames while riding it
	db $02, $02, $01, WPNPIERCE_NONE    ; WPN_RJ ; 1 unit / 8 frames while riding it
	db $08, $0C, $08, WPNPIERCE_ALWAYS  ; WPN_TP ; On contact with an enemy weak to it
	db $06, $06, $10, WPNPIERCE_NONE    ; WPN_AR ; Firing
	db $06, $06, $18, WPNPIERCE_ALWAYS  ; WPN_WD ; Thrown
	db $06, $06, $02, WPNPIERCE_LASTHIT ; WPN_ME ; Firing
	db $06, $06, $20, WPNPIERCE_NONE    ; WPN_CR ; Firing
	db $06, $03, $02, WPNPIERCE_NONE    ; WPN_NE ; Firing
	db $06, $03, $10, WPNPIERCE_LASTHIT ; WPN_HA ; Firing
	db $06, $06, $10, WPNPIERCE_NONE    ; WPN_MG ; Firing
	db $03, $03, $01, WPNPIERCE_NONE    ; WPN_SG ; 1 unit / 4 frames while riding it
	
; =============== Module_Password ===============
; Password input screen.
; OUT
; - C flag: If set, the password is invalid.
Module_Password:
	;--
	;
	; Load VRAM
	;
	
	ld   a, GFXSET_PASSWORD
	call GFXSet_Load
	
	; This is using the tilemap loader instead of performing a proper GFX load request,
	; since there's only one tile to load and it fits within the limit.
	ld   de, GfxDef_PasswordCursor
	call LoadTilemapDef
	
	ld   de, TilemapDef_Password
	call LoadTilemapDef
	call StartLCDOperation
	
	;--
	ld   a, BGM_PASSWORD
	ldh  [hBGMSet], a
	
	;
	; Init memory
	;
	
	; Reset cursor pos
	xor  a
	ld   [wPassCursorX], a
	ld   [wPassCursorY], a
	
	; Clear all 16 dots from the selection table
	ld   hl, wPassSelTbl
	ld   b, wPassSelTbl_End-wPassSelTbl
.clrDotLoop:
	ldi  [hl], a
	dec  b
	jr   nz, .clrDotLoop
	
	; Set up the four sprites thar make up the cursor.
	ld   a, $00
	ld   [wPassCursorULObj+iObjTileId], a
	ld   [wPassCursorURObj+iObjTileId], a
	ld   [wPassCursorDLObj+iObjTileId], a
	ld   [wPassCursorDRObj+iObjTileId], a
	xor  a
	ld   [wPassCursorULObj+iObjAttr], a ; 0
	xor  SPR_XFLIP
	ld   [wPassCursorURObj+iObjAttr], a	; SPR_XFLIP
	xor  SPR_YFLIP|SPR_XFLIP
	ld   [wPassCursorDLObj+iObjAttr], a	; SPR_YFLIP
	xor  SPR_XFLIP
	ld   [wPassCursorDRObj+iObjAttr], a	; SPR_YFLIP|SPR_XFLIP
	
	;
	; MAIN LOOP
	;
	
.loop:
	;
	; Update the cursor's sprite position depending on the current selection.
	; The cursor has four different sprites 8px apart from each other, one for each corner. 
	; Their relative positioning is handled manually rather than going with sprite mappings.
	;

	; YPos = $2C + (wPassCursorY * $10)
	ld   a, [wPassCursorY]
	swap a
	add  $2C ; Top
	ld   [wPassCursorULObj+iObjY], a
	ld   [wPassCursorURObj+iObjY], a
	add  $08 ; Bottom
	ld   [wPassCursorDLObj+iObjY], a
	ld   [wPassCursorDRObj+iObjY], a
	; XPos = $3C + (wPassCursorY * $10)
	ld   a, [wPassCursorX]
	swap a
	add  $3C ; Left
	ld   [wPassCursorULObj+iObjX], a
	ld   [wPassCursorDLObj+iObjX], a
	add  $08 ; Right
	ld   [wPassCursorURObj+iObjX], a
	ld   [wPassCursorDRObj+iObjX], a
	
	
.inputLoop:
	rst  $08 ; Wait Frame
	
	; Check for input
	call JoyKeys_Refresh
	
	; If none of the keys we're looking for were pressed, wait for new keys
	ldh  a, [hJoyNewKeys]
	and  KEY_DOWN|KEY_UP|KEY_LEFT|KEY_RIGHT|KEY_START|KEY_A
	jr   z, .inputLoop
	
	ldh  a, [hJoyNewKeys]
	bit  KEYB_A, a		; Pressed A?
	jr   nz, .toggleSel	; If so, toggle the current dot
	bit  KEYB_START, a	; Pressed START?
	jr   nz, .validate	; If so, validate the password
	
.chkMove:
	; Otherwise, we're moving the cursor.

	; Good SFX reuse
	push af
		ld   a, SFX_BOSSBAR
		ldh  [hSFXSet], a
	pop  af
	
	; Which direction we're moving to?
	; This goes off the four direction bits being stored in the upper nybble,
	; so we can push them out to the carry one by one.
	rla  				; Pressed DOWN?
	jr   c, .moveD		; If so, jump
	rla  				; Pressed UP?
	jr   c, .moveU		; If so, jump
	rla  				; Pressed LEFT?
	jr   c, .moveL		; If so, jump
.moveR:					; Otherwise, we pressed RIGHT
	; Regardless of direction, the movement logic is the same: inc/dec X/Y, then modulo 4.
	ld   a, [wPassCursorX]
	inc  a
	and  $03
	ld   [wPassCursorX], a
	jr   .loop
.moveL:
	ld   a, [wPassCursorX]
	dec  a
	and  $03
	ld   [wPassCursorX], a
	jr   .loop
.moveD:
	ld   a, [wPassCursorY]
	inc  a
	and  $03
	ld   [wPassCursorY], a
	jr   .loop
.moveU:
	ld   a, [wPassCursorY]
	dec  a
	and  $03
	ld   [wPassCursorY], a
	jr   .loop
	
.toggleSel:
	;
	; Play toggle sound
	;
	ld   a, SFX_SHOOT
	ldh  [hSFXSet], a
	
	;
	; Toggle the selection
	;
	
	; Create index to the dot table from the coords
	; A = wPassCursorY * 4 + wPassCursorX
	ld   hl, wPassCursorY
	ldd  a, [hl]		; A = wPassCursorY, seek to wPassCursorX
	add  a				; A *= 4
	add  a
	or   [hl]			; A += wPassCursorX
	ld   e, a			; Save to E for later
	
	; Index the dot table with it
	ld   hl, wPassSelTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	
	; Do toggle the selection
	ld   a, [hl]
	xor  $FF			; Also updates the Z flag, used for the upcoming check
	ld   [hl], a
	
	;
	; Request a screen update by building a TilemapDef and triggering it.
	; It will take effect on the next VBlank.
	;
	
	; Pick which tile to draw
	ld   b, $1D			; B = Blank tile
	jr   z, .setSelTile	; Did we just clear the dot (Z flag set)? If so, jump 
	ld   b, $02			; Otherwise, B = Selected tile
.setSelTile:

	; Map the dot ID to its respective tilemap pointer
	ld   hl, Password_SelTilemapPtrTbl	; HL = Table base
	ld   d, $00			; DE = E * 2
	sla  e
	add  hl, de			; HL = Ptr to Big endian tilemap ptr
	
	; bytes0-1: Big endian pointer
	ld   de, wTilemapBuf	; DE = Destination
	call CopyWord			
	
	; byte2: Flags + Byte count
	ld   a, $01				; Only one tile to copy
	ld   [de], a
	inc  de
	
	; byte3: Payload (the single tile ID)
	ld   a, b
	ld   [de], a
	inc  de
	
	; End terminator
	xor  a
	ld   [de], a
	
	; Trigger write with a non-zero wTilemapEv
	dec  a					; A = $FF
	ld   [wTilemapEv], a
	jp   .inputLoop
	
.validate:
	;
	; PASSWORD DECODER
	;
	; The password is 16 bits long, represented as 16 different dots, with the selection screen placing
	; each into a separate byte.
	; These separate bytes are either $00 or $FF to simplify the password entry code, and during
	; decoding they can be accumulated by shifting any bit from them to a single register.
	;
	; At the basis of this password system are groups of bits/dots and giant tables containing 
	; valid combinations for each group. It's all hardcoded!
	; The selected bits/dots do *not* represent the data directly, instead the game looks for a match inside
	; these tables. If a match is found, its *index* is treated as the data, which may be offsetted.
	;
	; The password contains the following:
	; - 4  bits: Number of E-Tanks.
	;            Makes up a single group of 4 bits.
	; - 12 bits: Unlocked Weapons.
	;            Split into 4 groups of 3 bits each, however after the value -> index mapping 
	;            only 2 bits get stored, for a total of 8 bits (wWpnUnlock0).
	;            Depending on the number of E-Tanks selected, both the group order
	;            and the valid bit combinations differ.
	;
	; There's no checksum to the password, but it *does* get validated.
	;
	
	;
	; -> E TANK COUNT
	;
	; Start with the number of E-Tanks, since it affects the bit locations 
	; used to read the rest of the data.
	;
	
	;
	; Accumulate the E Tank bits.
	;
	; B = ----A4,B2,C1,D3
	;
	ld   b, $00
	ld   a, [wPassSelTbl+iDotA4]	
	rra		; Shift in carry
	rl   b	; << to B
	ld   a, [wPassSelTbl+iDotB2]
	rra  	; and so on for the others
	rl   b
	ld   a, [wPassSelTbl+iDotC1]
	rra  
	rl   b
	ld   a, [wPassSelTbl+iDotD3]
	rra  
	rl   b
	
	;
	; Find a match for the accumulated value into Password_ETankTruthTbl.
	; If found, the index to that entry (-1) will be the number of E Tanks.
	;
	ld   hl, Password_ETankTruthTbl.end - 1					; HL = Ptr to last table entry
	ld   c, Password_ETankTruthTbl.end-Password_ETankTruthTbl	; C = Bytes left to check
.etankChkLoop:
	ldd  a, [hl]			; Read potential match, seek to prev
	cp   b					; Does it match our value?
	jr   z, .etankOk		; If so, we found it
	dec  c					; Otherwise, BytesLeft--
	jr   nz, .etankChkLoop	; Checked them all? If not, loop
	jp   .passErr			; Otherwise, the password is not valid
.etankOk:
	ld   a, c				; wETanks = C - 1
	dec  a
	ld   [wETanks], a
	
	;
	; -> WEAPONS UNLOCKED 
	;
	
	;
	; As previously mentioned, this data is split into 4 groups of 3 bits each.
	; Depending on the number of E-Tanks, these groups are processed in a different order.
	;
	; Even though the valid bit combinations differ between E-Tanks values, 
	; the same group number will always point to the same three bit positions.
	;
	
	; This order is defined into the pointer table at Password_OrderPtrTbl.
	; Index it by E-Tank count and seek HL to the retrieved pointer.
	add  a								; Index = wETanks * 2
	ld   hl, Password_OrderPtrTbl		; HL = Table base
	ld   b, $00
	ld   c, a
	add  hl, bc							; Index it
	ldi  a, [hl]						; Read the pointer out to HL
	ld   h, [hl]
	ld   l, a
	
	; HL now points to a table containing four group numbers (see below),
	; which is then immediately followed by the truth table for each group.
	
	;
	; Then, process the four groups in a loop, with BC keeping track of the index
	; to this structure.
	; If this loop ends successfully, tPassWpnError will still be 0 and wWpnUnlock0
	; will have received all 8 bits.
	;
	DEF tPassWpnError = wTmpCFE2
	xor  a					; A = 0
	ld   [tPassWpnError], a	; ErrorFlag = 0
	ld   b, a				; GroupNum = 0
	ld   c, a

.wpnLoop:
	push bc ; Save GroupNum
	push hl
	
		;
		; Shift left to D the three bits associated with the current group.
		;
		
		push bc
		push hl ; Save base OrderTable ptr
		
			; HL = Ptr to order table entry.
			; This points to a group number (will be in range $00-$03)
			add  hl, bc
			
			;
			; Seek to the dot position list for the current group (in Password_WpnDotTbl).
			; Each group is 3 dots long, so its index will be:
			; BC = GroupNum * 3
			;
			ld   a, [hl]	; Read group number
			add  a			; *= 2
			add  [hl]		; += GroupNum (*3)
			ld   c, a		; B will always be 0 anyway
			; And index it
			ld   hl, Password_WpnDotTbl
			add  hl, bc
			
			; Read out the three bits associated to this group.
			; Accumulate the 3 bits by shifting them left to D.
			; For example, assuming the group number was 0, D will contain the following:
			; D = -----A1,A2,B1
			ld   d, $00					; D = 0
			call Password_AccumSel		; << 1st dot
			call Password_AccumSel		; << 2nd dot
			call Password_AccumSel		; << 3rd dot
		pop  hl ; Restore base OrderTable ptr
		pop  bc
		
		;
		; Verify that the value we got is valid for this group.
		; If it is, the bits at ($04 - Value) will be pushed to wWpnUnlock0.
		;
		
		; Seek to the truth table.
		; There are four truth tables, one for each group, and they immediately follow the 4 bytes of the order table.
		; Therefore, given a pointer to the start of the order table...
		; TruthTbl = OrderTbl + (GroupNum * 4) + 4 
		ld   a, c
		add  a		; *2
		add  a		; *2
		add  $04	; +4
		ld   c, a
		add  hl, bc	; B is 0 as always
		
		;
		; Verify that these bits are one of the three valid combinations.
		; Similar to the E Tank validation code, except we're advancing the pointer forwards!
		;
		ld   b, $04				; B = Matches left
	.wpnChkLoop:
		ldi  a, [hl]			; Read potential match, seek to next
		cp   d					; Does it match?
		jr   z, .wpnOk			; If so, we're done
		dec  b					; Checked all matches?
		jr   nz, .wpnChkLoop	; If not, loop
		ld   a, $FF				; Otherwise, the password is invalid
		ld   [tPassWpnError], a
		jr   .chkErr
	.wpnOk:
		; Convert the remaining matches to the table index for the matched entry
		; A = 4 - B
		ld   a, $04
		sub  b
		
		; Push from the top the two bits to the weapon unlock flags.
		; Note that this is the only bitmask used here, meaning that
		; passwords won't record anything stored in wWpnUnlock1.
		ld   hl, wWpnUnlock0	; Seek to unlocked weapons 
		rra			; push bit 0 to carry
		rr   [hl]	; >> to result
		rra  		; push bit 1 to carry
		rr   [hl]	; >> to result
		
	.chkErr:
	pop  hl ; Restore base OrderTable ptr
	pop  bc ; Restore GroupNum
	
	; If any matching failed, abort
	ld   a, [tPassWpnError]
	and  a
	jr   nz, .passErr
	
	; Processed all 4 groups?
	inc  c				; GroupNum++
	ld   a, c
	cp   $04			; GroupNum < 4?
	jr   c, .wpnLoop	; If so, loop
	
	;
	; Reject invalid weapon combinations.
	; If the any of the second set of bosses is marked as defeated,
	; then the entirety of the first set must be as well.
	;
	
	ld   a, [wWpnUnlock0]
	and  WPU_MG|WPU_HA|WPU_NE|WPU_TP	; Got any of the second weapons?
	jr   z, .passOk						; If not, skip
	
	ld   a, [wWpnUnlock0]
	and  WPU_CR|WPU_ME|WPU_WD|WPU_AR	; Filter out 2nd weapons
	cp   WPU_CR|WPU_ME|WPU_WD|WPU_AR	; Did we get *all* of the first weapons?
	jr   nz, .passErr					; If not, reject ot
	
.passOk:
	call FlashBGPal
	xor  a ; C Flag clear
	ret
	
.passErr:
	; Write "PASS WORD ERROR!"
	ld   hl, TilemapDef_PasswordError
	ld   de, wTilemapBuf
	ld   bc, $0014
	call CopyMemory
	ld   a, $FF				; Trigger
	ld   [wTilemapEv], a
	; Wait for 4.25 seconds
	call WaitFrames
	scf ; C Flag set
	ret
	
; =============== Password_AccumSel ===============
; Accumulates the selection into D, shifting it in to the left.
; IN
; - D: Accumulated result
; - HL: Points to the selection number (value used to index wPassSelTbl)
Password_AccumSel:
	push af
	push hl
		; Read the specified selection
		; A = wPassSelTbl[*HL]
		ld   a, LOW(wPassSelTbl)
		add  [hl]
		ld   l, a
		ld   a, HIGH(wPassSelTbl)
		adc  $00
		ld   h, a
		ld   a, [hl]
		
		; Store the selection into the carry, by rotating a bit there.
		; These are either $00 or $FF, so the rotation direction doesn't matter.
		rra
		; Shift left the carry into the accumulated result.
		rl   d
	pop  hl
	pop  af
	; Seek to next selection number
	inc  hl
	ret
	
; =============== Password_SelTilemapPtrTbl ===============
; Table of tilemap pointers for each dot, indexed by the selection ID.
; These pointers need to be Big Endian since they are used as-is as
; part of a TilemapDef.
Password_SelTilemapPtrTbl:
	db $98,$87 ; $00
	db $98,$89 ; $01
	db $98,$8B ; $02
	db $98,$8D ; $03
	db $98,$C7 ; $04
	db $98,$C9 ; $05
	db $98,$CB ; $06
	db $98,$CD ; $07
	db $99,$07 ; $08
	db $99,$09 ; $09
	db $99,$0B ; $0A
	db $99,$0D ; $0B
	db $99,$47 ; $0C
	db $99,$49 ; $0D
	db $99,$4B ; $0E
	db $99,$4D ; $0F
	
; =============== Password_ETankTruthTbl ===============
; Truth table for E Tank bit combinations.
; Matches by value the accumulated password bits A4,B2,C1,D3 to the number of E Tanks.
; See: .etankLoop
Password_ETankTruthTbl:
	db %0000 ; 0 ;
	db %0010 ; 1 ; C1
	db %0101 ; 2 ; B2,D3
	db %1010 ; 3 ; A4,C1
	db %1011 ; 4 ; A4,C1,D3
.end:

; =============== Password_WpnDotTbl ===============
; Dot positions used to store unlocked weapons, for each group.
Password_WpnDotTbl:
	db iDotA1 ; Group $00
	db iDotA2
	db iDotB1
	db iDotA3 ; Group $01
	db iDotB3
	db iDotB4
	db iDotC2 ; Group $02
	db iDotD1
	db iDotD2
	db iDotC3 ; Group $03
	db iDotC4
	db iDotD4

; =============== Password_OrderPtrTbl ===============
; Truth & group order tables for unlocked weapon bits combinations.
; These are completely different depending on the amount of E-Tanks saved into the password.
Password_OrderPtrTbl:
	dw Password_OrderTbl0 ; 0 Tanks
	dw Password_OrderTbl1 ; 1 Tank
	dw Password_OrderTbl2 ; 2 Tanks
	dw Password_OrderTbl3 ; 3 Tanks
	dw Password_OrderTbl4 ; 4 Tanks

; --------------- Password_OrderTbl0 ---------------
; Order table used when zero E Tanks are recorded into the password.
; These four numbers right below are the group numbers -- they are multiplied by 3,
; and used to index Password_WpnDotTbl.
Password_OrderTbl0:
	db $00 ; A1,A2,B1 (bit0-1)
	db $01 ; A3,B3,B4 (bit2-3)
	db $02 ; C2,D1,D2 (bit4-5)
	db $03 ; C3,C4,D4 (bit6-7)
; Immediately following are the truth tables for each group.
.truth0: ; For the 1st group (here it's $00 | A1,A2,B1)
	db %100
	db %101
	db %011
	db %110
.truth1: ; For the 2nd group (here it's $01 | A3,B3,B4)
	db %011
	db %110
	db %100
	db %101
.truth2: ; ...
	db %001
	db %011
	db %100
	db %110
.truth3:	
	db %101
	db %011
	db %001
	db %110
	
; --------------- Password_OrderTbl1 ---------------
; Like above, but when 1 E Tank is recorded.
Password_OrderTbl1:
	db $01 ; A3,B3,B4
	db $02 ; C2,D1,D2
	db $03 ; C3,C4,D4
	db $00 ; A1,A2,B1
	
.truth0: ; For the 1st group (here it's $01 | A3,B3,B4)
	db %001
	db %110
	db %010
	db %101
.truth1: ; For the 2nd group (here it's $02 | C2,D1,D2)
	db %010
	db %011
	db %100
	db %110
.truth2: ; ...
	db %101
	db %001
	db %011
	db %100
.truth3:
	db %011
	db %100
	db %001
	db %010
	
; --------------- Password_OrderTbl2 ---------------
Password_OrderTbl2:
	db $02 ; C2,D1,D2
	db $03 ; C3,C4,D4
	db $00 ; A1,A2,B1
	db $01 ; A3,B3,B4
Password_OrderTbl2r0:
	db %001
	db %100
	db %011
	db %101
Password_OrderTbl2r1:
	db %011
	db %100
	db %010
	db %110
Password_OrderTbl2r2:
	db %001
	db %010
	db %101
	db %011
Password_OrderTbl2r3:
	db %000
	db %110
	db %100
	db %001
	
; --------------- Password_OrderTbl3 ---------------
Password_OrderTbl3:
	db $03 ; C3,C4,D4
	db $00 ; A1,A2,B1
	db $01 ; A3,B3,B4
	db $02 ; C2,D1,D2
Password_OrderTbl3r0:
	db %110
	db %010
	db %101
	db %011
Password_OrderTbl3r1:
	db %101
	db %001
	db %110
	db %100
Password_OrderTbl3r2:
	db %100
	db %011
	db %001
	db %110
Password_OrderTbl3r3:
	db %000
	db %010
	db %001
	db %011
	
; --------------- Password_OrderTbl4 ---------------
Password_OrderTbl4: 
	db $00 ; A1,A2,B1
	db $02 ; C2,D1,D2
	db $03 ; C3,C4,D4
	db $01 ; A3,B3,B4
Password_OrderTbl4r0: 
	db %010
	db %011
	db %001
	db %100
Password_OrderTbl4r1: 
	db %101
	db %010
	db %100
	db %110
Password_OrderTbl4r2: 
	db %000
	db %010
	db %011
	db %100
Password_OrderTbl4r3: 
	db %011
	db %010
	db %100
	db %110
	
SETCHARMAP generic
; =============== TilemapDef_PasswordError ===============
TilemapDef_PasswordError:
.def00:
	wd $99E2
	db $00|(.eof-.start) ; $10
.start:
	db "PASS WORD ERROR!"
.eof: db $00

; =============== GfxDef_PasswordCursor ===============
GfxDef_PasswordCursor:
.def00:
	wd $8000
	db $00|(.eof-.start) ; TILESIZE
.start:
	INCBIN "data/password/cursor_gfx.bin"
.eof: db $00

; =============== Module_PasswordView ===============
; Password display screen, used both between levels or after game overing.
; See also: Module_Password
Module_PasswordView:
	;--
	;
	; Load VRAM
	;
	ld   a, GFXSET_PASSWORD
	call GFXSet_Load
	
	;--
	; Not necessary here, we can't input anything
	ld   de, GfxDef_PasswordCursor
	call LoadTilemapDef
	;--
	
	ld   de, TilemapDef_Password			; Main password screen tilemap, shared with Module_Password
	call LoadTilemapDef
	
	ld   de, TilemapDef_PasswordKeyPrompt	; "PRESS A BUTTON" prompt
	call LoadTilemapDef
	call StartLCDOperation
	;--
	; Since this screen is reused for both winning and losing a level, no explicit BGM is set here.
	
	;
	; Init memory
	;	
	xor  a
	; Clear all 16 dots from the selection table
	ld   hl, wPassSelTbl
	ld   b, wPassSelTbl_End-wPassSelTbl
.clrDotLoop:
	ldi  [hl], a
	dec  b
	jr   nz, .clrDotLoop
	
	;
	; PASSWORD ENCODER
	;
	; This is just the decoder in reverse.
	; It's simpler since unlike the decoder, which required to find the index to a table (requiring loops),
	; all the encoder needs is indexing the same tables with the value we have.
	;
	
	;
	; -> E-TANK COUNT
	;
	; This isn't affected by anything else, so it uses the same truth table.
	; 
	
	; B = Password_ETankTruthTbl[wETanks]
	ld   a, [wETanks]
	ld   hl, Password_ETankTruthTbl	; HL = Ptr to truth table
	ld   b, $00						; B = Number of E-Tanks
	ld   c, a
	add  hl, bc						; Seek to the entry
	ld   b, [hl]					; Read the 
	
	; The bits are distributed in the opposite order they are decoded (D3,C1,B2,A4 from LSB to MSB).
	ld   a, $FF						; A = Value marking selected dots	

	; bit0 -> D3
.wrEt0:
	rr   b							; Shift out lowest bit
	jr   nc, .wrEt1					; Is it set? If not, skip (iDotD3 = $00)
	ld   [wPassSelTbl+iDotD3], a	; Otherwise iDotD3 = $FF
.wrEt1:
	; bit1 -> C1
	rr   b							; and so on for the others
	jr   nc, .wrEt2
	ld   [wPassSelTbl+iDotC1], a
.wrEt2:
	; bit2 -> B2
	rr   b
	jr   nc, .wrEt3
	ld   [wPassSelTbl+iDotB2], a
.wrEt3:
	; bit3 -> A4
	rr   b
	jr   nc, .wpnUnl
	ld   [wPassSelTbl+iDotA4], a
	
.wpnUnl:
	;
	; -> WEAPONS UNLOCKED 
	;
	; The dot positions and truth tables vary depending on the number of E-Tanks we have.
	; To save space, rather than duplicating the entire dot position list, the dots are
	; grouped, with an "order list" defines the order of these groups.
	;
	; Pick the order table to use depending in the number of E-Tanks we have.
	;
	ld   a, [wETanks]				; Index = wETanks * 2
	add  a
	ld   hl, Password_OrderPtrTbl	; HL = Table base
	ld   b, $00						
	ld   c, a
	add  hl, bc						; Index it
	ldi  a, [hl]					; Read the pointer out to HL
	ld   h, [hl]
	ld   l, a
	
	;
	; HL now points to an order table (Password_OrderTbl*), which contains the four group numbers in
	; its first four bytes, then the four truth tables, one for each group.
	;
	
	ld   a, [wWpnUnlock0]	; E = Unlocked weapons (running value, will be shifted during processing)
	ld   e, a
	xor  a
	ld   b, a				; B = 0
	ld   c, a				; GroupNum = 0 (current index into order table)
.wpnLoop:
	;
	; Process the two bits of the unlocked weapons at a time, since the truth tables are all four
	; entries long, meaning their index only uses two bits.
	;
	push bc ; Save GroupNum
	push hl ; Save base OrderTable ptr
	
		push bc ; Save GroupNum
		push hl ; Save base OrderTable ptr
		
			;
			; Map the next two weapon bits to the encoded value from the truth table.
			;
			; D = OrderTable + 4[GroupNum * 4][E % $03]
			;     + 4          -> The first truth table is 4 bytes after the order table (1 byte for each group)
			;     GroupNum * 4 -> Each group uses its own truth table, which is 4 bytes long
			;     E % $03      -> Use the lowest two bits as index to the truth table
			;
			
			ld   a, e		; A = Running value of unlocked weapons
			and  $03		; Extract lowest two bits (will be the index)
			add  $04		; HL points to the order table; the first truth table is 4 bytes after  
			ld   d, a		; Keep track of that to D
			
			ld   a, c		; Get group number
			add  a 			; *4, as each group is 4 bytes long
			add  a 			; ""
			add  d 			; Add what we calculated before
			ld   c, a		; Save to C, (B is always $00)
			
			add  hl, bc		; B is 0 as always
			ld   d, [hl]	; Read the encoded value
			
			; The encoded value is three bits long (bit0-2).
			; Password_WriteSel expects to shift them from the top (bit5-7), since it's doing the
			; opposite the decoder routine does, so...
			swap d ; << 4
			rl   d ; << 1
		pop  hl ; Restore GroupNum
		pop  bc ; Restore base OrderTable ptr
		
		
		; HL = Ptr to order table entry.
		; This points to a group number (will be in range $00-$03)
		add  hl, bc		; Seek to group ID for this entry
			
		;
		; Seek to the dot position list for the current group (in Password_WpnDotTbl).
		; Each group is 3 dots long, so its index will be:
		; BC = GroupNum * 3
		;
		ld   a, [hl]	; Read group number
		add  a			; *= 2
		add  [hl]		; += GroupNum (*3)
		ld   c, a		; B will always be 0 anyway
		; And index it
		ld   hl, Password_WpnDotTbl
		add  hl, bc
		
		; Write out the three bits from the top of D to the next three Password_WpnDotTbl entries
		call Password_WriteSel ; bit7 -> HL
		call Password_WriteSel ; bit6 -> HL + 1
		call Password_WriteSel ; bit5 -> HL + 2
		
		; Shift the next two bits in from the top
		rr   e
		rr   e
		
	pop  hl
	pop  bc ; Restore GroupNum
	
	; Processed all 4 groups?
	inc  c				; GroupNum++
	ld   a, c
	cp   $04			; GroupNum < 4?
	jr   c, .wpnLoop	; If so, loop
	
	;
	; Write the dots to the tilemap.
	;
	; This is accomplished by patching an event that writes to the grid and triggering it.
	;
	
	; Copy the event template to RAM
	ld   hl, TilemapDef_PasswordDotsTemplate
	ld   de, wTilemapBuf
	ld   bc, TilemapDef_PasswordDotsTemplate.end-TilemapDef_PasswordDotsTemplate
	call CopyMemory
	
	;
	; On its own, that event writes four grid rows, including their inner vertical borders. 
	; Thus each row is 7 tiles long, alternating tile $1D (black tile) with $12 (white vertical line).
	;
	; Our job here is to loop through wPassSelTbl and patch the respective $1D tiles with $02 (dot) whenever
	; we run into a non-zero selection.
	;
	ld   de, wPassSelTbl
	ld   hl, wTilemapBuf+iTilemapDefPayload	; Start from byte3, the first tile ID
	ld   c, $04			; C = Rows left
	
	; For every row...
.bgLoop:
	ld   b, $04			; B = Cells left in the row
	
	; For every cell...
.bgLoopRow:				
	ld   a, [de]		; Read selection/dot value ($00 or $FF)
	inc  de				; Seek to next
	and  a				; Was a dot written here? (!= $00)
	jr   z, .bgNext		; If not, skip
	ld   [hl], $02		; Otherwise, patch in the round dot tile
.bgNext:
	; Seek to next cell, which is two tiles right
	inc  hl				; Move right to vertical border tile
	inc  hl				; Move right to next cell tile
	dec  b				; Did we go over all dots in a row?
	jr   nz, .bgLoopRow	; If not, loop
	
	; Otherwise, we actually moved on byte1 of the next row (low byte of the VRAM pointer)
	; That's also two bytes apart from byte3, the payload.
	inc  hl				; Seek to flags
	inc  hl				; Seek to first byte of payload
	dec  c				; Did we process every row?
	jr   nz, .bgLoop	; If not, loop
	
	ld   a, $FF			; Otherwise, trigger the event
	ld   [wTilemapEv], a
	
	;
	; MAIN LOOP
	;
	; Nothing much to do here, after the password is drawn it's just a static screen.
	;
.main:
	rst  $08 ; Wait Frame
	call JoyKeys_Refresh
	
	; A -> Exit from password screen
	ldh  a, [hJoyNewKeys]
	rra  					; Shift KEY_A into carry
	jr   nc, .main			; Is it set? If not, keep waiting
	ret
	
; =============== Password_WriteSel ===============
; Writes the MSB into the selection (dot), shifting the remaining bits left.
; Meant to be used 8 times, to write the individual bits of the encoded
; data into 8 different dot positions.
; The opposite of Password_AccumSel.
; IN
; - D: Encoded data
; - HL: Points to the selection number (value used to index wPassSelTbl)
Password_WriteSel:
	push hl ; Save selection number
		; Shift left the MSB into the carry
		rl   d				; C Flag = MSB
		jr   nc, .next		; If the bit set? If not, don't write a dot here
		
		; Otherwise, seek to the current selection
		; HL = &wPassSelTbl[*HL]
		ld   a, LOW(wPassSelTbl)
		add  [hl]
		ld   l, a
		ld   a, HIGH(wPassSelTbl)
		adc  $00
		ld   h, a
		
		; Write $FF there (although it's just the LSB that matters)
		ld   [hl], $FF
.next:
	; Seek to next selection number
	pop  hl ; Restore selection number
	inc  hl
	ret
	
SETCHARMAP generic
TilemapDef_PasswordKeyPrompt:
.def00:
	wd $99E2
	db $00|(.eof-.start) ; $10
.start:
	db " PRESS A BUTTON "
.eof: db $00

TilemapDef_PasswordDotsTemplate: INCLUDE "data/password/dots_template_bg.asm"
.end:
TilemapDef_Password: INCLUDE "data/password/password_bg.asm"

; =============== Freeze_Do ===============
; [TCRF] Handles the freeze-frame pause feature, normally unused.
Freeze_Do:
	; The sound used when toggling this is unique to this subroutine,
	; making it normally unused.
	ld   a, SFX_FREEZETOGGLE
	ldh  [hSFXSet], a
	
	; Stay here until pressing SELECT to unpause
.loop:
	rst  $08 ; Wait frame
	call JoyKeys_Refresh
	ldh  a, [hJoyNewKeys]
	bit  KEYB_SELECT, a		; Pressed SELECT?
	jr   z, .loop			; If not, keep waiting
	
	ld   a, SFX_FREEZETOGGLE
	ldh  [hSFXSet], a
	ret
	
; =============== Game_Unused_RefillCur ===============
; [TCRF] Unreferenced code.
; Instantly refills all of the player's health and the current weapon's ammo.
; Supiciously located after the freeze frame handler.
Game_Unused_RefillCur:
	
	ld   a, BAR_MAX			; Fully refill...
	ld   [wPlHealth], a		; ... our health
	ld   [wWpnAmmoCur], a	; ... the current weapon's ammo
	
	ld   a, [wPlHealth]		; Redraw the health bar
	ld   c, $00
	call Game_AddBarDrawEv
	
	ld   a, [wWpnId]		; If a weapon is selected...
	or   a
	jr   z, .exec
	ld   a, [wWpnAmmoCur]	; ...redraw the weapon bar too
	ld   c, $01
	call Game_AddBarDrawEv
	
.exec:
	rst  $18 ; Wait bar update
	ret
	
; =============== Module_WilyStationCutscene ===============
; Cutscene showing Wily escaping from the Castle into the Station.
Module_WilyStationCutscene:

WilyStation_Sc1:
	;
	; SCENE 1
	;
	; Wily flies away from the Castle.
	;
	call WilyCastle_LoadVRAM
	call StartLCDOperation
	ld   a, BGM_WILYCASTLE
	ldh  [hBGMSet], a
	
	; Wait for 2 seconds
	ld   a, 60*2
	call WaitFrames
	
	; Don't flip any sprites
	xor  a
	ld   [wScBaseSprFlags], a
	
	;
	; Spawn Wily's spaceship.
	; This does not use the normal actor system, instead it has its own version specific to cutscenes,
	; where everything is spawned/handled manually and expects to be loaded to fixed slots.
	;
	DEF tActWily = wScAct0
	ld   hl, tActWily
	xor  a
	; The spaceship spawns from one of the skull's eyes.
	; Y Position: $70
	ldi  [hl], a ; iScActYSub
	ld   a, OBJ_OFFSET_Y+$60
	ldi  [hl], a ; iScActY
	; X Position: $40
	xor  a
	ldi  [hl], a ; iScActXSub
	ld   a, OBJ_OFFSET_X+$38
	ldi  [hl], a ; iScActX
	; Vertical speed: 0.25px/frame up
	ld   bc, -$0040
	ld   [hl], c ; iScActSpdYSub = $C0
	inc  hl
	ld   [hl], b ; iScActSpdY = $FF
	inc  hl
	; Horizontal speed: Calculated later
	xor  a
	ldi  [hl], a ; iScActSpdXSub = $00
	ldi  [hl], a ; iScActSpdX = $00
	
	; Start at the first hotspot
	ldi  [hl], a ; wScWilyArcIdx
	ld   [wScWilyHotspotNum], a
	
.nextHotspot:	
	;
	; Wily's Spaceship moves back and forth horizontally in a sine wave pattern.
	;
	; To do this, we're reusing the sine arc table (ActS_ArcPathTbl) to gradually speed up and down,
	; using a small arc (advancing the index twice, akipping half of the values)
	; As the values for speeding up and down can be mirrored, only half of them are defined in the table.
	; 
	; With Wily starting from the center, that means we have the following hotspots (wScWilyHotspotNum):
	;  ID |    POS |   DIR | SPEED
	; $00 | Center | Right |  Down
	; $01 |  Right |  Left |    Up
	; $02 | Center |  Left |  Down
	; $03 |   Left | Right |    Up
	; [loops]
	; 
	; Notice the direction changing every 2 hotspots, but offset by 1 since we're starting from the center,
	; while the speed changes every other hotspot.
	;
	
	
	; Calculate the high byte of the speed (pixel speed), from the hotspot number.
	; As we're moving slower than 1px/frame, this directly maps to the hotspot direction:
	; - $00 when moving right
	; - $FF when moving left
	ld   a, [wScWilyHotspotNum]
	dec  a				; -1 as we start from the center
	rrca				; /2 as the direction changes every 2 hotspots
	and  $01			; %2 as "" (right -> $01, left -> $00)
	dec  a				; Shift the result down (right -> $00, left -> $FF)
	ld   [tActWily+iScActSpdX], a
	
	; After $2D frames we reach the next hotspot.
	; As we're advancing indexes twice each time, that's the half of the length of the path table (+1)
	DEF TURNTIMER = (ActS_ArcPathTbl.end-ActS_ArcPathTbl)/2 + 1
	ld   a, TURNTIMER
	ld   [wScWilyArcLeft], a
	
.sineLoop:

	;--
	;
	; DRAW SPRITES
	;

	xor  a				; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	; Draw the small Wily Spaceship.
	; Even though multiple sizes exist, the game only ever draws the third one.
	ld   a, [tActWily+iScActY]
	ld   [wTargetRelY], a
	ld   a, [tActWily+iScActX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScWilyShipSm
	ld   a, $02
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; UPDATE HORIZONTAL SPEED
	;
	; In practice:
	; - If speeding up, wScWilyArcIdx += 2
	; - If speeding down, wScWilyArcIdx -= 2
	; Then the speed is read from ActS_ArcPathTbl[wScWilyArcIdx], and adjusted for the current direction.
	; As wScWilyArcIdx doesn't get reset between hotspots and speeding up is alternated with speeding down,
	; the index will move back and forth from $00 to $58 without going out of range.
	;
	; The way the wScWilyArcIdx is updated is more complicated than it has any right to be.
	; Instead of precalculating the offset (+2 or -2) into a separate variable before .sineLoop and just updating the index by that,
	; *every frame* it does two sets of calculations:
	; - One that only returns +2 on even hotspots
	; - One that only returns -2 on odd hotspots
	; Worth noting the +2 happens only after moving Wily, meaning outdated values are used when moving right.
	;
	
	;--
	; On odd hotspots, decrement the index by -2.
	; When (wScWilyHotspotNum % 2) == 1 -> wScWilyArcIdx -= 2
	ld   a, [wScWilyHotspotNum]
	inc  a		; +1 as we start from the center (and inverts odd/even)
	and  $01	; %2 as speed dir changes every other hotspot (odd: $00, even: $01)
	dec  a		; -1 for decrementing the index (odd: $FF, even: $00)
	add  a		; *2 as we skip speed (odd: $FE, even: $00)
	; wScWilyArcIdx += A
	ld   hl, wScWilyArcIdx
	add  [hl]	; Only does anything in the odd case
	ld   [hl], a
	;--
	
	; Seek HL to the current speed
	ld   hl, ActS_ArcPathTbl	; HL = ActS_ArcPathTbl
	ld   a, [wScWilyArcIdx]
	ld   b, $00					; BC = wScWilyArcIdx
	ld   c, a
	add  hl, bc					; Seek to HL[BC]
	
	; The speed read from the table is relative to moving right.
	; When moving left, it needs to be reversed since there's no concept of directions here.
	; Since iScActSpdX is guaranteed to be either $00 or $FF, xoring the read value with that mostly works out:
	; - When moving right it will be $00, so the speed value is untouched.
	; - When moving left it will be $FF, so the speed value is reversed.
	;   However, not doing the mandatory "inc a" means Wily will gradually drift over to the left.
	ld   a, [tActWily+iScActSpdX]
	xor  [hl]
	ld   [tActWily+iScActSpdXSub], a
	
	;
	; MOVE WILY
	;
	ld   hl, tActWily			; Move the Wily actor
	call ScAct_ApplySpeed
	
	; When Wily's Spaceship nearly moves offscreen above, advance to the next scene
	ld   a, [tActWily+iScActY]
	cp   OBJ_OFFSET_Y+$08		; iScActY == $18?
	jr   z, WilyStation_Sc2		; If so, jump
	
	;
	; TICK TIMERS
	;
	
	;--
	; On even hotspots, increment the index by +2.
	; The same as the the one for -2, except we never decremented the result so it increases it.
	; When (wScWilyHotspotNum % 2) == 0, wScWilyArcIdx += 2
	ld   a, [wScWilyHotspotNum]
	inc  a		; +1 as we start from the center (and inverts odd/even)
	and  $01	; %2 as speed dir changes every other hotspot (odd: $00, even: $01)
	add  a		; *2 as we skip speed (odd: $00, even: $02)
	; wScWilyArcIdx += A
	ld   hl, wScWilyArcIdx
	add  [hl]	; Only does anything in the even case
	ld   [hl], a
	;--
	
	ld   hl, wScWilyArcLeft
	dec  [hl]					; Reached the next hotspot?
	jr   nz, .sineLoop			; If not, loop
	
	ld   hl, wScWilyHotspotNum
	inc  [hl]					; Increment hotspot number
	jr   .nextHotspot			; Recalculate direction
	
WilyStation_Sc2:
	;
	; SCENE 2
	;
	; Wily flies into the Station.
	;
	call WilyStation_LoadVRAM
	call StartLCDOperation
	
	; Wait for 2 seconds
	ld   a, 60*2
	call WaitFrames
	
	;
	; Spawn Wily's spaceship.
	; The spaceship is handled like in the first scene, except there's no looping logic.
	; Every hotspot has its own code, leading to big copypaste.
	;
	DEF tActWily = wScAct0
	ld   hl, tActWily
	xor  a
	; The spaceship spawns from offscreen below
	; Y Position: $98
	ldi  [hl], a ; iScActYSub
	ld   a, OBJ_OFFSET_Y+$88
	ldi  [hl], a ; iScActY
	; X Position: $40
	xor  a
	ldi  [hl], a ; iScActXSub
	ld   a, OBJ_OFFSET_X+$38
	ldi  [hl], a ; iScActX
	; Vertical speed: 0.25px/frame up
	ld   bc, -$0040
	ld   [hl], c ; iScActSpdYSub = $C0
	inc  hl
	ld   [hl], b ; iScActSpdY = $FF
	inc  hl
	; Horizontal speed: Calculated later
	xor  a
	ldi  [hl], a ; iScActSpdXSub = $00
	ldi  [hl], a ; iScActSpdX = $00
	; Start from start of the arc
	ldi  [hl], a ; wScWilyArcIdx
	
	;##
	;
	; SCENE 2a - Move Wily left, slowing down
	;	
	
	; Start moving left
	ld   a, $FF
	ld   [tActWily+iScActSpdX], a
	ld   a, TURNTIMER
	ld   [wScWilyArcLeft], a
	
.loopL0:
	;--
	;
	; DRAW SPRITES
	;

	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	; Draw the small Wily Spaceship.
	ld   a, [tActWily+iScActY]
	ld   [wTargetRelY], a
	ld   a, [tActWily+iScActX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScWilyShipSm
	ld   a, $02
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; MOVE WILY
	;
	
	; Use horizontal speed from ActS_ArcPathTbl[wScWilyArcIdx]
	ld   hl, ActS_ArcPathTbl	; HL = ActS_ArcPathTbl
	ld   a, [wScWilyArcIdx]
	ld   b, $00					; BC = wScWilyArcIdx
	ld   c, a
	add  hl, bc					; Seek to HL[BC]
	ld   a, [hl]				; Read entry
	xor  $FF					; Reverse speed for moving left
	ld   [tActWily+iScActSpdXSub], a
	
	; Move the Wily actor
	ld   hl, tActWily
	call ScAct_ApplySpeed
	
	; Slow down over time
	ld   hl, wScWilyArcIdx		; wScWilyArcIdx++
	inc  [hl]
	inc  [hl]
	
	;
	; TICK TIMERS
	;
	
	ld   hl, wScWilyArcLeft
	dec  [hl]					; Reached the next hotspot?
	jr   nz, .loopL0			; If not, loop
	
	;##
	;
	; SCENE 2b - Move Wily right, at double speed, speeding up
	;
	
	ld   a, TURNTIMER
	ld   [wScWilyArcLeft], a
.loopR0:
	;--
	;
	; DRAW SPRITES
	;

	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	; Draw the small Wily Spaceship.
	ld   a, [tActWily+iScActY]
	ld   [wTargetRelY], a
	ld   a, [tActWily+iScActX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScWilyShipSm
	ld   a, $02
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; MOVE WILY
	;
	
	; Speed up over time
	ld   hl, wScWilyArcIdx	; wScWilyArcIdx -= 2
	dec  [hl]
	dec  [hl]
	
	; Use horizontal speed
	; iScActSpdX* = ActS_ArcPathTbl[wScWilyArcIdx] * 2
	ld   a, [hl]
	ld   hl, ActS_ArcPathTbl	; HL = ActS_ArcPathTbl
	ld   b, $00					; BC = wScWilyArcIdx
	ld   c, a
	add  hl, bc					; Index it
	; The *2 means we can go faster than 1px/frame, so also set iScActSpdX
	ld   l, [hl]				; Read byte to HL
	ld   h, $00
	add  hl, hl					; *2, for double speed
	ld   a, l
	ld   [tActWily+iScActSpdXSub], a
	ld   a, h
	ld   [tActWily+iScActSpdX], a
	
	; Move the Wily actor
	ld   hl, tActWily
	call ScAct_ApplySpeed
	
	;
	; TICK TIMERS
	;
	
	ld   hl, wScWilyArcLeft
	dec  [hl]					; Reached the next hotspot?
	jr   nz, .loopR0			; If not, loop
	
	;##
	;
	; SCENE 2c - Move Wily right, at double speed, slowing down
	;
	ld   a, TURNTIMER
	ld   [wScWilyArcLeft], a
.loopR1:
	;--
	;
	; DRAW SPRITES
	;

	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	; Draw the small Wily Spaceship.
	ld   a, [tActWily+iScActY]
	ld   [wTargetRelY], a
	ld   a, [tActWily+iScActX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScWilyShipSm
	ld   a, $02
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; MOVE WILY
	;
	
	; Use horizontal speed
	; iScActSpdX* = ActS_ArcPathTbl[wScWilyArcIdx] * 2
	ld   hl, ActS_ArcPathTbl	; HL = ActS_ArcPathTbl
	ld   a, [wScWilyArcIdx]
	ld   b, $00					; BC = wScWilyArcIdx
	ld   c, a
	add  hl, bc					; Index it
	; The *2 means we can go faster than 1px/frame, so also set iScActSpdX
	ld   l, [hl]				; Read byte to HL
	ld   h, $00
	add  hl, hl					; *2, for double speed
	ld   a, l
	ld   [tActWily+iScActSpdXSub], a
	ld   a, h
	ld   [tActWily+iScActSpdX], a
	
	; Move the Wily actor
	ld   hl, tActWily
	call ScAct_ApplySpeed
	
	; Slow down over time
	ld   hl, wScWilyArcIdx		; wScWilyArcIdx++
	inc  [hl]
	inc  [hl]
	
	;
	; TICK TIMERS
	;
	
	ld   hl, wScWilyArcLeft
	dec  [hl]					; Reached the next hotspot?
	jr   nz, .loopR1			; If not, loop
	
	;##
	;
	; SCENE 2d - Move Wily left, speeding up
	;
	
	; Start moving left
	ld   a, $FF
	ld   [tActWily+iScActSpdX], a
	ld   a, TURNTIMER
	ld   [wScWilyArcLeft], a
.loopL1:
	; Speed up over time
	ld   hl, wScWilyArcIdx	; wScWilyArcIdx -= 2
	dec  [hl]
	dec  [hl]
	
	;--
	;
	; DRAW SPRITES
	;

	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	; Draw the small Wily Spaceship.
	ld   a, [tActWily+iScActY]
	ld   [wTargetRelY], a
	ld   a, [tActWily+iScActX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScWilyShipSm
	ld   a, $02
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; MOVE WILY
	;
	
	; Use horizontal speed from ActS_ArcPathTbl[wScWilyArcIdx]
	ld   hl, ActS_ArcPathTbl	; HL = ActS_ArcPathTbl
	ld   a, [wScWilyArcIdx]
	ld   b, $00					; BC = wScWilyArcIdx
	ld   c, a
	add  hl, bc					; Seek to HL[BC]
	ld   a, [hl]				; Read entry
	xor  $FF					; Reverse speed for moving left
	ld   [tActWily+iScActSpdXSub], a
	
	; Move the Wily actor
	ld   hl, tActWily
	call ScAct_ApplySpeed
	
	;
	; TICK TIMERS
	;
	
	ld   hl, wScWilyArcLeft
	dec  [hl]					; Reached the next hotspot?
	jr   nz, .loopL1			; If not, loop
	
	;##
	;
	; SCENE 2e - Wily entered through the skull's eye.
	;            Display the spaceship without drawing Wily for 2 seconds.
	;
	
	; Delete Wily sprite
	xor  a
	ldh  [hWorkOAMPos], a
	call OAM_ClearRest
	; Apply changes
	rst  $08 ; Wait Frame
	
	; Wait for 2 seconds
	ld   a, 60*2
	call WaitFrames
	
WilyStation_Sc3:
	;
	; SCENE 3
	;
	; Rockman enters the Wily Station from the main entrance.
	;
	
	ld   a, GFXSET_SPACE
	call GFXSet_Load
	ld   de, TilemapDef_WilyStationEntrance
	call LoadTilemapDef
	; Put the entrance offscreen to the right
	ld   a, $F0
	ldh  [hScrollX], a
	call StartLCDOperation
	;--
	
	;
	; SCENE 3a - Move Rockman right until the screen is about to scroll
	;
	
	; Set spawn coordinates for the player.
	; As this is the only sprite in this scene, its coordinates are directly written to wTargetRel*
	ld   a, OBJ_OFFSET_Y+$70	; Y position: $80 (around the bottom)
	ld   [wTargetRelY], a
	ld   a, OBJ_OFFSET_X-$08	; X position: $00 (offscreen left)
	ld   [wTargetRelX], a
.loopA:
	;--
	;
	; DRAW SPRITES
	;	
	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a

	
	; Draw Rush Marine with Rockman inside.
	ld   hl, SprMapPtrTbl_ScPl
	xor  a
	call Sc_DrawSprMap
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; MOVE PLAYER
	;	
	
	; Move player 1px/frame right
	ld   a, [wTargetRelX]	; PlX++
	inc  a
	ld   [wTargetRelX], a
	cp   $40				; Reached X position $40?
	jr   nz, .loopA			; If not, loop
	
	;##
	;
	; SCENE 3b - Scroll the entrance to the Wily Station into view
	;
	
	; Sync over the current player location
	ld   hl, wScSt3PlY
	ld   a, [wTargetRelY]		; wScSt3PlY = wTargetRelY
	ldi  [hl], a
	ld   a, [wTargetRelX]		; wScSt3PlX = wTargetRelX
	ldi  [hl], a
	; Set initial jaw location (offscreen, right)
	ld   a, OBJ_OFFSET_Y+$78	; wScSt3SkullJawY
	ldi  [hl], a
	ld   a, OBJ_OFFSET_X+$C8	; wScSt3SkullJawX
	ld   [hl], a
.loopB:
	;--
	;
	; DRAW SPRITES
	;	
	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a

	; Draw Rush Marine with Rockman inside
	ld   a, [wScSt3PlY]
	ld   [wTargetRelY], a
	ld   a, [wScSt3PlX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScPl
	xor  a
	call Sc_DrawSprMap
	
	; Draw Wily Station entrance
	ld   a, [wScSt3SkullJawY]
	ld   [wTargetRelY], a
	ld   a, [wScSt3SkullJawX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScSkullJaw
	xor  a
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; LOGIC
	;
	
	; Scroll screen 1px/frame to the right.
	; This scrolls in the entrance to the Wily Station from the right.
	ld   hl, wScSt3SkullJawX	; Move door sprite left to account for scrolling
	dec  [hl]
	ld   hl, hScrollX			; Move viewport right
	inc  [hl]
	; (Don't move the player)
	
	ldh  a, [hScrollX]
	cp   $21					; Reached the target scroll position?
	jr   nz, .loopB				; If not, loop
	
	;
	; SCENE 3c - Move the player right, while opening the entrance
	;
.loopC:
	;--
	;
	; DRAW SPRITES
	;	
	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a

	; Draw Rush Marine with Rockman inside
	ld   a, [wScSt3PlY]
	ld   [wTargetRelY], a
	ld   a, [wScSt3PlX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScPl
	xor  a
	call Sc_DrawSprMap
	
	; Draw Wily Station entrance
	ld   a, [wScSt3SkullJawY]
	ld   [wTargetRelY], a
	ld   a, [wScSt3SkullJawX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScSkullJaw
	xor  a
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; LOGIC
	;
	
	; Move down the entrance jaw 1px/frame until it fully opens.
	ld   a, [wScSt3SkullJawY]	; Get Y pos
	cp   OBJ_OFFSET_Y+$90		; C Flag = Y Position < $A0
	adc  $00					; Move 1px down if it was
	ld   [wScSt3SkullJawY], a	; Save back
	
	; Move player right 1px/frame until it fully goes offscreen
	ld   a, [wScSt3PlX]			; PlX++
	inc  a
	ld   [wScSt3PlX], a
	cp   OBJ_OFFSET_X+$B8		; Reached offscreen?
	jr   nz, .loopC				; If not, loop
	
	;
	; SCENE 3d - Close the entrance
	;
.loopD:
	;--
	;
	; DRAW SPRITES
	;	
	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a

	; Draw Rush Marine with Rockman inside
	; Not necessary as it's fully offscreen
	ld   a, [wScSt3PlY]
	ld   [wTargetRelY], a
	ld   a, [wScSt3PlX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScPl
	xor  a
	call Sc_DrawSprMap
	
	; Draw Wily Station entrance
	ld   a, [wScSt3SkullJawY]
	ld   [wTargetRelY], a
	ld   a, [wScSt3SkullJawX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScSkullJaw
	xor  a
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; LOGIC
	;
	
	; Move back up the entrance jaw 1px/frame to its original position
	ld   a, [wScSt3SkullJawY]	; JawY--
	dec  a
	ld   [wScSt3SkullJawY], a
	cp   OBJ_OFFSET_Y+$78		; Moved up to Y position $88?
	jr   nz, .loopD				; If not, loop
	
	;
	; SCENE 3e - Wait 3 seconds before ending the cutscene
	;
	ld   a, 60*3
	call WaitFrames
	ret
	
; =============== WilyStation_Unused_DrawWily ===============
; [TCRF] Unreferenced subroutine to draw Wily's Spaceship, identically to how it happens in the 1st and 2nd scenes.
;        Would have been useful to cut down on code duplication in there.
WilyStation_Unused_DrawWily: 
	;--
	;
	; DRAW SPRITES
	;

	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	; Draw the small Wily Spaceship.
	ld   a, [tActWily+iScActY]
	ld   [wTargetRelY], a
	ld   a, [tActWily+iScActX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScWilyShipSm
	ld   a, $02
	call Sc_DrawSprMap
	
	jp   OAM_ClearRest		; Done drawing

; =============== Module_Ending ===============
; Ending cutscene.
Module_Ending:
	
Ending_Sc1:
	;
	; SCENE 1
	;
	; Wily escapes from the station, with Rockman chasing him and shooting him down.
	;
	
	; Load the space scene
	ld   a, GFXSET_SPACE
	call GFXSet_Load
	
	ld   de, TilemapDef_WilyStationEntrance
	call LoadTilemapDef
	; Make entrance visible on the right side of the screen
	ld   a, $20
	ldh  [hScrollX], a
	call StartLCDOperation
	
	; Load the same explosion graphics used in the Wily Castle cutscene, at the same address.
	; A consequence is that GFXSET_SPACE will need to be reloaded when moving to the 2nd scene.
	ld   hl, GFX_Wpn_MeNe ; Source GFX ptr
	ld   de, $8500 ; VRAM Destination ptr
	ld   bc, (BANK(GFX_Wpn_MeNe) << 8)|$08 ; B = Source GFX bank number (BANK $02) C = Number of tiles to copy
	call GfxCopy_Req

	ld   a, BGM_TITLE
	ldh  [hBGMSet], a
	
	;
	; Spawn the two actors.
	; During the course of this sequence, until Wily explodes, only two will ever be visible
	; on screen at the same time, so that's how many we need.
	;
	
	; Wily and the Player use the same slot (can't have them both onscreen)
	DEF tActWily     = wScAct0
	DEF tActPl       = wScAct0
	; The entrance and the missile use the same slot 
	DEF tActSkullJaw = wScAct1
	DEF tActMissile  = wScAct1
	
	; WILY SPACESHIP
	ld   hl, tActWily
	xor  a
	ld   de, ((OBJ_OFFSET_Y+$70) << 8)|(OBJ_OFFSET_X+$B8)
	; Y position: $80 (around bottom)
	ldi  [hl], a ; iScActYSub
	ld   [hl], d ; iScActY
	inc  hl
	; X position: $C0 (offscreen right)
	ldi  [hl], a ; iScActXSub
	ld   [hl], e ; iScActX
	inc  hl
	ldi  [hl], a ; iScActSpdYSub
	ldi  [hl], a ; iScActSpdY
	ldi  [hl], a ; iScActSpdXSub
	ldi  [hl], a ; iScActSpdX
	
	; ENTRANCE DOOR
	ld   de, ((OBJ_OFFSET_Y+$78) << 8)|(OBJ_OFFSET_X+$98)
	; Y position: $88 (around bottom)
	ldi  [hl], a ; iScActYSub
	ld   [hl], d ; iScActY
	inc  hl
	; X position: $A8 (right)
	ldi  [hl], a ; iScActXSub
	ld   [hl], e ; iScActX
	inc  hl
	ldi  [hl], a ; iScActSpdYSub
	ldi  [hl], a ; iScActSpdY
	ldi  [hl], a ; iScActSpdXSub
	ldi  [hl], a ; iScActSpdX
	
	; MISC INIT 
	ldi  [hl], a ; wScEd1ScrollSpdX
	ldi  [hl], a ; wScEd1FramesLeft
	ldi  [hl], a ; wScAct0SprMapBaseId
	ldi  [hl], a ; wScAct1SprMapBaseId
	ldi  [hl], a ; wScEvSrcPtr_Low
	ldi  [hl], a ; wScEvSrcPtr_High
	ldi  [hl], a ; wScEvEna
	ldi  [hl], a ; $CD05
	
	;
	; SCENE 1a - Open the entrance skull
	;
	ld   a, $01				; Move 1px/frame down
	ld   [tActSkullJaw+iScActSpdY], a
	ld   a, $18				; For 24 frames
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	;
	; SCENE 1b - Make Wily escape
	;
	ld   a, -$02			; Move Wily 2px/frame left
	ld   [tActWily+iScActSpdX], a
	ld   a, $00				; Keep entrance opened
	ld   [tActSkullJaw+iScActSpdY], a
	ld   a, $02				; Use Wily Sprite
	ld   [wScAct0SprMapBaseId], a
	ld   a, $70				; For ~2 seconds (enough to move from offscreen right to offscreen left)
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	;
	; SCENE 1c - Make Rockman escape #1
	;            Scroll screen, pre-redraw.
	;	
	ld   a, OBJ_OFFSET_X+$A8	; Start offscreen right
	ld   [tActPl+iScActX], a
	ld   a, LOW(-$80)			; Move player 0.5px/frame left
	ld   [tActPl+iScActSpdXSub], a
	ld   a, HIGH(-$80)
	ld   [tActPl+iScActSpdX], a
	ld   a, $02					; Close entrance 2px/frame up
	ld   [tActSkullJaw+iScActSpdX], a
	ld   a, -$02				; Scrols screen at 2px/frame left
	ld   [wScEd1ScrollSpdX], a
	ld   a, $04					; Use Rockman sprite
	ld   [wScAct0SprMapBaseId], a
	ld   a, $10					; For 16 frames only
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	;
	; SCENE 1d - Make Rockman escape #2
	;            Scroll screen, redraw tilemap edge.
	;
	xor  a						; Stop moving the Jaw
	ld   [tActSkullJaw+iScActSpdX], a
	; Trigger redraw of the tilemap to erase the Wily Station, allowing for looping scrolling stars.
	; This event starts while part of the Station is still visible, but with the way the event happens
	; over multiple frames, by the time it'd write over the visible part we have already scrolled it offscreen.
	ld   hl, TilemapDef_Ending_Space
	ld   a, l					; Set event source
	ld   [wScEvSrcPtr_Low], a
	ld   a, h
	ld   [wScEvSrcPtr_High], a
	ld   a, $FF					; Trigger event
	ld   [wScEvEna], a
	ld   a, $50					; For ~1.5 seconds
	ld   [wScEd1FramesLeft], a
	; While this happens, the player keeps moving 0.5px/frame left.
	call EndingSc1_AnimFor
	
	;
	; SCENE 1d - Move player slightly above, while still moving right.
	;            This is so the missile, which spawns later, can hit Wily while moving in a straight line.
	;
	ld   a, LOW(-$40)			; Move 0.125px/frame up (while still moving 0.5px/frame left)
	ld   [tActPl+iScActSpdYSub], a
	ld   a, HIGH(-$40)
	ld   [tActPl+iScActSpdY], a
	ld   a, $40					; For ~1 second
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	;
	; SCENE 1e - The player is in place, stop moving #1
	;	
	xor  a						; Stop moving
	ld   [tActPl+iScActSpdYSub], a
	ld   [tActPl+iScActSpdY], a
	ld   [tActPl+iScActSpdXSub], a
	ld   [tActPl+iScActSpdX], a
	ld   a, $40					; For ~1 second
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	;
	; SCENE 1f - The player is in place, stop moving #2
	;	
	xor  a						; Not necessary
	ld   [tActPl+iScActSpdYSub], a
	ld   [tActPl+iScActSpdY], a
	ld   a, $80					; For ~2 seconds
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	;
	; SCENE 1g - Spawn missile
	;
	ld   a, [tActPl+iScActY]	; Missile Y: 8px below player
	add  $08
	ld   [tActMissile+iScActY], a
	ld   a, [tActPl+iScActX]	; Missile X: Same as player (middle)
	ld   [tActMissile+iScActX], a
	ld   a, $02					; Use missile sprite
	ld   [wScAct1SprMapBaseId], a
	ld   a, $80					; For ~2 seconds
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	;
	; SCENE 1h - Fire missile, scrolling the player out to the right.
	;            Actually doesn't alter the starfield scrolling screen, which is a missed opportunity,
	;            it's only the player moving to the right to give the effect.
	;	
	ld   a, $01					; Move player 1px/frame right
	ld   [tActPl+iScActSpdX], a
	ld   a, $80					; For ~2 seconds
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	;
	; SCENE 1i - Fire missile, scrolling Wily in from the left.
	;            Making Wily show up required scrolling the player out first.
	;	
	ld   a, [tActPl+iScActY]	; Move Wily 10px below player
	add  $10
	ld   [tActWily+iScActY], a
	ld   a, $01					; Move Wily 1px/frame right
	ld   [tActWily+iScActSpdX], a
	ld   a, $02					; Use Wily sprite
	ld   [wScAct0SprMapBaseId], a
	ld   a, $80					; For ~2 seconds
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	;
	; SCENE 1j - Despawn missile
	;	
	xor  a						; Stop moving Wily
	ld   [tActWily+iScActSpdX], a
	ld   a, $10					; For 16 frames
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	
	;
	; SCENE 1k - Make Wily blow up while flashing.
	;
	; This effect displays several sprites while flashing Wily's palette.
	; This is not supported by EndingSc1_AnimFor, which is why it's all done
	; manually and uses its own format for tracking sprites.
	;

	; Save the spaceship position elsewhere
	ld   a, [tActWily+iScActY]
	ld   [wScEd1WilyY], a
	ld   a, [tActWily+iScActX]
	ld   [wScEd1WilyX], a
	
	;
	; Spawn the 4 explosions
	;
	
	; EXPLOSION 0
	ld   hl, wScEdExpl0
	xor  a
	; Initially, hide all the explosions by placing them with both coords 0.
	ldi  [hl], a ; iScExplY
	ldi  [hl], a ; iScExplX
	; Start with hidden explosion sprite
	ld   [hl], $04 ; iScExplSprMapId
	inc  hl
	; After $28 frames, show this explosion.
	; When the timer elapses, EndingSc1_AnimExpl gets called, which properly initializes the coordinates.
	; Every explosion has its initial timer set to an unique value, to avoid having them animate in sync.
	ld   [hl], $28 ; iScExplTimer
	inc  hl
	
	; EXPLOSION 1
	ldi  [hl], a ; iScExplY
	ldi  [hl], a ; iScExplX
	ld   [hl], $04 ; iScExplSprMapId
	inc  hl
	ld   [hl], $20 ; iScExplTimer
	inc  hl
	
	; EXPLOSION 2
	ldi  [hl], a ; iScExplY
	ldi  [hl], a ; iScExplX
	ld   [hl], $04 ; iScExplSprMapId
	inc  hl
	ld   [hl], $18 ; iScExplTimer
	inc  hl
	
	; EXPLOSION 3
	ldi  [hl], a ; iScExplY
	ldi  [hl], a ; iScExplX
	ld   [hl], $04 ; iScExplSprMapId
	inc  hl
	ld   [hl], $10 ; iScExplTimer
	inc  hl
	
	
	; Do this scene for ~4 seconds
	ld   a, $FF
	ld   [wScEdWilyExplTimer], a
	
.loop:
	;--
	;
	; DRAW SPRITES
	;
	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	;
	; Draw Wily's spaceship
	;
	ld   a, [wScEd1WilyY]
	ld   [wTargetRelY], a
	ld   a, [wScEd1WilyX]
	ld   [wTargetRelX], a
	; Flash Wily's palette every 4 frames
	ld   a, [wScEdWilyExplTimer] ; (1/16)
	add  a ; << 1 (1/8)
	add  a ; << 1 (1/4)
	and  SPR_OBP1 ; Filter bit
	ld   [wScBaseSprFlags], a
	; Draw the same Wily sprite.
	; This doesn't animate it, but it's hard to notice between the flashing and explosions.
	ld   hl, SprMapPtrTbl_ScPl
	ld   a, $02
	call Sc_DrawSprMap
	
	;
	; Draw all four explosions
	;
	xor  a						; Draw with normal palette
	ld   [wScBaseSprFlags], a
	
	ld   hl, wScEdExpl0			; HL = Ptr to first explosion
	ld   b, $04					; B = Number of explosions
.drExLoop:
	push bc ; Save count
		ldi  a, [hl]			; Y Position: iScExplY
		ld   [wTargetRelY], a
		ldi  a, [hl]			; X Position: iScExplX
		ld   [wTargetRelX], a
		ldi  a, [hl]			; Sprite mapping ID: iScExplSprMapId
		inc  hl					; Skip past iScExplTimer, into the next iScExplY
		push hl					; Save slot ptr
			ld   hl, SprMapPtrTbl_ScExpl
			call Sc_DrawSprMap
		pop  hl					; Restore slot ptr
	pop  bc				; B = ExplLeft
	dec  b				; Processed them all?
	jr   nz, .drExLoop	; If not, loop
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; ANIMATE EXPLOSIONS
	;
	ld   hl, wScEdExpl0			; HL = Ptr to first explosion
	ld   b, $04					; B = Number of explosions
.animLoop:
	inc  hl ; iScExplX
	inc  hl ; iScExplSprMapId
	inc  hl ; iScExplTimer
	; If iScExplTimer elapsed, advance the animation for this explosion
	push hl
		dec  [hl]					; iScExplTimer--
		call z, EndingSc1_AnimExpl	; iScExplTimer == 0? If so, animate
	pop  hl
	inc  hl ; Seek to next explosion's iScExplY
	dec  b 				; Done animating them all?
	jr   nz, .animLoop	; If not, loop
	
	; Do scrolling starfield
	ld   hl, hScrollX	; 2px/frame
	dec  [hl]
	dec  [hl]
	
	ld   a, [wScEdWilyExplTimer]
	dec  a							; Timer--
	ld   [wScEdWilyExplTimer], a	; Has it elapsed?
	jr   nz, .loop					; If not, loop
	
Ending_Sc2:	
	;
	; SCENE 2
	;
	; Wily dies.
	;
	
	;--
	ld   a, GFXSET_SPACE
	call GFXSet_Load
	
	ld   de, TilemapDef_Earth
	call LoadTilemapDef
	
	call StartLCDOperation
	;--
	
	ld   a, BGM_STAGESELECT
	ldh  [hBGMSet], a

	
	;--
	; [POI] Not necessary, the small explosions aren't loaded or used here.
	; EXPLOSION 0
	ld   hl, wScEdExpl0
	xor  a
	ld   de, ($80 << 8)|$40
	ldi  [hl], a ; iScExplY
	ld   [hl], d ; iScExplX
	inc  hl
	ldi  [hl], a ; iScExplSprMapId
	ld   [hl], e ; iScExplTimer
	inc  hl
	
	; EXPLOSION 1
	ldi  [hl], a ; iScExplY
	ldi  [hl], a ; iScExplX
	ldi  [hl], a ; iScExplSprMapId
	ldi  [hl], a ; iScExplTimer
	;--

	
	;##
	;
	; SCENE 2a - Wily crashes into the Earth
	;
	
	; Set Wily's initial position (top-right)
	ld   a, OBJ_OFFSET_Y+$30
	ld   [wTargetRelY], a
	ld   a, OBJ_OFFSET_X+$98
	ld   [wTargetRelX], a
	
	xor  a
	ld   [wScEdWilyExplTimer], a
.crLoop:
	;--
	;
	; DRAW SPRITES
	;
	xor  a				; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	; Draw Wily fireball
	; Use sprites $00-$01 at 1/8 speed, based on Wily's vertical postion.
	ld   hl, SprMapPtrTbl_ScWilyCrash
	ld   a, [wTargetRelY]
	rrca ; /2
	rrca ; /4 (at half speed movement, that's 1/8)
	and  $01 ; Use sprites $00-$01
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	;--

	;
	; Move at 0.5px/frame down-left
	;
	rst  $08 ; Wait Frame	; Every 2 frames...
	rst  $08 ; Wait Frame
	
	ld   hl, wTargetRelY	; Move 1px down
	inc  [hl]
	ld   hl, wTargetRelX	; Move 1px left
	dec  [hl]
	
	; Crash into the earth when reaching Y position $90, around the bottom
	ld   a, [wTargetRelY]
	cp   OBJ_OFFSET_Y+$80
	jr   nz, .crLoop
	
	;##
	;
	; SCENE 2b - Wily crashes
	;
	
	xor  a				; Init timer
	ld   [wScEdWilyExplTimer], a
	
	ld   a, SND_MUTE	; Play nuke SFX
	ldh  [hBGMSet], a
	ld   a, SFX_UFOCRASH
	ldh  [hSFXSet], a
	
.nkLoop:
	;--
	;
	; DRAW SPRITES
	;
	
	xor  a				; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	; Draw the skull nuke
	; Use sprites $00-$07 at 1/16 speed
	ld   hl, SprMapPtrTbl_ScWilyNuke
	ld   a, [wScEdWilyExplTimer]
	rrca ; /2
	rrca ; /4
	rrca ; /8 
	rrca ; /16 
	and  $07 ; Use sprites $00-$07
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	; Execute the above for $80 frames (~2 seconds)
	ld   hl, wScEdWilyExplTimer
	inc  [hl]			; Timer++
	ld   a, [hl]
	add  a				; Timer * 2 overflows? (Timer < $80)
	jr   nc, .nkLoop	; If not, loop
	
	; Wait 2 seconds before starting the credits
	ld   a, 60*2
	call WaitFrames
	ret
	
; =============== EndingSc1_AnimFor ===============
; Animates the ending scene with scrolling starts for the specified amount of frames.
; This does not support Wily's explosions, so it can't be used for that part.
; IN
; - wScEd1FramesLeft: How many frames to execute it
EndingSc1_AnimFor:
	call EndingSc1_Anim
	
	; Move both actors, whatever they may be
	ld   hl, wScAct0
	call ScAct_ApplySpeed
	ld   hl, wScAct1
	call ScAct_ApplySpeed
	
	; Scroll the screen/starfield horizontally by the specified amount
	ld   hl, wScEd1ScrollSpdX
	ldh  a, [hScrollX]
	add  [hl]
	ldh  [hScrollX], a
	
	inc  hl 					; Seek to wScEd1FramesLeft
	ld   hl, wScEd1FramesLeft 	; (Not necessary)
	dec  [hl]					; Executed it for all frames?
	jr   nz, EndingSc1_AnimFor			; If not, loop
	ret
	
; =============== EndingSc1_Anim ===============
; Draws the sprite mappings for all cutscene actors in the scrolling stars sequence.
; This also handles updating the tilemap for the scrolling starfield.
EndingSc1_Anim:
	xor  a						; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	;
	; DRAW ACTOR 0 (Player or Wily)
	;
	ld   a, [wScAct0+iScActY]
	ld   [wTargetRelY], a
	ld   a, [wScAct0+iScActX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScPl
	;--
	; Alternate between wScAct0SprMapBaseId and (wScAct0SprMapBaseId+1) at 1/4 speed
	ld   a, [wScEd1FramesLeft]
	rrca ; /2
	rrca ; /4
	and  $01	; 2 frames anim ($00-$01)
	ld   b, a	; to B
	ld   a, [wScAct0SprMapBaseId]	; Get base ID
	add  b							; Add relative
	;--
	call Sc_DrawSprMap			; Draw it
	
	;
	; DRAW ACTOR 1 (Skull Jaw or Crayola Missile)
	;
	ld   a, [wScAct1+iScActY]
	ld   [wTargetRelY], a
	ld   a, [wScAct1+iScActX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScSkullJaw
	;--
	; Alternate between wScAct0SprMapBaseId and (wScAct0SprMapBaseId+1) at 1/4 speed.
	; This is used to animate the Missile, but because this is also done while drawing the Skull Jaw,
	; which has no animation, the latter has a duplicate entry in the sprite mapping table.
	ld   a, [wScEd1FramesLeft]
	rrca 
	rrca 
	and  $01
	ld   b, a
	ld   a, [wScAct1SprMapBaseId]
	add  b
	;--
	call Sc_DrawSprMap
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;##
	
	;
	; TILEMAP EDGE REDRAW
	; 
	; Used to redraw part of the tilemap when scrolling the starfield right.
	;
	; This is because the tilemap loaded in this scene (TilemapDef_WilyStationEntrance) contains
	; the entrance to the Wily Station on the right, which needs to get overwritten by stars.
	;
	; This only needs to be triggered exactly once during the whole sequence, as soon as the entrance
	; is scrolled out of view, then no further updates are necessary. 
	;
	
	ld   a, [wScEvEna]
	and  a				; Tilemap update triggered/in progress?
	ret  z				; If not, return
	
	;
	; As a large amount of tiles need to be written, this event is processed over multiple frames.
	; Unlike with GFX updates, there's no system in place for doing so with tilemaps, although
	; the way events are chained until reaching an end terminator would work very well for it.
	;
	; The event this uses is stored in ROM at TilemapDef_Ending_Space, which defines multiple commands for writing
	; columns to the tilemap. As each command can be executed as an indivudual event, copy that
	; to the buffer, stick and end terminator, and trigger it. The next frame copy the next command
	; from where we last left off, and so on until we reach the terminator in ROM.
	;
	; Similar multi-frame events are handled manually later on, in the credits sequence.
	;
	
	ld   a, [wScEvSrcPtr_Low]		; HL = Source event (where we last left off)
	ld   l, a
	ld   a, [wScEvSrcPtr_High]
	ld   h, a
	ld   de, wTilemapBuf			; DE = Destination
	ld   bc, $0015					; BC = Event size (3-byte header + 18 tiles)
	call CopyMemory					; Copy to event buffer
	xor  a							; Write terminator
	ld   [de], a
	inc  a							; Trigger event
	ld   [wTilemapEv], a
	ld   a, l						; Save back what we reached
	ld   [wScEvSrcPtr_Low], a
	ld   a, h
	ld   [wScEvSrcPtr_High], a
	
	ld   a, [hl]
	and  a							; Did we reach the null terminator?
	ret  nz							; If not, return (trigger another event next frame)
	ld   [wScEvEna], a			; Otherwise, we're done
	ret
	
; =============== EndingSc1_AnimExpl ===============
; Animattes a single explosion for Wily's spaceship.
; IN
; - HL: Ptr to iScExplTimer
EndingSc1_AnimExpl:
	; Reset animation timer to $08
	; This sets the animation speed to 1/8
	ld   [hl], $08
	
	; Advance animation cycle ($00-$02)
	dec  hl ; iScExplSprMapId
	ld   a, [hl]	; SprId++
	inc  a
	ld   [hl], a
	cp   $03		; Went out of range?
	ret  c			; If not, return
	
	; Otherwise, "respawn" the explosion
	ld   [hl], $00	; Reset to first sprite
	
	;
	; Randomize the spawn coordinates, anywhere from +$18 to -$20 within Wily's Spaceship.
	;
	
	; X POSITION
	dec  hl ; iScExplX
	; C = (Rand & $38) - $20
	call Rand	; Randomize
	and  $38	; Filter in range
	sub  $20	; Offset in both directions
	ld   c, a
	; iScExplX = wScEd1WilyX + C
	ld   a, [wScEd1WilyX]
	add  c
	ld   [hl], a
	
	; Y POSITION
	dec  hl ; iScExplY
	; C = (Rand & $38) - $20
	call Rand	; Randomize
	and  $38	; Filter in range
	sub  $20	; Offset in both directions
	ld   c, a
	; iScExplY = wScEd1WilyY + C
	ld   a, [wScEd1WilyY]
	add  c
	ld   [hl], a
	
	ld   a, SFX_EXPLODE	; Play explosion SFX
	ldh  [hSFXSet], a
	ret
	
; =============== Module_Credits ===============
; Cast roll and Thank you for playing screen.
; This never returns, and if it did you'd reach an infinite loop.
Module_Credits:
	ld   a, BGM_ENDING
	ldh  [hBGMSet], a
	
Credits_Sc1:
	;
	; This expects to directly continue off the heels of the ending sequence.
	; The earth is visible at the bottom, alongside a skull nuke sprite.
	;
	; Scroll the screen up slowly, while overwriting the bottom of the tilemap
	; with starts as the Earth gets out of view, to allow for a vertically scrolling starfield.
	;
	; This uses a similar setup to EndingSc1_Anim, except it's for vertical scrolling and with
	; the slower scrolling speed multiple frames pass between tilemap row writes.
	;
	ld   hl, TilemapDef_Credits_Space	; Set event source
	ld   a, l
	ld   [wScEvSrcPtr_Low], a
	ld   a, h
	ld   [wScEvSrcPtr_High], a
	
.mkFieldLoop:

	; Every 4 frames...
	REPT 4
		rst  $08 ; Wait Frame
	ENDR
	
	;
	; ...Scroll the screen 1px up (0.25px/frame)
	;
	
	ld   hl, wTargetRelY	; Move nuke 1px down to compensate
	inc  [hl]
	;--
	; Draw the Nuke sprite at the new location
	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a
	ld   hl, SprMapPtrTbl_ScWilyNuke
	ld   a, $07
	call Sc_DrawSprMap
	call OAM_ClearRest		; Done drawing
	;--
	ld   hl, hScrollY		; Scroll screen up 1px
	dec  [hl]
	ld   a, [hl]
	
	; Every other frame we get here...
	; (In total, every 8 frames of moving up, aka 1 tile)
	and  $01
	jp   z, .mkFieldLoop
	
	; ... overwrite the next row with starfield tiles,
	ld   a, [wScEvSrcPtr_Low]		; HL = Source event (where we last left off)
	ld   l, a
	ld   a, [wScEvSrcPtr_High]
	ld   h, a
	ld   de, wTilemapBuf			; DE = Destination
	ld   bc, $000D					; BC = Event size (3-byte header + 10 tiles)
	call CopyMemory					; Copy to event buffer
	xor  a							; Write terminator
	ld   [de], a
	inc  a							; Trigger event
	ld   [wTilemapEv], a
	ld   a, l						; Save back what we reached
	ld   [wScEvSrcPtr_Low], a
	ld   a, h
	ld   [wScEvSrcPtr_High], a

	; Continue until we reach the end terminator for this event
	ld   a, [hl]
	and  a							; Did we reach the null terminator?
	jr   nz, .mkFieldLoop			; If not, loop (trigger another event after 8 frames)


Credits_Sc2:
	;
	; Load the credits text font and large Rockman sprite, while still scrolling up.
	; At this point, the Nuke is fully offscreen so it won't getdrawn anymore.
	;
	; As the background is *currently* reserved to the scrolling starfield, the text is drawn using sprites.
	;

	ld   hl, GFX_Credits_OBJ ; Source GFX ptr
	ld   de, $8000 ; VRAM Destination ptr (1st section)
	ld   bc, (BANK(GFX_Credits_OBJ) << 8)|$80 ; B = Source GFX bank number (BANK $0B) C = Number of tiles to copy
	call GfxCopy_Req
	
	;
	; Loading $80 tiles takes up $20 frames.
	; As we need to be consistent with the starfield scrolling speed of 0.25px/frame, we're waiting 
	; 4 frames at a time rather than 2, so by the halfway mark we're done loading it.
	;
	ld   b, $10				; For $10 frames...
.fontLoadLoop:
	ld   a, $04				; Load a full row of graphics
	call WaitFrames
	ld   hl, hScrollY		; Scroll screen 1px up
	dec  [hl]
	dec  b					; Are we done?
	jr   nz, .fontLoadLoop	; If not, loop
	
Credits_Sc3:
	;
	; CAST ROLL
	;
	; Enemies come from the right side of the screen, pause for a bit 
	; while showing their name, then move offscreen to the left.
	;
	; Curiously, up until the bosses, the enemies shown are ordered by their actor ID.
	;
	xor  a						; From the first enemy
	ld   [wCredRowId], a
	ld   a, OBJ_OFFSET_Y+$30	; Enemy Y position: $40 (near the top, fixed)
	ld   [wCredRowY], a
	ld   a, $B0					; Enemy X position: $A8 (offscreen to the right)
	ld   [wCredRowX], a
.nextEnemy:
	;
	; Cast roll data is stored in several tables, all indexed by wCredRowId.
	; The first of them defines the actor art set associated to the enemy.
	;
	ld   hl, Credits_CastGfxSetTbl	; A = Credits_CastGfxSetTbl[wCredRowId]
	ld   a, [wCredRowId]
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	call ActS_ReqLoadRoomGFX.tryLoadBySetId	; Load that
	
	; Wait for ~half a second while the enemy graphics load
	ld   b, $20
	call Credits_CastScrollYFor
	
.loopEnemy:
	;--
	;
	; DRAW SPRITES
	;

	xor  a				; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	; Draw the large Rockman sprite
	ld   a, OBJ_OFFSET_Y+$40	; Around the bottom (as the origin of this sprite is at the top)
	ld   [wTargetRelY], a
	ld   a, OBJ_OFFSET_X+$80	; Right side
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_Credits_Pl
	xor  a
	call Sc_DrawSprMap
	
	; Draw the enemy sprite (without text)
	ld   a, [wCredRowY]
	ld   [wTargetRelY], a
	ld   a, [wCredRowX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_Credits_CastPic
	ld   a, [wCredRowId]
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	; Move enemy left 1px
	ld   hl, wCredRowX	; XPos--
	dec  [hl]
	
	;
	; Whenever the enemy reaches the center of the screen, draw its name and pause for 2 seconds.
	; This delay is why the text doesn't disappear immediately, as the sprites previously written
	; to the OAM mirror do not get changed in the middle of Credits_CastScrollYFor.
	;
	ld   a, [hl]						; A = XPos
	cp   OBJ_OFFSET_X+$50				; XPos == $58?
	call z, Credits_CastDrawNameStub	; If so, draw its name to OAM (preserves flags for second check)
	ld   b, 60*2						; For 2 seconds...
	call z, Credits_CastScrollYFor		; If the check above passed, wait for that long
	
	; Scroll the starfield
	call Credits_CastScrollY
	
	; 
	; When the enemy moves offscreen to the left, advance to the next one.
	; Just to be sure to account, this check triggers at X position $C0,
	; which is around the middle of the offscreen area.
	;
	ld   a, [hl]			; A = XPos
	cp   OBJ_OFFSET_X+$B8	; XPos == $C0?
	jr   nz, .loopEnemy		; If not, keep moving the sprite left
	
	ld   hl, wCredRowId		; Otherwise, advance to the next row
	inc  [hl]				; wCredRowId++
	; Went past the last cast roll entry ($26)?
	ld   a, [hl]
	cp   Credits_CastGfxSetTbl.end-Credits_CastGfxSetTbl
	jr   nz, .nextEnemy		; If so, jump
	

Credits_Sc4:
	;
	; Prepare the screen for the vertically scrolling text.
	;
	; Due to sprite limits, we can't use sprites to draw the text like we did before,
	; so that text really needs to be written to the tilemap.
	; However, the tilemap is currently displaying a scrolling starfield!
	;
	; Therefore, as the screen scrolls, we have to wipe the tilemap clean.
	; To make the transition seamless, draw a sprite version of the starfield as
	; soon as we start doing it.
	;
	; Note that the reason we can't clear the screen all at once is that there
	; aren't enough sprites to draw the full starfield, so stars would visibly pop out.
	;
	
	; As the screen is scrolling up, overwrite what's above the viewport.
	; Since we start overwriting when the viewport is near the top of the screen,
	; start from the bottom of the tilemap.
	ld   a, (BGMap_End-BGMap_Begin)/8	; /8 due to how it's offset
	ld   [wCredBGClrPtrLow], a
	; Wait for the Y position to reach the top of the tilemap, to start at a known position.
	ld   b, $10
	call Credits_CastScrollYTo
	
.loop:

	; Wait 32 frames, scrolling the starfield down at 0.25px/frame.
	; This will scroll the screen up by 8px when we're done.
	ld   b, $20
.scLoop:
	push bc
		call Credits_CastScrollY	; Scroll both the sprite starfield and what's left of the background starfield
		call Credits_DrawThank		; Draw Rockman and the sprite starfield
		rst  $08 ; Wait Frame
	pop  bc
	dec  b				; Done waiting?
	jr   nz, .scLoop	; If not, loop
	
	
	; 
	; Calculate the destination ptr to the tilemap.
	; HL = BGMap_Begin[wCredBGClrPtrLow - BG_TILECOUNT_H]
	; All calculations are done with values divided by 8.
	;
	ld   a, [wCredBGClrPtrLow]
	sub  BG_TILECOUNT_H/8		; Move 1 tile up
	ld   [wCredBGClrPtrLow], a		; Save back
	ld   l, a
	ld   h, HIGH(BGMap_Begin)/8	
	; Then multiply the result by 8 to get the real pointer
	add  hl, hl ; *2
	add  hl, hl ; *4
	add  hl, hl ; *8
	
	ld   de, wTilemapBuf
	
	; bytes0-1: Destination pointer
	ld   a, h
	ld   [de], a
	inc  de
	ld   a, l
	ld   [de], a
	inc  de
	
	; byte2: Writing mode + Number of bytes to write
	ld   a, BG_REPEAT|BG_MVRIGHT|$14	; Repeat tile 14 times right
	ld   [de], a
	inc  de
	
	; byte3+: payload
	ld   a, $70		; Use black tile ID
	ld   [de], a
	inc  de
	
	; Write terminator
	xor  a
	ld   [de], a
	
	; Trigger event
	inc  a
	ld   [wTilemapEv], a
	
	ld   a, [wCredBGClrPtrLow]
	and  a			; Wrote to the top of the tilemap?
	jr   nz, .loop	; If not, loop
	
Credits_Sc5:
	;
	; Scroll in from below the "Thank you for playing" text, while the sprite starfield keeps scrolling down.
	;
	
	; Load the credits text font on the background section, as we're writing text there.
	ld   hl, GFX_Credits_OBJ ; Source GFX ptr
	ld   de, $9200 ; VRAM Destination ptr (3rd section)
	ld   bc, (BANK(GFX_Credits_OBJ) << 8)|$60 ; B = Source GFX bank number (BANK $0B) C = Number of tiles to copy
	call GfxCopy_Req
	
	; With the tilemap fully black, set viewport to Y position $60.
	; This makes the viewport aligned to the bottom of the tilemap.
	ld   a, $60
	ldh  [hScrollY], a
	
	; Prepare the event, which starts writing text at the top of the tilemap.
	; As the viewport moves down, this text will immediately scroll up into the visible area.
	ld   hl, TilemapDef_Credits_Thank	
	ld   a, l
	ld   [wScEvSrcPtr_Low], a
	ld   a, h
	ld   [wScEvSrcPtr_High], a
.loop:

	; Wait 64 frames, scrolling the text up and starfield down at 0.25px/frame.
	; This will scroll the screen up by 16px when we're done.
	ld   b, $40
.scLoop:
	push bc
		call Credits_SprStarTextScroll	; Scroll text and sprite starfield
		call Credits_DrawThank			; Draw Rockman and sprite starfield
		rst  $08 ; Wait Frame
	pop  bc
	dec  b				; Done waiting?
	jr   nz, .scLoop	; If not, loop
	
	; ... overwrite the next row with the event data.
	; As this writes the whole thing, by the time we're done everything will have been written,
	; including the Capcom logo.
	ld   a, [wScEvSrcPtr_Low]		; HL = Source event (where we last left off)
	ld   l, a
	ld   a, [wScEvSrcPtr_High]
	ld   h, a
	ld   de, wTilemapBuf			; DE = Destination
	ld   bc, $0010					; BC = Event size (3-byte header + 13 tiles)
	call CopyMemory					; Copy to event buffer
	xor  a							; Write terminator
	ld   [de], a
	inc  a							; Trigger event
	ld   [wTilemapEv], a
	ld   a, l						; Save back what we reached
	ld   [wScEvSrcPtr_Low], a
	ld   a, h
	ld   [wScEvSrcPtr_High], a

	; Continue until we reach the end terminator for this event
	ld   a, [hl]
	and  a							; Did we reach the null terminator?
	jr   nz, .loop					; If not, loop
	
Credits_Sc6:
	;
	; Continue scrolling the text we wrote before, until we reach Y position $80.
	; That's when the Capcom logo gets vertically centered.
	;
	call Credits_SprStarTextScroll	; Scroll text and sprite starfield
	call Credits_DrawThank			; Draw Rockman and the sprite starfield
	rst  $08 ; Wait Frame
	ldh  a, [hScrollY]
	cp   $80
	jr   nz, Credits_Sc6
	
Credits_Sc7:
	;
	; Infinite loop at the Capcom logo.
	;
	call Credits_SprStarScroll		; Scroll sprite starfield only
	call Credits_DrawThank			; Draw Rockman and the sprite starfield
	rst  $08 ; Wait Frame
	jr   Credits_Sc7
	; We never get here
	ret
	
; =============== Credits_CastScrollY ===============
; Scrolls the starfield down at 0.25px/frame.
; Used during the cast roll and transition, when the starfield is drawn using the background.
Credits_CastScrollY:
	; Takes 4 frames to overflow
	ld   a, [wCredScrollYSub]
	add  $40					; SubPx += $40
	ld   [wCredScrollYSub], a	; Did we overflow?
	ret  nc						; If not, return
	
	; When the stars are drawn on the background layer (during the cast roll),
	; make them move up by moving the viewport up.
	ldh  a, [hScrollY]			; Otherwise, move up 1px
	dec  a
	ldh  [hScrollY], a
	; Keep this synched for later.
	; This will be important once the cast roll ends and the starfield is converted
	; to sprites to make the vertical scrolling text possible.
	ld   [wCredSprScrollY], a
	ret
	
; =============== Credits_CastScrollYFor ===============
; Scrolls the starfield for the specified amount of frames.
; Cast roll only.
; IN
; - B: Number of frames
Credits_CastScrollYFor:
	call Credits_CastScrollY
	push bc ; (Not necessary)
		rst  $08 ; Wait Frame
	pop  bc
	dec  b				; Done moving?
	jr   nz, Credits_CastScrollYFor	; If not, loop
	ret
	
; =============== Credits_CastDrawNameStub ===============
; Wrapper to Credits_CastDrawName.
Credits_CastDrawNameStub:
	push af ; Save and restore flags
		call Credits_CastDrawName
	pop  af
	ret
	
; =============== Credits_CastScrollYTo ===============
; Scrolls the starfield until the specified scroll position is reached.
; Cast roll only.
; IN
; - B: Target Y position
Credits_CastScrollYTo:
	push bc ; (Not necessary)
		call Credits_CastScrollY
		rst  $08 ; Wait Frame
	pop  bc
	
	ldh  a, [hScrollY]
	cp   b				; Are we on the target Y position?
	jr   nz, Credits_CastScrollYTo	; If not, loop
	ret
	
; =============== Credits_SprStarTextScroll ===============
; Scrolls the text up and the starfield down at 0.25px/frame.
; Thanks for playing screen only, when the starfield is drawn using sprites.
Credits_SprStarTextScroll:
	; Takes 4 frames to overflow
	ld   a, [wCredScrollYSub]
	add  $40					; SubPx += $40
	ld   [wCredScrollYSub], a	; Did we overflow?
	ret  nc						; If not, return
	
	; Scroll the BG viewport down.
	; This scrolls up the text drawn on the background layer.
	ldh  a, [hScrollY]
	inc  a
	ldh  [hScrollY], a
	
	; Scroll the sprite viewport up.
	; This is set up to simulate how the the BG viewport works, except with sprites.
	; So scrolling this viewport up makes the sprite starfield scroll down (see Credits_DrawThank).
	ld   a, [wCredSprScrollY]
	dec  a
	ld   [wCredSprScrollY], a
	ret
	
; =============== Credits_DrawThank ===============
; Draws all sprites in scenes after the cast roll.
Credits_DrawThank:
	xor  a				; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	;
	; Draw the large Rockman sprite
	;
	ld   a, OBJ_OFFSET_Y+$40	; Around the bottom (as the origin of this sprite is at the top)
	ld   [wTargetRelY], a
	ld   a, OBJ_OFFSET_X+$80	; Right side
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_Credits_Pl
	xor  a
	call Sc_DrawSprMap
	
	;
	; Draw the sprite version of the starfield.
	;
	
	;--
	; DE = Ptr to destination (current OAM slot)
	ld   hl, wWorkOAM		; HL = Ptr to start of OAM mirror
	ldh  a, [hWorkOAMPos]	; BC = Current pos
	ld   b, $00
	ld   c, a
	add  hl, bc				; Seek to current
	ld   e, l				; Move to DE
	ld   d, h
	;--
	
	ld   hl, Credits_StarfieldSprTbl								; HL = Ptr to source
	ld   b, (Credits_StarfieldSprTbl.end-Credits_StarfieldSprTbl)/3	; B = Number of stars ($1A)
.loop:

	; Y Position = byte0 - wCredSprScrollY - 1
	; wCredSprScrollY is being treated similarly to the background viewport.
	; For example, scrolling a viewport up makes the background move down.
	;
	; Since sprites do not use viewports, this is simulated manually making sprites move down
	; The higher wCredSprScrollY becomes, the lower the viewport moves down, moving the starfield up.
	; Therefore, subtract viewport position from the relative Y position.
	ld   a, [wCredSprScrollY]	; A = -wCredSprScrollY
	xor  $FF					; ""
	add  [hl]					; Add relative Y position (byte0)
	ld   [de], a				; Write to OAM
	inc  hl ; Seek to byte1
	inc  de ; Seek to XPos
	
	; X Position = byte1
	ldi  a, [hl]	; Read byte1, seek to byte2
	ld   [de], a
	inc  de			; Seek to TileId
	
	; Tile ID = byte2
	ldi  a, [hl]	; Read byte2, seek to next byte0
	ld   [de], a
	inc  de			; Seek to Flags
	
	; Flags = $00
	; To save space, since every star uses the same sprite flags, 
	; this is not included in the sprite mapping.
	xor  a
	ld   [de], a
	inc  de			; Seek to next YPos
	
	dec  b					; Drawn all stars?
	jr   nz, .loop			; If not, loop
	
	ld   a, e				; Track reached OAM slot
	ldh  [hWorkOAMPos], a
	call OAM_ClearRest		; Done drawing
	ret
	
; =============== Credits_SprStarScroll ===============
; Scrolls the sprite starfield down at 0.25px/frame.
; This is used when the Capcom logo stops moving, so the BG viewport isn't changed.
Credits_SprStarScroll:
	; Takes 4 frames to overflow
	ld   a, [wCredScrollYSub]
	add  $40					; SubPx += $40
	ld   [wCredScrollYSub], a	; Did we overflow?
	ret  nc						; If not, return
	
	; Scroll the sprite viewport up.
	ld   hl, wCredSprScrollY
	dec  [hl]
	ret
	
; =============== Sc_DrawSprMap ===============
; Draws the specified cutscene sprite.
; See also: ActS_DrawSprMap
; IN
; - HL: Ptr to sprite mapping table
; - A: Sprite mapping ID
; - wTargetRelY: Y position
; - wTargetRelX: X position
; - wScBaseSprFlags: Base flags
Sc_DrawSprMap:
	;
	; Index the sprite mapping pointer from the table we've been passed.
	; HL = HL[A*2]
	;
	add  a			; * 2 for pointer table
	ld   b, $00
	ld   c, a
	add  hl, bc		; Seek to entry
	ld   e, [hl]	; Read out pointer to DE
	inc  hl
	ld   d, [hl]
	ld   l, e		; Move to HL
	ld   h, d
	
	;
	; Write the sprite mapping to the OAM mirror.
	;
	
	;--
	ld   de, wWorkOAM		; HL = Ptr to current OAM slot (could have been done simpler)
	ldh  a, [hWorkOAMPos]
	add  e
	ld   e, a
	ld   a, d
	adc  $00
	ld   d, a
	;--
	
	; The first byte of a mapping marks the number of individual OBJ they use.
	; Unlike other sprite mapping drawing routines, this neither allows blank sprite mappings
	; nor does it check if we're going over the sprite limit (since it's all controlled manually).
	; It also does not support flipping.
	ld   b, [hl]			; B = OBJCount
	inc  hl					; Seek to the OBJ table
.loop:
	; YPos = wTargetRelY + byte0
	ld   a, [wTargetRelY]	; A = Absolute Y
	add  [hl]				; Add relative Y
	ld   [de], a			; Write to OAM mirror
	inc  hl					; SrcPtr++
	inc  de					; DestPtr++
	
	; XPos = wTargetRelX + byte1
	ld   a, [wTargetRelX]
	add  [hl]
	ld   [de], a
	inc  hl
	inc  de
	
	; TileID = byte2
	ldi  a, [hl]
	ld   [de], a
	inc  de
	
	; Flags = wScBaseSprFlags ^ byte3
	; Unlike every other routine, this does merge them the proper way by xor'ing them.
	ld   a, [wScBaseSprFlags]
	xor  [hl]
	ld   [de], a
	inc  hl
	inc  de
	
	dec  b					; Finished copying all OBJ?
	jr   nz, .loop			; If not, loop
	
	ld   a, e				; Save back current OAM ptr
	ldh  [hWorkOAMPos], a
	ret
	
; =============== Credits_CastDrawName ===============
; Draws the enemy's name using sprites.
Credits_CastDrawName:

	;
	; Get ptr to the string for the current cast roll entry.
	; HL = Credits_CastTextPtrTbl[wCredRowId * 2]
	;
	ld   a, [wCredRowId]	; A = RowId * 2 (for ptr table)
	add  a
	ld   hl, Credits_CastTextPtrTbl	; HL = Ptr table base
	ld   b, $00		; BC = Index
	ld   c, a
	add  hl, bc		; Seek to entry
	ld   e, [hl]	; Read out to DE
	inc  hl
	ld   d, [hl]
	ld   l, e		; Move to HL
	ld   h, d
	
	;
	; Set starting coordinates for the text drawing loop.
	;
	
	; Y POSITION - Fixed
	; All lines start at Y position $48.
	DEF TEXT_BASE_Y = OBJ_OFFSET_Y+$38
	ld   a, TEXT_BASE_Y
	ld   [wCredTextY], a
	
	; X POSITION - String-specific.
	; The first byte of a string contains its left padding, in tiles.
	ld   a, [hl]	; Read byte0
	inc  hl			; Seek to first character
	and  $1F		; Filter out unwanted bits
	add  a			; *2
	add  a			; *4
	add  a			; *8 (TILE_H)
	ld   [wCredTextX], a
	ld   [wCredTextRowX], a	; Make a backup copy for restoring it on newlines
	
	;
	; Convert the text string into sprites.
	;
	
	;--
	; Start drawing writing them from the current OAM entry
	; HL = wWorkOAM + hWorkOAMPos
	ld   de, wWorkOAM
	ldh  a, [hWorkOAMPos]
	add  e
	ld   e, a
	ld   a, d
	adc  $00
	ld   d, a
	;--
.loop:
	; YPos = wCredTextY
	ld   a, [wCredTextY]
	ld   [de], a
	inc  de
	
	; XPos = wCredTextX
	ld   a, [wCredTextX]
	ld   [de], a
	; Write the next character 8 pixels ro the right
	; wCredTextX += 8
	add  TILE_H
	ld   [wCredTextX], a
	inc  de
	
	; TileID = byte2 - $20
	; The font in ROM is ASCII-like, but in VRAM it's located 32 tiles before that.
	ldi  a, [hl]		; Read character, seek to next
	sub  $20			; -32
	ld   [de], a		; Use that as tile ID
	inc  de
	
	; Flags = wScBaseSprFlags ^ byte3
	xor  a
	ld   [de], a
	inc  de
	
	; Check for a string terminator
	ld   a, [hl]		; Read next character
	cp   $2F			; Reached a newline character?
	call z, .newLine	; If so, move to the start of the next row
	cp   $2E			; Reached terminator?
	jr   nz, .loop		; If not, loop
	
	; Otherwise, we're done
	ld   a, e			; Save back new OAM write position
	ldh  [hWorkOAMPos], a
	ret
	
.newLine:
	; Text strings only have two lines at most.
	; We can get away with using an hardcoded Y location rather than doing it the proper way.
	ld   a, TEXT_BASE_Y+TILE_H
	ld   [wCredTextY], a
	; Seek back to the start of the row
	ld   a, [wCredTextRowX]
	ld   [wCredTextX], a
	
	inc  hl 		; Seek to next character
	ld   a, [hl]	; Read it before returning to the terminator check
	ret
	
; =============== ScAct_ApplySpeed ===============
; Moves the actor by its current speed.
; In short, actually moves the actor.
; IN
; - HL: Ptr to cutscene actor slot
ScAct_ApplySpeed:
	; Seek to vars
	ld   e, l				; DE = Ptr to iScActYSub (position)
	ld   d, h
	
	inc  hl ; iScActY		; HL = Ptr to iScActSpdYSub (speed)
	inc  hl ; iScActXSub
	inc  hl ; iScActX
	inc  hl ; iScActSpdYSub
	
	; Move vertically
	; iScActY* += iScActSpdY*
	ld   a, [de]	; Read iScActYSub
	add  [hl]		; Add iScActSpdYSub
	ld   [de], a	; Save back
	inc  hl ; iScActSpdY
	inc  de ; iScActY
	ld   a, [de]	; Read iScActY
	adc  [hl]		; Add speed + overflow
	ld   [de], a	; Save back
	inc  hl ; iScActSpdXSub
	inc  de ; iScActXSub
	
	; Move horizontally
	; iScActX* += iScActSpdX*
	ld   a, [de]
	add  [hl]
	ld   [de], a
	inc  hl
	inc  de
	ld   a, [de]
	adc  [hl]
	ld   [de], a
	inc  hl
	inc  de
	
	ret
	
TilemapDef_WilyStationEntrance: INCLUDE "data/space/entrance_bg.asm"
TilemapDef_Earth: INCLUDE "data/space/earth_bg.asm"
TilemapDef_Ending_Space: INCLUDE "data/space/ending_space_bg.asm"
TilemapDef_Credits_Space: INCLUDE "data/credits/space_bg.asm"
IF !SKIP_JUNK
	db $00;X
ENDC

SETCHARMAP credits
; =============== TilemapDef_Credits_Thank ===============
TilemapDef_Credits_Thank:
.def00:
	wd $9803
	db $00|$0D
	db "  THANK YOU  "
.def01:
	wd $9843
	db $00|$0D
	db " FOR PLAYING "
.def02:
	wd $98A3
	db $00|$0D
	db "  PRESENTED  "
.def03:
	wd $98E3
	db $00|$0D
	db "     BY      "
.def04:
	wd $9900
	db $00|$0D
	db "_____________"
.def05:
	wd $9920
	db $00|$0D
	db "_____________"
.def06:
	wd $9940
	db $00|$0D
	db "_____________"
.def07:
	wd $9960
	db $00|$0D
	db "_____________"
.def08:
	wd $9B03
	db $00|$0D
	db $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C ; CAPCOM logo
.def09:
	wd $9B23
	db $00|$0D
	db $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B,$3C ; CAPCOM logo
.def0A:
	wd $9803
	db $00|$0D
	db "_____________"
.eof: db $00

; =============== Credits_StarfieldSprTbl ===============
Credits_StarfieldSprTbl:
	INCLUDE "data/credits/starfield_dspr.asm"

; =============== SPRITE MAPPINGS ===============
SprMapPtrTbl_ScWilyShipSm:
	dw SprMap_ScWilyShipSm0;X
	dw SprMap_ScWilyShipSm1;X
	dw SprMap_ScWilyShipSm2
	dw SprMap_ScWilyShipSm3;X
SprMapPtrTbl_ScPl:
	dw SprMap_ScPlR0
	dw SprMap_ScPlR1
	dw SprMap_ScWily0
	dw SprMap_ScWily1
	dw SprMap_ScPlL0
	dw SprMap_ScPlL1
SprMapPtrTbl_ScSkullJaw:
	dw SprMap_ScSkullJaw
	dw SprMap_ScSkullJaw ; Duplicate entry since the missile animation code always gets executed
	dw SprMap_ScMissile0
	dw SprMap_ScMissile1
SprMapPtrTbl_ScWilyCrash:
	dw SprMap_ScWilyCrash0
	dw SprMap_ScWilyCrash1
SprMapPtrTbl_ScWilyNuke:
	dw SprMap_ScWilyNuke0
	dw SprMap_ScWilyNuke1
	dw SprMap_ScWilyNuke2
	dw SprMap_ScWilyNuke3
	dw SprMap_ScWilyNuke4
	dw SprMap_ScWilyNuke5
	dw SprMap_ScWilyNuke6
	dw SprMap_ScWilyNuke7
SprMapPtrTbl_ScExpl:
	dw SprMap_ScExpl0
	dw SprMap_ScExpl1
	dw SprMap_ScExpl2
	dw SprMap_ScExpl0;X	; Repeat entries for some reason
	dw SprMap_ScExpl1	; Explosions are initialized with sprite $04 (out of range value that forces a loop to $00) but aren't actually drawn with it.
	dw SprMap_ScExpl2;X
SprMapPtrTbl_Credits_Pl:
	dw SprMap_Credits_Pl

INCLUDE "data/space/spr/null_spr.asm"
INCLUDE "data/space/spr/wily_sm_spr.asm"
INCLUDE "data/space/spr/pl_spr.asm"
INCLUDE "data/space/spr/wily_spr.asm"
INCLUDE "data/space/spr/missile_spr.asm"
INCLUDE "data/space/spr/skulljaw_spr.asm"
INCLUDE "data/space/spr/wilycrash_spr.asm"
INCLUDE "data/space/spr/wilynuke_spr.asm"
INCLUDE "data/space/spr/expl_spr.asm"
INCLUDE "data/credits/pl_spr.asm"

; =============== Credits_CastGfxSetTbl ===============
; Maps each entry in the cast roll to its art set.
Credits_CastGfxSetTbl:
	db ACTGFX_LVLHARD    ; Bee
	db ACTGFX_LVLHARD    ; Chibee
	db ACTGFX_LVLHARD    ; Wanaan
	db ACTGFX_LVLHARD    ; HammerJoe
	db ACTGFX_LVLHARD    ; NeoMonking
	db ACTGFX_LVLNEEDLE  ; NeoMet
	db ACTGFX_LVLTOP     ; Komasaburo
	db ACTGFX_LVLTOP     ; Mechakkero
	db ACTGFX_LVLMAGNET  ; MagFly
	db ACTGFX_LVLMAGNET  ; GiantSpringer
	db ACTGFX_LVLMAGNET  ; Peterchy
	db ACTGFX_LVLMAGNET  ; NewShotnan
	db ACTGFX_LVLNEEDLE  ; Yambow
	db ACTGFX_LVLNEEDLE  ; HariHarry
	db ACTGFX_LVLNEEDLE  ; Cannon
	db ACTGFX_LVLCRASH   ; Telly
	db ACTGFX_LVLCRASH   ; Pipi
	db ACTGFX_LVLCRASH   ; ShotMan
	db ACTGFX_LVLCRASH   ; FlyBoy
	db ACTGFX_LVLMETAL   ; Springer
	db ACTGFX_LVLMETAL   ; PieroBot
	db ACTGFX_LVLMETAL   ; Mole
	db ACTGFX_LVLWOOD    ; Robbit
	db ACTGFX_LVLWOOD    ; Cook
	db ACTGFX_LVLWOOD    ; Batton
	db ACTGFX_LVLAIR     ; PuchiGoblin
	db ACTGFX_LVLAIR     ; Scworm
	db ACTGFX_LVLAIR     ; Matasaburo
	db ACTGFX_LVLAIR     ; KaminariGoro
	db ACTGFX_CRASHMAN   ; CrashMan
	db ACTGFX_METALMAN   ; MetalMan
	db ACTGFX_WOODMAN    ; WoodMan
	db ACTGFX_AIRMAN     ; AirMan
	db ACTGFX_HARDMAN    ; HardMan
	db ACTGFX_TOPMAN     ; TopMan
	db ACTGFX_MAGNETMAN  ; MagnetMan
	db ACTGFX_NEEDLEMAN  ; NeedleMan
	db ACTGFX_QUINT      ; Quint
.end: ; [POI] Dummy unused entries
	db ACTGFX_LVLHARD
	db ACTGFX_LVLHARD
	db ACTGFX_LVLHARD
	db ACTGFX_LVLHARD
	db ACTGFX_LVLHARD
	db ACTGFX_LVLHARD
	db ACTGFX_LVLHARD
	
; =============== SprMapPtrTbl_Credits_CastPic ===============
; Sprite mappings used for the enemies in the cast roll.
; Goes without saying, these are separate from the ones used during gameplay.
SprMapPtrTbl_Credits_CastPic:
	dw SprMap_Cast_Bee
	dw SprMap_Cast_Chibee
	dw SprMap_Cast_Wanaan
	dw SprMap_Cast_HammerJoe
	dw SprMap_Cast_NeoMonking
	dw SprMap_Cast_NeoMet
	dw SprMap_Cast_Komasaburo
	dw SprMap_Cast_Mechakkero
	dw SprMap_Cast_MagFly
	dw SprMap_Cast_GiantSpringer
	dw SprMap_Cast_Peterchy
	dw SprMap_Cast_NewShotnan
	dw SprMap_Cast_Yambow
	dw SprMap_Cast_HariHarry
	dw SprMap_Cast_Cannon
	dw SprMap_Cast_Telly
	dw SprMap_Cast_Pipi
	dw SprMap_Cast_ShotMan
	dw SprMap_Cast_FlyBoy
	dw SprMap_Cast_Springer
	dw SprMap_Cast_PieroBot
	dw SprMap_Cast_Mole
	dw SprMap_Cast_Robbit
	dw SprMap_Cast_Cook
	dw SprMap_Cast_Batton
	dw SprMap_Cast_PuchiGoblin
	dw SprMap_Cast_Scworm
	dw SprMap_Cast_Matasaburo
	dw SprMap_Cast_KaminariGoro
	dw SprMap_Cast_CrashMan
	dw SprMap_Cast_MetalMan
	dw SprMap_Cast_WoodMan
	dw SprMap_Cast_AirMan
	dw SprMap_Cast_HardMan
	dw SprMap_Cast_TopMan
	dw SprMap_Cast_MagnetMan
	dw SprMap_Cast_NeedleMan
	dw SprMap_Cast_Quint
	dw $0000;X

; =============== Credits_CastTextPtrTbl ===============
; Enemy names for the cast roll.
MACRO mCastStr
	db $60|\1 ; Left padding, in tiles. The $60 marker doesn't have any effect.
	db \2     ; String
	db "\0"   ; Terminator
ENDM
Credits_CastTextPtrTbl:
	dw Str_Bee
	dw Str_Chibee
	dw Str_Wanaan
	dw Str_HammerJoe
	dw Str_NeoMonking
	dw Str_NeoMet
	dw Str_Komasaburo
	dw Str_Mechakkero
	dw Str_MagFly
	dw Str_GiantSpringer
	dw Str_Peterchy
	dw Str_NewShotnan
	dw Str_Yambow
	dw Str_HariHarry
	dw Str_Cannon
	dw Str_Telly
	dw Str_Pipi
	dw Str_ShotMan
	dw Str_FlyBoy
	dw Str_Springer
	dw Str_PieroBot
	dw Str_Mole
	dw Str_Robbit
	dw Str_Cook
	dw Str_Batton
	dw Str_PuchiGoblin
	dw Str_Scworm
	dw Str_Matasaburo
	dw Str_KaminariGoro
	dw Str_CrashMan
	dw Str_MetalMan
	dw Str_WoodMan
	dw Str_AirMan
	dw Str_HardMan
	dw Str_TopMan
	dw Str_MagnetMan
	dw Str_NeedleMan
	dw Str_Quint
	
SETCHARMAP credits
Str_Bee:           mCastStr $07, "HAVE'SU'BEE"
Str_Chibee:        mCastStr $08, "CHIBEE"
Str_Wanaan:        mCastStr $08, "WANAAAN"
Str_HammerJoe:     mCastStr $08, "HAMMER\nJOE"
Str_NeoMonking:    mCastStr $06, "KAETTEKITA\nMONKING"
Str_NeoMet:        mCastStr $08, "METALL"
Str_Komasaburo:    mCastStr $07, "KOMASABURO"
Str_Mechakkero:    mCastStr $09, "MECHA\nKERO"
Str_MagFly:        mCastStr $08, "MAG FLY"
Str_GiantSpringer: mCastStr $07, "G.SPRINGER"
Str_Peterchy:      mCastStr $07, "PETERCHY"
Str_NewShotnan:    mCastStr $08, "NEW\nSHOTMAN"
Str_Yambow:        mCastStr $09, "YAMBO"
Str_HariHarry:     mCastStr $06, "HARI HARRY"
Str_Cannon:        mCastStr $08, "HOUDAI"
Str_Telly:         mCastStr $09, "TELLY"
Str_Pipi:          mCastStr $09, "PIPI"
Str_ShotMan:       mCastStr $08, "SHOTMAN"
Str_FlyBoy:        mCastStr $08, "FLY BOY"
Str_Springer:      mCastStr $08, "SPRINGER"
Str_PieroBot:      mCastStr $07, "PIEROBOT"
Str_Mole:          mCastStr $09, "MOLE"
Str_Robbit:        mCastStr $08, "ROBBIT"
Str_Cook:          mCastStr $09, "COOK"
Str_Batton:        mCastStr $08, "BATTON"
Str_PuchiGoblin:   mCastStr $09, "PUTI\nGOBLIN"
Str_Scworm:        mCastStr $08, "SCWORM"
Str_Matasaburo:    mCastStr $06, "MATASABURO"
Str_KaminariGoro:  mCastStr $08, "KAMINARI\nGORO"
Str_CrashMan:      mCastStr $07, "CLASHMAN"
Str_MetalMan:      mCastStr $07, "METALMAN"
Str_WoodMan:       mCastStr $08, "WOODMAN"
Str_AirMan:        mCastStr $08, "AIRMAN"
Str_HardMan:       mCastStr $08, "HARDMAN"
Str_TopMan:        mCastStr $08, "TOPMAN"
Str_MagnetMan:     mCastStr $07, "MAGNETMAN"
Str_NeedleMan:     mCastStr $07, "NEEDLEMAN"
Str_Quint:         mCastStr $09, "QUINT"

;
; [POI] There are unused sprite mappings for some of the larger enemies.
;       They didn't make the cut as there wouldn't be enough space in OAM to display
;       them, their name and the large Rockman sprite at the same time.
;
;       None of them have entries or names in the cast roll, just unreferenced sprites.
;

INCLUDE "data/credits/cast_spr/bee_spr.asm"
INCLUDE "data/credits/cast_spr/chibee_spr.asm"
INCLUDE "data/credits/cast_spr/wanaan_spr.asm"
INCLUDE "data/credits/cast_spr/hammerjoe_spr.asm"
INCLUDE "data/credits/cast_spr/neomonking_spr.asm"
INCLUDE "data/credits/cast_spr/neomet_spr.asm"
INCLUDE "data/credits/cast_spr/unused_pickelmanbull_spr.asm"
INCLUDE "data/credits/cast_spr/unused_bikky_spr.asm"
INCLUDE "data/credits/cast_spr/komasaburo_spr.asm"
INCLUDE "data/credits/cast_spr/mechakkero_spr.asm"
INCLUDE "data/credits/cast_spr/magfly_spr.asm"
INCLUDE "data/credits/cast_spr/giantspringer_spr.asm"
INCLUDE "data/credits/cast_spr/peterchy_spr.asm"
INCLUDE "data/credits/cast_spr/newshotnan_spr.asm"
INCLUDE "data/credits/cast_spr/yambow_spr.asm"
INCLUDE "data/credits/cast_spr/hariharry_spr.asm"
INCLUDE "data/credits/cast_spr/cannon_spr.asm"
INCLUDE "data/credits/cast_spr/telly_spr.asm"
INCLUDE "data/credits/cast_spr/unused_blocky_spr.asm"
INCLUDE "data/credits/cast_spr/pipi_spr.asm"
INCLUDE "data/credits/cast_spr/shotman_spr.asm"
INCLUDE "data/credits/cast_spr/flyboy_spr.asm"
INCLUDE "data/credits/cast_spr/springer_spr.asm"
INCLUDE "data/credits/cast_spr/pierobot_spr.asm"
INCLUDE "data/credits/cast_spr/mole_spr.asm"
INCLUDE "data/credits/cast_spr/robbit_spr.asm"
INCLUDE "data/credits/cast_spr/cook_spr.asm"
INCLUDE "data/credits/cast_spr/batton_spr.asm"
INCLUDE "data/credits/cast_spr/puchigoblin_spr.asm"
INCLUDE "data/credits/cast_spr/scworm_spr.asm"
INCLUDE "data/credits/cast_spr/matasaburo_spr.asm"
INCLUDE "data/credits/cast_spr/kaminarigoro_spr.asm"
INCLUDE "data/credits/cast_spr/crashman_spr.asm"
INCLUDE "data/credits/cast_spr/metalman_spr.asm"
INCLUDE "data/credits/cast_spr/woodman_spr.asm"
INCLUDE "data/credits/cast_spr/airman_spr.asm"
INCLUDE "data/credits/cast_spr/hardman_spr.asm"
INCLUDE "data/credits/cast_spr/topman_spr.asm"
INCLUDE "data/credits/cast_spr/magnetman_spr.asm"
INCLUDE "data/credits/cast_spr/needleman_spr.asm"
INCLUDE "data/credits/cast_spr/quint_spr.asm"

	mIncJunk "L016E46"
