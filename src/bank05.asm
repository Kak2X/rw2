Lvl_LayoutPtrTbl:
	dw LvlLayout_Hard     ; LVL_HARD
	dw LvlLayout_Top      ; LVL_TOP
	dw LvlLayout_Magnet   ; LVL_MAGNET
	dw LvlLayout_Needle   ; LVL_NEEDLE
	dw LvlLayout_Crash    ; LVL_CRASH
	dw LvlLayout_Metal    ; LVL_METAL
	dw LvlLayout_Wood     ; LVL_WOOD
	dw LvlLayout_Air      ; LVL_AIR
	dw LvlLayout_Castle   ; LVL_CASTLE
	dw LvlLayout_Station  ; LVL_STATION

	mIncJunk "L054014"
	
; =============== Lvl_ScreenLockTbl ===============
; Screen locks, 1 byte for each room.
; bit1 -> left side of room unlocked.
; bit0 -> right side of room unlocked.
Lvl_ScreenLockTbl:
	INCLUDE "data/game/lvl/hard/locks.asm"
	INCLUDE "data/game/lvl/top/locks.asm"
	INCLUDE "data/game/lvl/magnet/locks.asm"
	INCLUDE "data/game/lvl/needle/locks.asm"
	INCLUDE "data/game/lvl/crash/locks.asm"
	INCLUDE "data/game/lvl/metal/locks.asm"
	INCLUDE "data/game/lvl/wood/locks.asm"
	INCLUDE "data/game/lvl/air/locks.asm"
	INCLUDE "data/game/lvl/castle/locks.asm"
	INCLUDE "data/game/lvl/station/locks.asm"

	mIncJunk "L05411A"

; =============== Lvl_RoomTrsUTbl ===============
; Room transitions, above.
Lvl_RoomTrsUTbl:
	INCLUDE "data/game/lvl/hard/trs_u.asm"
	INCLUDE "data/game/lvl/top/trs_u.asm"
	INCLUDE "data/game/lvl/magnet/trs_u.asm"
	INCLUDE "data/game/lvl/needle/trs_u.asm"
	INCLUDE "data/game/lvl/crash/trs_u.asm"
	INCLUDE "data/game/lvl/metal/trs_u.asm"
	INCLUDE "data/game/lvl/wood/trs_u.asm"
	INCLUDE "data/game/lvl/air/trs_u.asm"
	INCLUDE "data/game/lvl/castle/trs_u.asm"
	INCLUDE "data/game/lvl/station/trs_u.asm"
	; [POI] For what's worth, the padding area starts with a single $01.
	mIncJunk "L05427A"
	
; =============== Lvl_RoomTrsDTbl ===============
; Room transitions, below.
Lvl_RoomTrsDTbl:
	INCLUDE "data/game/lvl/hard/trs_d.asm"
	INCLUDE "data/game/lvl/top/trs_d.asm"
	INCLUDE "data/game/lvl/magnet/trs_d.asm"
	INCLUDE "data/game/lvl/needle/trs_d.asm"
	INCLUDE "data/game/lvl/crash/trs_d.asm"
	INCLUDE "data/game/lvl/metal/trs_d.asm"
	INCLUDE "data/game/lvl/wood/trs_d.asm"
	INCLUDE "data/game/lvl/air/trs_d.asm"
	INCLUDE "data/game/lvl/castle/trs_d.asm"
	INCLUDE "data/game/lvl/station/trs_d.asm"
	; [POI] This also starts out with a $01.
	mIncJunk "L0543FA"
	
; =============== LEVEL LAYOUTS ===============
LvlLayout_Hard: INCBIN "data/game/lvl/hard/layout.rle"
LvlLayout_Top: INCBIN "data/game/lvl/top/layout.rle"
LvlLayout_Magnet: INCBIN "data/game/lvl/magnet/layout.rle"
LvlLayout_Needle: INCBIN "data/game/lvl/needle/layout.rle"
LvlLayout_Crash: INCBIN "data/game/lvl/crash/layout.rle"
LvlLayout_Metal: INCBIN "data/game/lvl/metal/layout.rle"
LvlLayout_Wood: INCBIN "data/game/lvl/wood/layout.rle"
LvlLayout_Air: INCBIN "data/game/lvl/air/layout.rle"
LvlLayout_Castle: INCBIN "data/game/lvl/castle/layout.rle"
LvlLayout_Station: INCBIN "data/game/lvl/station/layout.rle"

	mIncJunk "L05748F"
	
; =============== 16x16 BLOCK DEFINITIONS ===============
Lvl_BlockTbl: 
BlockLayout_Hard: INCBIN "data/game/lvl/hard/block16.bin"
BlockLayout_Top: INCBIN "data/game/lvl/top/block16.bin"
BlockLayout_Magnet: INCBIN "data/game/lvl/magnet/block16.bin"
BlockLayout_Needle: INCBIN "data/game/lvl/needle/block16.bin"
BlockLayout_Crash: INCBIN "data/game/lvl/crash/block16.bin"
BlockLayout_Metal: INCBIN "data/game/lvl/metal/block16.bin"
BlockLayout_Wood: INCBIN "data/game/lvl/wood/block16.bin"
BlockLayout_Air: INCBIN "data/game/lvl/air/block16.bin"
BlockLayout_Castle: INCBIN "data/game/lvl/castle/block16.bin"
BlockLayout_Station: INCBIN "data/game/lvl/station/block16.bin"
