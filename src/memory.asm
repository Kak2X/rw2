SECTION "Main Memory", WRAM0[$C000]
wLvlLayout:            ds $800 ; $C000 ; Level layout
wActLayoutFlags:       ds $100 ; $C800 ; Actor layout - Y position & respawn flag
wActLayoutIds:         ds $100 ; $C900 ; Actor layout - IDs & GFX load request
wLvlBlocks:            ds $100 ; $CA00 ; Table of tile IDs for every 16x16 block
wLvlScrollLocks:       ds $100 ; $CB00 ; Scroll lock table (unpacked)
DEF wLvlLayout_End        EQU wActLayoutFlags
DEF wLvlLayoutDecode_End  EQU wLvlBlocks
wLvlScrollLocksRaw:    ds $19 ; $CC00 ; Scroll lock table (raw, direct copy from ROM)
ds $07
wRoomTrsU:             ds $19 ; $CC20 ; Table of target room IDs when scrolling up, indexed by room ID.
ds $07
wRoomTrsD:             ds $19 ; $CC40 : See above, but when scrolling down.
ds $07
wShot0:                ds $10 ; $CC60 ; Weapon shot #1
wShot1:                ds $10 ; $CC70 ; Weapon shot #2
wShot2:                ds $10 ; $CC80 ; Weapon shot #3
wShot3:                ds $10 ; $CC90 ; Weapon shot #4 (typically used for special purposes)	

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
wTargetRelX:           db ; $CF0D ; Temporary relative X position, for targets
wTargetRelY:           db ; $CF0E ; Temporary relative Y position, for targets
wPlRelRealX:           db ; $CF0F ; Copy of wPlRelX without the hardware's sprite offset
wLvlColPl:             db ; $CF10 ; Current column number the player is on
wPlSprMapId:           db ; $CF11 ; Player sprite mapping ID
wPlDirH:               db ; $CF12 ; Direction the player faces (0: left, 1: right)
wPlWalkAnimTimer:      db ; $CF13 ; Walk animation timer. Player will sidestep until it reaches 7 (purely visual) 
wPlAnimTimer:          db ; $CF14 ; Player animation timer
wPlRelX:               db ; $CF15 ; Player X position, relative to the screen
wPlRelY:               db ; $CF16 ; Player Y position, relative to the screen
wPl_Unk_RelY_Copy:     db ; $CF17 ; ??? Copy of the above
wPlSpdXSub:            db ; $CF18 ; Player horizontal speed (subpixels)
wPlSpdX:               db ; $CF19 ; Player horizontal speed.
wPlSpdYSub:            db ; $CF1A ; Player vertical speed (subpixels)
wPlSpdY:               db ; $CF1B ; Player vertical speed
wPlYCeilMask:          db ; $CF1C ; Mask applied to the player's Y position when hitting the ceiling while jumping. Can be $F0 or $F8 depending on the type of ceiling hit.
wPlMode:               db ; $CF1D ; Player action (PL_MODE_*)
wPl_CF1E_DelayTimer:   db ; $CF1E ; ???
wPlRelYSub:            db ; $CF1F ; Player Y subpixel position, used for a few actions such as climbing
wScrollVDir:           db ; $CF20 ; Vertical scroll direction
wPlBlinkChkDelay:      db ; $CF21 ; Delays the next dice roll to check if the player should blink
wPlShootTimer:         db ; $CF22 ; How long the player sticks the arm out when shooting
wPlShootType:          db ; $CF23 ; Determines the animation frame used when shooting (ie: normal, throw)
wActRjStandLastSlotPtr: db ; $CF24 ; wActRjStandSlotPtr value from the previous frame
ds $01
wColiGround:     db ; $CF26 ; ??? Delays falling when moving off a platform, by shifting
wPlSlideDustTimer:     db ; $CF27 ; Timer for the dust particle after starting a slide.
ds $02
wPlSlideTimer:    db ; $CF2A ; Player slide timer, when it elapses the slide ends
; Parameters to ActS_Spawn for, well, spawning actors
wActSpawnX:             db ; $CF2B ; X Position
wActSpawnY:             db ; $CF2C ; Y Position
wActSpawnId:            db ; $CF2D ; Actor ID
wActSpawnLayoutPtr:     db ; $CF2E ; Actor layout pointer
wActCurSlotPtr:         db ; $CF2F ; Low byte of the pointer to the currently processed actor slot. High byte will be from wAct or wActColi.
wActLastDrawSlotPtr:    db ; $CF30 ; Last actor slot that could be drawn the current frame (only if OAM is filled)
wActScrollX:            db ; $CF31 ; Scroll offset for all actors, to account for the player scrolling the screen
ds 3
wPlSlideDustX:          db ; $CF35 ; Dust particle sprite - X position
wPlSlideDustY:          db ; $CF36 ; Dust particle sprite - Y position
wActStartEndSlotPtr:    db ; $CF37 ; First *AND* last actor slot processed. Stored in the same address since the first slot is at $CD00 and the end at $CE00 (same low byte)
wActCurSprMapRelId:     db ; $CF38 ; Sprite mapping ID offset, relative to the one packed in iActSprMap
wStartTimer:            db ; $CF39 ; Copy of hTimer taken at the start of the gameplay loop. Used at the end of the loop to check for lag frames.
wShutterNum:            db ; $CF3A ; Number of shutters went through. Disables horizontal scrolling, used for boss rooms
wPlColiBlockL:          db ; $CF3B ; Player collision, block ID on the left
wPlColiBlockR:          db ; $CF3C ; Player collision, block ID on the right
wShutterBGPtr_Low:      db ; $CF3D ; Target tilemap pointer when animating the shutter.
wShutterBGPtr_High:     db ; $CF3E
wShutterTimer:          db ; $CF3F ; Generic animation timer for the shutter
wShutterRowsLeft:       db ; $CF40 ; Rows remaining to draw when animating the shutter
wActGfxId:              db ; $CF41 ; Loaded art set for room actors
wPlHurtTimer:           db ; $CF42 ; Player is in the hurt/shock pose until it elapses
wPlInvulnTimer:         db ; $CF43 ; Mercy invincibility timer
wBossIntroHealth:       db ; $CF44 ; Boss health as displayed during the intro, when it fills up. Separate from the real health.
wBossDmgEna:            db ; $CF45 ; Enables the checks associated with damaging a boss damage (updating health bar, triggering explosion, ...)
wHardYShakeOrg:         db ; $CF46 ; Untouched copy of hScrollY taken before Hard Man's screen shake effect starts. Used as the origin and to restore hScrollY.
wHardFistTargetX:       db ; $CF47 ; Target X location for Hard Man's fist attack
wHardFistTargetY:       db ; $CF48 ; Target Y location for Hard Man's fist attack
wShutterMode:           db ; $CF49 ; Boss shutter mode
wActPlatColiSlotPtr:    db ; $CF4A ; Marks the top-solid platform actor the player is standing on
ds 1
wGameTimeSub:           db ; $CF4C ; Gameplay timer (frames)
wGameTime:              db ; $CF4D ; Gameplay timer (seconds)
; Rectangle draw subroutine, used to draw large bosses
w_Unk_RectCpDestPtrLow:  db ; $CF4E ; Rect copy - Tilemap destination pointer
w_Unk_RectCpDestPtrHigh: db ; $CF4F ;
w_Unk_RectCpColsLeft:   db ; $CF50 ; Rect copy - Columns left (inner loop) ??? Inner write loop
w_Unk_RectCpRowsLeft:   db ; $CF51 ; Rect copy - Rows left (outer loop) ??? Outer write loop
wTmpCF52:               db ; $CF52 ; Temporary location for position-related calculations (also final OBJ flags for the current actor's sprite, calculated)
wTmpCF53:               db ; $CF53 ; Temporary location for position-related calculations
wTmpColiBoxH:           db ; $CF54 ; Temporary location to store iActColiBoxH
wTmpColiBoxV:           db ; $CF55 ; Temporary location to store iActColiBoxV
wTmpTileIdUL:           db ; $CF56 ; Temporary location to store the four tile IDs from wLvlBlocks
wTmpTileIdDL:           db ; $CF57
wTmpTileIdUR:           db ; $CF58
wTmpTileIdDR:           db ; $CF59
w_CF5A_TblOffsetByAct:  db ; $CF5A ; ??? Used by one three actors using the same code to distinguish which one it is. Used to index a pointer table.
w_CF5B_TblOffsetSec:    db ; $CF5B ; ??? Indexes the table the returned by the pointer above.
w_CF5C_SpawnTimer:      db ; $CF5C ; ??? Used by an actor to times spawning sub-actors
wActHurtSlotPtr:        db ; $CF5D ; Marks the actor the player got damaged by
wWpnSGUseTimer:         db ; $CF5E ; Timer for Sakugarne's weapon usage
wUnk_Unused_CF5F:       db ; $CF5F 
wLvlEnd:                db ; $CF60 ; Marks how the level ended, either when someone has died (EXPL_*) or an instant stage warp if a stage ID is written to the upper nybble.
wBossHealth:            db ; $CF61 ; Boss health (copied from the boss' iActColiHealth, to later update wBossHealthBar)
wTmpColiActId:          db ; $CF62 ; Temporary location to store the actor ID during shot-actor collision checks.
wExplodeOrgX:           db ; $CF63 ; X Origin of player/boss explosions
wExplodeOrgY:           db ; $CF64 ; Y Origin of player/boss explosions
wPlWarpSprMapRelId:     db ; $CF65 ; Relative sprite mapping ID used during the teleport animation
wStageSelCursor:        db ; $CF66 ; Cursor location on the stage select
wPlSprFlags:            db ; $CF67 ; OBJ flags for the player
wPlRmSpdYSub:           db ; $CF68 ; Rush Marine Y speed, calculated from wPlRmSpdU & wPlRmSpdD 
wPlRmSpdY:              db ; $CF69 ; ( ??? for some reason, there's no X equivalent)
wActHelperColiSlotPtr:  db ; $CF6A ; Marks the helper item (Rush/Sakugarne) the player has collided with
wActRjStandSlotPtr:     db ; $CF6B ; Marks the Rush Jet actor slot the player is standing on
wWpnSGRide:             db ; $CF6C ; Sakugarne ride controls enabled
wActUnk_CF6D_TimerInit: db ; $CF6D ; ??? An actor gets its timer initialized to this value
wGameOverSel:           db ; $CF6E ; Selected action on the game over screen
wLvlWater:              db ; $CF6F ; The level has water
wStatusBarRedraw:       db ; $CF70 ; Marks which parts of the status bar should be redrawn
wPlHealthBar:           db ; $CF71 ; Player health (as displayed in the bar, out of BAR_MAX)
wWpnAmmoBar:            db ; $CF72 ; Weapon ammo (as displayed in the bar, out of BAR_MAX)
wBossHealthBar:         db ; $CF73 ; Boss health (as displayed in the bar, out of BAR_MAX)
wPlLivesView:           db ; $CF74 ; Lives remaining (status bar value)
wPlRmSpdL:              db ; $CF75 ; Rush Marine speed/momentum - left 
wPlRmSpdR:              db ; $CF76 ; Rush Marine speed/momentum - right 
wPlRmSpdU:              db ; $CF77 ; Rush Marine speed/momentum - up 
wPlRmSpdD:              db ; $CF78 ; Rush Marine speed/momentum - down 
wUnk_CF79_FlipTimer:    db ; $CF79 ; Times the flip for ???
wLvlWarpDest:           db ; $CF7A ; Selected teleport destination in Wily's Castle (same format as wLvlEnd)
wGetWpnDestPtr_Low:     db ; $CF7B ; Tilemap pointer to the current row in the Get Weapon screen, keeps track of where to write text
wGetWpnDestPtr_High:    db ; $CF7C ; ""
wPlColiBoxV:            db ; $CF7D ; Player collision box, vertical radius
wPlCenterY:             db ; $CF7E ; Vertical center of the player's collision box. (the "logical" origin)
wPlRespawn:             db ; $CF7F ; If set, the level is being reloaded after the player has died.
ds $10
wStageSelStarfieldPos:  ds $30 ; $CF90 ; Table of coordinates for each star
wPassSelTbl:            ds $10 ; $CFC0 ; Dots placed on the password screen ($00 or $FF)
; Ammo for...
wPlHealth:              db ; $CFD0 ; Player's health ("Ammo for P")
DEF wWpnAmmoTbl EQU wPlHealth
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
DEF wPassSelTbl_End EQU wPlHealth
DEF wWpnAmmo_Start EQU wWpnAmmoRC
DEF wWpnAmmo_End   EQU wWpnAmmoSG + 1
wWpnUnlock1:            db ; $CFDD ; Automatic weapon unlocks
wWpnUnlock0:            db ; $CFDE ; Unlocked weapons / beaten stages (bitmask)
wWpnId:                 db ; $CFDF ; Current weapon
wWpnAmmoCur:            db ; $CFE0 ; Active weapon ammo
wBarQueuePos:           db ; $CFE1 ; Index to current wTilemapBarBuf write position
wTmpCFE2:               db ; $CFE2 ; Temporary location (copy of wWpnAmmoCur, password error marker) 
wPlIdleDelay:           db ; $CFE3 ; If set, the player returns to the idle state when it elapses. Used by Hard Knuckle.
wWpnNePos:              db ; $CFE4 ; Timer used to alternate the vertical position of Needle Cannon shots
wWpnWdUseAmmoOnThrow:   db ; $CFE5 ; Makes the Wood Shield use up ammo when fired. Not sure why it's a flag.
wTmpCFE6:               db ; $CFE6 ; Temporary storage
wTmpCFE7:               db ; $CFE7 ; Temporary storage
wPlLives:               db ; $CFE8 ; Number of lives remaining
wETanks:                db ; $CFE9 ; Number of E Tanks
wWpnTpActive:           db ; $CFEA ; The player is spinning in the air, actively using Top Spin
wWpnUnlockMask:         db ; $CFEB ; [TCRF] Masks the bit for the current weapon against wWpnUnlock0. Only written to though.
wWpnColiBoxH:           db ; $CFEC ; Weapon collision box - horizontal radius
wWpnColiBoxV:           db ; $CFED ; Weapon collision box - vertical radius
wWpnActDmg:             db ; $CFEE ; Damage the current weapon dealt to the actor
wWpnPierceLvl:          db ; $CFEF ; "Piercing level" of the current weapon (WPNPIERCE_*)
wWpnShotCost:           db ; $CFF0 ; Ammo cost of the currently fired shot
wWpnHelperActive:       db ; $CFF1 ; Rush/Sakugarne actors are active
wWpnAmmoInc:            db ; $CFF2 ; Slowly increments the weapon ammo until it elapses. (weapon energy effect)
wPlHealthInc:           db ; $CFF3 ; Slowly increments the player's health until it elapses. (life energy effect)
wPassCursorX:           db ; $CFF4 ; Password cursor - X position
wPassCursorY:           db ; $CFF5 ; Password cursor - Y position

SECTION "DC00", WRAM0[$DC00]
wActDespawnTbl:         ds $100 ; $DC00 ; Backup "nospawn" table for each of the wActLayoutFlags entries
DEF wActDespawnTbl_End EQU wActDespawnTbl + $100

SECTION "DD00", WRAM0[$DD00]
; Multipurpose scratch buffer for screen transfers
UNION
; TODO: Check for improper labels to this after all's done
wScrEvRows:            ds $40 ; $DD00 ; Tile IDs when vertical scrolling
NEXTU
wTilemapBuf:           ds $100 ; $DD00 ; TilemapDef tilemap buffer (Generic)
wTilemapBarBuf:        ds $100 ; $DE00 ; TilemapDef tilemap buffer (Status bar)
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
DEF hShotCur EQU hActCur ; Reused!
hScrEvLvlLayoutPtr_Low:  db ; $FFB0 ; Source level layout pointer
hScrEvLvlLayoutPtr_High: db ; $FFB1 ; 
hScrEvOffH:              db ; $FFB2 ; Target horizontal offset in grid
hScrEvOffV:              db ; $FFB3 ; Target vertical offset in grid
hScrEvVDestPtr_Low:      db ; $FFB4
hScrEvVDestPtr_High:     db ; $FFB5
hBGPAnim0:               db ; $FFB6 ; BG palette animation, 1st palette
hBGPAnim1:               db ; $FFB7 ; BG palette animation, 2nd palette

SECTION "FFF0", HRAM[$FFF0]
ds 5
hBGP:                db ; $FFF5 ; BG palette
hOBP0:               db ; $FFF6 ; OBJ0 palette
hOBP1:               db ; $FFF7 ; OBJ1 palette
ds 1
hCheatMode:        db ; $FFF9 ; [TCRF] Full invulnerability. Shots pass through & pits act like bouncy surfaces.

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
DEF iActSprMap        EQU $02 ; Sprite mapping ID + direction flags + animation timer
DEF iActLayoutPtr     EQU $03 ; Actor layout pointer
DEF iActXSub          EQU $04 ; X subpixel position
DEF iActX             EQU $05 ; X position
DEF iActYSub          EQU $06 ; Y subpixel position
DEF iActY             EQU $07 ; Y position
DEF iActSpdXSub       EQU $08 ; Horizontal speed (subpixels)
DEF iActSpdX          EQU $09 ; Horizontal speed
DEF iActSpdYSub       EQU $0A ; Vertical speed (subpixels)
DEF iActSpdY          EQU $0B ; Vertical speed
DEF iActTimer0C       EQU $0C ; Actor-specific
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

; See ActS_InitCirclePath
DEF iArcIdDir = iAct0D
DEF iArcIdX = iAct0E
DEF iArcIdY = iAct0F

; wActColi
DEF iActColiBoxH EQU $00 ; Collision box, horizontal radius
DEF iActColiBoxV EQU $01 ; Collision box, vertical radius (still half width, but the origin is at the bottom of the sprite)
DEF iActColiType EQU $02 ; Collision type (ACTCOLI_*)
DEF iActColiDamage EQU $03 ; Damage dealt (ACTCOLI_ENEMYPASS, ACTCOLI_ENEMYHIT, ACTCOLI_ENEMYREFLECT)
DEF iActColiSubtype EQU $03 ; Subtype (ACTCOLI_PLATFORM)
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

; ActS_ColiTbl
DEF iRomActColiBoxH       EQU $00
DEF iRomActColiBoxV       EQU $01
DEF iRomActColiType       EQU $02
DEF iRomActColiDamage     EQU $03
DEF iRomActColiHealthLow  EQU $04
DEF iRomActColiHealthHigh EQU $05
DEF iRomActColiDmgP       EQU $06
DEF iRomActColiDmgTp      EQU $07
DEF iRomActColiDmgAr      EQU $08
DEF iRomActColiDmgWd      EQU $09
DEF iRomActColiDmgMe      EQU $0A
DEF iRomActColiDmgCr      EQU $0B
DEF iRomActColiDmgNe      EQU $0C
DEF iRomActColiDmgHa      EQU $0D
DEF iRomActColiDmgMg      EQU $0E
DEF iRomActColiDmgSg      EQU $0F

; wShot
DEF iShotId      EQU $00 ; Weapon shot ID
DEF iShotWkTimer EQU $01 ; Timer, shot-specific
DEF iShotDir     EQU $02 ; Shot direction
DEF iShotFlags   EQU $03 ; Flags. In practice, there's only the deflected one.
DEF iShotXSub    EQU $04 ; Horizontal speed (subpixels)
DEF iShotX       EQU $05 ; Horizontal speed
DEF iShotYSub    EQU $06 ; Vertical speed (subpixels)
DEF iShotY       EQU $07 ; Vertical speed
DEF iShotSprId   EQU $08 ; Sprite mapping ID
DEF iShot9       EQU $09 ; Free space, not used
DEF iShotA       EQU $0A ; Free space, not used
DEF iShotB       EQU $0B ; Free space, not used
DEF iShotC       EQU $0C ; Free space, not used
DEF iShotD       EQU $0D ; Unused
DEF iShotE       EQU $0E ; Unused
DEF iShotF       EQU $0F ; Unused
DEF iShotEnd     EQU $10

DEF iShotTpAnimTimer EQU iShotWkTimer ; Animation timer
DEF iShotArNum       EQU iShotWkTimer ; Shot number, out of 3
DEF iShotWdAnim      EQU iShotWkTimer ; Animation timer & flags
                                      ; RT--CCNN (intro)
							          ; RTAAAAAA (main)
							          ; R - Rotation flag
							          ;     If set, the initial intro where the four leaves move outwards is done.
							          ; T - Throw flag
							          ;     If set, the shield has been thrown
							          ; N - Leaf number
							          ;     Identifies the movement code it uses.
							          ; C - Intro animation counter
							          ; A - Shield rotation timer (position index)
DEF iShotMeAnimTimer EQU iShotWkTimer ; Animation number
DEF iShotCrTimer     EQU iShotWkTimer ; Explosion timer
DEF iShotNeTimer     EQU iShotWkTimer ; How many frames have passed since the shot spawned
DEF iShotHaTimer     EQU iShotWkTimer ; How many frames have passed since the shot spawned (up to $10)
DEF iShotMgMoveV     EQU iShotWkTimer ; If set, Magnet Missile is moving vertically (has locked in)