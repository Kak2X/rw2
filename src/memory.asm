SECTION "Main Memory", WRAM0[$C000]
wLvlLayout:            ds $800 ; $C000
wLvlUnkTblC800:        ds $100 ; $C800
wLvlGFXReqTbl:         ds $100 ; $C900 ; GFX load request table for each column in the level
wLvlBlocks:            ds $100 ; $CA00 ; Table of tile IDs for every 16x16 block

DEF wLvlLayout_End     EQU wLvlUnkTblC800

SECTION "CC00", WRAM0[$CC00]
ds $20
wRoomTrsU:             ds $20 ; $CC20 ; Table of target room IDs when scrolling up, indexed by room ID.
wRoomTrsD:             ds $20 ; $CC40 : See above, but when scrolling down.

SECTION "CF00", WRAM0[$CF00]

;--
; Screen events enablers
wLvlScrollEvMode:      db ; $CF00 ; Enable tilemap row/column write, for level scrolling (contains scroll type + timer)
wPkgEv:                db ; $CF01 ; Enable tilemap packet write from wPkgBuf
wPkgBarEv:             db ; $CF02 ; Enable tilemap packet write from wPkgBarBuf
wShutterEvMode:        db ; $CF03 ; Enable tilemap boss shutter effect
;--
; GFX Copy on VBLANK (the only screen transfer for GFX)
wGfxEvSrcBank:         db ; $CF04 ; Source GFX Bank. Doubles as enable flag -- if $00, the GFX copy is disabled.
wGfxEvTilesLeft:       db ; $CF05 ; Number of tiles remaining to copy.
wGfxEvDestPtr_High:    db ; $CF06 ; Destination VRAM ptr, high byte.
wGfxEvDestPtr_Low:     db ; $CF07 ; Destination VRAM ptr, low byte.
wGfxEvSrcPtr_High:     db ; $CF08 ; Source GFX ptr, high byte.
wGfxEvSrcPtr_Low:      db ; $CF09 ; Source GFX ptr, low byte.
ds 1
wLvlRoomId:            db ; $CF0B ; Room ID, only used in a few cases (ie: room transitions)
wLvlColL:              db ; $CF0C ; Current column number in a level, ??? relative to the left edge of the screen.
ds 1
wPl_Unk_Alt_Y:         db ; $CF0E ; ??? Target pos?
wPl_Unk_Alt_X:         db ; $CF0F ; ??? Target pos?
wLvl_Unk_CurCol:       db ; $CF10 ; ??? Current column number the player is on
SECTION "CF12", WRAM0[$CF12]
wPlDirH:               db ; $CF12 ; Direction the player faces (0: left, 1: right)
ds 2
wPlRelX:               db ; $CF15 ; Player X position, relative to the screen
wPlRelY:               db ; $CF16 ; Player Y position, relative to the screen

SECTION "CF20", WRAM0[$CF20]
wScrollVDir:           db ; $CF20 ; Vertical scroll direction


SECTION "CF3D", WRAM0[$CF3D]
wShutterBGPtr_Low:     db ; $CF3D ; Target tilemap pointer when animating the shutter.
wShutterBGPtr_High:    db ; $CF3E
ds 2
wActGfxId:             db ; $CF41 ; Loaded art set for room actors

SECTION "CF56", WRAM0[$CF56]
wTmpTileIdUL:           db ; $CF56 ; Temporary location to store the four tile IDs from wLvlBlocks
wTmpTileIdDL:           db ; $CF57
wTmpTileIdUR:           db ; $CF58
wTmpTileIdDR:           db ; $CF59


SECTION "CFE1", WRAM0[$CFE1]
wBarDrawQueued:    db ; $CFE1 ; ??? Signals if a life/weapon bar has redraw queued up, important since only one can be update perr frame.

SECTION "DD00", WRAM0[$DD00]
; Multipurpose scratch buffer for screen transfers
UNION
wScrEvRows:            ds $40 ; $DD00 ; Tile IDs when vertical scrolling
NEXTU
wPkgBuf:               ds $100 ; $DD00 ; VRAM Packet buffer 0
wPkgBarBuf:            ds $100 ; $DE00 ; VRAM Packet buffer 1
ENDU

SECTION "HRAM", HRAM[$FF80]
hOAMDMA:         ds $0A ; $FF80 
hJoyKeys:            db ; $FF8A ; Currently held keys
hJoyNewKeys:         db ; $FF8B ; Newly pressed keys
ds 1
hFrameEnd:           db ; $FF8D ; Marks the frame as having ended.
hJoyKeysRaw:         db ; $FF8E ; "Raw" held keys value polled from VBlank.
hTimer:              db ; $FF8F ; Global timer

SECTION "FF90", HRAM[$FF90]
hScrollY:            db ; $FF90 ; Y scroll position
hScrollX:            db ; $FF91 ; X scroll position
hScrollXNybLow:      db ; $FF92 ; Copy of the above value's lower nybble.
hScrollX2:           db ; $FF93 ; [POI] X Scroll position for the screen split area, useless
hLYC:                db ; $FF94 ; Scanline number the rLYC/LCDC screen split triggers, generally aligned to hWinY ($FF to disable)
hWinX:               db ; $FF95 ; X WINDOW scroll position (ie: status bar, ...)
hWinY:               db ; $FF96 ; Y WINDOW scroll position ($FF to disable)


SECTION "FF9E", HRAM[$FF9E]
hRomBank:            db ; $FF9E ; Last ROM bank loaded
hTrsRowsProc:        db ; $FF9F ; Number of block rows processed during vertical transitions

SECTION "FFB0", HRAM[$FFB0]
hScrEvLvlLayoutPtr_Low:  db ; $FFB0 ; Source level layout pointer
hScrEvLvlLayoutPtr_High: db ; $FFB1 ; 
hScrEvOffH:              db ; $FFB2 ; Target horizontal offset in grid
hScrEvOffV:              db ; $FFB3 ; Target vertical offset in grid
hScrEvVDestPtr_Low:      db ; $FFB4
hScrEvVDestPtr_High:     db ; $FFB5

SECTION "FFF0", HRAM[$FFF0]
ds 5
hBGP:                db ; $FFF5 ; BG palette
hOBP0:               db ; $FFF6 ; OBJ0 palette
hOBP1:               db ; $FFF7 ; OBJ1 palette
