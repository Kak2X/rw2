; =============== Pause_AddBarDrawEv ===============
; Appends a *small* health/ammo bar draw request to the buffer.
; Used on the pause menu exclusively to render the gauges.
; See also: Game_AddBarDrawEv
; IN
; - A: Bar value
; - C: Weapon selection ID (WPN_*)
; - DE: Tilemap destination ptr
Pause_AddBarDrawEv:
	;
	; These gauges are handled similarly to the large ones, and most of the draw code is very similar too.
	; They have the following differences though:
	; - These gauges are 1-tile tall.
	;   With no repeated draw being necessary, the equivalent to Game_MkBarRowDrawEv is directly inlined.
	; - The weapon name (2 tiles) is displayed to the left of the bar.
	; - There's no blanking feature when drawing values > BAR_MAX. 
	;   Attempting to do so will instead cap it back.
	;
	push bc
	push hl
		push af
			
			;
			; Build the TilemapDef starting from the weapon's name.
			; The table containing this data, indexed by WPN_*, also contains the tilemap pointer.
			; After drawing the tilemap name (2 bytes), the bar will be immediately drawn to the right.
			;
		
			; bytes0-1: Destination pointer
			ld   b, $00				; BC = C * 4
			sla  c					
			sla  c
			ld   hl, Pause_BarTbl	; HL = Table base
			add  hl, bc				; Seek to entry (starts with vram pointer)
			call CopyWord			; Write the word value, seek pointers ahead
			
			; byte2: Writing mode + Number of bytes to write
			ld   a, $07				; Gauge width of 5 tiles + 2 for the weapon name
			ld   [de], a
			inc  de
			
			; byte3+: payload
			call CopyWord			; Copy weapon name, seek pointers ahead
			
			;
			; We're now pointing two tiles to the right from the origin point.
			; Set up the tilemap event to draw the small gauge at the current location.
			;
			
			ld   c, $05			; C = Tiles left
			
		; [POI] Unreachable failsafe, cap the value to BAR_MAX
		pop  af					; A = Bar value
		cp   BAR_MAX+1			; tBarValue <= $98?
		jr   c, .calcBars		; If so, jump
		ld   a, $98				; Otherwise, cap

	.calcBars:
		; The same code as Game_MkBarRowDrawEv, but with hardcoded tile ID ranges
		
		; Each bar represents 8 units
		; A = CEIL(A/8)
		add  $07			; CEIL
		srl  a				; >> 1 (/2)
		srl  a				; >> 1 (/4)
		srl  a				; >> 1 (/8)
	
	.stFill:
		; Filled: Draw BarCount/4 filled tiles 
		push af ; Save bar count
			srl  a			; >> 1 (/2)
			srl  a			; >> 1 (/4)
			jr   z, .stPart	; Are there less than 4 bars left? If so, skip ahead
			
		.drawFill:
			ld   b, a		; D = Fill tiles left
			ld   a, $84		; A = Fill tile ID
		.loopF:
			ld   [de], a	; Write the tile
			inc  de
			dec  c			; TilesLeft--
			dec  b			; FillLeft--
			jr   nz, .loopF
			
	.stPart:
		; Partially Filled: Remainder of the above
		pop  af 			; Restore bar count
		and  $03			; Get remainder
		jr   z, .stEmpty	; Is it 0? If so, skip ahead
		add  $80			; Otherwise, add the base tile ID
		ld   [de], a		; and draw the single partial tile
		inc  de
		dec  c				; TilesLeft--
		
	.stEmpty:
		; Empty: Keep drawing until TilesLeft elapses
		ld   a, c
		or   a				; Is it already 0?
		jr   z, .end		; If so, we're done
		ld   a, $80			; A = Black bar tile ID
	.loopE:
		ld   [de], a		; Draw to tilemap
		inc  de
		dec  c				; Are we done?
		jr   nz, .loopE		; If not, loop
	.end:
		xor  a				; Write the end terminator
		ld   [de], a
	pop  hl
	pop  bc
	ret
	
; =============== Pause_BarTbl ===============
; Defines the location and name for each entry in the pause screen, indexed by weapon ID / current selection.
; The tilemap pointer refers to where the name gets written, while the gauge is drawn two tiles to the right.
MACRO mPBarDef
	db HIGH(\1),LOW(\1) ; Tilemap pointer (reverse order)
	db \2 ; Weapon name
ENDM
Pause_BarTbl:
	SETCHARMAP pause
	mPBarDef $9C62, "P " ; WPN_P 
.wpn:
	mPBarDef $9C6B, "RC" ; WPN_RC
	mPBarDef $9CA2, "RM" ; WPN_RM
	mPBarDef $9CAB, "RJ" ; WPN_RJ
	mPBarDef $9CE2, "TP" ; WPN_TP
	mPBarDef $9CEB, "AR" ; WPN_AR
	mPBarDef $9D22, "WD" ; WPN_WD
	mPBarDef $9D2B, "ME" ; WPN_ME
	mPBarDef $9D62, "CL" ; WPN_CR
	mPBarDef $9D6B, "NE" ; WPN_NE
	mPBarDef $9DA2, "HA" ; WPN_HA
	mPBarDef $9DAB, "MG" ; WPN_MG
	mPBarDef $9DE2, "SG" ; WPN_SG
