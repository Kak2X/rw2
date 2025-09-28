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
	
