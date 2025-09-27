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
	INCLUDE "data/lvl/hard/locks.asm"
	INCLUDE "data/lvl/top/locks.asm"
	INCLUDE "data/lvl/magnet/locks.asm"
	INCLUDE "data/lvl/needle/locks.asm"
	INCLUDE "data/lvl/crash/locks.asm"
	INCLUDE "data/lvl/metal/locks.asm"
	INCLUDE "data/lvl/wood/locks.asm"
	INCLUDE "data/lvl/air/locks.asm"
	INCLUDE "data/lvl/castle/locks.asm"
	INCLUDE "data/lvl/station/locks.asm"

	mIncJunk "L05411A"

; =============== Lvl_RoomTrsUTbl ===============
; Room transitions, above.
Lvl_RoomTrsUTbl:
	INCLUDE "data/lvl/hard/trs_u.asm"
	INCLUDE "data/lvl/top/trs_u.asm"
	INCLUDE "data/lvl/magnet/trs_u.asm"
	INCLUDE "data/lvl/needle/trs_u.asm"
	INCLUDE "data/lvl/crash/trs_u.asm"
	INCLUDE "data/lvl/metal/trs_u.asm"
	INCLUDE "data/lvl/wood/trs_u.asm"
	INCLUDE "data/lvl/air/trs_u.asm"
	INCLUDE "data/lvl/castle/trs_u.asm"
	INCLUDE "data/lvl/station/trs_u.asm"
	; [POI] For what's worth, the padding area starts with a single $01.
	mIncJunk "L05427A"
	
; =============== Lvl_RoomTrsDTbl ===============
; Room transitions, below.
Lvl_RoomTrsDTbl:
	INCLUDE "data/lvl/hard/trs_d.asm"
	INCLUDE "data/lvl/top/trs_d.asm"
	INCLUDE "data/lvl/magnet/trs_d.asm"
	INCLUDE "data/lvl/needle/trs_d.asm"
	INCLUDE "data/lvl/crash/trs_d.asm"
	INCLUDE "data/lvl/metal/trs_d.asm"
	INCLUDE "data/lvl/wood/trs_d.asm"
	INCLUDE "data/lvl/air/trs_d.asm"
	INCLUDE "data/lvl/castle/trs_d.asm"
	INCLUDE "data/lvl/station/trs_d.asm"
	; [POI] This also starts out with a $01.
	mIncJunk "L0543FA"
	
; =============== LEVEL LAYOUTS ===============
LvlLayout_Hard: INCBIN "data/lvl/hard/layout.rle"
LvlLayout_Top: INCBIN "data/lvl/top/layout.rle"
LvlLayout_Magnet: INCBIN "data/lvl/magnet/layout.rle"
LvlLayout_Needle: INCBIN "data/lvl/needle/layout.rle"
LvlLayout_Crash: INCBIN "data/lvl/crash/layout.rle"
LvlLayout_Metal: INCBIN "data/lvl/metal/layout.rle"
LvlLayout_Wood: INCBIN "data/lvl/wood/layout.rle"
LvlLayout_Air: INCBIN "data/lvl/air/layout.rle"
LvlLayout_Castle: INCBIN "data/lvl/castle/layout.rle"
LvlLayout_Station: INCBIN "data/lvl/station/layout.rle"

	mIncJunk "L05748F"
	
; =============== 16x16 BLOCK DEFINITIONS ===============
Lvl_BlockTbl: 
BlockLayout_Hard: INCBIN "data/lvl/hard/block16.bin"
BlockLayout_Top: INCBIN "data/lvl/top/block16.bin"
BlockLayout_Magnet: INCBIN "data/lvl/magnet/block16.bin"
BlockLayout_Needle: INCBIN "data/lvl/needle/block16.bin"
BlockLayout_Crash: INCBIN "data/lvl/crash/block16.bin"
BlockLayout_Metal: INCBIN "data/lvl/metal/block16.bin"
BlockLayout_Wood: INCBIN "data/lvl/wood/block16.bin"
BlockLayout_Air: INCBIN "data/lvl/air/block16.bin"
BlockLayout_Castle: INCBIN "data/lvl/castle/block16.bin"
BlockLayout_Station: INCBIN "data/lvl/station/block16.bin"
