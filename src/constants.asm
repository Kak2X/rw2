; Keys (as bit numbers)
DEF KEYB_A           EQU 0
DEF KEYB_B           EQU 1
DEF KEYB_SELECT      EQU 2
DEF KEYB_START       EQU 3
DEF KEYB_RIGHT       EQU 4
DEF KEYB_LEFT        EQU 5
DEF KEYB_UP          EQU 6
DEF KEYB_DOWN        EQU 7

; Keys (values)
DEF KEY_NONE         EQU 0
DEF KEY_A            EQU 1 << KEYB_A
DEF KEY_B            EQU 1 << KEYB_B
DEF KEY_SELECT       EQU 1 << KEYB_SELECT
DEF KEY_START        EQU 1 << KEYB_START
DEF KEY_RIGHT        EQU 1 << KEYB_RIGHT
DEF KEY_LEFT         EQU 1 << KEYB_LEFT
DEF KEY_UP           EQU 1 << KEYB_UP
DEF KEY_DOWN         EQU 1 << KEYB_DOWN


DEF GFXSET_TITLE       EQU $00 ; Title Screen
DEF GFXSET_STAGESEL    EQU $01 ; Stage Select
DEF GFXSET_PASSWORD    EQU $02 ; Password screen
DEF GFXSET_LEVEL       EQU $03 ; Level
DEF GFXSET_GETWPN      EQU $04 ; Get Weapon screen
DEF GFXSET_CASTLE      EQU $05 ; Wily Castle cutscene
DEF GFXSET_STATION     EQU $06 ; Wily Station cutscene
DEF GFXSET_GAMEOVER    EQU $07 ; Generic font (Game Over screen)
DEF GFXSET_SPACE       EQU $08 ; Space cutscenes (Wily Station, Ending)

DEF ACTGFX_PLAYER    EQU $00
DEF ACTGFX_SPACE1    EQU $01
DEF ACTGFX_02        EQU $02
DEF ACTGFX_03        EQU $03
DEF ACTGFX_04        EQU $04
DEF ACTGFX_05        EQU $05
DEF ACTGFX_MAGNETMAN EQU $06
DEF ACTGFX_07        EQU $07
DEF ACTGFX_NEEDLEMAN EQU $08
DEF ACTGFX_09        EQU $09
DEF ACTGFX_CRASHMAN  EQU $0A
DEF ACTGFX_0B        EQU $0B
DEF ACTGFX_METALMAN  EQU $0C
DEF ACTGFX_0D        EQU $0D
DEF ACTGFX_WOODMAN   EQU $0E
DEF ACTGFX_0F        EQU $0F
DEF ACTGFX_AIRMAN    EQU $10
DEF ACTGFX_11        EQU $11
DEF ACTGFX_12        EQU $12
DEF ACTGFX_13        EQU $13
DEF ACTGFX_HARDMAN   EQU $14
DEF ACTGFX_TOPMAN    EQU $15

DEF LVL_HARD           EQU $00
DEF LVL_TOP            EQU $01
DEF LVL_MAGNET         EQU $02
DEF LVL_NEEDLE         EQU $03
DEF LVL_CRASH          EQU $04
DEF LVL_METAL          EQU $05
DEF LVL_WOOD           EQU $06
DEF LVL_AIR            EQU $07
DEF LVL_CASTLE         EQU $08
DEF LVL_STATION        EQU $09

; wWpnUnlock0
DEF WPNB_TP EQU 0
DEF WPNB_AR EQU 1
DEF WPNB_WD EQU 2
DEF WPNB_ME EQU 3
DEF WPNB_CR EQU 4
DEF WPNB_NE EQU 5
DEF WPNB_HA EQU 6
DEF WPNB_MG EQU 7

DEF WPN_TP EQU 1 << WPNB_TP
DEF WPN_AR EQU 1 << WPNB_AR
DEF WPN_WD EQU 1 << WPNB_WD
DEF WPN_ME EQU 1 << WPNB_ME
DEF WPN_CR EQU 1 << WPNB_CR
DEF WPN_NE EQU 1 << WPNB_NE
DEF WPN_HA EQU 1 << WPNB_HA
DEF WPN_MG EQU 1 << WPNB_MG

; wWpnUnlock1
DEF WPNB_RC EQU 0
DEF WPNB_RM EQU 1
DEF WPNB_RJ EQU 2
DEF WPNB_SG EQU 3

