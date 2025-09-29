; =============== Module_Credits ===============
; Cast roll and Thank you for playing screen.
; This never returns, and if it did you'd reach an infinite loop.
Module_Credits:
	ld   a, BGM_ENDING
	mPlayBGM
	
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

	ld   hl, GFX_Credits ; Source GFX ptr
	ld   de, $8000 ; VRAM Destination ptr (1st section)
	ld   bc, (BANK(GFX_Credits) << 8)|$80 ; B = Source GFX bank number (BANK $0B) C = Number of tiles to copy
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
	ld   hl, GFX_Credits ; Source GFX ptr
	ld   de, $9200 ; VRAM Destination ptr (3rd section)
	ld   bc, (BANK(GFX_Credits) << 8)|$60 ; B = Source GFX bank number (BANK $0B) C = Number of tiles to copy
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
	
