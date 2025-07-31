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
wTilemapEv:            db ; $CF01 ; Enable tilemap write from wTilemapBuf
wTilemapBarEv:         db ; $CF02 ; Enable tilemap write from wTilemapBarBuf
wShutterEvMode:        db ; $CF03 ; Enable tilemap boss shutter effect
;--
; GFX Copy on VBLANK (the only screen transfer for GFX)
wGfxEvSrcBank:         db ; $CF04 ; Source GFX Bank. Doubles as enable flag -- if $00, the GFX copy is disabled.
wGfxEvTilesLeft:       db ; $CF05 ; Number of tiles remaining to copy.
wGfxEvDestPtr_High:    db ; $CF06 ; Destination VRAM ptr, high byte.
wGfxEvDestPtr_Low:     db ; $CF07 ; Destination VRAM ptr, low byte.
wGfxEvSrcPtr_High:     db ; $CF08 ; Source GFX ptr, high byte.
wGfxEvSrcPtr_Low:      db ; $CF09 ; Source GFX ptr, low byte.
wLvlId:                db ; $CF0A ; Level ID
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


SECTION "CFC0", WRAM0[$CFC0]
wPassSelTbl:            ds $10 ; $CFC0 ; Dots placed on the password screen ($00 or $FF)
wPlHealth:              db ; $CFD0 ; Player's health
DEF wPassSelTbl_End EQU wPlHealth
; Ammo for...
wWpnAmmoRC:             db ; $CFD1 ; Rush Coil
wWpnAmmoRM:             db ; $CFD2 ; Rush Marine
wWpnAmmoRJ:             db ; $CFD3 ; Rush Jet
wWpnAmmoTP:             db ; $CFD4 ; Top Spin
wWpnAmmoAR:             db ; $CFD5 ; Air Shooter
wWpnAmmoWD:             db ; $CFD6 ; Leaf Shield
wWpnAmmoME:             db ; $CFD7 ; Metal Blade
wWpnAmmoCL:             db ; $CFD8 ; Crash Bomb
wWpnAmmoNE:             db ; $CFD9 ; Needle Cannon
wWpnAmmoHA:             db ; $CFDA ; Hard Knuckle
wWpnAmmoMG:             db ; $CFDB ; Magnet Missile
wWpnAmmoSG:             db ; $CFDC ; Sakugarne
DEF wWpnAmmo_Start EQU wWpnAmmoRC
DEF wWpnAmmo_End   EQU wWpnAmmoSG + 1
wWpnUnlock1:            db ; $CFDD ; Unlocked weapons / beaten stages (bitmask)
wWpnUnlock0:            db ; $CFDE ;
wWpnSel:                db ; $CFDF ; Currently selected weapon


SECTION "CFE1", WRAM0[$CFE0]
wWpnAmmoCur:            db ; $CFE0 ; Active weapon ammo
wBarDrawQueued:         db ; $CFE1 ; ??? Signals if a life/weapon bar has redraw queued up, important since only one can be update perr frame.
UNION
wWpnAmmoCurCopy:        db ; $CFE2 ; ???
NEXTU
wPassWpnError:          db ; $CFE2 ; Marks if there was an error while decoding unlocked weapons
ENDU

SECTION "CFE8", WRAM0[$CFE8]
wLives:                 db ; $CFE8 ; Number of lives remaining
wETanks:                db ; $CFE9 ; Number of E Tanks

SECTION "CFF4", WRAM0[$CFF4]
wPassCursorX:           db ; $CFF4 ; Password cursor - X position
wPassCursorY:           db ; $CFF5 ; Password cursor - Y position

SECTION "DD00", WRAM0[$DD00]
; Multipurpose scratch buffer for screen transfers
UNION
wScrEvRows:            ds $40 ; $DD00 ; Tile IDs when vertical scrolling
NEXTU
wTilemapBuf:           ds $100 ; $DD00 ; TilemapDef tilemap buffer (Generic)
wTilemapBarBuf:        ds $100 ; $DE00 ; TilemapDef tilemap buffer (Life/Weapon bars)
ENDU
wWorkOAM:              ds OAM_SIZE ; $DF00 ; OAM Mirror
wStack:                ds $60  ; $DFA0

; Fixed sprites
DEF wCursorObj EQU wWorkOAM
DEF wPassCursorULObj EQU wWorkOAM + (OBJ_SIZE * 0)
DEF wPassCursorURObj EQU wWorkOAM + (OBJ_SIZE * 1)
DEF wPassCursorDLObj EQU wWorkOAM + (OBJ_SIZE * 2)
DEF wPassCursorDRObj EQU wWorkOAM + (OBJ_SIZE * 3)

SECTION "HRAM", HRAM[$FF80]
hOAMDMA:             ds $0A; ; $FF80 ; OAMDMA_Code.end-OAMDMA_Code
hJoyKeys:            db ; $FF8A ; Currently held keys
hJoyNewKeys:         db ; $FF8B ; Newly pressed keys
hIE:                 db ; $FF8C ; Backup of rIE when stopping the LCD
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
hWorkOAMPos:         db ; $FF97 ; Current position on the OAM mirror (low byte of the WorkOAM pointer)
hBGMSet:             db ; $FF98 ; Requested BGM Id
hSFXSet:             db ; $FF99 ; Requested SFX Id
hBGMCur:             db ; $FF9A ; Current BGM Id

SECTION "FF9D", HRAM[$FF9D]
hRomBankLast:        db ; $FF9D ; Last ROM bank loaded (Bank to restore when done with hRomBank)
hRomBank:            db ; $FF9E ; Current ROM bank loaded
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
ds 1
hInvulnCheat:        db ; $FFF9 ; [TCRF] Full invulnerability. Shots pass through & pits act like bouncy surfaces.

SECTION "FFFA", HRAM[$FFFA]
hWarmBootFlag:       db ; $FFFA ; [TCRF] Value checked during boot, but has no effect due to the lack of soft-reset
hRandSt0:            db ; $FFFB ; RNG state, topmost byte (output)
hRandSt1:            db ; $FFFC ; "", byte 1
hRandSt2:            db ; $FFFD ; "", byte 2
hRandSt3:            db ; $FFFE ; "", lowest byte