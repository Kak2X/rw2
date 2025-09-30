; =============== StageSel_BossIntro ===============
; Handles a stage getting selected.
StageSel_BossIntro:
	
	; Start a request to load the graphics for this boss.
	ld   hl, StageSel_BossGfxTbl	; HL = StageSel_BossGfxTbl
	ld   a, [wLvlId]				; BC = wLvlId
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]					; Read OBJ GFX set ID
	call ActS_ReqLoadRoomGFX.loadBySetId
	
	; Delete cursor sprites
	call OAM_ClearAll
	
	; The stage intro sound plays immediately, there's no separate selection sound.
	mPlayBGM BGM_STAGESTART
	
	; Flash the palette for 32 frames.
	; This is enough time to let the boss graphics fully load.
	call FlashBGPal
	rst  $20 ; But just in case, ensure they are fully loaded
	
	; Blank out the selected portrait, as the boss sprite will spawn there.
	; This makes the sprite stand out more, for the little time it stays there.
	ld   a, [wLvlId]
	call StageSel_MkEmptyPicTilemap
	rst  $10 ; Wait tilemap load
	
	;--
	;
	; Spawn the boss actor for the intro.
	; This is actually the same exact one used during gameplay, but its normal code won't be executed.
	;
	
	; Delete any old actors, enabling their processing
	call ActS_InitMemory
	
	; Boss actors are indexed start at $68, indexed by level ID
	ld   a, [wLvlId]				; wActSpawnId = wLvlId + $68
	add  ACT_BOSS_START
	ld   [wActSpawnId], a
	
	; Doesn't need to respawn and it's not gameplay anyway
	xor  a
	ld   [wActSpawnLayoutPtr], a
	
	; Set the spawn position depending on the level id.
	; HL = StageSel_BossActStartPosTbl[(wLvlId % 4) * 2]
	ld   a, [wLvlId]	
	and  $03			; Force valid range, with the effect of not breaking in case the second set of bosses is selected
	add  a				; Coords are 2 bytes
	ld   hl, StageSel_BossActStartPosTbl
	ld   b, $00
	ld   c, a
	add  hl, bc			; Seek to entry
	ldi  a, [hl]		; wActSpawnX = byte0
	ld   [wActSpawnX], a
	ld   a, [hl]		; wActSpawnX = byte1
	ld   [wActSpawnY], a
	
	call ActS_Spawn
	;--
	
	; Prepare the starfield effect for later
	call Starfield_InitPos
	
	;
	; Open up the two halves of the selection screen at 2px/frame.
	;
	ld   b, $24			; For $24 frames...
.openLoop:
	; Scroll the BG viewport down.
	; This will scroll the top half up.
	ld   hl, hScrollY
	inc  [hl]
	inc  [hl]
	
	; Scroll the WINDOW layer down.
	; This will scroll the bottom half down.
	ld   hl, hWinY
	inc  [hl]
	inc  [hl]
	
	call StageSel_DoAct	; Handle boss actor
	dec  b				; Are we done?
	jr   nz, .openLoop	; If not, loop
	
	;
	; With the two halves fully scrolled out, write the starfield background, one row at a time.
	; This replaces everything above or below the horizontal bar.
	;
	
	; TOP HALF
	ld   d, HIGH($98E0)			; DE = Write address
	ld   e, LOW($98E0)
	ld   b, $09					; B = Number of columns
.loopU:
	call Starfield_ReqDrawBG	; Req tilemap update 
	
	ld   a, e					; Move up 1 row
	sub  BG_TILECOUNT_H
	ld   e, a
	ld   a, d
	sbc  $00
	ld   d, a
	
	call StageSel_DoAct			; Handle boss actor
	dec  b						; Written all rows?
	jr   nz, .loopU				; If not, loop
	;--
	
	; BOTTOM HALF
	ld   d, HIGH($9C20)			; DE = Write address
	ld   e, LOW($9C20)
	ld   b, $09
