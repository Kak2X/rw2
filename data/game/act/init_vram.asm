; =============== ActS_ReqLoadRoomGFX ===============
; Loads the actor graphics for the current room.
; Specifically, it triggers requests to load the graphics during VBlank,
; so they may take a couple of frames to fully load.
;
; Occasionally used to load generic sprite GFX sets.
ActS_ReqLoadRoomGFX:

	;
	; Each column in a level can be associated to a potential set of actor graphics,
	; with the table at wActLayoutIds potentially being able to map every column to an art request ID.
	;
	; This subroutine scans a room worth of columns, loading the first set found.
	; In practice, generally the actor layout is optimized to deliver a set ID immediately.
	;

	; HL = Starting pointer (wActLayoutIds + wLvlColL)
	ld   a, [wLvlColL]
	ld   l, a
	; B = Number of entries to scan
	ld   b, ROOM_COLCOUNT
	
.loop:

	;
	; If there's a request at the current column, apply that.
	;
	; As you may have noticed, this data is stored inside wActLayoutIds, which has the other important
	; purpose of defining actor IDs.
	;
	; How to distinguish between the two? 
	; Actors need to define some data in their respective wActLayoutFlags entry.
	; Art sets don't make use of it, and they MUST have this entry zeroed out.
	;
	
	; Otherwise we treat it as an actor ID (ie: not what we're looking for), so we skip to the next column
	ld   h, HIGH(wActLayoutFlags)
	ld   a, [hl]
	or   a
	jr   nz, .nextCol
	
	; Skip if there's no art set defined for this column
	ld   h, HIGH(wActLayoutIds)
	ld   a, [hl]
	or   a
	jr   z, .nextCol
	
; IN
; - A: Actor GFX set ID
.tryLoadBySetId:
	ld   hl, wActGfxId
	cp   [hl]			; Requesting the same set as last time?
	ret  z				; If so, return (graphics already loaded)
	
; IN
; - A: Actor GFX set ID
.loadBySetId:
	ld   [wActGfxId], a	; Mark as the currently loaded set
	
	; Index the set table and read out its entry
	ld   hl, ActS_GFXSetTbl
	sla  a				; 2 bytes/entry
	ld   b, $00
	ld   c, a
	add  hl, bc
	
	; These requests are dumb, as there's no concept of loading actor GFX
	; at a dynamic address -- instead, the entire $80 tile area is copied over
	; directly from ROM with no way to mix and match, kinda like a CHR-ROM game.
	
	ld   b, [hl]		; B = [byte0] Source GFX bank number
	ld   c, $80			; C = Number of tiles to copy
	inc  hl
	ld   a, [hl]		; HL = [byte1] Source GFX ptr, with low byte hardcoded to $00
	ld   h, a
	ld   l, $00
	ld   de, $8800		; DE = VRAM Destination ptr
	jp   GfxCopy_Req	; Set up the request and return
	
.nextCol:
	inc  l				; Seek to the next column
	dec  b				; Checked all columns?
	jr   nz, .loop		; If not, loop
	ret ; We never get here