DEF WPN_RC EQU 1 << WPNB_RC
DEF WPN_RM EQU 1 << WPNB_RM
DEF WPN_RJ EQU 1 << WPNB_RJ
DEF WPN_SG EQU 1 << WPNB_SG

; wWpnSel
DEF WPNSEL_P  EQU $00
DEF WPNSEL_RC EQU $01
DEF WPNSEL_RM EQU $02
DEF WPNSEL_RJ EQU $03
DEF WPNSEL_TP EQU $04
DEF WPNSEL_AR EQU $05
DEF WPNSEL_WD EQU $06
DEF WPNSEL_ME EQU $07
DEF WPNSEL_CR EQU $08
DEF WPNSEL_NE EQU $09
DEF WPNSEL_HA EQU $0A
DEF WPNSEL_MG EQU $0B
DEF WPNSEL_SG EQU $0C
DEF WPNSEL_EN EQU $0D

DEF SECT_DISABLE     EQU $FF ; Magic value to disable the WINDOW layer and LYC trigger

DEF SCREVB_SCROLLV   EQU 7 ; Vertical scrolling
DEF SCREV_SCROLLV    EQU 1 << SCREVB_SCROLLV

DEF SCROLLV_UP       EQU 0
DEF SCROLLV_DOWN     EQU 1

; TilemapDef tilemap writing flags
DEF BGB_REPEAT       EQU 6
DEF BGB_MVDOWN       EQU 7
DEF BG_NOREPEAT      EQU $00
DEF BG_REPEAT        EQU 1 << BGB_REPEAT
DEF BG_MVRIGHT       EQU $00
DEF BG_MVDOWN        EQU 1 << BGB_MVDOWN

; wShutterEvMode
DEF SHUTTER_NONE     EQU $00
DEF SHUTTER_OPEN     EQU $01
DEF SHUTTER_CLOSE    EQU $02

DEF BLOCK_TILECOUNT_H    EQU $02 ; Number of 8x8 tiles in a block, horizontally
DEF BLOCK_TILECOUNT_V    EQU $02 ; Number of 8x8 tiles in a block, vertically
DEF BLOCK_H EQU BLOCK_TILECOUNT_H * TILE_H ; $10
DEF BLOCK_V EQU BLOCK_TILECOUNT_V * TILE_V ; $10

DEF SCREEN_GAME_BLOCKCOUNT_H EQU $0A ; Number of blocks horizontally in the game screen
DEF SCREEN_GAME_BLOCKCOUNT_V EQU $08 ; Number of blocks vertically in the game screen
DEF SCREEN_GAME_H          EQU SCREEN_GAME_BLOCKCOUNT_H * BLOCK_TILECOUNT_H * TILE_H ; $A0 ; Width, in pixels, of the gameplay screen
DEF SCREEN_GAME_V          EQU SCREEN_GAME_BLOCKCOUNT_V * BLOCK_TILECOUNT_V * TILE_V ; $80 ; Height, in pixels, of the gameplay screen


DEF LVLSCROLLV_BLOCKCOUNT  EQU $0C ; Number of blocks drawn when scrolling vertically
;DEF LVLSCROLLH_EDGECOL     EQU $02 ; Location of the seam column when scrolling horizontally
;                                   ; relative to both the left and right edges of the screen. 
;                                   ; (2 cols to the left of the left edge, 2 cols to the right of the right edge)

; Rooms
DEF COL_TILECOUNT_H  EQU $02 ; Number of tiles horizontally in a column
DEF ROOM_COLCOUNT    EQU $0A ; Number of columns in a room
DEF LVL_ROOMCOUNT    EQU $19 ; Max number of rooms in a level

DEF COL_PX_H         EQU COL_TILECOUNT_H * TILE_H ; $10 ; Width of a column, in pixels

DEF TILEID_SHUTTER_L EQU $78
DEF TILEID_SHUTTER_R EQU $79

; Gameplay
DEF BAR_MAX EQU $98 ; 152
DEF BARID_PL   EQU 0 ; Player health
DEF BARID_WPN  EQU 1 ; Weapon ammo
DEF BARID_BOSS EQU 2 ; Boss health
DEF BARID_LIVES EQU 3 ; Player lives (special)



DEF BLOCKID_EMPTY_START EQU $00 ; Empty blocks ($00-$21)
DEF BLOCKID_SOLID_START EQU $22 ; Solid blocks ($22-$3B)
DEF BLOCKID_HALF_START  EQU $3C ; Small platforms ($3C-$3F)

DEF BLOCKID_WATER      EQU $10 ; Underwater block
DEF BLOCKID_WATERSPIKE EQU $18 ; Underwater spike
DEF BLOCKID_SPIKE      EQU $19 ; Spike


