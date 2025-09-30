; =============== Module_Game_PlDead ===============
; Gameplay loop when the player explodes.
; OUT
; - C Flag: If set, the player has not game overed.
; - wGameOverSel: Game Over selection, if the above is clear.
Module_Game_PlDead:
	
	;
	; Draw an empty health bar for the player.
	;
	xor  a
	ld   [wPlHealthInc], a		; Stop health refills, if any (Game_TickTime still called)
	ld   [wWpnAmmoInc], a		; Stop ammo refills, if any ""
	ld   [wPlHealthBar], a		; Zero out visible health
	ld   hl, wStatusBarRedraw	; Draw empty health bar
	set  BARID_PL, [hl]
	
	;
	; Handle the death sequence.
	; This mainly animates the slow large explosions, which unlike other games *always* happen on death.
	; Typically other games would skip it for pit deaths, but not this one (also because pits really are spikes).
	;
	ld   b, 60*3			; Do the effect for 3 seconds
.loop:						; As the timer ticks down to 0...
	push bc
		ld   a, b			
		cp   60*3			; immediately -> spawn 1st explosion, with SFX
		jr   z, .explode0
		cp   60*1+30		; after 1.5 seconds -> spawn 2nd explosion, with no SFX
		jr   z, .explode1
		jr   .playExpl
	.explode0:
		; The first explosion that spawns also plays its respective sound effect
		mStopSnd			; And kill the level music
		mPlaySFX SFX_EXPLODE
	.explode1:
		; Use the origin coordinates set when we died.
		ld   a, [wExplodeOrgX]
		ld   [wActSpawnX], a
		ld   a, [wExplodeOrgY]
		ld   [wActSpawnY], a
		call ActS_SpawnLargeExpl
		
	.playExpl:
		rst  $08 ; Wait Frame
		
		;
		; Process/draw moving entities such as weapon shots and actors, just not the player.
		;
		
		xor  a						; Start drawing sprites
		ldh  [hWorkOAMPos], a
		
		call WpnS_Do ; BANK $01		; Process/draw shots
		push af
			ld   a, BANK(ActS_Do) ; BANK $02
			ldh  [hROMBankLast], a
			ldh  [hROMBank], a
			ld   [MBC1RomBank], a
		pop  af
		
		call ActS_Do				; Process/draw actors, including the explosion
		
		push af
			ld   a, $01
			ldh  [hROMBankLast], a
			ldh  [hROMBank], a
			ld   [MBC1RomBank], a
		pop  af
		
		call OAM_ClearRest			; Drawn everything
		call Game_TickTime			; Tick gameplay clock
		
	pop  bc				; B = Timer
	dec  b				; Has it elapsed?
	jr   nz, .loop		; If not, keep showing the anim
	
	;
	; Explosion animation has ended.
	; If we ran out of lives, show the password screen (then game over).
	;
	ld   a, [wPlLives]	; Lives--
	sub  $01
	ld   [wPlLives], a	; Did we ran out? (underflowed)
	jr   c, .gameOver		; If so, jump
	
	;
	; Otherwise, respawn at the appropriate checkpoint.
	; Every level has exactly four checkpoints assigned to it, of which:
	; - The first one is typically the start of the level
	; - The last one is assumed to be inside a boss corridor
	;
	; This data is stored inside a table indexed by level ID.
	; The four room IDs are ordered from lowest to highest, so we read them in reverse order,
	; stopping at the first that's behind the one the player reached. If all checks fail, peter out at the first checkpoint.
	;
	; This has a few implications on the level design, as room transitions need to take checkpoints in mind
	; when the path forward involves moving left, due to the linear nature of the level layout.
	;
	; There's also an oversight in here, which does need the player to commit to it though.
	; Nowhere in here does the game keep track of the last checkpoint reached, all calculations are around the player's position
	; within the level, so if you die to a checkpoint, respawn, then move behind the checkpoint and die again, you get sent further back.
	;
	
	ld   a, [wLvlId]	; A = Level ID
	add  a				; *4 as that's the entry size (how many checkpoints a level can have)
	add  a				; (that will make bits0-1 empty)
	or   $03			; Start checking from the last entry
	ld   hl, Lvl_CheckpointTbl
	ld   b, $00
	ld   c, a
	add  hl, bc			; Seek HL to last entry
	;--
	; Calculate the room ID, identically to Game_StartRoomTrs
	; A = Room ID (wLvlColL / $0A)
