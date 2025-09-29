; =============== Lvl_LoadData ===============
; Loads all of the data for the currently selected level.
Lvl_LoadData:
	push af
		ld   a, BANK(Lvl_LayoutPtrTbl) ; BANK $05
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	;
	; LEVEL LAYOUT
	;
	; This is compressed using RLE, and once decompressed it takes up $A00 bytes.
	; In the same archive, it packs:
	; - Actual level layout ($800 bytes)
	;   This is a straight 256x8 level map, taking up $800 bytes uncompressed.
	;   The entire level is loaded all at once and the data is read/ordered as-is.
	;   This has a few implications:
	;   - There's no hard concept of rooms loading their own layout data
	;   - Room transitions simply work by warping the player to another point of the same map.
	; - Actor layout ($200 bytes)
	;   Split into two $100 tables, all indexed by column number.
	;   The first contains the Y position & nospawn flag of the actor, while the second one
	;   has a mix of Actor IDs and GFX set IDs.
	;   A few notes:
	;   - The X position isn't stored anywhere here.
	;     Instead, the index to the actor layout represents the column number, and the actor is spawned at its center.
	;     This means there can be at most one actor/column.
	;     Actors that don't want to spawn at the center of the column have their init code adjust the position.
	;   - The game determines if a given entry is for a GFX set ID
	;     by checking for the respective value in the first table to be 0. 
	;   - The nospawn flag is always set to 0 in the compressed data, otherwise the actor wouldn't load.
	;     In RAM, this helps to avoid respawning on-screen actors or to permanently delete actors (see below)
	;     
	
	; DE = Ptr to compressed level layout data
	ld   a, [wLvlId]
	ld   hl, Lvl_LayoutPtrTbl 	; BANK $05
	ld   b, $00					; BC = wLvlId * 2
	sla  a
	ld   c, a
	add  hl, bc
	ldi  a, [hl]	; Read ptr out to DE
	ld   e, a
	ld   a, [hl]
	ld   d, a
	
	; Decompress it to wLvlLayout.
	; The RLE format takes advantage of how the decompressed data never has the MSB set, allowing for some shortcuts.
	; The bytes are read in sequence, and:
	; - If the MSB isn't set, the current byte is copied directly to the destination.
	; - If the MSB is set, the next byte is repeated <current byte> times.
	;
	; These is no explicit length to this data, instead decompression ends when moving
	; outside the buffer.
	
	ld   hl, wLvlLayout
.nextCmdL:
	ld   a, [de]		; Read command byte
	inc  de				; SrcPtr++
	bit  7, a			; Is the MSB set?
	jr   nz, .repL		; If so, it's a repeated copy
.uncL:
	ldi  [hl], a		; Otherwise, it's a raw byte. Copy it as-is, DestPtr++
	jr   .chkEndL
.repL:
	and  $7F			; Filter out MSB
	ld   b, a			; B = Repeat count
	ld   a, [de]		; Read single byte
	inc  de				; SrcPtr++
.repLoopL:
	ldi  [hl], a		; Copy the same byte over, DestPtr++
	dec  b				; Done the repeated copy?
	jr   nz, .repLoopL	; If not, loop it
.chkEndL:
	ld   a, h
	cp   HIGH(wLvlLayoutDecode_End)			; Reached the end?
	jr   c, .nextCmdL
	
	
.restPerm:
	;
	; PERMADESPAWNS
	;
	; The nospawn flag for actors starts out as 0, is set when one spawns, and normally unset when one despawns.
	; This prevents actors that are currently on-screen from being reloaded, any actor with the nospawn flag set
	; is skipped.
	;
	; There wouldn't need to be anything else to do if that was it but some actors, like 1UPs, need to permanently
	; despawn once collected. This is accomplished by them despawning without clearning the nospawn flag.
	; However, when the level reloads after the player has died, the actor layout is fully reset, and so are the nospawn flags.
	;
	; To enforce permadespawns, the nospawn data is also stored into a separate buffer, which is applied after the level loads.
	; If this is the first time we load the level however, that's not necessary -- moreover, that memory range is dirty and 
	; needs to be wiped clean.
	;
	ld   a, [wPlRespawn]
	or   a							; Reloading after player death?
	jr   nz, .loadPerm				; If so, jump