DEF PLCOLI_V EQU $06 ; Player collision box, vertical radius

; wPlMode
DEF PL_MODE_GROUND        EQU $00 ; On the ground
DEF PL_MODE_JUMP          EQU $01 ; Jumping (move up)
DEF PL_MODE_JUMPABSORB    EQU $02 ; Fast jump before absorbing the weapon
DEF PL_MODE_FALL          EQU $03 ; Falling (move down)
DEF PL_MODE_CLIMB         EQU $04 ; Climbing
DEF PL_MODE_CLIMBININIT   EQU $05 ; Init for...
DEF PL_MODE_CLIMBIN       EQU $06 ; Climbed down from top of the ladder while standing
DEF PL_MODE_CLIMBOUTINIT  EQU $07 ; Init for...
DEF PL_MODE_CLIMBOUT      EQU $08 ; Climbed to the top of a ladder
DEF PL_MODE_CLIMBDTRSINIT EQU $09 ; Init for...
DEF PL_MODE_CLIMBDTRS     EQU $0A ; Downwards screen transition - climbing down
DEF PL_MODE_CLIMBUTRSINIT EQU $0B ; Init for...
DEF PL_MODE_CLIMBUTRS     EQU $0C ; Upwards screen transition - climbing up
DEF PL_MODE_FALLTRSINIT   EQU $0D ; Init for...
DEF PL_MODE_FALLTRS       EQU $0E ; Downwards screen transition - falling
DEF PL_MODE_NOCTRL        EQU $0F ; Controls disabled (for the boss room) 
DEF PL_MODE_SLIDE         EQU $10 ; Sliding
DEF PL_MODE_RM            EQU $11 ; Inside Rush Marine
DEF PL_MODE_WARPININIT    EQU $12 ; Init for...
DEF PL_MODE_WARPINMOVE    EQU $13 ; Teleporting Down - Moving
DEF PL_MODE_WARPINLAND    EQU $14 ; Teleporting Down - Ground animation
DEF PL_MODE_WARPOUTINIT   EQU $15 ; Init for...
DEF PL_MODE_WARPOUTANIM   EQU $16 ; Teleporting Up - Ground animation
DEF PL_MODE_WARPOUTMOVE   EQU $17 ; Teleporting Up - Moving
DEF PL_MODE_WARPOUTEND    EQU $18 ; Teleporting Up - Wait for level end
DEF PL_MODE_TLPINIT       EQU $19 ; Init for...
DEF PL_MODE_TLP           EQU $1A ; Wily Teleporter - Anim
DEF PL_MODE_TLPEND        EQU $1B ; Wily Teleporter - Wait for level end

DEF ACT_EXPLPART   EQU $07 ; Large explosion particle
DEF ACT_BOSS_START EQU $68
DEF ACT_HARDMAN    EQU $68
DEF ACT_TOPMAN     EQU $69
DEF ACT_MAGNETMAN  EQU $6A
DEF ACT_NEEDLEMAN  EQU $6B
DEF ACT_CRASHMAN   EQU $6C
DEF ACT_METALMAN   EQU $6D
DEF ACT_WOODMAN    EQU $6E
DEF ACT_AIRMAN     EQU $6F

DEF ACT_BUBBLE EQU $64 ; Air bubble when the player is underwater
DEF ACT_E0 EQU $E0 ; Rush Coil ?
DEF ACT_E1 EQU $E1 ; Rush Marine ?
DEF ACT_E2 EQU $E2 ; Rush Jet ?
DEF ACT_WPN_SG EQU $E3 ; Sakugarne
DEF ACT_E4 EQU $E4

; wWpnHelperWarp
DEF AHW_MODE_0 EQU $00
DEF AHW_MODE_1 EQU $01
DEF AHW_MODE_2 EQU $02
DEF AHW_MODE_3 EQU $03
DEF AHW_MODE_4 EQU $04
DEF AHW_MODE_5 EQU $05
DEF AHW_WARPOUT_START EQU $06
DEF AHW_MODE_7 EQU $07
DEF AHW_MODE_8 EQU $08


; wLvlEnd
DEF EXPL_NONE EQU $00 ; Nothing
DEF EXPL_PL   EQU $01 ; Player explodes (restart level)
DEF EXPL_BOSS EQU $02 ; Boss explodes (won level)