.loopD:
	call Starfield_ReqDrawBG
	
	ld   a, e					; Move down 1 row
	add  BG_TILECOUNT_H
	ld   e, a
	ld   a, d
	adc  $00
	ld   d, a
	
	call StageSel_DoAct			; Handle boss actor
	dec  b						; Written all rows?
	jr   nz, .loopD				; If not, loop
	;--
	
	
	;
	; Close the two halves of the selection screen at 2px/frame.
	; The opposite of what we did before, but for less frames, to
	; make the white backdrop visible.
	;
	ld   b, $18			; For $18 frames...
.closeLoop:
	; Scroll the BG viewport up.
	; This will scroll the top half down.
	ld   hl, hScrollY
	dec  [hl]
	dec  [hl]
	
	; Scroll the WINDOW layer up.
	; This will scroll the bottom half up.
	ld   hl, hWinY
	dec  [hl]
	dec  [hl]
	
	call StageSel_DoAct	; Handle boss actor
	dec  b				; Are we done?
	jr   nz, .closeLoop	; If not, loop
	
	;
	; Wait for the boss intro animation to finish before continuing
	;
.waitAnimEnd:
	call StageSel_DoAct
	ldh  a, [hActCur+iActRtnId]
	cp   $06				; Reached the last actor routine?
	jr   nz, .waitAnimEnd	; If not, wait
	
	;
	; Display the boss' name.
	; 
	
	; Load the font to VRAM
	ld   hl, GFX_NormalFont	; Source GFX ptr
	ld   de, $9400				; VRAM Destination ptr
	ld   bc, (BANK(GFX_NormalFont) << 8) | $20 ; BANK $0B | Number of tiles to copy
	call GfxCopy_Req
	; Normally we would call GfxCopyEv_Wait, but that wouldn't animate the starfield.
	; The 32 tiles should load within 8 frames, so wait that much.
	ld   a, $08
	call .waitFrames
	
	; Seek HL to the boss' name.
	; Boss names are hardcoded to 10 characters, stored in a table indexed by level ID.
	DEF BOSSNAME_LEN EQU 10
	ld   a, [wLvlId]			
	add  a		; * 2
	ld   b, a				
	add  a		; * 4
	add  a		; * 8
	add  b		; * 10
	ld   hl, StageSel_BossNameTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	
	; Write it out to the tilemap
	ld   de, wTilemapBuf
	ld   a, HIGH($99A5)		; byte0 - VRAM Address (high)
	ld   [de], a
	inc  de
	ld   a, LOW($99A5)		; byte1 - VRAM Address (low)
	ld   [de], a
	inc  de
	ld   a, BOSSNAME_LEN	; byte2 - Flags + Tile count
	ld   [de], a
	inc  de
	ld   bc, BOSSNAME_LEN	; Boss name
	call CopyMemory
	xor  a					; Write terminator
	ld   [de], a
	
	inc  a					; Trigger request
	ld   [wTilemapEv], a
	
	; Wait for 3 seconds
	ld   a, 3*60
	
; IN
; - A: Number of frames
.waitFrames:
	push af
		call StageSel_DoAct
	pop  af
	dec  a
	jr   nz, .waitFrames
	ret
	
; =============== StageSel_DoAct ===============
; Handles actor processing during the boss intro screen.
; This will wait a frame before returning.
StageSel_DoAct:
	push hl
	push de
	push bc
		
		; We're going to draw sprites
		xor  a
		ldh  [hWorkOAMPos], a
		
		;--
		; This screen only has one actor at the first slot.
		; Copy the first slot to the proc area.
		ld   hl, wAct
		ld   de, hActCur+iActId
		ld   b, iActEnd
	.cpInLoop:
		ldi  a, [hl]
		ld   [de], a
		inc  de
		dec  b
		jr   nz, .cpInLoop
		;--
		
		; Perform any changes in the proc area.
		
		ld   a, $00						; Act_StageSelBoss will set this as needed.
		ld   [wActCurSprMapBaseId], a
		
		; This call here is the main reason why this intro screen has a specific
		; version of the actor processing subroutine.
		; The normal (gameplay) code associated to the actor can't be executed here.
		call Act_StageSelBoss
		
		; Draw the boss
		call ActS_DrawSprMap
		
		;--
		; Save back the changes from the proc area to the actor slot.
		ld   hl, hActCur+iActId
		ld   de, wAct
		ld   b, iActEnd
	.cpOutLoop:
		ldi  a, [hl]
		ld   [de], a
		inc  de
		dec  b
		jr   nz, .cpOutLoop
		;--
		
		; Frame done
		call OAM_ClearRest
		rst  $08 ; Wait Frame
	
	pop  bc
	pop  de
	pop  hl
	ret
	
