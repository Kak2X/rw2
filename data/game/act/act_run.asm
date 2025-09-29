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
	dw Act_Wily2Intro			; ACT_WILY2INTRO
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

