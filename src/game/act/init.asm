; =============== ActS_InitMemory ===============
; Initializes the actor memory.
ActS_InitMemory:
	; Delete the last loaded GFX marker
	ld   a, $FF
	ld   [wActGfxId], a
	
	; Start processing actors from the first slot
	xor  a
	ld   [wActStartSlotPtr], a
	
	; Delete everything old from the actor area
	ld   hl, wAct
	ld   bc, wAct_End-wAct
	jp   ZeroMemory
	
; =============== ActS_DespawnAll ===============
; Despawns all of the current actors.
; Used at the start of room transitions to *re-initialize* actor memory to a clean state,
; while safely despawning actors so that they may respawn when moving back to the old room.
; See also: ActS_Despawn
ActS_DespawnAll:
	ld   d, HIGH(wActLayoutFlags)	; DE = Actor layout (high byte)
	ld   hl, wAct					; HL = Current actors
.loop:
	ld   a, [hl]					; Read iActId
	or   a							; Is this slot active?
	jr   z, .next					; If not, skip it
	push hl							; Otherwise...
		; Mark it as empty
		xor  a						
		ldi  [hl], a				; iActId
		inc  l						; iActRtnId
		inc  l						; iActSprMap
		
		; Allow the actor to respawn if scrolled back in
		ld   a, [hl]				; DE = iActLayoutPtr (low byte)
		ld   e, a
		ld   a, [de]				; Read flags associated to this slot
		res  ACTLB_NOSPAWN, a		; Clear nospawn flag
		ld   [de], a				; Save back
	pop  hl							; Restore base slot ptr
.next:
	ld   a, l						; Seek to the next slot
	add  iActEnd
	ld   l, a
	jr   nz, .loop					; Done all 16? If not, loop
	
	; By despawning all actors, we also despawned Rush & the Sakugarne.
	; Clear out their flags that affect the player.
	xor  a
	ld   [wWpnHelperWarpRtn], a		; Rush/SG no longer there, can be recalled
	ld   [wWpnSGRide], a			; Disable pogo movement mode
	
	; Remove all weapon shots too, even though they aren't really actors.
	
	; Top Spin is melee weapon, and its "shot" is allowed to move through rooms
	; since it tracks the player's position.
	ld   a, [wWpnId]
	cp   WPN_TP
	ret  z
	
	; The rest get deleted though
	xor  a
	ld   hl, wShot0+iShotId
	ld   [hl], a
	ld   hl, wShot1+iShotId
	ld   [hl], a
	ld   hl, wShot2+iShotId
	ld   [hl], a
	ld   hl, wShot3+iShotId
	ld   [hl], a
	ret
	
