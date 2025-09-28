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
	mPlayBGM
	
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
		mPlaySFX
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
	mPlaySFX
	
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
	
