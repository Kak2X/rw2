; =============== RESET VECTOR $00 ===============
; Jump table handler.
; A table of pointers is expected to follow the "rst $00" instruction, which will be indexed using A.
; Execution will jump to the returned pointer. 
; IN
; - A: Index to the pointer table
SECTION "Rst00", ROM0[$0000]
;Rst_DynJump:
	jp   DynJump
	mIncJunk "L000003"
; =============== RESET VECTOR $08 ===============
SECTION "Rst08", ROM0[$0008]
;Rst_EndOfFrame:
	jp   EndOfFrame
	mIncJunk "L00000B"
; =============== RESET VECTOR $10 ===============
SECTION "Rst10", ROM0[$0010]
;Rst_TilemapEv_RunSync:
	jp   TilemapEv_RunSync
	mIncJunk "L000013"
; =============== RESET VECTOR $18 ===============
SECTION "Rst18", ROM0[$0018]
;Rst_TilemapBarEv_RunSync:
	jp   TilemapBarEv_RunSync
	mIncJunk "L00001B"
; =============== RESET VECTOR $20 ===============
SECTION "Rst20", ROM0[$0020]
;Rst_GfxCopyEv_Wait:
	jp   GfxCopyEv_Wait
	mIncJunk "L000023"
; =============== RESET VECTOR $28 ===============
; Not used.
SECTION "Rst28", ROM0[$0028]
	ret
	mIncJunk "L000029"
; =============== RESET VECTOR $30 ===============
; Not used.
SECTION "Rst30", ROM0[$0030]
	ret
	mIncJunk "L000031"
; =============== RESET VECTOR $38 ===============
; Not used.
SECTION "Rst38", ROM0[$0038]
	ret
	mIncJunk "L000039"
; =============== VBLANK INTERRUPT ===============
SECTION "VBlankInt", ROM0[$0040]
	jp   VBlankHandler
	mIncJunk "L000043"
; =============== LCDC/STAT INTERRUPT ===============
SECTION "LCDCInt", ROM0[$0048]
	jp   LCDCHandler
	mIncJunk "L00004B"
; =============== TIMER INTERRUPT ===============
SECTION "TimerInt", ROM0[$0050]
	jp   TimerHandler
	mIncJunk "L000053"
; =============== SERIAL INTERRUPT ===============
; Not used.
SECTION "SerialInt", ROM0[$0058]
	reti
	mIncJunk "L000059"
; =============== JOYPAD INTERRUPT ===============
; Not used.
SECTION "JoyInt", ROM0[$0060]
	reti
	mIncJunk "L000061"
	
SECTION "EntryPoint", ROM0[$0100]