; =============== Act_StageSelBoss ===============
; Special code for animating the bosses after selecting a stage.
Act_StageSelBoss:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_StageSelBoss_Init
	dw Act_StageSelBoss_JumpUp
	dw Act_StageSelBoss_JumpDown
	dw Act_StageSelBoss_JumpLand
	dw Act_StageSelBoss_WaitAnim
	dw Act_StageSelBoss_IntroAnim
	dw Act_StageSelBoss_Starfield

; =============== Act_StageSelBoss ===============
; RTN $00
; Sets up the direction and initial movement speed.
Act_StageSelBoss_Init:

	;
	; Make the boss face the proper direction.
	; Bosses on the left (bit0 clear) will face right (ACTDIRB_R set).
	; Bosses on the right (bit0 set) will face left (ACTDIRB_R clear).
	;
	ld   a, [wLvlId]
	; bit0 determines odd/even values, bit7 determines the direction for iActSprMap
	; rotate right bit0 to bit7
	rrca		
	; Filter out unwanted bits
	and  ACTDIR_R
	; Other way around
	xor  ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	
	;
	; BC = Jump speed.
	; This will be reduced over time.
	; Bosses on the top (bit1 clear) use a lower jump arc compared to those at the bottom.
	;
	ld   bc, $01A0		; BC = 1.6px/frame
	ld   a, [wLvlId]
	bit  1, a			; Boss pic on top?
	jr   z, .setSpeed	; If not, skip
	ld   bc, $03B0		; BC = 2.7px/frame
	
.setSpeed:
	; 1px/frame forward
	xor  a
	ldh  [hActCur+iActSpdXSub], a
	inc  a
	ldh  [hActCur+iActSpdX], a
	; BC/frame speed upwards
	ld   a, c
	ldh  [hActCur+iActSpdYSub], a
	ld   a, b
	ldh  [hActCur+iActSpdY], a
	; The total jump arc will take up $28 frames
	ld   a, $28
	ldh  [hActCur+iActTimer], a
	
	; Next mode
	jp   ActS_IncRtnId
	
; =============== Act_StageSelBoss_JumpUp ===============
; RTN $01
; Jump arc - upwards movement.
Act_StageSelBoss_JumpUp:
	; iActTimer--
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	
	; Continue jump arc
	call ActS_MoveBySpeedX
	call ActS_ApplyGravityU	; Reached the peak?
	ret  c					; If not, return
	
	jp   ActS_IncRtnId
	
; =============== Act_StageSelBoss_JumpDown ===============
; RTN $02
; Jump arc - downwards movement.
Act_StageSelBoss_JumpDown:
	; Continue jump arc
	call ActS_MoveBySpeedX
	call ActS_ApplyGravityD
	
	; Wait for the timer to tick down before continuing
	; iActTimer--
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	jp   ActS_IncRtnId
	
; =============== Act_StageSelBoss_JumpLand ===============
; RTN $03
; Jump arc - landed from the jump.
Act_StageSelBoss_JumpLand:
	; Make boss face left
	xor  a
	ldh  [hActCur+iActSprMap], a
	
	; Delay next mode for 32 frames
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	
	jp   ActS_IncRtnId
	