DEF ACTLB_SPAWNNORM   EQU 4 ; Spawn the actor normally
DEF ACTLB_SPAWNBEHIND EQU 5 ; Spawn the actor from behind
DEF ACTLB_NOSPAWN     EQU 7 ; Prevents the actor from being respawned
DEF ACTL_NOSPAWN      EQU 1 << ACTLB_NOSPAWN

DEF ACTB_UNK_PROCFLAG EQU 7
DEF ACT_UNK_PROCFLAG EQU 1 << ACTB_UNK_PROCFLAG

; iActSprMap directional flags
DEF ACTDIRB_D EQU 6
DEF ACTDIRB_R EQU 7
DEF ACTDIR_U EQU $00
DEF ACTDIR_D EQU 1 << ACTDIRB_D
DEF ACTDIR_L EQU $00
DEF ACTDIR_R EQU 1 << ACTDIRB_R

; iActColiType
DEF ACTCOLI_0 EQU 0

; iArcIdDir index directions
DEF ADRB_DEC_IDY EQU 0 ; If set, the horizontal path index will decrease
DEF ADRB_DEC_IDX EQU 1 ; If set, the vertical path index will decrease
DEF ADR_INC_IDY EQU $00
DEF ADR_DEC_IDY EQU 1 << ADRB_DEC_IDY
DEF ADR_INC_IDX EQU $00
DEF ADR_DEC_IDX EQU 1 << ADRB_DEC_IDX


DEF WPNPIERCE_NONE    EQU 0 ; Weapon always disappears on contact
DEF WPNPIERCE_LASTHIT EQU 1 ; Weapon pierces only if it defeats the enemy
DEF WPNPIERCE_ALWAYS  EQU 2 ; Weapon always pierces

DEF ARC_MAX EQU 88

; Password dot locations
DEF iDotA1 EQU $00
DEF iDotA2 EQU $01
DEF iDotA3 EQU $02
DEF iDotA4 EQU $03
DEF iDotB1 EQU $04
DEF iDotB2 EQU $05
DEF iDotB3 EQU $06
DEF iDotB4 EQU $07
DEF iDotC1 EQU $08
DEF iDotC2 EQU $09
DEF iDotC3 EQU $0A
DEF iDotC4 EQU $0B
DEF iDotD1 EQU $0C
DEF iDotD2 EQU $0D
DEF iDotD3 EQU $0E
DEF iDotD4 EQU $0F

; Pause bar bullshit
DEF iPBar_Ptr EQU $00
DEF iPBar_Tiles EQU $02


; Sound driver
DEF SND_MUTE              EQU $00

DEF BGM_TITLE             EQU $01
DEF BGM_STAGESELECT       EQU $02
DEF BGM_STAGESTART        EQU $03
DEF BGM_PASSWORD          EQU $04
DEF BGM_BOSS              EQU $05
DEF BGM_STAGECLEAR        EQU $06
DEF BGM_WEAPONGET         EQU $07
DEF BGM_CRASHMAN          EQU $08
DEF BGM_AIRMAN            EQU $09
DEF BGM_METALMAN          EQU $0A
DEF BGM_HARDMAN           EQU $0B
DEF BGM_WOODMAN           EQU $0C
DEF BGM_TOPMAN            EQU $0D
DEF BGM_MAGNETMAN         EQU $0E
DEF BGM_NEEDLEMAN         EQU $0F
DEF BGM_WILYINTRO         EQU $10
DEF BGM_WILYCASTLE        EQU $11
DEF BGM_ENDING            EQU $12
DEF BGM_UNUSEDENDING      EQU $13

DEF SFX_LAND              EQU $01
DEF SFX_SHOOT             EQU $02
DEF SFX_ENEMYHIT          EQU $03
DEF SFX_ENEMYDEAD         EQU $04
DEF SFX_DEFLECT           EQU $05
DEF SFX_EXPLODE           EQU $06
DEF SFX_BAR               EQU $07
DEF SFX_ETANK             EQU $08
DEF SFX_1UP               EQU $09
DEF SFX_SHUTTER           EQU $0A
DEF SFX_BOSSBAR           EQU $0B
DEF SFX_TELEPORTIN        EQU $0C
DEF SFX_TELEPORTOUT       EQU $0D
DEF SFX_FREEZETOGGLE      EQU $0E
DEF SFX_WEAPONABSORB      EQU $0F
DEF SFX_BLOCK             EQU $10
DEF SFX_UFOCRASH          EQU $11
DEF SFX_CURSORMOVE        EQU $12
DEF SFX_DAMAGED           EQU $13
DEF SFX_UNKNOWN2          EQU $14