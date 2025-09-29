; =============== INTERRUPT DEFINITION ===============
INCLUDE "data/_base/hw_interrupt_def.asm"
; =============== CART HEADER ===============
INCLUDE "data/hw_header.asm"
; =============== ENTRY POINT ===============
INCLUDE "data/init.asm"
; =============== INTERRUPT IMPLEMENTATION (DynJump, Event Run, VBlank, ...) ===============
INCLUDE "data/_base/hw_interrupt_impl.asm"
; =============== SCREEN GFX & PALETTE LOAD ===============
INCLUDE "data/init_gfx.asm"
INCLUDE "data/title/init_gfx.asm"
INCLUDE "data/stagesel/init_gfx.asm"
INCLUDE "data/password/init_gfx.asm"
INCLUDE "data/game/init_gfx.asm"
INCLUDE "data/getwpn/init_gfx.asm"
INCLUDE "data/scene/castle/init_gfx.asm"
INCLUDE "data/scene/station/init_gfx.asm"
INCLUDE "data/gameover/init_gfx.asm"
INCLUDE "data/scene/_space/init_gfx.asm"
; =============== BASE SUBROUTINES ===============
INCLUDE "data/_base/hw_screen.asm"				; Generic VRAM/OAM utilities + tilemap event loader
INCLUDE "data/_base/util.asm"					; Utility functions (Delay, Poll, Rand, Math)
; =============== LEVEL ===============
INCLUDE "data/game/lvl_init.asm" 				; Level init
INCLUDE "data/game/lvl_draw.asm" 				; Level draw to tilemap
INCLUDE "data/game/lvl_roomtrs.asm" 			; Vertical room transitions
; Initial status bar tilemap with placeholder values, loaded by lvl_draw.asm
TilemapDef_StatusBar: INCLUDE "data/game/statusbar_bg.asm"
; =============== PLAYER ===============
INCLUDE "data/game/pl/init.asm"					; Init
INCLUDE "data/game/pl/pl.asm"					; Entity code
INCLUDE "data/game/pl/coli_lvl.asm"				; Level collision routines
INCLUDE "data/game/pl/move.asm"					; Speed / movement routines
INCLUDE "data/game/pl/draw.asm"					; Animation and sprite mapping draw code
; =============== ACTORS ===============
INCLUDE "data/game/act/init.asm"				; Initialization and room/edge spawn code
INCLUDE "data/game/act/expl/expl_lg_spawn.asm"	; Spawn code for large explosions
INCLUDE "data/game/act/spawn_in.asm"			; Base subroutine for actually spawning actors
INCLUDE "data/game/act/init_vram.asm"			; Actor GFX set loading code
INCLUDE "data/game/act/expl/expl_sm_spawn.asm"	; Spawn code for small explosions
INCLUDE "data/game/act/item/item_spawn.asm"		; Spawn code for randomized item drops
; =============== ACTOR FUNCTIONS ===============
; Most of these either expect to affect the currently processed actor, or are passed in the actor they should affect.
; In any case, they are exclusively run from actor code.
INCLUDE "data/game/act/sub_util.asm"			; Miscellaneous utility functions
INCLUDE "data/game/act/sub_anim.asm"			; Sprite animation functions
INCLUDE "data/game/act/sub_path.asm"			; Special movement paths. These don't move the actor directly, but affect its speed.
INCLUDE "data/game/act/coli_lvl.asm"			; Actor-specific solid collision check routines
INCLUDE "data/game/act/move.asm"				; Movement routines, similar to the player's move.asm
INCLUDE "data/game/act/spawn_out.asm"			; Self-despawn code
INCLUDE "data/game/act/draw.asm"				; Sprite mapping draw code
INCLUDE "data/game/act/sub_path_tbl.asm"		; Data used for special movement paths.
; =============== MAIN CODE ===============
INCLUDE "data/main.asm"							; Main function, handles state changes
INCLUDE "data/game/game.asm"					; Gameplay loop, main
INCLUDE "data/game/game_deadpl.asm"				; Pseudo-gameplay loop, player dead
INCLUDE "data/game/game_deadboss.asm"			; Pseudo-gameplay loop, boss dead
INCLUDE "data/game/game_cutscene_sub.asm"		; Pseudo-gameplay loop routines, for in-engine cutscenes
INCLUDE "data/game/init.asm"					; Gameplay init mode
INCLUDE "data/game/event.asm"					; Shared gameplay events, such as health refills
; =============== TITLE SCREEN ===============
INCLUDE "data/title/title.asm"
; =============== STAGE SELECT ===============
INCLUDE "data/stagesel/stagesel.asm"			; Stage select (1st part)
INCLUDE "data/stagesel/intro.asm"				; Boss intro (2nd part)
; =============== GET WEAPON SCREEN ===============
INCLUDE "data/getwpn/getwpn.asm"				; Main code
INCLUDE "data/getwpn/text_tbl.asm"				; Text string & assignments
; =============== SHARED CUTSCENE CODE ===============
INCLUDE "data/scene/castle/init_vram.asm"		; VRAM setup for Wily Castle pic
INCLUDE "data/scene/station/init_vram.asm"		; VRAM setup for Wily Station pic
INCLUDE "data/scene/castle/wilycastle.asm"		; In-engine Wily Castle cutscene code
INCLUDE "data/game/castle_teleporters.asm"		; Visual effect for closing teleporters, when returning to the teleporter room
; =============== COLLISION ===============
INCLUDE "data/game/coli_lvl.asm"				; Shared solid collision check routines
INCLUDE "data/game/wpn/coli_act.asm"			; Weapon to actor collision, including (boss) death setup
INCLUDE "data/game/pl/coli_act.asm"				; Player to actor collision
; =============== PAUSE SCREEN / STATUS BAR ===============
INCLUDE "data/game/pause.asm"					; Pause screen code
INCLUDE "data/game/wpn/gfx_ptr.asm"				; Weapon art set definitions
INCLUDE "data/game/wpn/clear.asm"				; Init code
INCLUDE "data/game/wpn/ammo.asm"				; Ammo routines
INCLUDE "data/game/statusbar_draw.asm"			; Status bar drawing routines
INCLUDE "data/game/pause_sub.asm"				; Pause drawing & cursor movement routines
; =============== MISC TABLES ===============
INCLUDE "data/game/act/gfx_ptr.asm"				; Actor art set definitions
INCLUDE "data/game/lvl/settings_tbl.asm"		; Level settings
INCLUDE "data/game/lvl_draw_tbl.asm"			; Table of tilemap pointers for each block
	mIncJunk "L003C94"
