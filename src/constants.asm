; Keys (as bit numbers)
DEF KEYB_A                   EQU 0
DEF KEYB_B                   EQU 1
DEF KEYB_SELECT              EQU 2
DEF KEYB_START               EQU 3
DEF KEYB_RIGHT               EQU 4
DEF KEYB_LEFT                EQU 5
DEF KEYB_UP                  EQU 6
DEF KEYB_DOWN                EQU 7

; Keys (values)
DEF KEY_NONE                 EQU 0
DEF KEY_A                    EQU 1 << KEYB_A
DEF KEY_B                    EQU 1 << KEYB_B
DEF KEY_SELECT               EQU 1 << KEYB_SELECT
DEF KEY_START                EQU 1 << KEYB_START
DEF KEY_RIGHT                EQU 1 << KEYB_RIGHT
DEF KEY_LEFT                 EQU 1 << KEYB_LEFT
DEF KEY_UP                   EQU 1 << KEYB_UP
DEF KEY_DOWN                 EQU 1 << KEYB_DOWN

DEF GFXSET_TITLE             EQU $00 ; Title Screen
DEF GFXSET_STAGESEL          EQU $01 ; Stage Select
DEF GFXSET_PASSWORD          EQU $02 ; Password screen
DEF GFXSET_LEVEL             EQU $03 ; Level
DEF GFXSET_GETWPN            EQU $04 ; Get Weapon screen
DEF GFXSET_CASTLE            EQU $05 ; Wily Castle cutscene
DEF GFXSET_STATION           EQU $06 ; Wily Station cutscene
DEF GFXSET_GAMEOVER          EQU $07 ; Generic font (Game Over screen)
DEF GFXSET_SPACE             EQU $08 ; Space cutscenes (Wily Station, Ending)

DEF ACTGFX_PLAYER            EQU $00
DEF ACTGFX_SPACE1            EQU $01
DEF ACTGFX_LVLHARD           EQU $02
DEF ACTGFX_BIKKY             EQU $03
DEF ACTGFX_LVLTOP            EQU $04
DEF ACTGFX_LVLMAGNET         EQU $05
DEF ACTGFX_MAGNETMAN         EQU $06
DEF ACTGFX_LVLNEEDLE         EQU $07
DEF ACTGFX_NEEDLEMAN         EQU $08
DEF ACTGFX_LVLCRASH          EQU $09
DEF ACTGFX_CRASHMAN          EQU $0A
DEF ACTGFX_LVLMETAL          EQU $0B
DEF ACTGFX_METALMAN          EQU $0C
DEF ACTGFX_LVLWOOD           EQU $0D
DEF ACTGFX_WOODMAN           EQU $0E
DEF ACTGFX_LVLAIR            EQU $0F
DEF ACTGFX_AIRMAN            EQU $10
DEF ACTGFX_WILY0             EQU $11
DEF ACTGFX_WILY1             EQU $12
DEF ACTGFX_QUINT             EQU $13
DEF ACTGFX_HARDMAN           EQU $14
DEF ACTGFX_TOPMAN            EQU $15

DEF LVL_HARD                 EQU $00
DEF LVL_TOP                  EQU $01
DEF LVL_MAGNET               EQU $02
DEF LVL_NEEDLE               EQU $03
DEF LVL_CRASH                EQU $04
DEF LVL_METAL                EQU $05
DEF LVL_WOOD                 EQU $06
DEF LVL_AIR                  EQU $07
DEF LVL_CASTLE               EQU $08
DEF LVL_STATION              EQU $09

; wWpnUnlock0
DEF WPUB_TP                  EQU 0
DEF WPUB_AR                  EQU 1
DEF WPUB_WD                  EQU 2
DEF WPUB_ME                  EQU 3
DEF WPUB_CR                  EQU 4
DEF WPUB_NE                  EQU 5
DEF WPUB_HA                  EQU 6
DEF WPUB_MG                  EQU 7

DEF WPU_TP                   EQU 1 << WPUB_TP
DEF WPU_AR                   EQU 1 << WPUB_AR
DEF WPU_WD                   EQU 1 << WPUB_WD
DEF WPU_ME                   EQU 1 << WPUB_ME
DEF WPU_CR                   EQU 1 << WPUB_CR
DEF WPU_NE                   EQU 1 << WPUB_NE
DEF WPU_HA                   EQU 1 << WPUB_HA
DEF WPU_MG                   EQU 1 << WPUB_MG

; wWpnUnlock1
DEF WPUB_RC                  EQU 0
DEF WPUB_RM                  EQU 1
DEF WPUB_RJ                  EQU 2
DEF WPUB_SG                  EQU 3

DEF WPU_RC                   EQU 1 << WPUB_RC
DEF WPU_RM                   EQU 1 << WPUB_RM
DEF WPU_RJ                   EQU 1 << WPUB_RJ
DEF WPU_SG                   EQU 1 << WPUB_SG

