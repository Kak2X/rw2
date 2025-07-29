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


DEF SECT_DISABLE     EQU $FF ; Magic value to disable the WINDOW layer and LYC trigger

DEF SCREVB_SCROLLV   EQU 7 ; Vertical scrolling
DEF SCREV_SCROLLV    EQU 1 << SCREVB_SCROLLV

DEF SCROLLV_UP       EQU 0
DEF SCROLLV_DOWN     EQU 1

; Packet writing flags
DEF PKGB_MVDOWN      EQU 6
DEF PKGB_REPEAT      EQU 7
DEF PKG_MVRIGHT      EQU $00
DEF PKG_MVDOWN       EQU 1 << PKGB_MVDOWN
DEF PKG_NOREPEAT     EQU $00
DEF PKG_REPEAT       EQU 1 << PKGB_REPEAT

; wShutterEvMode
DEF SHUTTER_NONE     EQU $00
DEF SHUTTER_OPEN     EQU $01
DEF SHUTTER_CLOSE    EQU $02

DEF BLOCK_TILECOUNT_H    EQU $02 ; Number of 8x8 tiles in a block, horizontally
DEF BLOCK_TILECOUNT_V    EQU $02 ; Number of 8x8 tiles in a block, vertically

DEF LVLSCROLLV_BLOCKCOUNT  EQU $0C ; Number of blocks drawn when scrolling vertically

DEF SCREEN_GAME_BLOCKCOUNT_H EQU $0A ; Number of blocks horizontally in the game screen
DEF SCREEN_GAME_BLOCKCOUNT_V EQU $08 ; Number of blocks vertically in the game screen
DEF SCREEN_GAME_H          EQU SCREEN_GAME_BLOCKCOUNT_H * BLOCK_TILECOUNT_H * TILE_H ; $A0 ; Width, in pixels, of the gameplay screen
DEF SCREEN_GAME_V          EQU SCREEN_GAME_BLOCKCOUNT_V * BLOCK_TILECOUNT_V * TILE_V ; $80 ; Height, in pixels, of the gameplay screen


; Rooms
DEF COL_TILECOUNT_H  EQU $02 ; Number of tiles horizontally in a column
DEF ROOM_COLCOUNT    EQU $0A ; Number of columns in a room
DEF LVL_ROOMCOUNT    EQU 26 ; Max number of rooms in a level


DEF COL_PX_H         EQU COL_TILECOUNT_H * TILE_H ; $10 ; Width of a column, in pixels


DEF TILEID_SHUTTER_L EQU $78
DEF TILEID_SHUTTER_R EQU $79