.en:
	mPBarDef $9DEB, "EN" ; WPN_EN
	
; =============== Pause_FlashWpnName ===============
; Flashes the selected weapon's name every 8 frames.
; This also polls for input.
Pause_FlashWpnName:
	; Every 8 frames...
	ldh  a, [hTimer]
	and  $07
	jr   nz, .noChange
	
	;
	; Build the TilemapDef for the weapon name only.
	; The table containing this data, indexed by WPN_*, also contains the tilemap pointer.
	; After drawing the tilemap name (2 bytes), the bar will be immediately drawn to the right.
	;
	
	; bytes0-1: Destination pointer
	ld   a, [wWpnId]		; A = wWpnId * 4
	add  a
	add  a
	ld   hl, Pause_BarTbl	; HL = Table base
	ld   b, $00				
	ld   c, a
	add  hl, bc				; Seek to entry (starts with vram pointer)
	ld   de, wTilemapBuf	; DE = Event data buffer
	call CopyWord			; Write the word value, seek pointers ahead
	
	; byte2: Writing mode + Number of bytes to write
	ld   a, $02				; 2 tiles for the weapon name
	ld   [de], a
	inc  de
	
	; byte3+: payload
	
	; Alternate between the actual weapon name and two blank tiles every other 8 frames
	ldh  a, [hTimer]
	and  $08				; hTimer % 8 != 0?
	jr   nz, .wpnName		; If so, jump
.blankName:
	ld   a, $70				; A = Blank tile
	ld   [de], a			; Set it as first char
	inc  de					; EvPtr++
	jr   .setChar2			; Set it as second char
.wpnName:
	ldi  a, [hl]			; Read first char
	ld   [de], a			; Write it over
	inc  de					; EvPtr++
	ldi  a, [hl]			; Read second char
.setChar2:
	ld   [de], a			; Write it over
	inc  de					; EvPtr++
	xor  a					; Write terminator
	ld   [de], a
	
	rst  $10 ; Wait tilemap load
	jp   JoyKeys_Refresh
	
.noChange:
	rst  $08 ; Wait Frame
	jp   JoyKeys_Refresh
	
; =============== CopyWord ===============
; Copies two bytes from the source to the destination,
; advancing both appropriately.
; IN
; - HL: Ptr to source
; - DE: Ptr to destination
CopyWord:
REPT 2
	ldi  a, [hl]	; Read src, Src++
	ld   [de], a	; Write to dest
	inc  de			; Dest++
ENDR
	ret
	
; =============== Pause_CanMoveSel ===============
; Checks if the cursor can move to the specified location.
; In practice, it mostly checks if the weapons are unlocked.
; IN
; - A: Current weapon / Cursor selection (WPN_*)
; OUT
; - C flag: If set, the cursor can move.
;           (ie: the weapon is unlocked)
Pause_CanMoveSel:
	; The basic player weapon is always selectable
	or   a ; WPN_P	; Selecting the default weapon?
	jr   nz, .chkTank	; If not, skip
	scf  				; Otherwise, C Flag = Set
	ret
.chkTank:
	; And so are E-Tanks
	cp   WPN_EN
	jr   nz, .chkWpns
	scf  
	ret
.chkWpns:
	; The rest is all unlockable weapons/items.
	; This opts to do checks by shifting the relevant bit to the carry, and it assumes
	; that cursor poin a way that can't be represented by the WPUB_* constants,
	push bc
		ld   c, a ; Save cursor pos
			; Sakugarne requires bit3 of wWpnUnlock1
			; This is just a manual check, as it's the exception to the convention (see .chkItems)
			cp   WPN_SG			; Selecting Sakugarne?
			jr   nz, .chkItems		; If not, skip
			ld   a, [wWpnUnlock1]	; Get unlock bits
			swap a					; << 4
			rla  					; << 1 (bit3 shifted)
			jr   .end
		.chkItems:
			; The first four selections are for the items, stored in wWpnUnlock1 (alongside WPN_P, which was checked before).
			; This and .chkNormWpn need WPN_* and WPUB_* to be consistent, due to how the selection number doubles
			; as how many times to shift bits right.
			cp   WPN_TP				; wWpnId >= WPN_TP
			jr   nc, .chkNormWpn	; If so, skip 
			ld   b, a				; Res = wWpnUnlock1 >> A
			ld   a, [wWpnUnlock1]
			jr   .loopBit
		.chkNormWpn:
			; Normal boss weapon, stored in wWpnUnlock0.
			; Offset by -1 since one extra shift is needed to shift into the carry.
			; (.chkItems didn't need to as WPN_P being $00 already provided that extra shift)
			sub  WPN_TP-1		; Res = wWpnUnlock0 >> A - 3
			ld   b, a
			ld   a, [wWpnUnlock0]
		.loopBit:
			rra  					; A >>= 1
			dec  b					; Done shifting?
			jr   nz, .loopBit		; If not, loop
	.end:
		ld   a, c ; Restore cursor pos
	pop  bc
	ret
	