; wWpnId
DEF WPN_P                    EQU $00
DEF WPN_RC                   EQU $01
DEF WPN_RM                   EQU $02
DEF WPN_RJ                   EQU $03
DEF WPN_TP                   EQU $04
DEF WPN_AR                   EQU $05
DEF WPN_WD                   EQU $06
DEF WPN_ME                   EQU $07
DEF WPN_CR                   EQU $08
DEF WPN_NE                   EQU $09
DEF WPN_HA                   EQU $0A
DEF WPN_MG                   EQU $0B
DEF WPN_SG                   EQU $0C
DEF WPN_EN                   EQU $0D

DEF SECT_DISABLE             EQU $FF ; Magic value to disable the WINDOW layer and LYC trigger

DEF SCREVB_SCROLLV           EQU 7 ; Vertical scrolling
DEF SCREV_SCROLLV            EQU 1 << SCREVB_SCROLLV

DEF SCROLLV_UP               EQU 0
DEF SCROLLV_DOWN             EQU 1

DEF SLKB_OPEN                EQU 7 ; Scroll unlocked for the column (unpacked)

; Gauge
DEF BAR_MAX                  EQU $98 ; $98 (152)
DEF BAR_UNIT                 EQU $08 ; 1 bar is 8 units of health/ammo
DEF BARID_PL                 EQU 0 ; Player health
DEF BARID_WPN                EQU 1 ; Weapon ammo
DEF BARID_BOSS               EQU 2 ; Boss health
DEF BARID_LIVES              EQU 3 ; Player lives (special)

; TilemapDef tilemap writing flags
DEF BGB_REPEAT               EQU 6
DEF BGB_MVDOWN               EQU 7
DEF BG_NOREPEAT              EQU $00
DEF BG_REPEAT                EQU 1 << BGB_REPEAT
DEF BG_MVRIGHT               EQU $00
DEF BG_MVDOWN                EQU 1 << BGB_MVDOWN

; wShutterMode
DEF SHMODE_NONE              EQU $00
DEF SHMODE_START             EQU $01

; wShutterEvMode
DEF SHUTTER_NONE             EQU $00
DEF SHUTTER_OPEN             EQU $01
DEF SHUTTER_CLOSE            EQU $02

DEF TILEID_SHUTTER_L         EQU $78
DEF TILEID_SHUTTER_R         EQU $79

DEF BLOCK_TILECOUNT_H        EQU $02 ; Number of 8x8 tiles in a block, horizontally
DEF BLOCK_TILECOUNT_V        EQU $02 ; Number of 8x8 tiles in a block, vertically
DEF BLOCK_H                  EQU BLOCK_TILECOUNT_H * TILE_H ; $10
DEF BLOCK_V                  EQU BLOCK_TILECOUNT_V * TILE_V ; $10

DEF SCREEN_GAME_BLOCKCOUNT_H EQU $0A ; Number of blocks horizontally in the game screen
DEF SCREEN_GAME_BLOCKCOUNT_V EQU $08 ; Number of blocks vertically in the game screen
DEF SCREEN_GAME_H            EQU SCREEN_GAME_BLOCKCOUNT_H * BLOCK_TILECOUNT_H * TILE_H ; $A0 ; Width, in pixels, of the gameplay screen
DEF SCREEN_GAME_V            EQU SCREEN_GAME_BLOCKCOUNT_V * BLOCK_TILECOUNT_V * TILE_V ; $80 ; Height, in pixels, of the gameplay screen


DEF LVLSCROLLV_BLOCKCOUNT    EQU $0C ; Number of blocks drawn when scrolling vertically

; Rooms
DEF COL_TILECOUNT_H          EQU $02 ; Number of tiles horizontally in a column
DEF ROOM_COLCOUNT            EQU $0A ; Number of columns in a room
DEF LVL_ROOMCOUNT            EQU $19 ; Max number of rooms in a level

DEF COL_PX_H                 EQU COL_TILECOUNT_H * TILE_H ; $10 ; Width of a column, in pixels

; Gameplay

DEF BLOCKID_EMPTY_START      EQU $00 ; Empty blocks ($00-$21)
DEF BLOCKID_TOPSOLID_START   EQU $21 ; Solid blocks on top ($22-$3B)
DEF BLOCKID_SOLID_START      EQU $22 ; Solid blocks ($22-$3B)
DEF BLOCKID_HALF_START       EQU $3C ; Small platforms ($3C-$3F)

DEF BLOCKID_WLEAF            EQU $03 ; White leaf
DEF BLOCKID_WLEAFL           EQU $04 ; White leaf, left edge
DEF BLOCKID_WLEAFR           EQU $05 ; White leaf, right edge

DEF BLOCKID_WATER            EQU $10 ; Underwater block