.initPerm:
	xor  a							; Otherwise, initialize the table
	ld   hl, wActDespawnTbl
	ld   bc, $0100
	call ZeroMemory
	jr   .loadBlocks
.loadPerm:
	; Merge the entirety of wActDespawnTbl into the live table at wActLayoutFlags. 
	ld   l, $00						; For each byte...
.loopColl:
	ld   h, HIGH(wActDespawnTbl)	; B = Backup
	ld   b, [hl]
	ld   h, HIGH(wActLayoutFlags) 	; A = Live
	ld   a, [hl]
	or   b							; Merge backup nospawn flag
	ld   [hl], a					; Save back to main
	inc  l							; Restored all $100?
	jr   nz, .loopColl				; If not, loop
	
.loadBlocks:
	;
	; 16x16 BLOCK DEFINITIONS
	;
	; These define, for every block, the four 8x8 tiles they use.
	;
	; This data is stored uncompressed in a table indexed by level ID, where each entry
	; is $100 bytes long (enough space for defining $40 blocks).
	;
	ld   a, [wLvlId]		; BC = wLvlId * $100
	ld   b, a
	ld   c, $00
	ld   hl, Lvl_BlockTbl 	; BANK $05
	add  hl, bc				; Seek to the block table entry
	ld   de, wLvlBlocks
	ld   bc, $0100
	call CopyMemory			; Copy it over
	
	;--
	
	;
	; The remainder of the level data is all stored (in the ROM, at least) in a way that uses 1 byte for each room.
	; Rooms in this game are simply groups of 10 columns (the horizontal width of a screeen) starting from the leftmost one.
	;
	; As the level width is fixed, so is the max number of rooms in a level ($19), therefore, given the same level ID,
	; the offsets to each set of data are the same.
	;
	; Instead of using pointer tables, a single table at Lvl_RoomColOffsetTbl is used containing multiples of the room count.
	; When indexed by level ID, it will return said offset for each of the tables.
	; (of course, it would have been better to push/pop the offset instead of always recalculating it...)
	;
	
	; OUT
	; - DE: Data offset
	MACRO mGetLvlOffset
		ld   hl, Lvl_RoomColOffsetTbl	; HL = Base table
		ld   a, [wLvlId]
		add  a							; BC = wLvlId * 2
		ld   b, $00
		ld   c, a
		add  hl, bc						; Seek to entry
		ld   e, [hl]					; Read out offset value to DE
		inc  hl
		ld   d, [hl]
	ENDM
	
	;
	; SCROLL LOCKS (UNPACK)
	;
	; Marks which screens the camera is free to scroll towards.
	; While this data is stored in RAM at wLvlScrollLocks on a per-column basis ($00 -> no scroll, $80 -> scroll),
	; in the ROM it has a granularity of half a room.
	;
	; Specifically, it's packed into $19 bytes, with byte mapping to a single room.
	; Of that byte, only two bits are used: bit1 for the left side, bit0 for the right.
	;
	
	; DE = Ptr to scroll lock data
	mGetLvlOffset				; DE = Data offset
	ld   hl, Lvl_ScreenLockTbl	; BANK $05
	add  hl, de					; Seek to level scroll data
	ld   e, l					; DE = HL
	ld   d, h
	
	; Unpack the data to RAM
	ld   hl, wLvlScrollLocks	; HL = Starting address
	ld   b, $19					; B = Rooms left
