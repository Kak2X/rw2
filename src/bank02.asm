; =============== ActS_Do ===============
; Processes all active actors.
ActS_Do:
	; Start processing actors from where we left off last time
	ld   h, HIGH(wAct)				; Set high byte
	ld   a, [wActStartSlotPtr]	; A = Ptr to initial slot
.loop:
	; Save the current slot pointer for any actor code using it.
	; Generally used when actors need to check if the player has collided with them,
	; since those checks are made by comparing slot pointers.
	ld   [wActCurSlotPtr], a
	ld   l, a			; HL = Ptr to current slot
	
	; Skip empty slots
	ld   a, [hl]
	or   a				; iActId == 0?
	jr   z, .nextSlot	; If so, skip to the next one
	
	push hl
		push hl
			
			;--
			;
			; Copy the actor to a working area for processing.
			;
			ld   de, hActCur+iActId	; DE = Working area (destination)
			ld   b, iActEnd		; B = Bytes to copy
		.wkInLoop:
			ldi  a, [hl]		; Read byte from slot, SlotPtr++
			ld   [de], a		; Copy over to wk
			inc  de				; WkPtr++
			dec  b				; Are we done?
			jr   nz, .wkInLoop	; If not, loop
			;--
			
			;
			; Perform the actor-specific actions.
			;
			
			ld   a, $00					; Always needs to be reconfirmed
			ld   [wActCurSprMapBaseId], a
			
			; As actor positions are relative to the screen, if the screen scrolls horizontally,
			; their positions should be adjusted to match.
			; This happens even if the processing flag isn't set.
			call ActS_MoveByScrollX	
			
			; If the processing flag is set, execute the actor's code
			ldh  a, [hActCur+iActId]
			bit  ACTFB_PROC, a			; Processing flag set?
			jr   z, .actEnd				; If not, skip to the end
			call ActS_ExecCode
			
			; If the actor didn't despawn itself, draw its sprite mapping
			ldh  a, [hActCur+iActId]
			bit  ACTFB_PROC, a			; Processing flag still set?
			jr   z, .actEnd				; If not, skip to the end (likely zeroed out)
			ldh  a, [hWorkOAMPos]
			cp   OAM_SIZE				; OAM is full already?
			call c, ActS_DrawSprMap		; If not, draw it
			
		; 
		; Save back the changes made to the working area into the slot.
		;
	.actEnd:
		pop  de 			; DE = Slot ptr (destination)
		ld   hl, hActCur+iActId	; HL = Working area (source)
		ld   b, iActEnd		; B = Bytes to copy
	.wkOutLoop:
		ldi  a, [hl]		; Read byte from wk, WkPtr++
		ld   [de], a		; Copy back to slot
		inc  de				; SlotPtr++
		dec  b				; Are we done?
		jr   nz, .wkOutLoop	; If not, loop
	
	pop  hl
.nextSlot:
	;
	; Seek to the next actor slot.
	; If after doing this, we didn't wrap around to the starting slot yet, handle it.
	;
	ld   a, [wActStartSlotPtr]
	ld   b, a			; B = First slot handled
	ld   a, l			; A = Current slot + $10, potentially overflowing back to the start of wAct
	add  iActEnd
	cp   b				; Did we wrap around to the first slot we handled?
	jr   nz, .loop		; If not, handle this one
	
	; If we filled OAM, chances are not all actors could be drawn.
	; As the processing order and draw order are one and the same, "shuffle"
	; it by starting processing actors from after the last drawn one.
	; Note that regardless of the starting slot, every time all 16 actors are
	; handled -- the game never skips processing actors when they are enabled.

	ldh  a, [hWorkOAMPos]
	cp   OAM_SIZE		; Did we fill up OAM?
	ret  nz				; If not, return
	
	; Note that this value doesn't need to be reset to 0 at any time, since
	; it can wrap around just fine.
	ld   a, [wActLastDrawSlotPtr]
	ld   [wActStartSlotPtr], a
	ret
	
; =============== ActS_ExecCode ===============
; Executes actor-specific code.
ActS_ExecCode:
	ldh  a, [hActCur+iActId]
	and  $FF^ACTF_PROC			; Remove processing flag
	rst  $00 ; DynJump
	; There are no invalid IDs, every entry is filled in some way.
	dw Act_ExplSm				; ACT_EXPLSM
	; Items specifically sorted by item drop rarity, see ActS_TrySpawnItemDrop
	dw Act_Item					; ACT_1UP
	dw Act_Item					; ACT_AMMOLG
	dw Act_Item					; ACT_HEALTHLG
	dw Act_Item					; ACT_HEALTHSM
	dw Act_Item					; ACT_AMMOSM
	; This one is excluded from item drops for obvious reasons
	dw Act_Item					; ACT_ETANK
	dw Act_ExplLgPart			; ACT_EXPLLGPART
	dw Act_Bee					; ACT_BEE
	dw Act_BeeHive				; ACT_BEEHIVE
	dw Act_Chibee				; ACT_CHIBEE
	dw Act_Wanaan				; ACT_WANAAN
	dw Act_HammerJoe			; ACT_HAMMERJOE
	dw Act_Hammer				; ACT_HAMMER
	dw Act_NeoMonking			; ACT_NEOMONKING
	dw Act_NeoMet				; ACT_NEOMET
	dw Act_PickelmanBull		; ACT_PICKELBULL
	dw Act_Bikky				; ACT_BIKKY
	dw Act_Komasaburo			; ACT_KOMASABURO
	dw Act_Koma					; ACT_KOMA
	dw Act_Mechakkero			; ACT_MECHAKKERO
	dw Act_SpinTopU				; ACT_SPINTOPU
	dw Act_SpinTopD				; ACT_SPINTOPD
	dw Act_Tama					; ACT_TAMA
	dw Act_TamaBall				; ACT_TAMABALL
	dw Act_TamaFlea				; ACT_TAMAFLEA
	dw Act_MagFly				; ACT_MAGFLY
	dw Act_GiantSpringer		; ACT_GSPRINGER
	dw Act_GiantSpringerShot	; ACT_GSPRINGERSHOT
	dw Act_Peterchy				; ACT_PETERCHY
	dw Act_MagnetField			; ACT_MAGNETFIELD
	dw Act_Respawner			; ACT_RESPAWNER ;X
	dw Act_Block				; ACT_BLOCK0
	dw Act_Block				; ACT_BLOCK1
	dw Act_Block				; ACT_BLOCK2
	dw Act_Block				; ACT_BLOCK3
	dw Act_NewShotman			; ACT_NEWSHOTMAN
	dw Act_NeedlePress			; ACT_NEEDLEPRESS
	dw Act_Yambow				; ACT_YAMBOW
	dw Act_HariHarry			; ACT_HARI
	dw Act_HariHarryShot		; ACT_HARISHOT
	dw Act_Cannon				; ACT_CANNON
	dw Act_CannonShot			; ACT_CANNONSHOT
	dw Act_TellySpawner			; ACT_TELLYSPAWN
	dw Act_Lift					; ACT_LIFT0
	dw Act_Lift					; ACT_LIFT1
	dw Act_Lift					; ACT_LIFT2
	dw Act_BlockyHead			; ACT_BLOCKYHEAD
	dw Act_BlockyBody			; ACT_BLOCKYBODY
	dw Act_BlockyRise			; ACT_BLOCKYRISE
	dw Act_Pipi					; ACT_PIPI
	dw Act_Egg					; ACT_EGG
	dw Act_Copipi				; ACT_COPIPI
	dw Act_Shotman				; ACT_SHOTMAN
	dw Act_FlyBoy				; ACT_FLYBOY
	dw Act_FlyBoySpawner		; ACT_FLYBOYSPAWN
	dw Act_Springer				; ACT_SPRINGER
	dw Act_PieroBotGear			; ACT_PIEROGEAR
	dw Act_PieroBot				; ACT_PIEROBOT
	dw Act_Mole					; ACT_MOLE
	dw Act_MoleSpawner			; ACT_MOLESPAWN
	dw Act_Press				; ACT_PRESS
	dw Act_Robbit				; ACT_ROBBIT
	dw Act_RobbitCarrot			; ACT_CARROT
	dw Act_Cook					; ACT_COOK
	dw Act_CookSpawner			; ACT_COOKSPAWN
	dw Act_Batton				; ACT_BATTON
	dw Act_Friender				; ACT_FRIENDER
	dw Act_FrienderFlame		; ACT_FLAME
	dw Act_GoblinHorn			; ACT_GOBLINHORN
	dw Act_Goblin				; ACT_GOBLIN
	dw Act_PuchiGoblin			; ACT_PUCHIGOBLIN
	dw Act_ScwormBase			; ACT_SCWORMBASE
	dw Act_ScwormShot			; ACT_SCWORMSHOT
	dw Act_Matasaburo			; ACT_MATASABURO
	dw Act_KaminariGoro			; ACT_KAMINARIGORO
	dw Act_KaminariCloud		; ACT_KAMINARICLOUD
	dw Act_Kaminari				; ACT_KAMINARI
	dw Act_Telly				; ACT_TELLY
	dw Act_PipiSpawner			; ACT_PIPISPAWN
	dw Act_Wily1				; ACT_WILY1
	dw Act_Wily2				; ACT_WILY2
	dw Act_Wily3				; ACT_WILY3
	dw Act_Quint				; ACT_QUINT
	dw Act_Wily3Part			; ACT_WILY3PART
	dw Act_Wily2Intro		; ACT_WILY2INTRO
	dw Act_QuintSakugarne		; ACT_QUINT_SG
	dw Act_QuintDebris			; ACT_QUINT_DEBRIS
	dw Act_Wily1Bomb			; ACT_WILY1BOMB
	dw Act_Wily1Nail			; ACT_WILY1NAIL
	dw Act_Wily2Bomb			; ACT_WILY2BOMB
	dw Act_Wily2Shot			; ACT_WILY2SHOT
	dw Act_Wily3Missile			; ACT_WILY3MISSILE
	dw Act_Wily3Met				; ACT_WILY3MET
	dw Act_WilyCtrl				; ACT_WILYCTRL
	dw Act_ExplSm				; ACT_5F ;X
	dw Act_RushCoil				; ACT_WPN_RC
	dw Act_RushMarine			; ACT_WPN_RM
	dw Act_RushJet				; ACT_WPN_RJ
	dw Act_Sakugarne			; ACT_WPN_SG
	dw Act_Bubble				; ACT_BUBBLE
	dw Act_WilyCastleCutscene	; ACT_WILYCASTLESC
	dw Act_TeleporterRoom		; ACT_TELEPORTCTRL
	dw Act_TeleporterLight		; ACT_TELEPORTLIGHT
	dw Act_HardMan				; ACT_HARDMAN
	dw Act_TopMan				; ACT_TOPMAN
	dw Act_MagnetMan			; ACT_MAGNETMAN
	dw Act_NeedleMan			; ACT_NEEDLEMAN
	dw Act_CrashMan				; ACT_CRASHMAN
	dw Act_MetalMan				; ACT_METALMAN
	dw Act_WoodMan				; ACT_WOODMAN
	dw Act_AirMan				; ACT_AIRMAN
	dw Act_HardKnuckle			; ACT_HARDKNUCKLE
	dw Act_TopManShot			; ACT_SPINTOPSHOT
	dw Act_MagnetManShot		; ACT_MAGNETMISSILE
	dw Act_NeedleManShot		; ACT_NEEDLECANNON
	dw Act_CrashManShot			; ACT_CRASHBOMB
	dw Act_MetalManShot			; ACT_METALBLADE
	dw Act_AirManShot			; ACT_WHIRLWIND
	dw Act_WoodManLeafShield	; ACT_LEAFSHIELD
	dw Act_WoodManLeafRise		; ACT_LEAFRISE
	dw Act_WoodManLeafFall		; ACT_LEAFFALL
	dw Act_CrashManShotExpl		; ACT_CRASHBOMBEXPL
	dw Act_GroundExpl			; ACT_GROUNDEXPL
	dw Act_NeoMetShot			; ACT_NEOMETSHOT
	dw Act_NewShotmanShotV		; ACT_NEWSHOTMANSHOTV
	dw Act_NewShotmanShotH		; ACT_NEWSHOTMANSHOTH
	dw Act_ShotmanShot			; ACT_SHOTMANSHOT

; =============== Act_ExplSm ===============
; ID: ACT_EXPLSM
; Small explosion.
;
; This actor isn't directly spawned in a level -- when defeating enemies, their actor ID
; gets replaced by ACT_EXPLSM, and so they keep most of their properties, such as
; coordinates and collision box (see below).
Act_ExplSm:
	; Typically, the first routine is used to initialize the actor
	ldh  a, [hActCur+iActRtnId]
	and  $7F
	rst  $00 ; DynJump
	dw Act_ExplSm_Init
	dw Act_ExplSm_Anim
	
; =============== Act_ExplSm_Init ===============
Act_ExplSm_Init:
	;
	; Place the explosion at the center of the actor that just died.
	;
	; Currently the explosion is at the previous actor's origin, so it needs
	; to be moved up by the vertical radius of the collision box.
	; Of course, this assumes the sprite mapping to not be weirdly offset from its origin.
	;
	ld   h, HIGH(wActColi)		; Seek HL to iActColiBoxV, vertical radius
	ld   a, [wActCurSlotPtr]
	ld   l, a
	inc  l ; iActColiBoxV
	ldh  a, [hActCur+iActY]		; Move the actor up by that
	sub  [hl]
	ldh  [hActCur+iActY], a
	
	ld   a, SFX_ENEMYDEAD		; Play explosion sound
	ldh  [hSFXSet], a
	jp   ActS_IncRtnId
	
; =============== Act_ExplSm_Anim ===============
Act_ExplSm_Anim:
	; Advance the animation at 1/4 speed, every four frames.
	ldh  a, [hActCur+iActSprMap]
	add  $02						; Timer += 2
	and  $1F						; Force valid frame range
	ldh  [hActCur+iActSprMap], a
	
	; If we went past the last valid sprite, the animation is over.
	srl  a				; >> 3 to sprite ID
	srl  a
	srl  a
	and  $03			; Filter out other flags
	cp   $03			; Sprite ID reached $03?
	ret  nz				; If not, return
	jp   ActS_Despawn	; Otherwise, we're done
	
; =============== Act_Item ===============
; ID: ACT_1UP, ACT_AMMOLG, ACT_HEALTHLG, ACT_HEALTHSM, ACT_AMMOSM, ACT_ETANK
; Collectable Items.
; While these use the same actor code, their effects when collected by the player
; are handled separately by Pl_DoActColi.coliItem, which goes off their actor ID.
Act_Item:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_ItemFixed_Anim
	dw Act_ItemDrop_Init
	dw Act_ItemDrop_MoveU
	dw Act_ItemDrop_MoveD
	dw Act_ItemDrop_InitGround
	dw Act_ItemDrop_Ground
	dw Act_ItemDrop_Flash
	
; =============== Act_ItemFixed_Anim ===============
; Item directly part of the level, never despawns over time.
; This is the first routine since actors defined in the actor layout
; *always* spawn in their first routine, no exceptions.
Act_ItemFixed_Anim:
	; Every item has the same 2-frame animation, at 1/8 speed.
	; Those that don't animate, like E-Tanks, merely repeat the same two frames.
	ld   c, $01
	call ActS_Anim2
	ret
	
; =============== Act_ItemDrop_* ===============
; The rest of these routines are used to handle item drops from defeated enemies,
; which are spawned through ActS_TrySpawnItemDrop.
; These items fall down until they hit a solid block (but not actor platforms,
; for performance reasons) and despawn after some amount of time.
	
; =============== Act_ItemDrop_Init ===============
Act_ItemDrop_Init:
	;--
	; Try to move the actor a bit closer to the explosion.
	; This is the same thing done in Act_ExplSm_Init, except here it's not exactly accurate
	; given iActColiBoxV isn't inherited.
	ld   h, HIGH(wActColi)		; Seek HL to iActColiBoxV, vertical radius
	ld   a, [wActCurSlotPtr]
	ld   l, a
	inc  l ; iActColiBoxV
	ldh  a, [hActCur+iActY]		; Move the actor up by that
	sub  [hl]
	ldh  [hActCur+iActY], a
	;--
	ld   c, $01
	call ActS_Anim2
	ld   bc, $0300				; 3px/frame upwards speed
	call ActS_SetSpeedY
	ld   b, $00					; Cannot collect it while moving up
	call ActS_SetColiType
	jp   ActS_IncRtnId			; Next mode
	
; =============== Act_ItemDrop_MoveU ===============
; Move upwards until it hits a ceiling, reach the peak of the jump, or are near the top of the screen.
; The item can't be collected during this.
Act_ItemDrop_MoveU:
	ld   c, $01
	call ActS_Anim2
	
	;--
	; If our current speed would move us near the top of the screen, cut the jump
	ldh  a, [hActCur+iActSpdYSub]	; BC = Y Speed
	ld   c, a
	ldh  a, [hActCur+iActSpdY]
	ld   b, a
	ldh  a, [hActCur+iActYSub]		; Set carry from iActYSub - C
	sub  c
	ldh  a, [hActCur+iActY]			; A = iActY - B - carry
	sbc  b
	and  $F0						; Check block row range
	cp   $00						; Are we in the top row? ($00-$0F)
	jr   z, .setMoveD				; If so, cut the jump
	;--
	call ActS_ApplySpeedUpYColi		; Otherwise, apply gravity
	ret  c							; Did we move anywhere? If so, return
.setMoveD:							; Otherwise, we hit a solid block or gravity set our speed to 0
	ld   b, ACTCOLI_ITEM			; Make item tangible as it moves down
	call ActS_SetColiType
	jp   ActS_IncRtnId
	
; =============== Act_ItemDrop_MoveD ===============
; The item moves down.
Act_ItemDrop_MoveD:
	ld   c, $01
	call ActS_Anim2
	call ActS_ApplySpeedDownYColi	; Apply gravity
	ret  c							; Hit a solid block? If not, return
	jp   ActS_IncRtnId
	
; =============== Act_ItemDrop_InitGround ===============
; Prepares the item to be on the ground.
Act_ItemDrop_InitGround:
	ld   c, $01
	call ActS_Anim2
	ld   a, 3*60					; 3 seconds before flashing
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_ItemDrop_Ground ===============
; Item is on the ground.
; Once on the ground, it won't check for collision anymore.
Act_ItemDrop_Ground:
	ld   c, $01
	call ActS_Anim2
	
	ldh  a, [hActCur+iActTimer0C]	; Wait those 3 seconds
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	ld   a, 2*60					; 2 seconds before despawning
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_ItemDrop_Flash ===============
; Item is fading out.
Act_ItemDrop_Flash:
	; For this part, extend the animation to 3 frames, at 1/4 speed.
	; This third frame is fully blank, giving the effect of the item fading out.
	ld   bc, ($03 << 8)|$02			; B = 3 frames, C = 2/8 speed
	call ActS_AnimCustom
	
	ldh  a, [hActCur+iActTimer0C]	; Wait those 2 seconds
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	xor  a							; Despawn
	ldh  [hActCur+iActId], a
	ret
	
; =============== Act_ExplLgPart ===============
; ID: ACT_EXPLLGPART
; Individual particle for the large 8-way explosion displayed when either:
; - The player dies
; - A boss dies
; - Energy is being absorbed
; See also: ActS_SpawnLargeExpl, ActS_SpawnAbsorb
Act_ExplLgPart:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_ExplLgPart_Init
	dw Act_ExplLgPart_Move
; =============== Act_ExplLgPart_Init ===============
Act_ExplLgPart_Init:
	; Boss explosions and the weapon absorption particles move twice as fast.
	ld   a, [wLvlEnd]
	cp   LVLEND_PLDEAD			; Is the player exploding?
	call nz, ActS_DoubleSpd		; If not, speed up
	jp   ActS_IncRtnId
; =============== Act_ExplLgPart_Move ===============
Act_ExplLgPart_Move:
	ld   bc, ($03 << 8)|$01			; B = 3 frames, C = 1/8 speed
	call ActS_AnimCustom
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
; =============== Act_Bee ===============
; ID: ACT_BEE
; Giant bee carrying a beehive coming from behind, which it drops
; on the ground to spawn many smaller bees.
Act_Bee:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Bee_InitChild
	dw Act_Bee_InitPath
	dw Act_Bee_MoveToTarget
	dw Act_Bee_MoveU
	dw Act_Bee_MoveD
	dw Act_Bee_FlyAway

; =============== Act_Bee_InitChild ===============
; Spawns the beehive.
Act_Bee_InitChild:
	; Spawn the child beehive directly below.
	; If the beehive couldn't spawn, don't continue and try again next frame.
	ld   a, ACT_BEEHIVE
	ld   bc, ($00 << 8)|$0C		; 12px below
	call ActS_SpawnRel			; Could it spawn?
	ret  c						; If not, return
	
	; Keep track of the slot the beehive spawned into.
	; By convention, tracked child slots are written into iAct0D/iActChildSlotPtr,
	; as some shared helper subroutines expect it to be there.
	ld   a, l
	ldh  [hActCur+iActChildSlotPtr], a
	jp   ActS_IncRtnId
	
; =============== Act_Bee_InitPath ===============
; Sets up the bee's initial horizontal path.
Act_Bee_InitPath:
	call ActS_ChkExplodeWithChild	; Did we defeat the bee?
	ret  c							; If so, return (bee and beehive despawned)
									; Otherwise...
	ld   c, $02				; Animate wings at 1/4
	call ActS_Anim2
	call ActS_FacePl		; Move towards the player
	
	; Set the 2px/frame forward speed, will be used immediately
	ld   bc, $0200			; 2px/frame forward
	call ActS_SetSpeedX
	
	; Set for later a 0.125px/frame vertical speed, it will be used
	; when the bee bobs when it's about to drop the hive
	ld   bc, $0020
	call ActS_SetSpeedY
	
	;
	; Set the target position for the bee, it will stop moving when it's reached.
	;
	; The bee will pick the opposite side of the screen while coming from behind,
	; to try place itself in front of the player at the time of this check.
	; Since the target is relative to the screen, attempting to outrun the bee
	; will move the target with it.
	; 
	ld   b, OBJ_OFFSET_X+$08						; B = 0-16 pixels from the left edge
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a								; Facing right?
	jr   z, .setTarget								; If not, jump (if facing left, the bee spawned on the right)
	ld   b, OBJ_OFFSET_X+SCREEN_GAME_H-BLOCK_H-$08	; B = 0-16 pixels from the right edge (bee spawned on the left)
.setTarget:
	ld   a, b
	ldh  [hActCur+iBeeTargetX], a
	jp   ActS_IncRtnId

; =============== Act_Bee_MoveToTarget ===============
; Move horizontally until it reaches the target.
Act_Bee_MoveToTarget:
	call ActS_ChkExplodeWithChild
	ret  c
	
	ld   c, $02	
	call ActS_Anim2
	
	; Move forward at 2px/frame
	call ActS_ApplySpeedFwdX
	
	; If we didn't reach the target yet, return.
	ldh  a, [hActCur+iActX]			; Get bee position
	and  $F0						; Check 16px wide range to avoid missing the pixel (clear low nybble)
	ld   b, a
	ldh  a, [hActCur+iBeeTargetX]	; Get target
	and  $F0						; Check 16px ...
	cp   b							; Do the ranges match?
	ret  nz							; If not, return
	
	; Target reached, turn the other side (the player) and wait for a bit
	call ActS_FlipH
	ld   a, $00
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Bee_MoveU ===============
; Bob upwards for a bit, waiting.	
Act_Bee_MoveU:
	call ActS_ChkExplodeWithChild
	ret  c
	ld   c, $02
	call ActS_Anim2
	
	; Move up at 0.125px/frame
	call ActS_ApplySpeedFwdY
	
	; Do so for 20 frames
	ldh  a, [hActCur+iActTimer0C]
	add  $01
	ldh  [hActCur+iActTimer0C], a
	cp   $14
	ret  nz
	
	; Move vertically after that
	call ActS_FlipV
	jp   ActS_IncRtnId
	
; =============== Act_Bee_MoveD ===============
; Bob downwards for a bit, waiting.	
Act_Bee_MoveD:
	call ActS_ChkExplodeWithChild
	ret  c
	ld   c, $02
	call ActS_Anim2
	
	; Move down at 0.125px/frame
	call ActS_ApplySpeedFwdY
	
	; Do so for 40 frames
	ldh  a, [hActCur+iActTimer0C]
	add  $01
	ldh  [hActCur+iActTimer0C], a
	cp   $28
	ret  nz
	
	; Flip back to its original direction
	call ActS_FlipH
	jp   ActS_IncRtnId
	
; =============== Act_Bee_FlyAway ===============
; Move the bee horizontally in the same horizontal direction 
; from Act_Bee_MoveToTarget until it gets offscreened.
; Act_BeeHive is manually timed to drop itself during this mode.
Act_Bee_FlyAway:
	ld   c, $02
	call ActS_Anim2
	; Move forward at 2px/frame
	call ActS_ApplySpeedFwdX
	ret
	
; =============== Act_BeeHive ===============
; ID: ACT_BEEHIVE
; Beehive carried by a giant bee, when it drops it blows up, spawning smaller bees.
;
; Child actor for Act_Bee, but completely independent so its speed and timings need
; to be consistent with those from its parent.
Act_BeeHive:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BeeHive_InitPath
	dw Act_BeeHive_MoveToTarget
	dw Act_BeeHive_MoveU
	dw Act_BeeHive_MoveD
	dw Act_BeeHive_Drop

; =============== Act_BeeHive_InitPath ===============
; Identical to Act_Bee_InitPath except the hive doesn't animate and can't be hit.
; These differences also apply to the next routines.
Act_BeeHive_InitPath:
	call ActS_FacePl
	
	ld   bc, $0200			; 2px/frame forward speed
	call ActS_SetSpeedX
	
	ld   bc, $0020			; 0.125px/frame vertical speed
	call ActS_SetSpeedY
	
	; Set target pos
	ld   b, OBJ_OFFSET_X+$08
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a
	jr   z, .setTarget
	ld   b, OBJ_OFFSET_X+SCREEN_GAME_H-BLOCK_H-$08
.setTarget:
	ld   a, b
	ldh  [hActCur+iBeeTargetX], a
	jp   ActS_IncRtnId
	
; =============== Act_BeeHive_MoveToTarget ===============
; Move horizontally until it reaches the target.
Act_BeeHive_MoveToTarget:
	call ActS_ApplySpeedFwdX
	
	; Check target pos
	ldh  a, [hActCur+iActX]
	and  $F0
	ld   b, a
	ldh  a, [hActCur+iBeeTargetX]
	and  $F0
	cp   b
	ret  nz
	
	; (Hive doesn't turn)
	ld   a, $00
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_BeeHive_MoveU ===============
; Bob upwards for a bit, waiting.		
Act_BeeHive_MoveU:
	; Move up at 0.125px/frame
	call ActS_ApplySpeedFwdY
	
	; Do so for 20 frames
	ldh  a, [hActCur+iActTimer0C]
	add  $01
	ldh  [hActCur+iActTimer0C], a
	cp   $14
	ret  nz
	
	; Move vertically after that
	call ActS_FlipV
	jp   ActS_IncRtnId
	
; =============== Act_BeeHive_MoveD ===============
; Bob downwards for a bit, waiting.	
Act_BeeHive_MoveD:
	; Move down at 0.125px/frame
	call ActS_ApplySpeedFwdY
	
	; Do so for 40 frames
	ldh  a, [hActCur+iActTimer0C]
	add  $01
	ldh  [hActCur+iActTimer0C], a
	cp   $28
	ret  nz
	
	; This is where the beehive and bee diverge.
	; Reset the hive's vertical speed, in preparation for dropping it on the ground.
	xor  a							; And sprite flags too
	ldh  [hActCur+iActSprMap], a
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_BeeHive_Drop ===============
; The beehive drops.
Act_BeeHive_Drop:
	; Continue falling down until hitting a solid block
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; Once we do, immediately despawn the hive.
	xor  a
	ldh  [hActCur+iActId], a
	
	; Try to spawn five chibees around the hive.
	; These bees are what handle the hive explosion, as the hive itself has just despawned.
	ld   a, ACT_CHIBEE
	ld   bc, (-$10 << 8)|LOW(-$10)	; Top left		
	call ActS_SpawnRel
	ret  c
	ld   a, ACT_CHIBEE
	ld   bc, ($10 << 8)|LOW(-$10)	; Top right	
	call ActS_SpawnRel
	ret  c
	ld   a, ACT_CHIBEE
	ld   bc, (-$10 << 8)|$10	; Bottom left	
	call ActS_SpawnRel
	ret  c
	ld   a, ACT_CHIBEE
	ld   bc, ($10 << 8)|$10		; Bottom right	
	call ActS_SpawnRel
	ret  c
	ld   a, ACT_CHIBEE
	ld   bc, ($00 << 8)|$00		; Centered
	call ActS_SpawnRel
	ret
	
; =============== Act_Chibee ===============
; ID: ACT_CHIBEE
; Small bee homing into the player.
Act_Chibee:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Chibee_ExplAnim
	dw Act_Chibee_MoveLine
	dw Act_Chibee_MoveArc
	
	DEF ACTRTN_CHIBEE_MOVELINE = $01
	
; =============== Act_Chibee_ExplAnim ===============
; Animates the explosion effect, using identical code to Act_ExplSm_Anim.
; The first three sprite mappings for the small bee are explosion frames.
Act_Chibee_ExplAnim:
	; Advance the animation at 1/4 speed, every four frames.
	ldh  a, [hActCur+iActSprMap]
	add  $02						; Timer += 2
	and  $1F						; Force valid frame range
	ldh  [hActCur+iActSprMap], a
	
	; If we went past the last valid sprite, the animation is over.
	srl  a				; >> 3 to sprite ID
	srl  a
	srl  a
	and  $03			; Filter out other flags
	cp   $03			; Sprite ID reached $03?
	ret  nz				; If not, return
	jp   ActS_IncRtnId	; Otherwise, next mode
	
; =============== Act_Chibee_MoveLine ===============
; Moves the bee in a straight line towards the player.
Act_Chibee_MoveLine:
	; Use the 2-frame animation at $03-$04
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ld   c, $02
	call ActS_Anim2
	
	; Move the bee directly towards the player until it gets too close
	call ActS_AngleToPl
	ld   a, [tActPlYDiff]	; Get Y distance
	ld   b, a
	ld   a, [tActPlXDiff]	; Get X distance
	or   b					; Are both of them...
	cp   $10				; ...less than 16?
	jr   c, .nextMode		; If so, prepare circling around
	
.moveDiag:
	; Move diagonally at half speed
	call ActS_HalfSpdSub
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
.nextMode:
	call ActS_InitCirclePath
	jp   ActS_IncRtnId
	
; =============== Act_Chibee ===============
; Moves the bee in a circular path for ~3 seconds, then loops back to Act_Chibee_MoveLine.
Act_Chibee_MoveArc:
	; Use the 2-frame animation at $03-$04
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ld   c, $02
	call ActS_Anim2
	
	; Wait nearly 3 seconds before returning to the previous mode
	ldh  a, [hActCur+iActTimer0C]
	add  $01
	ldh  [hActCur+iActTimer0C], a
	cp   $B0							; Timer < $B0?
	jr   c, .doArc						; If so, skip
	ld   a, ACTRTN_CHIBEE_MOVELINE
	ldh  [hActCur+iActRtnId], a
	
.doArc:
	ld   a, ARC_SM						; Move along a small circular path
	call ActS_ApplyCirclePath
	call ActS_HalfSpdSub				; At half speed as always
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
; =============== Act_Wanaan ===============
; ID: ACT_WANAAN
; Retractable trap that activates when the player gets close.
Act_Wanaan:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wanaan_Init
	dw Act_Wanaan_ChkDistance
	dw Act_Wanaan_Wait
	dw Act_Wanaan_MoveU
	dw Act_Wanaan_MoveD
	
	DEF ACTRTN_WANAAN_CHKDISTANCE = $01

; =============== Act_Wanaan_Init ===============
Act_Wanaan_Init:
	; Make intangible while retracted
	ld   b, ACTCOLI_PASS
	call ActS_SetColiType
	
	; The center of the pipe is 8px to the right
	ldh  a, [hActCur+iActX]
	add  $08
	ldh  [hActCur+iActX], a
	
	; Rise and retract at 2px/frame
	ld   bc, $0200
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_Wanaan_ChkDistance ===============
Act_Wanaan_ChkDistance:
	; Do not activate if the player is below
	ld   a, [wPlRelY]		; B = PlY
	ld   b, a
	ldh  a, [hActCur+iActY]	; A = ActY
	sub  b					; ActY - PlY < 0? (ActY < PlY)
	ret  c					; If so, return
	
	; Wait for the player to get within 20px horizontally before activating
	call ActS_GetPlDistanceX
	cp   $14
	ret  nc
	
	; Delay activation by $1E frames
	ld   a, $1E
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Wanaan_Wait ===============
Act_Wanaan_Wait:
	; Wait for it...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Show sprite
	ld   a, $01
	call ActS_SetSprMapId
	; Make tangible and invulnerable
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType
	; Move up for 16 frames
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Wanaan_MoveU ===============
Act_Wanaan_MoveU:
	; Move up for 16 frames at 2px/frame (2 blocks up)
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Close grip
	ld   a, $02
	call ActS_SetSprMapId
	
	; Start retracting to the ground
	call ActS_FlipV
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Wanaan_MoveD ===============
Act_Wanaan_MoveD:
	; Move down for 16 frames at 2px/frame (2 blocks up)
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; We're back inside the pipe
	
	; Hide sprite (its first is blank)
	ld   a, $00
	call ActS_SetSprMapId
	; Make intangible while retracted
	ld   b, ACTCOLI_PASS
	call ActS_SetColiType
	; Set direction for rising up
	call ActS_FlipV
	ld   a, ACTRTN_WANAAN_CHKDISTANCE
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_HammerJoe ===============
; ID: ACT_HAMMERJOE
; Sniper Joe throwing hammers forward.
Act_HammerJoe:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_HammerJoe_Init
	dw Act_HammerJoe_Swing
	dw Act_HammerJoe_Throw
	DEF ACTRTN_HAMMERJOE_INIT = $00
	DEF ACTRTN_HAMMER_INITTHROW = $01

; =============== Act_HammerJoe_Init ===============
Act_HammerJoe_Init:
	; Spawn Hammer Joe's hammer immediately.
	; [BUG] Unlike with bees, no check if made if the hammer could actually spawn.
	;       Hammer Joe's placement makes it impossible to trigger, but if it could,
	;       the first slot would be treated as the hammer.
	ld   a, ACT_HAMMER
	ld   bc, ($00 << 8)|LOW(-$1E)	; 30px above, right above the top of the collosion box
	call ActS_SpawnRel
	ld   a, l						; Keep track of child
	ldh  [hActCur+iActChildSlotPtr], a
	
	; The hammer moves 2px/frame forward
	add  iActSpdXSub
	ld   l, a
	ld   a, $00
	ldi  [hl], a ; iActSpdXSub
	ld   a, $02
	ld   [hl], a ; iActSpdX
	
	ld   a, $00
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_HammerJoe_Swing ===============
; Swing the hammer while invulnerable.
Act_HammerJoe_Swing:
	;--
	; Not necessary given it's invulnerable here
	call ActS_ChkExplodeWithChild
	ret  c
	;--
	
	; Hammer Joe itself only has a 2-frame animation, it's the hammer that has four.
	ld   c, $01
	call ActS_Anim2
	
	; Always face the player while swinging
	call ActS_FacePl
	
	;--
	;
	; Make the hammer do so too.
	;
	
	; HL = Ptr to hammer iActSprMap
	ld   h, HIGH(wAct)			
	ldh  a, [hActCur+iActChildSlotPtr]
	inc  a ; iActRtnId
	inc  a ; iActSprMap
	ld   l, a
	
	; B = Joe's direction
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R
	ld   b, a
	
	ld   a, [hl]		; Read hammer iActSprMap
	and  $FF^ACTDIR_R	; Delete direction flag
	or   b				; Merge with ours
	ld   [hl], a		; Save back
	;--
	

	ldh  a, [hActCur+iActTimer0C]	; Timer++
	add  $01
	ldh  [hActCur+iActTimer0C], a
	
	;
	; After 1 second, open Joe's eyes and make him vulnerable.
	; Half a second after that, throw the hammer forward.
	;
	ld   b, ACTCOLI_ENEMYREFLECT
	cp   60+30						; Timer == $5A? (half a second passed after $3C)
	jr   z, .throw					; If so, jump
	cp   60							; Timer < $3C? (second hasn't passed yet)
	jr   c, .setColi				; If so, jump
.openEyes:
	ld   a, $02						; Use frames $02-$03, with eye open	
	ld   [wActCurSprMapBaseId], a
	ld   b, ACTCOLI_ENEMYHIT		; Make vulnerable
.setColi:
	ld   b, b
	call ActS_SetColiType
	ret
.throw:

	ld   a, $00
	ldh  [hActCur+iActTimer0C], a
	
	; Reset animation frame
	call ActS_ClrSprMapId
	
	; Advance the child hammer's routine to throw it forward
	ld   h, HIGH(wAct)				 ; HL = Ptr to hammer iActRtnId
	ldh  a, [hActCur+iActChildSlotPtr]
	inc  a
	ld   l, a
	ld   a, ACTRTN_HAMMER_INITTHROW
	ldi  [hl], a
	
	jp   ActS_IncRtnId
	
; =============== Act_HammerJoe_Throw ===============
; Wait a second before looping to the start.
Act_HammerJoe_Throw:
	; If defeated during this, also kill off the hammer
	call ActS_ChkExplodeWithChild
	ret  c
	
	; Use throw frame
	ld   a, $04
	ld   [wActCurSprMapBaseId], a
	
	; Wait for one second
	ldh  a, [hActCur+iActTimer0C]
	add  $01
	ldh  [hActCur+iActTimer0C], a
	cp   60
	ret  nz
	
	; Make invulnerable again
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType
	
	; Back to start
	ld   a, ACTRTN_HAMMERJOE_INIT
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Hammer ===============
; ID: ACT_HAMMER
; Hammer thrown by Hammer Joe.
Act_Hammer:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Hammer_Swing
	dw Act_Hammer_InitThrow
	dw Act_Hammer_Throw

; =============== Act_Hammer_Swing ===============
Act_Hammer_Swing:
	; 4-frame swinging hammer anim at 1/4 speed (frames $00-$03)
	ld   c, $02
	call ActS_Anim4
	ret
	
; =============== Act_Hammer_InitThrow ===============
; Sets up the animation and position for the thrown hammer.
Act_Hammer_InitThrow:
	; Switch to frame $04 (part of the throw anim)
	ld   a, $00
	call ActS_SetSprMapId
	ld   a, $04
	ld   [wActCurSprMapBaseId], a
	
	; Not actually vulnerable, it's set to be invulnerable to all weapons
	ld   b, ACTCOLI_ENEMYHIT
	call ActS_SetColiType
	
	;
	; As Hammer Joe's arm is logically moved forward when throwing, reposition the hammer...
	;
	
	; ...18px down
	ldh  a, [hActCur+iActY]
	add  $12
	ldh  [hActCur+iActY], a
	
	; ...and 20px forward
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a			; Facing right?
	jr   nz, .moveR				; If so, jump
.moveL:
	ldh  a, [hActCur+iActX]
	sub  $18
	ldh  [hActCur+iActX], a
	jp   ActS_IncRtnId
.moveR:
	ldh  a, [hActCur+iActX]
	add  $18
	ldh  [hActCur+iActX], a
	jp   ActS_IncRtnId
	
; =============== Act_Hammer_Throw ===============
; Hammer is thrown forward at 2px/frame.
Act_Hammer_Throw:
	; 2-frame animation at $04-$05 when moving through the air
	ld   c, $01
	call ActS_Anim2
	ld   a, $04
	ld   [wActCurSprMapBaseId], a
	; Move forward at 2px/frame.
	call ActS_ApplySpeedFwdX
	ret
	
; =============== Act_NeoMonking ===============
; ID: ACT_NEOMONKING
Act_NeoMonking:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_NeoMonking_WaitGround
	dw Act_NeoMonking_JumpCeil
	dw Act_NeoMonking_WaitCeil
	dw Act_NeoMonking_DropCeil
	dw Act_NeoMonking_InitJump
	dw Act_NeoMonking_JumpU
	dw Act_NeoMonking_JumpD
	DEF ACTRTN_NEOMONKING_INITJUMP = $04

; =============== Act_NeoMonking_WaitGround ===============
; Waits on the ground until the player gets close.
Act_NeoMonking_WaitGround:
	ld   c, $01
	call ActS_Anim2
	call ActS_FacePl
	
	; Wait until the player gets within 4 blocks
	call ActS_GetPlDistanceX
	cp   BLOCK_H*4
	ret  nc
	
	; Set 4px/frame jump speed
	ld   bc, $0400
	call ActS_SetSpeedY
	
	; Jump to the ceiling
	jp   ActS_IncRtnId
	
; =============== Act_NeoMonking_JumpCeil ===============
; Jumps up in the air.
Act_NeoMonking_JumpCeil:
	; Use frames $00-$01, at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	call ActS_FacePl
	
	; Move up at 4px/frame until a solid block is above
	call ActS_ApplySpeedFwdY	; Move up
	ldh  a, [hActCur+iActX]		; X Target: ActX
	ld   [wTargetRelX], a
	ldh  a, [hActCur+iActY]		; Y Target: ActY - $18
	sub  $18
	ld   [wTargetRelY], a
	call Lvl_GetBlockId			; Is there a solid block there?
	ret  c						; If not, return
	jp   ActS_IncRtnId			; Start idling
	
; =============== Act_NeoMonking_WaitCeil ===============
; Holds on the ceiling until the player gets even closer.
Act_NeoMonking_WaitCeil:
	; Use frames $02-$05, at 1/8 speed
	ld   c, $01
	call ActS_Anim4
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	
	call ActS_FacePl
	
	; Wait until the player gets within 1 block
	call ActS_GetPlDistanceX
	cp   BLOCK_H
	ret  nc
	
.startJumpD:
	; Reset relative frame, in preparation for the next base 
	call ActS_ClrSprMapId
	
	; Reset gravity
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_NeoMonking_DropCeil ===============
; Jumps down from the ceiling.
Act_NeoMonking_DropCeil:
	; Use frame $06, no animation
	ld   a, $06
	ld   [wActCurSprMapBaseId], a
	
	; Apply gravity until we touch a solid block
	call ActS_ApplySpeedDownYColi
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_NeoMonking_InitJump ===============
; Sets up a jump towards the player.
Act_NeoMonking_InitJump:
	xor  a
	ldh  [hActCur+iActSprMap], a
	
	call ActS_FacePl		; Towards the player
	ld   bc, $0180			; 1.5px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0300			; 3px/frame jump
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_NeoMonking_JumpU ===============
; Handles jump arc while moving up.
Act_NeoMonking_JumpU:
	call ActS_ApplySpeedFwdXColi	; Move forward
	call nc, ActS_FlipH				; Touched a wall? If so, rebound
	call ActS_ApplySpeedUpYColi		; Move up
	ret  c							; Reached the peak? If not, return
	jp   ActS_IncRtnId				; Start moving down
	
; =============== Act_NeoMonking_JumpD ===============
; Handles jump arc while moving down.
Act_NeoMonking_JumpD:
	call ActS_ApplySpeedFwdXColi	; Move forward
	call nc, ActS_FlipH				; Touched a wall? If so, rebound
	call ActS_ApplySpeedDownYColi	; Move down
	ret  c							; Touched the ground? If not, return
	ld   a, ACTRTN_NEOMONKING_INITJUMP	; Otherwise, immediately set up a new jump
	ldh  [hActCur+iActRtnId], a		; Unlike RM3, these will never return to idling
	ret
	
; =============== Act_NeoMet ===============
; ID: ACT_NEOMET
; Rockman 2-style Met.
Act_NeoMet:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_NeoMet_InitHide
	dw Act_NeoMet_WaitNotice
	dw Act_NeoMet_Notice
	dw Act_NeoMet_UnHide
	dw Act_NeoMet_Fire
	dw Act_NeoMet_PostFireWait
	dw Act_NeoMet_Walk
	dw Act_NeoMet_Fall
	DEF ACTRTN_NEOMET_INITHIDE = $00

; =============== Act_NeoMet_InitHide ===============
Act_NeoMet_InitHide:
	; When walking forwards, do so at 0.5px/frame
	ld   bc, $0080
	call ActS_SetSpeedX
	
	; Mets start out hiding inside their invulnerable hat
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType
	ld   a, $00
	call ActS_SetSprMapId
	
	; Wait for 1 second
	ld   a, 60
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_NeoMet_WaitNotice ===============
; Waits for 1 second before noticing the player.
Act_NeoMet_WaitNotice:
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	jp   ActS_IncRtnId
	
; =============== Act_NeoMet_Notice ===============
; Waits for the player to get close.
Act_NeoMet_Notice:
	; Always face player while on the lookout
	call ActS_FacePl
	; If the player isn't within 4 blocks, return
	call ActS_GetPlDistanceX
	cp   BLOCK_H*4
	ret  nc
	; Set transition sprite
	ld   a, $01
	call ActS_SetSprMapId
	; Show it for 8 frames
	ld   a, $08
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_NeoMet_UnHide ===============
; Rise up from shield.
Act_NeoMet_UnHide:
	; Wait those 8 frames first
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Set fully risen sprite
	ld   a, $02
	call ActS_SetSprMapId
	; Met isn't hiding anymore, make vulnerable
	ld   b, ACTCOLI_ENEMYHIT
	call ActS_SetColiType
	; Wait 20 frames before attacking
	ld   a, $14
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_NeoMet_Fire ===============
; Fire projectiles.
Act_NeoMet_Fire:
	; Wait for it...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Do spread shot
	call Act_NeoMet_SpawnShots
	; Wait for another second
	ld   a, 60
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_NeoMet_PostFireWait ===============
; Stands still after firing.
Act_NeoMet_PostFireWait:
	; Wait 1 second before walking forward
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Walk for $30 frames
	ld   a, $30
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_NeoMet_Walk ===============
; Slowly walk forward.
Act_NeoMet_Walk:
	; After almost a second of walking, hide instantly.
	; There is no transition sprite unlike when rising up.
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	jr   nz, .move
	ld   a, ACTRTN_NEOMET_INITHIDE
	ldh  [hActCur+iActRtnId], a
	ret
.move:
	; Use frames $03-$04, at 1/8 speed
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ld   c, $01
	call ActS_Anim2
	
	; Move forward at 0.5px/frame
	call ActS_ApplySpeedFwdXColi	; Solid wall hit?
	jp   nc, ActS_FlipH				; If so, turn around
	
	; If there's no solid ground above, start falling
	call ActS_GetGroundColi			; Calc collision flags
	ld   a, [wColiGround]
	cp   %11						; Are both blocks empty?
	ret  nz							; If not, return
	xor  a							; Otherwise, init fall speed
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_NeoMet_Fall ===============
; Falling mode, in case we walked off a platform.
Act_NeoMet_Fall:
	call ActS_ApplySpeedDownYColi	; Apply gravity
	ret  c							; Hit a solid block yet? If not, return
	ld   a, ACTRTN_NEOMET_INITHIDE	; Otherwise, hide immediately
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_PickelmanBull ===============
; ID: ACT_PICKELBULL
; Pickelman riding a bulldozer.
Act_PickelmanBull:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_PickelmanBull_Init
	dw Act_PickelmanBull_MoveFwd
	dw Act_PickelmanBull_Shake

; =============== Act_PickelmanBull_Init ===============
Act_PickelmanBull_Init:
	; Move forward 0.5px/frame
	ld   bc, $0080
	call ActS_SetSpeedX
	jp   ActS_IncRtnId
	
; =============== Act_PickelmanBull_MoveFwd ===============
; Moves the bulldozer forward.
Act_PickelmanBull_MoveFwd:
	; Animate wheels
	ld   c, $01
	call ActS_Anim2
	
	; Move forward
	call ActS_ApplySpeedFwdXColi	; Hit a solid wall?
	jp   nc, ActS_FlipH				; If so, turn
	call ActS_GetBlockIdFwdGround	; Is there no ground forward?
	jp   c, ActS_FlipH				; If so, turn
	
	; This forward movement happens for a random amount of frames.
	; Each time we get there, there's a ~3% chance of shaking for a bit.
	call Rand		; A = Rand()
	cp   $08		; A >= $09?
	ret  nc			; If so, return
					; 1/32 chance of getting here
	
	; Stutter for half a second
	ld   a, 30
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_PickelmanBull_Shake ===============
; Shakes the bulldozer.
Act_PickelmanBull_Shake:
	; Still animate wheels
	ld   c, $01
	call ActS_Anim2
	
	; Go back to moving forward after the 30 frames pass
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	jp   z, ActS_DecRtnId
	
	; Alternate between moving left and right every 4 frames, at 1px/frame.
	ldh  a, [hActCur+iActTimer0C]	; A = Timer
	ld   hl, hActCur+iActX			; HL = Ptr to iActX
	bit  2, a						; Timer & 4 == 0?
	jr   z, .moveR					; If so, move right
.moveL:
	dec  [hl]						; iActX--
	ret
.moveR:
	inc  [hl]						; iActX++
	ret
	
; =============== Act_Bikky ===============
; ID: ACT_BIKKY
; Giant jumper robot.
Act_Bikky:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Bikky_Init
	dw Act_Bikky_GroundReflect
	dw Act_Bikky_GroundHit
	dw Act_Bikky_JumpU
	dw Act_Bikky_JumpD
	DEF ACTRTN_BIKKY_INIT = $00

; =============== Act_Bikky_Init ===============
; Initializes the jumps.
Act_Bikky_Init:
	; Set up jump speed for later
	ld   bc, $0080			; 0.5px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0300			; 3px/frame upwards
	call ActS_SetSpeedY
	
	; Start invulnerable
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType
	
	; With eyes closed
	ld   a, $00
	call ActS_SetSprMapId
	
	; Stay for one second like this
	ld   a, 60
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Bikky_GroundReflect ===============
; Stays on the ground, invulnerable.
Act_Bikky_GroundReflect:
	; Use frames $00-$01, at 1/8 speed, giving a shaking effect
	ld   c, $01
	call ActS_Anim2
	
	; Wait for the second...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; After the second passes, show its eyes and make it vulnerable
	ld   b, ACTCOLI_ENEMYHIT	; Vulnerable
	call ActS_SetColiType
	ld   a, $02					; Set frame $02
	call ActS_SetSprMapId
	
	; Small delay before jumping
	ld   a, $14
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Bikky_GroundHit ===============
; Stays on the ground, vulnerable.
Act_Bikky_GroundHit:
	; Wait for those 20 frames
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Set jumping sprite and jump towards the player.
	ld   a, $03
	call ActS_SetSprMapId
	call ActS_FacePl
	jp   ActS_IncRtnId
	
; =============== Act_Bikky_JumpU ===============
; Jumping, moving up.
Act_Bikky_JumpU:
	; Move forward, turn around if a wall is hit
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Apply gravity, switch to next routine when reaching the peak of the jump
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_Bikky_JumpD ===============
; Jumping, moving down.
Act_Bikky_JumpD:
	; Move forward, turn around if a wall is hit
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Apply gravity, return invulnerable on the ground and loop
	call ActS_ApplySpeedDownYColi
	ret  c
	ld   a, ACTRTN_BIKKY_INIT
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Komasaburo ===============
; ID: ACT_KOMASABURO
; Spawns spinning tops.
Act_Komasaburo:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Komasaburo_Init
	dw Act_Komasaburo_InitIdle
	dw Act_Komasaburo_Idle
	dw Act_Komasaburo_Shoot
	dw Act_Komasaburo_AfterShoot
	DEF ACTRTN_KOMASABURO_INITIDLE = $01
	
; =============== Act_Komasaburo_Init ===============
Act_Komasaburo_Init:
	call ActS_FacePl
	; This actor is around two blocks wide and is intended to be spawned
	; between those two blocks, but the actor layout format isn't precise
	; enough for that, so move him right by 8px during init.
	ldh  a, [hActCur+iActX]
	add  $08
	ldh  [hActCur+iActX], a
	jp   ActS_IncRtnId
	
; =============== Act_Komasaburo_InitIdle ===============
; Sets up the delay before shooting.
Act_Komasaburo_InitIdle:
	; Use frames $00-$01, at 1/4 speed
	ld   c, $02
	call ActS_Anim2
	
	; Wait for 60 seconds in the next mode
	ld   a, 60
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Komasaburo_Idle ===============
; Enemy is idle, waiting for a second before shooting.
Act_Komasaburo_Idle:
	; Use frames $00-$01, at 1/4 speed
	ld   c, $02
	call ActS_Anim2
	
	; Wait for those 60 seconds before shooting
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	jp   ActS_IncRtnId
	
; =============== Act_Komasaburo_Shoot ===============
; Shoots a spinning top if there aren't too many of them.
Act_Komasaburo_Shoot:
	
	; If there are 3 or more spinning tops on screen, try again next frame.
	; Returning like this means the actor won't animate while waiting for one of them to despawn.
	ld   a, ACT_KOMA
	call ActS_CountById
	ld   a, b
	cp   $03		; Are there 3 or more spinning tops onscreen?
	ret  nc			; If so, return
	
	; Otherwise, spawn a new one directly at the parent's location.
	ld   a, ACT_KOMA
	ld   bc, $0000		; Directly on top
	call ActS_SpawnRel	; Could it spawn?
	jr   c, .setSpr		; If not, skip
	call ActS_SyncDirToSpawn ; Throw it forward (same direction as parent)
.setSpr:
	; Use shoot frame...
	ld   a, $02
	call ActS_SetSprMapId
	
	; ...for 12 frames
	ld   a, $0C
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Komasaburo_AfterShoot ===============
; Waits 12 frames in the shooting sprite, as cooldown.
Act_Komasaburo_AfterShoot:
	; After they pass, return to the start again, in its idle animation
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	ld   a, ACTRTN_KOMASABURO_INITIDLE
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Koma ===============
; ID: ACT_KOMA
; Spinning top projectile spawned by Act_Komasaburo.	
Act_Koma:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Koma_Init
	dw Act_Koma_MoveH
	dw Act_Koma_FallV
	DEF ACTRTN_KOMA_MOVEH = $01
	
; =============== Act_Koma_Init ===============
Act_Koma_Init:
	ld   bc, $0180				; 1.5px/frame forward
	call ActS_SetSpeedX
	ld   a, 60*3				; Explode after 3 seconds (outside of when they fall down)
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Koma_MoveH ===============
; Spinning top moves horizontally.
Act_Koma_MoveH:
	; Use frames $00-$01, at 1/4 speed
	ld   c, $02
	call ActS_Anim2
	
	; When the life timer elapses, explode (without dropping items)
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	jr   nz, .moveH
	jp   ActS_Explode
.moveH:
	; Move horizontally, turning the other way when hitting a wall
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	
	; If there's no ground below, start falling
	call ActS_GetGroundColi
	ld   a, [wColiGround]
	cp   %11
	ret  nz
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_Koma_FallV ===============
; Spinning top falls off a platform.
; During this time, the life timer is paused (ie: not handled).
Act_Koma_FallV:
	; Use frames $00-$01, at 1/4 speed
	ld   c, $02
	call ActS_Anim2
	
	; Keep moving down until we hit solid ground.
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; Then return to moving forward
	ld   a, ACTRTN_KOMA_MOVEH
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Mechakkero ===============
; ID: ACT_MECHAKKERO
; Hopping frog-like enemy that's hard to hit on the ground.
Act_Mechakkero:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Mechakkero_InitJump
	dw Act_Mechakkero_JumpU
	dw Act_Mechakkero_JumpD
	dw Act_Mechakkero_Wait0
	dw Act_Mechakkero_Wait1
	DEF ACTRTN_MECHAKKERO_INITJUMP = $00

; =============== Act_Mechakkero_InitJump ===============
; Initializes the jump
Act_Mechakkero_InitJump:
	; Set up jump speed
	ld   bc, $0100			; 1px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0200			; 2px/frame up
	call ActS_SetSpeedY
	
	; Face player when starting the jump
	call ActS_FacePl
	
	; Use jumping sprite
	ld   a, $02
	call ActS_SetSprMapId
	
	;--
	; [TCRF] This suggests the intention to wait for 1.5 seconds before jumping,
	;        similar to what Rockman 3 does, but the code isn't quite set up for that.
	ld   a, $5A
	ldh  [hActCur+iActTimer0C], a
	;--
	jp   ActS_IncRtnId
	
; =============== Act_Mechakkero_JumpU ===============
; Jump, before peak.
Act_Mechakkero_JumpU:
	; Move forward, turning around when hitting a solid wall
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Move up until we reach the peak
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_Mechakkero_JumpD ===============
; Jumps, after peak.
Act_Mechakkero_JumpD:
	; Move forward, turning around when hitting a solid wall
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Move down until we touch the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; After landing, stay on the ground for 24 frames.
	; For the first 12, use a sprite with half-closed eyes, for the latter fully open.
	
	; Use normal eyes sprite for 12 frames
	ld   a, $00
	call ActS_SetSprMapId
	ld   a, $0C
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Mechakkero_Wait0 ===============
; On the ground, normal eyes.
Act_Mechakkero_Wait0:
	; Wait for it...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Use open eyes sprite for 12 frames
	ld   a, $01
	call ActS_SetSprMapId
	ld   a, $0C
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Mechakkero_Wait1 ===============
; On the ground, open eyes.
Act_Mechakkero_Wait1:
	; Wait for it..
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	;--
	; [POI] Why return to this for a single frame?
	ld   a, $00					
	call ActS_SetSprMapId
	;--
	; Loop back to setting up the next jump
	ld   a, ACTRTN_MECHAKKERO_INITJUMP
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_SpinTopU ===============
; ID: ACT_SPINTOPU
; Large spinning top platform that moves up.
; This uses its own collision type ACTCOLI_PLATFORM -> ACTCOLISUB_SPINTOP, to act
; as a top-solid platform that spins the player around.
Act_SpinTopU:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_SpinTopU_Init
	dw Act_SpinTopU_Move
	
; =============== Act_SpinTopU_Init ===============
Act_SpinTopU_Init:
	; Move 0.5px/frame up
	ld   bc, $0080
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_SpinTopU_Move ===============
Act_SpinTopU_Move:
	; Use frames $00-$03 at 1/2 speed
	ld   c, $04
	call ActS_Anim4
	
	; Move up
	call ActS_ApplySpeedFwdY
	
	; When it goes off-screen above, make it wrap around to the bottom.
	; This makes it relatively safe to idle on the platform (spinning aside).
	ldh  a, [hActCur+iActY]
	cp   OBJ_OFFSET_Y			; ActY == $10?
	ret  nz						; If not, return
	ld   a, OBJ_OFFSET_Y+SCREEN_GAME_V+BLOCK_V-1
	ldh  [hActCur+iActY], a		; Otherwise, ActY = $9F
	ret
	
; =============== Act_SpinTopD ===============
; ID: ACT_SPINTOPD
; Large spinning top platform that moves down.
Act_SpinTopD:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_SpinTopD_Init
	dw Act_SpinTopD_Move
	
; =============== Act_SpinTopD_Init ===============
Act_SpinTopD_Init:
	; Move 0.5px/frame down
	ld   bc, $0080
	call ActS_SetSpeedY
	call ActS_FlipV ; Move down
	jp   ActS_IncRtnId
	
; =============== Act_SpinTopD_Move ===============
Act_SpinTopD_Move:
	; Use frames $00-$03 at 1/2 speed
	ld   c, $04
	call ActS_Anim4
	call ActS_ApplySpeedFwdY
	
	; When it goes off-screen below, make it wrap around to the top.
	; The positions used are identical to those in Act_SpinTopU_Move,
	; except the other way around, making sure the platforms won't desync
	; once they are spawned,
	ldh  a, [hActCur+iActY]
	cp   OBJ_OFFSET_Y+SCREEN_GAME_V+BLOCK_V-1
	ret  nz
	ld   a, OBJ_OFFSET_Y
	ldh  [hActCur+iActY], a
	ret
	
; =============== Act_Tama ===============
; ID: ACT_TAMA
; Giant cat miniboss in Top Man's stage.
Act_Tama:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Tama_InitTilemap
	dw Act_Tama_InitAttackType
	dw Act_Tama_ChkAttack
	dw Act_Tama_Throw0
	dw Act_Tama_Throw1
	dw Act_Tama_ThrowAfter
	DEF ACTRTN_TAMA_CHKATTACK = $02

; =============== Act_Tama_InitTilemap ===============
; Draws the tilemap for the miniboss.
Act_Tama_InitTilemap:
	call Act_BGBoss_ReqDraw
	jp   ActS_IncRtnId
	
; =============== Act_Tama_InitAttackType ===============
Act_Tama_InitAttackType:
	; Return if dead
	call Act_Tama_ChkExplode
	ret  c
	; First attack will be the Yarn Ball.
	; (While iTamaAttackType 0 is for the fleas, it will be pre-xor'd to 1)
	xor  a
	ldh  [hActCur+iTamaAttackType], a
	jp   ActS_IncRtnId
	
; =============== Act_Tama_ChkAttack ===============
Act_Tama_ChkAttack:
	; Return if dead
	call Act_Tama_ChkExplode
	ret  c
	
	; Use frames $00-$01 at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	
	; Wait until no Yarn Balls or Fleas are onscreen
	ld   a, ACT_TAMABALL
	call ActS_CountById
	ld   a, b
	or   a					; Count != 0?
	ret  nz					; If so, wait
	ld   a, ACT_TAMAFLEA
	call ActS_CountById
	ld   a, b
	or   a					; Count != 0?
	ret  nz					; If so, wait
	
	; Start one of the two possible attacks
	
	; Set the delay for the throw animation, in case we're throwing the Yarn Ball next
	ld   a, 30
	ldh  [hActCur+iActTimer0C], a
	
	; Alternate betwen attack types
	ldh  a, [hActCur+iTamaAttackType]
	xor  $01
	ldh  [hActCur+iTamaAttackType], a
	
	or   a						; iTamaAttackType != 0?
	jp   nz, ActS_IncRtnId		; If so, prepare to spawn the Yarn Ball
	jp   Act_Tama_SpawnFleas	; Otherwise, spawn fleas (and stay on Act_Tama_WaitAttack)
	
; =============== Act_Tama_Throw0 ===============
; First part of the throw sequence.
Act_Tama_Throw0:
	call Act_Tama_ChkExplode
	ret  c
	
	; Use frames $00-$01 at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	
	; Wait for half a second in the same animation as Act_Tama_WaitAttack
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Wait another half a second in the next mode
	ld   a, 30
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Tama_Throw1 ===============
; Second part of the throw sequence.
Act_Tama_Throw1:
	call Act_Tama_ChkExplode
	ret  c
	
	; Use frames $02-$03 at 1/8 speed, the actual throw animation
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ld   c, $01
	call ActS_Anim2
	
	; Wait half a second before spawning the ball
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; This does nothing
	ld   a, $0F
	ldh  [hActCur+iActTimer0C], a
	
	; Finally spawn the Yarn Ball
	ld   a, ACT_TAMABALL
	ld   bc, (LOW(-$18) << 8)|LOW(-$04)	; 24px left, 4px up
	call ActS_SpawnRel
	jp   ActS_IncRtnId
	
; =============== Act_Tama_ThrowAfter ===============
; Cooldown
Act_Tama_ThrowAfter:
	call Act_Tama_ChkExplode
	ret  c
	
	; Use frames $00-$01 at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	
	; Wait for the Yarn Ball to be destroyed
	ld   a, ACTRTN_TAMA_CHKATTACK
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_TamaBall ===============
; ID: ACT_TAMABALL
; Bouncing yarn ball thrown by Tama.
Act_TamaBall:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_TamaBall_InitSpdX
	dw Act_TamaBall_InitJump
	dw Act_TamaBall_JumpU
	dw Act_TamaBall_JumpD
	DEF ACTRTN_TAMABALL_INITJUMP = $01
	
; =============== Act_TamaBall_InitSpdX ===============
; Initializes the horizontal speed, which never changes.
Act_TamaBall_InitSpdX:
	; Move towards the player at 0.5px/frame
	call ActS_FacePl
	ld   bc, $0080
	call ActS_SetSpeedX
	jp   ActS_IncRtnId
	
; =============== Act_TamaBall_InitJump ===============
; Sets up the next jump.
Act_TamaBall_InitJump:
	; Set jump at 2px/frame
	ld   bc, $0200
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_TamaBall_JumpU ===============
; Jump, pre-peak.
Act_TamaBall_JumpU:
	; Move forwards, turn if we hit a wall
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Apply gravity while moving up until we reach the peak
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_TamaBall_JumpD ===============
; Jump, post-peak.
Act_TamaBall_JumpD:
	; Move forwards, turn if we hit a wall
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Apply gravity while moving down until we hit the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	; Then set up another jump
	ld   a, ACTRTN_TAMABALL_INITJUMP
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_TamaFlea ===============
; ID: ACT_TAMAFLEA
; Flea that jump out of Tama.
Act_TamaFlea:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_TamaFlea_Init
	dw Act_TamaFlea_JumpU
	dw Act_TamaFlea_JumpD
	dw Act_TamaFlea_Ground
	DEF ACTRTN_TAMAFLEA_INIT = $00
	
; =============== Act_TamaFlea_Init ===============
; Initializes some of the properties of the jump.
; Note that the speed isn't set here -- the first time we get here, our speed
; will be the one set by Act_Tama_SpawnFleas since each individual flea has
; their *first* jump at a different arc.
Act_TamaFlea_Init:
	; Use jumping sprite $01
	ld   a, $01
	call ActS_SetSprMapId
	; Always jump towards the player
	call ActS_FacePl
	jp   ActS_IncRtnId
	
; =============== Act_TamaFlea_JumpU ===============
; Jump, pre-peak.
Act_TamaFlea_JumpU:
	; Move forwards, turn if we hit a wall
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Apply gravity while moving up until we reach the peak
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_TamaFlea_JumpD ===============
; Jump, post-peak.
Act_TamaFlea_JumpD:
	; Move forwards, turn if we hit a wall
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Apply gravity while moving down until we hit the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; The fleas, while on the ground, use a smaller sprite than their jumping one
	; so adjust the collision box to be smaller.
	ld   bc, $0303			; H Radius: 3, V Radius: 3
	call ActS_SetColiBox
	
	; Use standing sprite $00
	ld   a, $00
	call ActS_SetSprMapId
	
	; Delay the next jump by 1 second
	ld   a, 60
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_TamaFlea_Ground ===============
; Flea is on the ground.
Act_TamaFlea_Ground:
	; Wait for the second to pass before setting up a new jump
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Larger sprite when jumping (set in ACTRTN_TAMAFLEA_INIT) means larger collision box by 4px vertically
	ld   bc, $0305			; H Radius: 3, V Radius: 5
	call ActS_SetColiBox
	; Set up standard jump settings for the second jump onwards
	ld   bc, $0080			; 0.5px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0300			; 3px/frame up
	call ActS_SetSpeedY
	
	; Set jump settings shared with the first one
	ld   a, ACTRTN_TAMAFLEA_INIT
	ldh  [hActCur+iActRtnId], a
	ret

; =============== Act_MagFly ===============
; ID: ACT_MAGFLY
; Flying Magnet that attracts the player.
Act_MagFly:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_MagFly_Init
	dw Act_MagFly_Move
	
; =============== Act_MagFly_Init ===============
Act_MagFly_Init:
	; Move 0.5px/frame forward
	ld   bc, $0080
	call ActS_SetSpeedX
	jp   ActS_IncRtnId
	
; =============== Act_MagFly_Move ===============
Act_MagFly_Move:
	; Use frames $00-$01 at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	
	; Move forward
	call ActS_ApplySpeedFwdX
	
	;
	; Attract the player when they get close to its horizontal range.
	; This can't be done through the collision box as the magnet itself deals damage.
	;
	
	; Do not attract if the player is either hurt or invulnerable.
	; This causes the player to fall off when hitting the magnet directly.
	ld   a, [wPlHurtTimer]
	ld   b, a
	ld   a, [wPlInvulnTimer]
	or   b
	ret  nz
	
	; Only attract the player when on the ground or jumping.
	; This means it's possible to avoid getting attracted by sliding through.
	ld   a, [wPlMode]
	cp   PL_MODE_CLIMB
	ret  nc
	
	;--
	; A = Horizontal distance from player.
	; This is identical to ActS_GetPlDistanceX, except with wPlRelX 
	; and iActX swapped, which makes no difference.
	ldh  a, [hActCur+iActX]	; B = iActX
	ld   b, a
	ld   a, [wPlRelX]		; A = wPlRelX
	sub  b					; A = wPlRelX - iActX
	jr   nc, .chkDistance	; Did we underflow? (Player is to the left) If not, return
	xor  $FF				; Otherwise, flip the result's sign
	inc  a
	scf  					; and set the C flag since that xor cleared it
	;--
.chkDistance:
	; Don't attract if more than 4px away from the origin.
	; This makes the "collision box" for getting attracted infinitely tall, 7 pixels wide.
	cp   $04				; Distance >= $04?
	ret  nc					; If so, return
	
	; HORIZONTAL MOVEMENT
	; If we get here, always take the player for a ride
	ldh  a, [hActCur+iActSprMap]	; In the same direction as the magnet...
	ld   bc, $0080					; ...move 0.5px/frame
	call Pl_SetSpeedByActDir
	
	; VERTICAL MOVEMENT
	; Do not move the player up if its center point is above the magnet's origin.
	ldh  a, [hActCur+iActY]		; Get actor Y pos
	add  PLCOLI_V				; Adding PLCOLI_V means the player's center will be the target
	ld   b, a
	ld   a, [wPlRelY]			; Get player Y pos
	cp   b						; PlY - PLCOLI_V < ActY?
	ret  c						; If so, return
	
	; Otherwise, force a 1px/frame upwards jump that can't be cut early.
	xor  a					; 0 subpx
	ld   [wPlSpdYSub], a
	inc  a					; 1px/frame
	ld   [wPlSpdY], a
	inc  a					; Player mode 2 (PL_MODE_FULLJUMP, forced jump)
	ld   [wPlMode], a
	ret
	
; =============== Act_GiantSpringer ===============
; ID: ACT_GSPRINGER
; Large Springer that fires homing missiles.	
Act_GiantSpringer:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_GiantSpringer_Init
	dw Act_GiantSpringer_Main
	dw Act_GiantSpringer_FallV
	dw Act_GiantSpringer_FireMissile
	dw Act_GiantSpringer_SpringOut
	DEF ACTRTN_GSPRINGER_MAIN = $01
	DEF ACTRTN_GSPRINGER_FIREMISSILE = $03
	DEF ACTRTN_GSPRINGER_SPRINGOUT = $04
	
	DEF DISTANCE_SPRINGOUT = $20
	
; =============== Act_GiantSpringer_Init ===============
Act_GiantSpringer_Init:
	; Move very slowly forward, at 0.0625px/frame
	ld   bc, $0010
	call ActS_SetSpeedX
	jp   ActS_IncRtnId
	
; =============== Act_GiantSpringer_Main ===============
; Main routine, handles checks for all actions.
Act_GiantSpringer_Main:
	; Always move towards the player
	call ActS_FacePl
	
	; Whenver the player gets nearby, activate the springout animation.
	; This is a misleading animation, as while it looks like an attack
	; the actor's collosion box doesn't change at all.
	call ActS_GetPlDistanceX
	cp   DISTANCE_SPRINGOUT		; Distance >= $20?
	jr   nc, .far				; If so, jump
.near:
	ld   a, ACTRTN_GSPRINGER_SPRINGOUT
	ldh  [hActCur+iActRtnId], a
	ret
.far:

	; Try to immediately spawn a missile when outside its nearby range.
	; Typically this triggers immediately after the actor spawns.
	ld   a, ACT_GSPRINGERSHOT
	call ActS_CountById	; Find how many ACT_GSPRINGERSHOT active
	ld   a, b
	or   a				; Count != 0?
	jr   nz, .move	; If so, jump
	
	; Otherwise, do a round trip for spawning the missile before returning back here
	ld   a, $01					; Use shooting frame
	call ActS_SetSprMapId
	ld   a, 30					; Delay firing for half a second
	ldh  [hActCur+iActTimer0C], a
	ld   a, ACTRTN_GSPRINGER_FIREMISSILE
	ldh  [hActCur+iActRtnId], a
	ret
	
.move:
	; If we got here, just move towards the player
	call ActS_ApplySpeedFwdXColi
	
	; If there's no ground below, start falling
	call ActS_GetGroundColi
	ld   a, [wColiGround]
	cp   %11
	ret  nz
	; [TCRF] None are placed in ways that can fall off platforms.
	;       The rest of the subroutine and Act_GiantSpringer_FallV are unreachable.
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_GiantSpringer_FallV ===============
; Enemy falls off a platform.
Act_GiantSpringer_FallV:
	; Keep moving down until we hit solid ground.
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; Return to tracking the player
	ld   a, ACTRTN_GSPRINGER_MAIN
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_GiantSpringer_FireMissile ===============
; Enemy spawns the homing missile.
Act_GiantSpringer_FireMissile:
	; Wait for half a second before spawning the missile
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Launch the missile from the top
	ld   a, ACT_GSPRINGERSHOT
	ld   bc, ($00 << 8)|LOW(-$18) ; 24px above
	call ActS_SpawnRel
	
	; Return to tracking the player
	ld   a, $00
	call ActS_SetSprMapId
	ld   a, ACTRTN_GSPRINGER_MAIN
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_GiantSpringer_SpringOut ===============
; Enemy is in its unretracted spring out animation.
Act_GiantSpringer_SpringOut:
	; Use frames $02-$05, at 1/8 speed
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ld   c, $01
	call ActS_Anim4
	
	; Retract the spring and return to to tracking the player when they go out of range
	call ActS_GetPlDistanceX
	cp   DISTANCE_SPRINGOUT		; Distance < $20?
	ret  c						; If so, keep springing
	
	; Return to tracking the player
	ld   a, $00
	call ActS_SetSprMapId
	ld   a, ACTRTN_GSPRINGER_MAIN
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_GiantSpringerShot ===============
; ID: ACT_GSPRINGERSHOT
; Homing missile fired by Giant Springers.
Act_GiantSpringerShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_GiantSpringerShot_InitMoveU
	dw Act_GiantSpringerShot_MoveU
	dw Act_GiantSpringerShot_Arc
	dw Act_GiantSpringerShot_MoveLine

; =============== Act_GiantSpringerShot_InitMoveU ===============
; After the missile spawns, it rises straight up a a few frames.
Act_GiantSpringerShot_InitMoveU:
	; For 15 frames...
	ld   a, $0F
	ldh  [hActCur+iActTimer0C], a
	; Move up at 1px/frame
	ld   bc, $0100
	call ActS_SetSpeedY
	; Use vertical missile sprite
	ld   a, $02
	call ActS_SetSprMapId
	jp   ActS_IncRtnId
	
; =============== Act_GiantSpringerShot_MoveU ===============
; Moves the missile up, then sets up the arc.
Act_GiantSpringerShot_MoveU:
	; Handle the upwards movement set up before
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
		
	;--
	; Not necessary, done below
	ld   a, $00
	ldh  [hActCur+iActTimer0C], a
	;--
	
	;
	; After that is done, prepare the settings for the circular path.
	; This does not go through ActS_InitCirclePath since that one makes it start moving horizontally (start from top to l/r),
	; while we, due to having just finished moving straight up, want to start it moving vertically (start from l/r to top)
	; so that horizontal movement will be gradual.
	;

	
	
	; PATH DIRECTION
	; The missile always moves away from the player on its first rotation.
	
	;##
	; This is identical to ActS_GetPlDistanceX, except with wPlRelX and iActX swapped.
	; The distance is not used directly, there's a bit more code than needed.
	ldh  a, [hActCur+iActX]	; B = iActX
	ld   b, a
	ld   a, [wPlRelX]		; A = wPlRelX
	sub  b					; wPlRelX >= iActX?
	jr   nc, .setArc		; If so, jump (player on the right, carry clear)
	;--
	; This bit is unnecessary, all we care for is the carry flag, which is alredy set when going here.
	xor  $FF				; Otherwise, flip the result's sign
	inc  a
	scf  					; and set the C flag since that xor cleared it
	;--
	;##
.setArc:
	; Using the carry as direction means that:
	; - If the player is on the left, the carry will be set, making the missile move right
	; - If the player is on the right, the carry will be clear, making the missile move left
	rra  					; Shift carry into place
	and  ACTDIR_R			; Use that as direction.
	ldh  [hActCur+iActSprMap], a
	
	ld   a, ADR_DEC_IDX|ADR_INC_IDY	; Set index directions
	ldh  [hActCur+iArcIdDir], a
	ld   a, ARC_MAX					; Move slow horz
	ldh  [hActCur+iArcIdX], a
	xor  a							; Move fast vert
	ldh  [hActCur+iArcIdY], a
	
	ldh  [hActCur+iActTimer0C], a
	; Use diagonal missile sprite
	ld   a, $00
	call ActS_SetSprMapId
	jp   ActS_IncRtnId
	
; =============== Act_GiantSpringerShot_Arc ===============
; Moves the missile in a circular path, until the player gets close.
Act_GiantSpringerShot_Arc:
	;--
	; [POI] There's nothing using the timer here, including ActS_ApplyCirclePath.
	ldh  a, [hActCur+iActTimer0C]	; Timer++
	add  $01
	ldh  [hActCur+iActTimer0C], a
	cp   $B0						; Timer < $B0?
	jp   c, doArc					; If so, skip
	ld   a, $00						; Timer = 0
	ldh  [hActCur+iActTimer0C], a
	;--
doArc:
	; Move missile around a small arc
	ld   a, ARC_SM
	call ActS_ApplyCirclePath
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	
	;
	; Determine when to stop the circular movement and start moving directly towards the player.
	; It needs to pass a gauntlet of checks first.
	;
	
	; The missile is shound not be near the top or bottom of the circle (X speed at its max value)
	; as at that time it's traveling nearly horizontally
	ldh  a, [hActCur+iActSpdXSub]
	cp   $FF
	ret  nz
	
	; Player should not be too close horizontally (< $30px) ...
	call ActS_GetPlDistanceX
	cp   $30
	ret  c
	
	; But also not too far vertically (>= $40)
	;--
	; ActS_GetPlDistanceY, but relative to the player's vertical center. 
	ld   a, [wPlRelY]		; B = PlY - $0C (center)
	sub  PLCOLI_V
	ld   b, a
	ldh  a, [hActCur+iActY]	; A = ActY (bottom)
	sub  b					; Do the distance calc
	jr   nc, .chkDiffY
	xor  $FF				; Force absolute
	inc  a
	scf  
	;--
.chkDiffY:
	cp   $40				; DiffY >= $40?
	ret  nc					; If so, return
	
	; The missile must travel towards the same direction as the player.
	; Otherwise it could do a instant 180°, which would break the illusion of momentum.
	ld   a, [wPlRelX]			; B = PlX
	ld   b, a
	ldh  a, [hActCur+iActX]		; A = ActX
	cp   b						; ActX < PlX?
	jr   c, .plR				; If so, jump (player is on the right)
	
.plL:
	; Player is on the left, so the missile should be also facing left
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a			; Is the missile facing right?
	ret  nz						; If so, return
	call ActS_AngleToPl			; Get the speed values to target the player
	jp   ActS_IncRtnId			; Start moving in a straight line with those values
	
.plR:
	; Player is on the right, so the missile should be also facing right
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a			; Is the missile facing right?
	ret  z						; If not, return
	call ActS_AngleToPl
	jp   ActS_IncRtnId
	
; =============== Act_GiantSpringerShot_MoveLine ===============
; Moves the missile along a straight line.
; It targets a snapshot of the player's old position at the time of the check.
Act_GiantSpringerShot_MoveLine:
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
; =============== Act_Peterchy ===============
; ID: ACT_PETERCHY
; Walker enemy.	
Act_Peterchy:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Peterchy_Init
	dw Act_Peterchy_MoveH
	dw Act_Peterchy_FallV
	DEF ACTRTN_PETERCHY_MOVEH = $01
	
; =============== Act_Peterchy_Init ===============
Act_Peterchy_Init:
	; Move at 0.5px/frame, starting towards the player
	ld   bc, $0080
	call ActS_SetSpeedX
	call ActS_FacePl
	jp   ActS_IncRtnId
	
; =============== Act_Peterchy_MoveH ===============
Act_Peterchy_MoveH:
	; Use frames $00-$06 at 1/4 speed
	ld   bc, ($06 << 8)|$02
	call ActS_AnimCustom
	
	; Move forward, turning around when hitting a wall
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	
	; If there's no ground below, start falling
	call ActS_GetGroundColi
	ld   a, [wColiGround]
	cp   %11
	ret  nz
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_Peterchy_FallV ===============
Act_Peterchy_FallV:
	; Use frames $00-$06 at 1/4 speed
	ld   bc, ($06 << 8)|$02
	call ActS_AnimCustom
	
	; Keep moving down until we hit solid ground.
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; Return to moving forwards
	ld   a, ACTRTN_PETERCHY_MOVEH
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_MagnetField ===============
; ID: ACT_MAGNETFIELD
; Magnetic field that always attracts the player to the right.
; The actual attraction itself is done by its collision type (ACTCOLI_MAGNET),
; this merely displays its wave animation near the visible magnet block.
Act_MagnetField:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_MagnetField_Init
	dw Act_MagnetField_Anim

; =============== Act_MagnetField_Init ===============
Act_MagnetField_Init:
	; In the actor layout, the magnet is placed directly inside the magnet block.
	; It instead should be placed vertically centered on its left.
	ldh  a, [hActCur+iActX]		; Move left 1 block
	sub  BLOCK_H
	ldh  [hActCur+iActX], a
	ldh  a, [hActCur+iActY]		; Move down by 4 pixels
	add  $04					; As it's around 1.5blocks tall, that will vertically center it.
	ldh  [hActCur+iActY], a
	jp   ActS_IncRtnId
	
; =============== Act_MagnetField_Anim ===============
Act_MagnetField_Anim:
	; Use frames $00-$03 at 1/8 speed
	ld   bc, ($03 << 8)|$01
	call ActS_AnimCustom
	ret
	
; =============== Act_Respawner ===============
; [TCRF] Unused.
; When on-screen, it instantly respawns any defeated actors that are part of the layout.
Act_Respawner:
	jp   ActS_SpawnRoom
	
; =============== Act_Block ===============
; ID: ACT_BLOCK0, ACT_BLOCK1, ACT_BLOCK2, ACT_BLOCK3
; Appearing block, in four separately timed variants.
Act_Block:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Block_Hide
	dw Act_Block_DelayShow
	dw Act_Block_Solid0
	dw Act_Block_Solid1
	dw Act_Block_Solid2
	dw Act_Block_Solid3
	DEF ACTRTN_BLOCK_HIDE = $00

; =============== Act_Block_Hide ===============
; Hides the block in an intangible state until it's time to make it appear.
Act_Block_Hide:
	; Hide the block and make it intangible.
	ld   b, ACTCOLI_PASS
	call ActS_SetColiType
	ld   a, $00
	call ActS_SetSprMapId
	
	;
	; Determine if the block's timing currently makes it visible, and if so, advance the routine.
	;
	; There are four separate actor IDs for the disappearing block. Given groups of four seconds,
	; each actor starts appearing on a specific one, in order.
	;
	; ie: 
	; - ACT_BLOCK0 starts it sequence at wGameTime % 4 == 0
	; - ACT_BLOCK1 starts it sequence at wGameTime % 4 == 1
	;   and so on
	;
	
	; Get the block number that can currently activate
	ld   a, [wGameTime]			; B = wGameTime % 4
	and  $03
	ld   b, a
	
	; Get the block number of this actor, off its ID
	ldh  a, [hActCur+iActId]	; B = (iActId & $7F) - ACT_BLOCK0
	and  $FF^ACTF_PROC
	sub  ACT_BLOCK0
	
	cp   b						; Do the block numbers match? 
	ret  nz						; If not, return (keep waiting)
	
	;
	; [BUG] If we got here on the first try, the blocks can desync since we may get here at any
	;       possible frame of the second, but the delay always waits for a fixed amount of time.
	;       
	;		Because of how much time a block needs to wait after it hides itself, any desync
	;       fixes itself the second time we get here (see wGameTime shift markers below)
	;
	
	; Delay appearing for a second 
	; This should have delayed for 60 - wGameTimeSub.
	ld   a, 60
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Block_DelayShow ===============
Act_Block_DelayShow:
	; Wait for a second before making the block show up
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; [wGameTime shift = $01/$04]
	
	ld   a, SFX_BLOCK			; Play block appear sound
	ldh  [hSFXSet], a
	ld   b, ACTCOLI_PLATFORM	; Make platform tangible
	call ActS_SetColiType
	
	ld   a, 10					; For next mode
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Block_Solid0 ===============
; First of four routines that manually handle the block's animation.
; ActS_Anim* is not being used because not only the amount of time to wait on each sprite is
; higher than what it suppports, each sprite is also displayed for a different amount of frames.
;
; Use visible sprite $01 for 10 frames
Act_Block_Solid0:
	ld   a, $01
	ld   [wActCurSprMapBaseId], a
	
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; [wGameTime shift = $01.$0A/$04]
	
	ld   a, 10
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Block_Solid1 ===============
; Use visible sprite $02 for 10 frames
Act_Block_Solid1:
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; [wGameTime shift = $01.$14/$04]
	
	ld   a, 20
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Block_Solid2 ===============
; Use visible sprite $03 for 20 frames
Act_Block_Solid2:
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; [wGameTime shift = $01.$28/$04]
	
	ld   a, 60
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Block_Solid3 ===============
; Use visible sprite $04 for a second
Act_Block_Solid3:
	ld   a, $04
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; [wGameTime shift = $02.$28/$04]
	; That leaves over a second of buffer from $04, fixing any desync.
	
	ld   a, ACTRTN_BLOCK_HIDE
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_NewShotman ===============
; ID: ACT_NEWSHOTMAN
; Front-facing variant of the Shotman, alternates between firing horizontally and at an arc.
Act_NewShotman:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_NewShotman_InitMain
	dw Act_NewShotman_Main
REPT 3 ; 3 horizontal shots
	dw Act_NewShotman_SetSpawnDelayH
	dw Act_NewShotman_SpawnH
ENDR
	dw Act_NewShotman_AfterSpawnH
	dw Act_NewShotman_AfterSpawnV
	DEF ACTRTN_NEWSHOTMAN_INITMAIN = $00
	DEF ACTRTN_NEWSHOTMAN_SPAWNH = $03
	DEF ACTRTN_NEWSHOTMAN_AFTERSPAWNV = 2*3 + $03 ; $09

; =============== Act_NewShotman_InitMain ===============
Act_NewShotman_InitMain:
	; Use frames $00-$01, at 1/8 speed 
	xor  a
	ldh  [hActCur+iActSprMap], a
	ld   c, $01
	call ActS_Anim2
	
	; Set delay for triggering horizontal attack
	ld   a, 60
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_NewShotman_Main ===============
; Default idle routine.
Act_NewShotman_Main:
	; Use frames $00-$01, at 1/8 speed 
	ld   c, $01
	call ActS_Anim2
	
	; Every $80 frames, alternate between attacks
	ldh  a, [hTimer]
	bit  7, a			; Timer < $80?
	jr   z, .tryHorz		; If so, jump
	
.tryVert:
	; Only trigger the vertical attack within 3 blocks, fall back to the horizontal one otherwise.
	call ActS_GetPlDistanceX
	cp   BLOCK_H*3
	jr   nc, .tryHorz
	
	; Use sprite $02 while shooting up
	ld   a, $00
	call ActS_SetSprMapId
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	
	; Cooldown of half a second after spawning the shots
	ld   a, 30
	ldh  [hActCur+iActTimer0C], a
	
	; Spawn the two vertical shots, one on each side.
	xor  a									; A = Sprite $00, Moving left
	ld   de, ($01 << 8)|ACT_NEWSHOTMANSHOTV ; D = 1px/frame up, E = Actor Id
	ld   bc, ($00 << 8)|LOW(-$10)			; B = Same X pos, C = 16px above
	call ActS_SpawnArcShot
	
	ld   a, ACTDIR_R						; A = Sprite $00, Moving right
	ld   de, ($01 << 8)|ACT_NEWSHOTMANSHOTV	; D = 1px/frame up, E = Actor Id
	ld   bc, ($00 << 8)|LOW(-$10)			; B = Same X pos, C = 16px above
	call ActS_SpawnArcShot
	
	; Switch to after-shot cooldown
	ld   a, ACTRTN_NEWSHOTMAN_AFTERSPAWNV
	ldh  [hActCur+iActRtnId], a
	ret
	
.tryHorz:
	; Wait until the second ticks down before triggering the horizontal attack.
	; This is mainly useful if we came here from .tryVert, as it gives a window of opportunity
	; for the vertical attack to trigger.
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Otherwise, prepare the horizontal attack.
	jp   ActS_IncRtnId
	
; =============== Act_NewShotman_SetSpawnDelayH ===============
; Sets up the delay between horizontal shots.
Act_NewShotman_SetSpawnDelayH:
	; Use frames $00-$01, at 1/8 speed 
	ld   c, $01
	call ActS_Anim2
	; Half a second cooldown between shots
	ld   a, 30
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_NewShotman_SpawnH ===============
; Fires an horizontal shot on each side.
Act_NewShotman_SpawnH:
	; While waiting, use frames $00-$01, at 1/8 speed 
	ld   c, $01
	call ActS_Anim2
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Then, fire both shots on each side.
	; These are aligned to the small chutes at the side of the enemy.
	
	ld   a, ACT_NEWSHOTMANSHOTH
	ld   bc, (LOW(-$08) << 8)|LOW(-$08) ; 8px left, 8px up
	call ActS_SpawnRel
	jr   c, .nextMode
	; As this actor visually faces forward and has symmetrical attacks, it never sets an explicit horizontal direction.
	; This means it's internally always facing left, so calling the following alo makes the shot face/move left.
	call ActS_SyncDirToSpawn
	
	; RIGHT SIDE
	ld   a, ACT_NEWSHOTMANSHOTH
	ld   bc, (LOW($08) << 8)|LOW(-$08) ; 8px right, 8px up
	call ActS_SpawnRel
	jr   c, .nextMode
	call ActS_SyncRevDirToSpawn ; Face right
	
.nextMode:
	jp   ActS_IncRtnId
	
; =============== Act_NewShotman_AfterSpawnH ===============
; Returns to the main routine after the horizontal shots are all spawned.
Act_NewShotman_AfterSpawnH:
	; Use frames $00-$01, at 1/8 speed 
	ld   c, $01
	call ActS_Anim2
	ld   a, ACTRTN_NEWSHOTMAN_INITMAIN
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_NewShotman_AfterSpawnV ===============
; Cooldown after spawning vertical shots.
Act_NewShotman_AfterSpawnV:
	; Use sprite $02 for 30 seconds (previously set in Act_NewShotman_InitMain)
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; After the cooldown elapses, do the horizontal attack.
	; Unlike when the horizontal attack starts on its own, the first shot is delayed by a second.
	; (the ther two ones still delay by half a second)
	ld   a, 60
	ldh  [hActCur+iActTimer0C], a
	ld   a, ACTRTN_NEWSHOTMAN_SPAWNH
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_NeedlePress ===============
; ID: ACT_NEEDLEPRESS
; Retractable needle obstacle.
Act_NeedlePress:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_NeedlePress_InitDelay
	dw Act_NeedlePress_WaitCycle
	dw Act_NeedlePress_InitMain
	dw Act_NeedlePress_Main
	DEF ACTRTN_NEEDLEPRESS_INITMAIN = $02

; =============== Act_NeedlePress_InitDelay ===============
Act_NeedlePress_InitDelay:
	; The needle starts out hidden on a ceiling
	ld   b, ACTCOLI_PASS
	call ActS_SetColiType
	; Adjust 1px down
	ld   hl, hActCur+iActX
	inc  [hl]
	
	;
	; Alternate between cycle timings for every Needle Press that spawns (see Act_NeedlePress_WaitCycle)
	;
	ld   a, [wActNePrLastCycleTarget]	; Toggle 0 and 1
	xor  $01
	ld   [wActNePrLastCycleTarget], a
	ldh  [hActCur+iNePrCycleTarget], a	; Use new value as target
	
	jp   ActS_IncRtnId
	
; =============== Act_NeedlePress_WaitCycle ===============
; Waits until it's the turn for the needle to extend downwards from the ceiling.
Act_NeedlePress_WaitCycle:

	;
	; Wait until wGameTime % 2 == iNePrCycleTarget to extend the spike.
	; This is mainly to avoid, after vertical transitions where multiple actors get spawned 
	; in the same frame, to have multiple onscreen spikes use the same cycle.
	;
	ld   a, [wGameTime]					; B = wGameTime % 2 (current timer)
	and  $01
	ld   b, a
	ldh  a, [hActCur+iNePrCycleTarget]	; A = Target second
	cp   b								; Does it match with the current one?
	ret  nz								; If not, keep waiting
	
	jp   ActS_IncRtnId
	
; =============== Act_NeedlePress_InitMain ===============
Act_NeedlePress_InitMain:
	; Start from the first frame (reset cycle, start extending down)
	xor  a
	ldh  [hActCur+iNePrAnimOff], a
	; Delay for 12 frames before applying any changes
	ld   a, $0C
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_NeedlePress_Main ===============
; Main animation routine for the Needle Press.
; This is an involved process, because its animation involves the needle extending and retracting 
; from the ceiling, altering the collision as needed.
Act_NeedlePress_Main:

	;
	; Seek to the current entry of the frame table.
	; This defines the properties of the current frame.
	;
	
	; HL = Ptr to Act_NeedlePress_AnimTbl[iNePrAnimOff]
	ldh  a, [hActCur+iNePrAnimOff]
	ld   hl, Act_NeedlePress_AnimTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	
	;
	; Check if we're pointing to the end terminator.
	; If we are, reset the animation to the start by re-executing Act_NeedlePress_InitMain.
	;
	ld   a, [hl]							; A = byte0
	cp   $FF								; End terminator reached?
	jr   nz, .valOk							; If not, jump
	ld   a, ACTRTN_NEEDLEPRESS_INITMAIN
	ldh  [hActCur+iActRtnId], a
	ret
	
.valOk:
	;
	; Wait for the timer to elapse before continuing.
	; [POI] This should have been the first thing done in the subroutine, to avoid running the indexing code while waiting
	;       and to prevent the last animation entry from being skipped (iNePrAnimOff will point to the end terminator).
	;
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	;
	; COLLISION BOX
	;
	; Map the sprite ID (byte0) to its vertical collision radius.
	; It's not fixed to $0F since the spike is two blocks tall, while the ceiling it hangs from can be less than that.
	;
	; The horizontal one doesn't need to change, so it's always $03.
	;
	push hl
		; HL = Act_NeedlePress_ColiBoxVTbl[byte0]
		ld   a, [hl]	 		; Read byte0, the sprite ID
		ld   hl, Act_NeedlePress_ColiBoxVTbl
		ld   b, $00
		ld   c, a
		add  hl, bc
		ld   c, [hl]			; Read vert radius from entry
		ld   b, $03				; Use fixed horz radius
		call ActS_SetColiBox	; Update box
	pop  hl
	
	;
	; COLLISION TYPE
	;
	; While this actor generally reflects shots, there is a point where it's fully retracted.
	; The sprite it uses during that time is $00, so save some CPU time by making it intangible there.
	;
	push hl
		ld   b, ACTCOLI_ENEMYREFLECT	; Reflect shots by default
		ld   a, [hl]					; Read sprite ID [byte0]
		or   a							; SpriteId != 0?
		jr   nz, .setColi				; If so, jump (keep reflecting shots)
		ld   b, ACTCOLI_PASS			; Otherwise, make intangible
	.setColi:
		call ActS_SetColiType
	pop  hl
	
	;
	; SPRITE ID
	;
	; Copy it almost as-is from byte0 to iActSprMap.
	;
	ldi  a, [hl]	; Read byte0, seek to byte1
	sla  a			; >> 3 since iActSprMap's first 3 bits are for the animation timer
	sla  a
	sla  a
	ldh  [hActCur+iActSprMap], a
	
	;
	; Y POSITION
	;
	; This needs to be adjusted due to the spike extending from the ceiling while actor origins are at the bottom.
	; The animation table defines it as an offset relative to the current position.
	;
	ldh  a, [hActCur+iActY]	; iActY += byte1
	add  [hl]
	ldh  [hActCur+iActY], a
	
	; For next time, advance animation to next entry
	ldh  a, [hActCur+iNePrAnimOff]
	add  $02 ; 
	ldh  [hActCur+iNePrAnimOff], a
	
	; Show current data for 12 frames
	ld   a, $0C
	ldh  [hActCur+iActTimer0C], a
	ret
	
; =============== Act_NeedlePress_AnimTbl ===============
; Defines the animation for extending and retracting the needle.
; Each entry is two bytes long:
; - 0: Sprite ID
;      This is used for two other purposes:
;      - As index to Act_NeedlePress_ColiBoxVTbl to get the vertical radius for the sprite
;      - To determine the collision type (see Act_NeedlePress_Main)
; - 1: Vertical offset compared to previous entry
Act_NeedlePress_AnimTbl:
	;  SPR  Y DIFF
	db $00, +$00
	db $00, +$00
	db $00, +$00
	db $01, +$08
	db $02, +$08
	db $03, +$10
	db $03, +$00
	db $03, -$00
	db $02, -$10
	db $01, -$08
	db $00, -$08
	db $00, -$00
	db $FF ; Terminator, loop to start

; =============== Act_NeedlePress_ColiBoxVTbl ===============
; Maps each sprite to its respective vertical radius. (the horizontal one is fixed, so it's not here)
Act_NeedlePress_ColiBoxVTbl: 
	db $03 ; $00
	db $03 ; $01
	db $07 ; $02
	db $0F ; $03

; =============== Act_Yambow ===============
; ID: ACT_YAMBOW
; Mosquito enemy, travels in a rectangular path around the player before charging in.
Act_Yambow:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Yambow_InitSpd
	dw Act_Yambow_PlFar
	dw Act_Yambow_MoveOppH0
	dw Act_Yambow_MoveOppH1
	dw Act_Yambow_WaitMoveD
	dw Act_Yambow_MoveD
	dw Act_Yambow_WaitCharge
	dw Act_Yambow_Charge

; =============== Act_Yambow_InitSpd ===============
Act_Yambow_InitSpd:
	; Set base movement speed, which won't be altered again.
	; (but specific routines will avoid moving the player with it)
	ld   bc, $0200		; 2px/frame horizontally
	call ActS_SetSpeedX
	ld   bc, $0280		; 2.5px/frame vertically
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_Yambow_PlFar ===============
; Waits for the player to get close.
Act_Yambow_PlFar:
	; Unlike the NES game, this enemy is neither invisibile nor intangible
	; while the player is outside its trigger range.
	
	; Use frames $00-$01, at speed 1/4
	; This is used all the time by this actor.
	ld   c, $02
	call ActS_Anim2
	
	; Face the player while waiting
	call ActS_FacePl
	
	; Trigger when the player gets within 3 blocks
	call ActS_GetPlDistanceX
	cp   BLOCK_H*3
	ret  nc
	jp   ActS_IncRtnId
	
; =============== Act_Yambow_MoveOppH0 ===============
; First part of moving to the other side of the screen.
; Moves the actor forward until it's on the same column as the player.
; This is split in two because the checks go off the player distance, an absolute value.
Act_Yambow_MoveOppH0:
	ld   c, $02
	call ActS_Anim2
	
	; Move forward at 2px/frame
	call ActS_ApplySpeedFwdX
	
	; Wait until the enemy moves above the player (within 16 pixels from the player)
	call ActS_GetPlDistanceX	; Get horz distance
	and  $F0					; Check block ranges
	or   a						; DiffX != $0x?
	ret  nz						; If so, return
	jp   ActS_IncRtnId
	
; =============== Act_Yambow_MoveOppH1 ===============
; Second part of moving to the other side of the screen.
; Moves the actor away from the player, still moving forward.
Act_Yambow_MoveOppH1:
	ld   c, $02
	call ActS_Anim2
	
	; Move forward at 2px/frame
	call ActS_ApplySpeedFwdX
	
	; Wait until the enemy moves 3 blocks away from the player (on the other side it moved from)
	call ActS_GetPlDistanceX
	cp   BLOCK_H*3
	ret  c
	
	; Wait for half a second after moving
	ld   a, 30
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Yambow_WaitMoveD ===============
; Waits before moving down and sets up downwards movement.
Act_Yambow_WaitMoveD:
	ld   c, $02
	call ActS_Anim2
	
	; Wait that half a second
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Hopefully face the player by doing this
	call ActS_FlipH
	
	; Make the enemy move down
	ldh  a, [hActCur+iActSprMap]
	or   ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Yambow_MoveD ===============
; Moves the actor down, until it's within 16px vertically from the player.
Act_Yambow_MoveD:
	ld   c, $02
	call ActS_Anim2
	
	; Move down at 2.5px/frame
	call ActS_ApplySpeedFwdY
	
	; Wait until the enemy moves within 16 pixels from the player
	call ActS_GetPlDistanceY	; Get vert distance
	and  $F0					; A /= $10
	swap a
	or   a						; DiffBlkY != 0?
	ret  nz						; If so, return
	
	; Wait half a second before charging
	ld   a, 30
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Yambow_WaitCharge ===============
Act_Yambow_WaitCharge:
	ld   c, $02
	call ActS_Anim2
	
	; Wait that half a second
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	jp   ActS_IncRtnId
	
; =============== Act_Yambow_Charge ===============
Act_Yambow_Charge:
	ld   c, $02
	call ActS_Anim2
	; Charge forward at 2px/frame
	call ActS_ApplySpeedFwdX
	ret

; =============== Act_HariHarry ===============
; ID: ACT_HARI
; Hari Harry, a porcupine shooting needles that's invulnerable while rolling.
Act_HariHarry:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_HariHarry_InitIdle
	dw Act_HariHarry_Idle
	dw Act_HariHarry_InitShoot
	dw Act_HariHarry_Shoot
	dw Act_HariHarry_InitShoot
	dw Act_HariHarry_Shoot
	dw Act_HariHarry_InitMove
	dw Act_HariHarry_MoveH
	dw Act_HariHarry_FallV
	DEF ACTRTN_HARI_INITSHOOT = $02
	DEF ACTRTN_HARI_MOVEH = $07

; =============== Act_HariHarry_InitIdle ===============
Act_HariHarry_InitIdle:
	; The enemy is initially idle for two seconds, vulnerable to shots
	ld   b, ACTCOLI_ENEMYHIT
	call ActS_SetColiType
	
	ld   bc, $0180			; 1.5px/frame forward when moving
	call ActS_SetSpeedX
	
	ld   a, 60*2			; Wait idle for 2 seconds
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_HariHarry_Idle ===============
Act_HariHarry_Idle:
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	jp   ActS_IncRtnId
	
; =============== Act_HariHarry_InitShoot ===============
; Prepare for shooting the needles.
Act_HariHarry_InitShoot:
	ld   a, $00
	ldh  [hActCur+iActTimer0C], a
	; Face the player in preparation for moving after shooting them
	call ActS_FacePl
	; Reset sprite to idle in case we got here after rolling
	ld   a, $00
	call ActS_SetSprMapId
	jp   ActS_IncRtnId
	
; =============== Act_HariHarry_Shoot ===============
; Enemy shoots the needles.
; This will happen twice on each cycle.
Act_HariHarry_Shoot:
	;
	; Shoot the needles right in the middle of the shooting sprite range (see below)
	;
	ldh  a, [hActCur+iActTimer0C]
	add  $01
	ldh  [hActCur+iActTimer0C], a
	cp   $18				; Timer == $18?
	jr   nz, .chkAnim		; If not, skip
	
	push af
		call Act_Hari_SpawnShots
	pop  af
	
.chkAnim:

	;
	; For the animation, alternate between the idle and shooting sprites every 16 frames.
	; This will switch it 3 times effectively:
	; $00-$0F -> Idle
	; $10-$1F -> Shoot
	; $20-$2F -> Idle
	; $30 -> (Next mode)
	;
	srl  a	; A >>= 4 for 16-frame ranges
	srl  a
	srl  a
	srl  a
	
	cp   ($30 >> 4)		; iActTimer0C == $30?	
	jr   z, .nextMode	; If so, next mode
.tryAnimShoot:
	and  $01			; Alternate between idle and shoot
	ld   a, a
	ld   [wActCurSprMapBaseId], a
	ret
.nextMode:
	ld   a, $00
	ld   [wActCurSprMapBaseId], a
	jp   ActS_IncRtnId
	
; =============== Act_HariHarry_InitMove ===============
; Sets up rolling forward.
Act_HariHarry_InitMove:
	; Roll towards the player for 1.5 seconds, while invulnerable
	ld   a, $5A
	ldh  [hActCur+iActTimer0C], a
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType
	call ActS_FacePl
	
	jp   ActS_IncRtnId
	
; =============== Act_HariHarry_MoveH ===============
; Roll forwards.
Act_HariHarry_MoveH:
	; Use frames $02-$03 at 1/8 speed
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ld   c, $01
	call ActS_Anim2
	
	; Wait for half a second before returning to shoot
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	jr   nz, .move
	
.endRoll:
	; Make vulnerable again when upright
	ld   b, ACTCOLI_ENEMYHIT
	call ActS_SetColiType
	; Prepare to shoot once more
	ld   a, ACTRTN_HARI_INITSHOOT
	ldh  [hActCur+iActRtnId], a
	ret
	
.move:
	; Move forward, turning around when hitting a wall
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	
	; If there's no ground below, start falling
	call ActS_GetGroundColi
	ld   a, [wColiGround]
	cp   $03
	ret  nz
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	
	jp   ActS_IncRtnId
	
; =============== Act_HariHarry_FallV ===============
; Falls down in the air.
; During this, the rolling timer does not tick down.
Act_HariHarry_FallV:
	; Use frames $02-$03 at 1/8 speed
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ld   c, $01
	call ActS_Anim2
	
	; Keep moving down until we hit solid ground.
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; Return to rolling forwards
	ld   a, ACTRTN_HARI_MOVEH
	ldh  [hActCur+iActRtnId], a
	ret	
	
; =============== Act_HariHarryShot ===============
; ID: ACT_HARISHOT
; An individual needle fired by Act_HariHarry.
; Spawned by Act_Hari_SpawnShots
Act_HariHarryShot:
	; Move in both directions, if any
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
; =============== Act_Cannon ===============
; ID: ACT_CANNON
; A cannon firing balls in an arc.
Act_Cannon:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Cannon_Init
	dw Act_Cannon_PlFar
	dw Act_Cannon_Unshield
	dw Act_Cannon_Shoot
	dw Act_Cannon_Shield
	dw Act_Cannon_Cooldown
	DEF ACTRTN_CANNON_PLFAR = $01
	
; =============== Act_Cannon_Init ===============
Act_Cannon_Init:
	; Horizontally center between two blocks
	ldh  a, [hActCur+iActX]
	add  $08
	ldh  [hActCur+iActX], a
	jp   ActS_IncRtnId
	
; =============== Act_Cannon_PlFar ===============
Act_Cannon_PlFar:
	call ActS_FacePl
	
	; Activate when the player gets within four and half blocks
	call ActS_GetPlDistanceX
	cp   $48
	ret  nc
	
	; Set up the unshield animation.
	; Use sprites $00-$03, showing each for 12 frames (1/12 speed)
	ld   de, ($00 << 8)|$03
	ld   c, $0C
	call ActS_InitAnimRange
	
	; [POI] The cannon isn't set to be immediately vulnerable during the animation, which is both
	;       misleading and also inconsistent with what the shielding anim does.
	
	jp   ActS_IncRtnId
	
; =============== Act_Cannon_Unshield ===============
Act_Cannon_Unshield:
	call ActS_FacePl
	
	; Wait until the unshield animation is done (24 frames)
	call ActS_PlayAnimRange
	ret  z
	
	; Use frame $03, for the exposed cannon
	ld   a, $00
	call ActS_SetSprMapId
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	
	; The exposed cannon is vulnerable
	ld   b, ACTCOLI_ENEMYHIT
	call ActS_SetColiType
	
	ld   a, $00
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Cannon_Shoot ===============
; Handles the shooting sequence.
; The cannon shoots twice during the course of 80 frames, after which it shields itself again.
Act_Cannon_Shoot:
	call ActS_FacePl
	
	; Tick on the animation timer, then check where we are in the animation.
	; The animation itself manually alternates between the two shooting sprites $03 and $02,
	; the latter being for the slightly retracted cannon ready to shoot.
	ldh  a, [hActCur+iActTimer0C]
	add  $01
	ldh  [hActCur+iActTimer0C], a
	
	;
	; $00-$1D -> Sprite $02
	;
	cp   $1E			; Timer >= $1E?
	jr   nc, .chkSh0	; If so, jump
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ret
	
.chkSh0:
	;
	; $1E-$27 -> Sprite $02
	;     $28 -> Shoot a ball
	;
	cp   $28
	push af
		call z, Act_Cannon_SpawnShot
	pop  af
	jr   nc, .chkWait0
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ret
	
.chkWait0:
	;
	; $28-$45 -> Sprite $03
	;
	cp   $46
	jr   nc, .chkSh1
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ret
.chkSh1:
	;
	; $46-$49 -> Sprite $02
	;     $50 -> Shoot a ball
	;
	cp   $50
	push af
		call z, Act_Cannon_SpawnShot
	pop  af
	jr   nc, .nextMode
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ret
.nextMode:
	;
	; $50 -> Sprite $02, start shield anim
	;
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	
	; Set up the shield animation.
	; Use sprites $03-$06, at 1/12 speed
	ld   de, ($03 << 8)|$06
	ld   c, $0C
	call ActS_InitAnimRange
	
	jp   ActS_IncRtnId
	
; =============== Act_Cannon_Shield ===============
Act_Cannon_Shield:
	call ActS_FacePl
	; Wait until the shield animation is done (24 frames)
	call ActS_PlayAnimRange
	ret  z
	
	; Make invulnerable after it's over
	ld   a, $00
	call ActS_SetSprMapId
	
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType
	
	; Cooldown of 1 second before checking the player getting near again
	ld   a, 60
	ldh  [hActCur+iActTimer0C], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Cannon_Cooldown ===============
Act_Cannon_Cooldown:
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	ld   a, ACTRTN_CANNON_PLFAR
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Cannon_SpawnShot ===============
Act_Cannon_SpawnShot:
	; Prepare the call to ActS_SpawnArcShot.
	; The cannonball should be thrown forwards, from the forward part of the cannon,
	; so its position variea depending on which direction it's facing.
	ld   bc, (LOW(-$08) << 8)|LOW(-$04)	; B = 8px left, C = 16px above
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R					; Facing right? (also, A = Same direction as cannon)
	jr   z, .spawnL					; If not, jump
	ld   bc, (LOW($08) << 8)|LOW(-$04)	; B = 8px right, C = 16px above
.spawnL:
	ld   de, ($02 << 8)|ACT_CANNONSHOT ; D = 2px/frame up, E = Actor Id
	jp   ActS_SpawnArcShot
	
; =============== Act_CannonShot ===============
; ID: ACT_CANNONSHOT
; A cannon firing balls in an arc.
; Has identical code to Act_NewShotmanShotV.
Act_CannonShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_CannonShot_JumpU
	dw Act_CannonShot_JumpD
; =============== Act_CannonShot_JumpU ===============
; Jump, pre-peak.
Act_CannonShot_JumpU:
	; [POI] Bounce on solid walls
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Apply gravity while moving up until we reach the peak
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
; =============== Act_CannonShot_JumpD ===============
; Jump, post-peak.
Act_CannonShot_JumpD:
	; [POI] Bounce on solid walls
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Apply gravity while moving down until we hit the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	; Despawn when touching the ground
	jp   ActS_Explode

; =============== Act_TellySpawner ===============
; ID: ACT_TELLYSPAWN
; Spawns Tellies every ~second at its location.
Act_TellySpawner:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_TellySpawner_Init
	dw Act_TellySpawner_Spawn
	dw Act_TellySpawner_Wait

; =============== Act_TellySpawner_Init ===============
; Sets the initial spawn delay.
Act_TellySpawner_Init:
	; Wait 32 frames before spawning the first one
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_TellySpawner_Spawn ===============
Act_TellySpawner_Spawn:
	; Wait the 32 frames, whenever they come from
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	;--
	; Try again 32 frames later...
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	
	; ...if there are more than 3 tellies onscreen
	ld   a, ACT_TELLY
	call ActS_CountById
	ld   a, b
	cp   $03
	ret  nc
	;--
	
	; Checks passed, spawn the Telly at the spawner's location
	ld   a, ACT_TELLY
	ld   bc, $0000
	call ActS_SpawnRel
	
	; Wait for a few seconds before spawning another one
	ld   a, $FF
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_TellySpawner_Wait ===============
Act_TellySpawner_Wait:
	; Wait 255 frames
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Wait the usual additional 32 frames in Act_TellySpawner_Spawn
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_DecRtnId
	
; =============== Act_Lift ===============
; ID: ACT_LIFT0, ACT_LIFT1, ACT_LIFT2 
; Moving lifts in Crash Man's stage, with separate paths for each actor.
Act_Lift:;I
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Lift_InitPath
	dw Act_Lift_InitPos
	dw Act_Lift_NextSeg
	dw Act_Lift_MoveH
	dw Act_Lift_MoveV
	DEF ACTRTN_LIFT_NEXTSEG = $02
	DEF ACTRTN_LIFT_MOVEH = $03
	DEF ACTRTN_LIFT_MOVEV = $04
	DEF LIFT_SPEED = $0080

; =============== Act_Lift_InitPath ===============
Act_Lift_InitPath:
	; Each actor ID has its own path assigned.
	; wActLiftPathId and wActLiftPathSeg being global variables means having multiple lifts on-screen won't work properly.
	ldh  a, [hActCur+iActId]	; wActLiftPathId = (iActId & $7F) - ACT_LIFT0
	and  $FF^ACTF_PROC
	sub  ACT_LIFT0
	ld   [wActLiftPathId], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Lift_InitPos ===============
Act_Lift_InitPos:
	; Adjust the actor's position to make it stand on the rail
	ldh  a, [hActCur+iActX]		; 5 pixels right
	add  $05
	ldh  [hActCur+iActX], a
	ldh  a, [hActCur+iActY]		; 4 pixels up
	sub  $04
	ldh  [hActCur+iActY], a
	
	; Start from the first segment
	xor  a
	ld   [wActLiftPathSeg], a
	
	; Use slow movement speed of 0.5px/frame
	ld   bc, LIFT_SPEED
	call ActS_SetSpeedX
	ld   bc, LIFT_SPEED
	call ActS_SetSpeedY
	
	jp   ActS_IncRtnId
	
; =============== Act_Lift_NextSeg ===============
; Handles the next path segment.
Act_Lift_NextSeg:
	;
	; Read the next path segnent from the nested tables.
	; A = Act_Lift_PathPtrTbl[wActLiftPathId][wActLiftPathSeg]
	;
	
	; Seek to the path table for this actor
	ld   hl, Act_Lift_PathPtrTbl	; HL = Table base
	ld   a, [wActLiftPathId]		; BC = wActLiftPathId * 2 (ptr table)
	add  a
	ld   b, $00
	ld   c, a
	add  hl, bc						; Offset it
	ld   e, [hl]					; Read the pointer out to HL
	inc  hl
	ld   d, [hl]
	ld   l, e						; HL = Ptr to Act_Lift_Path*
	ld   h, d
	; Seek to the current segment of this path
	ld   a, [wActLiftPathSeg]		; BC = wActLiftPathSeg * 2 (2 byte entries)
	add  a
	ld   b, $00
	ld   c, a
	add  hl, bc						; Offset it
	
	; The path data ends with a single $FF terminator
	ldi  a, [hl]					; Read byte0, seek to byte1
	cp   $FF						; Is it the terminator?
	jr   nz, .readSeg				; If not, jump
.endSeg:
	xor  a							; Otherwise, loop to the start
	ld   [wActLiftPathSeg], a
	jr   Act_Lift_NextSeg
.readSeg:
	push af ; Save byte0 AND flags
		; byte0 - Apply the segment's movement directions
		and  ACTDIR_R|ACTDIR_D			; B = New directions
		ld   b, a
		ldh  a, [hActCur+iActSprMap]	; A = iActSprMap
		and  $FF^(ACTDIR_R|ACTDIR_D)	; Delete old directions
		or   b							; Merge with new ones
		ldh  [hActCur+iActSprMap], a
		
		; byte1 - How many frames the lift should move
		ld   a, [hl]					; Read byte1
		ld   a, a
		ldh  [hActCur+iActTimer0C], a	; Write directly to iActTimer0C
		
		; Use the next segment next time
		ld   hl, wActLiftPathSeg
		inc  [hl]
	pop  af ; A = byte0, C = A < $FF
	
	; Pick the correct movement routine depending on the direction we're moving to.
	; This needs to be defined in a separate bit because ACTDIR_R and ACTDIR_D merely tell
	; which directions the lift is facing, not where it moves.
	rrca 						; Is bit0 set?
	jp   c, ActS_IncRtnId 		; If so, jump (move horizontally) ACTRTN_LIFT_MOVEH
	ld   a, ACTRTN_LIFT_MOVEV	; Otherwise, move vertically
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Lift_MoveH ===============
; Moves the lift horizontally.
Act_Lift_MoveH:
	; Move actor horizontally
	call ActS_ApplySpeedFwdX
	;--
	; If the player is standing on the actor, make him move along with it.
	; Not needed with vertical movement due to how the top-platform collision works at low speed.
	ld   a, [wActCurSlotPtr]		; B = Current slot
	ld   b, a
	ld   a, [wActPlatColiSlotPtr]	; A = Slot the player is standing on
	cp   b							; Do they match?
	jr   nz, .tick					; If not, skip
									; Otherwise...
	ldh  a, [hActCur+iActSprMap]	; Move the same direction as the lift
	ld   bc, LIFT_SPEED				; With the same speed
	call Pl_SetSpeedByActDir
	;--
	
.tick:
	; Do the above for the specified amount of frames
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Handle the next segment when done
	ld   a, ACTRTN_LIFT_NEXTSEG
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Lift_MoveV ===============
; Moves the lift vertically.
Act_Lift_MoveV:
	; Move vertically for the specified amount of frames
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Handle the next segment when done
	ld   a, ACTRTN_LIFT_NEXTSEG
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Lift_PathPtrTbl ===============
; Maps each lift actor with its own path data.
Act_Lift_PathPtrTbl: 
	dw Act_Lift_Path0 ; ACT_LIFT0
	dw Act_Lift_Path1 ; ACT_LIFT1
	dw Act_Lift_Path2 ; ACT_LIFT2
	
	DEF LIFT_MV_V = $00 ; Move vertically
	DEF LIFT_MV_H = $01 ; Move horizontally

; =============== Act_Lift_Path0 ===============
Act_Lift_Path0:
	;    MV DIR   MV AXIS, TIME (at 0.5/frame, it's BLOCK_H/V * 2)
	db ACTDIR_D|LIFT_MV_V, $40 ; 2   blocks
	db ACTDIR_L|LIFT_MV_H, $E0 ; 7   blocks
	db ACTDIR_U|LIFT_MV_V, $40 ; 2   blocks
	db ACTDIR_R|LIFT_MV_H, $E0 ; 7   blocks
	db $FF
; =============== Act_Lift_Path1 ===============
Act_Lift_Path1:
	db ACTDIR_D|LIFT_MV_V, $80 ; 4   blocks
	db ACTDIR_L|LIFT_MV_H, $80 ; 4   blocks
	db ACTDIR_U|LIFT_MV_V, $20 ; 1   block
	db ACTDIR_R|LIFT_MV_H, $40 ; 2   blocks
	db ACTDIR_U|LIFT_MV_V, $20 ; 1   block
	db ACTDIR_R|LIFT_MV_H, $20 ; 1   block
	db ACTDIR_U|LIFT_MV_V, $20 ; 1   block
	db ACTDIR_L|LIFT_MV_H, $40 ; 2   blocks
	db ACTDIR_D|LIFT_MV_V, $20 ; 1   block
	db ACTDIR_L|LIFT_MV_H, $60 ; 3   blocks
	db ACTDIR_U|LIFT_MV_V, $20 ; 1   block
	db ACTDIR_R|LIFT_MV_H, $40 ; 2   blocks
	db ACTDIR_U|LIFT_MV_V, $20 ; 1   block
	db ACTDIR_R|LIFT_MV_H, $80 ; 4   blocks
	db $FF
; =============== Act_Lift_Path2 ===============
Act_Lift_Path2:
	db ACTDIR_D|LIFT_MV_V, $A0 ; 5   blocks
	db ACTDIR_L|LIFT_MV_H, $C0 ; 6   blocks
	db ACTDIR_U|LIFT_MV_V, $20 ; 1   block
	db ACTDIR_R|LIFT_MV_H, $A0 ; 5   blocks
	db ACTDIR_U|LIFT_MV_V, $60 ; 3   blocks
	db ACTDIR_L|LIFT_MV_H, $20 ; 1   block
	db ACTDIR_D|LIFT_MV_V, $40 ; 2   blocks
	db ACTDIR_L|LIFT_MV_H, $60 ; 3   blocks
	db ACTDIR_U|LIFT_MV_V, $10 ; 0.5 blocks
	db ACTDIR_R|LIFT_MV_H, $40 ; 2   blocks
	db ACTDIR_U|LIFT_MV_V, $10 ; 0.5 blocks
	db ACTDIR_L|LIFT_MV_H, $40 ; 2   blocks
	db ACTDIR_U|LIFT_MV_V, $10 ; 0.5 blocks
	db ACTDIR_R|LIFT_MV_H, $40 ; 2   blocks
	db ACTDIR_U|LIFT_MV_V, $10 ; 0.5 blocks
	db ACTDIR_L|LIFT_MV_H, $60 ; 3   blocks
	db ACTDIR_U|LIFT_MV_V, $20 ; 1   block
	db ACTDIR_R|LIFT_MV_H, $C0 ; 6   blocks
	db $FF

; =============== Act_BlockyHead ===============
; ID: ACT_BLOCKYHEAD
; Tower of blocks made up of four section.
; This is the head part, the second block in the tower, which usually controls other child sections.
Act_BlockyHead:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BlockyHead_Init
	dw Act_BlockyHead_Idle0
	dw Act_BlockyHead_FallV
	dw Act_BlockyHead_Ground
	dw Act_BlockyHead_WaitRise
	dw Act_BlockyHead_Idle1
	 
; =============== Act_BlockyHead_Init ===============
Act_BlockyHead_Init:
	; Move forward at 0.25px/frame
	ld   bc, $0040
	call ActS_SetSpeedX
	
	:
	; Set the block-specific properties, which are required for all of the four blocks.
	; BLOCK 2/4
	;
	
	;
	; The individual blocks (both head and body) move back and forth,
	; even ones start moving right, while odd one start moving left.
	;
	; The head is the second block, so it starts moving right.
	; bit4 determines the direction (if set, it moves right) and the lower bits are the timer.
	ld   a, $18
	ldh  [hActCur+iBlockyWaveTimer], a
	
	; This keeps track of the block's position relative to the master, which allows reusing the same
	; movement code between head and body parts (Act_Blocky_MoveMain).
	; Since we *are* the head block, that will be zero here.
	xor  a
	ldh  [hActCur+iBlockyRelY], a
	
	;
	; Spawn the other body parts, which are separate actors.
	; Note that there are two actor types for the body parts, one used before the head is hit once,
	; which is thrown on signal, the other after it gets rebuilt, which explodes on signal.
	;
	; [POI] Them being separate actors, especially when they move back and forth, means it's possible
	;       to offscreen individual sections of the tower, but that can't be fixed without making it
	;       possible for actors to opt out of getting offscreened.
	;
	;       Also, the code below doesn't check if the individual sections couldn't spawn, so care
	;       must be taken when placing it.
	;
	
	; BLOCK 1/4
	ld   a, ACT_BLOCKYBODY
	ld   bc, ($00 << 8)|LOW(-$10) ; 16px up
	call ActS_SpawnRel
	ld   de, iBlockyWaveTimer
	add  hl, de
	ld   [hl], $08 ; iBlockyWaveTimer | Move left
	inc  hl
	ld   [hl], -$10 ; iBlockyRelY | Needs to be consistent with what was passed to ActS_SpawnRel
	
	; BLOCK 3/4
	ld   a, ACT_BLOCKYBODY
	ld   bc, ($00 << 8)|LOW($10) ; 16px down
	call ActS_SpawnRel
	ld   de, iBlockyWaveTimer
	add  hl, de
	ld   [hl], $08 ; iBlockyWaveTimer | Move left
	inc  hl
	ld   [hl], $10 ; iBlockyRelY
	
	; BLOCK 4/4
	ld   a, ACT_BLOCKYBODY
	ld   bc, ($00 << 8)|LOW($20) ; 32px down
	call ActS_SpawnRel
	ld   de, iBlockyWaveTimer
	add  hl, de
	ld   [hl], $18 ; iBlockyWaveTimer | Move right
	inc  hl
	ld   [hl], $20 ; iBlockyRelY
	
	
	; Initialize global variables used for communication between head and body.
	; Side effect of doing this is that you can't have more than one Blocky on-screen.
	ld   hl, wActBlockyMode
	xor  a
	; Signal out to Act_BlockyBody idle mode
	ldi  [hl], a 				; wActBlockyMode = BLOCKY_IDLE0
	; Will be used later for Act_BlockyRise
	ldi  [hl], a 				; wActBlockyRiseDone
	; Initialize the base head position from iActY, which *all*	blocks use to keep themselves in sync
	; (For the most part, iActY won't be used directly)
	ldh  a, [hActCur+iActY]		; wActBlockyHeadY = iActY
	ldi  [hl], a
	
	; The head is vulnerable immediately
	ld   b, ACTCOLI_ENEMYHIT
	call ActS_SetColiType
	
	jp   ActS_IncRtnId
	
; =============== Act_BlockyHead_Idle0 ===============
; Main idle code before the enemy is hit once.
; This mainly moves the enemy forwards.
Act_BlockyHead_Idle0:
	
	;
	; Handle blinking animation
	; Uses frames $00-$01 with the following timing:
	;
	ldh  a, [hActCur+iBlockyWaveTimer]
	add  $08			; Shift timing by 8
	and  %01111100		; This mask zeroes out ranges $80-$83 and $00-$03, making them use the closed eyes
	sub  $01			; If the result was 0, set carry flag
	ld   a, $00
	adc  a				; Push carry into result, alternating between $00 and $01
	ld   [wActCurSprMapBaseId], a
	
	; Fall off empty blocks, if any, while moving forwards, bringing the body parts down with it.
	call Act_BlockyHead_ChkGround
	call Act_Blocky_MoveMain
	
	;
	; If hit by the player, fall to the ground while launching the body blocks forward.
	; Any hit from a weapon that doesn't clink will bring the health below the threshold.
	;
	call ActS_GetHealth
	cp   $11					; Health >= $11?
	ret  nc						; If so, wait
	
	; Signal out to throw the blocks
	ld   hl, wActBlockyMode		; wActBlockyMode = BLOCKYBODY_THROW
	inc  [hl]
	; Not necessary, already done
	inc  hl ; wActBlockyRiseDone
	ld   [hl], $00
	; Set shocked eyes (until the body blocks despawn)
	ld   a, $01
	call ActS_SetSprMapId
	; Make invulnerable until the tower recomposes itself
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType
	; Set the actor to be one hit from death
	ld   b, $11
	call ActS_SetHealth
	
	; Prepare for falling to the ground
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_BlockyHead_FallV ===============
; Head falling to the ground.
Act_BlockyHead_FallV:
	; Wait for the head to fall to the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	; Set initial check delay (see below)
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_BlockyHead_Ground ===============
; Head on the ground, waiting to rebuild itself.
Act_BlockyHead_Ground:
	
	;--
	;
	; The body parts, once they hit the ground, bounce a bit, then finally despawning when they hit the ground again.
	; Wait until all of them have despawned before starting to rebuild the tower. 
	; These checks are made every 16 frames to save time.
	;
	
	; Wait for those 16 frames
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Set a new delay in case the check below fails
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	; If any body parts are still active, wait
	ld   a, ACT_BLOCKYBODY
	call ActS_CountById
	ld   a, b
	and  a
	ret  nz
	;--
	
	;
	; Spawn the rising body blocks (Act_BlockyRise), which once finish rising they will 
	; start moving forward themselves, identically to Act_BlockyBody.
	; This is similar to what was done in Act_BlockyHead_Init, except the rising blocks
	; come from the bottom of the screen.
	;
	
	; BLOCK 2/4 (Head)
	; This is reset like in Act_BlockyHead_Init.
	ld   a, $18							; Start moving right
	ldh  [hActCur+iBlockyWaveTimer], a
	xor  a								; Head is base part
	ldh  [hActCur+iBlockyRelY], a

	; BLOCK 1/4
	; All other body blocks follow this template.
	ld   a, ACT_BLOCKYRISE
	; Use the head's position (currently on the ground) as reference point.
	ld   bc, $0000						
	call ActS_SpawnRel
	; Immediately replace the Y position to point off-screen below.
	; The positions chosen among the three blocks make a 3-block tower with no gaps inbetween.
	ld   de, iActY 								; DE = $07
	add  hl, de									; Seek to iActY
	ld   [hl], OBJ_OFFSET_Y+SCREEN_V+($10*0)	; Offscreen below
	; Set custom properties, identical to those in Act_BlockyHead_Init.
	dec  de										; DE = 06
	add  hl, de									; Seek to iActY+$06 = iBlockyWaveTimer
	ld   [hl], $08 ; iBlockyWaveTimer
	inc  hl
	ld   [hl], -$10 ; iBlockyRelY 
	
	; BLOCK 3/4
	ld   a, ACT_BLOCKYRISE
	ld   bc, $0000
	call ActS_SpawnRel
	ld   de, iActY
	add  hl, de
	ld   [hl], OBJ_OFFSET_Y+SCREEN_V+($10*1)
	dec  de
	add  hl, de
	ld   [hl], $08 ; iBlockyWaveTimer | Move left
	inc  hl
	ld   [hl], $10 ; iBlockyRelY
	
	; BLOCK 4/4
	ld   a, ACT_BLOCKYRISE
	ld   bc, $0000
	call ActS_SpawnRel
	ld   de, iActY
	add  hl, de
	ld   [hl], OBJ_OFFSET_Y+SCREEN_V+($10*2)
	dec  de
	add  hl, de
	ld   [hl], $18 ; iBlockyWaveTimer | Move right
	inc  hl
	ld   [hl], $20 ; iBlockyRelY
	
	ld   hl, wActBlockyMode
	xor  a
	; The new block types spawned have their own communication sequence
	ldi  [hl], a ; wActBlockyMode = BLOCKYRISE_REBUILD
	; Not necessary, it's already 0
	ld   [hl], a ; wActBlockyRiseDone
	jp   ActS_IncRtnId
	
; =============== Act_BlockyHead_WaitRise ===============
; Waiting for the blocks to rise up, then sets up movement.
Act_BlockyHead_WaitRise:
	; Wait until all Act_BlockyRise have finished moving.
	; Note that they always finish doing so on the same frame, so we'll read either $00 or $03
	ld   a, [wActBlockyRiseDone]
	cp   $03
	ret  nz
	
	; Set normal eye sprite
	ld   a, $00
	call ActS_SetSprMapId
	; Make head vulnerable again
	ld   b, ACTCOLI_ENEMYHIT
	call ActS_SetColiType
	; Signal to the body parts that normal movement is enabled.
	; This will cause them to move forward in sync.
	ld   hl, wActBlockyMode
	inc  [hl]				; wActBlockyMode = BLOCKYRISE_IDLE1
	
	jp   ActS_IncRtnId
	
; =============== Act_BlockyHead_Idle1 ===============
; Main idle code after the enemy is hit once.
; The actor explodes if hit again on the head.
Act_BlockyHead_Idle1:
	;--
	; Handle blinking animation, identically to Act_BlockyHead_Idle0
	ldh  a, [hActCur+iBlockyWaveTimer]
	add  $08
	and  $7C
	sub  $01
	ld   a, $00
	adc  a
	ld   [wActCurSprMapBaseId], a
	;--
	
	; Fall off empty blocks, if any, while moving forwards, bringing the body parts down with it
	call Act_BlockyHead_ChkGround
	call Act_Blocky_MoveMain
	
	; If hit another time, make the actor explode
	call ActS_ChkExplodeNoChild
	ret  nc
	; And signal that out to the body parts
	ld   hl, wActBlockyMode		; wActBlockyMode = BLOCKY_DEAD
	inc  [hl]
	ret
	
; =============== Act_Blocky_MoveMain ===============
; Handles normal block movement, used for both the head and body parts.
; The code being shared means it needs to account for their different positions.
Act_Blocky_MoveMain:

	;
	; Y POSITION
	;
	; The blocks don't typically move vertically, but they can fall off platforms.
	; To ensure the body parts are always kept in sync, the Y position is regenerated
	; based on the head's position:
	;
	; iActY = wActBlockyHeadY + iAct0E 
	;
	ld   a, [wActBlockyHeadY]		; A = Base Y pos of head
	ld   hl, hActCur+iBlockyRelY	; HL = Ptr to actor's Y offset (relative to the head)
	add  [hl]						; Add both to get the final value
	ldh  [hActCur+iActY], a
	
	;
	; X POSITION
	;
	; This is a bit more involved, as it is influenced by two factors:
	; - Normal forward movement
	; - The wave pattern
	;
	
	;
	; First, move forward at its normal 0.25px/frame speed
	;
	call ActS_ApplySpeedFwdX
	
	;
	; Then, move horizontally depending on the wave pattern location.
	;
	; In practice, alternate every 16 frames between moving left and right at 0.5px/frame.
	; This movement is applied directly to the horizontal position, which avoids having to adjust the speed.
	;

	; HL = (iBlockyWaveTimer / 16) % 2
	;      The result will either be $0100 or $0000.
	;      If it's $0100, the base movement speed of -0.5px (left) will become 0.5px (right).
	ldh  a, [hActCur+iBlockyWaveTimer]
	and  $10			; A = iBlockyWaveTimer & $10
	rrca 				; A >>= 4
	rrca 
	rrca 
	rrca 
	ld   h, a			; HL = A
	ld   l, $00
	
	ld   de, -$0080		; Get base 0.5px/frame left
	add  hl, de			; Make it move right, if the timer agrees
	
	; iActX += HL
	ldh  a, [hActCur+iActXSub]	; DE = Current speed
	ld   e, a
	ldh  a, [hActCur+iActX]
	ld   d, a
	add  hl, de					; Add new one
	ld   a, l					; Save back
	ldh  [hActCur+iActXSub], a
	ld   a, h
	ldh  [hActCur+iActX], a
	
	; Advance the wave timer
	ld   hl, hActCur+iBlockyWaveTimer
	inc  [hl]
	ret
	
; =============== Act_BlockyHead_ChkGround ===============
; Checks if the actor is touching the solid ground, and if so, makes it tall.
; This check only needs to be made by the head part, so it's tailored for that.
Act_BlockyHead_ChkGround:

	; LEFT CORNER
	ldh  a, [hActCur+iActX]	; X Target: ActX - $07 (left)
	sub  $07
	ld   [wTargetRelX], a
	
	; [BUG] The head block is the 2nd of the 4 blocks from the top, so 2 body blocks are below.
	;       As blocky's sections are are $10 pixels tall, that makes for the $20... which is off by one,
	;       so the actor sinks 1 pixel into the ground for what's worth.
	ldh  a, [hActCur+iActY]	; Y Target: ActX + $20 (ground - 1)
	add  BLOCK_V*2         
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ret  nc
	
	; RIGHT CORNER
	ldh  a, [hActCur+iActX]	; X Target: ActX + $07 (right)
	add  $07
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	ret  nc
	
	; If we got here, there is no ground below, so fall at 2px/frame downwards by directly affecting the Y position.
	; Even though it's falling 2px at a time, it can't sink into the ground this way as that's a multiple of the block height.
	ld   hl, wActBlockyHeadY	; wActBlockyHeadY += $02
	inc  [hl]
	inc  [hl]
	ret
	
; =============== Act_BlockyBody ===============
; ID: ACT_BLOCKYBODY
; Invulnerable body section of Blocky, before the rebuild.
Act_BlockyBody:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BlockyBody_Init
	dw Act_BlockyBody_Idle
	dw Act_BlockyBody_JumpU
	dw Act_BlockyBody_JumpD
	dw Act_BlockyBody_Explode

; =============== Act_BlockyBody_Init ===============
Act_BlockyBody_Init:
	; Move forward at 0.25px/frame, the same speed as the head
	ld   bc, $0040
	call ActS_SetSpeedX
	jp   ActS_IncRtnId
	
; =============== Act_BlockyBody_Idle ===============
Act_BlockyBody_Idle:
	; Continue moving horizontally, like the head part
	call Act_Blocky_MoveMain
	
	;
	; Throw the blocks when we're signaled to.
	;
	
	; Wait for the signal first
	ld   a, [wActBlockyMode]
	and  a						; wActBlockyMode == BLOCKYBODY_IDLE0?
	ret  z						; If so, return
	
	xor  a
	ldh  [hActCur+iBlockyGroundBounce], a
	
	;
	; Each block in the tower is thrown in a different arc, and the speed values
	; are read from a table indexed by block ID.
	;
	; The block ID can be easily determined through the relative Y position to the head block,
	; which is unique for each and always a multiple of $10.
	; The topmost block has a negative -$10 value since it's above the head block, so that
	; needs to be counterbalanced:
	; BlockId = (iBlockyRelY + $10) / $10
	;
	; Each table entry is 4 bytes long (iActSpdXSub-iActSpdY) so:
	; Offset = (iBlockyRelY + $10) / $10 * $04
	;        = (iBlockyRelY + $10) / $04
	;
	ldh  a, [hActCur+iBlockyRelY]	
	add  $10						; Account for topmost block being -$10
	rrca 							; / $04
	rrca 							; ""
	ld   hl, Act_BlockyBody_ThrowSpdTbl	; HL = Table base
	ld   b, $00						; BC = Offset
	ld   c, a
	add  hl, bc						; Seek to entry
	; Copy the four speed values from the entry to the actor 
	ld   de, hActCur+iActSpdXSub
	REPT 4
		ldi  a, [hl]
		ld   [de], a
		inc  de
	ENDR
	
	; Throw the blocks in the direction of the player
	call ActS_FacePl
	
	jp   ActS_IncRtnId
	

; =============== Act_BlockyBody_JumpU ===============
; Jump, pre-peak.
Act_BlockyBody_JumpU:
	; Move forward
	call ActS_ApplySpeedFwdXColi
	; Apply gravity while moving up until we reach the peak
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_BlockyBody_JumpD ===============
; Jump, post-peak.
Act_BlockyBody_JumpD:
	; Move forward
	call ActS_ApplySpeedFwdXColi
	; Apply gravity while moving down until we hit the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	
	;
	; When the blocks hit the ground the first time, make them jump directly up.
	; This second jump is handled by returning to Act_BlockyBody_JumpU with different speed values.
	;
	
	ldh  a, [hActCur+iBlockyGroundBounce]
	and  a					; Already bounced on the ground once?
	jp   nz, ActS_IncRtnId	; If so, explode
	inc  a					; Otherwise, set up the bounce
	ldh  [hActCur+iBlockyGroundBounce], a
	
	ld   bc, $0000			; No horizontal speed
	call ActS_SetSpeedX
	ld   bc, $0200			; 2px/frame up
	call ActS_SetSpeedY
	jp   ActS_DecRtnId		; Return to handling the pre-peak jump
	
; =============== Act_BlockyBody_Explode ===============
Act_BlockyBody_Explode:
	jp   ActS_Explode
	
; =============== Act_BlockyBody_ThrowSpdTbl ===============
; Table of speed values for each separate block, indexed by block number. (iBlockyRelY / $10) + $10
Act_BlockyBody_ThrowSpdTbl:
	;      X      Y
	dw $0280, $0300 ; 1/4
	dw $0000, $0000 ; 2/4 ; Unused dummy entry for the head block
	dw $0200, $0280 ; 3/4
	dw $0180, $0180 ; 4/4

; =============== Act_BlockyRise ===============
; ID: ACT_BLOCKYRISE
; Invulnerable body section of Blocky, after the rebuild.
Act_BlockyRise:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BlockyRise_Init
	dw Act_BlockyRise_Rise
	dw Act_BlockyRise_WaitMove
	dw Act_BlockyRise_Move

; =============== Act_BlockyRise_Init ===============
Act_BlockyRise_Init:
	; Rising blocks can't be moving down
	ldh  a, [hActCur+iActSprMap]
	and  $FF^ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	
	ld   bc, $0040			; Same 0.25px/frame forward speed as the other blocks
	call ActS_SetSpeedX
	ld   bc, $0200			; 2px/frame rising speed
	call ActS_SetSpeedY
	ld   a, $20				; Rise for 32 frames
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_BlockyRise_Rise ===============
Act_BlockyRise_Rise:
	; Rise up for those 32 frames
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	;
	; Signal that the block has risen up.
	; The head part is looping at Act_BlockyHead_WaitRise, waiting for all three to have done so.
	; When that's done, forward movement will start, which is signaled to us by having 
	; wActBlockyMode set to BLOCKYRISE_IDLE1.
	;
	ld   hl, wActBlockyRiseDone
	inc  [hl]
	
	jp   ActS_IncRtnId
	
; =============== Act_BlockyRise_WaitMove ===============
; Waits for the head part to have entered the second moving phase.
Act_BlockyRise_WaitMove:
	; Wait for movement
	ld   a, [wActBlockyMode]
	and  a				; wActBlockyMode == BLOCKYRISE_REBUILD?
	ret  z				; If so, return
						; Otherwise, it's at BLOCKYRISE_IDLE1, start moving
	jp   ActS_IncRtnId
	
; =============== Act_BlockyRise_Move ===============
Act_BlockyRise_Move:
	; Move forward the normal way
	call Act_Blocky_MoveMain
	
	; If the head part got hit (a second time) instadespawn the actor.
	ld   a, [wActBlockyMode]
	cp   BLOCKYRISE_DEAD
	ret  nz
	xor  a
	ldh  [hActCur+iActId], a
	ret
	
; =============== Act_Pipi ===============
; ID: ACT_PIPI
; A bird that drops eggs.
; Only spawned by Act_PipiSpawner, which takes care of spawning it from the correct side.
Act_Pipi:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Pipi_InitWait
	dw Act_Pipi_Wait
	dw Act_Pipi_Move

; =============== Act_Pipi_InitWait ===============
Act_Pipi_InitWait:
	; Save an original copy of the offscreen X position here (see Act_Pipi_Wait)
	ldh  a, [hActCur+iActX]
	ldh  [hActCur+iPipiSpawnX], a
	
	; Wait 64 frames before coming from the side of the screen
	ld   a, $40
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Pipi_Wait ===============
; Waits offscreen.
Act_Pipi_Wait:

	; Force the bird to stay offscreen, in case we're scrolling the screen (ie: Air Man's stage)
	ldh  a, [hActCur+iPipiSpawnX]
	ldh  [hActCur+iActX], a
	
	; Wait for 64 frames 
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz

	; [BUG] This is forgetting to call ActS_ChkExplodeNoChild.
	;       This causes the death handler to be delayed until it gets to the next mode,
	;       which sounds odd when you can hear something getting hit multiple times offscreen.
	
	
	; Face the player, as that's not done by the spawner
	call ActS_FacePl
	
	; Move 0.75px/frame towards the player
	ld   bc, $00C0
	call ActS_SetSpeedX
	
	; Spawn the egg right below the actor
	ld   a, ACT_EGG
	ld   bc, $0008		; 8px below bird
	call ActS_SpawnRel
	; Keep track of the actor slot containing the egg
	ld   a, l
	ldh  [hActCur+iPipiEggSlotPtr_Low], a
	ld   a, h
	ldh  [hActCur+iPipiEggSlotPtr_High], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Pipi_Move ===============
; Moves horizontally in a straight line, until it gets offscreened the other side.
Act_Pipi_Move:
	; Use frames $00-$01 at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	
	; Move horizontally 
	call ActS_ApplySpeedFwdX
	
	; When the actor's health goes below the threshold, destroy it and notify the egg.
	; This lets the egg decide whether it should be destroyed automatically.
	call ActS_ChkExplodeNoChild		; Handle death
	ret  nc							; Did it happen? If not, return
	
	ld   a, ACT_EGG
	call ActS_CountById
	ld   a, b
	and  a							; Any eggs onscreen?
	ret  z							; If not, return
	
	; Seek HL to the egg's iEggBirdDead
	ldh  a, [hActCur+iPipiEggSlotPtr_Low]	
	add  iEggBirdDead
	ld   l, a
	ldh  a, [hActCur+iPipiEggSlotPtr_High]
	ld   h, a
	ld   [hl], $FF					; Flag as dead
	ret
	
; =============== Act_Egg ===============
; ID: ACT_EGG
; Egg carried/dropped by Pipi.
Act_Egg:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Egg_Init
	dw Act_Egg_MoveH
	dw Act_Egg_MoveHChkDrop
	dw Act_Egg_FallV

; =============== Act_Egg_Init ===============
Act_Egg_Init:
	; Move towards the player (same direction as the bird)
	call ActS_FacePl
	
	; Move at the same speed as the bird (0.75px/frame)
	ld   bc, $00C0
	call ActS_SetSpeedX
	
	; When dropped, start falling at 0.75px/frame too
	ld   bc, $00C0
	call ActS_SetSpeedY
	ldh  a, [hActCur+iActSprMap]
	or   ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	
	xor  a
	ldh  [hActCur+iEggBirdDead], a
	
	ld   a, $40
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Egg_MoveH ===============
; Egg carried by the bird. Move horizontally, don't drop.
; Gives a ~1 second window after it gets spawned where the Egg can't drop.
; This prevents the egg from being dropped into walls at the side of 
; the screen, if any are there.
Act_Egg_MoveH:
	; Move the egg to sync itself with the bird.
	
	call ActS_ApplySpeedFwdX
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	jp   z, ActS_IncRtnId			; Timer elapsed? If so, jump
	
	; If the bird has died, also destroy the egg since it's still being carried.
	ldh  a, [hActCur+iEggBirdDead]
	and  a
	ret  z
	jp   ActS_Explode
	
; =============== Act_Egg_MoveHChkDrop ===============
; Egg carried by the bird. Move horizontally, check for drop.
Act_Egg_MoveHChkDrop:
	; Move horizontally until the egg gets within 3 blocks of the player.
	call ActS_ApplySpeedFwdX
	call ActS_GetPlDistanceX
	cp   $30					; Distance < $30?
	jp   c, ActS_IncRtnId		; If so, jump
	
	; If the bird has died, also destroy the egg since it's still being carried.
	ldh  a, [hActCur+iEggBirdDead]
	and  a
	ret  z
	jp   ActS_Explode
	
; =============== Act_Egg_FallV ===============
; Egg was dropped by the bird.
; From this point, shooting the bird won't affect the egg.
Act_Egg_FallV:
	; Apply gravity at 0.75px/frame
	call ActS_ApplySpeedFwdYColi
	
	; If the egg fell offscreen, despawn it
	ldh  a, [hActCur+iActY]
	cp   SCREEN_GAME_V+OBJ_OFFSET_Y+$0C
	jp   nc, .despawn
	
	;
	; Wait until it hits a solid block.
	; When that happens, explode and spawn six small birds.
	;
	call Lvl_GetBlockId
	ret  c
	
	ld   de, Act_Egg_CopipiSpreadTbl	; HL = Properties
	ld   b, $06				; B = Actors left
.loop:
	push bc ; Save remaining birds
	
		;
		; Spawn the bird exactly at the egg's position.
		;
		
		; HL = Ptr to Act_Copipi's slot
		push de
			ld   a, ACT_COPIPI
			ld   bc, $0000
			call ActS_SpawnRel
		pop  de
		
		inc  hl ; iActRtnId
		inc  hl ; iActSprMap
		
		; Reset their directions.
		; Doing this makes the speed defined in Act_Egg_CopipiSpreadTbl a bit misleading 
		; (ie: negative h speed moves right), so it's not clear why it's like this.
		ld   a, [hl]
		and  $FF^(ACTDIR_R|ACTDIR_D)
		ld   [hl], a
		
		;
		; Each bird has its own *initial* movement speed, used exclusively to show them
		; spreading out from the egg in a formation.
		; 
		; Copy the speed properties from the table.
		;
		
		; Seek to iActSpdXSub
		ld   a, iActSpdXSub-iActSprMap
		ld   b, $00
		ld   c, a
		add  hl, bc
		
		ld   a, [de]	; iActSpdXSub = byte0
		ld   [hl], a
		inc  hl
		inc  de
		ld   a, [de]	; iActSpdX = byte1
		ld   [hl], a
		inc  hl
		inc  de
		ld   a, [de]	; iActSpdYSub = byte2
		ld   [hl], a
		inc  hl
		inc  de
		ld   a, [de]	; iActSpdY = byte3
		ld   [hl], a
		inc  de			; Seek to byte0 of next entry
	pop  bc 		; Get remaining birds to spawn
	dec  b			; Have all spawned?
	jr   nz, .loop	; If not, loop
	; Finally, visibly explode
	jp   ActS_Explode
.despawn:
	xor  a
	ldh  [hActCur+iActId], a
	ret
	
; =============== Act_Egg_CopipiSpreadTbl ===============
; Initial Speed for each spawned Copipi.
; Note that due to the bird's direction being forced into UP/LEFT, signs work the other way around.
Act_Egg_CopipiSpreadTbl:
	;       X       Y
	dw +$0000, -$00FF ; $00 ;                       ~1px/frame down
	dw -$00B4, +$00B4 ; $01 ; ~0.7px/frame right, ~0.7px/frame up 
	dw -$00FF, +$0000 ; $02 ;   ~1px/frame right
	dw +$0000, +$00FF ; $03 ;                       ~1px/frame up
	dw +$00FF, +$0000 ; $04 ;   ~1px/frame left
	dw +$00B4, +$00B4 ; $05 ; ~0.7px/frame left,  ~0.7px/frame up 

; =============== Act_Copipi ===============
; ID: ACT_COPIPI
; Small bird that spawns from an egg.
Act_Copipi:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Copipi_InitSpread
	dw Act_Copipi_Spread
	dw Act_Copipi_Fly

; =============== Act_Copipi_InitSpread ===============
Act_Copipi_InitSpread:
	; How long the birds should spread out
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Copipi_Spread ===============
; Animates the small bird spreading out from the egg's origin.
Act_Copipi_Spread:
	; Use frames $00-$01 at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	
	; Move from the egg into the initial formation
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	
	; Wait for those 32 frames...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Once that's all done, target the player's position at the time of the check.
	call ActS_AngleToPl
	jp   ActS_IncRtnId
	
; =============== Act_Copipi_Fly ===============
Act_Copipi_Fly:
	; Use frames $00-$01 at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	; Move hopefully towards the player
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
; =============== Act_Shotman ===============
; ID: ACT_SHOTMAN
; Fires shots in an high or low arc.
Act_Shotman:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Shotman_Init
	dw Act_Shotman_ShotLow
	dw Act_Shotman_WaitShotHi
	dw Act_Shotman_ShotHi
	dw Act_Shotman_InitShotLow
	DEF ACTRTN_SHOTMAN_SHOTLOW = $01
; =============== Act_Shotman_Init ===============
; Sets up the initial low arc pattern.
Act_Shotman_Init:
	; Use sprite $00 (low arc)
	ld   a, $00
	call ActS_SetSprMapId
	
	; After six shots, switch to the high arc
	ld   a, $06
	ldh  [hActCur+iShotmanShotsLeft], a
	
	; Start the shooting sequence almost immediately, without any long delay like how it is between arcs.
	; Still wait the usual 32 frame cooldown, normally used between shots
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Shotman_ShotLow ===============
; Fire long shots in a low arc.
Act_Shotman_ShotLow:
	; Wait for the cooldown to elapse first
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Then spawn the shot
	ld   a, ACT_SHOTMANSHOT
	ld   bc, (LOW(-$0C) << 8)|LOW(-$08) ; 12px left, 8px up
	call ActS_SpawnRel
	ld   de, $0300 ; 3px/frame forward
	ld   bc, $0200 ; 2px/frame up
	call nc, Act_Shotman_SetShotSpeed
	
	; Set cooldown of 32 frames before the next shot
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	
	; If all six shots have been fired, delay for a bit and switch to an higher arc
	ld   hl, hActCur+iShotmanShotsLeft
	dec  [hl]				; ShotsLeft--
	ret  nz					; ShotsLeft != 0? If so, return
	
	; Fire six high arc shots
	ld   a, $06
	ldh  [hActCur+iShotmanShotsLeft], a
	; Use sprite $01 (transition to other arc)
	ld   a, $01
	call ActS_SetSprMapId
	; Show the transition sprite for 8 frames.
	; This means the next shot comes out in 32+8 = 40 frames
	ld   a, $08
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Shotman_InitShowHi ===============
Act_Shotman_WaitShotHi:
	; Wait until the transition timer elapses
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Use sprite $02 (high arc)
	ld   a, $02
	call ActS_SetSprMapId
	; Normal 32 frame cooldown
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Shotman_ShotHi ===============
; Fire near shots in a high arc.
; See also: Act_Shotman_ShotLow
Act_Shotman_ShotHi:
	; Wait for the cooldown to elapse first
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Then spawn the shot
	ld   a, ACT_SHOTMANSHOT
	ld   bc, (LOW(-$0C) << 8)|LOW(-$0C) ; 12px left, 12px up
	call ActS_SpawnRel
	ld   de, $0080 ; 0.5px/frame forward
	ld   bc, $0380 ; 3.5px/frame up
	call nc, Act_Shotman_SetShotSpeed
	
	; Set cooldown of 32 frames before the next shot
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	
	; If all six shots have been fired, delay for a bit and switch back to the lower arc
	ld   hl, hActCur+iShotmanShotsLeft
	dec  [hl]				; ShotsLeft--
	ret  nz					; ShotsLeft != 0? If so, return
	
	; Fire six low arc shots
	ld   a, $06
	ldh  [hActCur+iShotmanShotsLeft], a
	; Use sprite $01 (transition to other arc)
	ld   a, $01
	call ActS_SetSprMapId
	; Show the transition sprite for 8 frames.
	ld   a, $08
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId

; =============== Act_Shotman_InitShotLow ===============
Act_Shotman_InitShotLow:
	; Wait until the transition timer elapses
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Use sprite $02 (low arc)
	ld   a, $00
	call ActS_SetSprMapId
	; Normal 32 frame cooldown
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	ld   a, ACTRTN_SHOTMAN_SHOTLOW
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Shotman_SetShotSpeed ===============
; Sets the newly spawned shot's arc.
; IN
; - HL: Ptr to spawned shot slot
; - DE: Horizontal speed
; - BC: Vertical speed
Act_Shotman_SetShotSpeed:
	; Seek HL to iActSpdXSub
	ld   a, l
	add  iActSpdXSub
	ld   l, a
	; Write the properties over
	ld   [hl], e ; iActSpdXSub
	inc  hl
	ld   [hl], d ; iActSpdX
	inc  hl
	ld   [hl], c ; iActSpdYSub
	inc  hl
	ld   [hl], b ; iActSpdY
	ret
	
; =============== Act_FlyBoy ===============
; ID: ACT_FLYBOY
; An easy to miss propeller enemy that homes in the player.
; Spawned by Act_FlyBoySpawner, never part of the actor layout.
Act_FlyBoy:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_FlyBoy_Init
	dw Act_FlyBoy_JumpD
	dw Act_FlyBoy_Ground
	dw Act_FlyBoy_LiftOff
	dw Act_FlyBoy_JumpU
	DEF ACTRTN_FLYBOY_JUMPD = $01

; =============== Act_FlyBoy_Init ===============
Act_FlyBoy_Init:
	ld   a, $00				; Use normal sprite	
	call ActS_SetSprMapId
	ld   bc, $0040			; 0.25px/frame speed
	call ActS_SetSpeedX
	
	; Prepare for falling down, as these enemies are spawned in the air
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_FlyBoy_JumpD ===============
; Jump arc, post-peak.
Act_FlyBoy_JumpD:
	; (No animation, use sprite $00 while moving down)
	
	; Handle jump arc until touching the ground
	call ActS_ApplySpeedFwdXColi
	call ActS_ApplySpeedDownYColi
	ret  c
	; Wait 32 frames on the ground
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_FlyBoy_Ground ===============
; Grounded.
Act_FlyBoy_Ground:
	; While on the ground and also a bit after, the enemy tries to propel itself up.
	; This animation will play until after the next jump's peak.
	ld   c, $01
	call ActS_Anim2
	
	; Wait for it...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; After 32 frames, start slowly moving up for around 3 seconds
	ld   bc, $0040			; 0.25px/frame up
	call ActS_SetSpeedY
	ld   a, $C0				; ~3 seconds
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_FlyBoy_LiftOff ===============
; Slowly moving up.
Act_FlyBoy_LiftOff:
	; Continue with the propelling animation
	ld   c, $01
	call ActS_Anim2
	
	; Move slowly 0.25px/frame up for 3 seconds
	call ActS_ApplySpeedFwdYColi
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	;
	; Set up the jump arc for precisely targeting the player:
	; H Speed: (PlDistance * 4)*subpixels*/frame
	; V Speed: 2px/frame
	;
	call ActS_FacePl
	
	call ActS_GetPlDistanceX
	ld   c, a
	ld   b, $00
	call ActS_SetSpeedX
	call ActS_DoubleSpd	
	call ActS_DoubleSpd
	
	ld   bc, $0200
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_FlyBoy_JumpU ===============
; Jump arc, pre-peak.
Act_FlyBoy_JumpU:
	; Use flying animation ($00-$01) at 1/8 speed
	; This is only used when moving up.
	ld   c, $01
	call ActS_Anim2
	; Handle the jump arc until we reach the peak
	call ActS_ApplySpeedFwdXColi
	call ActS_ApplySpeedUpYColi
	ret  c
	; Start moving down then
	ld   a, ACTRTN_FLYBOY_JUMPD
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_FlyBoySpawner ===============
; ID: ACT_FLYBOYSPAWN
; Fly Boy spawner.
Act_FlyBoySpawner:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_FlyBoySpawner_Init
	dw Act_FlyBoySpawner_Main

; =============== Act_FlyBoySpawner_Init ===============
Act_FlyBoySpawner_Init:
	; Wait ~3 seconds before spawning one in.
	; This is way too shot, making it easy to miss them in the only place they are used.
	ld   a, $C0
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_FlyBoySpawner_Main ===============
Act_FlyBoySpawner_Main:
	; Wait until the delay elapses before spawning another one
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Set the same very long delay
	ld   a, $C0
	ldh  [hActCur+iActTimer0C], a
	
	; Max 2 Fly Boys on screen, otherwise try again after 3 seconds
	ld   a, ACT_FLYBOY
	call ActS_CountById
	ld   a, b
	cp   $02
	jp   nc, ActS_DecRtnId
	
	; Spawn directly on top of the spawner.
	; The spawner is set around the top of the screen, making these enemies fall in.
	ld   a, ACT_FLYBOY
	ld   bc, $0000
	call ActS_SpawnRel	; HL = Ptr to spawned Fly Boy
	ret  c				; Did it spawn? If not, return
	
	; Not necessary, this is already done by the Fly Boy's init code
	ld   a, l
	add  iActYSub
	ld   l, a
	xor  a
	ldi  [hl], a ; iActYSub
	ld   [hl], a ; iActY
	ret
	
; =============== Act_Springer ===============
; ID: ACT_SPRINGER
; Springy enemy that travels on the ground, speeding up when the player is at its vertical position.
Act_Springer:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Springer_Init
	dw Act_Springer_MoveSlow
	dw Act_Springer_TurnSlow
	dw Act_Springer_MoveFast
	dw Act_Springer_TurnFast
	dw Act_Springer_InitSpring
	dw Act_Springer_Spring
	DEF ACTRTN_SPRINGER_MOVESLOW = $01
	DEF ACTRTN_SPRINGER_MOVEFAST = $03
	DEF ACTRTN_SPRINGER_INITSPRING = $05

; =============== Act_Springer_Init ===============
Act_Springer_Init:
	ld   a, $00
	call ActS_SetSprMapId
	
	; Always start moving to the left at 0.25px/frame
	ldh  a, [hActCur+iActSprMap]
	and  $FF^ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	ld   bc, $0040
	call ActS_SetSpeedX
	
	jp   ActS_IncRtnId
	
; =============== Act_Springer_MoveSlow ===============
; Horizontal movement, slow speed.
Act_Springer_MoveSlow:
	; When the player gets close, spring out
	call Act_Springer_IsPlNear
	jp   c, Act_Springer_SwitchToSpring
	
	; Move forward, turning when a solid block is ahead
	call ActS_ApplySpeedFwdXColi
	jp   nc, ActS_IncRtnId
	; Also turn if there's no ground ahead
	call ActS_GetBlockIdFwdGround
	jp   c, ActS_IncRtnId
	
	; If the player is at the same vertical position than us, switch to moving fast
	call ActS_GetPlDistanceY
	and  a						; DistanceY != 0?
	ret  nz						; If so, return
	ld   bc, $0200				; Otherwise, move fast at 2px/frame
	call ActS_SetSpeedX
	ld   a, ACTRTN_SPRINGER_MOVEFAST
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Springer_TurnSlow ===============
Act_Springer_TurnSlow:
	; Turn horizontally
	ldh  a, [hActCur+iActSprMap]
	xor  ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	; Loop back to Act_Springer_MoveSlow
	jp   ActS_DecRtnId
	
; =============== Act_Springer_MoveFast ===============
; Horizontal movement, fast speed.
; This is identical to Act_Springer_MoveSlow, minus the check at the end.
Act_Springer_MoveFast:
	; When the player gets close, spring out
	call Act_Springer_IsPlNear
	jp   c, Act_Springer_SwitchToSpring
	
	; Move forward, turning when a solid block is ahead
	call ActS_ApplySpeedFwdXColi
	jp   nc, ActS_IncRtnId
	; Also turn if there's no ground ahead
	call ActS_GetBlockIdFwdGround
	jp   c, ActS_IncRtnId
	
	; If the player is no longer at the same vertical position than us, switch to moving slow
	call ActS_GetPlDistanceY
	and  a						; DistanceY == 0?
	ret  z						; If so, return
	ld   bc, $0040				; Otherwise, move slow at 0.25px/frame
	call ActS_SetSpeedX
	ld   a, ACTRTN_SPRINGER_MOVESLOW
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Springer_TurnFast ===============
; Identical to Act_Springer_TurnSlow.
Act_Springer_TurnFast:
	ldh  a, [hActCur+iActSprMap]
	xor  ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	jp   ActS_DecRtnId
	
; =============== Act_Springer_InitSpring ===============
; Sets up the spring out effect, shown when the player gets close.
Act_Springer_InitSpring:
	; Spring out for 32 * 8 frames in total
	ld   a, $20	; 32 frames of animation (looped from the 4th)
	ldh  [hActCur+iSpringerAnimTimer], a
	ld   a, $08	; Each sprite shown for 8 frames
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Springer_Spring ===============
Act_Springer_Spring:

	; Do the animation cycle for the jack-o-box spring effect.
	; Even though it may not look like, the actor's collision box stays the same.
	
	; Uses frames $01-$04...
	ldh  a, [hActCur+iSpringerAnimTimer]
	and  $03
	inc  a
	ld   [wActCurSprMapBaseId], a
	
	; ...at 1/8 speed
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	ld   a, $08	
	ldh  [hActCur+iActTimer0C], a
	
	; If we've gone through the entire animation (all 32 frames), return to whatever we were doing before.
	; If the player is still nearby, it will instantly return to this routine, making the effect seem continuous.
	ldh  a, [hActCur+iSpringerAnimTimer]
	dec  a									; Timer--
	ldh  [hActCur+iSpringerAnimTimer], a	; Timer == 0?
	ret  nz									; If not, return
	ldh  a, [hActCur+iSpringerRtnBak]		; Otherwise, restore timer
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Springer_SwitchToSpring ===============
; Makes the enemy spring out, interrupting whatever routine the enemy was in.
Act_Springer_SwitchToSpring:
	; Keep track for restoring it later
	ldh  a, [hActCur+iActRtnId]
	ldh  [hActCur+iSpringerRtnBak], a
	
	ld   a, ACTRTN_SPRINGER_INITSPRING
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Springer_IsPlNear ===============
; Checks if the player is near.
; OUT
; - C Flag: If set, the player is near
Act_Springer_IsPlNear:
	call ActS_GetPlDistanceX
	cp   $07					; Player within 7 pixels horizontally?
	ret  nc						; If not, return (C Flag = No)
	call ActS_GetPlDistanceY	
	cp   $07					; Player within 7 pixels vertically?
	ret							; C Flag = It is
	
; =============== Act_PieroBotGear ===============
; ID: ACT_PIEROGEAR
; Pierobot's Gear, what actually spawns Pierobot.
Act_PieroBotGear:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_PieroBotGear_Init
	dw Act_PieroBotGear_AirNoBot
	dw Act_PieroBotGear_AirBot
	dw Act_PieroBotGear_FallV
	dw Act_PieroBotGear_MoveH
	dw Act_PieroBotGear_TurnH
	
	
	DEF PIEROGEAR_FV EQU $17 ; Gear high, for relative positioning
	DEF ACTRTN_PIEROBOT_ONGEAR = $03
	DEF ACTRTN_PIEROBOT_GEARGONE = $04

; =============== Act_PieroBotGear_Init ===============
Act_PieroBotGear_Init:
	; For animating the cog, use frames $00-$01, at 1/8 speed.
	; This will be consistently done every routine.
	ld   c, $01
	call ActS_Anim2
	
	xor  a
	ldh  [hActCur+iPieroGearBotDead], a
	
	; Set Pierobot spawn delay
	ld   a, $40
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_PieroBotGear_AirNoBot ===============
; Gear in the air, no Pierobot.
Act_PieroBotGear_AirNoBot:
	;
	; Wait for ~1 second animating the gear by itself.
	; Note this doesn't call Act_PieroBotGear_ChkCommon, making it impossible to actually destroy
	; the gear due to the +$10 offset. iPieroGearBotDead would need to be initially set to $FF for
	; that to work, since it hasn't spawned yet.
	;
	ld   c, $01
	call ActS_Anim2
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	;
	; Spawn Pierobot and set its properties up.
	; Once that's done, the two actors will have a 2-way link enabling to pass each other state.
	; Unlike other actors, no global variables are involved, since more can be onscreen at once.
	;
	ld   a, ACT_PIEROBOT
	ld   bc, ($00 << 8)|LOW(-$10) ; Basically $0000 because the Y position gets overwritten later
	call ActS_SpawnRel
	
	;
	; The first thing Pierobot will do is falling on top of the gear from offscreen.
	; To do so, its Y position needs to be reset to $00.
	;
	ld   a, l
	ldh  [hActCur+iPieroGearBotSlotPtr], a		; Also save the slot pointer for the bot, as part of the link
	add  iActY
	ld   l, a
	;--
	; [POI] Pointless, will be overwritten soon.
	ld   a, h
	ldh  [hActCur+iPieroGearBotDead], a
	;--
	xor  a
	ld   [hl], a ; iActY = $00
	
	;
	; Pierobot does not check for actor collision with the gear, as that would be slow.
	; Instead, calculate the target Y position where it should stop moving,
	; which is much faster and more accurate, given proper collision heights:
	; iPieroBotTargetY = iActY - $17
	;
	ld   a, iPieroBotTargetY-iActY		; Seek to iPieroBotTargetY
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldh  a, [hActCur+iActY]				; Get gear's y position (bottom)
	sub  PIEROGEAR_FV					; -= height (top)
	ldi  [hl], a						; Set as target pos
	
	; Just as we know the bot's slot pointer, it should know ours.
	; This enables it to determine if the gear still exists, and if so, drop down.
	ld   a, [wActCurSlotPtr]
	ldi  [hl], a ; iPieroBotGearSlotPtr
	
	;--
	; [POI] This is never written to again, see its only use.
	xor  a
	ld   [hl], a ; iPieroBot0F
	;--
	
	; The bot also notifies us when it dies
	ldh  [hActCur+iPieroGearBotDead], a
	
	; Set next delay 
	ld   a, $80
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_PieroBotGear_AirBot ===============
; Gear in the air, Pierobot jumping on it.
Act_PieroBotGear_AirBot:
	; Wait for ~2 seconds before dropping the gear.
	call Act_PieroBotGear_ChkCommon
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Pierobot is currently jumping on the gear, notify him to also drop.
	; This is perfectly timed with the end of one of Pierobot's jumps, making
	; it look like that jump caused the gear to fall off.
	
	; If he has died already, don't bother (but still make the gear drop)
	ldh  a, [hActCur+iPieroGearBotDead]
	and  a
	jp   nz, ActS_IncRtnId
	
	; Set the bot's routine
	ldh  a, [hActCur+iPieroGearBotSlotPtr]
	ld   l, a
	ld   h, HIGH(wAct)
	inc  hl ; iActRtnId
	ld   [hl], ACTRTN_PIEROBOT_ONGEAR
	
	; This should have been done before checking for iPieroGearBotDead
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	
	jp   ActS_IncRtnId
	
; =============== Act_PieroBotGear_FallV ===============
; Drop the gear until it touches the ground.
Act_PieroBotGear_FallV:
	call Act_PieroBotGear_ChkCommon
	call Act_PieroBotGear_ChkOffscreenV
	
	; Apply gravity until we touch a solid block, then roll towards the player at 0.75px/frame
	call ActS_ApplySpeedDownYColi
	ret  c
	call ActS_FacePl
	ld   bc, $00C0
	call ActS_SetSpeedX
	
	jp   ActS_IncRtnId
	
; =============== Act_PieroBotGear_MoveH ===============
; Gear rolls forward.
Act_PieroBotGear_MoveH:
	call Act_PieroBotGear_ChkCommon
	
	;
	; Move forward at 0.75px/frame, turn around if a solid wall is ahead
	;
	call ActS_ApplySpeedFwdXColi	; Solid wall hit?
	jp   nc, ActS_IncRtnId			; If so, advance to Act_PieroBotGear_TurnH
	
	;
	; If there's no ground below, start falling 
	;
	call ActS_GetGroundColi
	ld   a, [wColiGround]
	cp   %11					; No ground below on either block?
	ret  nz						; If not, return
								; Otherwise...
								
	; Give an extra push of 1 pixels forward
	ld   bc, $0100
	call ActS_SetSpeedX
	call ActS_ApplySpeedFwdXColi
	
	; Prepare gravity for falling down
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	
	jp   ActS_DecRtnId			; Return back to Act_PieroBotGear_FallV
	
; =============== Act_PieroBotGear_TurnH ===============
; Makes the gear turn horizontally.
Act_PieroBotGear_TurnH:
	call Act_PieroBotGear_ChkCommon
	call Act_PieroBotGear_ChkOffscreenH
	
	ldh  a, [hActCur+iActSprMap]
	xor  ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	
	jp   ActS_DecRtnId
	
; =============== Act_PieroBotGear_ChkCommon ===============
; Performs common actions on each routine.
Act_PieroBotGear_ChkCommon:
	; Animate the gear as normal
	ld   c, $01
	call ActS_Anim2
	
	;
	; When the gear explodes, notify Pierobot that we've died.
	; This will make the latter fall off the screen, as his "ground" was taken away.
	;
	call ActS_ChkExplodeNoChild		; Handle death
	ret  nc							; Gear exploded? If not, return
	
	; As the gear died, no more of that actor code should run when we return.
	; We're inside a subroutine though, so pop out the return value to return directly to ActS_Do.
	pop  hl
	
	; Don't notify Pierobot if he died already
	ldh  a, [hActCur+iPieroGearBotDead]
	and  a
	ret  nz
	
	; Otherwise, make Pierobot fall down by directly adjusting his routine
	ldh  a, [hActCur+iPieroGearBotSlotPtr]
	ld   l, a
	ld   h, HIGH(wAct)
	inc  hl ; iActRtnId
	ld   [hl], ACTRTN_PIEROBOT_GEARGONE
	ret
	
; =============== Act_PieroBotGear_ChkOffscreenV ===============
; Checks the gear went offscreen to the bottom.
; Because of the two way link, this actor needs to perform the check manually
; to make sure Pierobot gets despawned if the gear moves offscreen.
Act_PieroBotGear_ChkOffscreenV:
	ldh  a, [hActCur+iActY]
	cp   SCREEN_GAME_V+OBJ_OFFSET_Y+$0A		; iActY < $9A?
	ret  c									; If so, return
	jr   Act_PieroBotGear_Explode
	
; =============== Act_PieroBotGear_ChkOffscreenH ===============
; Like above, but with the horizontal position.
Act_PieroBotGear_ChkOffscreenH:
	ldh  a, [hActCur+iActX]
	cp   SCREEN_GAME_H+OBJ_OFFSET_X+$08		; iActY < $B0?
	ret  c									; If so, return
	; Fall-through
	
; =============== Act_PieroBotGear_Explode ===============
; Makes the gear explode, despawning Pierobot if he hasn't died already.
Act_PieroBotGear_Explode:
	; Visually explode the gear
	call ActS_Explode
	; Force return to the actor loop when returning.
	pop  hl
	
	; If Pierobot hasn't died yet, instantly despawn it.
	ldh  a, [hActCur+iPieroGearBotDead]
	and  a									; Died yet?
	ret  nz									; If so, return
	ldh  a, [hActCur+iPieroGearBotSlotPtr]
	ld   l, a								; Seek HL to the bot's iActId
	ld   h, HIGH(wAct)
	ld   [hl], $00 ; iActId					; Despawn
	ret
	
; =============== Act_PieroBot ===============
; ID: ACT_PIEROBOT
; Jester, hopping on the gear and rolling on it.
Act_PieroBot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_PieroBot_Init
	dw Act_PieroBot_JumpD
	dw Act_PieroBot_JumpU
	dw Act_PieroBot_OnGear
	dw Act_PieroBot_InitGearGone
	dw Act_PieroBot_GearGone

; =============== Act_PieroBot_Init ===============
Act_PieroBot_Init:
	call Act_PieroBot_ChkCommon
	; Initialize gravity
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_PieroBot_JumpD ===============
; Part of the jumping loop, post-peak.
; This comes first because we first drop from offscreen.
; Pierobot will continuously jump on the gear until the gear forces our routine to Act_PieroBot_OnGear.
Act_PieroBot_JumpD:
	call Act_PieroBot_ChkCommon
	
	;
	; Apply gravity while moving down until we reach the target Y position (top of the gear)
	;
	call ActS_ApplySpeedDownY
	ldh  a, [hActCur+iPieroBotTargetY]	; A = GearY
	ld   hl, hActCur+iActY				; HL = Ptr to BotY
	cp   [hl]							; GearY >= BotY?
	ret  nc								; If so, return (we're still above the gear)
	ld   [hl], a						; Otherwise, align to target
	ld   bc, $0200						; And set up jump at 2px/frame
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_PieroBot ===============
; Part of the jumping loop, pre-peak.
Act_PieroBot_JumpU:
	call Act_PieroBot_ChkCommon
	; Apply gravity while moving up until we reach the peak
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_DecRtnId
	
; =============== Act_PieroBot_OnGear ===============
; Main routine, rolling on the gear.
Act_PieroBot_OnGear:
	call Act_PieroBot_ChkCommon
	
	;
	; Force Pierobot to stay on top of the gear, perfectly centered on it.
	; This is the routine run when the gear rolls, execution will stay indefinitely
	; here until said gear dies, which forces our routine to Act_PieroBot_InitGearGone.
	;
	
	; HL = Ptr to gear's X position
	ldh  a, [hActCur+iPieroBotGearSlotPtr]
	add  iActX
	ld   l, a
	ld   h, HIGH(wAct)
	
	; X Position = Gear X (center)
	ldi  a, [hl]
	ldh  [hActCur+iActX], a
	inc  hl ; iActY
	
	; Y Position = Gear Y - $17 (top)
	ld   a, [hl]				; Get gear's iActY
	sub  PIEROGEAR_FV			; Move to top of gear
	ldh  [hActCur+iActY], a		; Stand on that
	ret
	
; =============== Act_PieroBot_InitGearGone ===============
; Sets up vertical gravity after the gear dies.
Act_PieroBot_InitGearGone:
	call Act_PieroBot_ChkCommon
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_PieroBot_GearGone ===============
Act_PieroBot_GearGone:
	; When the gear is gone, make Pierobot fall off until he gets offscreened below.
	; Don't even let solid blocks stop his movement.
	call Act_PieroBot_ChkCommon
	call ActS_ApplySpeedDownY
	ret
	
; =============== Act_PieroBot_ChkCommon ===============
; Performs common actions on each routine.
; See also: Act_PieroBotGear_ChkCommon
Act_PieroBot_ChkCommon:
	; Animate hopping, use frames $00-$01 at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	
	;
	; When Pierobot explodes, notify the gear that we've died.
	; This prevents the gear from attempting to notify a despawned actor.
	;
	call ActS_ChkExplodeNoChild		; Handle death
	ret  nc							; Gear exploded? If not, return
	
	; Return to actor loop
	pop  bc
	
	;--
	; [POI] iPieroBot0F is always zero, and the check is a copy/paste from Act_PieroBotGear_ChkCommon.
	ldh  a, [hActCur+iPieroBot0F]
	and  a
	ret  nz
	;--
	
	; Notify the gear
	ldh  a, [hActCur+iPieroBotGearSlotPtr]	; Seek HL to the gear's iPieroGearBotDead
	add  iPieroGearBotDead
	ld   l, a
	ld   h, HIGH(wAct)
	ld   [hl], $FF							; Flag with nonzero value
	ret
	
; =============== Act_Mole ===============
; ID: ACT_MOLE
; Small enemy that drills into the ground vertically.
; Spawned by Act_MoleSpawner.
Act_Mole:;I
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw L025891
	dw Act_Mole_DigBorder
	dw Act_Mole_DigSolid0
	dw Act_Mole_DigOut
	dw Act_Mole_DigAir
	dw Act_Mole_DigIn
	dw Act_Mole_DigSolid1

; =============== Act_Mole_Init ===============
L025891:
	;
	; Randomize the horizontal position of the mole.
	; The spawner has already randomized the vertical position but not the horizontal
	; once, since for the latter not all positions are accepted.
	;
	; This means that, currently, its X position is the same as the spawner's.
	; Offset that by a random value:
	; iActX += (Rand() * 5 / 16 - 2) * 16
	;
	
	call Rand	; Rand() will be a "subpixel" value
	ld   l, a	; HL = DE = Rand()
	ld   e, a
	xor  a
	ld   h, a
	ld   d, a
	add  hl, hl	; HL *= 2 (*2)
	add  hl, hl	; HL *= 2 (*4)
	add  hl, de ; HL += DE (*5)
	ld   a, h	; A = H - 2
	sub  $02
	add  a		; A *= 2 (*2)
	add  a		; A *= 2 (*4)
	add  a		; A *= 2 (*8)
	add  a		; A *= 2 (*16)
	
	ld   hl, hActCur+iActX	; HL = Ptr to iActX
	add  [hl]				; Add it to the offset
	ld   [hl], a			; Save back
	
	; If the mole would spawn too close to the player, try again next time.
	; When that happens, this can make the mole visibly move around.
	call ActS_GetPlDistanceX
	cp   $10
	ret  c
	
	; Otherwise, we can start moving fast, 2px/frame (see below)
	ld   bc, $0200
	call ActS_SetSpeedY
	
	ld   a, $02
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Mole_DigBorder ===============
; First in a series of *sequential* routines that handle movement.
;
; It goes like this:
; - Dig fast through the empty border area
; - Dig fast through the ground
; - Slowly dig out of the ground
; - Move a bit faster when out
; - Slowly dig into the ground
; - Dig fast through the ground, into the offscreen
;
; As these are sequential, it can only handle the presence of a single tunnel,
; if there were a second one it'd be treated like solid ground.
Act_Mole_DigBorder:
	; Move at 2px/frame when not fully inside a block after spawning.
	; This is mainly here to account for the offscreen area being treated as blank space,
	; which would cause the second mode to end earlier than intended.
	call Act_Mole_ChkCommon
	and  a					; A == 0? (U solid, D solid)
	ret  nz					; If not, wait
	jp   ActS_IncRtnId
	
; =============== Act_Mole_DigSolid0 ===============
Act_Mole_DigSolid0:
	; Move at 2px/frame when inside a solid block, until we find an empty one either up or down
	call Act_Mole_ChkCommon
	and  a					; A == 0? (U solid, D solid)
	ret  z					; If so, wait

	ld   bc, $0020
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_Mole_DigOut ===============
Act_Mole_DigOut:
	; Move at 0.125px/frame when digging out of the ground, until we're fully outside
	call Act_Mole_ChkCommon
	cp   %11				; A == 3? (U blank, D blank)
	ret  nz					; If not, wait
	
	ld   bc, $0080
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_Mole_DigAir ===============
Act_Mole_DigAir:
	; Move at 0.5px/frame when moving in the air, until we find a solid block above or below
	call Act_Mole_ChkCommon
	cp   %11				; A == 3? (U blank, D blank)
	ret  z					; If so, wait
	
	ld   bc, $0020
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_Mole_DigIn ===============
Act_Mole_DigIn:
	; Move at 0.125px/frame when digging into the ground, until we're fully inside
	call Act_Mole_ChkCommon
	and  a					; A == 0? (U solid, D solid)
	ret  nz					; If not, wait

	ld   bc, $0200
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_Mole_DigSolid1 ===============
Act_Mole_DigSolid1:
	; Move at 2px/frame when inside a solid block, until we get offscreened
	call ActS_ApplySpeedFwdY
	ret
	
; =============== Act_Mole_ChkCommon ===============
; Performs common actions when moving.
; OUT
; - A: Collision Flags
;      ------UD
;      U - If set, the block above is not solid
;      D - If set, the block below is not solid
; - Z Flag: If set, the animation has advanced
Act_Mole_ChkCommon:
	; Set base sprite for animation (digging up or down)
	ldh  a, [hActCur+iMoleSprMapBaseId]
	ld   [wActCurSprMapBaseId], a
	
	; Move vertically by the specified speed
	call ActS_ApplySpeedFwdY
	
	;--
	;
	; Check for collision on both the top and bottom of the actor's bounding box,
	; storing the result into A.
	;
	
	; BOTTOM SENSOR
	ldh  a, [hActCur+iActX]	; X Sensor: ActX (center)
	ld   [wTargetRelX], a
	ldh  a, [hActCur+iActY]	; Y Sensor: ActY (bottom)
	ld   [wTargetRelY], a
	call Lvl_GetBlockId		; C Flag = Is empty?
	ld   a, $00
	adc  a					; Store the result to bit0
	ld   b, a				; Put here for later
	
	; TOP SENSOR
	ld   a, [wTargetRelY]	; Y Sensor: ActY - $0E (top)
	sub  $0E
	ld   [wTargetRelY], a
	push bc
		call Lvl_GetBlockId	; C Flag = Is empty?
		ld   a, $00
		adc  a				; Store the result to bit0
		add  a				; >>1 to bit1
	pop  bc
	add  b					; Merge with other check
	;--
	
	;
	; Handle the animation manually, at 1/2 speed.
	;
	ld   hl, hActCur+iActTimer0C
	dec  [hl]				; Animation timer elapsed?
	ret  nz					; If not, return
	push af
		; There are two animations, one for digging up, the other for digging down.
		; Both are made of 2 sprites, so flip bit0 to alternate between them.
		ldh  a, [hActCur+iMoleSprMapBaseId]
		xor  $01
		ldh  [hActCur+iMoleSprMapBaseId], a
		; Flip again after 2 frames
		ld   [hl], $02		; iActTimer0C = $02
	pop  af
	ret
	
; =============== Act_MoleSpawner ===============
; ID: ACT_MOLESPAWN
; Spawns moles and sets some of their safe properties.
Act_MoleSpawner:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_MoleSpawner_Spawn
	dw Act_MoleSpawner_Wait

; =============== Act_MoleSpawner_Spawn ===============
Act_MoleSpawner_Spawn:
	; Immediately spawn a mole, without even checking if it could spawn.
	ld   a, ACT_MOLE
	ld   bc, $0000
	call ActS_SpawnRel
	
	; ~2 second delay before spawning another mole
	ld   a, $80
	ldh  [hActCur+iActTimer0C], a
	;--
	
	inc  hl ; iActRtnId
	inc  hl ; iActSprMap
	
	;
	; The mole is currently directly on top of the spawner.
	;
	; The horizontal position can't be changed here since we may have to
	; re-roll the dice in the next frame, in case we roll a position too close
	; to the player, which is not convenient to do inside the spawner.
	;
	; There are no such issues with randomizing the vertical position here, so do that.
	;
	
	; Randomize the vertical direction, without any mungling.
	call Rand		; A = Rand()
	and  ACTDIR_D	; Only keep the vertical direction flag (bit6)
	ld   b, a
		xor  [hl]		; This does nothing, iActRtnId is always 0 here
		ld   [hl], a	; Save udated directions
		
		;
		; The direction should also affect the mole's Y position, as:
		; - Moles that move up (ACTDIR_D clear, $00) should spawn on the bottom ($98)
		; - Those that move down (ACTDIR_D set, $40) should spawn on the top ($18)
		;
		; The Y position we want is quite close to the direction value we have 
		; (<< 1, then invert bit7, then offset by $18)
		;
		ld   de, iActY-iActSprMap	; Seek to Y position
		add  hl, de
	ld   a, b		; B = Vertical direction
	add  a			; << 1, to shift bit6 into bit7
	xor  (ACTDIR_D << 1) ; Invert that bit 7
	ld   b, a		; Save raw Y pos
		; Shift the spawning lines 24px below.
		; This avoids spawning the top ones off-screen and the bottom ones too high up.
		add  $18		; Y += $18 
		ld   [hl], a	; Save to iActY
		
		;
		; The mole uses two different animations depending on which direction it's travelling.
		; Both are made of 2 sprites, so toggle them through bit1.
		; $00-$01 => When digging down
		; $02-$03 => When digging up
		;
		add  hl, de 	; iActTimer0C-iActY
		inc  hl 		; iMoleSprMapBaseId
	ld   a, b		; Get base $00-$80 position
	rlca 			; bit7 to bit0
	rlca 			; bit0 to bit1
	ld   [hl], a	; Save to iMoleSprMapBaseId
	jp   ActS_IncRtnId
	
; =============== Act_MoleSpawner_Wait ===============
Act_MoleSpawner_Wait:
	; Wait those ~2 seconds before spawning another mole
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	jp   ActS_DecRtnId
	
; =============== Act_Press ===============
; ID: ACT_PRESS
; Metallic press that drops down when the player gets close.
Act_Press:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Press_Init
	dw Act_Press_WaitPl
	dw Act_Press_FallV
	dw Act_Press_MoveU
	dw Act_Press_Cooldown
	DEF ACTRTN_PRESS_WAITPL = $01

; =============== Act_Press_Init ===============
Act_Press_Init:
	; Place between two blocks
	ldh  a, [hActCur+iActX]
	add  $08
	ldh  [hActCur+iActX], a
	
	; Keep track of the spawn position as its target.
	; After the press falls down, it will slowly move back up to that point.
	ldh  a, [hActCur+iActY]
	ldh  [hActCur+iPressSpawnY], a
	
	; Initialize gravity for later
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_Press_WaitPl ===============
Act_Press_WaitPl:
	; Waits until the player gets within 2 blocks to drop
	call ActS_GetPlDistanceX
	cp   BLOCK_H*2
	ret  nc
	jp   ActS_IncRtnId
	
; =============== Act_Press_FallV ===============
Act_Press_FallV:
	; Apply gravity until we land on a solid block
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; Start slowly moving up at 0.25px/frame
	ld   bc, $0040
	call ActS_SetSpeedY
	; Clear ACTDIR_D to move up
	ldh  a, [hActCur+iActSprMap]
	and  $FF^ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	jp   ActS_IncRtnId
	
; =============== Act_Press_MoveU ===============
Act_Press_MoveU:
	; Slowly move up until we reach the original spawn position
	call ActS_ApplySpeedFwdY		; Move up
	ldh  a, [hActCur+iActY]			; B = ActY
	ld   b, a
	ldh  a, [hActCur+iPressSpawnY]	; A = TargetY
	cp   b							; ActY == TargetY?
	ret  nz							; If not, return
	
	; Wait 1.5 seconds before dropping again, that's enough for the player to pass through
	ld   a, $5A
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Press_Cooldown ===============
Act_Press_Cooldown:
	; After waiting for that...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Return to waiting for the player to get here
	ld   a, ACTRTN_PRESS_WAITPL
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Robbit ===============
; ID: ACT_ROBBIT
; Hopping rabbit throwing carrots at the player.
Act_Robbit:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Robbit_InitJump
	dw Act_Robbit_JumpU
	dw Act_Robbit_JumpD
	dw Act_Robbit_Ground
	dw Act_Robbit_Cooldown
	DEF ACTRTN_ROBBIT_INITJUMP = $00
	
; =============== Act_Robbit_InitJump ===============
Act_Robbit_InitJump:
	call ActS_FacePl		; Jump towards the player
	ld   bc, $0100			; 1px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0240			; 2.25px/frame up
	call ActS_SetSpeedY
	ld   a, $01				; Use jumping sprite
	call ActS_SetSprMapId
	jp   ActS_IncRtnId
	
; =============== Act_Robbit_JumpU ===============
; Jump, pre-peak.
Act_Robbit_JumpU:
	call ActS_ApplySpeedFwdXColi
	call ActS_ApplySpeedUpYColi
	ret  c
	; Reached the peak, start moving down
	jp   ActS_IncRtnId
	
; =============== Act_Robbit_JumpD ===============
; Jump, post-peak.
Act_Robbit_JumpD:
	call ActS_ApplySpeedFwdXColi
	call ActS_ApplySpeedDownYColi
	ret  c
	; We landed on ground.
	
	ld   a, $03						; Fire 3 carrots at the player
	ldh  [hActCur+iRobbitCarrotsLeft], a
	
	ld   a, $00						; Use standing sprite
	call ActS_SetSprMapId
	ld   a, $40						; ~1 second delay between shots, and at the start
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Robbit_Ground ===============
Act_Robbit_Ground:
	; Wait for cooldown before shooting
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Face the player every time we're about to shoot
	call ActS_FacePl
	
	ld   a, ACT_CARROT
	ld   bc, $0000
	call ActS_SpawnRel
	
	ld   hl, hActCur+iRobbitCarrotsLeft
	dec  [hl]							; # Ran out of carrots?
	ld   a, $40							; Cooldown of ~1 sec after shooting
	ldh  [hActCur+iActTimer0C], a
	ret  nz								; # If not, return
	jp   ActS_IncRtnId					; # Otherwise, wait that second before jumping
	
; =============== Act_Robbit_Cooldown ===============
Act_Robbit_Cooldown:
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	ld   a, ACTRTN_ROBBIT_INITJUMP
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_RobbitCarrot ===============
; ID: ACT_CARROT
; Carrot thrown by Act_Robbit, moves in a line.
Act_RobbitCarrot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_RobbitCarrot_Init
	dw Act_RobbitCarrot_Move

; =============== Act_RobbitCarrot_Init ===============
Act_RobbitCarrot_Init:
	; Set up the carrot's speed to target the player's current position.
	call ActS_AngleToPl
	jp   ActS_IncRtnId
	
; =============== Act_RobbitCarrot_Move ===============
Act_RobbitCarrot_Move:
	; Keep targeting that old player position.
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
; =============== Act_Cook ===============
; ID: ACT_COOK
; Running chicken, spawned by Act_CookSpawner.
Act_Cook:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Cook_Init
	dw Act_Cook_Run
	dw Act_Cook_JumpD
	dw Act_Cook_JumpU
	DEF ACTRTN_COOK_JUMPU = $03
	
; =============== Act_Cook_Init ===============
Act_Cook_Init:
	ld   bc, $0120				; Run 1.125px/frame forwards
	call ActS_SetSpeedX
	xor  a						; Init gravity
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	; Jump after around half a second
	ld   a, $20					
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Cook_Run ===============
Act_Cook_Run:
	; Animate run cycle ($00-$03, at 1/8 speed)
	ld   c, $01
	call ActS_Anim4
	; Run forward
	call ActS_ApplySpeedFwdX
	; If there's no ground below, fall down
	call ActS_GetGroundColi
	ld   a, [wColiGround]
	cp   %11
	jp   z, ActS_IncRtnId
	
	; Wait half a second before triggering a jump
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	ldh  a, [hActCur+iActSprMap]	; Reset frame and timer
	and  ACTDIR_R|ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	
	ld   bc, $0300					; Start jump at 3px/frame
	call ActS_SetSpeedY
	
	ld   a, ACTRTN_COOK_JUMPU
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Cook_JumpD ===============
; Jump, post-peak.
Act_Cook_JumpD:
	; Force jumping sprite $01
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R|ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	ld   a, $01
	ld   [wActCurSprMapBaseId], a
	
	; Continue moving forward while jumping
	call ActS_ApplySpeedFwdX
	; Move down until we touch solid ground, then return to running on the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	; Jump after around half a second of running
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_DecRtnId
	
; =============== Act_Cook_JumpU ===============
; Jump, pre-peak.
Act_Cook_JumpU:
	; Force jumping sprite $01
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R|ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	ld   a, $01
	ld   [wActCurSprMapBaseId], a
	
	; Continue moving forward while jumping
	call ActS_ApplySpeedFwdX
	; Move up until we reach the peak of the jump, then go back to Act_Cook_JumpD
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_DecRtnId
	
; =============== Act_CookSpawner ===============
; ID: ACT_COOKSPAWN
; Spawns running chickens.
Act_CookSpawner:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_CookSpawner_Spawn
	dw Act_CookSpawner_Wait

; =============== Act_CookSpawner_Spawn ===============
; Tries to immediately spawn a chicken on the right side of the screen.
; There is a cooldown of ~1 second, but that only applies if the actor could spawn,
; if that fails it will retry every frame.
Act_CookSpawner_Spawn:
	; Set the ~1 sec cooldown, only applied on success
	ld   a, $40
	ldh  [hActCur+iActTimer0C], a
	
	; If there's a chicken running around already, don't spawn a second one
	ld   a, ACT_COOK
	call ActS_CountById
	ld   a, b
	and  a
	jp   nz, ActS_IncRtnId
	
	; Spawn the chicken exclusively from the right side of the screen, close to the despawn range.
	ld   a, ACT_COOK
	ld   bc, $0000
	call ActS_SpawnRel		; Spawn directly on the spawner
	jp   c, ActS_IncRtnId	; Could it spawn? If not, don't spawn
	
	ld   a, l				; Seek to X position
	add  iActX
	ld   l, a
	ld   [hl],  SCREEN_GAME_H+OBJ_OFFSET_X+$08	; Point to off-screen right ($B0)
	
	; Spawned successfully, wait ~1 sec 
	jp   ActS_IncRtnId
	
; =============== Act_CookSpawner_Wait ===============
; Cooldown after spawning one.
Act_CookSpawner_Wait:
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	jp   ActS_DecRtnId

; =============== Act_Batton ===============
; ID: ACT_BATTON
; Bat enemy that homes in on the player, and hangs invulnerable on ceilings.
Act_Batton:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Batton_InitCeil
	dw Act_Batton_Ceil
	dw Act_Batton_ToFlight
	dw Act_Batton_Fly
	dw Act_Batton_InitFlyU
	dw Act_Batton_FlyU
	dw Act_Batton_InitCeil2
	DEF ACTRTN_BATTON_INITCEIL = $00
	
; =============== Act_Batton_InitCeil ===============
Act_Batton_InitCeil:
	; Wait 4 seconds on the ceiling, invulnerable
	ld   a, 60*4
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Batton_Ceil ===============
Act_Batton_Ceil:
	; Wait for it...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; The transition to flight anim starts with sprite $01 (and ends at $04)
	ld   a, $01
	ldh  [hActCur+iBattonFlySprMapId], a
	; Show the transition sprite for 8 frames (the bat is still invulnerable)
	ld   a, $08
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Batton_ToFlight ===============
Act_Batton_ToFlight:
	;--
	;
	; Handle the ceiling-to-flight animation.
	; When it ends, start flying immediately.
	;
	
	; Display the previously set transition sprite
	ldh  a, [hActCur+iBattonFlySprMapId]
	ld   [wActCurSprMapBaseId], a
	
	; Wait those 8 frames, and then...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	ld   a, $08								; Reset the anim timer
	ldh  [hActCur+iActTimer0C], a
	
	ldh  a, [hActCur+iBattonFlySprMapId]	; Advance through the animation
	inc  a
	ldh  [hActCur+iBattonFlySprMapId], a
	cp   $05				; Went past the last transition sprite?
	ret  nz					; If not, return (continue looping)
							; Otherwise, prepare flight mode
	;--
	
	; Target the player at half speed
	call ActS_AngleToPl
	call ActS_HalfSpdSub
	
	; Make vulnerable
	ld   b, ACTCOLI_ENEMYHIT
	call ActS_SetColiType
	
	; Advance the flight animation cycle every 8 frames (1/8 speed)
	ld   a, $08
	ldh  [hActCur+iBattonFlyAnimTimer], a
	
	; To save time, only re-check the player's position every 16 frames
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Batton_Fly ===============
Act_Batton_Fly:
	; Animate flight
	call Act_Batton_AnimFlight
	; Move towards the player
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	
	; If the player got hit by the bat, start moving straight up
	ld   a, [wActHurtSlotPtr]	; B = Actor slot that hurt the player
	ld   b, a
	ld   a, [wActCurSlotPtr]	; A = Current actor slot
	cp   b						; Do they match?
	jp   z, ActS_IncRtnId		; If so, advance to Act_Batton_InitFlyU
	
	; Otherwise, adjust the target speed every 16 frames.
	; This is often enough to smoothly home in towards the player, but not too often
	; that we waste time every frame (especially with multiple bats on screen)
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	call ActS_AngleToPl			; Target the player at half speed
	call ActS_HalfSpdSub		; still at half speed
	ld   a, $10					; Perform next update 16 frames later
	ldh  [hActCur+iActTimer0C], a
	ret
	
; =============== Act_Batton_InitFlyU ===============
Act_Batton_InitFlyU:
	; Fly straight up at 0.5px/frame, which is faster than the normal movement
	ldh  a, [hActCur+iActSprMap]
	and  $FF^ACTDIR_D				; Clear down flag, to move up
	ldh  [hActCur+iActSprMap], a
	ld   bc, $0080
	call ActS_SetSpeedY
	
	; Reset flight anim cycle
	ld   a, $08
	ldh  [hActCur+iBattonFlyAnimTimer], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Batton_FlyU ===============
Act_Batton_FlyU:
	; Animate flight
	call Act_Batton_AnimFlight
	
	;
	; Fly up until we either reach a solid block, the top of the room, or the white leaves.
	; When we do so, immediately start clinging without any transition animation.
	;
	call ActS_ApplySpeedFwdYColi	; Move upwards at 0.5px/frame
	; SOLID CHECK
	jp   nc, ActS_IncRtnId			; Solid block above? If so, start clinging
	
	; SCREEN TOP CHECK
	ldh  a, [hActCur+iActY]		; Y Sensor: ActY - $08 (low)
	sub  $08
	ld   [wTargetRelY], a
	and  $F0					; Check row ranges
	cp   $10					; In 2nd row? (A >= $10 && A <= $1F)
	jp   z, ActS_IncRtnId		; If so, start clinging
	
	; WHITE LEAF BLOCK CHECK
	; These are otherwise empty blocks the player can pass through, which only make sense on Wood Man's stage.
	ldh  a, [hActCur+iActX]		; X Sensor: ActX (center)
	ld   [wTargetRelX], a
	call Lvl_GetBlockId			; A = Block ID at that location
	cp   BLOCKID_WLEAF			; Check the three blocks...
	jp   z, ActS_IncRtnId
	cp   BLOCKID_WLEAFL
	jp   z, ActS_IncRtnId
	cp   BLOCKID_WLEAFR
	jp   z, ActS_IncRtnId
	
	; If all checks failed, keep moving up
	ret
	
; =============== Act_Batton_InitCeil2 ===============
; Performs pre-cling cleanup Act_Batton_InitCeil didn't need to do when it spawned.
Act_Batton_InitCeil2:
	; Make invulnerable
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType
	; Init the rest of the clinging bit
	ld   a, ACTRTN_BATTON_INITCEIL
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Batton_AnimFlight ===============
; Handles the flight animation.
; This uses sprites $05-$07 at 1/8 speed-
Act_Batton_AnimFlight:
	ldh  a, [hActCur+iBattonFlySprMapId]	; Set current sprite
	ld   [wActCurSprMapBaseId], a
	
	ld   hl, hActCur+iBattonFlyAnimTimer
	dec  [hl]								; Timer--, has it elapsed?
	ret  nz									; If not, return
	ld   [hl], $08							; Set next delay
	ldh  a, [hActCur+iBattonFlySprMapId]	; Advance animation
	inc  a
	ldh  [hActCur+iBattonFlySprMapId], a
	cp   $08								; Went past the last sprite?
	ret  nz									; If not, return
	ld   a, $05								; Otherwise, wrap around
	ldh  [hActCur+iBattonFlySprMapId], a
	ret
	
; =============== Act_Friender ===============
; ID: ACT_FRIENDER
; Giant dog miniboss in Wood Man's stage.
Act_Friender:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Friender_Init
	dw Act_Friender_PreFire
	dw Act_Friender_Fire
	dw Act_Friender_FireCooldown
	dw Act_Friende_WaitNoAnim
	dw Act_Friender_WaitAnim
	DEF ACTRTN_FRIENDER_PREFIRE = $01
	
; =============== Act_Friender_Init ===============
Act_Friender_Init:
	; Draw the tilemap for the miniboss.
	call Act_BGBoss_ReqDraw
	
	; Wait for 16 frames before firing
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Friender_PreFire ===============
; Waits for a bit before determining the amount of shots to fire.
Act_Friender_PreFire:
	; Return if dead
	call Act_Friender_ChkExplode
	ret  c
	
	; Wait for it...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Use sprite with open mouth, as that's where the flame shot comes from
	ld   a, $02
	call ActS_SetSprMapId
	
	;--
	; [POI] Randomize the amount of indivudual flames spawned.
	;       Would have spawned anywhere between 3 and 6 of them...
	call Rand	; A = Rand() % 4 + 3
	and  $03
	add  $03
	; ...but we're discarding the result for an hardcoded amount!
	; Presumably because higher values run up against the sprite limit.
	ld   a, $04
	ldh  [hActCur+iFrienderShotsLeft], a
	;--
	
	jp   ActS_IncRtnId
	
; =============== Act_Friender_Fire ===============
; Fires a single flame shot.
Act_Friender_Fire:
	call Act_Friender_ChkExplode
	ret  c
	
	ld   a, ACT_FLAME
	ld   bc, (LOW(-$10)<<8)|$00		; 10px left
	call ActS_SpawnRel
	
	; Delay the next shot by 4 frames
	ld   a, $04
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Friender_FireCooldown ===============
; Handles cooldown between shots, determines if there are more to fire.
Act_Friender_FireCooldown:
	call Act_Friender_ChkExplode
	ret  c
	; Cooldown between shots..
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; If there are still shots left, go back to Act_Friender_Fire
	ld   hl, hActCur+iFrienderShotsLeft
	dec  [hl]
	jp   nz, ActS_DecRtnId
	
	; Otherwise, stop shooting for a while.
	
	; Display sprite $00 for 16 frames
	ld   a, $00
	call ActS_SetSprMapId
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Friende_WaitNoAnim ===============
; Idle, no animation.
Act_Friende_WaitNoAnim:
	call Act_Friender_ChkExplode
	ret  c
	
	; Wait for those 16 frames...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Display the leg animation for 32 frames
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Friender_WaitAnim ===============
; Idle, leg animation.
Act_Friender_WaitAnim:
	call Act_Friender_ChkExplode
	ret  c
	
	; Leg animation, use frames $00-$01 at 1/8 speed
	; When that stops (we go back to Act_Friender_PreFire) that's the tell that the enemy is about to fire again.
	ld   c, $01
	call ActS_Anim2
	
	; Wait for those 32 frames...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Return to Act_Friender_PreFire, waiting 16 more frames before shooting
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	ld   a, ACTRTN_FRIENDER_PREFIRE
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_FrienderFlame ===============
; ID: ACT_FLAME
; Flame projectile fired by Friender.
Act_FrienderFlame:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_FrienderFlame_Init
	dw Act_FrienderFlame_Move

; =============== Act_FrienderFlame_Init ===============
Act_FrienderFlame_Init:
	; Set the shot's initial movement speed
	ldh  a, [hActCur+iActSprMap]
	or   ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	ld   bc, $01C0			; 1.75px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0300			; 3px/frame down (ACTDIR_D set)
	call ActS_SetSpeedY
	
	jp   ActS_IncRtnId
	
; =============== Act_FrienderFlame_Move ===============
Act_FrienderFlame_Move:
	; Apply the movement speed in an arc.
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	
	; Apply upwards gravity at 0.125px/frame
	ldh  a, [hActCur+iActSpdYSub]	; HL = iActSpdY*
	ld   l, a
	ldh  a, [hActCur+iActSpdY]
	ld   h, a
	ld   de, -$20					; Move $20 subpixels up
	add  hl, de
	ld   a, l						; Save back
	ldh  [hActCur+iActSpdYSub], a
	ld   a, h
	ldh  [hActCur+iActSpdY], a
	ret
	
; =============== Act_GoblinHorn ===============
; ID: ACT_GOBLINHORN
; Retractable horns that only show up when the player is standing on the goblin platform.
; Spawned by Act_Goblin.
Act_GoblinHorn:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_GoblinHorn_Init
	dw Act_GoblinHorn_MoveU
	dw Act_GoblinHorn_Idle
	dw Act_GoblinHorn_MoveD

; =============== Act_GoblinHorn_Init ===============
Act_GoblinHorn_Init:
	; Move up at 0.125px/frame
	ld   hl, hActCur+iActSprMap
	res  ACTDIRB_D, [hl]
	ld   bc, $0020
	call ActS_SetSpeedY
	; Move for ~1 second 
	ld   a, $40
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_GoblinHorn_MoveU ===============
; Horn emerges from the top of the platform.
Act_GoblinHorn_MoveU:
	; Move up at 0.125px/frame for that ~1 second (total movement: 1 block)
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Wait for ~1 second
	ld   a, $40
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_GoblinHorn_Idle ===============
; Horn is idle
Act_GoblinHorn_Idle:
	; Wait for it
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Move down at 0.5px/frame
	ld   hl, hActCur+iActSprMap
	set  ACTDIRB_D, [hl]
	ld   bc, $0080
	call ActS_SetSpeedY
	
	; Move for 16 frames 
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_GoblinHorn_MoveD ===============
; Horn retracts, then despawns.
Act_GoblinHorn_MoveD:
	; Move down at 0.5px/frame for 16 frames (total movement: half a block)
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; After that, despawn the horn.
	xor  a
	ldh  [hActCur+iActId], a
	ret
	
; =============== Act_Goblin ===============
; ID: ACT_GOBLIN
; Makes a goblin platform show up at the location it's placed on, and spawns any of its child objects.
; The only part of the goblin placed in the actor layout.
Act_Goblin:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Goblin_WaitPl
	dw Act_Goblin_SpawnPuchi
	dw Act_Goblin_SpawnHorns

; =============== Act_Goblin_WaitPl ===============
Act_Goblin_WaitPl:
	; Don't interfere with level scrolling, since showing the body involves writing event data
	ld   a, [wLvlScrollEvMode]
	and  a
	ret  nz
	
	; Don't do anything until the player gets within 4 blocks, which is far enough to not let
	; the player get inside the area where the Goblin is drawn.
	call ActS_GetPlDistanceX
	cp   BLOCK_H*4
	ret  nc
	
	; Draw the Goblin and write its blocks to the level layout
	call Act_Goblin_ShowBody
	
	; First Petit Goblin spawns on the left
	xor  a
	ldh  [hActCur+iGoblinPuchiDir], a
	
	;
	; Set the initial delays for spawning Petit Goblins and making the horns rise, respectively.
	; These are shorter than the normal delays used from the 2nd, which *especially* affect the latter.
	;
	; Unlike most other delays, these are *concurrent*.
	; From this point onward, every frame the actor will alternate between checking to spawn the Petit Goblins
	; and checking to spawn the horns on the side. Any check that fails will switch to the other routine and return.
	; That is the reason two separate timers are at play here.
	;
	
	; Wait 16 frames before doing the spawn checks (normal delay is ~1 second)
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	
	; 16 frames are significantly shorter than the normal delay of ~2 seconds (as it needs to wait for the spikes)
	; which is set from the 2nd time onwards.
	;
	; That leaves a very little window to safely jump on the platform without getting hit without stopping,
	; especially considering how far the goblin's spawn check reaches.
	ld   a, $10
	ldh  [hActCur+iGoblinRiseDelay], a
	
	; From this point onward, alternate between spawning Petit Goblins and raising/spawning horns.
	jp   ActS_IncRtnId
	
; =============== Act_Goblin_SpawnPuchi ===============
Act_Goblin_SpawnPuchi:

	; Wait before trying to spawn them.
	ldh  a, [hActCur+iActTimer0C]
	sub  $01						; Timer--
	ldh  [hActCur+iActTimer0C], a
	jp   nz, ActS_IncRtnId			; Timer > 0? If so, switch
	
	; From the 2nd time onwards, delay spawns by ~1 second
	ld   a, $40
	ldh  [hActCur+iActTimer0C], a
	
	; If the player isn't within 2 blocks, switch routines.
	; This maps to the player being in the horizontal range of the Goblin platform.
	call ActS_GetPlDistanceX
	cp   BLOCK_H*2				; DiffX >= $20?
	jp   nc, ActS_IncRtnId		; If so, switch
	
	; If there are already 3 on screen, don't spawn more
	ld   a, ACT_PUCHIGOBLIN
	call ActS_CountById
	ld   a, b
	cp   $03					; Count >= $03?
	jp   nc, ActS_IncRtnId		; If so, switch
	
	; Otherwise, spawn the Petit Goblin.
	; It will spawn directly on the center of the platform, so it will need to move horizontally out by itself.
	ld   a, ACT_PUCHIGOBLIN
	ld   bc, ($00 << 8)|LOW(-$02)	; 2px up
	call ActS_SpawnRel
	jp   c, ActS_IncRtnId
	
	; Altenate between making the Petit Goblin exit on the left and right sides
	inc  hl ; iActRtnId
	inc  hl ; iActSprMap
	
	ldh  a, [hActCur+iGoblinPuchiDir]	; Get our direction
	xor  [hl]							; Merge with iActSprMap (Could have been "or  [hl]", iActSprMap is 0)
	ld   [hl], a						; Save back to iActSprMap
	ldh  a, [hActCur+iGoblinPuchiDir]	; Flip spawn dir for next time
	xor  ACTDIR_R
	ldh  [hActCur+iGoblinPuchiDir], a
	jp   ActS_IncRtnId
	
; =============== Act_Goblin_SpawnHorns ===============
Act_Goblin_SpawnHorns:

	; Wait before trying to spawn them.
	ld   hl, hActCur+iGoblinRiseDelay
	dec  [hl]
	jp   nz, ActS_DecRtnId
	
	; From the 2nd time onwards, delay spawns by ~2 seconds
	ld   [hl], $80 ; iGoblinRiseDelay
	
	; Don't spawn the horns when the head origin is offscreen, as they'd risk wrapping around.
	ldh  a, [hActCur+iActX]
	cp   SCREEN_GAME_H+OBJ_OFFSET_X+$08
	ret  nc
	
	; LEFT HORN
	ld   a, ACT_GOBLINHORN
	ld   bc, (LOW(-$12) << 8)|LOW(-$18) ; 18px left, 24px up
	call ActS_SpawnRel			; Could it spawn?
	jp   c, ActS_DecRtnId		; If not, go back to Act_Goblin_SpawnPuchi
	
	;
	; There's a bug that shifts actors by 1 pixel when they're being scrolled to the right.
	; Normally actors should be spawned on horizontal pixel $08, the bug makes them spawn on $07.
	;
	; That's bad, as the actor's position is supposed to be consistent with the solid blocks, but
	; instead of just fixing the bug in Pl_MoveR, this actor opted to work around it with unfortunate code.
	;
	; This actor assumes the Goblin to be on the bugged $07 position.
	; The horn is 18px to the left of the Goblin, when converted to absolute, we land into
	; (7 - 18) % 8 = -3
	;
	; Meaning the horn is meant to be 3px to the left the 8x8 tile's left edge.
	; aka 5px to the right.
	;
	ld   de, iActX		; HL = Actor's X position
	add  hl, de
	ldh  a, [hScrollX]	
	and  $07			; A = Updated tile scroll offset (pixels)
	ld   b, a			;
	add  [hl]			; Add the actor's X pos
	and  $F8			; Align to tile boundary.
	sub  b				; After aligning, remove the scroll pos we added. This is the start of the tile.
	add  $05			; Add those 5 pixels
	ld   [hl], a		; Save to iActX

	
	; RIGHT HORN
	ld   a, ACT_GOBLINHORN
	ld   bc, (LOW($14) << 8)|LOW(-$18) ; 20px right, 24px up
	call ActS_SpawnRel
	jp   c, ActS_DecRtnId
	; See above, but with 3px to the right
	; (20 - 7) % 8 = 3
	ld   de, iActX
	add  hl, de
	ldh  a, [hScrollX]
	and  $07
	ld   b, a
	add  [hl]
	and  $F8
	sub  b
	add  $03
	ld   [hl], a
	
	jp   ActS_DecRtnId
	
; =============== Act_PuchiGoblin ===============
; ID: ACT_PUCHIGOBLIN
; Petit Goblin, the small flying enemies that spawn from the goblin head.
; Spawned by Act_Goblin.
Act_PuchiGoblin:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_PuchiGoblin_Init
	dw Act_PuchiGoblin_MoveOutH
	dw Act_PuchiGoblin_MoveU
	dw Act_PuchiGoblin_TrackPl

; =============== Act_PuchiGoblin_Init ===============
Act_PuchiGoblin_Init:
	; Instantly move a block away.
	; Why this wasn't done by the spawner directly?
	ld   bc, $1000
	call ActS_SetSpeedX
	call ActS_ApplySpeedFwdX
	
	; Move out 0.25px/frame from the side of the Goblin
	ld   bc, $0040
	call ActS_SetSpeedX
	
	; Do that for $40 frames; by the end it will have moved another block
	ld   a, $40
	ldh  [hActCur+iActTimer0C], a
	
	jp   ActS_IncRtnId
	
; =============== Act_PuchiGoblin_MoveOutH ===============
Act_PuchiGoblin_MoveOutH:
	; Use frames $00-$01 for animating the flight
	ld   c, $01
	call ActS_Anim2
	
	; Move forward for those $40 frames
	call ActS_ApplySpeedFwdX
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Start moving 1.25px/frame up for 32 frames (40px)
	ld   bc, $0140
	call ActS_SetSpeedY
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	
	jp   ActS_IncRtnId
	
; =============== Act_PuchiGoblin_MoveU ===============
Act_PuchiGoblin_MoveU:
	ld   c, $01
	call ActS_Anim2
	
	; Move up for those 32 frames
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; From this point, track the player's position every 16 frames
	call ActS_AngleToPl
	call ActS_HalfSpdSub	; Move at 1/4th of the speed
	call ActS_HalfSpdSub
	
	ld   a, $10				; Next tracking in
	ldh  [hActCur+iActTimer0C], a
	
	jp   ActS_IncRtnId
	
; =============== Act_PuchiGoblin_TrackPl ===============
Act_PuchiGoblin_TrackPl:
	ld   c, $01
	call ActS_Anim2
	
	; Move towards the snapshop of the player position
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	
	; Wait those 16 frames
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Take a new snapshot
	call ActS_AngleToPl
	call ActS_HalfSpdSub
	call ActS_HalfSpdSub
	; Take the next one after 16 frames
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	ret
	
; =============== Act_ScwormBase ===============
; ID: ACT_SCWORMBASE
; Small chute on the ground, lobs shots at the player.
Act_ScwormBase:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_ScwormBase_Init
	dw Act_ScwormBase_Shot
	
; =============== Act_ScwormBase_Init ===============
Act_ScwormBase_Init:
	; ~1 second cooldown between shots
	ld   a, $30
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_ScwormBase_Shot ===============
Act_ScwormBase_Shot:
	; Handle the cooldown
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	ld   a, $30						; Reset cooldown timer for next time
	ldh  [hActCur+iActTimer0C], a
	
	call ActS_GetPlDistanceX
	cp   BLOCK_H*4					; Is the player within 4 blocks?
	ret  nc							; If not, return
	
	ld   a, ACT_SCWORMSHOT
	ld   bc, ($00 << 8)|LOW(-$08) 	; Spawn shot 8px up
	call ActS_SpawnRel
	ret
	
; =============== Act_ScwormShot ===============
; ID: ACT_SCWORMSHOT
; Pipe shot lobbed by Act_ScwormBase.
Act_ScwormShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_ScwormShot_Init
	dw Act_ScwormShot_MoveOut
	dw Act_ScwormShot_JumpU
	dw Act_ScwormShot_JumpD
	dw Act_ScwormShot_Ground

; =============== Act_ScwormShot_Init ===============
Act_ScwormShot_Init:
	; Set up animation for coming out of the tube.
	; This needs its own non-looping animation mainly since the spawner is too thin to clip the normal-sized shot.
	; Use sprites $00-$02 at 1/8 speed
	ld   de, ($00 << 8)|$02
	ld   c, $08
	call ActS_InitAnimRange
	
	jp   ActS_IncRtnId
	
; =============== Act_ScwormShot_MoveOut ===============
Act_ScwormShot_MoveOut:
	; Wait until the animation has finished
	call ActS_PlayAnimRange
	ret  z
	
	;
	; Then set up the jump towards the player.
	;
	
	; HORIZONTAL SPEED
	; SpdX = ((DiffX * 4) + (Rand() % $10)) / $10
	call ActS_FacePl			; Towards the player
	call ActS_GetPlDistanceX	; A = DiffX
	ld   l, a					; HL = A
	ld   h, $00
	add  hl, hl					; HL *= 2 (*2)
	add  hl, hl					; HL *= 2 (*4)
	push hl
		call Rand				; A = Rand()
	pop  hl
	and  $0F					; A %= $10
	ld   e, a					; DE = A
	ld   d, $00
	add  hl, de					; HL += DE
	ld   a, l					; Save finalized speed
	ldh  [hActCur+iActSpdXSub], a
	ld   a, h
	ldh  [hActCur+iActSpdX], a
	
	; VERTICAL SPEED
	ld   bc, $0300			; Fixed 3px/frame
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_ScwormShot_JumpU ===============
; Jump, pre-peak.
Act_ScwormShot_JumpU:
	call Act_ScwormShot_Anim
	; Move forward during the jump, stopping if there's a solid wall in the way
	call ActS_ApplySpeedFwdXColi
	; Apply gravity while moving up until we reach the peak, including hitting the ceiling
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_ScwormShot_JumpD ===============
; Jump, post-peak.
Act_ScwormShot_JumpD:
	call Act_ScwormShot_Anim
	; Move forward during the jump, stopping if there's a solid wall in the way
	call ActS_ApplySpeedFwdXColi
	; Apply gravity while moving down until we hit the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	; Stay on the ground for ~1 second
	ld   a, $40
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_ScwormShot_Ground ===============
Act_ScwormShot_Ground:
	; Wait ~1 second animating on the ground
	call Act_ScwormShot_Anim
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; After that, despawn with a small explosion
	jp   ActS_Explode
	
; =============== Act_ScwormShot_Anim ===============
; Handles the animation cycle for the pipe.
; Uses frames $02-$03 at 1/8 speed
Act_ScwormShot_Anim:
	ldh  a, [hTimer]	; Get global timer
	rrca		; /2
	rrca		; /4
	rrca		; /8
	and  $01	; Animation is 2 frames long
	add  $02	; From $02
	ld   [wActCurSprMapBaseId], a
	ret
	
; =============== Act_Matasaburo ===============
; ID: ACT_MATASABURO
; Large enemy that blows the player away.
Act_Matasaburo:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Matasaburo_Init
	dw Act_Matasaburo_Blow0
	dw Act_Matasaburo_Blow1

; =============== Act_Matasaburo_Init ===============
Act_Matasaburo_Init:
	; Stay in the next routine for ~1 second 
	ld   a, $40
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Matasaburo_Blow0 ===============
Act_Matasaburo_Blow0:
	;
	; Try to blow the player to backwards.
	;
	
	call ActS_GetPlDistanceX
	; As this actor can only face left, blow the player only if he's on the left side.
	jr   c, .anim			; Player is on the right? If so, skip
	; Don't blow away if too far away
	cp   BLOCK_H*6			; DiffX >= $60?			
	jr   nc, .anim			; If so, jump
	; Checks passed, push player left at 0.5px/frame
	ld   a, $00
	ld   bc, $0080
	call Pl_SetSpeedByActDir
	
.anim:
	;
	; Animate the fan (using sprites $00-$01)
	; wActCurSprMapBaseId = (hTimer / 4) % 2
	;
	ldh  a, [hTimer]
	rrca 
	rrca 
	and  $01
	ld   [wActCurSprMapBaseId], a
	
	; After ~1 second, switch to the next mode
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; 16 frames in the next mode
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Matasaburo_Blow1 ===============
; Nearly identical to Act_Matasaburo_Blow0 except for the sprites used in the animation.
Act_Matasaburo_Blow1:
	;
	; Try to blow the player to backwards.
	;
	
	call ActS_GetPlDistanceX
	; As this actor can only face left, blow the player only if he's on the left side.
	jr   c, .anim			; Player is on the right? If so, skip
	; Don't blow away if too far away
	cp   BLOCK_H*6			; DiffX >= $60?			
	jr   nc, .anim			; If so, jump
	; Checks passed, push player left at 0.5px/frame
	ld   a, $00
	ld   bc, $0080
	call Pl_SetSpeedByActDir
	
.anim:
	;
	; Animate the fan (using sprites $02-$03)
	; These have the enemy hold their arms up.
	; wActCurSprMapBaseId = (hTimer / 4) % 2 + 2
	;
	ldh  a, [hTimer]
	rrca 
	rrca 
	and  $01
	add  $02
	ld   [wActCurSprMapBaseId], a
	
	; After 16 frames, switch to the previous mode
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; ~1 second, consistent with the init routine
	ld   a, $40
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_DecRtnId

; =============== Act_KaminariGoro ===============
; ID: ACT_KAMINARIGORO
; Enemy throwing lightning bolts on a rotating cloud platform.
; Spawned by the aforemented cloud platform (Act_KaminariCloud).
Act_KaminariGoro:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_KaminariGoro_Init
	dw Act_KaminariGoro_Move
	dw Act_KaminariGoro_Throw
	DEF ACTRTN_KAMINARIGORO_MOVE = $01

; =============== Act_KaminariGoro_Init ===============
Act_KaminariGoro_Init:
	;--
	; [POI] This doesn't matter because this actor's position is relative to the cloud
	ld   a, ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	;--
	
	; Wait ~2 seconds before throwing a lightning bolt.
	ld   a, $80
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_KaminariGoro_Move ===============
; Movement - holding lightning bolt.
Act_KaminariGoro_Move:
	; Use frames $00-$01 at 1/8 speed.
	; In this animation, the lightning bolt is being held and is baked in the sprites.
	; Note that $80 frames at 1/8 speed means it will end at frame ($80 / 8) % 2 = 0
	ld   c, $01
	call ActS_Anim2
	
	; Always track the player position
	call Act_KaminariGoro_SyncPos
	call ActS_FacePl
	
	; Wait for those ~2 seconds before throwing
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	;
	; Set up throw animation, which is handled in the next routine.
	;
	
	; Display the throw sprite ($02) for 16 frames
	; [BUG] This forgets to reset the relative sprite ID, which could have offset the sprite ID by $01.
	;       Thankfully, due to the animation length and speed used (($80 * 1/8) % 2 => 0) that offset 
	;       will always be $00,  but altering the throw timing will make the bug show up.
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	
	; Spawn the lightning bolt.
	; As it is being thrown from the hand, it should be spawned around there.
	; The spawn position is set to be 8px above and 8px in front of the actor's origin,
	; but for convenience the latter is set in the newly spawned actor's init code, so it's $00 for now.
	ld   a, ACT_KAMINARI
	ld   bc, ($00 << 8)|LOW(-$08) ; 8px up
	call ActS_SpawnRel
	
	jp   ActS_IncRtnId
	
; =============== Act_KaminariGoro_Throw ===============
; Movement - throw pose.
Act_KaminariGoro_Throw:
	; Display the throw sprite $03 for 16 frames.
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	
	; Always track the player position
	call Act_KaminariGoro_SyncPos
	
	; Wait those 16 frames
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Done, materialize a new lightning bolt
	ld   a, $80							; Throw it after ~2 seconds
	ldh  [hActCur+iActTimer0C], a
	ld   a, ACTRTN_KAMINARIGORO_MOVE	; Back to the main routine
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_KaminariGoro_SyncPos ===============
; Syncronizes the actor's position with the cloud's.
; This is useful since the cloud moves in a complex circular path.
Act_KaminariGoro_SyncPos:
	ldh  a, [hActCur+iActGoroCloudXPtr]	; Seek HL to the cloud's iActX
	ld   l, a
	ld   h, HIGH(wAct)
	
	ldi  a, [hl] ; iActX		; X Position: CloudX (center)
	ldh  [hActCur+iActX], a
	
	inc  hl ; iActYSub
	ld   a, [hl] ; iActY		; Y Position: CloudY - $10 (on top of the cloud)
	sub  $10					; Consistent with the offset set in Act_KaminariCloud_Init
	ldh  [hActCur+iActY], a
	ret
	
; =============== Act_KaminariCloud ===============
; ID: ACT_KAMINARICLOUD
; Rotating cloud platform the player can stand on.
Act_KaminariCloud:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_KaminariCloud_Init
	dw Act_KaminariCloud_Move

; =============== Act_KaminariCloud_Init ===============
Act_KaminariCloud_Init:
	; Start moving anticlockwise, from the top.
	call ActS_InitCirclePath
	ld   a, ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	
	; Spawn the child enemy on top of the cloud, which is the part that can be shot.
	ld   a, ACT_KAMINARIGORO
	ld   bc, ($00 << 8)|LOW(-$10) ; $10px up
	call ActS_SpawnRel
	
	; Share the cloud's slot pointer to the child, which it can use to sync its position.
	; To save time, it's already pointing to the X position.
	ld   de, iActGoroCloudXPtr	; HL = Seek to child iActGoroCloudXPtr
	add  hl, de
	ld   a, [wActCurSlotPtr]	; A = Low byte of ptr to cloud iActX
	add  iActX
	ld   [hl], a				; Save to iActGoroCloudXPtr
	
	jp   ActS_IncRtnId
	
; =============== Act_KaminariCloud_Move ===============
; Handles the rotation movement path.
Act_KaminariCloud_Move:
	;
	; Animate the propeller under the cloud.
	; Use sprites $00-$01 at 1/4 speed.
	;
	ldh  a, [hTimer]
	rrca ; /2			; Every 4 frames...
	rrca ; /4
	and  $01			; Alternate between $00 and $01
	ld   [wActCurSprMapBaseId], a
	
	;
	; Continue moving on the large circle path, at half speed.
	; ActS_ApplyCirclePath will automatically flip the cloud's direction as needed,
	; which is why it flips horizontally when it starts moving left.
	;
	ld   a, ARC_LG
	call ActS_ApplyCirclePath	; Use large path
	call ActS_HalfSpdSub		; At half speed
	call ActS_ApplySpeedFwdX	; Move the player
	call ActS_ApplySpeedFwdY
	
	;
	; If the player is standing on the cloud platform, drag him along with it.
	;
	ld   a, [wActCurSlotPtr]		; A = Our slot
	ld   b, a
	ld   a, [wActPlatColiSlotPtr]	; B = Slot the player is standing on
	cp   b							; Do they match?
	ret  nz							; If not, return
	; Otherwise, add the cloud's horizontal speed to player's, which keeps him horizontally aligned.
	; There's no need to do so for the vertical speed, as the way platform collision works accounts for it.
	ldh  a, [hActCur+iActSpdXSub]	; BC = Cloud horizontal speed
	ld   c, a
	ldh  a, [hActCur+iActSpdX]
	ld   b, a
	ldh  a, [hActCur+iActSprMap]	; A = Cloud direction
	jp   Pl_SetSpeedByActDir		; Move player by that
	
; =============== Act_Kaminari ===============
; ID: ACT_KAMINARI
; Lightning bolt projectile thrown in an arc by Act_KaminariGoro.
Act_Kaminari:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Kaminari_Init
	dw Act_Kaminari_JumpU
	dw Act_Kaminari_JumpD

; =============== Act_Kaminari_Init ===============
; Sets up the jump arc.
Act_Kaminari_Init:
	
	; Immediately move 8px towards the player.
	; Typically this places it on Kaminari Goro's hand.
	call ActS_FacePl			; Move towards player
	ld   bc, $0800				; Move 8px forward
	call ActS_SetSpeedX
	call ActS_ApplySpeedFwdX	; And apply it
	
	; Set up jump arc
	ld   bc, $0100				; 1px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0200				; 2px/frame up
	call ActS_SetSpeedY
	
	jp   ActS_IncRtnId
	
; =============== Act_Kaminari_JumpU ===============
; Jump, pre-peak.
Act_Kaminari_JumpU:
	; Flash at 1/4 speed
	ld   c, $02
	call ActS_Anim2
	; Continue the arc until we reach the peak of the jump
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedUpY
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_Kaminari_JumpD ===============
; Jump, post-peak.
Act_Kaminari_JumpD:
	; Flash at 1/4 speed
	ld   c, $02
	call ActS_Anim2
	
	; Continue the arc until we get offscreened
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedDownY
	ret
	
; =============== Act_Telly ===============
; ID: ACT_TELLY
; Floating block that homes in on the player.
Act_Telly:;I
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Telly_Init
	dw Act_Telly_Move

; =============== Act_Telly_Init ===============
Act_Telly_Init:
	
	ld   bc, $0601			; Play telly rotation animation (sprites $00-$06, at 1/8 speed)
	call ActS_AnimCustom
	
	call ActS_AngleToPl		; Take snapshot of player position
	call ActS_HalfSpdSub	; Move there at 1/4th of the speed
	call ActS_HalfSpdSub	;
	
	ld   a, $10				; Take next snapshot after 16 frames
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Telly_Move ===============
Act_Telly_Move:
	; Play telly rotation animation (sprites $00-$06, at 1/8 speed)
	ld   bc, $0601
	call ActS_AnimCustom
	
	; Move towards the player('s snapshot)
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	
	; After 16 frames pass, take a new snapshot
	ldh  a, [hActCur+iActTimer0C]
	sub  $01						; Timer--
	ldh  [hActCur+iActTimer0C], a
	ret  nz							; Timer != 0? If so, return
	call ActS_AngleToPl				; Take snapshot of player position
	call ActS_HalfSpdSub			; Move there at 1/4th of the speed
	call ActS_HalfSpdSub			;
	
	ld   a, $10						; Take next snapshot after 16 frames
	ldh  [hActCur+iActTimer0C], a
	ret
	
; =============== Act_PipiSpawner ===============
; ID: ACT_PIPISPAWN
; Spawns Act_Pipi every ~1 second to the side of the screen.
Act_PipiSpawner:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_PipiSpawner_SetWait
	dw Act_PipiSpawner_Main
	DEF ACT_PIPISPAWN_SETWAIT = $00
	
; =============== Act_PipiSpawner_SetWait ===============
Act_PipiSpawner_SetWait:
	; Wait ~1 second before trying to spawn a Pipi.
	ld   a, $40
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_PipiSpawner_Main ===============
Act_PipiSpawner_Main:
	; Wait that ~1 second
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Regardless of the checks passing or failing, wait another second before trying to spawn another
	ld   a, ACT_PIPISPAWN_SETWAIT
	ldh  [hActCur+iActRtnId], a
	
	; If there's already a Pipi on-screen, don't spawn another one.
	ld   a, ACT_PIPI
	call ActS_CountById
	ld   a, b
	and  a
	ret  nz
	
	; Spawn the Pipi directly on top of the spawner...
	ld   a, ACT_PIPI
	ld   bc, $0000
	call ActS_SpawnRel
	; ...and immediately reposition it to the side of the screen the player is looking at.
	; This is how Pipi's work, except in this game the ladder climb animation makes the player turn, which is not good.
	ld   a, l			; Seek HL to Pipi's X position
	add  iActX
	ld   l, a
	; iActX = (wPlDirH << 7) + (wPlDirH << 6)
	; This results in...
	; [DIR]         | [X POS]
	; DIR_L ($00) | $00 (offscreen left)
	; DIR_R ($01) | $C0 (offscreen right)
	ld   a, [wPlDirH]	; A = Horizontal direction  | ($00 or $01)
	rrca 				; R>>1 bit0 to bit7         | ($00 or $80)
	ld   [hl], a		; Save this initial value
	rrca 				; R>>1 bit7 to bit6         | ($00 or $40)
	add  [hl]			; Merge with previous value | ($00 or $C0)
	ld   [hl], a		; Save back
	ret
	
; =============== Act_Wily1 ===============
; ID: ACT_WILY1
; 1st phase of the Wily Machine.
Act_Wily1:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_WilyIntro
	dw Act_Wily1_InitJump
	dw Act_Wily1_JumpU
	dw Act_Wily1_JumpD
	dw Act_Wily1_WaitBomb
	dw Act_Wily1_WaitNail
	dw Act_Wily1_Turn0
	dw Act_Wily1_Turn1
	dw Act_Wily1_Turn2
	dw Act_Wily1_Turn3
	dw Act_Wily1_Turn4
	DEF ACTRTN_WILY1_INITJUMP = $01
	DEF ACTRTN_WILY1_TURN0 = $06

; =============== Act_Wily1_InitJump ===============
; Sets up the jump towards the player
Act_Wily1_InitJump:
	call Act_Wily1_ChkDeath
	call Act_Wily1_ChkPlBehind
	
	; X Speed = (DiffX * 4 / $10) px/frame
	call ActS_GetPlDistanceX
	ld   l, a
	ld   h, $00
	add  hl, hl
	add  hl, hl
	ld   a, l
	ldh  [hActCur+iActSpdXSub], a
	ld   a, h
	ldh  [hActCur+iActSpdX], a
	
	; Y Speed = 3.5px/frame
	ld   bc, $0380
	call ActS_SetSpeedY
	
	call ActS_FacePl
	
	jp   ActS_IncRtnId

; =============== Act_Wily1_JumpU ===============
; Jump, pre-peak.
Act_Wily1_JumpU:
	call Act_Wily1_ChkDeath
	
	; Use jumping sprite $01
	ld   a, $01
	ld   [wActCurSprMapBaseId], a
	; Move forward, stopping on solid walls
	call ActS_ApplySpeedFwdXColi
	; Apply gravity while moving up until we reach the peak
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_Wily1_JumpD ===============
; Jump, post-peak.
Act_Wily1_JumpD:
	call Act_Wily1_ChkDeath
	
	; Use landing sprite $00 (no separate one post-peak)
	ld   a, $00
	ld   [wActCurSprMapBaseId], a
	; Move forward, stopping on solid walls
	call ActS_ApplySpeedFwdXColi
	; Apply gravity while moving down until we hit the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; When we do, immediately spawn a bouncing bomb
	ld   a, ACT_WILY1BOMB
	ld   bc, $0000
	call ActS_SpawnRel
	
	jp   ActS_IncRtnId
	
; =============== Act_Wily1_WaitBomb ===============
Act_Wily1_WaitBomb:
	call Act_Wily1_ChkDeath
	
	; If the player is behind at any point, start turning around
	call Act_Wily1_ChkPlBehind
	
	; Wait for the bomb to despawn before...
	ld   a, ACT_WILY1BOMB
	call ActS_CountById
	ld   a, b
	and  a
	ret  nz
	
	; ...firing the nail immediately
	ld   a, ACT_WILY1NAIL
	ld   bc, $0000
	call ActS_SpawnRel
	jp   ActS_IncRtnId
	
; =============== Act_Wily1_WaitNail ===============
Act_Wily1_WaitNail:
	call Act_Wily1_ChkDeath
	
	; If the player is behind at any point, start turning around
	call Act_Wily1_ChkPlBehind
	
	; Wait for the nail to despawn before...
	ld   a, ACT_WILY1NAIL
	call ActS_CountById
	ld   a, b
	and  a
	ret  nz
	
	; ...starting another jump towards the player, looping the pattern
	ld   a, ACTRTN_WILY1_INITJUMP
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Wily1_Turn0 ===============
; The remainder of routines handle the turning animation.
; Mainly due to limitations with the default animation routines, this is handled manually.
;
; The animation uses frames $00,$02,$03 each displayed for 16 frames,
; then the actor turns and does it in reverse.
Act_Wily1_Turn0:
	call Act_Wily1_ChkDeath
	
	; Use sprite $00 for 16 frames
	ld   a, $00
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily1_Turn1 ===============
Act_Wily1_Turn1:
	call Act_Wily1_ChkDeath
	
	; Use sprite $02 for 16 frames
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily1_Turn2 ===============
Act_Wily1_Turn2:
	call Act_Wily1_ChkDeath
	
	; Use sprite $03 for 16 frames
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; The Wily Machine is now facing the camera, and it needs to continue turning.
	; Finally turn the actor at this point, then play back the animation in reverse.
	call ActS_FacePl
	
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily1_Turn3 ===============
Act_Wily1_Turn3:
	call Act_Wily1_ChkDeath
	
	; Use sprite $02 for 16 frames
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily1_Turn4 ===============
Act_Wily1_Turn4:
	call Act_Wily1_ChkDeath
	
	; Use sprite $00 for 16 frames
	ld   a, $00
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Go back to whatever we were doing before
	ldh  a, [hActCur+iWily1RtnBak]
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Wily1_ChkPlBehind ===============
; Checks if the player is behind the player and if so, it makes it turn to the other side.
; The actor return to whatever it was doing after it finishes turning.
Act_Wily1_ChkPlBehind:

	;##
	;
	; Overly complicated code to check if the player is behind us.
	;
	; This could have been done the sane way by comparing the player and actor's position,
	; then checking for the appropriate directional flag.
	;
	; Instead, it saves the directions, makes the actor face the player (which may update them)
	; and then checks if the directions are different compared to before.
	;
	
	ldh  a, [hActCur+iActSprMap]	; Save unmodified iActSprMap for later
	ld   b, a
	and  ACTDIR_R|ACTDIR_D			; Filter old directions
	ld   c, a
	
	push bc
		call ActS_FacePl			; Face the player. This may or may not modify the directions.
	pop  bc
	
	ld   hl, hActCur+iActSprMap		; Get new iActSprMap
	ld   a, [hl]
	and  ACTDIR_R|ACTDIR_D			; Filter new directions
	cp   c							; Are the new directions unchanged from the old ones?
	ld   [hl], b					; (restore original iActSprMap, as if ActS_FacePl was never called)
	ret  z							; If so, return
	;##
	
	;
	; Otherwise, it means the player is behind the Wily Machine, make it slowly turn to the other side.
	; The actor will properly turn to the player in the middle of that sequence.
	;
	
	ld   a, $10						; Show for 16 frames
	ldh  [hActCur+iActTimer0C], a
	
	ld   hl, hActCur+iActRtnId		; Seek HL to iActRtnId
	ld   a, [hl]					; A = iActRtnId
	ldh  [hActCur+iWily1RtnBak], a	; Save a backup to restore once done
	ld   [hl], ACTRTN_WILY1_TURN0
	
	; Prevent the rest of the routine from being executed.
	pop  hl
	ret
	
; =============== Act_Wily1_ChkDeath ===============
; Handles the death sequence for Wily Machine.
Act_Wily1_ChkDeath:

	;
	; The 1st and 2nd phases are specifically set to die at 7 health or less,
	; to prevent the generic death code from running.
	; Normally the threshold is set at 16, but that is way too high for boss actors,
	; which have 19 health.
	; When that happens:
	; - Spawn a large explosion
	; - Reposition the Wily Ship actor and enable it
	;
	; The explosion and Wily Ship are set to use the same position, which is specifically
	; picked to make the effect of attaching and detaching the ship look seamless.
	;
	; See also: Act_WilyCtrl
	;
	call ActS_GetHealth
	cp   $08					; Health >= $08?
	ret  nc						; If so, return
	
	ld   a, $FF					; Enable the Wily Ship
	ld   [wWilyPhaseDone], a
	
	ldh  a, [hActCur+iActY]		; Y Position: iActY - $18
	sub  $18
	ld   [wWilyShipY], a		; For Wily's ship
	ld   [wActSpawnY], a		; and the explosion
	ldh  a, [hActCur+iActX]
	
	ld   [wActSpawnX], a		; X Position: iActX
	ld   [wWilyShipX], a
	call ActS_SpawnLargeExpl
	
	ld   a, SFX_EXPLODE			; Play explosion sound
	ldh  [hSFXSet], a
	
	; Return to the actor loop
	pop  hl
	jp   ActS_Explode
	
; =============== Act_Wily2 ===============
; ID: ACT_WILY2
; 2nd phase of the Wily Machine.
Act_Wily2:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_WilyIntro
	dw Act_Wily2_InitFire
	dw Act_Wily2_Fire
	dw Act_Wily2_InitMoveFwd
	dw Act_Wily2_MoveFwd
	dw Act_Wily2_Wait
	dw Act_Wily2_MoveBak
	dw Act_Wily2_Turn
	DEF ACTRTN_WILY2_INITFIRE = $01
	DEF ACTRTN_WILY2_MOVEBAK = $06
	DEF ACTRTN_WILY2_TURN = $07

; =============== Act_Wily2_InitFire ===============
; Sets up the shooting mode.
Act_Wily2_InitFire:

	; Allow damaging the Wily Machine from the top until 12px above its center point.
	; Make everything below reflect shots.
	ld   b, -$0C
	call ActS_SetColiType
	
	call Act_Wily2_ChkDeath
	
	; Fire two shots, with a cooldown of ~half a second
	ld   a, $02
	ldh  [hActCur+iWily2ShotsLeft], a
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Wily2_Fire ===============
; Shooting mode.
Act_Wily2_Fire:
	; Use firing sprite $02
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	
	call Act_Wily2_ChkDeath
	
	; Wait for the cooldown...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Fire an energy ball forward.
	; It's set to fire towards the player, but that's handled by the shot's init code.
	ld   a, ACT_WILY2SHOT
	ld   bc, ($00 << 8)|LOW(-$08) ; 8px up
	call ActS_SpawnRel
	
	; Set cooldown for next shot
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	
	; If we fired all of them, start moving
	ld   hl, hActCur+iWily2ShotsLeft
	dec  [hl]
	ret  nz
	
	jp   ActS_IncRtnId
	
; =============== Act_Wily2_InitMoveFwd ===============
; Preparing to move forward.
Act_Wily2_InitMoveFwd:
	; Use frames $00-$01 at 1/8 speed to animate the treads.
	ld   c, $01
	call ActS_Anim2
	
	call Act_Wily2_ChkDeath
	
	; Wait for that ~half a sec of cooldown after the last shot...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Move forwards at 0.5px/frame for ~1.5 seconds
	ld   bc, $0080
	call ActS_SetSpeedX
	ld   a, $60
	ldh  [hActCur+iActTimer0C], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Wily2_MoveFwd ===============
Act_Wily2_MoveFwd:
	; Animate the treads
	ld   c, $01
	call ActS_Anim2
	
	call Act_Wily2_ChkDeath

	; Move forward for the previously set amount
	call ActS_ApplySpeedFwdX
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; At this point, we're typically waiting near the center of the screen.
	
	
	; Spawn a boucing bomb
	ld   a, ACT_WILY2BOMB
	ld   bc, $0000
	call ActS_SpawnRel
	
	; For later, set up movement at -0.5px/frame
	; We won't actually move yet, but setting it here helps out Act_Wily2_ChkPlBehind (see below)
	ld   bc, -$0080
	call ActS_SetSpeedX
	
	; Wait ~2 seconds, typically near the center of the screen
	ld   a, $80
	ldh  [hActCur+iActTimer0C], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Wily2_Wait ===============
; Waits a bit near the center of the screen, as cooldown after spawning a bomb. 
Act_Wily2_Wait:
	; *Only* check if the player has moved behind in the middle of moving backwards.
	; A consequence of this is that the turning routine doesn't need to either:
	; - Remember whatever we were doing before, since it will just skip to Act_Wily2_MoveBak
	; - Explicitly set the backwards speed, as it will always be already set to -0.5px/frame
	call Act_Wily2_ChkPlBehind
	
	call Act_Wily2_ChkDeath
	
	; Animate the treads
	ld   c, $01
	call ActS_Anim2
	
	; Wait for it...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Move back for ~1.5 seconds
	ld   a, $60
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily2_MoveBak ===============
Act_Wily2_MoveBak:
	; Animate the treads
	ld   c, $01
	call ActS_Anim2
	
	call Act_Wily2_ChkDeath
	
	; Move backwards at 0.5px/frame (for either ~1.5 or ~2 seconds, depending on how we got here)
	call ActS_ApplySpeedFwdX
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; For later, set up movement at 0.5px/frame
	ld   bc, $0080
	call ActS_SetSpeedX
	;--
	; [POI] Ignored, will be overwritten
	ld   a, $60
	ldh  [hActCur+iActTimer0C], a
	;--
	
	; Start firing shots again, looping the pattern
	ld   a, ACTRTN_WILY2_INITFIRE
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Wily2_Turn ===============
; Makes the Wily Machine turn around.
; After this is done, it will immediately move backwards, to the other side.
Act_Wily2_Turn:

	; Use turning sprite $03
	; This one actually remembers to clean up the relative sprite ID in iActSprMap.
	ld   hl, hActCur+iActSprMap
	res  3, [hl]	; with ActS_Anim2 used elsewhere, only bit3 is affected
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	
	call Act_Wily2_ChkDeath
	
	; Show the sprite for 16 frames...
	ldh  a, [hActCur+iActTimer0C]
	sub  a, $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Then turn around
	call ActS_FacePl
	
	; Move away from the player for ~2 seconds.
	; As the player might be very nearby, this is half a second longer than normal.
	ld   a, $80
	ldh  [hActCur+iActTimer0C], a
	ld   a, ACTRTN_WILY2_MOVEBAK
	ldh  [hActCur+iActRtnId], a
	ret 

; =============== Act_Wily2_ChkPlBehind ===============
; Checks if the player is behind the player and if so, it makes it turn around.
; Nearly identical to Act_Wily1_ChkPlBehind except for:
; - Swapped b/c registers
; - Only the horizontal direction is filtered
;   (as this phase only moves horizontally, but it could have been like this in the 1st phase too)
Act_Wily2_ChkPlBehind:

	;##
	;
	; Check if the player is behind us.
	;
	
	ldh  a, [hActCur+iActSprMap]	; Save unmodified iActSprMap for later
	ld   c, a
	and  ACTDIR_R					; Filter old directions
	ld   b, a
	
	push bc
		call ActS_FacePl			; Face the player. This may or may not modify the directions.
	pop  bc
	
	ld   hl, hActCur+iActSprMap		; Get new iActSprMap
	ld   a, [hl]
	and  ACTDIR_R					; Filter new directions
	cp   b							; Are the new directions unchanged from the old ones?
	ld   [hl], c					; (restore original iActSprMap, as if ActS_FacePl was never called)
	ret  z							; If so, return
	;##
	
	;
	; Otherwise, it means the player is behind the Wily Machine, make it turn around.
	;
	
	ld   a, $10						; Stay in that mode for 16 frames
	ldh  [hActCur+iActTimer0C], a
	
	ld   hl, hActCur+iActRtnId		; Seek HL to iActRtnId
	;--
	; [POI] Copypaste from Act_Wily1_ChkPlBehind that's not applicable here,
	;       as after turning we switch to an hardcoded routine.
	;       iWily1RtnBak also points to iWily2ShotsLeft here.  
	ld   a, [hl]					; A = iActRtnId
	ldh  [hActCur+iWily1RtnBak], a	; Save a backup to restore once done
	;--
	ld   [hl], ACTRTN_WILY2_TURN
	
	; Prevent the rest of the routine from being executed.
	pop  hl
	ret

; =============== Act_Wily2_ChkDeath ===============
; Handles the death sequence for Wily Machine.
; This is identical to Act_Wily1_ChkDeath, except for the Y position for the ship,
; since the 2nd phase machine is shorter than the 1st.
Act_Wily2_ChkDeath:
	call ActS_GetHealth
	cp   $08					; Health >= $08?
	ret  nc						; If so, return
	
	ld   a, $FF					; Enable the Wily Ship
	ld   [wWilyPhaseDone], a
	
	ldh  a, [hActCur+iActY]		; Y Position: iActY - $10
	sub  $10
	ld   [wWilyShipY], a		; For Wily's ship
	ld   [wActSpawnY], a		; and the explosion
	ldh  a, [hActCur+iActX]
	
	ld   [wActSpawnX], a		; X Position: iActX
	ld   [wWilyShipX], a
	call ActS_SpawnLargeExpl
	
	ld   a, SFX_EXPLODE			; Play explosion sound
	ldh  [hSFXSet], a
	
	; Return to the actor loop
	pop  hl
	jp   ActS_Explode
	
	
; =============== Act_Wily3 ===============
; ID: ACT_WILY3
; 3rd phase of the Wily Machine, visually distinct from the others.
;
; Unlike the others, it is partially drawn with BG tiles, but as they are already part 
; of the level layout, we don't need to draw those ourselves.
;
; This sprite associated to this actor is the skull that extends after attacks,
; hence why it's the only part that flashes when hit; other parts are indepentently
; animated and use their own helper actor.
Act_Wily3:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wily3_Nop
	dw Act_WilyIntro
	dw Act_Wily3_Init
	dw Act_Wily3_FireMissile
	dw Act_Wily3_FireMet
	dw Act_Wily3_WaitSkUp
	dw Act_Wily3_WaitSkDown
	DEF ACTRTN_WILY3_FIREMISSILE = $03

; =============== Act_Wily3_Nop ===============
; The Wily Machine doesn't do anything until Act_WilyCtrl_P3ScrollR sets our routine to Act_Wily3_Init.
; This is to make sure it only gets processed once it fully scrolls in.
Act_Wily3_Nop:
	ret
	
; =============== Act_Wily3_Init ===============
; Performs initialization, and sets up the delay for firing the missile.
Act_Wily3_Init:
	; Allow damaging the Wily Machine from the top until 16px above its center point.
	; Make everything below reflect shots.
	ld   b, -$10
	call ActS_SetColiType
	
	; Always face left, as that's the direction the BG tiles show
	ld   hl, hActCur+iActSprMap
	res  ACTDIRB_R, [hl]
	
	; Do not animate parts yet
	xor  a
	ldh  [hActCur+iWily3AnimPart], a
	
	; [POI] Pointless, this actor can't move as it uses BG tiles
	ld   bc, $0080
	call ActS_SetSpeedX
	
	; Wait 16 frames before firing the missile 
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Wily3_FireMissile ===============
; Fires an homing missile.
Act_Wily3_FireMissile:
	; Wait for it...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Spawn the homing missile
	ld   a, ACT_WILY3MISSILE
	ld   bc, ($00 << 8)|LOW(-$10) ; 16px up
	call ActS_SpawnRel
	
	; Raise the arm cannon forward
	ld   a, WILY3PART_SPR_ARM
	ldh  [hActCur+iWily3AnimPart], a
	
	; Cooldown of ~2 seconds before firing the Goombas
	ld   a, $80
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily3_FireMet ===============
; Fires multiple Mets.
Act_Wily3_FireMet:
	; Wait those ~2 seconds
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	;
	; Spawn four Mets at different jump arcs, which are spaced far enough that by the time
	; they reach the ground, they will have spread out across the room.
	;
	; The player will have to dodge them similarly to the falling leaves from Wood Man's fight,
	; however, unlike those these Mets continue moving horizontally, making dodging them a bit iffy.
	;
	
	ld   a, ACT_WILY3MET
	; Each one spawns at the same coordinates: 1 block right, 2 blocks up
	ld   bc, (LOW($10) << 8)|LOW(-$20)
	call ActS_SpawnRel
	; Their horizontal speed is what differs, which stays the same over time.
	; Meanwhile, their vertical speed is the same between all of them, making 
	; sure the Mets stay vertically aligned, and is also affected by gravity.
	ld   de, iActSpdXSub
	add  hl, de
	ld   [hl], LOW($0020)		; 0.125px/frame forward
	inc  hl
	ld   [hl], HIGH($0020)
	
	ld   a, ACT_WILY3MET
	ld   bc, (LOW($10) << 8)|LOW(-$20)
	call ActS_SpawnRel
	ld   de, iActSpdXSub
	add  hl, de
	ld   [hl], LOW($00E0)		; 0.875px/frame forward
	inc  hl
	ld   [hl], HIGH($00E0)
	
	ld   a, ACT_WILY3MET
	ld   bc, (LOW($10) << 8)|LOW(-$20)
	call ActS_SpawnRel
	ld   de, iActSpdXSub
	add  hl, de
	ld   [hl], LOW($0180)		; 1.5px/frame forward
	inc  hl
	ld   [hl], HIGH($0180)
	
	ld   a, ACT_WILY3MET
	ld   bc, (LOW($10) << 8)|LOW(-$20)
	call ActS_SpawnRel
	ld   de, iActSpdXSub
	add  hl, de
	ld   [hl], LOW($0220)		; 2.125px/frame forward
	inc  hl
	ld   [hl], HIGH($0220)
	
	; Raise the tail up
	ld   a, WILY3PART_SPR_TAIL
	ldh  [hActCur+iWily3AnimPart], a
	
	; Delay ~2 seconds after shooting, to wait for the Mets to have fallen offscreen
	ld   a, $80
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily3_WaitSkUp ===============
; Waits - skull retracted.
Act_Wily3_WaitSkUp:
	; Wait those ~2 seconds...
	; During this time, sprite
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Stay in the next routine for ~half a second
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily3_WaitSkDown ===============
; Waits - skull extended.
Act_Wily3_WaitSkDown:
	; Extend the skull down by using sprite $01.
	; This is only a visual effect, it does nothing at all otherwise.
	ld   a, $01
	ld   [wActCurSprMapBaseId], a
	
	; Show that for ~half a second
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Then fire the homing missile, looping the pattern.
	ld   a, $80						; Delay that by ~2 secs
	ldh  [hActCur+iActTimer0C], a
	
	ld   a, ACTRTN_WILY3_FIREMISSILE
	ldh  [hActCur+iActRtnId], a		; Loop back. Exiting this routine retracts the skull.
	ret
	
; =============== Act_WilyShip ===============
; ID: N/A (run inside ACT_WILYCTRL)
;
; Wily's Spaceship, visible between the Wily Machine phases.
;
; This actor is used to animate the top half of the Wily Machine after its body explodes,
; and is then shown flying away and seamlessly attaching itself to the top of the next one.
; 
; To make the illusion work, the spaceship visually matches with the top half of the first
; two phases of the Wily Machine, and is positioned to precisely overlap with that part
; when it attaches or detaches itself -- most noticeable with Wily's sprite, which visually
; doesn't appear to change position, even though actors teleport around.
;
; The exception to this is the 3rd phase, which is why the spaceship doesn't visually attach
; itself there.
;
; This is not used as its own actor, instead it's run under Act_WilyCtrl, which is associated
; to the Wily Spaceship sprites. The main consequence is that it shouldn't interfere with that
; actor's routine, hence why a separate iWilyShipRtnId is being used.
;
; Used at the end of both the 1st and 2nd phases, however the calling code aborts them
; at different points.
Act_WilyShip:
	ldh  a, [hActCur+iWilyShipRtnId]
	rst  $00 ; DynJump
	dw Act_WilyShip_Init
	dw Act_WilyShip_Wait
	dw Act_WilyShip_MoveU
	dw Act_WilyShip_MoveR
	dw Act_WilyShip_MoveScrollR
	dw Act_WilyShip_MoveD
	dw Act_WilyShip_Nop

; =============== Act_WilyShip_Init ===============
; Sets up the various properties.
Act_WilyShip_Init:
	; Set up propeller animation (frames $00-$01 at 1/8 speed)
	ld   a, $00				; Start from $00, regardless of wherever we are
	call ActS_SetSprMapId
	ld   c, $01
	call ActS_Anim2
	
	; Face towards the player
	call ActS_FacePl
	
	; Stand still for ~2 seconds
	ld   a, $80
	ldh  [hActCur+iActTimer0C], a
	
	; Next mode
	ld   hl, hActCur+iWilyShipRtnId
	inc  [hl]
	ret
	
; =============== Act_WilyShip_Wait ===============
; Ship stays still.
Act_WilyShip_Wait:
	; Animate propeller
	ld   c, $01
	call ActS_Anim2
	
	; Wait for those ~2 seconds...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Set up movement speed for later routines
	ld   bc, $0080			; 0.5px/frame horizontally
	call ActS_SetSpeedX
	ld   bc, $0080			; 0.5px/frame vertically
	call ActS_SetSpeedY
	
	; Move up
	ld   hl, hActCur+iActSprMap
	res  ACTDIRB_D, [hl]
	ld   hl, hActCur+iWilyShipRtnId
	inc  [hl]
	ret
	
; =============== Act_WilyShip_MoveU ===============
; Move up until reaching the top of the screen.
Act_WilyShip_MoveU:
	; Animate propeller
	ld   c, $01
	call ActS_Anim2
	
	; Move up at 0.5px/frame, until we're near the ceiling
	call ActS_ApplySpeedFwdY		; Move up
	ldh  a, [hActCur+iActY]
	cp   OBJ_OFFSET_Y+$28			; ActY != $38?
	ret  nz							; If not, return
	; Otherwise, start moving right
	ld   hl, hActCur+iActSprMap		
	set  ACTDIRB_R, [hl]
	ld   hl, hActCur+iWilyShipRtnId
	inc  [hl]
	ret
	
; =============== Act_WilyShip_MoveR ===============
; Move right, without scrolling the screen.
Act_WilyShip_MoveR:
	; Animate propeller
	ld   c, $01
	call ActS_Anim2
	
	; Move the spaceship right at 0.5px/frame until it reaches X position $90,
	; which is barely enough before it starts going offscreen, which we want to avoid.
	ldh  a, [hActCur+iActX]
	cp   SCREEN_GAME_H+OBJ_OFFSET_X-$18		; ActX < $90?
	jp   c, ActS_ApplySpeedFwdX				; If so, just move
	
	; Prepare downwards movement for later
	ld   hl, hActCur+iActSprMap
	set  ACTDIRB_D, [hl]
	
	; But continue moving while scrolling the screen for ~2 seconds more
	ld   a, $80
	ldh  [hActCur+iActTimer0C], a
	
	; Switch to the next routine.
	; If we're in the transition between the 2nd and 3rd phases, at this point
	; the caller takes over and makes the ship actually move off-screen,
	; since it's not possible to attach it to the 3rd phase machine without looking wrong.
	ld   hl, hActCur+iWilyShipRtnId
	inc  [hl]
	ret
	
; =============== Act_WilyShip_MoveScrollR ===============
; Move right, while scrolling the screen.
; First transition only.
Act_WilyShip_MoveScrollR:
	; Animate propeller
	ld   c, $01
	call ActS_Anim2
	
	;
	; Move the screen (and the actor) right 0.5px/frame.
	;
	
	; First, apply the subpixel speed as normal
	ld   hl, hActCur+iActXSub		; HL = Ptr to subpixel X
	ldh  a, [hActCur+iActSpdXSub]	; A = Subpixel speed
	add  [hl]						; Move right by that
	ld   [hl], a					; Save back
	
	; If that overflowed, instead of incrementing iActX directly, scroll the screen 1px to the right.
	; The way this works assumes movement < 1px/frame, since it should not alter iActX.
	call c, Act_WilyShip_ScrollR
	
	; Do the above for ~2 seconds
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; After that, start moving down
	ld   hl, hActCur+iActSprMap
	res  ACTDIRB_R, [hl]			; Face left
	set  ACTDIRB_D, [hl]			; Move down
	
	ld   hl, hActCur+iWilyShipRtnId
	inc  [hl]
	ret
	
; =============== Act_WilyShip_MoveD ===============
; Move down.
; First transition only.
Act_WilyShip_MoveD:
	; Animate propeller
	ld   c, $01
	call ActS_Anim2
	
	; Move down 0.5px/frame
	call ActS_ApplySpeedFwdY
	
	; Continue that until we reach the point where the body of the 2nd phase should be.
	ldh  a, [hActCur+iActY]
	cp   OBJ_OFFSET_Y+$60			; AcyY != $70?
	ret  nz							; If so, return
	
	; Switch to the next routine.
	; If we're in the transition between the 1st and 2nd phases, at this point the caller takes over.
	ld   hl, hActCur+iWilyShipRtnId
	inc  [hl]
	ret
	
; =============== Act_WilyShip_Nop ===============
; We never get here.
Act_WilyShip_Nop:
	ret
	
; =============== Act_WilyShip_ScrollR ===============
; Scrolls the screen to the right.
; IN
; - HL: Ptr to iActXSub
Act_WilyShip_ScrollR:
	; Scroll the screen to the right by 1 pixel
	push hl
		call Game_AutoScrollR_NoAct
	pop  hl
	
	;
	; If haven't reached the rightmost edge of the screen, also move 1px to the right.
	; Note that to even get here (through Act_WilyShip_MoveScrollR), iActX needs to be $90,
	; so we only get to increment it once -- then it becomes $91 and the check below always returns.
	;
	; What's the point of this? Was the requirement to get to Act_WilyShip_MoveScrollR lower than $90 at some point? 
	;
	ldh  a, [hActCur+iActX]	
	cp   SCREEN_GAME_H+OBJ_OFFSET_X-$18+1	; iActX >= $91?
	ret  nc									; If not, return
	inc  hl 			; iActXSub
	inc  [hl] 			; iActX++
	ret
	
; =============== Act_Quint ===============
; ID: ACT_QUINT
;
; Quint, the poor man's Blues.
Act_Quint:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Quint_Init
	dw Act_Quint_IntroStand
	dw Act_Quint_IntroWaitSg
	dw Act_Quint_IntroJumpU
	dw Act_Quint_JumpD
	dw Act_Quint_InitGround
	dw Act_Quint_GroundDebris
	dw Act_Quint_GroundWait
	dw Act_Quint_JumpU
	dw Act_Quint_DeadFall
	dw Act_Quint_WarpLand
	dw Act_Quint_WarpMove
	dw Act_Quint_PlWarpOut
	dw Act_Quint_EndLvl
	DEF ACTRTN_QUINT_JUMPD = $04
	DEF ACTRTN_QUINT_DEADFALL = $09
	
; =============== Act_Quint_Init ===============
Act_Quint_Init:
	; Stand on the ground (show sprite $00) for ~2 seconds
	ld   a, $80
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Quint_IntroStand ===============
; Waiting on the ground, standing.
Act_Quint_IntroStand:

	;
	; [POI] At no point does the collision box or type for Quint ever change.
	;       This makes it possible to already damage him before the intro animation even ends.
	;       It's even possible to defeat him, but he won't teleport out until the intro ends,
	;       due to Act_Quint_ChkDeath not getting called there.
	;       Since Quint doesn't ride on the Sakugarne yet, it makes its hitbox very misleading.
	;

	; Wait for it...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	;
	; After those ~2 seconds, spawn the Sakugarne, which will drop from the top of the screen.
	;
	; Note that this newly spawned actor is *only* used for this intro -- the Sakugarne shown
	; when the Quint is riding it is fully handled here.
	;
	
	; Raise both hands arms up as it falls down
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	
	; Spawn the Sakugarne...
	ld   a, ACT_QUINT_SG
	ld   bc, $0000
	call ActS_SpawnRel
	ld   de, iActX ; $05
	add  hl, de
	ld   [hl], $60		; ...at the center of the screen
	inc  hl ; iActYSub
	inc  hl ; iActY
	ld   [hl], $40		; ...directly materializing around the top of the screen, but still onscreen (why not from $00?)
	inc  de ; $06
	add  hl, de			; Seek to iQuintSgJumpOk
	ld   [hl], $00		; Initialize the signal that tells us when to jump
	; Keep track of the slot ptr to iQuintSgJumpOk (only the low byte was needed)
	ld   a, l
	ldh  [hActCur+iQuintSgJumpOkPtrLow], a
	ld   a, h
	ldh  [hActCur+iQuintSgJumpOkPtrHigh], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Quint_IntroWaitSg ===============
; Waits for the Sakugarne to reach a particular position.
Act_Quint_IntroWaitSg:
	; Keep using same sprite as before
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	
	; Wait for the Sakugarne actor to signal us when to jump
	ldh  a, [hActCur+iQuintSgJumpOkPtrLow]	; HL = Ptr to iQuintSgJumpOk
	ld   l, a
	ldh  a, [hActCur+iQuintSgJumpOkPtrHigh]
	ld   h, a
	ld   a, [hl]	; A = iQuintSgJumpOk
	and  a			; A == 0?
	ret  z			; If so, return
	
	ld   bc, $0380			; Set up high jump at 3.5px/frame
	call ActS_SetSpeedY		; This is the same vertical speed the Sakugarne jumps at
	jp   ActS_IncRtnId
	
; =============== Act_Quint_IntroJumpU ===============
; Jumps towards the Sakugarne.
Act_Quint_IntroJumpU:
	; Use normal jumping sprite
	ld   a, $04
	ld   [wActCurSprMapBaseId], a
	
	; Move up, until we reach the peak of the jump
	call ActS_ApplySpeedUpYColi
	ret  c
	; Then start falling straight down
	ld   bc, $0000
	call ActS_SetSpeedX
	
	; From now on, Quint is riding the Sakugarne.
	jp   ActS_IncRtnId
	
; =============== Act_Quint_JumpD ===============
; Jump, post-peak.
; This is the start of the boss pattern.
Act_Quint_JumpD:
	call Act_Quint_ChkDeath
	ret  c
	
	; Use sakugarne jumping sprite
	ld   a, $05
	ld   [wActCurSprMapBaseId], a
	
	; Move forward, stopping on solid walls
	call ActS_ApplySpeedFwdXColi
	; Move up, until we touch the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; Then wait 8 frames idling
	ld   a, $08
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Quint_InitGround ===============
; Idle on the ground, while riding the Sakugarne.
Act_Quint_InitGround:
	call Act_Quint_ChkDeath
	ret  c
	
	; Show sprite $06 for 8 frames
	; This already accounts for the 2-frame $05-$06 1/8 animation (see Act_Quint_GroundDebris).
	ld   a, $06
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; After that, set up the spawned debris
	ld   a, $0C								; Number of times we loop to Act_Quint_GroundDebris
	ldh  [hActCur+iQuintDebrisTimer], a
	ld   a, $08								; Cooldown between spawn attempts
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Quint_GroundDebris ===============
; Ground cycle - spawn debris.
;
; This and the next routine alternate every 8 frames, to spawn the debris multiple times between jumps.
; Another effect is in the sprites used, as this one uses $05 and the other one $06, for manually
; handling the animation of using sprites $05-$06 at 1/8 speed.
Act_Quint_GroundDebris:
	call Act_Quint_ChkDeath
	ret  c
	
	; Show sprite $05 for 8 frames.
	ld   a, $05
	ld   [wActCurSprMapBaseId], a
	; Wait those 8 frames
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Set timer for the 2nd frame of the animation.
	; Between the two cooldowns, 16 frames will pass before the next spawn check.
	ld   a, $08
	ldh  [hActCur+iActTimer0C], a
	
	;
	; Spawn the debris only if its timer is >= 6 and divisible by 2.
	; In practice, this makes it spawn the debris 4 times (at ticks $0C, $0A, $08, $06),
	; with a longer cooldown period later.
	;
	ldh  a, [hActCur+iQuintDebrisTimer]
	cp   $06					; iQuintDebrisTimer < 6?
	jp   c, ActS_IncRtnId		; If so, jump
	rrca 						; iQuintDebrisTimer % 2 != 0?
	jp   nc, ActS_IncRtnId		; If so, jump

	;
	; Passed all the checks, spawn four separate debris actors that hurt the player.
	; The four debris have all different horizontal position and speed, with
	; the latter being determined by its unique init routines (see also: Act_QuintDebris)
	;
	
	; $00
	ld   a, ACT_QUINT_DEBRIS
	ld   bc, (LOW(-$06) << 8)|$00 ; 6px left
	call ActS_SpawnRel ; ACTRTN_QUINTDEBRIS_INIT0
	
	; $01
	ld   a, ACT_QUINT_DEBRIS
	ld   bc, (LOW(-$02) << 8)|$00 ; 2px left
	call ActS_SpawnRel
	inc  hl ; iActRtnId
	ld   [hl], ACTRTN_QUINTDEBRIS_INIT1
	
	; $02
	ld   a, ACT_QUINT_DEBRIS
	ld   bc, (LOW($02) << 8)|$00 ; 2px right
	call ActS_SpawnRel
	inc  hl ; iActRtnId
	ld   [hl], ACTRTN_QUINTDEBRIS_INIT2
	
	; $03
	ld   a, ACT_QUINT_DEBRIS
	ld   bc, (LOW($06) << 8)|$00 ; 6px right
	call ActS_SpawnRel
	inc  hl ; iActRtnId
	ld   [hl], ACTRTN_QUINTDEBRIS_INIT3
	
	jp   ActS_IncRtnId
	
; =============== Act_Quint_GroundWait ===============
; Ground cycle - debris end check.
Act_Quint_GroundWait:
	call Act_Quint_ChkDeath
	ret  c
	
	; Use sprite $06, as part of the animation
	ld   a, $06
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Wait 8 more frames (total 16) before spawning debris, in case we loop back.
	ld   a, $08
	ldh  [hActCur+iActTimer0C], a
	; Loop back if we aren't done spawning debris.
	ld   hl, hActCur+iQuintDebrisTimer
	dec  [hl]					; Timer--
	jp   nz, ActS_DecRtnId		; Timer != 0? If so, go back to Act_Quint_GroundDebris
	
	;
	; Otherwise, set up the next Sakugarne jump, directly targeting the player.
	;
	
	call ActS_FacePl			; Towards the player
	call ActS_GetPlDistanceX	; X Speed = ((DiffX * 4) / $10) px/frame
	ld   l, a
	ld   h, $00
	add  hl, hl
	add  hl, hl
	ld   a, l
	ldh  [hActCur+iActSpdXSub], a
	ld   a, h
	ldh  [hActCur+iActSpdX], a
	ld   bc, $0380				; Y Speed = 3.5px/frame
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_Quint_JumpU ===============
; Jump, pre-peak.
Act_Quint_JumpU:
	call Act_Quint_ChkDeath
	ret  c
	
	; Use sakugarne jumping sprite
	ld   a, $05
	ld   [wActCurSprMapBaseId], a
	
	; Move forward, stopping on solid walls
	call ActS_ApplySpeedFwdXColi
	; Move up, until we reach the peak of the jump
	call ActS_ApplySpeedUpYColi
	ret  c
	
	; Then start falling down
	ld   a, ACTRTN_QUINT_JUMPD
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Quint_DeadFall ===============
; Defeat sequence - fall down.
Act_Quint_DeadFall:
	; Fall on the ground in the standing frame.
	; This is usually barely noticeable, since Quint is likely already on the ground.
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; Start the ground teleport animation
	; Use sprites $07-$0A at 1/4 speed
	ld   de, ($07 << 8)|$0A
	ld   c, $04
	call ActS_InitAnimRange
	
	jp   ActS_IncRtnId
	
; =============== Act_Quint_WarpLand ===============
; Defeat sequence - ground animation.
Act_Quint_WarpLand:
	; Play the ground teleport animation, once that's done...
	call ActS_PlayAnimRange
	ret  z
	; ...move up at 4px/frame
	ld   hl, hActCur+iActSprMap
	res  ACTDIRB_D, [hl]
	ld   bc, $0400
	call ActS_SetSpeedY
	; ...play appropriate sound effect
	ld   a, SFX_TELEPORTOUT
	ldh  [hSFXSet], a
	jp   ActS_IncRtnId
	
; =============== Act_Quint_WarpMove ===============
; Defeat sequence - moving.
Act_Quint_WarpMove:
	; Use teleport sprite
	ld   a, $0B
	ld   [wActCurSprMapBaseId], a
	
	; Move up until we reach Y position $18
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActY]
	cp   $18				; iActY >= $18?
	ret  nc					; If so, return
	xor  a					; Otherwise, offscreen it above
	ldh  [hActCur+iActY], a
	jp   ActS_IncRtnId		; and teleport the player as soon as possible
	
; =============== Act_Quint_PlWarpOut ===============
; Defeat sequence - teleport player out.
Act_Quint_PlWarpOut:
	; Wait until the player has touched the ground before teleporting out
	ld   a, [wPlMode]
	or   a						; wPlMode == PL_MODE_GROUND?
	ret  nz						; If not, wait
	ld   a, PL_MODE_WARPOUTINIT	; Otherwise, start the teleport
	ld   [wPlMode], a
	
	ld   a, 60						; Wait for a second before ending the level
	ldh  [hActCur+iActTimer0C], a	; It should be enough to let the player fully teleport out
	jp   ActS_IncRtnId
	
; =============== Act_Quint_EndLvl ===============
; Defeat sequence - end level.
Act_Quint_EndLvl:
	; Wait for that second...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Then end the lemvel
	ld   a, LVLEND_BOSSDEAD
	ld   [wLvlEnd], a
	ret
	
; =============== Act_Quint_ChkDeath ===============
; Handles the death checks for Quint.
; OUT
; - C Flag: If set, Quint has been defeated
Act_Quint_ChkDeath:
	; As this boss doesn't have a visible health bar, it can use the normal $10 threshold
	; used by actors that perform special actions on death.
	call ActS_GetHealth
	cp   $11						; Health >= $11?
	ret  nc							; If so, return (C Flag = clear)
	
	ld   a, ACTRTN_QUINT_DEADFALL	; Otherwise, start teleporting out
	ldh  [hActCur+iActRtnId], a
	scf  							; C Flag = Set
	ret								; In practice, the above could have been "pop af"
	
; =============== Act_Wily3Part ===============
; ID: ACT_WILY3PART
; Animates the secondary parts of Wily Machine's 3rd phase.
; These parts only have two frames of animation, with the second one being triggered by Act_Wily3.
;
; Two separate instances are spawned, one for animating the arms, one for the tail.
; These are purely visual effects, they don't affect the fight at all.
Act_Wily3Part:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wily3Part_Intro
	dw Act_Wily3Part_Spr0
	dw Act_Wily3Part_Spr1

; =============== Act_Wily3Part_Intro ===============
; Displays the parts during the 3rd phase intro.
Act_Wily3Part_Intro:
	;
	; During this intro, Act_Wily3 scrolls in from the right, offscreen.
	; Make sure to keep our X position syncronized.
	;
	
	; Only use base sprite
	ldh  a, [hActCur+iWily3PartSprMapId]
	ld   [wActCurSprMapBaseId], a
	
	; Syncronize our X position with Act_Wily3, this is the important bit.
	ldh  a, [hActCur+iWily3PartAnimPtr]	; Get pointer to iWily3AnimPart
	sub  iWily3AnimPart-iActX			; Seek back to X position
	ld   l, a							; Set as low byte
	ld   h, HIGH(wAct)					; Use standard high byte
	ld   a, [hl]						; Read out the X position
	ldh  [hActCur+iActX], a				; Copy it over, as-is
	
	; The intro is treated as "finished" here once we have moved into position.
	cp   OBJ_OFFSET_X+$80		; iActX != $88?
	ret  nz						; If so, keep waiting
	
	; Otherwise, we're ready. The X position won't change anymore.
	jp   ActS_IncRtnId
	
; =============== Act_Wily3Part_Spr0 ===============
; Use 1st sprite.
Act_Wily3Part_Spr0:
	; Set sprite #0 (wActCurSprMapBaseId)
	call Act_Wily3Part_GetProp		; HL = Ptr to iWily3AnimPart, A = iWily3PartSprMapId
	ld   [wActCurSprMapBaseId], a	; Confirm sprite #0
	
	;
	; Check if Act_Wily3 is requesting to animate a part.
	; To uniquely identify the two actor instances, iWily3AnimPart goes off by sprite ID.
	;
	sub  [hl]						; iWily3AnimPart == iWily3PartSprMapId?
	ret  nz							; If not, keep waiting for the signal
									; Otherwise...
									
	ld   [hl], a					; Reset the request signal (A will be 0, which is why it uses "sub" over "cp")
	ld   a, $20						; Display the second sprite for ~half a second
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily3Part_Spr1 ===============
; Use 2nd sprite.
Act_Wily3Part_Spr1:
	; Set sprite #1 (iWily3PartSprMapId + 1)
	; This is always implicitly after iWily3PartSprMapId
	call Act_Wily3Part_GetProp
	inc  a
	ld   [wActCurSprMapBaseId], a
	
	; Show that for ~half a second
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Then go back to sprite #0
	jp   ActS_DecRtnId
	
; =============== Act_Wily3Part_GetProp ===============
; Gets some shared properties.
; OUT
; - HL: Ptr to iWily3AnimPart
; - A: iWily3PartSprMapId
Act_Wily3Part_GetProp:
	ldh  a, [hActCur+iWily3PartAnimPtr]
	ld   l, a
	ld   h, HIGH(wAct)
	
	ldh  a, [hActCur+iWily3PartSprMapId]
	
	ret
	
; =============== Act_Wily2Intro ===============
; ID: ACT_WILY2INTRO
; Body of the 2nd phase Wily Machine, used in the intro cutscene before the Wily attaches itself to it. 
Act_Wily2Intro:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wily2Intro_Init
	dw Act_Wily2Intro_Move
	dw Act_Wily2Intro_Wait

; =============== Act_Wily2Intro_Init ===============
Act_Wily2Intro_Init:
	; Move left 0.5px/frame 
	ld   bc, $0080
	call ActS_SetSpeedX
	;--
	; [POI] This was intended to make the actor face left, but it's writing to the wrong address.
	;       It also doesn't matter as the actor is already facing left.
	ld   hl, hActCur+iAct0D
	res  ACTDIRB_R, [hl]
	;--
	
	jp   ActS_IncRtnId
; =============== Act_Wily2Intro_Move ===============
Act_Wily2Intro_Move:
	; Move forward at 0.5px/frame until we reach the target coordinate.
	call ActS_ApplySpeedFwdX
	ldh  a, [hActCur+iActX]
	cp   OBJ_OFFSET_X+$88	; iActX != $90?
	ret  nz					; If so, return
	jp   ActS_IncRtnId		; Otherwise, stop moving
	
; =============== Act_Wily2Intro_Wait ===============
Act_Wily2Intro_Wait:
	; Wait forever until Wily's Spaceship attaches itself,
	; at which point Act_WilyCtrl will despawn us.
	ret
	
; =============== Act_QuintSakugarne ===============
; ID: ACT_QUINT_SG
; Sakugarne used during Quint's intro animation.
; This is not used during the fight itself, the Sakugarne Quint rides is baked into Quint itself.
Act_QuintSakugarne:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_QuintSakugarne_Init
	dw Act_QuintSakugarne_FallV
	dw Act_QuintSakugarne_InitJump
	dw Act_QuintSakugarne_JumpU
	dw Act_QuintSakugarne_JumpD
	dw Act_QuintSakugarne_WaitEnd

; =============== Act_QuintSakugarne_Init ===============
Act_QuintSakugarne_Init:
	; Reset gravity in preparation for falling down
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_QuintSakugarne_FallV ===============
; Drop from the top of the screen.
Act_QuintSakugarne_FallV:
	; Fall down until we touch the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	; Wait 4 frames before setting up a jump
	ld   a, $04
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_QuintSakugarne_InitJump ===============
Act_QuintSakugarne_InitJump:
	; Show sprite $01 while waiting 4 frames...
	; (only for these few frames it's on the ground)
	ld   a, $01
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	;
	; After that, set up a jump to the left.
	;
	
	; Signal out to Quint that he may also start jumping up, to make him catch the pogo stick.
	ld   a, $FF
	ldh  [hActCur+iQuintSgJumpOk], a
	
	ld   hl, hActCur+iActSprMap	; Jump right
	set  ACTDIRB_R, [hl]
	ld   bc, $0140				; 1.25px/frame to the right
	call ActS_SetSpeedX
	ld   bc, $0380				; 3.5px/frame up
	call ActS_SetSpeedY			; This is the same vertical speed Quint jumps at
	jp   ActS_IncRtnId
	
; =============== Act_QuintSakugarne_JumpU ===============
; Jump, pre-peak.
Act_QuintSakugarne_JumpU:
	; Apply jump arc until we reach the peak of the jump 
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_QuintSakugarne_JumpD ===============
; Jump, post-peak.
Act_QuintSakugarne_JumpD:
	; Apply jump arc until we reach X position $90.
	; That's the X position Quint is in.
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedDownYColi
	ldh  a, [hActCur+iActX]
	cp   OBJ_OFFSET_X+$88	; iActX < $90?
	ret  c					; If so, wait
	
	; Wait for 4 frames before despawning.
	; This is timed with the end of Quint's intro animation,
	; as the Sakugarne is baked into his sprites there.
	ld   a, $04
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_QuintSakugarne_WaitEnd ===============
Act_QuintSakugarne_WaitEnd:
	; Wait those 4 frames...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Then despawn
	xor  a
	ldh  [hActCur+iActId], a
	ret
	
; =============== Act_QuintDebris ===============
; ID: ACT_QUINT_DEBRIS
; Damaging debris spawned when Quint is on the ground.
Act_QuintDebris:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_QuintDebris_Init0
	dw Act_QuintDebris_Init1
	dw Act_QuintDebris_Init2
	dw Act_QuintDebris_Init3
	dw Act_QuintDebris_JumpU
	dw Act_QuintDebris_JumpD
	DEF ACTRTN_QUINTDEBRIS_JUMPU = $04

; =============== Act_QuintDebris_Init* ===============
; Four debris spawn at once, each with its own jump arc.
; Hence why there are four separate init routines, which are directly
; set by Act_Quint when it spawns the debris.
;

; =============== Act_QuintDebris_Init0 ===============
; ACTRTN_QUINTDEBRIS_INIT0
Act_QuintDebris_Init0:
	ld   bc, $0060						; 0.375px/frame left
	call ActS_SetSpeedX
	ld   bc, $0240						; 2.25px/frame up
	call ActS_SetSpeedY
	ldh  a, [hActCur+iActSprMap]
	and  $FF^(ACTDIR_R|ACTDIR_D)		; Set LEFT, UP directions
	ldh  [hActCur+iActSprMap], a
	ld   a, ACTRTN_QUINTDEBRIS_JUMPU	; Apply jump
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_QuintDebris_Init1 ===============
; ACTRTN_QUINTDEBRIS_INIT1
Act_QuintDebris_Init1:
	ld   bc, $0020						; 0.125px/frame left
	call ActS_SetSpeedX
	ld   bc, $02C0						; 2.75px/frame up
	call ActS_SetSpeedY
	ldh  a, [hActCur+iActSprMap]
	and  $FF^(ACTDIR_R|ACTDIR_D)		; Set LEFT, UP directions
	ldh  [hActCur+iActSprMap], a
	ld   a, ACTRTN_QUINTDEBRIS_JUMPU	; Apply jump
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_QuintDebris_Init2 ===============
; ACTRTN_QUINTDEBRIS_INIT2
Act_QuintDebris_Init2:
	ld   bc, $0020						; 0.125px/frame left
	call ActS_SetSpeedX
	ld   bc, $02C0						; 2.75px/frame up
	call ActS_SetSpeedY
	ldh  a, [hActCur+iActSprMap]
	and  $FF^(ACTDIR_R|ACTDIR_D)		; Set RIGHT, UP directions
	or   ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	ld   a, ACTRTN_QUINTDEBRIS_JUMPU	; Apply jump
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_QuintDebris_Init3 ===============
; ACTRTN_QUINTDEBRIS_INIT3
Act_QuintDebris_Init3:
	ld   bc, $0060						; 0.375px/frame right
	call ActS_SetSpeedX
	ld   bc, $0240						; 2.25px/frame up
	call ActS_SetSpeedY
	ldh  a, [hActCur+iActSprMap]
	and  $FF^(ACTDIR_R|ACTDIR_D)		; Set RIGHT, UP directions
	or   ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	jp   ActS_IncRtnId ; ACTRTN_QUINTDEBRIS_JUMPU	; Apply jump
	
; =============== Act_QuintDebris_JumpU ===============
; Jump, pre-peak.
Act_QuintDebris_JumpU:
	; Apply jump arc until we reach the peak of the jump 
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId			; Then start falling down
	
; =============== Act_QuintDebris_JumpD ===============
; Jump, post-peak.
Act_QuintDebris_JumpD:
	; Apply jump arc until we touch the ground 
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedDownYColi
	ret  c
	jp   ActS_Explode			; Then explode
	
; =============== Act_Wily1Bomb ===============
; ID: ACT_WILY1BOMB
; Bouncing bomb from the 1st phase of the Wily Machine.
; Does not explode.
Act_Wily1Bomb:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wily1Bomb_Init
	dw Act_Wily1Bomb_JumpU
	dw Act_Wily1Bomb_JumpD

; =============== Act_Wily1Bomb_Init ===============
Act_Wily1Bomb_Init:
	call ActS_FacePl		; Jump towards the player
	ld   bc, $0100			; 1px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0300			; 3px/frame up
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_Wily1Bomb_JumpU ===============
Act_Wily1Bomb_JumpU:
	; Apply jump arc until we reach the peak of the jump.
	; This does not check for solid walls while going forward,
	; so they it will phase through
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedUpY
	ret  c
	jp   ActS_IncRtnId		; Then start falling down
	
; =============== Act_Wily1Bomb_JumpD ===============
Act_Wily1Bomb_JumpD:
	; Apply jump arc until we touch the ground 
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedDownYColi
	ret  c
	
	ld   bc, $0300			; Then start another identical jump
	call ActS_SetSpeedY
	jp   ActS_DecRtnId		; looping
	
; =============== Act_Wily1Nail ===============
; ID: ACT_WILY1NAIL
; Toenail fired forward, with a very misleading hitbox.
Act_Wily1Nail:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wily1Nail_Init
	dw Act_Wily1Nail_Move

; =============== Act_Wily1Nail_Init ===============
; Set up horizontal movement towards the player at 2px/frame.
Act_Wily1Nail_Init:
	call ActS_FacePl
	ld   bc, $0200
	call ActS_SetSpeedX
	jp   ActS_IncRtnId
; =============== Act_Wily1Nail_Move ===============
; Move forward until it gets offscreened.
Act_Wily1Nail_Move:
	call ActS_ApplySpeedFwdX
	ret
	
; =============== Act_Wily2Bomb ===============
; ID: ACT_WILY2BOMB
; Bouncing bomb from the 2nd phase of the Wily Machine.
; Does explode.
Act_Wily2Bomb:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wily2Bomb_Init
	dw Act_Wily2Bomb_JumpU
	dw Act_Wily2Bomb_JumpD
	dw Act_Wily2Bomb_InitShot
	dw Act_Wily2Bomb_Shot
	DEF ACTRTN_WILY2BOMB_INITSHOT = $03
	
; =============== Act_Wily2Bomb_Init ===============
Act_Wily2Bomb_Init:
	call ActS_FacePl		; Jump towards the player
	ld   bc, $0080			; 0.5px/frame forward
	call ActS_SetSpeedX
	; No vertical movement yet, just fall down the first time
	jp   ActS_IncRtnId
	
; =============== Act_Wily2Bomb_JumpU ===============
Act_Wily2Bomb_JumpU:
	; Apply jump arc until we reach the peak of the jump.
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId			; Then start falling down
	
; =============== Act_Wily2Bomb_JumpD ===============
Act_Wily2Bomb_JumpD:
	; Apply jump arc until we touch the ground 
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedDownYColi
	ret  c
	
	;
	; When touching the ground, explode only if the player has gone past the bomb.
	; Otherwise, do another high jump at 3.5px/frame.
	;
	
	ld   bc, $0380					; Prepare 3.5px/frame in case we go back to Act_Wily2Bomb_JumpU
	call ActS_SetSpeedY
	
	; Check if the player is behind the bomb, similarly to Act_Wily2_ChkPlBehind,
	; except simpler since the bomb is guaranteed to not animate (so there's no need to filter directions)
	ldh  a, [hActCur+iActSprMap]	; Save unmodified iActSprMap for later
	push af
		call ActS_FacePl			; Face the player. This may or may not modify the directions.
	pop  af
	ld   hl, hActCur+iActSprMap		; Get new iActSprMap
	cp   [hl]						; Are the new directions unchanged from the old ones?
	ld   [hl], a					; (restore original iActSprMap, as if ActS_FacePl was never called)
	jp   z, ActS_DecRtnId			; If so, return (go back doing another jump)
	
	;
	; Otherwise, explode!
	; This causes two shots to travel diagonally up in both directions.
	; The moving shot is handled by the next routine, so a second instance of the bomb
	; is spawned that directly starts there.
	;
	
	; LEFT SHOT
	; The current actor is already moving left, so use it as left shot.
	res  ACTDIRB_D, [hl]			; We were moving down though, so make it move up
	
	; RIGHT SHOT
	ld   a, ACT_WILY2BOMB			; Spawn a new bomb instance
	ld   bc, $0000
	call ActS_SpawnRel
	inc  hl ; iActRtnId				; Start in the explosion routine
	ld   [hl], ACTRTN_WILY2BOMB_INITSHOT
	inc  hl ; iActSprMap
	ldh  a, [hActCur+iActSprMap]	; Face right
	xor  ACTDIR_R					; Could have been "or"
	ld   [hl], a
	
	jp   ActS_IncRtnId				; Start left shot
	
; =============== Act_Wily2Bomb_InitShot ===============
Act_Wily2Bomb_InitShot:
	; [POI] The collision box is not being altered from the bomb, which is extremely misleading
	;       as the shot's sprite is 8x8 compared to the bomb's 16x16.
	ld   a, $01					; Use shot sprite
	call ActS_SetSprMapId
	ld   bc, $0100				; Move forward 1px/frame
	call ActS_SetSpeedX
	ld   bc, $0100				; Move up 1px/frame
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_Wily2Bomb_Shot ===============
Act_Wily2Bomb_Shot:
	; Apply movement until it goes offscreen
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
; =============== Act_Wily2Shot ===============
; ID: ACT_WILY2SHOT
; Diagonal energy ball thrown towards the player.
Act_Wily2Shot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wily2Shot_Init
	dw Act_Wily2Shot_Move

; =============== Act_Wily2Shot_Init ===============
Act_Wily2Shot_Init:
	call ActS_AngleToPl	; Throw towards the player...
	call ActS_DoubleSpd	; ...at double speed
	jp   ActS_IncRtnId
	
; =============== Act_Wily2Shot_Move ===============
Act_Wily2Shot_Move:
	; Move the shot at the set speed until it goes offscreen
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
; =============== Act_Wily3Missile ===============
; ID: ACT_WILY3MISSILE
; Missile that initially homes in on the player.
Act_Wily3Missile:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wily3Missile_Init
	dw Act_Wily3Missile_TrackPl
	dw Act_Wily3Missile_Move

; =============== Act_Wily3Missile_Init ===============
Act_Wily3Missile_Init:
	; Home in for the first ~second
	ld   a, $40
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily3Missile_TrackPl ===============
Act_Wily3Missile_TrackPl:
	call ActS_AngleToPl			; Track player position
	call ActS_ApplySpeedFwdX	; Move precisely there
	call ActS_ApplySpeedFwdY	; ""
	ldh  a, [hActCur+iActTimer0C]
	sub  $01					; Done with this part?
	ldh  [hActCur+iActTimer0C], a
	ret  nz						; If not, return
	jp   ActS_IncRtnId
	
; =============== Act_Wily3Missile_Move ===============
Act_Wily3Missile_Move:
	; Continue moving with the last tracked speed values (last tracked player position)
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
; =============== Act_Wily3Met ===============
; ID: ACT_WILY3MET
; Off-model Mets(?) launched up by the final boss. Four are spawned at once.
Act_Wily3Met:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wily3Met_Init
	dw Act_Wily3Met_JumpU
	dw Act_Wily3Met_JumpD

; =============== Act_Wily3Met_Init ===============
Act_Wily3Met_Init:
	call ActS_FacePl		; Move towards the player
	ld   bc, $0440			; Y Speed: 4.25px/frame up
	call ActS_SetSpeedY
	; X Speed set by the spawner code in Act_Wily3, since it varies for each spawned instance of the set.
	jp   ActS_IncRtnId
	
; =============== Act_Wily3Met_JumpU ===============
; Jump, pre-peak.
Act_Wily3Met_JumpU:
	; (Use normal sprite $00)
	; Apply jump arc until we reach the peak of the jump.
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedUpY
	ret  c
	jp   ActS_IncRtnId		; Then start falling down
	
; =============== Act_Wily3Met_JumpD ===============
; Jump, post-peak.
Act_Wily3Met_JumpD:
	; Use upside down sprite $01
	ld   a, $01
	ld   [wActCurSprMapBaseId], a
	; Apply jump arc until we get offscreened 
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedDownY
	ret
	
;================ Act_WilyCtrl ================
; ID: ACT_WILYCTRL
; Master actor for the final boss.
; Takes care of spawning the actors for the individual phases as needed.
;
; The Wily Spaceship sprites are associated to this actor, so its code (Act_WilyShip)
; runs as part of it, with the necessary measures to not cause conflicts.
Act_WilyCtrl:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_WilyCtrl_P1Init
	dw Act_WilyCtrl_P1Wait
	dw Act_WilyCtrl_P2Intro0
	dw Act_WilyCtrl_P2Intro1
	dw Act_WilyCtrl_P2Wait
	dw Act_WilyCtrl_P3Intro0
	dw Act_WilyCtrl_P3Intro_MoveR
	dw Act_WilyCtrl_P3Spawn
	dw Act_WilyCtrl_P3ScrollR
	dw Act_WilyCtrl_Despawn

;================ Act_WilyCtrl_P1Init ================
; Wily Machine - Prepare 1st phase.
Act_WilyCtrl_P1Init:

	;
	; Hide the Wily Spaceship during the 1st phase.
	;
	ld   b, ACTCOLI_PASS		; Make intangible
	call ActS_SetColiType
	xor  a						; Disable defeat trigger (see Act_WilyCtrl_P1Wait)
	ld   [wWilyPhaseDone], a
	ld   a, OBJ_OFFSET_Y+$88	; Hide under the ground
	ldh  [hActCur+iActY], a
	
	;
	; Spawn the 1st phase of the Wily Machine directly above the spawner.
	; As actors are executed even during shutter effects, this will spawn
	; the Wily Machine before it gets scrolled in, avoiding pop-ins.
	;
	; This also hides the fact that the Wily Spaceship is visible for one frame,
	; as that happens offscreen.
	;
	ld   a, ACT_WILY1			; Spawn the actor for the 1st phase...
	ld   bc, $0000				; ...with the same X pos as the spawner
	call ActS_SpawnRel
	ld   de, iActY
	add  hl, de					; ...on the ground (Y position $80)
	ld   [hl], OBJ_OFFSET_Y+$70
	
	jp   ActS_IncRtnId
	
;================ Act_WilyCtrl_P1Wait ================
; Wily Machine - Wait 1st phase.
Act_WilyCtrl_P1Wait:
	
	;
	; Wait, hidden, until Act_Wily1 signals to us that it's been destroyed.
	; wWilyPhaseDone is set when Act_Wily1_ChkDeath detects that the boss has less than 8 bars of health.
	;
	ld   a, $02					; Hide the Wily Spaceship (use blank sprite mapping)
	ld   [wActCurSprMapBaseId], a
	ld   a, [wWilyPhaseDone]
	and  a						; Was the 1st phase defeated?
	ret  z						; If not, return
	
	;
	; 1st phase defeated.
	;
	xor  a						; Disable trigger for next time
	ld   [wWilyPhaseDone], a
	ld   a, [wWilyShipY]		; Sync the spaceship coordinates
	ldh  [hActCur+iActY], a		; from whatever Act_Wily1_ChkDeath set them
	ld   a, [wWilyShipX]
	ldh  [hActCur+iActX], a
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType		; With the ship visible, take damage for running into it
	xor  a						; Reset routine
	ldh  [hActCur+iWilyShipRtnId], a
	jp   ActS_IncRtnId
	
;================ Act_WilyCtrl_P2Intro0 ================
; Wily Machine - 2nd phase intro #0
Act_WilyCtrl_P2Intro0:
	;
	; Animate the Wily Spaceship.
	;
	; When that's about to scroll the screen right, spawn the intro actor for the 2nd phase.
	;
	call Act_WilyShip
	
	ldh  a, [hActCur+iWilyShipRtnId]	; Read ship routine
	cp   ACTRTN_WILYSHIP_MOVESCROLLR	; Just got set to ACTRTN_WILYSHIP_MOVESCROLLR?
	ret  nz								; If not, return
	
	; Otherwise, spawn the body of the 2nd phase, used for the intro.
	ld   a, ACT_WILY2INTRO				
	ld   bc, $0000
	call ActS_SpawnRel
	
	; Make the body spawn on the ground, offscreen to the right.
	; While we're at it also keep track of the pointer to the spawned slot.
	
	; Seek HL to child's X position
	; HL += iActX
	ld   a, l			
	ldh  [hActCur+iWilyCtrlChildPtrLow], a		; # Save child slot ptr
	add  iActX
	ld   l, a
	ld   a, h
	ldh  [hActCur+iWilyCtrlChildPtrHigh], a		; # Save child slot ptr
	; Set coords
	ld   [hl], SCREEN_GAME_H+OBJ_OFFSET_X+$18	; iActX = $C0
	inc  hl ; iActYSub
	inc  hl ; iActY
	ld   [hl], OBJ_OFFSET_Y+$70 				; iActY = $80
	
	jp   ActS_IncRtnId
	
;================ Act_WilyCtrl_P2Intro1 ================
; Wily Machine - 2nd phase intro #1
Act_WilyCtrl_P2Intro1:
	; Continue animating the spaceship from where we left off.
	call Act_WilyShip
	ldh  a, [hActCur+iWilyShipRtnId]
	cp   ACTRTN_WILYSHIP_END			; Did the animation just end?
	ret  nz								; If not, return
	
	;
	; Animation over, the spaceship has attached itself.
	; Prepare for the 2nd phase.
	;
	
	; Despawn ACT_WILY2INTRO
	ldh  a, [hActCur+iWilyCtrlChildPtrLow]
	ld   l, a
	ldh  a, [hActCur+iWilyCtrlChildPtrHigh]
	ld   h, a
	ld   [hl], $00
	
	ld   a, OBJ_OFFSET_Y+$88	; Hide under the ground
	ldh  [hActCur+iActY], a
	ld   b, ACTCOLI_PASS		; Make intangible
	call ActS_SetColiType
	; Boss intros alter wBossMode after they're done.
	; Since we're chaining bosses, we have to reset it to the expected value, 
	; otherwise it will get skipped and the boss health bar won't refill.
	ld   a, BSMODE_INIT
	ld   [wBossMode], a
	
	; Spawn the actual 2nd phase actor
	ld   a, ACT_WILY2
	ld   bc, ($00 << 8)|LOW(-$18) ; 24px up
	call ActS_SpawnRel
	
	jp   ActS_IncRtnId
	
;================ Act_WilyCtrl_P2Wait ================
; Wily Machine - Wait 2nd phase.
; See also: Act_WilyCtrl_P1Wait
Act_WilyCtrl_P2Wait:
	;
	; Wait, hidden, until Act_Wily2 signals to us that it's been destroyed.
	;
	ld   a, $02					; Hide the Wily Spaceship (use blank sprite mapping)
	ld   [wActCurSprMapBaseId], a
	ld   a, [wWilyPhaseDone]
	and  a						; Was the 1st phase defeated?
	ret  z						; If not, return
	
	;
	; 2nd phase defeated.
	;
	xor  a						; Disable trigger
	ld   [wWilyPhaseDone], a
	ld   a, [wWilyShipY]		; Sync the spaceship coordinates
	ldh  [hActCur+iActY], a		; from whatever Act_Wily2_ChkDeath set them
	ld   a, [wWilyShipX]
	ldh  [hActCur+iActX], a
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType		; With the ship visible, take damage for running into it
	xor  a						; Reset routine
	ldh  [hActCur+iWilyShipRtnId], a
	
	;
	; Load the GFX for the BG portion of the final boss.
	;
	; These graphics completely replace the GFX set with the one from Wily's Castle,
	; as that one is empty enough it could squeeze those graphics in.
	;
	; To make the whole thing work, the only tile shown on screen is for a simple horizontal
	; pipe (tile $04), which is the same between GFX_LvlCastle and GFX_LvlStation.
	ld   bc, (BANK(GFX_LvlCastle) << 8) | $80 ; Source GFX bank number + Number of tiles to copy
	ld   hl, GFX_LvlCastle ; Source GFX ptr
	ld   de, $9000 ; VRAM Destination ptr (start of 3rd section)
	call GfxCopy_Req
	jp   ActS_IncRtnId
	
;================ Act_WilyCtrl_P3Intro0 ================
; Wily Machine - 3rd phase intro #0
Act_WilyCtrl_P3Intro0:
	;
	; Animate the Wily Spaceship.
	;
	; When that's about to scroll the screen right, take over the animation.
	;
	call Act_WilyShip
	ldh  a, [hActCur+iAct0D]
	cp   ACTRTN_WILYSHIP_MOVESCROLLR
	ret  nz
	
	; Move right for ~1.5 seconds
	ld   a, $60
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_WilyCtrl_P3Intro_MoveR ================
; Wily Machine - 3rd phase intro - move spaceship right, to offscreen.
Act_WilyCtrl_P3Intro_MoveR:
	; Animate propeller
	ld   c, $01
	call ActS_Anim2
	
	; Move the spaceship right 0.5px/frame for those ~1.5 seconds
	call ActS_ApplySpeedFwdX
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; At this point, the spaceship should be fully offscreen.
	; Wait ~half a second doing nothing to simulate the docking happening.
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_WilyCtrl_P3Spawn ================
; Wily Machine - 3rd phase intro - spawn actors.
Act_WilyCtrl_P3Spawn:
	; Wait for that ~half a second...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	;
	; Spawn the actual 3rd phase actor.
	; This will be stuck in the first routine, which does nothing, 
	; until Act_WilyCtrl_P3ScrollR finishes scrolling the screen.
	;
	ld   a, ACT_WILY3
	ld   bc, $0000
	call ActS_SpawnRel
	; Save to our struct the slot pointer to iWily3AnimPart, used by ACT_WILY3PART to check for animation signals.
	; This will be copied over to the spawned ACT_WILY3PART (see next spawns).
	ld   a, l
	add  iWily3AnimPart
	ldh  [hActCur+iWilyCtrl3PartAnimPtr], a
	; Set shared properties
	xor  a						; iWily3AnimPart = 0 (no signal)
	call Act_WilyCtrl_Set3Prop
	
	;
	; Spawn the accessory parts for the arm and tail.
	;
	ld   a, ACT_WILY3PART
	ld   bc, $0000
	call ActS_SpawnRel
	ld   a, WILY3PART_SPR_ARM ; iWily3PartSprMapId
	call Act_WilyCtrl_Set3Prop
	
	ld   a, ACT_WILY3PART
	ld   bc, $0000
	call ActS_SpawnRel
	ld   a, WILY3PART_SPR_TAIL ; iWily3PartSprMapId
	call Act_WilyCtrl_Set3Prop
	
	; Scroll the screen right at 0.5px/frame
	ld   a, $80
	ldh  [hActCur+iActSpdXSub], a
	
	jp   ActS_IncRtnId
	
;================ Act_WilyCtrl_P3ScrollR ================
; Wily Machine - 3rd phase intro - scroll screen.
; See also: Act_WilyShip_MoveScrollR
Act_WilyCtrl_P3ScrollR:

	;
	; Currently, Act_Wily3 is frozen in a dummy routine that does nothing,
	; so its movement needs to be done here.
	;

	;--
	;
	; Move the screen right 0.5px/frame, adjusting the actor to compensate.
	;

	; First, apply the subpixel speed as normal
	ldh  a, [hActCur+iActSpdXSub]	; A = Subpixel speed
	ld   hl, hActCur+iActXSub		; HL = Ptr to subpixel X
	add  [hl]						; Move right by that
	ld   [hl], a					; Save back
	
	; If that overflowed, instead of incrementing iActX directly, scroll the screen 1px to the right.
	; The way this works assumes movement < 1px/frame, since it should not alter iActX.
	jr   nc, .chkEnd
	; Scroll screen 1px right
	; This is not calling the normal Game_AutoScrollR because it leads to inconsistent results
	; when run from actor code, since ActS_MoveByScrollX would only get called for the actors
	; not processed yet.
	call Game_AutoScrollR_NoAct
	; Move final boss actor 1px left to adjust.
	; Both spawned parts will sync to the updated position by themselves.
	ldh  a, [hActCur+iWilyCtrl3PartAnimPtr]
	sub  iWily3AnimPart-iActX
	ld   l, a
	ld   h, HIGH(wAct)	; HL = Ptr to Act_Wily3's iActX
	dec  [hl]			; iActX--
.chkEnd:
	;--
	
	;
	; If Act_Wily3's position has reached $88, it has finished moving,
	; so unlock it from its frozen state.
	;
	ldh  a, [hActCur+iWilyCtrl3PartAnimPtr]
	sub  iWily3AnimPart-iActX
	ld   l, a
	ld   h, HIGH(wAct)		; HL = Ptr to Act_Wily3's iActX
	ld   a, [hl]			; Read it
	cp   OBJ_OFFSET_X+$80	; iActX != $88?
	ret  nz					; If so, return
	
	; Unlock Act_Wily3, by incrementing its routine
	ldh  a, [hActCur+iWilyCtrl3PartAnimPtr]
	sub  iWily3AnimPart-iActRtnId
	ld   l, a
	ld   h, HIGH(wAct)		; HL = Ptr to Act_Wily3's iActRtnId
	ld   [hl], ACTRTN_WILY3_INIT
	
	; Like before, allow the boss intro to happen
	ld   a, BSMODE_INIT
	ld   [wBossMode], a
	jp   ActS_IncRtnId
	
;================ Act_WilyCtrl_Despawn ================
Act_WilyCtrl_Despawn:
	xor  a
	ldh  [hActCur+iActId], a
	ret
	
; =============== Act_WilyCtrl_Set3Prop ===============
; Sets properties to the newly spawned 3rd phase actors.
; IN
; - HL: Ptr to newly spawned Act_Wily3 or Act_Wily3Part
; -  A: For Act_Wily3Part, it's the base sprite mapping ID (iWily3PartSprMapId).
;       That value acts as an unique identifier for the animation signal, and is never changed.
;       For Act_Wily3, it's the part animation signal (iWily3AnimPart)
;       When the sprite mapping ID of a part is written there, the actor with a matching iWily3PartSprMapId will animate.
Act_WilyCtrl_Set3Prop:
	;
	; All of the 3rd phase actors we spawn have the same coordinates.
	; Initially they spawn off-screen to the right, as their intro animation scrolls them in.
	;
	ld   de, iActX
	add  hl, de
	ld   [hl], OBJ_OFFSET_X+SCREEN_GAME_H+$20 ; iActX = $C8
	inc  hl ; iActYSub
	inc  hl ; iActY
	ld   [hl], OBJ_OFFSET_Y+$70 ; iActY = $80
	
	;
	; Save the sprite mapping ID related to the part, or initialize the signal.
	;
	ld   de, iWily3PartSprMapId-iActY
	add  hl, de
	ldi  [hl], a ; iWily3AnimPart / iWily3PartSprMapId
	
	;
	; Share to the Act_Wily3Part the pointer to Act_Wily3's iWily3AnimPart.
	; Act_Wily3Part will poll on this to know when to animate.
	;
	ldh  a, [hActCur+iWilyCtrl3PartAnimPtr]
	ld   [hl], a ; iWily3PartAnimPtr
	ret
	
;================ Act_RushCoil ================
; ID: ACT_WPN_RC
; Rush Coil helper item.
Act_RushCoil:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Helper_Teleport
	dw Act_RushCoil_WaitPl

;================ Act_RushCoil_WaitPl ================
Act_RushCoil_WaitPl:
	;
	; The timer is initially set to 3 seconds.
	; When 1 second remains, start flashing.
	;
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	cp   60
	jr   nc, .chkColi
	
	; Flash by alternating between frames $xx and $xx+08 every 4 frames.
	; In practice, the sprite ranges we end up with are $00-$01 and $08-$09.
	; $08 is a completely blank sprite mapping used for this flashing effect,
	; ??? whereas $09 is a copy of $01 for programming convenience, since it avoids 
	; us having to reset wActCurSprMapBaseId when spring collision happens.
	push af
		sla  a							; At double timer speed...
		and  %1000						; Every 8 frames... (/2)
		ld   [wActCurSprMapBaseId], a
	pop  af
	
	; If the timer fully elapsed, teleport out
	or   a
	jr   nz, .chkColi
	ld   a, AHW_WARPOUT_INITANIM
	ld   [wWpnHelperWarpRtn], a
	jp   ActS_DecRtnId		; Back to Act_Helper_Teleport
	
.chkColi:
	;
	; Check if Rush Coil should trigger.
	;
	
	; The player must have collided with this Rush Coil actor.
	; This collision is checked by Pl_DoActColi.markHelperColi, and only triggers if the player is falling on it.
	ld   a, [wActHelperColiSlotPtr]
	ld   b, a						; B = Helper actor the player fell on
	ld   a, [wActCurSlotPtr]		; A = Current actor
	cp   b							; Do they match?
	ret  nz							; If not, return (not collided with)
	
	; If Rush has already bounced the player up, don't do it again.
	ldh  a, [hActCur+iActSprMap]
	bit  3, a						; Is Rush's spring sprite used? ($01)
	ret  nz							; If so, return (already bounced up)
	
	or   $08						; Use spring sprite
	ldh  [hActCur+iActSprMap], a
	ld   a, PL_MODE_FULLJUMP		; Trigger player jump
	ld   [wPlMode], a
	ld   a, $04						; at 4.5px/frame
	ld   [wPlSpdY], a
	ld   a, $80
	ld   [wPlSpdYSub], a
	jp   WpnS_UseAmmo				; Use ammo for the trouble
	
;================ Act_RushMarine ================
; ID: ACT_WPN_RM
; Rush Marine helper item.
Act_RushMarine:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Helper_Teleport
	dw Act_RushMarine_ChkSpawnPos
	dw Act_RushMarine_WaitPl
	dw Act_RushMarine_Ride
	DEF ACTRTN_RUSHMARINE_TELEPORT = $00

;================ Act_RushMarine_ChkSpawnPos ================
; Determines if the location Rush Marine teleported into is viable.
; If it isn't, it will immediately teleport out before the player can get in.
Act_RushMarine_ChkSpawnPos:

	;
	; Not applicable if the level doesn't have any water to begin with
	;
	ld   a, [wLvlWater]
	or   a
	jr   z, .warpOut
	
	;
	; Rush must have fully landed on a water block (both top and bottom)
	;
.chkBottom:
	ldh  a, [hActCur+iActX]		; X Sensor: ActX (center)
	ld   [wTargetRelX], a
	ldh  a, [hActCur+iActY]		; Y Sensor: ActY (bottom)
	ld   [wTargetRelY], a
	call Lvl_GetBlockId			; A = Block ID
	cp   BLOCKID_WATER			; Is it a water block?
	jr   z, .chkTop				; If so, jump (ok)
	cp   BLOCKID_WATERSPIKE		; Is it an underwater spike?
	jr   nz, .warpOut			; If not, jump (fail)
.chkTop:
	ldh  a, [hActCur+iActY]		; Y Sensor: ActY - $0F (top of block)
	sub  BLOCK_V-1
	ld   [wTargetRelY], a
	call Lvl_GetBlockId			; Do the same block checks
	cp   BLOCKID_WATER
	jp   z, ActS_IncRtnId
	cp   BLOCKID_WATERSPIKE
	jp   z, ActS_IncRtnId
	
.warpOut:
	ld   a, AHW_WARPOUT_INITANIM	; Checks failed, start teleporting
	ld   [wWpnHelperWarpRtn], a
	jp   ActS_DecRtnId
	
;================ Act_RushMarine_WaitPl ================
; Waiting for the player to ride it.
; See also: Act_RushCoil_WaitPl
Act_RushMarine_WaitPl:

	; When 1 second remains, start flashing.
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	cp   60
	jr   nc, .chkColi
	
	; Flash every 4 frames.
	push af
		sla  a							; At double timer speed...
		and  %1000						; Every 8 frames... (/2)
		ld   [wActCurSprMapBaseId], a
	pop  af
	
	; If the timer fully elapsed, teleport out
	or   a
	jr   nz, .chkColi
	ld   a, AHW_WARPOUT_INITANIM
	ld   [wWpnHelperWarpRtn], a
	ld   a, ACTRTN_RUSHMARINE_TELEPORT
	ldh  [hActCur+iActRtnId], a
	ret
	
.chkColi:
	;
	; Check if Rush Marine should trigger.
	;
	
	; The player must have collided with this Rush Marine actor.
	ld   a, [wActHelperColiSlotPtr]
	ld   b, a						; B = Helper actor the player fell on
	ld   a, [wActCurSlotPtr]		; A = Current actor
	cp   b							; Do they match?
	ret  nz							; If not, return (not collided with)
	
	; Initialize momentum variables
	xor  a
	ld   [wPlRmSpdL], a
	ld   [wPlRmSpdR], a
	ld   [wPlRmSpdU], a
	ld   [wPlRmSpdD], a
	
	; Teleport the Rush Marine at the player's X position
	ld   a, [wPlRelX]
	ldh  [hActCur+iActX], a
	; Inconsistently, do the opposite with the Y position
	ldh  a, [hActCur+iActY]
	ld   [wPlRelY], a
	; Enter the ride state. This will hide the normal player sprite, only drawing Rush Marine.
	ld   a, PL_MODE_RM
	ld   [wPlMode], a
	jp   ActS_IncRtnId
	
;================ Act_RushMarine_Ride ================
; Player is riding it.
; This mostly handles drawing the sprite, while the controls are by PlMode_RushMarine.
Act_RushMarine_Ride:
	; Animate propeller (use frames $xx-$xx+1 at 1/8 speed)
	ld   c, $01
	call ActS_Anim2
	
	;
	; Flashing after getting hit, in differenr ways depending on how long has passed.
	; Keep in mind the Rush Marine ride state does not handle the hurt state at all,
	; so the player can keep moving Rush as normal during this.
	;
	; The sprite mappings for Rush Marine are grouped in pairs, since the propeller animation
	; is always done even when flashing, which may offset by 1 the result:
	;
	; ...
	; $08-$09: Hidden
	; $0A-$0B: Normal
	; $0C-$0D: Flashing (OBP1)
	; 
	
	;
	; Immediately after getting hurt, start flashing Rush Marine's palette every 2 frames.
	; This is done by alternating between sprite mappings $0A-$0B (normal) and $0C-$0D (inverted),
	; not by simply updating the sprite's palette (which isn't possible with the current system).
	;
.chkHurt:
	ld   a, [wPlHurtTimer]
	or   a					; Player got hurt?
	jr   z, .chkInvuln		; If not, skip
	ldh  a, [hTimer]		
	and  $02				; Each set has 2 sprites; this also causes the flashing to happen every 2 frames
	add  $0A				; Use $0A-0B (normal) or $0C-$0D (OBP1)
	jr   .setSpr
.chkInvuln:
	;
	; If the player is in mercy invulnerability, flash by hiding the sprite every 2 frames.
	;
	ld   a, [wPlInvulnTimer]
	or   a					; Player is invulnerable?
	jr   z, .noFlash		; If not, skip
	ldh  a, [hTimer]
	and  $02				; ...
	add  $08				; Use $08-09 (hide) or $0A-$0B (normal)
	jr   .setSpr
.noFlash:
	; Otherwise, display the normal sprites
	ld   a, $0A				; Use $0A-$0B
	
.setSpr:
	ld   [wActCurSprMapBaseId], a	; Apply sprite
	ld   a, [wPlRelX]				; Sync Rush Marine with player's position (latter set by PlMode_RushMarine)
	ldh  [hActCur+iActX], a
	ld   a, [wPlRelY]
	ldh  [hActCur+iActY], a
	
	; Face the same direction as the player
	ld   a, [wPlDirH]				; Get player direction (DIR_L or DIR_R, bit0)
	rrca 							; Shift to bit7
	and  ACTDIR_R					; Filter out other bits
	ld   b, a						; to B
	ldh  a, [hActCur+iActSprMap]	; Get actor sprite info
	and  $FF^ACTDIR_R				; Delete horizontal direction flag
	or   b							; Replace with the player's
	ldh  [hActCur+iActSprMap], a	; Save back
	
	;
	; Ammo consumption rate: every 1 unit / 16 frames (1 bar / ~2 seconds).
	; Once it's fully consumed, kick the player out.
	;
	; [POI] This address is only initialized when the level starts and never again.
	;       This can be theoretically used to avoid consuming weapon ammo by switching 
	;       out just in time and letting another weapon underflow the timer, in practice
	;       it's pointless and annoying to do.
	ld   a, [wWpnHelperUseTimer]	; Timer -= $10
	sub  $10
	ld   [wWpnHelperUseTimer], a
	call c, WpnS_UseAmmo			; Underflowed? If so, use it
	
	ld   a, [wWpnAmmoCur]
	or   a							; Any ammo left?
	ret  nz							; If so, return
	xor  a ; PL_MODE_GROUND			; Otherwise, force player out of the ride
	ld   [wPlMode], a
	ld   a, AHW_WARPOUT_INITANIM	; and teleport Rush out
	ld   [wWpnHelperWarpRtn], a
	ld   a, ACTRTN_RUSHMARINE_TELEPORT
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_RushJet ================
; ID: ACT_WPN_RJ
; Rush Jet helper item.
Act_RushJet:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Helper_Teleport
	dw Act_RushJet_ChkSpawnPos
	dw Act_RushJet_WaitPl
	dw Act_RushJet_Ride
	DEF ACTRTN_RUSHJET_TELEPORT = $00

;================ Act_RushJet_ChkSpawnPos ================
; Determines if the location Rush Jet teleported into is viable.
; If it isn't, it will immediately teleport out before the player can get in.
Act_RushJet_ChkSpawnPos:

	ld   a, [wLvlWater]
	or   a					; Does the level have water?
	jr   z, .ok				; If not, skip checks (Act_Helper_Teleport already checked for solid blocks)
	
	; Rush must not have landed on a water block
	ldh  a, [hActCur+iActX]		; X Sensor: ActX (center)
	ld   [wTargetRelX], a
	ldh  a, [hActCur+iActY]		; Y Sensor: ActY (bottom)
	ld   [wTargetRelY], a
	call Lvl_GetBlockId			; A = Block ID
	cp   BLOCKID_WATER			; Is it a water block?
	jr   z, .warpOut			; If so, jump (fail)
	cp   BLOCKID_WATERSPIKE		; Is it an underwater spike?
	jr   z, .warpOut			; If so, jump (fail)
.ok:
	jp   ActS_IncRtnId
.warpOut:
	ld   a, AHW_WARPOUT_INITANIM
	ld   [wWpnHelperWarpRtn], a
	jp   ActS_DecRtnId
	
;================ Act_RushJet_WaitPl ================
; Waiting for the player to stand on it.
Act_RushJet_WaitPl:

	; When 1 second remains, start flashing.
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	cp   60
	jr   nc, .chkColi
	
	; Flash every 4 frames.
	push af
		sla  a							; At double timer speed...
		and  %1000						; Every 8 frames... (/2)
		ld   [wActCurSprMapBaseId], a
	pop  af
	
	; If the timer fully elapsed, teleport out
	or   a
	jr   nz, .chkColi
	ld   a, AHW_WARPOUT_INITANIM
	ld   [wWpnHelperWarpRtn], a
	ld   a, ACTRTN_RUSHJET_TELEPORT
	ldh  [hActCur+iActRtnId], a
	ret
	
.chkColi:
	;
	; Check if Rush Jet should trigger.
	;
	
	; The player must have collided with this Rush Jet actor.
	ld   a, [wActCurSlotPtr]
	ld   b, a						; B = Current actor
	ld   a, [wActHelperColiSlotPtr]	; A = Helper actor the player fell on
	cp   b							; Do they match?
	ret  nz							; If not, return (not collided with)
	
	; When the player is on Rush Jet, move at 1px/frame in any direction
	ld   bc, $0100
	call ActS_SetSpeedX
	ld   bc, $0100
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
;================ Act_RushJet_Ride ================
; Player is riding it.
;
; Rush Jet is simply a top solid platform that follows the player, whose height can be controlled while standing.
; The normal player modes and the Rush Jet actor collision code handle the rest, with very few RJ-specific checks in place:
; - Skipping the walk cycle when moving
; - Preventing sliding on Rush Jet, mainly to prevent falling off as the slide is faster than Rush Jet.
Act_RushJet_Ride:

	;
	; HORIZONTAL MOVEMENT
	;
	
	;
	; Always try to move Rush Jet at the player's horizontal position.
	; When standing on it, this is what allows to keep it in sync with the player's movement,
	; it's also the *only* part that's even done when not standing on it, with its speed 
	; allowing it to catch up as long as the player isn't sliding.
	;
	; By *only* part, we really mean it. Everything else is skipped, including the check
	; that makes it use up ammo, ala RM3 Rush Jet.
	;
	call ActS_GetPlDistanceX
	or   a							; DiffX == 0?
	jr   z, .chkStand				; If so, skip (we're precisely 
	call ActS_FacePl				; Move towards the player
	call ActS_ApplySpeedFwdXColi	; at 1px/frame, stopping on solid blocks
	
.chkStand:
	; Do the rest only if the player is standing on it
	ld   a, [wActCurSlotPtr]
	ld   b, a
	ld   a, [wActPlatColiSlotPtr]
	cp   b
	ret  nz
	
	;
	; VERTICAL MOVEMENT
	;
	
	; Do the checks by shifting the topmost KEY_* bits to the carry, one by one.
	ldh  a, [hJoyKeys]
	;--
	rla ; KEY_DOWN				; Holding DOWN?
	jr   nc, .chkMoveU			; If not, skip
.moveD:
	; If we touch the bottom of the screen, teleport out.
	ldh  a, [hActCur+iActY]
	cp   OBJ_OFFSET_Y+SCREEN_GAME_V	; iActY > $90?
	jr   nc, .teleport				; If so, jump
	
	; Prevent moving towards water
	ld   a, [wLvlWater]
	or   a						; Level supports water?
	jr   z, .okMoveD			; If not, jump (ok)
	ldh  a, [hActCur+iActX]		; X Sensor: ActX (center)
	ld   [wTargetRelX], a
	ldh  a, [hActCur+iActY]		; Y Sensor: ActY + 1 (ground)
	inc  a
	ld   [wTargetRelY], a
	call Lvl_GetBlockId			; A = Block ID
	cp   BLOCKID_WATER			; Is it a water block?
	jr   z, .chkAmmo			; If so, jump (fail)
	cp   BLOCKID_WATERSPIKE		; Is it an underwater spike?
	jr   z, .chkAmmo			; If so, jump (fail)
.okMoveD:
	; Confirm downwards movement at 1px/frame
	ldh  a, [hActCur+iActSprMap]
	or   ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	call ActS_ApplySpeedFwdYColi
	jr   .chkAmmo
	;--
	
.chkMoveU:
	rla ; KEY_UP				; Holding UP?
	jr   nc, .chkAmmo			; If not, skip
.moveU:
	; If we're near the top of the screen, prevent moving further up
	ld   a, [wPlRelY]
	cp   OBJ_OFFSET_Y+$08	; iActY < $18?
	jr   c, .chkAmmo		; If so, jump
	
	; Prevent moving up if there's a solid block above, using the same collision box
	; as the player, except taller.
	
	sub  (PLCOLI_V*2)		; Y Sensor: ActY - $18 (above the player)
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]		; X Sensor: ActX - $06 (left)
	sub  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; Is the block solid?
	jr   nc, .chkAmmo		; If so, jump (don't move)
	
	ld   a, [wPlRelX]		; X Sensor: ActX + $06 (right)
	add  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; Is the block solid?
	jr   nc, .chkAmmo		; If so, jump (don't move)
.okMoveU:
	; Confirm upwards movement at 1px/frame
	ldh  a, [hActCur+iActSprMap]
	and  $FF^ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	call ActS_ApplySpeedFwdY
	;--
.chkAmmo:

	;
	; Ammo consumption rate: every 1 unit / 8 frames (1 bar / ~1 second).
	; Once it's fully consumed, teleport out, making the player fall down.
	;
	ld   a, [wWpnHelperUseTimer]	; Timer -= $20
	sub  $20
	ld   [wWpnHelperUseTimer], a
	call c, WpnS_UseAmmo			; Underflowed? If so, use it
	
	ld   a, [wWpnAmmoCur]
	or   a							; Any ammo left?
	ret  nz							; If so, return
.teleport:
	ld   a, AHW_WARPOUT_INITANIM	; Otherwise, teleport out
	ld   [wWpnHelperWarpRtn], a
	ld   a, ACTRTN_RUSHJET_TELEPORT
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_Sakugarne ================
; ID: ACT_WPN_SG
; Sakugarne helper item.
Act_Sakugarne:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Helper_Teleport
	dw Act_Sakugarne_WaitPl
	dw Act_Sakugarne_WaitGfxLoad
	dw Act_Sakugarne_Ride
	DEF ACTRTN_SAKUGARNE_TELEPORT = $00
	
;================ Act_Sakugarne_WaitPl ================
; Waiting for the player to ride it.
; See also: Act_RushCoil_WaitPl
Act_Sakugarne_WaitPl:

	; When 1 second remains, start flashing.
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	cp   60
	jr   nc, .chkColi
	
	; Flash every 4 frames.
	push af
		sla  a							; At double timer speed...
		and  %1000						; Every 8 frames... (/2)
		ld   [wActCurSprMapBaseId], a
	pop  af
	
	; If the timer fully elapsed, teleport out
	or   a
	jr   nz, .chkColi
	ld   a, AHW_WARPOUT_INITANIM
	ld   [wWpnHelperWarpRtn], a
	jp   ActS_DecRtnId
	
.chkColi:
	;
	; Check if the Sakugarne should trigger.
	;
	
	; The player must have collided with this actor.
	ld   a, [wActHelperColiSlotPtr]
	ld   b, a						; B = Helper actor the player fell on
	ld   a, [wActCurSlotPtr]		; A = Current actor
	cp   b							; Do they match?
	ret  nz							; If not, return (not collided with)
	
	;
	; Player fell on the Sakugarne.
	;
	; Like when riding the Rush Marine, the normal player sprite is hidden, with the actor being
	; drawn with the player's graphics baked in, to save up on the amount of sprites drawn.
	;
	; However, keeping the playerless and w/player Sakugarne graphics loaded at the same time 
	; is a waste and also not possible, as in total they'd go over the 16 tile limit for weapon art sets.
	; Therefore, those two variations take up two separate sets, and we have to load the 2nd one.
	;
	
	; Since we're loading new GFX while the actor is onscreen, we have to hide it temporarily,
	; as long as it needs for the graphics to fully load.
	ld   a, $01
	call ActS_SetSprMapId
	
	; Start GFX load request
	ld   hl, GFX_Wpn_SgRide ; Source GFX ptr
	ld   de, $8500 ; VRAM Destination ptr (2nd set)
	ld   bc, (BANK(GFX_Wpn_SgRide) << 8) | $10 ; Source GFX bank number + Number of tiles to copy
	call GfxCopy_Req
	
	; Graphics are loaded 4 tiles/frame, so loading 16 tiles will take up 4 frames.
	ld   a, $04
	ldh  [hActCur+iActTimer0C], a
	
	jp   ActS_IncRtnId
	
;================ Act_Sakugarne_WaitGfxLoad ================
; Sets up the ride state.
Act_Sakugarne_WaitGfxLoad:
	; Wait 4 frames while the GFX set hopefully loads.
	; During this time the normal player sprite will still be visible.
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Same inconsistency as Rush Marine
	ld   a, [wPlRelX]			; ActX = PlX
	ldh  [hActCur+iActX], a
	ldh  a, [hActCur+iActY]		; PlY = ActY
	ld   [wPlRelY], a
	; The Sakugarne controls are handled by PL_MODE_GROUND and PL_MODE_FULLJUMP only.
	xor  a ; PL_MODE_GROUND
	ld   [wPlMode], a
	; Flag the Sakugarne as being riden.
	; This will hide the normal player sprite.
	inc  a
	ld   [wWpnSGRide], a		; wWpnSGRide = 1
	jp   ActS_IncRtnId
	
;================ Act_Sakugarne_Ride ================
; Player is riding it.
; Purely handles drawing the sprite and the ridiculous ammo usage.
Act_Sakugarne_Ride:
	; Sync Sakugarne with player's position
	ld   a, [wPlRelX]
	ldh  [hActCur+iActX], a
	ld   a, [wPlRelY]
	ldh  [hActCur+iActY], a
	
	; If we touch the bottom of the screen, teleport out.
	cp   OBJ_OFFSET_Y+SCREEN_GAME_V	; iActY > $90?
	jr   nc, .teleport				; If so, jump
	
	; Ammo consumption rate: every 1 unit / 4 frames (1 bar / ~half a second).
	ld   a, [wWpnHelperUseTimer]	; Timer -= $40
	sub  $40
	ld   [wWpnHelperUseTimer], a
	call c, WpnS_UseAmmo			; Underflowed? If so, use it
	
	ld   a, [wWpnAmmoCur]
	or   a							; Any ammo left?
	ret  nz							; If so, return
.teleport:
	xor  a ; PL_MODE_GROUND
	ld   [wPlMode], a				; Cut early any jump
	ld   [wWpnSGRide], a			; Disable ride mode & draw normal player sprite
	ld   a, AHW_WARPOUT_INITANIM	; Teleport the Sakugarne out
	ld   [wWpnHelperWarpRtn], a
	ld   a, ACTRTN_SAKUGARNE_TELEPORT
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_Helper_Teleport ================
; Routine shared by all helper item actors (Rush, Sakugarne), handles teleporting in and out.
Act_Helper_Teleport:
	ld   a, [wWpnHelperWarpRtn]
	dec  a
	rst  $00 ; DynJump
	dw Act_Helper_TeleportIn_Init
	dw Act_Helper_TeleportIn_MoveD
	dw Act_Helper_TeleportIn_MoveDChkSpawn
	dw Act_Helper_TeleportIn_Anim
	dw Act_Helper_TeleportIn_ChkSolid
	dw Act_Helper_TeleportOut_InitAnim
	dw Act_Helper_TeleportOut_Anim
	dw Act_Helper_TeleportOut_MoveU

;================ Act_Helper_TeleportIn_Init ================
; Teleport in - initialize.
Act_Helper_TeleportIn_Init:
	; Use teleport sprite $02.
	; By convention, all helper items need to define it there.
	ld   a, $02
	call ActS_SetSprMapId
	
	; Reset gravity in preparation of falling from the top of the screen
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	
	; Next mode
	ld   hl, wWpnHelperWarpRtn
	inc  [hl]
	
	;--
	; The Sakugarne uses two sets of graphics, one without the player, the other with the player baked in.
	; It is possible to spawn one while the 2nd set is loaded, so to be sure force load the 1st set.
	; See also: Act_Sakugarne_WaitPl
	
	ld   a, [wWpnId]
	cp   WPN_SG			; Are we using the Sakugarne?
	ret  nz				; If not, return
	
	; Otherwise, request the loading.
	; It will take 2 frames, which is well ahead of our limit given the teleport animation uses shared graphics.
	ld   hl, GFX_Wpn_Sg ; Source GFX ptr
	ld   de, $8500 ; VRAM Destination ptr (2nd set)
	ld   bc, (BANK(GFX_Wpn_Sg) << 8) | $08 ; Source GFX bank number + Number of tiles to copy
	jp   GfxCopy_Req
	;--
	
;================ Act_Helper_TeleportIn_MoveD ================
; Teleport in - move down.
Act_Helper_TeleportIn_MoveD:
	; Move down until it reaches 24px above the player.
	; This is a common threshold applicable for all helpers.
	call ActS_ApplySpeedDownY
	ldh  a, [hActCur+iActY]	; B = ActX
	ld   b, a
	ld   a, [wPlRelY]		; A = PlX - 24
	sub  $18
	cp   b					; Player is below the actor? (PlX - 24 > ActX)
	ret  nc					; If so, keep moving down
	
	; Otherwise, start the ground anim
	ld   hl, wWpnHelperWarpRtn
	inc  [hl]
	ret
	
;================ Act_Helper_TeleportIn_MoveDChkSpawn ================
; Teleport in - move down and check if the helper is viable to spawn at the current position.
; This will continue moving down the actor until the checks pass or it moves below the level.
Act_Helper_TeleportIn_MoveDChkSpawn:

	;
	; If the actor has reached below the level, teleport out on the spot.
	; This can be easily noticed by attempting to spawn something while facing a solid wall.
	;
	ldh  a, [hActCur+iActY]
	cp   OBJ_OFFSET_Y+SCREEN_GAME_V		; iActY < $90?
	jr   c, .chkRc						; If so, keep trying
	
	ld   a, AHW_WARPOUT_INITANIM			; Otherwise, teleport out
	ld   [wWpnHelperWarpRtn], a
	ret
	
	;
	; Depending on the helper we're spawning, check for something different.
	;
.chkRc:
	ld   a, [wWpnId]
	cp   WPN_RC						; Spawned Rush Coil?
	jr   nz, .chkRm					; If not, jump
	
	; Continue moving down until a solid block is hit
	call ActS_ApplySpeedDownYColi
	ret  c
	; When reached, advance to the next routine
	ld   a, $00						; Init anim
	ldh  [hActCur+iActTimer0C], a
	ld   hl, wWpnHelperWarpRtn		; Next mode
	inc  [hl]
	ret
	
.chkRm:
	cp   WPN_RM						; Spawned Rush Marine?
	jr   nz, .chkRj					; If not, jump
	
	; Continue moving down until the actor reaches the player
	call ActS_ApplySpeedDownY
	ldh  a, [hActCur+iActY]			; B = ActY
	ld   b, a
	ld   a, [wPlRelY]				; A = PlY
	cp   b							; Player is below the actor? (PlY > ActY)
	ret  nc							; If so, keep moving down
	
	ldh  [hActCur+iActY], a			; Otherwise, align with player position
	ld   a, $00						; Init anim
	ldh  [hActCur+iActTimer0C], a
	ld   hl, wWpnHelperWarpRtn		; Next mode
	inc  [hl]
	ret
	
.chkRj:
	; Identical to Rush Marine
	cp   WPN_RJ						; Spawned Rush Jet?
	jr   nz, .chkSg					; If not, jump
	
	; Continue moving down until the actor reaches the player
	call ActS_ApplySpeedDownY
	ldh  a, [hActCur+iActY]			; B = ActY
	ld   b, a
	ld   a, [wPlRelY]				; A = PlY
	cp   b							; Player is below the actor? (PlY > ActY)
	ret  nc							; If so, keep moving down
	
	ldh  [hActCur+iActY], a			; Otherwise, align with player position
	ld   a, $00						; Init anim
	ldh  [hActCur+iActTimer0C], a
	ld   hl, wWpnHelperWarpRtn		; Next mode
	inc  [hl]
	ret
.chkSg:
	; Otherwise, assume the Sakugarne (WPN_SG)
	; Identical to Rush Coil
	
	; Continue moving down until a solid block is hit
	call ActS_ApplySpeedDownYColi
	ret  c
	; When reached, advance to the next routine
	ld   a, $00						; Init anim
	ldh  [hActCur+iActTimer0C], a
	ld   hl, wWpnHelperWarpRtn		; Next mode
	inc  [hl]
	ret
	
;================ Act_Helper_TeleportIn_Anim ================
; Teleport in - ground animation
Act_Helper_TeleportIn_Anim:
	ldh  a, [hActCur+iActTimer0C]	; Timer++
	add  $01
	ldh  [hActCur+iActTimer0C], a
	
	; Starting from a pre-incremented $00, this will animate from $00 to $05
	srl  a							; SprMapId = Timer / 2 
	ld   [wActCurSprMapBaseId], a
	cp   $05						; SprMapId == 5?
	ret  nz							; If not, return

	ld   hl, wWpnHelperWarpRtn		; Next mode
	inc  [hl]
	ret
	
;================ Act_Helper_TeleportIn_ChkSolid ================
; Teleport in - solid ground check.
Act_Helper_TeleportIn_ChkSolid:
	ld   a, $05						; Stay on sprite $05 while checking
	ld   [wActCurSprMapBaseId], a
	
	; LEFT SIDE
	ldh  a, [hActCur+iActY]			; Y Sensor: ActY - 4 (low)
	sub  $04
	ld   [wTargetRelY], a
	ldh  a, [hActCur+iActX]			; X Sensor: ActX - 8 (left)
	sub  $08
	ld   [wTargetRelX], a
	call Lvl_GetBlockId				; Is there an empty block there?
	jr   nc, .warpOut				; If not, teleport out
	
	; RIGHT SIDE
	ldh  a, [hActCur+iActX]			; X Sensor: ActX + 8 (right)
	add  $08
	ld   [wTargetRelX], a
	call Lvl_GetBlockId				; Is there an empty block there?
	jr   nc, .warpOut				; If not, teleport out
	
.ok:
	; Checks passed!
	ld   a, $00						; Return to normal sprite
	call ActS_SetSprMapId
	call ActS_FacePl				; Face the opposite side as the player. As it's spawned in front, 
	call ActS_FlipH					; typically this causes it to face the same direction as the player.
	
	ld   a, AHW_ACTIVE				; Mark helper item as active
	ld   [wWpnHelperWarpRtn], a
	ld   a, SFX_TELEPORTIN			; PLay landing sound
	ldh  [hSFXSet], a
	ld   a, 60*3					; If the player doesn't interact within 3 seconds, automatically teleport it out
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
.warpOut:
	; If we got here, a solid block was in the way, so teleport out immediately.
	; For what's worth, as this is done after doing the ground animation, it will
	; look slightly different compared to teleport from moving below the level.
	ld   hl, wWpnHelperWarpRtn
	inc  [hl]
	ret
	
;================ Act_Helper_TeleportOut_InitAnim ================
; Teleport out - ground animation init. 
Act_Helper_TeleportOut_InitAnim:
	ld   a, $02					; Use normal teleport sprite
	call ActS_SetSprMapId
	ld   a, $0A					; Wait 8 frames (see below)
	ldh  [hActCur+iActTimer0C], a
	ld   a, $05					; Start from sprite $05
	ld   [wActCurSprMapBaseId], a
	ld   hl, wWpnHelperWarpRtn	; Next mode
	inc  [hl]
	ret
	
;================ Act_Helper_TeleportOut_Anim ================
; Teleport out - ground animation. 
Act_Helper_TeleportOut_Anim:
	ldh  a, [hActCur+iActTimer0C]	; Timer--
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	
	; Starting from a pre-decremented $0A, this will animate from $04 to $01
	srl  a							; SprMapId = Timer / 2 
	ld   [wActCurSprMapBaseId], a
	or   a							; SprMapId == 0?
	ret  nz							; If not, return
	
	ld   a, $02						; Use normal teleport sprite $02
	call ActS_SetSprMapId
	
	ldh  a, [hActCur+iActSprMap]	; Move up at 4px/frame
	and  $FF^ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	ld   bc, $0400
	call ActS_SetSpeedY
	ld   a, SFX_TELEPORTOUT			; Play teleport sound
	ldh  [hSFXSet], a
	ld   hl, wWpnHelperWarpRtn		; Next mode
	inc  [hl]
	ret
	
;================ Act_Helper_TeleportOut_MoveU ================
; Teleport out - moving up. 
Act_Helper_TeleportOut_MoveU:
	; Continue moving up until we reach the top of the screen
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActY]
	cp   OBJ_OFFSET_Y		; iActY >= $10?
	ret  nc					; If so, return
	; Then despawn and flag that there's no helper actor active
	xor  a
	ldh  [hActCur+iActId], a
	ld   [wWpnHelperWarpRtn], a
	ret
	
;================ Act_Bubble ================
; ID: ACT_BUBBLE
; Air bubble spawned by the player when underwater.
Act_Bubble:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Bubble_Init
	dw Act_Bubble_MoveU
	dw Act_Bubble_Pop

;================ Act_Bubble_Init ================
Act_Bubble_Init:
	ld   bc, $0080			; 0.5px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0080			; 0.5px/frame up
	call ActS_SetSpeedY
	
	; Randomize time before turning the first time.
	call Rand					; iActTimer0C = (Rand & $F7) + $0F
	and  $FF^$08
	add  $0F
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_Bubble_MoveU ================
Act_Bubble_MoveU:
	; Turn horizontally every ~half a second
	ldh  a, [hActCur+iActTimer0C]	; iActTimer0C++
	add  $01
	ldh  [hActCur+iActTimer0C], a
	and  $1F						; Timer % $20 != 0?
	call z, ActS_FlipH				; If so, turn around
	
	; Move forward 0.5px/frame, turning if a solid wall is hit
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	
	; Move up 0.5px/frame
	call ActS_ApplySpeedFwdY
	
	; Continue doing the above until we exit out of a water block.
	; Typically this happens when the bubble hits the "ceiling" or a water surface.
	ldh  a, [hActCur+iActX]		; X Target: ActX (center)
	ld   [wTargetRelX], a
	ldh  a, [hActCur+iActY]		; Y Target: ActY (bottom)
	ld   [wTargetRelY], a
	;--
	; [BUG] But why? The only reason this is typically unnoticed is that
	;       there usually are empty blocks above water ones.
	call Lvl_GetBlockId			; Is there a solid block?
	ret  nc						; If so, return
	;--
	cp   BLOCKID_WATER			; Is it a water block?
	ret  z						; If so, return
	cp   BLOCKID_WATERSPIKE		; Is it an underwater spike?
	ret  z						; If so, return
	
	; Then pop it. Show popped sprite for 8 frames
	ld   a, $01
	call ActS_SetSprMapId
	ld   a, $08
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_Bubble_Pop ================
Act_Bubble_Pop:
	; Wait those 8 frames...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Then despawn
	xor  a
	ldh  [hActCur+iActId], a
	ret
	
;================ Act_WilyCastleCutscene ================
; ID: ACT_WILYCASTLESC
; There's actually no code for this, it's only used to draw Wily's sprite (and load his GFX when the room loads).
; This actor's animation is directly handled by WilyCastle_DoCutscene, which also uses pseudo-gameplay to move the player.
Act_WilyCastleCutscene:
	ret
	
;================ Act_TeleporterRoom ================
; ID: ACT_TELEPORTCTRL
; This actor controls all four teleporters inside Wily's Castle.
Act_TeleporterRoom:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_TeleporterRoom_SpawnLights
	dw Act_TeleporterRoom_WaitPl

;================ Act_TeleporterRoom_SpawnLights ================
; Spawns flashing lights above active teleporters.
; These lights are purely a visual effect, teleporting is done by this actor.
Act_TeleporterRoom_SpawnLights:

	ld   b, $00								; B = Coords ID (top-left)
	ld   a, [wWpnUnlock0]
	and  WPU_HA								; Cleared Hard Man's stage?
	call z, Act_TeleporterRoom_SpawnLight	; If not, flash a light there
	
	ld   b, $01								; B = Top-right
	ld   a, [wWpnUnlock0]
	and  WPU_TP								; Cleared Top Man's stage?
	call z, Act_TeleporterRoom_SpawnLight	; ...
	
	ld   b, $02								; B = Bottom-left
	ld   a, [wWpnUnlock0]
	and  WPU_MG								; Cleared Magnet Man's stage?
	call z, Act_TeleporterRoom_SpawnLight	; ...
	
	ld   b, $03								; B = Bottom-right
	ld   a, [wWpnUnlock0]
	and  WPU_NE								; Cleared Needle Man's stage?
	call z, Act_TeleporterRoom_SpawnLight	; ...
	
	jp   ActS_IncRtnId
	
;================ Act_TeleporterRoom_WaitPl ================
; Waits for the player to enter a teleporter.
Act_TeleporterRoom_WaitPl:
	; If we're already in the middle of teleporting, don't retrigger it again
	ld   a, [wLvlWarpDest]
	or   a
	ret  nz
	
	;
	; Determine if the player is overlapping with any teleporter.
	; The teleporters trigger when precisely on the ground within 24px from the edge of the screen.
	;
	
	ld   a, [wPlRelX]	; B = PlX
	ld   b, a
	ld   a, [wPlRelY]	; C = PlY
	ld   c, a
	
.chkU:
	cp   OBJ_OFFSET_Y+$2F	; PlY == $3F? (standing on 4th block)
	jr   nz, .chkD			; If not, jump
	
.chkUL:
	; TOP-LEFT SECTION / HARD MAN (Y Pos: $3F, X Pos: < $20)
	ld   a, b
	cp   OBJ_OFFSET_X+$18	; PlX >= $20?
	jr   nc, .chkUR			; If so, check the right one
	
	ld   a, [wWpnUnlock0]
	and  WPU_HA				; Hard Man stage cleared?
	ret  nz					; If so, return
	
	ld   a, LVLEND_TLPHARD	; Otherwise, teleport there
	ld   [wLvlWarpDest], a
	ld   a, PL_MODE_TLPINIT
	ld   [wPlMode], a
	ret
	
.chkUR:
	; TOP-RIGHT SECTION / TOP MAN (Y Pos: $3F, X Pos: >= $90)
	ld   a, b
	cp   OBJ_OFFSET_X+SCREEN_GAME_H-$18	; PlX < $90?
	ret  c								; If so, return
	
	ld   a, [wWpnUnlock0]
	and  WPU_TP				; Top Man stage cleared?
	ret  nz					; If so, return
	ld   a, LVLEND_TLPTOP
	ld   [wLvlWarpDest], a
	ld   a, PL_MODE_TLPINIT
	ld   [wPlMode], a
	ret
	
.chkD:
	ld   a, c
	cp   OBJ_OFFSET_Y+$6F	; PlY == $7F? (standing on 8th block)
	ret  nz					; If not, return (no teleporter touched)
	
.chkDL:
	; BOTTOM-LEFT SECTION / MAGNET MAN (Y Pos: $7F, X Pos: < $20)
	ld   a, b
	cp   OBJ_OFFSET_X+$18	; PlX >= $20?
	jr   nc, .chkDR			; If so, check the right one
	
	ld   a, [wWpnUnlock0]
	and  WPU_MG				; Magnet Man stage cleared?
	ret  nz					; If so, return
	
	ld   a, LVLEND_TLPMAGNET	; Otherwise, teleport there
	ld   [wLvlWarpDest], a
	ld   a, PL_MODE_TLPINIT
	ld   [wPlMode], a
	ret
	
.chkDR:
	; BOTTOM-RIGHT SECTION / NEEDLE MAN (Y Pos: $7F, X Pos: >= $90)
	ld   a, b
	cp   OBJ_OFFSET_X+SCREEN_GAME_H-$18	; PlX < $90?
	ret  c								; If so, return
	
	ld   a, [wWpnUnlock0]
	and  WPU_NE				; Needle Man stage cleared?
	ret  nz					; If so, return
	ld   a, LVLEND_TLPNEEDLE
	ld   [wLvlWarpDest], a
	ld   a, PL_MODE_TLPINIT
	ld   [wPlMode], a
	ret

;================ Act_TeleporterRoom_SpawnLight ================
; Spawns a light, marking an active teleporter.
; IN
; - B: Light ID, determines position
Act_TeleporterRoom_SpawnLight:

	; HL = Act_TeleporterRoom_LightPosTbl[B*2]
	ld   a, b
	add  a
	ld   hl, Act_TeleporterRoom_LightPosTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	
	; Read out the coordinates from there
	ldi  a, [hl]
	ld   [wActSpawnX], a
	ld   a, [hl]
	ld   [wActSpawnY], a
	
	; Not part of the actor layout
	xor  a
	ld   [wActSpawnLayoutPtr], a
	
	ld   a, ACT_TELEPORTLIGHT
	ld   [wActSpawnId], a
	jp   ActS_Spawn
	
;================ Act_TeleporterRoom_LightPosTbl ================
; Coordinates for the lights, by teleporter number.
Act_TeleporterRoom_LightPosTbl:
	;                 X                 Y
	db OBJ_OFFSET_X+$14, OBJ_OFFSET_Y+$08 ; $00 (top-left, Hard)
	db OBJ_OFFSET_X+$84, OBJ_OFFSET_Y+$08 ; $01 (top-right, Top)
	db OBJ_OFFSET_X+$14, OBJ_OFFSET_Y+$48 ; $02 (bottom-left, Magnet)
	db OBJ_OFFSET_X+$84, OBJ_OFFSET_Y+$48 ; $03 (bottom-right, Needle)

;================ Act_TeleporterLight ================
; ID: ACT_TELEPORTLIGHT
; Flashing light above active teleporters.
Act_TeleporterLight:
	; Use frames $00-$01 at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	ret
	
;================ Act_HardMan ================
; ID: ACT_HARDMAN
; First of the eight normal bosses.
Act_HardMan:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BossIntro
	dw Act_HardMan_InitPunchAnim
	dw Act_HardMan_PlayPunchAnim
	dw Act_HardMan_ThrowFist
	dw Act_HardMan_ThrowFist
	dw Act_HardMan_InitJump
	dw Act_HardMan_JumpU
	dw Act_HardMan_JumpD
	dw Act_HardMan_InitDropAnim
	dw Act_HardMan_PlayDropAnim
	dw Act_HardMan_Drop
	dw Act_HardMan_Shake
	dw Act_HardMan_InitRise
	dw Act_HardMan_RiseU
	dw Act_HardMan_RiseD
	dw Act_HardMan_Cooldown
	DEF ACTRTN_HARDMAN_INTRO = $00
	DEF ACTRTN_HARDMAN_INITDROPANIM = $08
	DEF ACTRTN_HARDMAN_SHAKE = $0B

;================ Act_HardMan_InitPunchAnim ================
; Set up fist throwing animation.
Act_HardMan_InitPunchAnim:
	; Already done by ActS_InitAnimRange
	ld   a, $00
	ldh  [hActCur+iActTimer0C], a
	
	; Throw the first towards the player
	call ActS_FacePl
	
	; Use sprites $00-$03 at 1/12 speed
	ld   de, ($00 << 8)|$03
	ld   c, $0C
	call ActS_InitAnimRange
	
	jp   ActS_IncRtnId
	
;================ Act_HardMan_PlayPunchAnim ================
; Plays the first throwing animation.
Act_HardMan_PlayPunchAnim:
	; Wait for it to finish first
	call ActS_PlayAnimRange			; Is it over?
	ret  z							; If not, return
	
	ld   a, $00						; Reset anim timer
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_HardMan_ThrowFist ================
; Throws a fist.
; Executed twice in a row to throw two of them.
Act_HardMan_ThrowFist:
	; Always throw them towards the player, even if they try to pass through.
	call ActS_FacePl
	
	ldh  a, [hActCur+iActTimer0C]	; Timer++
	add  $01
	ldh  [hActCur+iActTimer0C], a
	
	;
	; Handle the timing sequence.
	;
	
.chkSpr3a:
	; $00-$0B: Continue using launching sprite $03
	cp   $0C					; Timer >= $0C?		
	jr   nc, .chkSpawn0			; If so, jump
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ret
	
.chkSpawn0:
	; $18: Spawn first fist, while still using launching sprite $03
	cp   $18					; Timer == $18?
	jr   nz, .chkSpr3b			; If not, jump
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	
	ld   a, ACT_HARDKNUCKLE
	ld   bc, ($00 << 8)|LOW(-$09) ; 9px up
	call ActS_SpawnRel
	ret
	
.chkSpr3b:
	; $0C-$17: Continue using launching sprite $03
	;          This isn't any different than .chkSpr3.
	cp   $18					; Timer >= $18?
	jr   nc, .chkSpr5			; If so, jump
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ret
	
.chkSpr5:
	; $19-23: Use recoil sprite $05
	cp   $24
	jr   nc, .chkSpr4
	ld   a, $05
	ld   [wActCurSprMapBaseId], a
	ret
	
.chkSpr4:
	; $24-2F: Use post recoil sprite $04
	cp   $30
	jr   nc, .chkEnd
	ld   a, $04
	ld   [wActCurSprMapBaseId], a
	ret
	
.chkEnd:
	; $30: Use front facing sprite $04
	ld   a, $04
	ld   [wActCurSprMapBaseId], a
	ld   a, $00						; Reset for next mode
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId				; Next mode
	
;================ Act_HardMan_InitJump ================
; Sets up an high jump directly at the player.
Act_HardMan_InitJump:
	; Delay it by half a second
	ldh  a, [hActCur+iActTimer0C]
	add  $01
	ldh  [hActCur+iActTimer0C], a
	cp   30
	ret  nz
	
	call ActS_FacePl			; Jump towards the player
	
	; X Speed: Act_HardMan_JumpXTbl[DiffX / 8]
	; Precomputed based on how far the player is, in 16px ranges.
	call ActS_GetPlDistanceX	; Get X distance
	swap a						; /16, to Group by column
	and  $0F					; ""
	add  a						; Each table entry is 2 bytes long
	ld   hl, Act_HardMan_JumpXTbl
	ld   b, $00
	ld   c, a
	add  hl, bc					; Index it
	ld   c, [hl]				; Read out to BC
	inc  hl
	ld   b, [hl]
	call ActS_SetSpeedX
	
	; Y Speed: 4.25px/frame
	ld   bc, $0440
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
;================ Act_HardMan_JumpU ================
; Jump, pre-peak.
; This continues until either we reach the peak, or the player gets near.
Act_HardMan_JumpU:
	; Use jumping sprite
	ld   a, $06
	ld   [wActCurSprMapBaseId], a
	
	; If the player is within 4px away, interrupt the jump and start dropping down
	call ActS_GetPlDistanceX
	cp   $04
	jr   nc, .move
	ld   a, ACTRTN_HARDMAN_INITDROPANIM
	ldh  [hActCur+iActRtnId], a
	ret
.move:
	; Move forward, turning around if there's a solid wall
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Move up until we reach the peak of the jump
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId ; Fall down then
	
;================ Act_HardMan_JumpD ================
; Jump, post-peak.
Act_HardMan_JumpD:
	; Use jumping sprite
	ld   a, $06
	ld   [wActCurSprMapBaseId], a
	
	; If the player is within 4px away, interrupt the jump and start dropping down
	call ActS_GetPlDistanceX
	cp   $04
	jr   nc, .move
	ld   a, ACTRTN_HARDMAN_INITDROPANIM
	ldh  [hActCur+iActRtnId], a
	ret
.move:
	; Move forward, turning around if there's a solid wall
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Move down until we reach the touch the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; If we got all the way here, Hard Man failed to find the player.
	
	ld   a, 60					; Shake for a second
	ldh  [hActCur+iActTimer0C], a
	ld   a, PL_MODE_FROZEN		; Freeze the player while it happens
	ld   [wPlMode], a
	ldh  a, [hScrollY]			; Backup untouched coord
	ld   [wHardYShakeOrg], a
	ld   a, ACTRTN_HARDMAN_SHAKE
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_HardMan_InitDropAnim ================
; Sets up the dropping animation, when the player is below.
Act_HardMan_InitDropAnim:
	; Use sprites $07-$09 at 1/12 speed
	ld   de, ($07 << 8)|$09
	ld   c, $0C
	call ActS_InitAnimRange
	jp   ActS_IncRtnId
	
;================ Act_HardMan_PlayDropAnim ================
; Play the dropping animation, during this time Hard Man will stay frozen in the air, to give time to the player.
Act_HardMan_PlayDropAnim:
	call ActS_PlayAnimRange
	ret  z
	jp   ActS_IncRtnId
	
;================ Act_HardMan_Drop ================
; Drops to the ground.
Act_HardMan_Drop:
	; Use sprite $09 from before
	ld   a, $09
	ld   [wActCurSprMapBaseId], a
	
	; Drop down until we touch the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; When we do, freeze the player identically to Act_HardMan_JumpD 
	ld   a, 60					; Shake for a second
	ldh  [hActCur+iActTimer0C], a
	ld   a, PL_MODE_FROZEN		; Freeze the player while it happens
	ld   [wPlMode], a
	ldh  a, [hScrollY]			; Backup untouched coord
	ld   [wHardYShakeOrg], a
	ld   a, ACTRTN_HARDMAN_SHAKE
	ldh  [hActCur+iActRtnId], a
	; Fall-through!
	
;================ Act_HardMan_Shake ================
; Shakes the screen while the player is frozen.
Act_HardMan_Shake:
	; Use sprite $0A, which is halfway into the ground.
	ld   a, $0A
	ld   [wActCurSprMapBaseId], a
	
	; Shake the screen vertically for that second
	call Act_HardMan_SetShake
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; After it's done, restore the original scroll value
	ld   a, [wHardYShakeOrg]
	ldh  [hScrollY], a
	jp   ActS_IncRtnId
	
;================ Act_HardMan_InitRise ================
; Set up the small jump for exiting out of the ground (just visually).
Act_HardMan_InitRise:
	ld   a, $09				; Use rise up sprite $09
	ld   [wActCurSprMapBaseId], a
	
	ld   bc, $0200			; 2px/frame up
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
;================ Act_HardMan_RiseU ================
; Rise jump, pre-peak.
Act_HardMan_RiseU:
	ld   a, $09				; Continue using rise up sprite $09
	ld   [wActCurSprMapBaseId], a
	
	; Apply gravity until we reach the peak of the jump
	call ActS_ApplySpeedUpYColi
	ret  c
	
	jp   ActS_IncRtnId
	
;================ Act_HardMan_RiseD ================
; Rise jump, post-peak.
Act_HardMan_RiseD:
	ld   a, $08				; Use rise down sprite $08
	ld   [wActCurSprMapBaseId], a
	
	; Apply gravity until we touch the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	
	xor  a ; PL_MODE_GROUND		; Unfreeze the player
	ld   [wPlMode], a
	ld   a, $06					; Wait for 6 frames before looping
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_HardMan_Cooldown ================
; Pre-loop cooldown.
Act_HardMan_Cooldown:
	; Wait 6 frames of cooldown using sprite $07
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Then loop the pattern from the beginning.
	; [BUG] This is a common bug among all normal boss actors.
	;       When they need to loop the pattern, they improperly reset the routine to $00 rather than $01.
	;       That's a problem, because said routine is not supposed to be executed again in the middle of a boss fight,
	;       so when it ends up attempting to unlock the player's controls by the player state to PL_MODE_GROUND, leading
	;       to a oddities such as slides ending early or the jump getting cut off.
	ld   a, ACTRTN_HARDMAN_INTRO
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_HardMan_SetShake ================
; Updates the screen shake effect.
Act_HardMan_SetShake:
	; B = hTimer % 4 - 1
	; Will shift the screen, in a loop, from -1 to +2.
	ldh  a, [hTimer]
	and  $03
	add  -1
	ld   b, a
	; hScrollY = wHardYShakeOrg + B
	ld   a, [wHardYShakeOrg]
	add  b
	ldh  [hScrollY], a
	ret
	
;================ Act_HardMan_JumpXTbl ================
; Horizontal speed for the jumps, depending on how far the player is.
; These account for the vertical jump speed being 4.25px/frame.
Act_HardMan_JumpXTbl:
	;  X SPD ; px/frame ; PL DISTANCE
	dw $0040 ; 0.25     ; $00-$0F 
	dw $0040 ; 0.25     ; $10-$1F 
	dw $0080 ; 0.5      ; $20-$2F 
	dw $00C0 ; 0.75     ; $30-$3F 
	dw $0100 ; 1        ; $40-$4F 
	dw $0140 ; 1.25     ; $50-$5F 
	dw $0180 ; 1.5      ; $60-$6F ;X
	dw $01C0 ; 1.75     ; $70-$7F ;X
	dw $0200 ; 2        ; $80-$8F ;X
	dw $0240 ; 2.25     ; $90-$9F ;X
	dw $0280 ; 2.5      ; $A0-$AF ;X
	dw $02C0 ; 2.75     ; $B0-$BF ;X
	dw $0300 ; 3        ; $C0-$CF ;X
	dw $0340 ; 3.25     ; $D0-$DF ;X
	dw $0380 ; 3.5      ; $E0-$EF ;X
	dw $03C0 ; 3.75     ; $F0-$FF ;X

;================ Act_TopMan ================
; ID: ACT_TOPMAN
Act_TopMan:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BossIntro
	dw Act_TopMan_InitThrow
	dw Act_TopMan_Throw0
	dw Act_TopMan_Throw1
	dw Act_TopMan_SpawnTop
	dw Act_TopMan_Throw1
	dw Act_TopMan_InitSpin
	dw Act_TopMan_Spin
	dw Act_TopMan_Move
	DEF ACTRTN_TOPMAN_INTRO = $00

;================ Act_TopMan_InitThrow ================
; Initialize arm motion.
Act_TopMan_InitThrow:
	; Use sprite $00 for half a second
	ld   a, 30
	ldh  [hActCur+iActTimer0C], a
	ld   a, $00
	call ActS_SetSprMapId
	
	jp   ActS_IncRtnId
	
;================ Act_TopMan_Throw0 ================
; Arm motion - sprite $00.
Act_TopMan_Throw0:
	; Wait that half a second
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Use sprite $02 for half a second
	ld   a, 30
	ldh  [hActCur+iActTimer0C], a
	ld   a, $02
	call ActS_SetSprMapId
	
	jp   ActS_IncRtnId
	
;================ Act_TopMan_Throw1 ================
; Arm motion - sprite $02.
Act_TopMan_Throw1:
	; Wait that half a second
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Use sprite $01 for 15 frames
	ld   a, $0F
	ldh  [hActCur+iActTimer0C], a
	ld   a, $01
	call ActS_SetSprMapId
	jp   ActS_IncRtnId
	
;================ Act_TopMan_SpawnTop ================
Act_TopMan_SpawnTop:
	; Wait those 15 frames
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Cooldown of 2 seconds after spawning them, using sprite $02
	ld   a, 60*2
	ldh  [hActCur+iActTimer0C], a
	ld   a, $00
	call ActS_SetSprMapId
	
	; Spawn three spinning tops, which block shots.
	call Act_TopMan_SpawnShots
	jp   ActS_IncRtnId
	
;================ Act_TopMan_InitSpin ================
Act_TopMan_InitSpin:
	; Wait those 2 seconds before doing it
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Spin in place for 2 seconds
	ld   a, 60*2
	ldh  [hActCur+iActTimer0C], a
	ld   b, ACTCOLI_ENEMYREFLECT	; Reflect shots while spinning
	call ActS_SetColiType
	jp   ActS_IncRtnId
	
;================ Act_TopMan_Spin ================
Act_TopMan_Spin:
	; Use frames $03-$06 at 1/4 speed to animate the spin
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ld   c, $02
	call ActS_Anim4
	; Do that for aforemented 2 seconds
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Then start moving forward at 2px/frame, to the other side of the screen
	ld   bc, $0200
	call ActS_SetSpeedX
	jp   ActS_IncRtnId
	
;================ Act_TopMan_Move ================
Act_TopMan_Move:
	; Use frames $03-$06 at 1/4 speed to animate the spin
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ld   c, $02
	call ActS_Anim4
	
	; Move forward at 2px/frame until we reach the opposite side of the screen.
	; Specifically, until we're within 2 blocks from the edge of the screen.
	DEF OFFS = BLOCK_H*2
	call ActS_ApplySpeedFwdX
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a				; Facing right?
	jr   nz, .chkR					; If so, jump
.chkL:
	ldh  a, [hActCur+iActX]
	cp   OBJ_OFFSET_X+OFFS			; Top Man within 2 blocks from the left? (ActX < $18)
	jr   c, .loop					; If so, jump
	ret								; Otherwise, keep moving
.chkR:
	ldh  a, [hActCur+iActX]
	cp   OBJ_OFFSET_X+SCREEN_GAME_H-OFFS 	; Top Man within 2 blocks from the right? (ActX < $88)
	ret  c									; If not, keep moving
	
.loop:
	ld   b, ACTCOLI_ENEMYHIT		; Vulnerable when not spinning
	call ActS_SetColiType
	call ActS_FlipH					; Turn the other side
	; [BUG] This one is easy to notice, the player is likely in the air, so its vertical speed is reset.
	ld   a, ACTRTN_TOPMAN_INTRO		; Loop the pattern
	ldh  [hActCur+iActRtnId], a
	ret
	
	
;================ Act_MagnetMan ================
; ID: ACT_MAGNETMAN
Act_MagnetMan:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BossIntro
	dw Act_MagnetMan_InitFwdJump0
	dw Act_MagnetMan_JumpU
	dw Act_MagnetMan_JumpD
	dw Act_MagnetMan_InitFwdJump1
	dw Act_MagnetMan_JumpU
	dw Act_MagnetMan_JumpD
	dw Act_MagnetMan_ChkAttack
	dw Act_MagnetMan_JumpU
	dw Act_MagnetMan_InitSpawnMissile
	dw Act_MagnetMan_SpawnMissile
	dw Act_MagnetMan_InitSpawnMissile
	dw Act_MagnetMan_SpawnMissile
	dw Act_MagnetMan_InitSpawnMissile
	dw Act_MagnetMan_SpawnMissile
	dw Act_MagnetMan_JumpD
	dw Act_MagnetMan_InitCooldown
	dw Act_MagnetMan_Cooldown
	dw Act_MagnetMan_Attract
	DEF ACTRTN_MAGNETMAN_INITFWDJUMP0 = $01
	DEF ACTRTN_MAGNETMAN_INITCOOLDOWN = $10
	DEF ACTRTN_MAGNETMAN_ATTRACT = $12
	
;================ Act_MagnetMan_InitFwdJump0 ================
; Sets up the first of the two forward hops.
; These hops are notoriously hard to slide under due to misaligned sprite mappings.
Act_MagnetMan_InitFwdJump0:

	; X Speed = 1.375px/frame to the other side
	ld   bc, $0160			
	call ActS_SetSpeedX
	; For this to work it assumes Magnet Man to be at X positions $80-$8F when starting hops.
	ldh  a, [hActCur+iActX]
	and  ACTDIR_R					; Left side -> $00, Right side -> $80
	xor  ACTDIR_R					; Face the opposite side. That's our ACTDIR_*
	ldh  [hActCur+iActSprMap], a
	
	; Y Speed = 2px/frame
	ld   bc, $0200
	call ActS_SetSpeedY
	
	; Use jumping sprite $05
	ld   a, $05
	call ActS_SetSprMapId
	jp   ActS_IncRtnId
	
;================ Act_MagnetMan_JumpU ================
; Jump, pre-peak.
; This and the next routines are used to handle all jumps.
Act_MagnetMan_JumpU:
	; Apply gravity until the peak of the jump
	call ActS_ApplySpeedFwdXColi
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
	
;================ Act_MagnetMan_JumpD ================
; Jump, post-peak.
Act_MagnetMan_JumpD:
	; Apply gravity until we touch the ground
	call ActS_ApplySpeedFwdXColi
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; Then temporarily stand on the ground for 6 frames, using sprite $00
	ld   a, $06
	ldh  [hActCur+iActTimer0C], a
	ld   a, $00
	call ActS_SetSprMapId
	
	jp   ActS_IncRtnId
	
;================ Act_MagnetMan_InitFwdJump1 ================
; Sets up the second of the two forward hops.
Act_MagnetMan_InitFwdJump1:
	; Wait those 6 frames...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Y Speed = 3px/frame
	; This is the jump Rockman should slide under.
	ld   bc, $0300
	call ActS_SetSpeedY
	
	; (Keep same X speed as before)
	
	; Use jumping sprite $05
	ld   a, $05
	call ActS_SetSprMapId
	
	jp   ActS_IncRtnId ; Continue to another Act_MagnetMan_JumpU
	
;================ Act_MagnetMan_ChkAttack ================
; On the ground, determining the attack to perform.
Act_MagnetMan_ChkAttack:
	; Both attacks are done while facing the player.
	call ActS_FacePl
	
	;
	; Magnet Man has two attacks.
	; If the player is further away than 3 blocks, he has a 50% chance of attracting Rockman.
	; In any other case, he jumps straight up and fires three Magnet Missiles.
	;
	; The first attack is notoriously difficult to trigger when fighting the boss properly,
	; as having to slide under the second hop keeps the player within 3 blocks of distance.
	;
	
	; Don't attract if too close
	call ActS_GetPlDistanceX
	cp   $30				; DiffX >= $30?
	jr   nc, .chkAttr		; If so, jump
.missile:
	ld   bc, $0000			; Set jump straight up at 4.25px/frame
	call ActS_SetSpeedX
	ld   bc, $0440
	call ActS_SetSpeedY
	ld   a, $05				; Use jumping sprite
	call ActS_SetSprMapId
	jp   ActS_IncRtnId		; Next mode
	
.chkAttr:
	; 50% chance of attracting player
	call Rand				; A = Rand()
	bit  7, a				; A >= $80?
	jr   nz, .missile		; If so, jump
	
	ld   b, ACTCOLI_ENEMYREFLECT	; Make invulnerable while attracting
	call ActS_SetColiType
	ld   a, $03						; Use attract sprite $03 (part of an anim)
	call ActS_SetSprMapId
	ld   a, 60*3					; Waste 3 seconds doing this
	ldh  [hActCur+iActTimer0C], a
	ld   a, ACTRTN_MAGNETMAN_ATTRACT
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_MagnetMan_InitSpawnMissile ================
; Sets up the timer for missile spawning, also used for cooldown.
Act_MagnetMan_InitSpawnMissile:
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_MagnetMan_SpawnMissile ================
; Launches a Magnet Missile straight forward, which will home in down on the player.
; Called three times, alternated with the previous routine.
Act_MagnetMan_SpawnMissile:
	; Always face the player while in this pose, which is a bit pointless given those projectiles may hit a wall.
	call ActS_FacePl
	
	ldh  a, [hActCur+iActTimer0C]	; Timer--
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	push af
		ld   b, a
			; Alternate between sprites $05 and $06 every 8 frames.
			; This is timed with the check below so that it switches to $06, the throw frame,
			; exactly when the Magnet Missile spawns.
			; wActCurSprMapBaseId = Timer / 8 % 2
			srl  a ; /2
			srl  a ; /4
			srl  a ; /8 (every 8 frames)
			and  $01 ; % 2 (offset $00 or $01, relative to the base set in Act_MagnetMan_ChkAttack.missile)
			; This isn't quite the way the base sprite mapping ID is supposed to be used, but it works out.
			ld   [wActCurSprMapBaseId], a
		ld   a, b
		
		; Spawn the Magnet Missile halfway through, whe the timer ticks down to $08
		cp   $08
		jr   nz, .chkEnd
		
		ld   a, ACT_MAGNETMISSILE
		ld   bc, ($00 << 8)|LOW(-$10) ; 16px up
		call ActS_SpawnRel
		ldh  a, [hActCur+iActSprMap]
		and  ACTDIR_R	; Make missile travel forward
		or   ACTDIR_D	; Prepare for downwards movement
		inc  l ; iActRtnId
		inc  l ; iActSprMap
		ld   [hl], a	; Save as spawned actor's sprite mapping flags
.chkEnd:
	pop  af	; A = Timer
	ret  nz	; Has it elapsed? If not, return
	
	jp   ActS_IncRtnId
	
;================ Act_MagnetMan_InitCooldown ================
; On the ground, set up the cooldown before looping.
Act_MagnetMan_InitCooldown:
	; Use sprite $00 for 6 frames
	ld   a, $06
	ldh  [hActCur+iActTimer0C], a
	ld   a, $00
	call ActS_SetSprMapId
	jp   ActS_IncRtnId
	
;================ Act_MagnetMan_Cooldown ================
; Ground cooldown.
Act_MagnetMan_Cooldown:
	; Wait on the ground for those 6 frames...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Loop pattern to the start
	ld   a, ACTRTN_MAGNETMAN_INITFWDJUMP0
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_MagnetMan_Attract ================
; Attracts the player while invulnerable.
Act_MagnetMan_Attract:
	; Always face the player...
	call ActS_FacePl
	; ...and move the player the opposite direction we're facing.
	; Basically, move Rockman towards up at 0.5px/frame
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R
	xor  ACTDIR_R
	ld   bc, $0080
	call Pl_SetSpeedByActDir
	
	; Getting hurt interrupts the attack
	ld   a, [wPlHurtTimer]
	or   a						; Player is hurt?
	jr   nz, .end				; If so, jump
	
	
	ldh  a, [hActCur+iActTimer0C]	; TImer--
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	push af	; Save timer
		; Alternate between sprites $03 and $04 every 4 frames.
		; wActCurSprMapBaseId = Timer / 4 % 2
		srl  a ; /2
		srl  a ; /4 (every 4 frames)
		and  $01 ; % 2 (offset $00 or $01)
		ld   [wActCurSprMapBaseId], a
	pop  af	; A = Timer
	ret  nz	; Has it elapsed? If not, return
.end:
	ld   b, ACTCOLI_ENEMYHIT
	call ActS_SetColiType
	ld   a, ACTRTN_MAGNETMAN_INITCOOLDOWN
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_NeedleMan ================
; ID: ACT_NEEDLEMAN
Act_NeedleMan:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BossIntro
	dw Act_NeedleMan_InitChkAttack
	dw Act_NeedleMan_ChkAttack
	dw Act_NeedleMan_InitHeadExtend
	dw Act_NeedleMan_HeadExtend
	dw Act_NeedleMan_HeadRetract
	dw Act_NeedleMan_InitJump
	dw Act_NeedleMan_InitFwdJump
	dw Act_NeedleMan_JumpU
	dw Act_NeedleMan_JumpD
	dw Act_NeedleMan_InitThrJump
	dw Act_NeedleMan_JumpThrU
	dw Act_NeedleMan_JumpThrD
	dw Act_NeedleMan_ThrSpawn
	dw Act_NeedleMan_ThrCooldown
	DEF ACTRTN_NEEDLEMAN_INITCHKATTACK = $01
	DEF ACTRTN_NEEDLEMAN_INITHEADEXTEND = $03
	DEF ACTRTN_NEEDLEMAN_INITJUMP = $06
	DEF ACTRTN_NEEDLEMAN_INITFWDJUMP = $07
	DEF ACTRTN_NEEDLEMAN_JUMPU = $08
	DEF ACTRTN_NEEDLEMAN_0A = $0A
	DEF ACTRTN_NEEDLEMAN_JUMPTHRD = $0C

;================ Act_NeedleMan_InitChkAttack ================
; Sets up the delay before choosing an attack.
Act_NeedleMan_InitChkAttack:
	; Show ground sprite for 6 frames
	ld   a, $00
	call ActS_SetSprMapId
	ld   a, $06
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_NeedleMan_ChkAttack ================
; Chosses a random attack.
Act_NeedleMan_ChkAttack:
	; Stay on the ground for those 6 frames, before choosing an attack
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	;
	; Randomize the attack.
	; It's a 50/50 whether the boss attacks or jumps, specifically:
	;
	; - 25% Jump straight up
	; - 25% Forward jump
	; - 50% Proximity-based attack
	;   - If the player is within 4 blocks, use the headbutt
	;   - Otherwise, do a full jump straight up and throw needles
	;
	
	; Roll a value between $00 and $03
	call Rand	; A = (Rand() / 16) % 4
	swap a		; / 16
	and  $03	; % 4
	
.chkJump:
	; $00 - Jump straight up (25%)
	jr   nz, .chkFwdJump		; A == 0? If not, jump
	ld   a, ACTRTN_NEEDLEMAN_INITJUMP
	ldh  [hActCur+iActRtnId], a
	ret
.chkFwdJump:
	; $01 - Jump forward (25%)
	dec  a						; A == 1?
	jr   nz, .chkAtk			; If not, jump
	ld   a, ACTRTN_NEEDLEMAN_INITFWDJUMP
	ldh  [hActCur+iActRtnId], a
	ret
	
.chkAtk:
	; $02-$03 - Proximity-based attack ($50%)
	call ActS_GetPlDistanceX
	cp   BLOCK_H*4				; DiffX >= $40?
	jr   nc, .far				; If so, jump
.near:
	; Player is near, use headbutt
	ld   a, ACTRTN_NEEDLEMAN_INITHEADEXTEND
	ldh  [hActCur+iActRtnId], a
	ret
.far:
	; Player is far, jump and throw needles
	ld   a, ACTRTN_NEEDLEMAN_0A
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_NeedleMan_InitHeadExtend ================
; Sets up the headbutt attack, used when the player is nearby.
Act_NeedleMan_InitHeadExtend:
	; Face towards the player
	call ActS_FacePl
	
	; When extending, use sprites $02-$05 at 1/4 speed
	ld   de, ($02 << 8)|$05
	ld   c, $04
	call ActS_InitAnimRange
	
	jp   ActS_IncRtnId
	
;================ Act_NeedleMan_HeadExtend ================
; Headbutt, extend spikes.
Act_NeedleMan_HeadExtend:

	;
	; During the headbutt attack, use the sprite mapping ID as index to the collision box.
	; Note that, as radiuses are symmetrical, the collision box will also extend on the
	; other side... not like it matters since it's not possible to jump over Needle Man
	; without getting hit anyway.
	; 
	; [POI] What does matter however is the index used. While every frame in the animation
	;       has its own horizontal radius defined, most of them go unused since the index
	;       is only ever set to the first sprite of the range (iAnimRangeSprMapFrom).
	;
	;       This causes the needle to not have an hitbox while it's extending.
	;       The code for retracting has the opposite problem, with the extended hitbox lingering around.
	;
	
	; B = Act_NeedleMan_ColiXTbl[iAnimRangeSprMapFrom]
	;     In practice, always $0B
	ldh  a, [hActCur+iAnimRangeSprMapFrom]
	ld   hl, Act_NeedleMan_ColiXTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   b, [hl]			; Read horizntal radius
	ld   c, $0B				; Fixed vertical radius
	call ActS_SetColiBox
	
	; Wait until the animation finishes
	call ActS_PlayAnimRange
	ret  z
	
	; When retracting, use sprites $05-$08 at 1/4 speed
	ld   de, ($05 << 8)|$08
	ld   c, $04
	call ActS_InitAnimRange
	
	jp   ActS_IncRtnId
	
;================ Act_NeedleMan_HeadRetract ================
; Headbutt, retract spikes.
Act_NeedleMan_HeadRetract:

	; Set collision box for first frame
	ldh  a, [hActCur+iAnimRangeSprMapFrom]
	ld   hl, Act_NeedleMan_ColiXTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   b, [hl]
	ld   c, $0B
	call ActS_SetColiBox
	
	; Wait until the animation finishes
	call ActS_PlayAnimRange
	ret  z
	
	; Attack is done, restore the normal collision box
	ld   bc, ($0B << 8)|$0B		; 23x23
	call ActS_SetColiBox
	
	; Roll the dice for the next attack
	ld   a, ACTRTN_NEEDLEMAN_INITCHKATTACK
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_NeedleMan_InitJump ================
; Sets up a jump straight up.
Act_NeedleMan_InitJump:
	ld   bc, $0000			; No horz speed
	call ActS_SetSpeedX
	ld   bc, $0380			; 3.5px/frame up
	call ActS_SetSpeedY
	ld   a, ACTRTN_NEEDLEMAN_JUMPU
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_NeedleMan_InitFwdJump ================
; Sets up a forward jump.
Act_NeedleMan_InitFwdJump:
	ld   bc, $0100			; 1px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0380			; 3.5px/frame up
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
;================ Act_NeedleMan_JumpU ================
; Jump, pre-peak.
Act_NeedleMan_JumpU:
	; Use jumping sprite
	ld   a, $09
	ld   [wActCurSprMapBaseId], a
	; Apply gravity while moving up, until we reach the peak
	call ActS_ApplySpeedFwdXColi
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
	
;================ Act_NeedleMan_JumpD ================
; Jump, post-peak.
Act_NeedleMan_JumpD:
	; Use jumping sprite
	ld   a, $09
	ld   [wActCurSprMapBaseId], a
	; Apply gravity while moving down, until we reach touch the ground
	call ActS_ApplySpeedFwdXColi
	call ActS_ApplySpeedDownYColi
	ret  c
	; Then check for a new attack
	ld   a, ACTRTN_NEEDLEMAN_INITCHKATTACK
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_NeedleMan_InitThrJump ================
; Needle attack - Set up straight up high jump near the ceiling.
Act_NeedleMan_InitThrJump:
	ld   bc, $0440			; 4.25px/frame up
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
;================ Act_NeedleMan_JumpThrU ================
; Needle attack - high jump, pre-peak.
Act_NeedleMan_JumpThrU:
	; Use jumping sprite
	ld   a, $09
	ld   [wActCurSprMapBaseId], a
	
	; Apply gravity while moving up, until we reach the peak
	call ActS_ApplySpeedUpYColi
	ret  c
	
	xor  a
	ld   [wNeedleSpawnTimer], a
	jp   ActS_IncRtnId
	
;================ Act_NeedleMan_JumpThrD ================
; Needle attack - high jump, post-peak.
Act_NeedleMan_JumpThrD:
	; Use jumping sprite
	ld   a, $09
	ld   [wActCurSprMapBaseId], a
	
	; Face the player in case he's passing under
	call ActS_FacePl
	
	;--
	;
	; Spawn a needle every 8 frames, over a period of $20 (32) frames.
	; This will end up spawning four equally spaced needles around the start of the descent.
	;
	ld   a, [wNeedleSpawnTimer]
	cp   $20					; Timer >= $20?
	jr   nc, .move				; If so, skip (we already spawned 4 needles)
	inc  a						; Timer++
	ld   [wNeedleSpawnTimer], a
	
	dec  a						; Go back to previous value
	and  $07					; Divisible by 8?
	jr   nz, .move				; If not, skip
	
	jp   ActS_IncRtnId			; Otherwise, spawn it!
	;--
.move:
	; Apply gravity while moving down, until we touch tne ground.
	call ActS_ApplySpeedDownYColi
	ret  c
	ld   a, ACTRTN_NEEDLEMAN_INITCHKATTACK
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_NeedleMan_ThrSpawn ================
; Spawns a needle.
Act_NeedleMan_ThrSpawn:
	ld   a, ACT_NEEDLECANNON
	ld   bc, ($00 << 8)|LOW(-$10)	; 16px up
	call ActS_SpawnRel
	
	; Cooldown of 6 frames after spawning needle
	ld   a, $06
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_NeedleMan_ThrCooldown ================
; Cooldown after spawning a needle.
Act_NeedleMan_ThrCooldown:
	; Wait those 6 frames.
	; While this happens, gravity is not processed, making Needle Man freeze in the air.
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	ld   a, ACTRTN_NEEDLEMAN_JUMPTHRD
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_NeedleMan_ColiXTbl ================
; Maps each sprite to its collision box horizontal radius.
; Only used during the headbutt attack, so most entries go unused,
; on top of those unused by mistake (see Act_NeedleMan_HeadExtend).
Act_NeedleMan_ColiXTbl:
	db $0B ; $00 ;X
	db $0B ; $01 ;X
	db $0B ; $02 
	db $13 ; $03 ;X
	db $1B ; $04 ;X
	db $23 ; $05 
	db $1B ; $06 ;X
	db $13 ; $07 ;X
	db $0B ; $08 ;X
	db $0B ; $09 ;X

;================ Act_CrashMan ================
; ID: ACT_CRASHMAN
Act_CrashMan:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BossIntro
	dw Act_CrashMan_InitWalk
	dw Act_CrashMan_Walk
	dw Act_CrashMan_InitJump
	dw Act_CrashMan_JumpU
	dw Act_CrashMan_JumpShootD
	dw Act_CrashMan_JumpD1
	dw Act_CrashMan_JumpD2
	DEF ACTRTN_CRASHMAN_INTRO = $00
	
;================ Act_CrashMan_InitWalk ================
; Sets up walking.
Act_CrashMan_InitWalk:
	xor  a							; Reset walk cycle
	ldh  [hActCur+iCrashManWalkTimer], a
	ld   bc, $00E0					; Move 0.875px/frame forward
	call ActS_SetSpeedX
	ld   a, $80						; Walk for ~2 seconds at most
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_CrashMan_Walk ================
; Walking on the ground.
Act_CrashMan_Walk:
	;
	; Animate walk cycle.
	; Use sprites $03-$06 at 1/8 speed.
	;
	ld   hl, hActCur+iCrashManWalkTimer
	ld   a, [hl]		; Get current walk timer
	inc  [hl]			; WalkTimer++
	rrca ; /2
	rrca ; /4
	rrca ; /8			; Advance anim every 8 frames
	and  $03			; 4 sprite cycle
	add  $03			; Starting at $03
	ld   [wActCurSprMapBaseId], a
	
	;
	; If the player is shooting, retaliate.
	; Specifically, if the player shot in the first slot is active, retaliate.
	; This leads to similar results to what RM2 did, which was going off a B button press.
	;
	ld   a, [wShot0]		; Get shot ID. If it's active, it will be >= $80
	add  a					; Does *2 overflow it?
	jp   c, ActS_IncRtnId	; If so, a shot is active, so cut the wait early
	
	;
	; After waiting ~2 seconds, retaliate on our own.
	; This is unlike RM2, where Crash Man can wait indefinitely until the player shoots.
	;
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a	; Timer--
	jp   z, ActS_IncRtnId			; Timer == 0? If so, jump
	
	; Move forward at 0.875px/frame, turning around when a solid wall is in the way
	call ActS_ApplySpeedFwdXColi	; Perform movement
	ret  c							; Hit a wall? If not, return
	;--								; Otherwise, flip
	; This is ActS_FlipH done manually, why.
	ld   hl, hActCur+iActSprMap
	ld   a, ACTDIR_R
	xor  [hl]
	ld   [hl], a
	;--
	ret
	
;================ Act_CrashMan_InitJump ================
; Sets up a jump directly at the player.
Act_CrashMan_InitJump:
	; Jump towards the player
	call ActS_FacePl
	; X Speed: (DiffX * 4)subpx/frame
	call ActS_GetPlDistanceX	; A = Diff
	ld   l, a
	ld   h, $00					; to HL
	add  hl, hl					; *2
	add  hl, hl					; *4
	ld   a, l					; Set result
	ldh  [hActCur+iActSpdXSub], a
	ld   a, h
	ldh  [hActCur+iActSpdX], a
	
	ld   bc, $0400			; Y Speed: 4px/frame
	call ActS_SetSpeedY
	
	jp   ActS_IncRtnId
	
;================ Act_CrashMan_JumpU ================
; Jump, pre-peak.
Act_CrashMan_JumpU:
	; Use jumping sprite
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	
	; Jump forward, stopping on solid blocks
	call ActS_ApplySpeedFwdXColi
	; Apply gravity while moving up, until we reach the peak
	call ActS_ApplySpeedUpYColi
	ret  c
	; Wait 8 frames before
	ld   a, $08
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_CrashMan_JumpShootD ================
; Jump, post-peak. (can shoot Crash Bomb)
Act_CrashMan_JumpShootD:
	; Use jumping sprite
	ld   a, $08
	ld   [wActCurSprMapBaseId], a
	
	; Jump forward, stopping on solid blocks
	call ActS_ApplySpeedFwdXColi
	; Apply gravity while moving down...
	; No end check due to the high jump arc and level layout in the boss room,
	; not making it possible to touch the ground in this routine (or the next one).
	call ActS_ApplySpeedDownYColi
	
	; Wait for those 8 frames...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	;
	; Spawn a Crash Bomb, which travels diagonally, if one isn't already spawned.
	;
	; The spawn check goes off the explosion actor because by the time Crash Man gets to 
	; fire another bomb, even at the earliest possible time, the old Crash Bomb will have already exploded.
	;
	ld   a, ACT_CRASHBOMBEXPL
	call ActS_CountById
	ld   a, b				; A = Crash Bomb count
	and  a					; Is that != 0?
	jr   nz, .nextMode		; If so, skip
	
	ld   a, ACT_CRASHBOMB	; Otherwise, spawn at the current position
	ld   bc, $0000
	call ActS_SpawnRel
.nextMode:
	; Continue the jump down while displaying the shooting sprite $09 for 8 frames.
	ld   a, $08
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_CrashMan_JumpD1 ================
; Jump, post-peak (sprite $09).
Act_CrashMan_JumpD1:
	; Use jumping/shooting sprite
	ld   a, $09
	ld   [wActCurSprMapBaseId], a
	; Jump forward, stopping on solid blocks
	call ActS_ApplySpeedFwdXColi
	; Apply gravity while moving down...
	call ActS_ApplySpeedDownYColi
	
	; Wait for those 8 frames...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Continue the jump down while displaying sprite $09 until we touch the ground
	ld   a, $08
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_CrashMan_JumpD2 ================
; Jump, post-peak (sprite $07).
Act_CrashMan_JumpD2:
	; Use jumping sprite 2
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	; Jump forward, stopping on solid blocks
	call ActS_ApplySpeedFwdXColi
	; Apply gravity while moving down, until we touch a solid block.
	call ActS_ApplySpeedDownYColi
	ret  c
	; [BUG] Resetting to the intro, not Act_CrashMan_InitWalk
	ld   a, ACTRTN_CRASHMAN_INTRO
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_MetalMan ================
; ID: ACT_METALMAN
; See also: Act_CrashMan
Act_MetalMan:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BossIntro
	dw Act_MetalMan_InitWalk
	dw Act_MetalMan_Walk
	dw Act_MetalMan_AtkJumpU
	dw Act_MetalMan_AtkJumpSpawnD
	dw Act_MetalMan_AtkJumpD
	dw Act_MetalMan_Unused_AtkJumpEndD
	dw Act_MetalMan_Unused_AtkJumpCooldown
	dw Act_MetalMan_Unused_08
	dw Act_MetalMan_InitJumpFwd
	dw Act_MetalMan_JumpFwdU
	dw Act_MetalMan_JumpFwdD
	DEF ACTRTN_METALMAN_WALK = $02
	DEF ACTRTN_METALMAN_ATKJUMPSPAWND = $04
	DEF ACTRTN_METALMAN_INITJUMPFWD = $09

;================ Act_MetalMan_InitWalk ================
; Sets up walking in place.
Act_MetalMan_InitWalk:
	xor  a							; Reset walk cycle
	ldh  [hActCur+iMetalManWalkTimer], a
	;--
	ld   a, $10						; Not used
	ldh  [hActCur+iActTimer0C], a
	;--
	jp   ActS_IncRtnId
	
;================ Act_MetalMan_Walk ================
; Walking in place on the ground.
Act_MetalMan_Walk:
	;
	; Animate walk cycle.
	; Use sprites $03-$06 at 1/8 speed.
	;
	ld   hl, hActCur+iMetalManWalkTimer
	ld   a, [hl]		; Get current walk timer
	inc  [hl]			; WalkTimer++
	rrca ; /2
	rrca ; /4
	rrca ; /8			; Advance anim every 8 frames
	and  $03			; 4 sprite cycle
	add  $03			; Starting at $03
	ld   [wActCurSprMapBaseId], a
	
	;
	; If the player gets within 2 blocks, jump forward, the other way.
	;
	call ActS_GetPlDistanceX
	cp   BLOCK_H*2							; DiffX < $20?
	jp   c, Act_MetalMan_SwitchToJumpFwd	; If so, jump
	
	;
	; If the player is shooting, retaliate.
	;
	ld   a, [wShot0]
	add  a				; wShotId < $80?
	ret  nc				; If so, return
	
	; Jump straight up, preparing to shoot three Metal Blades
	ld   bc, $0400		; 4px/frame up
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
;================ Act_MetalMan_AtkJumpU ================
; Metal Blade attack - Jump, pre-peak.
Act_MetalMan_AtkJumpU:
	; Use jumping sprite
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	
	; Apply gravity while moving up, until we reach the peak
	call ActS_ApplySpeedUpYColi
	ret  c
	
	; Wait 4 frames before throwing one
	ld   a, $04
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_MetalMan_AtkJumpSpawnD ================
; Metal Blade attack - Jump, post-peak, throw Metal Blade.
;
; This and the next mode are looped in sequence, attempting to throw as many
; Metal Blades as possible until we land on the ground.
; Due to the fixed jump height, we always end up throwing 3 of them.
Act_MetalMan_AtkJumpSpawnD:
	; Use jumping down sprite
	ld   a, $08
	ld   [wActCurSprMapBaseId], a
	
	; Apply gravity while moving down, until we touch the ground.
	; When that happens, the attack is over.
	call ActS_ApplySpeedDownYColi
	jp   nc, Act_MetalMan_SwitchToWalk
	
	; Wait those 4 frames before spawning a Metal Blade
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	ld   a, ACT_METALBLADE
	ld   bc, $0000
	call ActS_SpawnRel
	
	; Display throw sprite for 8 frames, while still falling down
	ld   a, $08
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_MetalMan_AtkJumpD ================
; Metal Blade attack - Jump, post-peak, after throw cooldown.
Act_MetalMan_AtkJumpD:
	; Use jumping/throw sprite
	ld   a, $09
	ld   [wActCurSprMapBaseId], a
	
	; Apply gravity while moving down, until we touch tne ground
	call ActS_ApplySpeedDownYColi
	jp   nc, Act_MetalMan_SwitchToWalk
	
	; Wait those 8 frames
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Throw another Metal Blade after 16 frames
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	ld   a, ACTRTN_METALMAN_ATKJUMPSPAWND
	ldh  [hActCur+iActRtnId], a		; Back to previous routine
	ret
	
;================ Act_MetalMan_Unused_* ================
; [TCRF] Unused routines. All begin with a "ret" blocking their execution.
;        They appear to be incomplete code that would have made the attack more accurate to the NES counterpart.
;        This is similar to code found in Needle Man though, it might have been adapted from there.

;================ Act_MetalMan_Unused_AtkJumpEndD ================
; Metal Blade attack - Jump, post-peak. Don't throw more Metal Blades.
; It might have been used were the number of spawned Metal Blades capped.
Act_MetalMan_Unused_AtkJumpEndD:
	ret

	; Apply gravity while moving down, until we touch tne ground.
	call ActS_ApplySpeedDownYColi
	ret  c
	; Then return walking.
	ld   a, ACTRTN_METALMAN_WALK
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_MetalMan_Unused_InitAtkJumpCooldown ================
; Metal Blsde attack - Set up cooldown after shooting.
; This is noticeably not done here, unlike the NES game.
Act_MetalMan_Unused_InitAtkJumpCooldown:
	; Cooldown of 16 frames, presumably after spawning the Metal Blade
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_MetalMan_Unused_AtkJumpCooldown ================
; Waits 16 frames
Act_MetalMan_Unused_AtkJumpCooldown:
	ret  ; Ret'd out  
	
	; Use jumping sprite
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	
	; Wait those 10 frames.
	; While this happens, gravity is not processed, making Metal Man freeze in the air.
	ldh  a, [hActCur+iActTimer0C]
	sub  a, $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; And then...
	jp   ActS_IncRtnId
	
;================ Act_MetalMan_Unused_08 ================
Act_MetalMan_Unused_08:
	; Nothing!
	ret  

;================ Act_MetalMan_InitJumpFwd ================
; Sets up the jump to the other side.
Act_MetalMan_InitJumpFwd:
	; [POI] Since there's enough space, it is possible to trick Metal Man into jumping the wrong side.
	call ActS_FacePl		; Jump towards the player.
	ld   bc, $0180			; 1.5px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0380			; 3.5px/frame up
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
;================ Act_MetalMan_JumpFwdU ================
; Jump to other side, pre-peak.
Act_MetalMan_JumpFwdU:
	; Use jumping sprite
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	
	; [BUG] This isn't checking for solid collision, which would have been fine hadn't it been possible to
	;       trick Metal Man into jumping into the wall.
	call ActS_ApplySpeedFwdX
	; Apply gravity while moving up, until the peak of the jump
	call ActS_ApplySpeedUpYColi
	ret  c
	
	jp   ActS_IncRtnId
	
;================ Act_MetalMan_JumpFwdD ================
; Jump to other side, post-peak.
Act_MetalMan_JumpFwdD:
	; Use jumping sprite
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	; [BUG] See above. 
	call ActS_ApplySpeedFwdX
	; Apply gravity while moving down, until the peak of the jump
	call ActS_ApplySpeedDownYColi
	ret  c
	; Face the player as soon as we land
	call ActS_FacePl
	
	; Could have been omitted, to fall through Act_MetalMan_SwitchToWalk
	ld   a, ACTRTN_METALMAN_WALK
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_MetalMan_SwitchToWalk ================
Act_MetalMan_SwitchToWalk:
	ld   a, ACTRTN_METALMAN_WALK
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_MetalMan_SwitchToJumpFwd ================
Act_MetalMan_SwitchToJumpFwd:
	ld   a, ACTRTN_METALMAN_INITJUMPFWD
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_WoodMan ================
Act_WoodMan:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BossIntro
	dw Act_WoodMan_SpawnShield
	dw Act_WoodMan_Idle
	dw Act_WoodMan_SpawnRise
	dw Act_WoodMan_ThrowShield
	dw Act_WoodMan_SpawnFallLeaves
	dw Act_WoodMan_JumpU
	dw Act_WoodMan_JumpD
	dw Act_WoodMan_WaitShieldDespawn
	dw Act_WoodMan_WaitFallDespawn
	dw Act_WoodMan_Unused_Nop;X
	DEF ACTRTN_WOODMAN_INTRO = $00
	
;================ Act_WoodMan_SpawnShield ================
; Spawns the Leaf Shield.
Act_WoodMan_SpawnShield:
	; Don't throw it yet
	xor  a
	ld   [wLeafShieldOrgSpdX], a
	
	; After spawning it, idle for 16 frames (before spawning the rising leaves)
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	
	;
	; Spawn the Leaf Shield.
	; This is made of four individual leaf actors that rotate around Wood Man.
	;
	; There are $40 possible positions for the leaves (which wrap around), so to
	; have them evenly spaced out, their timer value is set to be $10 apart.
	; 
	; Since the leaves are small and the collision box is too, it's possible to
	; easily shoot through the shield, especially with the buster.
	;
	
	ld   a, ACT_LEAFSHIELD
	ld   bc, ($00 << 8)|$04	; 4px up
	call ActS_SpawnRel
	jp   c, ActS_IncRtnId
	ld   de, iActTimer0C
	add  hl, de
	ld   [hl], $10*0
	
	ld   a, ACT_LEAFSHIELD
	ld   bc, ($00 << 8)|$04	; 4px up
	call ActS_SpawnRel
	jp   c, ActS_IncRtnId
	ld   de, iActTimer0C
	add  hl, de
	ld   [hl], $10*1
	
	ld   a, ACT_LEAFSHIELD
	ld   bc, ($00 << 8)|$04	; 4px up
	call ActS_SpawnRel
	jp   c, ActS_IncRtnId
	ld   de, iActTimer0C
	add  hl, de
	ld   [hl], $10*2
	
	ld   a, ACT_LEAFSHIELD
	ld   bc, ($00 << 8)|$04	; 4px up
	call ActS_SpawnRel
	jp   c, ActS_IncRtnId
	ld   de, iActTimer0C
	add  hl, de
	ld   [hl], $10*3
	
	jp   ActS_IncRtnId
	
;================ Act_WoodMan_Idle ================
; Idle, on the ground.
Act_WoodMan_Idle:
	; Wait 16 frames in the idle animation
	call Act_WoodMan_AnimIdle
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Spawn three rising leaves
	ld   a, $03
	ldh  [hActCur+iWoodManRiseLeft], a
	; Wait 16 frames (total 32)
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_WoodMan_SpawnRise ================
; Spawns rising leaves, while idling.
Act_WoodMan_SpawnRise:
	; Wait 16 frames in the idle animation (cooldown)
	call Act_WoodMan_AnimIdle
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Spawn a leaf moving straight up
	ld   a, ACT_LEAFRISE
	ld   bc, $0000
	call ActS_SpawnRel
	
	; Wait 16 frames before spawning another one
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	
	; If we haven't spawned all 3 leaves, loop this routine
	ld   hl, hActCur+iWoodManRiseLeft
	dec  [hl]
	ret  nz
	
	jp   ActS_IncRtnId
	
;================ Act_WoodMan_ThrowShield ================
; Waits for the rising leaves to despawn before throwing the shield.
Act_WoodMan_ThrowShield:
	;
	; Continue with the idle animation until all rising leaves have gone offscreen.
	;
	call Act_WoodMan_AnimIdle
	ld   a, ACT_LEAFRISE
	call ActS_CountById
	ld   a, b
	and  a			; Leaf count > 0?
	ret  nz			; If so, wait
	
	; Face the player in preparation for jumping towards him
	call ActS_FacePl
	
	;
	; Signal out to the shield actors to throw the shield forwards at 1px/frame.
	;
	; This signal is the movement speed for the shield's origin,
	; so it should be $01 if it's moving right, $FF if it's moving left.
	;
	; That's close to the return value of ActS_GetPlDistanceX, but it needs some mungling first.
	;
	call ActS_GetPlDistanceX	; C Flag = Player is on the right
	ld   a, $00					; Start from blank canvas ("xor a" clears the C flag, can't use it)
	sbc  a						; Treat C as -1 to have one of them with all bits flipped (R -> $FF, L -> $00)
	and  $02					; Only keep bit1 (R -> $02, L -> $00)
	dec  a						; Shift down into place, with equal distance (R -> $01, L -> $FF)
	ld   [wLeafShieldOrgSpdX], a
	
	; Wait ~half a second before
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_WoodMan_SpawnFallLeaves ================
; Spawns the falling leaves and sets up the forward jump.
Act_WoodMan_SpawnFallLeaves:
	; Rise arms up for ~half a second...
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; ...before making three leaves SLOWLY fall down the screen.
	; These leaves fall from the top of the screen, moving back and forth
	; They all use the same Y position, while horizontally spread across the screen.
	
	ld   a, ACT_LEAFFALL
	ld   bc, ($00 << 8)|LOW(-$60) 	; [POI] 6 blocks above for testing, perhaps? Will be overwritten by Act_WoodMan_SetLeafFallPos
	call ActS_SpawnRel
	ld   a, OBJ_OFFSET_X+$10		; X Pos = $18
	call nc, Act_WoodMan_SetLeafFallPos
	
	ld   a, ACT_LEAFFALL
	ld   bc, $0000
	call ActS_SpawnRel
	ld   a, OBJ_OFFSET_X+$41		; X Pos = $49
	call nc, Act_WoodMan_SetLeafFallPos
	
	ld   a, ACT_LEAFFALL
	ld   bc, $0000
	call ActS_SpawnRel
	ld   a, OBJ_OFFSET_X+$70		; X Pos = $78
	call nc, Act_WoodMan_SetLeafFallPos
	
	;
	; Set up forward hop while the leaves are falling.
	;
	call ActS_FacePl		; Towards player
	ld   bc, $0080			; 0.5px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0200			; 2px/frame up
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
;================ Act_WoodMan_JumpU ================
; Jump, pre-peak.
Act_WoodMan_JumpU:
	; Use jumping sprite
	ld   a, $08
	ld   [wActCurSprMapBaseId], a
	
	; Move forward, stopping on solid walls
	call ActS_ApplySpeedFwdXColi
	; Apply gravity while moving up, until we reach the peak
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
	
;================ Act_WoodMan_JumpD ================
; Jump, post-peak.
Act_WoodMan_JumpD:
	; Use jumping sprite
	ld   a, $08
	ld   [wActCurSprMapBaseId], a
	; Move forward, stopping on solid walls
	call ActS_ApplySpeedFwdXColi
	; Apply gravity while moving down, until we touch solid ground
	call ActS_ApplySpeedDownYColi
	ret  c
	jp   ActS_IncRtnId
	
;================ Act_WoodMan_WaitShieldDespawn ================
; Waits until the Leaf Shield has fully despawned.
Act_WoodMan_WaitShieldDespawn:
	ld   a, ACT_LEAFSHIELD
	call ActS_CountById		; Get leaf count
	ld   a, b 
	and  a					; Is it != 0?
	ret  nz					; If so, return
	
	jp   ActS_IncRtnId
	
;================ Act_WoodMan_WaitFallDespawn ================
; Waits until the falling leaves have fully despawned, then loops the pattern.
Act_WoodMan_WaitFallDespawn:
	ld   a, ACT_LEAFFALL
	call ActS_CountById
	ld   a, b
	and  a
	ret  nz
	; [BUG] Improper loop point
	ld   a, ACTRTN_WOODMAN_INTRO
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_WoodMan_Unused_Nop ================
Act_WoodMan_Unused_Nop:
	ret
	
;================ Act_WoodMan_AnimIdle ================
; Handles the idle animation cycle while on the ground.
Act_WoodMan_AnimIdle:
	; Use sprites $03-$04 at 1/8 speed
	ldh  a, [hTimer]
	rrca ; /2
	rrca ; /4
	rrca ; /8 Every 8 frames...
	and  $01 ; Alternate between $00 and $01
	add  $03 ; Offset by $03
	ld   [wActCurSprMapBaseId], a
	ret
	
;================ Act_WoodMan_SetLeafFallPos ================
; Sets the spawn coordinates for the falling leaves.
; IN
; - HL: Ptr to spawned Act_WoodManLeafFall
; - A: X Position
Act_WoodMan_SetLeafFallPos:
	ld   de, iActX
	add  hl, de
	ldi  [hl], a				; iActX = A, seek to iActYSub
	inc  hl ; iActY
	ld   [hl], OBJ_OFFSET_Y+$20	; iActY = $30 (near the top of the screen)
	ret
	
;================ Act_AirMan ================
; ID: ACT_AIRMAN
Act_AirMan:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BossIntro
	dw Act_AirMan_Init
	dw Act_AirMan_Idle
	dw Act_AirMan_SpawnShot
	dw Act_AirMan_WaitShotDespawn
	dw Act_AirMan_InitJump0
	dw Act_AirMan_Jump0U
	dw Act_AirMan_Jump0D
	dw Act_AirMan_Jump1U
	dw Act_AirMan_Jump1D
	dw Act_AirMan_Reset
	DEF ACTRTN_AIRMAN_INIT = $01
	DEF ACTRTN_AIRMAN_SPAWNSHOT = $03
	
;================ Act_AirMan_Init ================
Act_AirMan_Init:
	; Do three consecutive waves of whirlwind patterns before jumping to the other side
	ld   a, $03
	ldh  [hActCur+iAirManWavesLeft], a
	; Set movement speed for later, when jumping forward
	ld   bc, $0100
	call ActS_SetSpeedX
	; Wait ~1 second idling before spawning the whirlwinds
	ld   a, $40
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_AirMan_Idle ================
; Idle on the ground.
Act_AirMan_Idle:
	; Animate fan on the ground.
	; Use sprites $03-$04 at 1/4 speed
	ldh  a, [hTimer]
	rrca ; /2
	rrca ; /4 Every 4 frames...
	and  $01 ; Alternate between $00 and $01
	add  $03 ; Offset by $03
	ld   [wActCurSprMapBaseId], a
	
	; Wait that ~1 second before doing anythinh...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; 
	; Randomize the wave pattern
	; There are four patterns, each one having four whirlwinds that have specific "paths",
	; all stored in a single table, so...
	;
	
	; Build base path ID, to the start of a random pattern
	call Rand	; Randomize value
	and  $03	; 4 patterns total (25% chance for any pattern)
	add  a		; 4 shots in a pattern
	add  a		; ""
	ldh  [hActCur+iAirManPatId], a
	
	; Initialize relative path ID, will be decremented every frame.
	; The whirlwind that gets spawned will use the path iAirManPatId + iActTimer0C - 1.
	ld   a, $04
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_AirMan_SpawnShot ================
; Spawns the whirlwinds that are part of the picked pattern, 1 at a time in reverse order.
; As a pattern is made up of four whirlwinds, this will take four frames.
Act_AirMan_SpawnShot:
	; Use different frame while spawning
	ld   a, $05
	ld   [wActCurSprMapBaseId], a
	
	;
	; Spawn the whirlwind and set up its properties, most importantly its speed.
	;
	ld   a, ACT_WHIRLWIND
	ld   bc, $0000
	call ActS_SpawnRel
	inc  hl ; iActRtnId
	inc  hl ; iActSprMap
	; Move to the same direction Air Man is facing
	ldh  a, [hActCur+iActSprMap]
	ld   [hl], a
	; Write the path ID, will be used to index Act_AirManShot_PathTbl
	ld   de, iAirManShotPathId-iActSprMap	; Seek HL to iAirManShotPathId
	add  hl, de
	ldh  a, [hActCur+iAirManPatId]			; Read base path ID
	ld   b, a
	ldh  a, [hActCur+iActTimer0C]			; Read relative path ID
	dec  a									; - 1
	add  b									; Add base to it
	ld   [hl], a							; Save result to iAirManShotPathId
	
	; Do the above 4 times in a row, to quickly spawn all whirlwinds without spiking the CPU
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Then wait for the wind to despawn, polling every 16 frames
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_AirMan_WaitShotDespawn ================
; Stay on the ground, while blowing until the wind until they all despawn.
Act_AirMan_WaitShotDespawn:

	;
	; Blow the player back immediately after all the whirlwinds spawn.
	; This is *not* what RM2 did. In that game, the player is blown back only when
	; the whirlwinds start moving forward *after* they get into position.
	;
	; This should have waited $80 frames before starting to blow the player back,
	; to be consistent with both RM2 and Act_AirManShot's timing.
	;
	ldh  a, [hActCur+iActSprMap]
	ld   bc, $00C0					; 0.75px/frame
	call Pl_SetSpeedByActDir
	
	; Animate fan
	; Use sprites $03-$04 at 1/4 speed
	ldh  a, [hTimer]
	rrca ; /2
	rrca ; /4 Every 4 frames...
	and  $01 ; Alternate between $00 and $01
	add  $03 ; Offset by $03
	ld   [wActCurSprMapBaseId], a
	
	; Poll every 16 frames...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	; Set next check delay
	ld   a, $10
	ldh  [hActCur+iActTimer0C], a
	
	; Keep waiting if all whirlwinds haven't been offscreened yet
	ld   a, ACT_WHIRLWIND
	call ActS_CountById
	ld   a, b		; Get ACT_WHIRLWIND count
	and  a			; Count != 0?
	ret  nz			; If so, return
	
	; 
	; Randomize another wave pattern, identically to before.
	;
	ld   hl, hActCur+iAirManWavesLeft
	dec  [hl]						; Any waves left?
	jp   z, ActS_IncRtnId			; If not, start jumping forward
	
	; Randomize base path ID
	call Rand
	and  $03
	add  a
	add  a
	ldh  [hActCur+iAirManPatId], a
	; Switch to spawning another wave
	ld   a, ACTRTN_AIRMAN_SPAWNSHOT
	ldh  [hActCur+iActRtnId], a
	; Initialize relative path ID
	ld   a, $04
	ldh  [hActCur+iActTimer0C], a
	ret
	
;================ Act_AirMan_InitJump0 ================
; The remaining modes handle the two consecutive jumps the player should move under.
Act_AirMan_InitJump0:
	ld   bc, $0240			; 2.25px/frame fprward
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
;================ Act_AirMan_Jump0U ================
; Jump, pre-peak.
Act_AirMan_Jump0U:
	; Use jumping frame
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	; Handle gravity moving up until the peak of the jump
	call ActS_ApplySpeedFwdXColi
	call ActS_ApplySpeedUpYColi
	ret  c
	
	jp   ActS_IncRtnId
	
;================ Act_AirMan_Jump0D ================
; Jump, post-peak.
Act_AirMan_Jump0D:
	; Use jumping frame
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	; Handle gravity moving down until we touch the ground
	call ActS_ApplySpeedFwdXColi
	call ActS_ApplySpeedDownYColi
	ret  c
	; Set up second, higher jump at 3px/frame
	ld   bc, $0300
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
;================ Act_AirMan_Jump1U ================
; High jump, pre-peak.
Act_AirMan_Jump1U:
	; Use jumping frame
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	; Handle gravity moving up until the peak of the jump
	call ActS_ApplySpeedFwdXColi
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
	
;================ Act_AirMan_Jump1D ================
; High jump, post-peak.
Act_AirMan_Jump1D:
	; Use jumping frame
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	; Handle gravity moving down until we touch the ground
	call ActS_ApplySpeedFwdXColi
	call ActS_ApplySpeedDownYColi
	ret  c
	; Flip horizontally
	ldh  a, [hActCur+iActSprMap]
	xor  ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	;--
	; Not necessary
	ld   a, $03
	ldh  [hActCur+iAirManWavesLeft], a
	;--
	jp   ActS_IncRtnId
	
;================ Act_AirMan_Reset ================
; Loop pattern to the start.
Act_AirMan_Reset:
	ld   a, ACTRTN_AIRMAN_INIT
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_AirManShot_PathTbl ================
; Defines the initial speed values a whirlwind can follow.
; When it spawns, a shot will move in a straight line using these speed for $40 frames (~1 second),
; effectively defining the "path" it will take.
Act_AirManShot_PathTbl:
	;  X SPD  Y SPD ;  ID
	; PATTERN 1
	dw $00CC, $00CC ; $00
	dw $0088, $0088 ; $01
	dw $00CC, $0044 ; $02
	dw $0110, $0044 ; $03
	; PATTERN 2
	dw $0044, $0000 ; $04
	dw $0110, $00CC ; $05
	dw $00CC, $0088 ; $06
	dw $0110, $0088 ; $07
	; PATTERN 3
	dw $0110, $0000 ; $08
	dw $0110, $00CC ; $09
	dw $0044, $0088 ; $0A
	dw $0088, $00CC ; $0B
	; PATTERN 4
	dw $0110, $0044 ; $0C
	dw $0110, $0088 ; $0D
	dw $0066, $0000 ; $0E
	dw $00CC, $00CC ; $0F

;================ Act_HardKnuckle ================
; ID: ACT_HARDKNUCKLE
; Boss version of Hard Knuckle, a fist that homes in twice.
Act_HardKnuckle:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_HardKnuckle_SetMove0
	dw Act_HardKnuckle_Move0
	dw Act_HardKnuckle_SetMove1
	dw Act_HardKnuckle_WaitMove1
	dw Act_HardKnuckle_Move1

;================ Act_HardKnuckle_SetMove0 ================
; Set up 1st movement.
Act_HardKnuckle_SetMove0:
	; Take a snapshot of the player's current position, and use it as target
	ld   a, [wPlRelX]
	ld   [wHardFistTargetX], a
	ld   a, [wPlRelY]
	ld   [wHardFistTargetY], a
	; Set up speed values that also home in to that snapshot
	call ActS_AngleToPl
	call ActS_DoubleSpd
	jp   ActS_IncRtnId
	
;================ Act_HardKnuckle_Move0 ================
; 1st movement.
Act_HardKnuckle_Move0:
	; Move at the previously set speed
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	
	;
	; Keep moving until we reach around the target position.
	;
	
	; If the we aren't within 16px from the horizontal target, wait.
	ld   a, [wHardFistTargetX]	; B = X Target
	ld   b, a
	ldh  a, [hActCur+iActX]		; A = X Pos
	sub  b						; Get distance
	jr   nc, .chkX				; Underflowed? If not, skip
	xor  $FF					; Otherwise, make absolute
	inc  a
	scf  
.chkX:
	and  $F0					; Diff != $0x?
	ret  nz						; If so, return
	
	; If the we aren't within 16px from the vertical target, wait.
	ld   a, [wHardFistTargetY]
	ld   b, a
	ldh  a, [hActCur+iActY]
	sub  b
	jr   nc, .chkY
	xor  $FF
	inc  a
	scf  
.chkY:
	and  $F0
	ret  nz
	
	; Then, keep moving for 24 frames at the same speed, going a bit over the target
	ld   a, $18
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_HardKnuckle_SetMove1 ================
; After 1st movement.
Act_HardKnuckle_SetMove1:
	; Keep moving for those 24 frames...
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Then take a new snapshot of the player location
	call ActS_AngleToPl
	call ActS_DoubleSpd
	
	; Stop for 6 frames
	ld   a, $06
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_HardKnuckle_WaitMove1 ================
; Waits for those 6 frames before moving.
Act_HardKnuckle_WaitMove1:
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	jp   ActS_IncRtnId
	
;================ Act_HardKnuckle_Move1 ================
; Moves at the previously set speed, crossing over the target.
Act_HardKnuckle_Move1:
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
;================ Act_TopManShot ================
; ID: ACT_SPINTOPSHOT
; Spinning top shot which moves into place, then targets the player. Spawned by Top Man.
Act_TopManShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_TopManShot_Init
	dw Act_TopManShot_MoveU
	dw Act_TopManShot_Wait
	dw Act_TopManShot_MoveToPl

;================ Act_TopManShot_Init ================
Act_TopManShot_Init:
	; Animate spinning top.
	; Use sprites $00-$01 at 3/8 speed
	ld   c, $03
	call ActS_Anim2
	
	; Move diagonally up for ~1 second.
	ld   a, $30
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_TopManShot_MoveU ================
; Moves the spinning top into position.
Act_TopManShot_MoveU:
	; Animate spinning top.
	ld   c, $03
	call ActS_Anim2
	
	; Move for that ~1 second.
	; The initial speed values come from Act_TopMan_SpawnShots.
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Wait half a second idling
	ld   a, 30
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_TopManShot_Wait ================
; Waits for a bit.
Act_TopManShot_Wait:
	; Animate spinning top
	ld   c, $03
	call ActS_Anim2
	
	; Wait for that half a second...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Take a snapshot of the player position
	call ActS_AngleToPl
	call ActS_DoubleSpd		; And move at double speed there
	jp   ActS_IncRtnId
	
;================ Act_TopManShot_MoveToPl ================
; Moves towards the player.
Act_TopManShot_MoveToPl:
	; Animate spinning top.
	ld   c, $03
	call ActS_Anim2
	
	; Move towards that player position, until we get offscreened
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
;================ Act_MagnetManShot ================
; ID: ACT_MAGNETMISSILE
; Magnet that moves horizontally, then straight down when it sees the player.
; As it's thrown by Magnet Man on the ceiling, it doesn't ever need to move up.
Act_MagnetManShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_MagnetManShot_Init
	dw Act_MagnetManShot_MoveNoChkH
	dw Act_MagnetManShot_MoveChkH
	dw Act_MagnetManShot_MoveD

;================ Act_MagnetManShot_Init ================
Act_MagnetManShot_Init:
	ld   bc, $0200				; Move forward at 2px/frame
	call ActS_SetSpeedX
	ld   a, $0C					; Move for 12 frames with no checks	
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_MagnetManShot_MoveNoChkH ================
; Move forward without checking if the player is below.
; This cooldown period prevents the magnets from directly moving down when
; the player is under Magnet Man.
Act_MagnetManShot_MoveNoChkH:
	; Move forward at 2px/frame for 12 frames
	call ActS_ApplySpeedFwdXColi		; Touched a solid block?
	jr   nc, Act_MagnetManShot_Explode	; If so, explode
	ldh  a, [hActCur+iActTimer0C]
	sub  $01							; Timer--
	ldh  [hActCur+iActTimer0C], a		; Timer != 0?
	ret  nz								; If so, return
	jp   ActS_IncRtnId
	
;================ Act_MagnetManShot_MoveChkH ================
; Move forward, checking for the player's position.
Act_MagnetManShot_MoveChkH:
	; Move forward at 2px/frame, explode if touching a solid block
	call ActS_ApplySpeedFwdXColi
	jr   nc, Act_MagnetManShot_Explode
	
	; If the player is below, halt and drop down
	call ActS_GetPlDistanceX
	cp   $04			; DiffX >= $04?
	ret  nc				; If so, return
	
	ld   bc, $0200		; Drop down at 2px/frame
	call ActS_SetSpeedY
	ld   a, $02			; Use downward-facing sprite
	call ActS_SetSprMapId
	jp   ActS_IncRtnId
	
;================ Act_MagnetManShot_MoveD ================
; Move down until we touch solid ground, then explode.
Act_MagnetManShot_MoveD:
	call ActS_ApplySpeedFwdYColi
	jr   nc, Act_MagnetManShot_Explode
	ret
	
;================ Act_MagnetManShot_Explode ================
Act_MagnetManShot_Explode:
	jp   ActS_Explode
	
;================ Act_NeedleManShot ================
; ID: ACT_NEEDLECANNON
; Boss version of the Needle Cannon shot, which moves towards the player.
Act_NeedleManShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_NeedleManShot_TrackPl
	dw Act_NeedleManShot_Move

;================ Act_NeedleManShot_TrackPl ================
; Snapshot the player's position
Act_NeedleManShot_TrackPl:
	call ActS_AngleToPl
	call ActS_DoubleSpd
	jp   ActS_IncRtnId
	
;================ Act_NeedleManShot_Move ================
; Move towards that at double speed
Act_NeedleManShot_Move:
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
;================ Act_CrashManShot ================
; ID: ACT_CRASHBOMB
; Boss version of the Crash Bomb.
; It needs to explode fast enough to win the spawn check Act_CrashMan_JumpShootD makes over ACT_CRASHBOMBEXPL.
Act_CrashManShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_CrashManShot_TrackPl
	dw Act_CrashManShot_MoveToPl
	dw Act_CrashManShot_SetExplDelay
	dw Act_CrashManShot_WaitExpl
	dw Act_CrashManShot_Explode

;================ Act_CrashManShot_TrackPl ================
; Take a snapshot of the player's position.
; Unlike the RM2 counterpart, which just moves diagonally down, this directly targets the player.
Act_CrashManShot_TrackPl:
	call ActS_AngleToPl
	call ActS_DoubleSpd
	jp   ActS_IncRtnId
	
;================ Act_CrashManShot_MoveToPl ================
Act_CrashManShot_MoveToPl:
	; Move until we hit a solid wall
	call ActS_ApplySpeedFwdXColi
	jp   nc, ActS_IncRtnId
	call ActS_ApplySpeedFwdYColi
	jp   nc, ActS_IncRtnId
	ret
	
;================ Act_CrashManShot_SetExplDelay ================
Act_CrashManShot_SetExplDelay:
	; Explode in ~half a second
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_CrashManShot_WaitExpl ================
Act_CrashManShot_WaitExpl:
	; Wait for that ~half a second...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	jp   ActS_IncRtnId
	
;================ Act_CrashManShot_Explode ================
Act_CrashManShot_Explode:
	; Spawn a large explosion with a misleadingly larger collision box directly over us.
	ld   a, ACT_CRASHBOMBEXPL
	ld   bc, $0000
	call ActS_SpawnRel
	
	; Alongside an extra small explosion to replace the bomb, which looks out of place once you notice it.
	jp   ActS_Explode
	
;================ Act_MetalManShot ================
; ID: ACT_METALBLADE
; Boss version of the Metal Blade.	
Act_MetalManShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_MetalManShot_TrackPl
	dw Act_MetalManShot_Move

;================ Act_MetalManShot_TrackPl ================
Act_MetalManShot_TrackPl:
	; Move towards the player's *origin* (bottom of the player).
	; This is the only actor that targets it over the center of the player.
	ld   b, $00
	call ActS_AngleToPlCustom
	call ActS_DoubleSpd
	jp   ActS_IncRtnId
	
;================ Act_MetalManShot_Move ================
Act_MetalManShot_Move:
	; Animate the shot
	ld   c, $01
	call ActS_Anim2
	
	; Move by the previously set position
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
;================ Act_AirManShot ================
; ID: ACT_WHIRLWIND
; Whirlwind shot spawned by Air Man, part of a wave.
Act_AirManShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_AirManShot_InitMoveToPos
	dw Act_AirManShot_MoveToPos
	dw Act_AirManShot_Wait
	dw Act_AirManShot_MoveFwd

;================ Act_AirManShot_InitMoveToPos ================
Act_AirManShot_InitMoveToPos:
	;
	; This whirlwind is currently directly overlapping Air Man.
	; It needs to move in a line into the position defined for the wave pattern.
	;
	; We don't have actual target coordinates though, what we do have is its speed values
	; used when moving into position. The whirlwind will be moved by that for ~1 second.
	; Read out those speed values from the table entry, indexed by path ID.
	;
	ldh  a, [hActCur+iAirManShotPathId]
	ld   l, a			; HL = PathId
	ld   h, $00
	add  hl, hl			; *2
	add  hl, hl			; *4 (Each entry is a pair of words)
	ld   de, Act_AirManShot_PathTbl
	add  hl, de			; Seek to entry
	ldi  a, [hl]		; Read the four bytes out
	ldh  [hActCur+iActSpdXSub], a
	ldi  a, [hl]
	ldh  [hActCur+iActSpdX], a
	ldi  a, [hl]
	ldh  [hActCur+iActSpdYSub], a
	ld   a, [hl]
	ldh  [hActCur+iActSpdY], a
	
	; Move for ~1 second
	ld   a, $40
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_AirManShot_MoveToPos ================
; Moves the whirlwind into position.
Act_AirManShot_MoveToPos:
	; Animate the whirlwind
	ld   bc, $0301			; Use frames $00-$02 at 1/4 speed
	call ActS_AnimCustom
	
	; Move diagonally forwards for $40 frames
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Wait ~1 second
	ld   a, $40
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_AirManShot_Wait ================
; Gives some time for the player to assess the pattern.
Act_AirManShot_Wait:
	; Animate the whirlwind
	ld   bc, $0301
	call ActS_AnimCustom
	
	; Wait for that ~1 second...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Start moving the whirlwind straight forward, at 1px/frame
	ld   bc, $0100			; 1px/frame horz
	call ActS_SetSpeedX
	ld   bc, $0000			; No vertical movement
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
;================ Act_AirManShot_MoveFwd ================
; Moves the whirlwind straight forward.
; As this happens to all whirlwinds at once, the entire pattern gets moved forward.
Act_AirManShot_MoveFwd:
	; [BUG] We're forgetting to animate the whirlwind.
	; [POI] Ideally at this point we should tell Air Man to start blowing the player forward
	;       but that happens as soon as the whirlwinds spawn...
	
	; Move forward until it gets offscreened.
	; Air Main is waiting for that to happen before jumping forward.
	call ActS_ApplySpeedFwdX
	ret
	
;================ Act_WoodManLeafShield ================
; ID: ACT_LEAFSHIELD
; Single leaf, part of a set of four that makes up Wood Man's Leaf Shield.
Act_WoodManLeafShield:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_WoodManLeafShield_Init
	dw Act_WoodManLeafShield_Around
	dw Act_WoodManLeafShield_Thrown

;================ Act_WoodManLeafShield_Init ================
Act_WoodManLeafShield_Init:
	;
	; Set the origin point for the leaf shield.
	; While the leaves are set to rotate around Wood Man, that *only* happens from the next routine.
	;
	; Currently, they have the same coordinates as Wood Man himself, so the shield origin point is 13px above that.
	;
	ldh  a, [hActCur+iActX]				; X Origin: Wood Man's X position (center)
	ldh  [hActCur+iLeafShieldOrgX], a	
	ldh  a, [hActCur+iActY]				; Y Origin: Wood Man's Y position - 13 (middle)
	sub  $0B
	ldh  [hActCur+iLeafShieldOrgY], a
	jp   ActS_IncRtnId
	
;================ Act_WoodManLeafShield_Around ================
; Leaf Shield rotates around Wood Man, without moving the origin point.
Act_WoodManLeafShield_Around:
	
	;
	; Handle the rotation sequence.
	;
	; This is accomplished with a table of sine values that loop every $40 entries.
	; Each value is a position relative to the shield's origin, when summed together 
	; you get the final position.
	;
	; The rotation pattern using the sine is accomplished by having the X index
	; shifted forward by $10 entries, through the base table pointer itself being ahead.
	; To account for that it means the table is $50 bytes large in total, with the last
	; $10 being identical to the first $10.
	;
	; This has a similar effect to what's done by ActS_ApplyCirclePath, except the positions
	; aren't relative to each other, but to an origin point.
	;
	
	; X POSITION
	; iActX = iLeafShieldOrgX + Act_WoodManLeafShield_SinePat.y[iActTimer0C % $40]
	ldh  a, [hActCur+iActTimer0C]
	and  $3F									; Wrap around every $40 entries
	ld   hl, Act_WoodManLeafShield_SinePat.x	; HL = Ptr to table base
	ld   b, $00									; BC = iActTimer0C % $40
	ld   c, a
	add  hl, bc									; HL = Ptr to rel. offset
	ldh  a, [hActCur+iLeafShieldOrgX]			; Get absolute coordinate
	add  [hl]									; += relative from entry, to get final pos
	ldh  [hActCur+iActX], a						; Overwrite
	
	; Y POSITION
	; iActY = iLeafShieldOrgX + Act_WoodManLeafShield_SinePat.y[iActTimer0C % $40]
	ld   hl, Act_WoodManLeafShield_SinePat.y	; Same thing but for the other coordinate
	ldh  a, [hActCur+iActTimer0C]
	and  $3F
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldh  a, [hActCur+iLeafShieldOrgY]
	add  [hl]
	ldh  [hActCur+iActY], a
	
	; Increment table index for next time we get here
	ldh  a, [hActCur+iActTimer0C]
	add  $01
	ldh  [hActCur+iActTimer0C], a
	
	; Wait until we've been signaled by Act_WoodMan to throw the shield.
	; For performance reasons, we're given a movement speed to apply to the origin point.
	ld   a, [wLeafShieldOrgSpdX]
	and  a							; Any throw speed set yet?
	ret  z							; If not, wait
	
	;--
	; [POI] Not necessary, the leaves don't move forward through their normal speed.
	;       Instead, the origin is moved forward through the speed Act_WoodMan wrote to wLeafShieldOrgSpdX.
	;       Maybe there was simpler logic on throw at some point, that *did* simply move the leaves forward without rotating them?
	call ActS_FacePl
	ld   bc, $0100
	call ActS_SetSpeedX
	;--
	jp   ActS_IncRtnId
	
;================ Act_WoodManLeafShield_Thrown ================
; Leaf Shield rotates around the origin point, which moves forward.
Act_WoodManLeafShield_Thrown:
	;
	; Move the shield's origin forward
	;
	ld   hl, hActCur+iLeafShieldOrgX	; iLeafShieldOrgX += wLeafShieldOrgSpdX
	ld   a, [wLeafShieldOrgSpdX]
	add  [hl]
	ld   [hl], a
	
	;
	; Then do the usual process for rotating the leaves.
	;
	
	; X POSITION
	; iActX = iLeafShieldOrgX + Act_WoodManLeafShield_SinePat.y[iActTimer0C % $40]
	ldh  a, [hActCur+iActTimer0C]
	and  $3F									; Wrap around every $40 entries
	ld   hl, Act_WoodManLeafShield_SinePat.x	; HL = Ptr to table base
	ld   b, $00									; BC = iActTimer0C % $40
	ld   c, a
	add  hl, bc									; HL = Ptr to rel. offset
	ldh  a, [hActCur+iLeafShieldOrgX]			; Get absolute coordinate
	add  [hl]									; += relative from entry, to get final pos
	ldh  [hActCur+iActX], a						; Overwrite
	
	; Y POSITION
	; iActY = iLeafShieldOrgX + Act_WoodManLeafShield_SinePat.y[iActTimer0C % $40]
	ld   hl, Act_WoodManLeafShield_SinePat.y	; Same thing but for the other coordinate
	ldh  a, [hActCur+iActTimer0C]
	and  $3F
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldh  a, [hActCur+iLeafShieldOrgY]
	add  [hl]
	ldh  [hActCur+iActY], a
	
	; Increment table index for next time we get here
	ldh  a, [hActCur+iActTimer0C]
	add  $01
	ldh  [hActCur+iActTimer0C], a
	
	ret
	
;================ Act_WoodManLeafShield_SinePat ================
; Leaf positions, relative to the shield's origin.
; See also: Act_WoodManLeafShield_Around
Act_WoodManLeafShield_SinePat:
.y: db $F0,$F0,$F0,$F1,$F1,$F2,$F3,$F4,$F5,$F6,$F7,$F8,$FA,$FB,$FD,$FE ; $00 ;
.x:	db $00,$02,$03,$05,$06,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F,$0F,$10,$10 ; $10 ; $00
	db $10,$10,$10,$0F,$0F,$0E,$0D,$0C,$0B,$0A,$09,$08,$06,$05,$03,$02 ; $20 ; $10
	db $00,$FE,$FD,$FB,$FA,$F8,$F7,$F6,$F5,$F4,$F3,$F2,$F1,$F1,$F0,$F0 ; $30 ; $20
	db $F0,$F0,$F0,$F1,$F1,$F2,$F3,$F4,$F5,$F6,$F7,$F8,$FA,$FB,$FD,$FE ;     ; $30

;================ Act_WoodManLeafRise ================
; ID: ACT_LEAFRISE
; Leaf rising up from Wood Man.
Act_WoodManLeafRise:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_WoodManLeafRise_Init
	dw Act_WoodManLeafRise_MoveU

;================ Act_WoodManLeafRise_Init ================
Act_WoodManLeafRise_Init:
	ldh  a, [hActCur+iActSprMap]	; Move up
	and  $FF^ACTDIR_D				; (clear down direction flag)
	ldh  [hActCur+iActSprMap], a
	ld   bc, $0200					; At 2px/frame
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
;================ Act_WoodManLeafRise_MoveU ================
Act_WoodManLeafRise_MoveU:
	; Move up at 2px/frame, until they go offscreen.
	; Act_WoodMan waits for that before throwing the shield.
	call ActS_ApplySpeedFwdY
	ret
	
;================ Act_WoodManLeafFall ================
; ID: ACT_LEAFFALL
; Falling leaf, which moves back and forth.
Act_WoodManLeafFall:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_WoodManLeafFall_Init
	dw Act_WoodManLeafFall_Move

;================ Act_WoodManLeafFall_Init ================
Act_WoodManLeafFall_Init:
	; Move down, and move right as initial horizontal direction
	ldh  a, [hActCur+iActSprMap]
	or   ACTDIR_R|ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	
	ld   bc, $0100			; 1px/frame horizontally
	call ActS_SetSpeedX
	ld   bc, $0060			; 0.375px/frame down
	call ActS_SetSpeedY
	ld   a, $10				; Turn every 16 frames
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_WoodManLeafFall_Move ================
Act_WoodManLeafFall_Move:
	;
	; Move by the previously set speed
	;
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	
	;
	; Turn every 16 frames
	;
	ldh  a, [hActCur+iActTimer0C]
	sub  $01						; TurnTimer--
	ldh  [hActCur+iActTimer0C], a	; Has it elapsed?
	ret  nz							; If not, keep moving at that direction
	
	ldh  a, [hActCur+iActSprMap]	; Otherwise, turn around horizontally
	xor  ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	ld   a, $10						; Move for 16 frames to the other side
	ldh  [hActCur+iActTimer0C], a
	ret
	
;================ Act_CrashManShotExpl ================
; ID: ACT_CRASHBOMBEXPL
; Large explosion caused by the boss version of the Crash Bombs.
; Unlike the player ones, these are an actual entity that hurts (the player) and have a larger than expected collision box.
Act_CrashManShotExpl:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_CrashManShotExpl_Init
	dw Act_CrashManShotExpl_Anim

;================ Act_CrashManShotExpl_Init ================
Act_CrashManShotExpl_Init:
	; Show for ~half a second
	ld   a, $20
	ldh  [hActCur+iActTimer0C], a
	jp   ActS_IncRtnId
	
;================ Act_CrashManShotExpl_Anim ================
Act_CrashManShotExpl_Anim:
	; The explosion is simply a 4-frame looping animation
	ld   c, $01
	call ActS_Anim4
	
	; Display the above, maintaining the oversized hitbox, for that ~half a second.
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Then despawn the explosion.
	; It should have been done by simply resetting iActId, and not by using the normal explosion,
	; which looks out of place compared to the larger explosion animation we were playing.
	jp   ActS_Explode
	
;================ Act_GroundExpl ================
; ID: ACT_GROUNDEXPL
; Weird-looking looping explosion used during the Wily Castle cutscene, when ground explodes 
; from under Rockman and he falls into the teleporter room.
;
; For some reason, the graphics associated with this actor are stored next to Needle Cannon
; and Metal Blade' shot graphics, and expect to be loaded in VRAM where weapon GFX load.
;
; This actor is only used to perform the animation and play the explosion sound. The blocks
; the player falls through are never solid, the cutscene merely writes blank blocks to the tilemap
; during the explosion to give the effect of the two blocks being gone.
Act_GroundExpl:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_GroundExpl_Init
	dw Act_GroundExpl_Play

;================ Act_GroundExpl_Init ================
Act_GroundExpl_Init:
	; Weird sound effect choice
	ld   a, SFX_ENEMYDEAD
	ldh  [hSFXSet], a
	; Use sprites $00-$02 at 1/8 speed
	ld   de, ($00 << 8)|$02
	ld   c, $08
	call ActS_InitAnimRange
	jp   ActS_IncRtnId
	
;================ Act_GroundExpl_Play ================
Act_GroundExpl_Play:
	; Wait until the explosion is finished
	call ActS_PlayAnimRange
	ret  z
	; Then loop back the to the first routine, resetting the animation.
	; This actor never despawns on its own, it's the screen transition that does it.
	xor  a
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_NewShotmanShotV ===============
; ID: ACT_NEOMETSHOT
; Neo Metall's shot, spawned in three, can be horizontal or diagonal.
Act_NeoMetShot:
	; The shot has a 4-frame animation which rotates the "shine" on the sprite.
	ld   c, $01
	call ActS_Anim4
	; Apply movement in both directions
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY ; Could be 0 too
	ret
	
; =============== Act_NewShotmanShotV ===============
; ID: ACT_NEWSHOTMANSHOTV
; New Shotman's vertical shot, spawned in pairs, which moves in an arc.
Act_NewShotmanShotV:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_NewShotmanShotV_JumpU
	dw Act_NewShotmanShotV_JumpD
; =============== Act_NewShotmanShotV_JumpU ===============
; Jump, pre-peak.
Act_NewShotmanShotV_JumpU:
	; [POI] Bounce on solid walls
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Apply gravity while moving up until we reach the peak
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
; =============== Act_NewShotmanShotV_JumpD ===============
; Jump, post-peak.
Act_NewShotmanShotV_JumpD:
	; [POI] Bounce on solid walls
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Apply gravity while moving down until we hit the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	; Despawn when touching the ground
	jp   ActS_Explode
	
; =============== Act_NewShotmanShotH ===============
; ID: ACT_NEWSHOTMANSHOTH
; New Shotman's horizontal shot, which moves horizontally at a fixed 1px/frame speed.
Act_NewShotmanShotH:
	; Set up the speed the first time we get here
	ldh  a, [hActCur+iActRtnId]
	or   a				; Routine != 0?
	jr   nz, .move		; If so, jump
.init:
	ld   bc, $0100		; 1px/frame forward
	call ActS_SetSpeedX
	jp   ActS_IncRtnId
.move:
	; This is the same animation Act_NeoMetShot does, but inconsistently the vertical shot doesn't.
	ld   c, $01
	call ActS_Anim4
	; Move forward at 1px/frame
	call ActS_ApplySpeedFwdX
	ret
	
; =============== Act_ShotmanShot ===============
; ID: ACT_SHOTMANSHOT
; Shotman's shot, which moves in an arc.
Act_ShotmanShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_ShotmanShot_JumpU
	dw Act_ShotmanShot_JumpD
; =============== Act_ShotmanShot_JumpU ===============
; Jump, pre-peak.
Act_ShotmanShot_JumpU:
	; Move shot forward at its set speed
	call ActS_ApplySpeedFwdX
	; Apply gravity while moving up until we reach the peak
	call ActS_ApplySpeedUpY
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_ShotmanShot_JumpD ===============
; Jump, post-peak.
Act_ShotmanShot_JumpD:
	; Move shot forward at its set speed
	call ActS_ApplySpeedFwdX
	; Apply gravity while moving down
	call ActS_ApplySpeedDownY
	; The shot moves through the ground, despawning when it moves offscreen
	ret
	
; =============== ActS_SpawnArcShot ===============
; Spawns a shot that follows a vertical arc.
; IN
; - A: Shot direction and sprite ID (iActSprMap)
; - B: Relative X pos
; - C: Relative Y pos
; - D: Vertical speed (px/frame)
; - E: Actor ID
;      This should point to a shot that respects gravity.
ActS_SpawnArcShot:
	; Save these two for later
	DEF tActSprMap = wTmpCFE6
	DEF tActSpdV = wTmpCFE7
	ld   [tActSprMap], a	; Save A
	ld   a, d
	ld   [tActSpdV], a		; Save D
	
	;
	; Attempt to spawn the shot actor
	;
	ld   a, e
	call ActS_SpawnRel		; HL = Ptr to spawned slot
	ret  c					; Could it spawn? If not, return
	
	;
	; Adjust the shot's properties.
	;
	push hl ; Save slot ptr
	
		;
		; HORIZONTAL SPEED
		; 
		; Adjusted to try homing into the player, by pick a different one depending on how far away the player is.
		; This is read off a table indexed by horizontal distance, in groups of 2 blocks.
		;
	
		; Index = (Distance / $10) & $0E
		call ActS_GetPlDistanceX	; Get distance in pixels
		swap a						; / $10 to get distance in blocks
		and  $0E					; Fix for above + remove the lowest bit.
									; The latter is because we're indexing a word table so offsets can't be odd,
									; but it also has the effect of each index being used for two blocks.
		; Index the table with that
		ld   hl, ActS_ArcShotSpdXTbl	; HL = Table base
		ld   b, $00			; BC = Index
		ld   c, a
		add  hl, bc			; Seek to entry
		; Read out to the registers expected by ActS_SetShotSpd
		ld   c, [hl]		; C = Horizontal speed (subpixels)
		inc  hl
		ld   b, [hl]		; B = Horizontal speed (pixels)
		
		;
		; VERTICAL SPEED
		;
		; Passed from this subroutine, in pixels.
		;
		ld   a, [tActSpdV]
		ld   d, a			; D = tActSpdV
		ld   e, $00			; E = $00
		
		;
		; SHOT DIRECTION / SPRITE ID
		;
		; Also passed from this subroutine.
		;
		ld   a, [tActSprMap] ; A = tActSprMap
		
	pop  hl ; HL = Ptr to spawned slot
	jp   ActS_SetShotSpd
	
; =============== ActS_ArcShotSpdXTbl ===============
; Horizontal shot speed based on the player's distance, in groups of 2 blocks.
ActS_ArcShotSpdXTbl:
	;  SPEED | px/frame | PLAYER DISTANCE
	dw $0080 ;     0.5  | $00-$1F
	dw $00C0 ;     0.75 | $20-$3F
	dw $0100 ;     1.0  | $40-$5F
	; [POI] The rest are too far away, and don't happen to get used
	dw $0180 ;     1.5  | $60-$7F
	dw $01C0 ;     1.75 | $80-$9F
	dw $0200 ;     2.0  | $A0-$BF
	dw $0280 ;     2.5  | $C0-$DF
	dw $0300 ;     3.0  | $E0-$FF


; =============== SPREAD SHOTS ===============
; The following subroutines handle spawning shot patterns, all following a similar pattern.

; =============== Act_NeoMet_SpawnShots ===============
; Spawns the individual shots that make up a Met's 3-way spreadshot.
Act_NeoMet_SpawnShots:

	;
	; FIRST SHOT
	;
	ld   a, ACT_NEOMETSHOT			
	ld   bc, ($00 << 8)|LOW(-$04)	; Spawn first shot 4px to the left of the Met
	call ActS_SpawnRel				; Could it spawn?
	ret  c							; If not, return
	;--
	; Every shot inherits the same direction as its parent (the Met)
	DEF tActDir = wTmpCF52
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R
	ld   [tActDir], a
	;--
	ld   bc, $00B4 ; $00.B4px/frame forwards
	ld   de, $00B4 ; $00.B4px/frame upwards
	call ActS_SetShotSpd
	
	;
	; For the remainder of the shots, call ActS_Spawn to reuse the spawn settings
	; that ActS_SpawnRel generated for us. Therefore, all of the shots will reuse
	; the same origin, which is 4px to the left of the Met.
	;
	
	;
	; SECOND SHOT
	;
	call ActS_Spawn
	ret  c
	ld   a, [tActDir]
	ld   bc, $00FF ; Nearly 1px/frame forwards
	ld   de, $0000 ; No vertical movement
	call ActS_SetShotSpd
	
	;
	; THIRD SHOT
	;
	call ActS_Spawn
	ret  c
	ld   a, [tActDir]	; Set downwards direction
	or   ACTDIR_D 
	ld   bc, $00B4 ; $00.B4px/frame forwards
	ld   de, $00B4 ; $00.B4px/frame downwards
	jp   ActS_SetShotSpd
	
; =============== Act_Tama_SpawnFleas ===============
; Spawns the three fleas that jump from Tama once the Yarn ball is destroyed.
; Each of the fleas starts from the same position, but has a different jump arc.
Act_Tama_SpawnFleas:
	; FIRST FLEA
	ld   a, ACT_TAMAFLEA
	ld   bc, ($00 << 8)|LOW(-$14)	; 20px to the left
	call ActS_SpawnRel
	ret  c
	
	;--
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R
	ld   [tActDir], a
	;--
	ld   bc, $00C0 ; 0.75px/frame fwd
	ld   de, $0180 ; 1.5px/frame up
	call ActS_SetShotSpd
	
	; SECOND FLEA
	call ActS_Spawn
	ret  c
	ld   a, [tActDir]
	ld   bc, $0100 ; 1px/frame fwd
	ld   de, $0200 ; 2px/frame up
	call ActS_SetShotSpd
	
	; THIRD FLEA
	call ActS_Spawn
	ret  c
	ld   a, [tActDir]
	ld   bc, $0140 ; 1.25px/frame fwd
	ld   de, $0280 ; 2.5px/frame
	jp   ActS_SetShotSpd
	
; =============== Act_Hari_SpawnShots ===============
; Spawns the individual needles that make up Hari Harry's spread shot.
Act_Hari_SpawnShots:
	; #1 Left
	ld   a, ACT_HARISHOT
	ld   bc, (LOW(-$0E) << 8)|LOW(-$04) ; 14px left, 4px up
	call ActS_SpawnRel
	ret  c
	ld   a, ($00 << 3) ; Sprite 0 (h needle)
	ld   bc, $0180 ; 1.5px/frame left
	ld   de, $0000 ; no vertical
	call ActS_SetShotSpd
	
	; #2 Top-left
	ld   a, ACT_HARISHOT
	ld   bc, (LOW(-$08) << 8)|LOW(-$08) ; 8px left, 8px up
	call ActS_SpawnRel
	ret  c
	ld   a, ($01 << 3) ; Sprite 1 (diag needle)
	ld   bc, $010E ; ~1px/frame left
	ld   de, $010E ; ~1px/frame up
	call ActS_SetShotSpd
	
	; #3 Up
	ld   a, ACT_HARISHOT
	ld   bc, (LOW($00) << 8)|LOW(-$10) ; 16px up
	call ActS_SpawnRel
	ret  c
	ld   a, ($02 << 3) ; Sprite 2 (v needle)
	ld   bc, $0000 ; no horizontal
	ld   de, $0180 ; 1.5px/frame up
	call ActS_SetShotSpd
	
	; #4 Top-right
	ld   a, ACT_HARISHOT
	ld   bc, (LOW($08) << 8)|LOW(-$08) ; 8px right, 8px up
	call ActS_SpawnRel
	ret  c
	ld   a, ACTDIR_R|($01 << 3) ; Sprite 1 (diag needle)
	ld   bc, $010E ; ~1px/frame right
	ld   de, $010E ; ~1px/frame up
	call ActS_SetShotSpd
	
	; #5 Right
	ld   a, ACT_HARISHOT
	ld   bc, (LOW($0E) << 8)|LOW(-$04) ; 14px right, 4px up
	call ActS_SpawnRel
	ret  c
	ld   a, ACTDIR_R|($00 << 3) ; Sprite 0 (h needle)
	ld   bc, $0180 ; 1.5px/frame right
	ld   de, $0000 ; no vertical
	jp   ActS_SetShotSpd
	
; =============== Act_TopMan_SpawnShots ===============
; Spawns the three spinning tops in Top Man's fight.
Act_TopMan_SpawnShots:
	; FIRST SHOT
	ld   a, ACT_SPINTOPSHOT
	ld   bc, ($00 << 8)|LOW(-$04) ; 4px left
	call ActS_SpawnRel
	ret  c
	;--
	; Top Man throws all three shots forwards, so they face the same direction as him
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R
	ld   [tActDir], a
	;--
	ld   bc, $00C0 ; 0.75px/frame forwards
	ld   de, $00C0 ; 0.75px/frame upwards
	call ActS_SetShotSpd
	
	; SECOND SHOT
	call ActS_Spawn
	ret  c
	ld   a, [tActDir]
	ld   bc, $0120 ; 1.125px/frame forwards
	ld   de, $0120 ; 1.125px/frame forwards
	call ActS_SetShotSpd
	
	; THIRD SHOT
	call ActS_Spawn
	ret  c
	ld   a, [tActDir]
	ld   bc, $0180 ; 1.5px/frame forwards
	ld   de, $0180 ; 1.5px/frame forwards
	jp   ActS_SetShotSpd
	
; =============== ActS_SetShotSpd ===============
; Alters the newly spawned actor shot's speed.
; IN
; - A: Shot direction and sprite ID (iActSprMap)
; - HL: Ptr to spawned actor slot
; - BC: Horizontal speed (forward)
; - DE: Vertical speed (upwards unless the calling code manually changes iActSprMap after returning)
ActS_SetShotSpd:
	; Set shot direction
	inc  l ; iActRtnId
	inc  l ; iActSprMap
	ld   [hl], a ; iActSprMap
	
	; Set horizontal and vertical speed
	ld   a, l
	add  iActSpdXSub - iActSprMap
	ld   l, a
	ld   [hl], c ; C = iActSpdXSub
	inc  hl
	ld   [hl], b ; B = iActSpdX
	inc  hl
	ld   [hl], e ; E = iActSpdYSub
	inc  hl
	ld   [hl], d ; D = iActSpdY
	ret
	
;================ Act_BossIntro ================
; Handles the boss intro sequence for all of the normal 8 bosses.
; It is imperative that this isn't called more after the intro is over,
; otherwise the player might behave oddly.
Act_BossIntro:
	; Execute code based on where we are in the intro sequence.
	; The wBossMode modes actually start all the way from being in the boss corridor,
	; however no code should be executed until the 2nd shutter closes, which sets us into mode $02.
	ld   a, [wBossMode]
	rst  $00 ; DynJump
	dw Act_SharedIntro_Wait ; BSMODE_NONE
	dw Act_SharedIntro_Wait ; BSMODE_CORRIDOR
	dw Act_SharedIntro_Init ; BSMODE_INIT
	dw Act_BossIntro_InitAnim ; BSMODE_INITANIM
	dw Act_BossIntro_PlayAnim ; BSMODE_PLAYANIM
	dw Act_SharedIntro_RefillBar ; BSMODE_REFILL
	dw Act_BossIntro_End ; BSMODE_END
	
;================ Act_WilyIntro ================
; Handles the boss intro sequence for all three phases of the Wily Machine.
; The main difference with Act_BossIntro is that routines that deal with animating
; the boss intro are replaced with generic delays, as the Wily bosses don't have them.
Act_WilyIntro:
	ld   a, [wBossMode]
	rst  $00 ; DynJump
	dw Act_SharedIntro_Wait ; BSMODE_NONE
	dw Act_SharedIntro_Wait ; BSMODE_CORRIDOR
	dw Act_SharedIntro_Init ; BSMODE_INIT
	dw Act_WilyIntro_Wait0 ; BSMODE_INITANIM
	dw Act_WilyIntro_Wait1 ; BSMODE_PLAYANIM
	dw Act_SharedIntro_RefillBar ; BSMODE_REFILL
	dw Act_WilyIntro_End ; BSMODE_END

;================ Act_SharedIntro_Wait ================
; SHARED | BSMODE_NONE-BSMODE_CORRIDOR
; Do nothing while waiting for the 2nd shutter to close.
Act_SharedIntro_Wait:
	ret
	
;================ Act_SharedIntro_Init ================
; SHARED | BSMODE_INIT
; Boss initialization code.
; When fighting multiple bosses in sequence (ie: the final boss), wBossMode
; needs to be manually reset to BSMODE_INIT to retrigger refilling the bar.
Act_SharedIntro_Init:
	; Prevent the player from moving as soon as the 2nd shutter closes,
	; leaving no wiggle room to control the player inbetween.
	; Controls will only be re-enabled once the entire intro ends.
	ld   a, PL_MODE_FROZEN
	ld   [wPlMode], a
	
	; Start with the health bar refill.
	; This is a purely visual effect that doesn't affect the boss' actual health.
	xor  a
	ld   [wBossIntroHealth], a	; Start from empty bar	
	ld   [wBossHealthBar], a	; ""
	ld   hl, wStatusBarRedraw	; Request drawing said empty bar
	set  BARID_BOSS, [hl]		
	
	; Wait half a second with the empty bar, while doing nothing.
	; Ideally, instead of doing nothing, it should have made the boss fall from the top of the screen.
	ld   a, 30
	ldh  [hActCur+iActTimer0C], a
	
	; Next mode
	ld   hl, wBossMode
	inc  [hl]
	
	; Play boss music.
	; Every boss, including the final boss, uses the same music.
	ld   a, BGM_BOSS
	ldh  [hBGMSet], a
	ret
	
;================ Act_BossIntro_InitAnim ================
; BOSS-ONLY | BSMODE_INITANIM
; Delay, then set up intro anim.
Act_BossIntro_InitAnim:
	; Wait for that half a second with the empty life bar
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Set up the boss intro animation
	; Use sprites $00-$02 at 1/30 speed
	ld   de, ($00 << 8)|$02
	ld   c, 30
	call ActS_InitAnimRange
	
	ld   hl, wBossMode
	inc  [hl]
	ret
	
;================ Act_WilyIntro_Wait0 ================
; WILY-ONLY | BSMODE_INITANIM
; Generic delay, as the Wily bosses don't have intros like the men.
Act_WilyIntro_Wait0:
	; Wait that half a second
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Wait another half a second
	ld   a, 30
	ldh  [hActCur+iActTimer0C], a
	
	ld   hl, wBossMode
	inc  [hl]
	ret
	
;================ Act_BossIntro_PlayAnim ================
; BOSS-ONLY | BSMODE_PLAYANIM
Act_BossIntro_PlayAnim:
	; Wait until the boss intro animation finishes
	call ActS_PlayAnimRange
	ret  z
	; Then reset to sprite $01, by convention the intro pose
	ld   a, $01
	call ActS_SetSprMapId
	
	ld   hl, wBossMode
	inc  [hl]
	ret
	
;================ Act_WilyIntro_Wait1 ================
; WILY-ONLY | BSMODE_PLAYANIM
; Generic delay, as the Wily bosses don't have intros like the men.
Act_WilyIntro_Wait1:
	; Wait that half a second...
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	ld   hl, wBossMode
	inc  [hl]
	ret
	
;================ Act_SharedIntro_RefillBar ================
; SHARED | BSMODE_REFILL
; Handle the boss health gauge refill.
Act_SharedIntro_RefillBar:
	; Increment health
	ld   a, [wBossIntroHealth]	; Health++
	inc  a
	ld   [wBossIntroHealth], a
	ld   [wBossHealthBar], a	; Set as drawn value
	
	; Trigger redraw, pointless unless a new bar is drawn though.
	; It could have been done alongside setting hSFXSet.
	ld   hl, wStatusBarRedraw
	set  BARID_BOSS, [hl]
	
	; Play the health refill sound for every new bar (every 8 units of health)
	ld   a, [wBossIntroHealth]
	and  $07					; Health % 8 != 0?
	jr   nz, .chkEnd			; If so, skip
	ld   a, SFX_BOSSBAR
	ldh  [hSFXSet], a
.chkEnd:
	; Wait for the gauge to fully refill
	ld   a, [wBossIntroHealth]
	cp   BAR_MAX				; Fully refilled the gauge?
	ret  c						; If not, return
	
	ld   hl, wBossMode		; Otherwise, next mode
	inc  [hl]
	ret
	
;================ Act_BossIntro_End ================
; BOSS-ONLY | BSMODE_END
; End of the normal boss intro.
; [POI] When bosses mistakenly return to the intro routine, they execute just this part
;       as wBossMode is kept to the last value.
Act_BossIntro_End:
	; Set to sprite $00, by convention the normal standing pose.
	ld   a, $00
	call ActS_SetSprMapId
	
	; Unlock the player controls
	; This is the source of numerous issues when this is re-executed mid-fight.
	xor  a ; PL_MODE_GROUND		
	ld   [wPlMode], a			
	
	; Enable the boss damage mode, which allows the generic damage handler to update
	; the boss' health bar and its level ending explosion.
	inc  a						
	ld   [wBossDmgEna], a
	
	; Advance routine to the actor-specific code.
	; By convention, the intro routine is always $00, which will get incremented to $01 now.
	ldh  [hActCur+iActRtnId], a
	ret
	
;================ Act_WilyIntro_End ================
; WILY-ONLY | BSMODE_END
; End of the Wily boss intro, almost identical to Act_BossIntro_End.
Act_WilyIntro_End:
	; Probably not necessary given Wily bosses don't animate in their intros
	ld   a, $00
	call ActS_SetSprMapId
	
	xor  a ; PL_MODE_GROUND		; Unlock the player controls
	ld   [wPlMode], a
	
	inc  a						; Enable the boss damage mode
	ld   [wBossDmgEna], a
	
	; The intro routine for Wily Bosses isn't necessarily executed in routine $00.
	; Why did this matter enough to split Act_BossIntro_End and Act_WilyIntro_End?
	ld   hl, hActCur+iActRtnId
	inc  [hl]
	ret
	
; =============== Act_BGBoss_ReqDraw ===============
; Requests drawing a BG-based miniboss to the tilemap, relative to the actor's location.
; Used by Tama and Friender and meant to be called by their init routine, so hActCur will
; point to the miniboss actor slot.
Act_BGBoss_ReqDraw:
	;
	; Tama and Friender follow a convention that lets them get away with sharing the same
	; initialization code and even the same tilemap.
	;
	; Both minibosses are 5x4 tile rectangles, with their graphics tucked in the top-right
	; corner of the level's GFX set, all using unique tiles. Given levels don't load separate
	; art sets mid-level, all that's needed is generating the tiles for a tilemap event.
	;
	; This is all done all at once in a single event, so there is a limit to how many tiles
	; it could use.
	;
	
	call Act_BGBoss_GetRect			; Get rectancle bounds
	ld   de, Tilemap_Act_Miniboss	; DE = Tama/Friender tilemap
	jp   ActS_WriteTilemapToRect	; Write it to that rectangle
	
; =============== Act_Tama_ChkExplode ===============
; Checks if Tama has been defeated, and if so, makes it explode.
Act_Tama_ChkExplode:
	; If Tama dies, clear its BG portion from the tilemap.
	call ActS_ChkExplodeNoChild		; Is the boss dead?
	ret  nc							; If not, return
									; Otherwise...
	call Act_BGBoss_GetRect			; Get same rectangle bounds from when we wrote the boss to the tilemap
	ld   de, Tilemap_Act_TamaDead	; Write blank gray tiles to them, matching Top Man's background
	jr   ActS_WriteTilemapToRect
	
; =============== Act_Friender_ChkExplode ===============
; Checks if Friender has been defeated, and if so, makes it explode.
; See also: Act_Tama_ChkExplode
Act_Friender_ChkExplode:
	; If Friender dies, clear its BG portion from the tilemap
	call ActS_ChkExplodeNoChild
	ret  nc
	; These tiles match the interior background in Wood Man's stage
	call Act_BGBoss_GetRect
	ld   de, Tilemap_Act_FrienderDead
	jr   ActS_WriteTilemapToRect
	
; =============== Act_Goblin_ShowBody ===============
; Makes the large goblin platform appear, for Air Man's stage.
; This isn't just a visual effect, the level layout blocks do get updated.
Act_Goblin_ShowBody:
	;
	; TILEMAP UPDATE
	;
	;--
	; Get tilemap rectangle bounds for the Goblin platform.
	; See also: Act_BGBoss_GetRect
	ldh  a, [hActCur+iActX]		; X Origin (left): ActX - $14 
	sub  $14
	ld   [wTargetRelX], a
	ldh  a, [hActCur+iActY]		; Y Origin (top): ActY - $14
	sub  $14
	ld   [wTargetRelY], a
	ld   a, $06					; Width: 6 tiles
	ld   [wRectCpWidth], a
	ld   a, $06					; Height: 6 tiles
	ld   [wRectCpHeight], a
	;--
	; Draw the platform tiles
	ld   de, Tilemap_Act_Goblin
	call ActS_WriteTilemapToRect
	
	;##
	;
	; LEVEL LAYOUT UPDATE
	;
	; The blocks placed around the actor are blank, and need to become solid.
	; The actual blocks used should have block16 data that matches what we just wrote to the tilemap.
	;
	
	;--
	;
	; For convenience, the origin was specified in pixels, since it's based on the actor's location.
	; As we need to write to the level layout, we need an offset to it though.
	; 
	
	; HORIZONTAL COMPONENT / LOW BYTE
	ldh  a, [hScrollXNybLow]; B = Block scroll offset (pixels)
	ld   b, a
	ld   a, [wTargetRelX]	; A = Origin X (pixels, relative to viewport)
	sub  OBJ_OFFSET_X		; Account for HW offset
	add  b					; Account for misaligned scrolling wLvlColL doesn't account for
	swap a					; Divide by $10 (BLOCK_H) to get the relative column number
	and  $0F				; ""
	ld   b, a				; Save it to B
	ld   a, [wLvlColL]		; Get base column number
	add  b					; Add the relative one
	ld   c, a				; Save result to C
	
	; VERTICAL COMPONENT / HIGH BYTE
	ld   a, [wTargetRelY]	; A = Origin Y
	sub  OBJ_OFFSET_Y		; Account for HW offset
	swap a					; Divide by $10 (BLOCK_V) to get the row number
	and  $0F				; ""
	ld   b, a				; Save result to B
	;--
	
	; Seek DE to that location in the level layout
	ld   hl, wLvlLayout
	add  hl, bc
	ld   e, l
	ld   d, h
	
	;
	; Copy the level layout part to the live level layout.
	; The blocks are ordered top to bottom, left to right.
	;
	ld   hl, LvlPart_Act_Goblin		; HL = Source data
	ld   b, $03					; B = Number of columns
.loop:
	push de			; Save column origin
		REPT 3
			ldi  a, [hl]		; Read from source, seek to next
			ld   [de], a		; Write to dest
			inc  d				; Move down 1 block
		ENDR
	pop  de			; Restore column origin
	inc  e 			; Move right 1 block, next column
	dec  b			; Copied all columns?
	jr   nz, .loop	; If not, loop
	ret
	
; =============== Act_BGBoss_GetRect ===============
; Gets the tilemap rectangle bounds for Tama and Friender.
; This will be used to tell ActS_WriteTilemapToRect where to start writing the tilemap
; for those minibosses, and how many tiles to copy.
Act_BGBoss_GetRect:
	ldh  a, [hActCur+iActX]	; X Origin (left): ActX - $12
	sub  $12
	ld   [wTargetRelX], a
	ldh  a, [hActCur+iActY]	; Y Origin (top): ActY - $1C
	sub  $1C
	ld   [wTargetRelY], a
	ld   a, $05				; Width: 5 tiles
	ld   [wRectCpWidth], a
	ld   a, $04				; Height: 4 tiles
	ld   [wRectCpHeight], a
	ret
	
; =============== ActS_ReqDrawTilemapToRect ===============
; Requests drawing the specified tilemap to a rectangle area of VRAM.
; IN
; - DE: Ptr to source tilemap
; - wTargetRelX: Dest. rectangle - Horizontal origin (pixels)
; - wTargetRelY: Dest. rectangle - Vertical origin (pixels)
; - wRectCpWidth: Dest. rectangle - Width (in tiles)
; - wRectCpHeight: Dest. rectangle - Height (in tiles)
ActS_WriteTilemapToRect:

	;
	; For convenience, the origin was specified in pixels, since it's based on the actor's location.
	; As we need to write to the tilemap, we need a tilemap destination pointer though.
	;
	
	;
	; VERTICAL COMPONENT
	; ScrEv_BGStripTbl[(hScrollY + wTargetRelY - OBJ_OFFSET_Y) / $08]
	;
	ldh  a, [hScrollY]		; B = Viewport Y (pixels)
	ld   b, a
	ld   a, [wTargetRelY]	; A = Origin Y (pixels, relative to viewport)
	sub  OBJ_OFFSET_Y		; Account for HW offset
	add  b					; Get absolute coordinate
	swap a					; Divide by $10 (BLOCK_V) to get block row/strip number
	and  $0F				; ""
	sla  a					; *2 for ptr table indexing
	ld   hl, ScrEv_BGStripTbl	; HL = Tilemap row pointers table
	ld   b, $00
	ld   c, a				; BC = What we calculated before
	add  hl, bc				; Seek to entry
	ldi  a, [hl]			; Read the pointer out to wRectCpDestPtr
	ld   [wRectCpDestPtrLow], a
	ld   a, [hl]
	ld   [wRectCpDestPtrHigh], a
	
	;
	; HORIZONTAL COMPONENT
	;	
	ldh  a, [hScrollX]		; B = Viewport X (pixels)
	ld   b, a
	;--
	; Readding the lower nybble to hScrollX, in light of the upcoming / $10,
	; will cause that result to be rounded to the nearest block boundary.
	;
	; ie: If hScrollX is $x0-$x7, it will be rounded down (low nybble won't overflow)
	;     If hScrollX is $x8-$xF, it will be rounded up (low nybble will overflow)
	ldh  a, [hScrollXNybLow]	; B = Viewport X (pixels, low nybble)
	add  b						; += hScrollX
	ld   b, a
	;--
	ld   a, [wTargetRelX]	; A = Origin X (pixels, relative to viewport)
	sub  OBJ_OFFSET_X		; Account for HW offset
	add  b					; Get absolute coordinate
	swap a					; Divide by $10 (BLOCK_H) to get column number
	and  $0F				; ""
	sla  a					; *2 as a column is 2 tiles wide
	ld   b, a				; Save offset to B
	
	; Move <B> tiles right from the start of the block row.
	; This will point to the top-left corner of a block, so it will never overflow.
	ld   a, [wRectCpDestPtrLow]
	add  b
	ld   [wRectCpDestPtrLow], a
	
	;
	; With the destination pointer ready, generate the event for drawing the tilemap.
	; The event will draw it column by column -- top to bottom, left to right.
	; The tilemap we want to draw, which is only made of raw time IDs, needs to be consistent
	; with that, by having the tiles in that order and following the width/height of the rectangle.
	;
	; This event will be executed all at once next VBLANK, which imposes a limit for how
	; much can be drawn.
	;
	ld   hl, wTilemapBuf		; HL = Ptr to event buffer
	ld   a, [wRectCpWidth]		; B = Columns remaining
	ld   b, a
.loop:							; For each column...
	; Current VRAM location we're pointing at
	ld   a, [wRectCpDestPtrHigh]
	ldi  [hl], a				; byte0 - VRAM Address (high)
	ld   a, [wRectCpDestPtrLow]
	ldi  [hl], a				; byte1 - VRAM Address (low)
	
	; byte2 - Flags + Tile count
	ld   a, [wRectCpHeight]		; Copy wRectCpHeight tiles
	or   BG_MVDOWN				; Write top to bottom
	ldi  [hl], a
	
	; byte3+ - Payload
	; Copy <wRectCpHeight> tiles from the source into the payload, as-is
	push bc
		ld   a, [wRectCpHeight]
		ld   b, a
	.loopCol:
		ld   a, [de]
		ldi  [hl], a
		inc  de
		dec  b
		jr   nz, .loopCol
	pop  bc
	
	;##
	;
	; Seek to the next column on the right, while accounting for the tilemap wrapping around.
	; This is slightly involved:
	; wRectCpDestPtrLow = (wRectCpDestPtrLow & $E0) | (wRectCpDestPtrLow++ & $1F)
	;
	;--
	; Accounting for wraparound wipes the upper three bits, so they need to be preserved.
	; These map to the low byte of the vertical component / row offset.
	; C = wRectCpDestPtrLow & $E0
	ld   a, [wRectCpDestPtrLow]	
	and  $FF^(BG_TILECOUNT_H-1)
	ld   c, a
	;--
	ld   a, [wRectCpDestPtrLow]	; Get column origin ptr
	inc  a						; Seek one tile right
	and  BG_TILECOUNT_H-1		; Account for row wraparound
	or   c						; Add back the lost bits
	ld   [wRectCpDestPtrLow], a
	;##
	
	dec  b						; Handled all columns?
	jr   nz, .loop				; If not, loop
	
	xor  a						; Write terminator
	ldi  [hl], a
	inc  a						; Trigger event
	ld   [wTilemapEv], a
	
	; Set C flag, for compatibility with a check the calling code makes
	scf  
	ret
	
Tilemap_Act_Miniboss: db $0B
L027F52: db $1B
L027F53: db $2B
L027F54: db $3B
L027F55: db $0C
L027F56: db $1C
L027F57: db $2C
L027F58: db $3C
L027F59: db $0D
L027F5A: db $1D
L027F5B: db $2D
L027F5C: db $3D
L027F5D: db $0E
L027F5E: db $1E
L027F5F: db $2E
L027F60: db $3E
L027F61: db $0F
L027F62: db $1F
L027F63: db $2F
L027F64: db $3F
Tilemap_Act_TamaDead: db $71
L027F66: db $71
L027F67: db $71
L027F68: db $71
L027F69: db $71
L027F6A: db $71
L027F6B: db $71
L027F6C: db $71
L027F6D: db $71
L027F6E: db $71
L027F6F: db $71
L027F70: db $71
L027F71: db $71
L027F72: db $71
L027F73: db $71
L027F74: db $71
L027F75: db $71
L027F76: db $71
L027F77: db $71
L027F78: db $71
Tilemap_Act_FrienderDead: db $2A
L027F7A: db $3A
L027F7B: db $2A
L027F7C: db $3A
L027F7D: db $29
L027F7E: db $39
L027F7F: db $29
L027F80: db $39
L027F81: db $2A
L027F82: db $3A
L027F83: db $2A
L027F84: db $3A
L027F85: db $29
L027F86: db $39
L027F87: db $29
L027F88: db $39
L027F89: db $2A
L027F8A: db $3A
L027F8B: db $2A
L027F8C: db $3A
Tilemap_Act_Goblin: db $0A
L027F8E: db $1A
L027F8F: db $2A
L027F90: db $3A
L027F91: db $4A
L027F92: db $4F
L027F93: db $0B
L027F94: db $1B
L027F95: db $2B
L027F96: db $3B
L027F97: db $4B
L027F98: db $48
L027F99: db $0C
L027F9A: db $1C
L027F9B: db $2C
L027F9C: db $3C
L027F9D: db $4C
L027F9E: db $49
L027F9F: db $0D
L027FA0: db $1D
L027FA1: db $2D
L027FA2: db $3D
L027FA3: db $4D
L027FA4: db $49
L027FA5: db $0E
L027FA6: db $1E
L027FA7: db $2E
L027FA8: db $3E
L027FA9: db $4E
L027FAA: db $02
L027FAB: db $22
L027FAC: db $32
L027FAD: db $21
L027FAE: db $31
L027FAF: db $01
L027FB0: db $03
LvlPart_Act_Goblin: db $22
L027FB2: db $24
L027FB3: db $34
L027FB4: db $23
L027FB5: db $25
L027FB6: db $35
L027FB7: db $2D
L027FB8: db $2E
L027FB9: db $2F
	mIncJunk "L027FBA"