DEF BLOCKID_SPIKE_START      EQU $18
DEF BLOCKID_WATERSPIKE       EQU $18 ; Underwater spike
DEF BLOCKID_SPIKE0           EQU $19 ; Spike block
DEF BLOCKID_SPIKE1           EQU $1A ; ""
DEF BLOCKID_SPIKE2           EQU $1B ; ""
DEF BLOCKID_SPIKE3           EQU $1C ; ""
DEF BLOCKID_SPIKE4           EQU $1D ; ""
DEF BLOCKID_SPIKE5           EQU $1E ; ""
DEF BLOCKID_SPIKE6           EQU $1F ; ""
DEF BLOCKID_SPIKE_END        EQU $20

DEF BLOCKID_LADDER           EQU $20 ; Ladder block
DEF BLOCKID_LADDERTOP        EQU $21 ; Ladder top block

DEF BLOCKID_CONVEDGE_R       EQU $30 ; Right conveyor belt, edge with arrow
DEF BLOCKID_CONVEDGE_L       EQU $31 ; Left conveyor belt, edge with arrow
DEF BLOCKID_CONVMID_R        EQU $32 ; Right conveyor belt, middle
DEF BLOCKID_CONVMID_L        EQU $33 ; Left conveyor belt, middle
DEF BLOCKID_SHUTTER          EQU $38 ; Shutter

; wBossMode
DEF BSMODE_NONE              EQU $00 ; Nothing (still on the main level)
DEF BSMODE_CORRIDOR          EQU $01 ; Boss corridor (from this mode onwards, the screen is locked)
DEF BSMODE_INIT              EQU $02 ; Boss initialization
DEF BSMODE_INITANIM          EQU $03 ; Set up boss intro animation
DEF BSMODE_PLAYANIM          EQU $04 ; Play boss intro animation
DEF BSMODE_REFILL            EQU $05 ; Refill health bar
DEF BSMODE_END               EQU $06 ; End of intro

; wLvlEnd
DEF LVLEND_NONE              EQU $00 ; Nothing
DEF LVLEND_PLDEAD            EQU $01 ; Player explodes (restart level)
DEF LVLEND_BOSSDEAD          EQU $02 ; Boss explodes (won level)
DEF LVLEND_TLPHARD           EQU (LVL_HARD+1) << 4 ; Teleport to Hard Man's stage
DEF LVLEND_TLPTOP            EQU (LVL_TOP+1) << 4 ; ...
DEF LVLEND_TLPMAGNET         EQU (LVL_MAGNET+1) << 4
DEF LVLEND_TLPNEEDLE         EQU (LVL_NEEDLE+1) << 4