.lockLoop:						; For each byte...

	; LEFT SIDE
	ld   a, [de]		; Read byte
	rrca 				; shift bit1 to bit0
	rrca 				; shift bit0 to bit7
	and  $80			; Remove other bits
	REPT ROOM_COLCOUNT/2	
		ldi  [hl], a	; Apply it for the left half of the room
	ENDR
	
	; RIGHT SIDE
	ld   a, [de]		; Reread same byte
	rrca 				; shift bit0 to bit7
	and  $80			; Remove other bits
	REPT ROOM_COLCOUNT/2	
		ldi  [hl], a	; Apply it for the right half of the room
	ENDR
	
	inc  de				; SrcPtr++
	dec  b				; Done for all rooms?
	jr   nz, .lockLoop	; If not, loop
	
	;
	; SCREEN LOCKS (RAW)
	;
	; This will be later used to determine the player's spawn position on the current room.
	;
	mGetLvlOffset					; DE = Data offset
	ld   hl, Lvl_ScreenLockTbl
	add  hl, de
	ld   de, wLvlScrollLocksRaw
	ld   bc, $0019
	call CopyMemory
	
	;
	; ROOM TRANSITIONS (UPWARDS)
	;
	; For each room, a target room ID is defined when performing a transition to the room above.
	; These can only be performed by climbing up a ladder.
	;
	; It's always possible to perform transitions at any point, it's up to the level designer
	; to include ladders that allow doing one.
	;
	mGetLvlOffset
	ld   hl, Lvl_RoomTrsUTbl		
	add  hl, de
	ld   de, wRoomTrsU
	ld   bc, $0019
	call CopyMemory
	
	;
	; ROOM TRANSITIONS (DOWNWARDS)
	;
	; Like above, but when moving down. Ladders aren't even required here.
	;
	; As with upwards transitions, it's always possible to do them at any point of any room, 
	; here doubly so since you don't need to be on a ladder. 
	; It's up to the level designer to restrict it with solid blocks or (invisible) spikes.
	;
	; Worth noting that there isn't a real concept of pits either. To kill the player instead
	; of triggering the transition, spikes need to be manually placed on the bottom row.
	; Spikes placed there have special behavior that instakills the player regardless of
	; invulnerability status, to really prevent the transition from being triggered.
	;
	mGetLvlOffset
	ld   hl, Lvl_RoomTrsDTbl
	add  hl, de
	ld   de, wRoomTrsD
	ld   bc, $0019
	call CopyMemory
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
; =============== Lvl_InitSettings ===============
; Initializes additional level properties.
Lvl_InitSettings:
	
	;
	; LEVEL PALETTE (ANIMATION)
	;
	; Overrides the fixed palette loaded by GFXSET_LEVEL.
	;
	; Each level has two palettes assigned, to allow for simple palette animations.
	; This is always enabled -- levels which don't use it merely define two identical palettes.
	;
	
	ld   a, [wLvlId]	; HL = Lvl_PalTbl[wLvlId * 2]
	add  a
	ld   hl, Lvl_PalTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	
	ldi  a, [hl]		; Read 1st pal
	ldh  [hBGP], a
	ldh  [hBGPAnim0], a
	ld   a, [hl]		; Read 2nd pal
	ldh  [hBGPAnim1], a
	
	;
	; AIR MAN's stage is hardcoded to use BG priority,
	; to make the clouds appear in front.
	;
	ld   b, $00
	ld   a, [wLvlId]
	cp   LVL_AIR
	jr   nz, .setBGPri
	ld   b, SPR_BGPRIORITY
.setBGPri:
	ld   a, b
	ld   [wPlSprFlags], a
	
	;
	; WATER SUPPORT
	;
	; Levels that don't have any water disable this to save on processing time.
	;
	ld   a, [wLvlId]	; wLvlWater = Lvl_WaterFlagTbl[wLvlId]
	ld   hl, Lvl_WaterFlagTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ld   [wLvlWater], a
	
	;
	; STATUS BAR POSITION
	;
	ld   a, $80
	ldh  [hLYC], a		; Set status bar at the bottom
	ldh  [hWinY], a		; ""
	xor  a
	ldh  [hScrollX2], a	; Not necessary
	ld   a, $07
	ldh  [hWinX], a		; Docked to the left
	ret
	