.getRoomNum:
	ld   b, $00
	ld   a, [wLvlColL]
.divLoop:
	cp   ROOM_COLCOUNT
	jr   c, .divDone
	inc  b
	sub  ROOM_COLCOUNT
	jr   .divLoop
.divDone:
	ld   a, b
	;--
	; Check from latest to earliest checkpoint, the first one that's smaller than our room ID.
	cp   [hl]			; RoomId >= Checkpoint3?
	jr   nc, .setBoss	; If so, use it
	dec  hl				; Seek to previous checkpoint
	cp   [hl]			; RoomId >= Checkpoint2?
	jr   nc, .setRoom	; ...
	dec  hl
	cp   [hl]			; RoomId >= Checkpoint1?
	jr   nc, .setRoom	; ...
	dec  hl				; Otherwise, use the first checkpoint (typically the start of the level)
.setRoom:
	;
	; Normal respawn.
	;
	ld   a, [hl]		; Respawn at that room
	ld   [wLvlRoomId], a
	
	; Reload the level with the respawn flag set, to preserve collected/permanently despawned items
	ld   a, $01			
	ld   [wPlRespawn], a
		call Module_Game_InitScrOff
		call Module_Game_InitScrOn
	xor  a
	ld   [wPlRespawn], a
	
	scf  ; C flag = Set
	ret
	
.setBoss:
	;
	; Boss corridor respawn, mostly the same as normal respawns.
	;
	ld   a, [hl]		; Respawn at that room
	ld   [wLvlRoomId], a
	
	ld   a, $01			; Reload level as respawn
	ld   [wPlRespawn], a
		call Module_Game_InitScrOff
		;--
		; For inexplicable reasons, by conventions the boss corridors are not perfectly aligned 
		; to room boundaries, with the room before being 1 block longer than it should.
		; On top of not making it possible to use screen locks with the 1st shutter, it also 
		; forces us to adjust the screen right by those 16 pixels.
		ld   b, $10
	.bsShLoop:
		push bc
			call Game_AutoScrollR	; Move 1px right
		pop  bc
		dec  b						; Moved all 16px?
		jr   nz, .bsShLoop			; If not, loop
		;--
		call Module_Game_InitScrOn
		
		; Set the appropriate boss mode, this locks the screen and makes
		; closing the 2nd shutter activate the boss.
		ld   a, BSMODE_CORRIDOR
		ld   [wBossMode], a
	xor  a
	ld   [wPlRespawn], a
	
	scf  ; C flag = Set
	ret
	
.gameOver:
	;
	; No more lives left, do the game over sequence.
	;
	
	; PASSWORD SCREEN
	mPlayBGM BGM_PASSWORD
	call Module_PasswordView ; BANK $01
	
	; GAME OVER
	call Pl_ResetLivesAndWpnAmmo	; Reset lives/ammo to default
	ld   a, GFXSET_GAMEOVER			; Load Game Over font...
	call GFXSet_Load
	ld   de, TilemapDef_GameOver	; ...and the tilemap
	call LoadTilemapDef
	call StartLCDOperation
.gmoLoop:
	rst  $08 ; Wait Frame
	call JoyKeys_Refresh
	; Wait in a loop until either A or B are pressed.
	; A -> Stage Select
	; B -> Continue
	ldh  a, [hJoyNewKeys]
	and  KEY_B|KEY_A				; A or B pressed?
	jr   z, .gmoLoop				; If not, loop
	ld   [wGameOverSel], a			; Save selection as keys
	xor  a  ; C flag = Clear
	ret
	
TilemapDef_GameOver: INCLUDE "src/gameover/gameover_bg.asm"