; =============== Act_StageSelBoss_WaitAnim ===============
; RTN $04
; Delay while the two halves are closing back.
Act_StageSelBoss_WaitAnim:

	; Wait for those 32 frames
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Set up the intro animation.
	; Every single intro uses the first three sprite mapping IDs.
	; Use sprites $00-$02 at 1/30 speed
	ld   de, ($00 << 8)|$02
	ld   c, 30
	call ActS_InitAnimRange
	
	jp   ActS_IncRtnId
	
; =============== Act_StageSelBoss_IntroAnim ===============
; RTN $05
; Performs the boss' animation while the starfield scrolls.
Act_StageSelBoss_IntroAnim:
	call Starfield_Do
	call ActS_PlayAnimRange		; Is it done?
	ret  z						; If not, return
								
	ld   a, $00					; Restore 1st frame
	ld   [wActCurSprMapBaseId], a
	
	ld   a, $01
	call ActS_SetSprMapId
	
	jp   ActS_IncRtnId
	
; =============== Act_StageSelBoss_Starfield ===============
; RTN $06
; Just displays the starfield.
; This will keep doing it while, elsewhere, the boss' name gets written.
Act_StageSelBoss_Starfield:
	call Starfield_Do
	ret
	
; =============== Starfield_InitPos ===============	
; =============== Starfield_Do ===============
; =============== Starfield_ReqDrawBG ===============
INCLUDE "src/stagesel/intro_starfield.asm"	

; =============== StageSel_BossActStartPosTbl ===============
; Spawn positions for boss actors for each picture.
StageSel_BossActStartPosTbl: 
	;    X    Y
	db $30, $3B ; Top-Left (LVL_CRASH, LVL_HARD)
	db $80, $3B ; Top-Right (LVL_METAL, LVL_TOP)
	db $30, $8C ; Bottom-Left (LVL_WOOD, LVL_MAGNET)
	db $80, $8C ; Bottom-Right (LVL_AIR, LVL_NEEDLE)

SETCHARMAP generic
; =============== StageSel_BossNameTbl ===============
; Boss names, indexed by level ID.
; Each of these is hardcoded to be 10 characters long.
; [TCRF] This explicitly accounts for the second set of bosses.
StageSel_BossNameTbl:
	INCLUDE "src/stagesel/intro_bossname_tbl.asm"

; =============== StageSel_MkEmptyPicTilemap ===============
; Builds the TilemapDef for clearing out the specified boss pic.
; IN
; - A: Boss picture ID ($00-$04)
StageSel_MkEmptyPicTilemap:
	;
	; DE = Ptr to tilemap associated with the pic
	;
	and  $03			; Enforce valid range
	add  a				; Pointer table index
	ld   hl, StageSel_PicPosPtrTbl
	ld   b, $00
	ld   c, a
	add  hl, bc			; Index it 
	ld   e, [hl]		; Read out ptr to DE
	inc  hl
	ld   d, [hl]
	
	; Generate the tilemap.
	; The tilemap system doesn't really play well with square tilemaps, 
	; so to clear a block of 4x4 tiles, 4 separate TilemapDef need to 
	; be generated, each clearing a single column of 4 tiles.
	ld   hl, wTilemapBuf
	ld   b, $04
.loop:
	ld   [hl], d		; byte0 - VRAM Address (high)
	inc  hl
	ld   [hl], e		; byte1 - VRAM Address (low)
	inc  hl
	ld   a, BG_MVDOWN|BG_REPEAT|$04		; byte2 - Flags + Tile count
	ldi  [hl], a
	ld   a, $1F			; byte3 - Tile ID (gray blank tile)
	ldi  [hl], a
	inc  e				; Seek tile to the right
	dec  b				; Generated all four?
	jr   nz, .loop		; If not, loop
	ld   [hl], a		; Write terminator
	ret
	
; =============== StageSel_PicPosPtrTbl ===============
StageSel_PicPosPtrTbl:
	dw $9843 ; CRASH MAN / HARD MAN
	dw $984D ; METAL MAN / TOP MAN
	dw $9C63 ; WOOD MAN / MAGNET MAN
	dw $9C6D ; AIR MAN / NEEDLE MAN
	
