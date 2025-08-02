SECTION "Main Memory", WRAM0[$C000]
wLvlLayout:            ds $800 ; $C000 ; Level layout
wLvlUnkTblC800:        ds $100 ; $C800 ; Actor layout ??? and/or respawn table
wLvlGFXReqTbl:         ds $100 ; $C900 ; GFX load request table for each column in the level
wLvlBlocks:            ds $100 ; $CA00 ; Table of tile IDs for every 16x16 block

DEF wLvlLayout_End     EQU wLvlUnkTblC800

SECTION "CC00", WRAM0[$CC00]
ds $20
wRoomTrsU:             ds $20 ; $CC20 ; Table of target room IDs when scrolling up, indexed by room ID.
wRoomTrsD:             ds $20 ; $CC40 : See above, but when scrolling down.

SECTION "CD00", WRAM0[$CD00]
wAct:                  ds $100 ; $CD00 ; Currently loaded actors
wActColi:              ds $100 ; $CE00 ; Respective collision data for currently loaded actors
DEF wAct_End EQU wActColi + $100

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

SECTION "CF2B", WRAM0[$CF2B]
; Parameters to ActS_Spawn for, well, spawning actors
wActSpawnX:       db ; $CF2B ; X Position
wActSpawnY:       db ; $CF2C ; Y Position
wActSpawnId:      db ; $CF2D ; Actor ID
wActSpawnByte3:   db ; $CF2E ; ???
wActCurSlotPtr:   db ; $CF2F ; Low byte of the pointer to the currently processed actor slot. High byte will be from wAct or wActColi.
wActOAMFull:      db ; $CF30 ; Marks if the OAM was filled

SECTION "CF37", WRAM0[$CF37]
wActNoProc:             db ; $CF37 ; ??? Disables actor processing
wActCurSprMapRelId:     db ; $CF38 ; Sprite mapping ID offset, relative to the one packed in iActSprMap
SECTION "CF3D", WRAM0[$CF3D]
wShutterBGPtr_Low:      db ; $CF3D ; Target tilemap pointer when animating the shutter.
wShutterBGPtr_High:     db ; $CF3E
ds 2
wActGfxId:              db ; $CF41 ; Loaded art set for room actors

SECTION "CF52", WRAM0[$CF52]
wActCurSprFlagsRes:     db ; $CF52 ; Final OBJ flags for the current actor's sprite, calculated

SECTION "CF56", WRAM0[$CF56]
wTmpTileIdUL:           db ; $CF56 ; Temporary location to store the four tile IDs from wLvlBlocks
wTmpTileIdDL:           db ; $CF57
wTmpTileIdUR:           db ; $CF58
wTmpTileIdDR:           db ; $CF59

SECTION "CF66", WRAM0[$CF66]
wStageSelCursor:        db ; $CF66 ; Cursor location on the stage select
wActCurSprFlags:        db ; $CF67 ; OBJ flags for the current actor

SECTION "CF90", WRAM0[$CF90]
wStageSelStarfieldPos:  ds $30 ; $CF90 ; Table of coordinates for each star
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
; TODO: Check for improper labels to this after all's done
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
DEF wStageSelCursorULObj EQU wWorkOAM + (OBJ_SIZE * 0)
DEF wStageSelCursorDLObj EQU wWorkOAM + (OBJ_SIZE * 1)
DEF wStageSelCursorURObj EQU wWorkOAM + (OBJ_SIZE * 2)
DEF wStageSelCursorDRObj EQU wWorkOAM + (OBJ_SIZE * 3)

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
hRomBankLast:            db ; $FF9D ; Last ROM bank loaded (Bank to restore when done with hRomBank)
hRomBank:                db ; $FF9E ; Current ROM bank loaded
hTrsRowsProc:            db ; $FF9F ; Number of block rows processed during vertical transitions
hActCur:                 ds $10 ; $FFA0 ; Currently processed actor, copied from the actor slot
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

;
; STRUCTS
;

; wTilemapBuf
DEF iTilemapDefPtr_High EQU $00
DEF iTilemapDefPtr_Low  EQU $01
DEF iTilemapDefOpt      EQU $02
DEF iTilemapDefPayload  EQU $03

; wAct
DEF iActId            EQU $00 ; Actor ID. Must be a multiple of two. If zero, the slot is free.
DEF iActRtnId         EQU $01 ; Routine ID, actor-specific
DEF iActSprMap        EQU $02 ; Sprite mapping ID + direction flags
DEF iAct_Unk_UnkTblPtr            EQU $03 ; ???
DEF iActXSub          EQU $04 ; X subpixel position
DEF iActX             EQU $05 ; X position
DEF iActYSub          EQU $06 ; Y subpixel position
DEF iActY             EQU $07 ; Y position
DEF iActSpdXSub       EQU $08 ; Horizontal speed (subpixels)
DEF iActSpdX          EQU $09 ; Horizontal speed
DEF iActSpdYSub       EQU $0A ; Vertical speed (subpixels)
DEF iActSpdY          EQU $0B ; Vertical speed
DEF iActTimer0C            EQU $0C ; Actor-specific
DEF iAct0D            EQU $0D ; Actor-specific
DEF iAct0E            EQU $0E ; Actor-specific
DEF iAct0F            EQU $0F ; Actor-specific
DEF iActEnd EQU $10

; Actor-specific fields

; see Act_Boss_InitIntro
DEF iBossIntroTimer EQU iActTimer0C
DEF iBossIntroSprMap0 EQU iAct0D
DEF iBossIntroSprMap1 EQU iAct0E
DEF iBossIntroFrameLen EQU iAct0F

; wActColi
DEF iActColiBoxH EQU $00 ; Collision box width
DEF iActColiBoxV EQU $01 ; Collision box height
DEF iActColiType EQU $02 ; Collision type
DEF iActColiDamage EQU $03 ; Damage dealt
DEF iActColiHealth EQU $04 ; Health (if <= $10, the actor is defeated)
DEF iActColiInvulnTimer EQU $05 ; Invulnerability time
DEF iActColi6 EQU $06
DEF iActColi7 EQU $07
DEF iActColi8 EQU $08
DEF iActColi9 EQU $09
DEF iActColiA EQU $0A
DEF iActColiB EQU $0B
DEF iActColiC EQU $0C
DEF iActColiD EQU $0D
DEF iActColiE EQU $0E
DEF iActColiF EQU $0F
DEF iActColiEnd EQU $10