; wPlMode
DEF PL_MODE_GROUND           EQU $00 ; On the ground
DEF PL_MODE_JUMP             EQU $01 ; Jumping (move up)
DEF PL_MODE_FULLJUMP         EQU $02 ; Jumping (can't cut early)
DEF PL_MODE_FALL             EQU $03 ; Falling (move down)
DEF PL_MODE_CLIMB            EQU $04 ; Climbing
DEF PL_MODE_CLIMBININIT      EQU $05 ; Init for...
DEF PL_MODE_CLIMBIN          EQU $06 ; Climbed down from top of the ladder while standing
DEF PL_MODE_CLIMBOUTINIT     EQU $07 ; Init for...
DEF PL_MODE_CLIMBOUT         EQU $08 ; Climbed to the top of a ladder
DEF PL_MODE_CLIMBDTRSINIT    EQU $09 ; Init for...
DEF PL_MODE_CLIMBDTRS        EQU $0A ; Downwards screen transition - climbing down
DEF PL_MODE_CLIMBUTRSINIT    EQU $0B ; Init for...
DEF PL_MODE_CLIMBUTRS        EQU $0C ; Upwards screen transition - climbing up
DEF PL_MODE_FALLTRSINIT      EQU $0D ; Init for...
DEF PL_MODE_FALLTRS          EQU $0E ; Downwards screen transition - falling
DEF PL_MODE_FROZEN           EQU $0F ; Player doesn't move, controls locked (ie: for the boss room) 
DEF PL_MODE_SLIDE            EQU $10 ; Sliding
DEF PL_MODE_RM               EQU $11 ; Inside Rush Marine
DEF PL_MODE_WARPININIT       EQU $12 ; Init for...
DEF PL_MODE_WARPINMOVE       EQU $13 ; Teleporting Down - Moving
DEF PL_MODE_WARPINLAND       EQU $14 ; Teleporting Down - Ground animation
DEF PL_MODE_WARPOUTINIT      EQU $15 ; Init for...
DEF PL_MODE_WARPOUTANIM      EQU $16 ; Teleporting Up - Ground animation
DEF PL_MODE_WARPOUTMOVE      EQU $17 ; Teleporting Up - Moving
DEF PL_MODE_WARPOUTEND       EQU $18 ; Teleporting Up - Wait for level end
DEF PL_MODE_TLPINIT          EQU $19 ; Init for...
DEF PL_MODE_TLPANIM          EQU $1A ; Wily Teleporter - Anim
DEF PL_MODE_TLPEND           EQU $1B ; Wily Teleporter - Wait for level end

; wPlSprMapId - Generic Set (affected by wPlShootType)
DEF PLSPR_WALK0              EQU $00
DEF PLSPR_WALK1              EQU $01
DEF PLSPR_WALK2              EQU $02
DEF PLSPR_WALK3              EQU $03
DEF PLSPR_IDLE               EQU $04
DEF PLSPR_BLINK              EQU $05
DEF PLSPR_SIDESTEP           EQU $06
DEF PLSPR_JUMP               EQU $07
DEF PLSPR_CLIMBTOP           EQU $08
DEF PLSPR_CLIMB              EQU $09
DEF PLSPR_SLIDE              EQU $0A

DEF PLSPR_SG_IDLE            EQU $1C
DEF PLSPR_SG_JUMP            EQU $1D

; wPlSprMapId - Fixed Set (wPlShootType-independent)
DEF PLSPR_HURT               EQU $30
DEF PLSPR_WARP_START         EQU $31
DEF PLSPR_WARP               EQU $31
DEF PLSPR_WARPLAND0          EQU $32
DEF PLSPR_WARPLAND1          EQU $33
DEF PLSPR_WARPLAND2          EQU $34
DEF PLSPR_WARPLAND3          EQU $35
DEF PLSPR_WARP_END           EQU $36


; wPlDirH / iShotDir
; The player direction only uses DIR_L and DIR_R.
DEF DIRB_R                   EQU 0
DEF DIR_L                    EQU $00
DEF DIR_R                    EQU $01
DEF DIR_U                    EQU $02
DEF DIR_D                    EQU $03
DEF DIR_UL                   EQU $04 
DEF DIR_UR                   EQU $05
DEF DIR_DL                   EQU $06
DEF DIR_DR                   EQU $07

DEF PLCOLI_H                 EQU $06 ; Player collision box, horizontal radius
DEF PLCOLI_V                 EQU $0C ; Player collision box, vertical radius
DEF RMCOLI_H                 EQU $0E ; Rush Marine collision box, horizontal radius
DEF RMCOLI_FV                EQU $0F ; Rush Marine collision box, vertical HEIGHT

DEF PL_LADDER_BORDER_V       EQU PLCOLI_V*2 ; Amount you automatically move when climbing in/out of ladders
DEF PL_LADDER_IN0            EQU $08
DEF PL_LADDER_IN1            EQU $10
ASSERT PL_LADDER_IN0 + PL_LADDER_IN1 == PL_LADDER_BORDER_V, "PL_LADDER_BORDER_V inconsistency"

; wPlShootType
DEF PSA_NONE                 EQU $00 ; Not shooting
DEF PSA_SHOOT                EQU $10 ; Shooting
DEF PSA_THROW                EQU $20 ; Throwing (ie: Metal Blade)

; Actor IDs
DEF ACT_EXPLSM               EQU $00 ; Small explosion
DEF ACT_1UP                  EQU $01 ; Extra Life
DEF ACT_AMMOLG               EQU $02 ; Large Weapon Energy
DEF ACT_HEALTHLG             EQU $03 ; Large Life Energy
DEF ACT_HEALTHSM             EQU $04 ; Small Life Energy
DEF ACT_AMMOSM               EQU $05 ; Small Weapon Energy
DEF ACT_ETANK                EQU $06 ; E-Tank
DEF ACT_EXPLLGPART           EQU $07 ; Large explosion particle
DEF ACT_BEE                  EQU $08 ; Have "Su" Bee
DEF ACT_BEEHIVE              EQU $09 ; Have "Su" Bee Beehive
DEF ACT_CHIBEE               EQU $0A ; Chibee
DEF ACT_WANAAN               EQU $0B ; Wanaan
DEF ACT_HAMMERJOE            EQU $0C ; Hammer Joe
DEF ACT_HAMMER               EQU $0D ; Hammer thrown by Hammer Joe
DEF ACT_NEOMONKING           EQU $0E ; Kaettekita Monking
DEF ACT_NEOMET               EQU $0F ; Neo Metall
DEF ACT_PICKELBULL           EQU $10 ; Pickelman Bull
DEF ACT_BIKKY                EQU $11 ; Bikky
DEF ACT_KOMASABURO           EQU $12 ; Komasaburo
DEF ACT_KOMA                 EQU $13 ; Komasaburo - Spinning Top shot
DEF ACT_MECHAKKERO           EQU $14 ; Mechakkero 
DEF ACT_SPINTOPU             EQU $15 ; Spinning Top Platform - Moving Up
DEF ACT_SPINTOPD             EQU $16 ; Spinning Top Platform - Moving Down
DEF ACT_TAMA                 EQU $17 ; Tama
DEF ACT_TAMABALL             EQU $18 ; Tama - Yarn ball
DEF ACT_TAMAFLEA             EQU $19 ; Tama - Flea
DEF ACT_MAGFLY               EQU $1A ; Mag Fly
DEF ACT_GSPRINGER            EQU $1B ; Giant Springer
DEF ACT_GSPRINGERSHOT        EQU $1C ; Giant Springer - Homing Missile
DEF ACT_PETERCHY             EQU $1D ; Peterchy
DEF ACT_MAGNETFIELD          EQU $1E ; Magnet attraction area
DEF ACT_RESPAWNER            EQU $1F ; Unused, Respawner
DEF ACT_BLOCK0               EQU $20 ; Disappearing Block - Timing #0
DEF ACT_BLOCK1               EQU $21 ; Disappearing Block - Timing #1
DEF ACT_BLOCK2               EQU $22 ; Disappearing Block - Timing #2
DEF ACT_BLOCK3               EQU $23 ; Disappearing Block - Timing #3
DEF ACT_NEWSHOTMAN           EQU $24 ; New Shotman
DEF ACT_NEEDLEPRESS          EQU $25 ; Needle Press
DEF ACT_YAMBOW               EQU $26 ; Yambow
DEF ACT_HARI                 EQU $27 ; Hari Harry
DEF ACT_HARISHOT             EQU $28 ; Hari Harry Shot
DEF ACT_CANNON               EQU $29 ; Cannon
DEF ACT_CANNONSHOT           EQU $2A ; Cannon Ball
DEF ACT_TELLYSPAWN           EQU $2B ; Telly Spawner
DEF ACT_LIFT0                EQU $2C ; Moving Lift - Path #0
DEF ACT_LIFT1                EQU $2D ; Moving Lift - Path #1
DEF ACT_LIFT2                EQU $2E ; Moving Lift - Path #2
DEF ACT_BLOCKYHEAD           EQU $2F ; Blocky - Head part (master)
DEF ACT_BLOCKYBODY           EQU $30 ; Blocky - Invulnerable body
DEF ACT_BLOCKYRISE           EQU $31 ; Blocky - Rising body
DEF ACT_PIPI                 EQU $32 ; Pipi
DEF ACT_EGG                  EQU $33 ; Pipi's Egg
DEF ACT_COPIPI               EQU $34 ; Copipi hatched from egg
DEF ACT_SHOTMAN              EQU $35 ; Shotman
DEF ACT_FLYBOY               EQU $36 ; Fly Boy
DEF ACT_FLYBOYSPAWN          EQU $37 ; Fly Boy Spawner
DEF ACT_SPRINGER             EQU $38 ; Springer
DEF ACT_PIEROGEAR            EQU $39 ; Pierobot Cog (master)
DEF ACT_PIEROBOT             EQU $3A ; Pierobot
DEF ACT_MOLE                 EQU $3B ; Mole
DEF ACT_MOLESPAWN            EQU $3C ; Mole Spawner
DEF ACT_PRESS                EQU $3D ; Press
DEF ACT_ROBBIT               EQU $3E ; Robbit
DEF ACT_CARROT               EQU $3F ; Robbit - Carrot shot
DEF ACT_COOK                 EQU $40 ; Kukku
DEF ACT_COOKSPAWN            EQU $41 ; Kukku Spawner
DEF ACT_BATTON               EQU $42 ; Batton
DEF ACT_FRIENDER             EQU $43 ; Friender
DEF ACT_FLAME                EQU $44 ; Friender - Flame shot
DEF ACT_GOBLINHORN           EQU $45 ; Goblin - Horns
DEF ACT_GOBLIN               EQU $46 ; Goblin - Fader
DEF ACT_PUCHIGOBLIN          EQU $47 ; Petit Goblin
DEF ACT_SCWORMBASE           EQU $48 ; Scworm base
DEF ACT_SCWORMSHOT           EQU $49 ; Schworm shot
DEF ACT_MATASABURO           EQU $4A ; Matasaburo
DEF ACT_KAMINARIGORO         EQU $4B ; Kaminari Goro (master)
DEF ACT_KAMINARICLOUD        EQU $4C ; Kaminari Goro - Cloud platform
DEF ACT_KAMINARI             EQU $4D ; Kaminari Goro - Thunder shot
DEF ACT_TELLY                EQU $4E ; Telly
DEF ACT_PIPISPAWN            EQU $4F ; Pipi Spawner
DEF ACT_SPECBOSS_START       EQU $50
DEF ACT_WILY1                EQU $50 ; Wily Machine (1st phase)
DEF ACT_WILY2                EQU $51 ; Wily Machine (2nd phase)
DEF ACT_WILY3                EQU $52 ; Wily Machine (3rd phase)
DEF ACT_QUINT                EQU $53 ; Quint
DEF ACT_SPECBOSS_END         EQU $54
DEF ACT_WILY3PART            EQU $54 ; Wily Machine (3rd phase) - Animated parts
DEF ACT_WILY2INTRO           EQU $55 ; Wily Machine (2nd phase) - Intro cutscene
DEF ACT_QUINT_SG             EQU $56 ; Quint - Sakugarne
DEF ACT_QUINT_DEBRIS         EQU $57 ; Quint - Sakugarne debris
DEF ACT_WILY1BOMB            EQU $58 ; Wily Machine (1st phase) - Bouncing Bomb
DEF ACT_WILY1NAIL            EQU $59 ; Wily Machine (1st phase) - Toenail
DEF ACT_WILY2BOMB            EQU $5A ; Wily Machine (2nd phase) - Bouncing Bomb and projectile
DEF ACT_WILY2SHOT            EQU $5B ; Wily Machine (2nd phase) - Energy Shot
DEF ACT_WILY3MISSILE         EQU $5C ; Wily Machine (3rd phase) - Crayola Missile
DEF ACT_WILY3MET             EQU $5D ; Wily Machine (3rd phase) - Goomba
DEF ACT_WILYCTRL             EQU $5E ; Wily Machine - Master
DEF ACT_5F                   EQU $5F ; Unused, points to ACT_EXPLSM's code
DEF ACT_WPN_RC               EQU $60 ; Rush Coil
DEF ACT_WPN_RM               EQU $61 ; Rush Marine
DEF ACT_WPN_RJ               EQU $62 ; Rush Jet
DEF ACT_WPN_SG               EQU $63 ; Sakugarne
DEF ACT_BUBBLE               EQU $64 ; Air bubble when the player is underwater
DEF ACT_WILYCASTLESC         EQU $65 ; Wily Castle Cutscene - Wily
DEF ACT_TELEPORTCTRL         EQU $66 ; Wily Castle - Teleport Room Controller
DEF ACT_TELEPORTLIGHT        EQU $67 ; Wily Castle Teleporter Light
DEF ACT_BOSS_START           EQU $68
DEF ACT_HARDMAN              EQU $68 ; Hard Man
DEF ACT_TOPMAN               EQU $69 ; Top Man
DEF ACT_MAGNETMAN            EQU $6A ; Magnet Man
DEF ACT_NEEDLEMAN            EQU $6B ; Needle Man
DEF ACT_CRASHMAN             EQU $6C ; Crash Man
DEF ACT_METALMAN             EQU $6D ; Metal Man
DEF ACT_WOODMAN              EQU $6E ; Wood Man
DEF ACT_AIRMAN               EQU $6F ; Air Man
DEF ACT_BOSS_END             EQU $70
DEF ACT_HARDKNUCKLE          EQU $70 ; Hard Man - Hard Knuckle shot
DEF ACT_SPINTOPSHOT          EQU $71 ; Top Man - Spinning Top
DEF ACT_MAGNETMISSILE        EQU $72 ; Magnet Man - Magnet Missile
DEF ACT_NEEDLECANNON         EQU $73 ; Needle Man - Needle Cannon
DEF ACT_CRASHBOMB            EQU $74 ; Crash Man - Crash Bomb
DEF ACT_METALBLADE           EQU $75 ; Metal Man - Metal Blade
DEF ACT_WHIRLWIND            EQU $76 ; Air Man - Wind
DEF ACT_LEAFSHIELD           EQU $77 ; Wood Man - Shield Leaf
DEF ACT_LEAFRISE             EQU $78 ; Wood Man - Rising leaf
DEF ACT_LEAFFALL             EQU $79 ; Wood Man - Falling leaf
DEF ACT_CRASHBOMBEXPL        EQU $7A ; Crash Man - Large Crash Bomb explosion
DEF ACT_GROUNDEXPL           EQU $7B ; Wily Castle Cutscene - Ground explosion
DEF ACT_NEOMETSHOT           EQU $7C ; Neo Metall - Shot
DEF ACT_NEWSHOTMANSHOTV      EQU $7D ; New Shotman - Vertical Arc Shot
DEF ACT_NEWSHOTMANSHOTH      EQU $7E ; New Shotman - Horizontal Shot
DEF ACT_SHOTMANSHOT          EQU $7F ; Shotman - Shot

;--
DEF ACTRTN_ITEMDROP_INIT EQU $01

; wActBlockyMode - to Act_BlockyBody
DEF BLOCKYBODY_IDLE0   EQU $00
DEF BLOCKYBODY_THROW   EQU $01
; wActBlockyMode - to Act_BlockyRise
DEF BLOCKYRISE_REBUILD EQU $00
DEF BLOCKYRISE_IDLE1   EQU $01
DEF BLOCKYRISE_DEAD    EQU $02

DEF ACTRTN_QUINTDEBRIS_INIT0 EQU $00
DEF ACTRTN_QUINTDEBRIS_INIT1 EQU $01
DEF ACTRTN_QUINTDEBRIS_INIT2 EQU $02
DEF ACTRTN_QUINTDEBRIS_INIT3 EQU $03

DEF ACTRTN_WILYSHIP_MOVESCROLLR EQU $04
DEF ACTRTN_WILYSHIP_END      EQU $06

DEF ACTRTN_WILY3_INIT        EQU $01

DEF WILY3PART_SPR_NONE       EQU $00
DEF WILY3PART_SPR_ARM        EQU $04
DEF WILY3PART_SPR_TAIL       EQU $06
;--

; wWpnHelperWarpRtn
DEF AHW_NONE                 EQU $00 ; Not spawned
DEF AHW_WARPIN_INIT          EQU $01
DEF AHW_WARPIN_MOVED         EQU $02
DEF AHW_WARPIN_MOVEDCHKSPAWN EQU $03
DEF AHW_WARPIN_ANIM          EQU $04
DEF AHW_WARPIN_CHKSOLID      EQU $05
DEF AHW_WARPOUT_INITANIM     EQU $06
DEF AHW_WARPOUT_ANIM         EQU $07
DEF AHW_WARPOUT_MOVEU        EQU $08
DEF AHW_ACTIVE               EQU $FF ; Active and usable

DEF ACTLB_SPAWNNORM          EQU 4 ; Spawn the actor normally
DEF ACTLB_SPAWNBEHIND        EQU 5 ; Spawn the actor from behind
DEF ACTLB_NOSPAWN            EQU 7 ; Prevents the actor from being respawned
DEF ACTL_NOSPAWN             EQU 1 << ACTLB_NOSPAWN

DEF ACTFB_PROC               EQU 7 ; Actor processing flag
DEF ACTF_PROC                EQU 1 << ACTFB_PROC

; iActSprMap directional flags
DEF ACTDIRB_D                EQU 6
DEF ACTDIRB_R                EQU 7
DEF ACTDIR_U                 EQU $00
DEF ACTDIR_D                 EQU 1 << ACTDIRB_D
DEF ACTDIR_L                 EQU $00
DEF ACTDIR_R                 EQU 1 << ACTDIRB_R

; iActColiType
DEF ACTCOLI_PASS             EQU 0 ; Intangible
DEF ACTCOLI_ENEMYPASS        EQU 1 ; Enemy - Intangible from shots
DEF ACTCOLI_ENEMYHIT         EQU 2 ; Enemy - Vulnerable from shots
DEF ACTCOLI_ENEMYREFLECT     EQU 3 ; Enemy - Invulnerable from shots
DEF ACTCOLI_PLATFORM         EQU 4 ; Platform / helper item
DEF ACTCOLI_MAGNET           EQU 5 ; Magnetic Field
DEF ACTCOLI_ITEM             EQU 6 ; Item
DEF ACTCOLI_UNUSED_PASS2     EQU 7 ; Intangible
DEF ACTCOLI_8_START          EQU 8 ; Partially vulnerable
DEF ACTCOLIB_PARTIAL         EQU 7 ; Partially vulnerable
DEF ACTCOLI_PARTIAL          EQU 1 << ACTCOLIB_PARTIAL

; iActColiSubtype
DEF ACTCOLISUB_TOPSOLID      EQU $00 ; Top-Solid Platform
DEF ACTCOLISUB_SPINTOP       EQU $01 ; Spinning Top
DEF ACTCOLISUB_RC            EQU $02 ; Rush Coil
DEF ACTCOLISUB_RM            EQU $03 ; Rush Marine
DEF ACTCOLISUB_RJ            EQU $04 ; Rush Jet
DEF ACTCOLISUB_SG            EQU $05 ; Sakugarne

DEF ACTSLOT_NONE             EQU $FF

; iArcIdDir index directions
DEF ADRB_DEC_IDY             EQU 0 ; If set, the horizontal path index will decrease
DEF ADRB_DEC_IDX             EQU 1 ; If set, the vertical path index will decrease
DEF ADR_INC_IDY              EQU $00
DEF ADR_DEC_IDY              EQU 1 << ADRB_DEC_IDY
DEF ADR_INC_IDX              EQU $00
DEF ADR_DEC_IDX              EQU 1 << ADRB_DEC_IDX
DEF ARC_MAX                  EQU 88

DEF ARC_LG                   EQU $01 ; Large arc path (no values skipped)
DEF ARC_SM                   EQU $02 ; Small arc path (half of the values skipped)

DEF WPNPIERCE_NONE           EQU 0 ; Weapon always disappears on contact
DEF WPNPIERCE_LASTHIT        EQU 1 ; Weapon pierces only if it defeats the enemy
DEF WPNPIERCE_ALWAYS         EQU 2 ; Weapon always pierces

; Marker to distinguish between free slots and $00.
; Not as important as ACTF_PROC as their code will be executed even without it.
DEF SHOT0B_PROC              EQU 7
DEF SHOT0_PROC               EQU 1 << SHOT0B_PROC

DEF SHOT3B_DEFLECT           EQU 7 ; Marks the shot has getting deflected
DEF SHOT3_DEFLECT            EQU 1 << SHOT3B_DEFLECT

DEF SHOTWDB_THROW            EQU 6 ; Leaf Shield thrown
DEF SHOTWDB_ROTATE           EQU 7 ; Leaf Shield spawn animation done
DEF SHOTWD_THROW             EQU 1 << SHOTWDB_THROW
DEF SHOTWD_ROTATE            EQU 1 << SHOTWDB_ROTATE
DEF SHOTCRB_EXPLODE          EQU 7 ; Crash Bomb explodes
DEF SHOTCR_EXPLODE           EQU 1 << SHOTCRB_EXPLODE

DEF SHOTSPR_P                EQU $00 ; Buster Shot
DEF SHOTSPR_AR0              EQU $01 ; Air Shooter #0
DEF SHOTSPR_AR1              EQU $02 ; Air Shooter #1
DEF SHOTSPR_AR2              EQU $03 ; Air Shooter #2 (unused)
DEF SHOTSPR_WD               EQU $04 ; Leaf Shield
DEF SHOTSPR_ME0              EQU $05 ; Metal Blade #0
DEF SHOTSPR_ME1              EQU $06 ; Metal Blade #1
DEF SHOTSPR_CRMOVE           EQU $07 ; Crash Bomb
DEF SHOTSPR_CRFLASH0         EQU $08 ; Crash Bomb Flash #0
DEF SHOTSPR_CRFLASH1         EQU $09 ; Crash Bomb Flash #1
DEF SHOTSPR_CREXPL0          EQU $0A ; Crash Bomb Explosion #0
DEF SHOTSPR_CREXPL1          EQU $0B ; Crash Bomb Explosion #1
DEF SHOTSPR_CREXPL2          EQU $0C ; Crash Bomb Explosion #2
DEF SHOTSPR_CREXPL3          EQU $0D ; Crash Bomb Explosion #3
DEF SHOTSPR_CREXPL4          EQU $0E ; Crash Bomb Explosion #4
DEF SHOTSPR_CREXPL5          EQU $0F ; Crash Bomb Explosion #5
DEF SHOTSPR_CREXPL6          EQU $10 ; Crash Bomb Explosion #6
DEF SHOTSPR_CREXPL7          EQU $11 ; Crash Bomb Explosion #7
DEF SHOTSPR_CREXPL8          EQU $12 ; Crash Bomb Explosion #8
DEF SHOTSPR_NE               EQU $13 ; Needle Cannon
DEF SHOTSPR_HA               EQU $14 ; Hard Knuckle
DEF SHOTSPR_MGH              EQU $15 ; Magnet Missile Forward
DEF SHOTSPR_MGU              EQU $16 ; Magnet Missile Up
DEF SHOTSPR_MGD              EQU $17 ; Magnet Missile Down
DEF SHOTSPR_TP0              EQU $18 ; Top Spin #0
DEF SHOTSPR_TP1              EQU $19 ; Top Spin #1
DEF SHOTSPR_TP2              EQU $1A ; Top Spin #2
DEF SHOTSPR_TP3              EQU $1B ; Top Spin #3
DEF SHOTSPR_SG               EQU $1C ; Sakugarne (invisible)

; Sound driver
DEF SND_MUTE                 EQU $00

DEF BGM_TITLE                EQU $01
DEF BGM_STAGESELECT          EQU $02
DEF BGM_STAGESTART           EQU $03
DEF BGM_PASSWORD             EQU $04
DEF BGM_BOSS                 EQU $05
DEF BGM_STAGECLEAR           EQU $06
DEF BGM_WEAPONGET            EQU $07
DEF BGM_CRASHMAN             EQU $08
DEF BGM_AIRMAN               EQU $09
DEF BGM_METALMAN             EQU $0A
DEF BGM_HARDMAN              EQU $0B
DEF BGM_WOODMAN              EQU $0C
DEF BGM_TOPMAN               EQU $0D
DEF BGM_MAGNETMAN            EQU $0E
DEF BGM_NEEDLEMAN            EQU $0F
DEF BGM_WILYINTRO            EQU $10
DEF BGM_WILYCASTLE           EQU $11
DEF BGM_ENDING               EQU $12
DEF BGM_UNUSEDENDING         EQU $13

DEF SFX_LAND                 EQU $01
DEF SFX_SHOOT                EQU $02
DEF SFX_ENEMYHIT             EQU $03
DEF SFX_ENEMYDEAD            EQU $04
DEF SFX_DEFLECT              EQU $05
DEF SFX_EXPLODE              EQU $06
DEF SFX_BAR                  EQU $07
DEF SFX_ETANK                EQU $08
DEF SFX_1UP                  EQU $09
DEF SFX_SHUTTER              EQU $0A
DEF SFX_BOSSBAR              EQU $0B
DEF SFX_TELEPORTIN           EQU $0C
DEF SFX_TELEPORTOUT          EQU $0D
DEF SFX_FREEZETOGGLE         EQU $0E
DEF SFX_WEAPONABSORB         EQU $0F
DEF SFX_BLOCK                EQU $10
DEF SFX_UFOCRASH             EQU $11
DEF SFX_CURSORMOVE           EQU $12
DEF SFX_DAMAGED              EQU $13
DEF SFX_UNKNOWN2             EQU $14