; =============== ActS_SpawnRoom ===============
; Spawns all of the actors in the current room.
; Meant to be called when the level loads or after a room transition
; to immediately spawn all actors that would be visible.
ActS_SpawnRoom:

	;
	; As a room is made of 10 columns (width of a screen), this will spawn any actors
	; defined on the 10 columns after the current one.
	;
	; In case the screen is locked to the right, one extra column is loaded for
	; the same reason it is done when drawing a full screen (the seam's position).
	;

	; A = Current room locks
	ld   a, [wLvlRoomId]
	ld   hl, wLvlScrollLocksRaw
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	
	ld   c, ROOM_COLCOUNT
	bit  0, a				; Is the screen locked to the right? (bit0 clear)
	jr   z, .setStart		; If so, skip (load 10 columns)
	inc  c					; Otherwise, make that 11
	
.setStart:
	
	; Start from the current column number.
	ld   a, [wLvlColL]		; HL = &wActLayoutFlags[wLvlColL]
	ld   l, a				;     (high byte set later)
	
	; Set the initial (relative) X position, which is autocalculated and *NOT* stored in the actor layout.
	; Since there is 1 actor/column, as we loop to the next column, this will be increased by the block width.
	;
	; The value being hardcoded means there's a big assumption about the screen being aligned to the block
	; boundary, which is one of the reasons levels shouldn't allow misaligned transitions
	; (otherwise actors' X positions would be offset incorrectly).
	;
	; This value is initialized to 7 rather than 0 to account for the actor's horizontal origin being at the center of the block.
	; What it does *NOT* account is the offset applied by the hardware, since actor positions and sprite positions
	; are one and the same. (ActS_SpawnFromLayout takes care of that)
	ld   b, $07				; B = Initial X pos
	
.loop:
	push hl
	push bc
		ld   h, HIGH(wActLayoutFlags) 	; Set the high byte
		ld   a, [hl]					; Read spawn flags
		bit  ACTLB_NOSPAWN, a			; Is the actor prevented from spawning?
		jr   nz, .skip					; If so, skip it (already on-screen or already collected)
		bit  ACTLB_SPAWNNORM, a			; Does this actor spawn normally?
		call nz, ActS_SpawnFromLayout	; If so, spawn it
.skip:
	pop  bc
	pop  hl
	
	inc  l				; Seek to the next actor layout entry, for the next column
	ld   a, b			; Spawn next actor to the next column
	add  BLOCK_H
	ld   b, a
	
	dec  c				; Done all columns?
	jr   nz, .loop		; If not, loop
	ret
	
; =============== ActS_SpawnColEdge ===============
; Spawns the actor, if one is defined, for the column that got scrolled in.
; IN
; - L: Actor layout pointer
; - B: X Position
ActS_SpawnColEdge:
	ld   h, HIGH(wActLayoutFlags)
	ld   a, [hl]
	bit  ACTLB_NOSPAWN, a			; Is the actor prevented from spawning?
	ret  nz							; If so, return
	bit  ACTLB_SPAWNNORM, a			; Does this actor spawn normally?
	ret  z							; If not, return
	jr   ActS_SpawnFromLayout
	
; =============== ActS_SpawnColEdgeBehind ===============
; Spawns the actor, if one is defined, for the column opposite to the one that got scrolled in.
; Intended to only spawn actors that spawn from behind the screen, such as
; the large bees in Hard Man's stage.
; These actors are flagged with their own flag so that they are only spawned this way.
; IN
; - L: Actor layout pointer
; - B: X Position
ActS_SpawnColEdgeBehind:
	ld   h, HIGH(wActLayoutFlags)
	ld   a, [hl]
	bit  ACTLB_NOSPAWN, a			; Is the actor prevented from spawning?
	ret  nz							; If so, return
	bit  ACTLB_SPAWNBEHIND, a		; Does this actor spawn from behind?
	ret  z							; If not, return
	jr   ActS_SpawnFromLayout
	
	
; =============== ActS_SpawnFromLayout ===============
; Spawns an actor from an actor layout entry.
; IN
; - HL: Ptr to an wActLayoutFlags entry
; -  A: Value dereferenced from the above
; -  B: X Position
ActS_SpawnFromLayout:
	; The actor is being spawned, not to repeat that since it'll be active
	set  ACTLB_NOSPAWN, a
	ld   [hl], a
	
	;
	; Prepare the call to ActS_Spawn
	;
	
	; Y POSITION
	; Stored in bits0-2 of the wActLayoutFlags entry, representing the row number to spawn on.
	and  $07			; Filter unwanted bits out
	swap a				; From row number to pixels (A *= BLOCK_V)
	add  OBJ_OFFSET_Y	; Actor positions are sprite positions, so get offsetted by the hardware
	or   BLOCK_V-1		; Actor origin is at the bottom, so align it
	ld   [wActSpawnY], a
	
	; X POSITION
	; Comes from the loop itself, already accounts for that origin being at the center.
	ld   a, b
	add  OBJ_OFFSET_X		; It does not account for the hardware offset though
	ld   [wActSpawnX], a
	
	; ACTOR ID
	; Stored in the respective wActLayoutIds entry 
	ld   h, HIGH(wActLayoutIds)
	ld   a, [hl]
	ld   [wActSpawnId], a
	
	; ACTOR LAYOUT POINTER
	; Needed to know where to clear ACTLB_NOSPAWN on despawn.
	ld   a, l
	ld   [wActSpawnLayoutPtr], a
	
	jp   ActS_Spawn
	
