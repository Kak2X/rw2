;
; ROCKMAN WORLD 2
;
; ロックマンワールド２
;

DEF VER_JP EQU 0
DEF VER_US EQU 1

INCLUDE "inc/font.asm"
INCLUDE "inc/hardware.asm"
INCLUDE "inc/constants.asm"
INCLUDE "inc/macro.asm"
INCLUDE "inc/memory.asm"

MACRO mFillBank
IF LABEL_JUNK
Padding_\@:
ENDC
IF !SKIP_JUNK
	REPT $4000
		db $FF
	ENDR
ENDC
ENDM

; 
; BANK $00 - Main Bank #1
;
SECTION "bank00", ROM0
; =============== INTERRUPT DEFINITION ===============
INCLUDE "src/_base/hw_interrupt_def.asm"
; =============== CART HEADER ===============
INCLUDE "src/hw_header.asm"
; =============== ENTRY POINT ===============
INCLUDE "src/init.asm"
; =============== INTERRUPT IMPLEMENTATION (DynJump, Event Run, VBlank, ...) ===============
INCLUDE "src/_base/hw_interrupt_impl.asm"
; =============== SCREEN GFX & PALETTE LOAD ===============
INCLUDE "src/init_gfx.asm"
INCLUDE "src/title/init_gfx.asm"
INCLUDE "src/stagesel/init_gfx.asm"
INCLUDE "src/password/init_gfx.asm"
INCLUDE "src/game/init_gfx.asm"
INCLUDE "src/getwpn/init_gfx.asm"
INCLUDE "src/scene/castle/init_gfx.asm"
INCLUDE "src/scene/station/init_gfx.asm"
INCLUDE "src/gameover/init_gfx.asm"
INCLUDE "src/scene/_space/init_gfx.asm"
; =============== BASE SUBROUTINES ===============
INCLUDE "src/_base/hw_screen.asm"				; Generic VRAM/OAM utilities + tilemap event loader
INCLUDE "src/_base/util.asm"					; Utility functions (Delay, Poll, Rand, Math)
; =============== LEVEL ===============
INCLUDE "src/game/lvl_init.asm" 				; Level init
INCLUDE "src/game/lvl_draw.asm" 				; Level draw to tilemap
INCLUDE "src/game/lvl_roomtrs.asm" 			; Vertical room transitions
; Initial status bar tilemap with placeholder values, loaded by lvl_draw.asm
TilemapDef_StatusBar: INCLUDE "src/game/statusbar_bg.asm"
; =============== PLAYER ===============
INCLUDE "src/game/pl/init.asm"					; Init
INCLUDE "src/game/pl/pl.asm"					; Entity code
INCLUDE "src/game/pl/coli_lvl.asm"				; Level collision routines
INCLUDE "src/game/pl/move.asm"					; Speed / movement routines
INCLUDE "src/game/pl/draw.asm"					; Animation and sprite mapping draw code
; =============== ACTORS ===============
INCLUDE "src/game/act/init.asm"				; Initialization and room/edge spawn code
INCLUDE "src/game/act/expl/expl_lg_spawn.asm"	; Spawn code for large explosions
INCLUDE "src/game/act/spawn_in.asm"			; Base subroutine for actually spawning actors
INCLUDE "src/game/act/init_vram.asm"			; Actor GFX set loading code
INCLUDE "src/game/act/expl/expl_sm_spawn.asm"	; Spawn code for small explosions
INCLUDE "src/game/act/item/item_spawn.asm"		; Spawn code for randomized item drops
; =============== ACTOR FUNCTIONS ===============
; Most of these either expect to affect the currently processed actor, or are passed in the actor they should affect.
; In any case, they are exclusively run from actor code.
INCLUDE "src/game/act/sub_util.asm"			; Miscellaneous utility functions
INCLUDE "src/game/act/sub_anim.asm"			; Sprite animation functions
INCLUDE "src/game/act/sub_path.asm"			; Special movement paths. These don't move the actor directly, but affect its speed.
INCLUDE "src/game/act/coli_lvl.asm"			; Actor-specific solid collision check routines
INCLUDE "src/game/act/move.asm"				; Movement routines, similar to the player's move.asm
INCLUDE "src/game/act/spawn_out.asm"			; Self-despawn code
INCLUDE "src/game/act/draw.asm"				; Sprite mapping draw code
INCLUDE "src/game/act/sub_path_tbl.asm"		; Data used for special movement paths.
; =============== MAIN CODE ===============
INCLUDE "src/main.asm"							; Main function, handles state changes
INCLUDE "src/game/game.asm"					; Gameplay loop, main
INCLUDE "src/game/game_deadpl.asm"				; Pseudo-gameplay loop, player dead
INCLUDE "src/game/game_deadboss.asm"			; Pseudo-gameplay loop, boss dead
INCLUDE "src/game/game_cutscene_sub.asm"		; Pseudo-gameplay loop routines, for in-engine cutscenes
INCLUDE "src/game/init.asm"					; Gameplay init mode
INCLUDE "src/game/event.asm"					; Shared gameplay events, such as health refills
; =============== TITLE SCREEN ===============
INCLUDE "src/title/title.asm"
; =============== STAGE SELECT ===============
INCLUDE "src/stagesel/stagesel.asm"			; Stage select (1st part)
INCLUDE "src/stagesel/intro.asm"				; Boss intro (2nd part)
; =============== GET WEAPON SCREEN ===============
INCLUDE "src/getwpn/getwpn.asm"				; Main code
INCLUDE "src/getwpn/text_tbl.asm"				; Text string & assignments
; =============== SHARED CUTSCENE CODE ===============
INCLUDE "src/scene/castle/init_vram.asm"		; VRAM setup for Wily Castle pic
INCLUDE "src/scene/station/init_vram.asm"		; VRAM setup for Wily Station pic
INCLUDE "src/scene/castle/wilycastle.asm"		; In-engine Wily Castle cutscene code
INCLUDE "src/game/castle_teleporters.asm"		; Visual effect for closing teleporters, when returning to the teleporter room
; =============== COLLISION ===============
INCLUDE "src/game/coli_lvl.asm"				; Shared solid collision check routines
INCLUDE "src/game/wpn/coli_act.asm"			; Weapon to actor collision, including (boss) death setup
INCLUDE "src/game/pl/coli_act.asm"				; Player to actor collision
; =============== PAUSE SCREEN / STATUS BAR ===============
INCLUDE "src/game/pause.asm"					; Pause screen code
INCLUDE "src/game/wpn/gfx_ptr.asm"				; Weapon art set definitions
INCLUDE "src/game/wpn/clear.asm"				; Init code
INCLUDE "src/game/wpn/ammo.asm"				; Ammo routines
INCLUDE "src/game/statusbar_draw.asm"			; Status bar drawing routines
INCLUDE "src/game/pause_sub.asm"				; Pause drawing & cursor movement routines
; =============== MISC TABLES ===============
INCLUDE "src/game/act/gfx_ptr.asm"				; Actor art set definitions
INCLUDE "src/game/lvl/settings_tbl.asm"		; Level settings
INCLUDE "src/game/lvl_draw_tbl.asm"			; Table of tilemap pointers for each block
	mIncJunk "L003C94"


; 
; BANK $01 - Main Bank #2
; 
SECTION "bank01", ROMX, BANK[$01]
; =============== WEAPON PLAYER CONTROLS ===============
INCLUDE "src/game/wpn/ctrl_run.asm"
INCLUDE "src/game/wpn/p/ctrl.asm"
INCLUDE "src/game/wpn/rc/ctrl.asm"
INCLUDE "src/game/wpn/rm/ctrl.asm"
INCLUDE "src/game/wpn/rj/ctrl.asm"
INCLUDE "src/game/wpn/sg/ctrl.asm"
INCLUDE "src/game/wpn/helperctrl_sub.asm"
INCLUDE "src/game/wpn/tp/ctrl.asm"
INCLUDE "src/game/wpn/ar/ctrl.asm"
INCLUDE "src/game/wpn/wd/ctrl.asm"
INCLUDE "src/game/wpn/me/ctrl.asm"
INCLUDE "src/game/wpn/cr/ctrl.asm"
INCLUDE "src/game/wpn/ne/ctrl.asm"
INCLUDE "src/game/wpn/ha/ctrl.asm"
INCLUDE "src/game/wpn/mg/ctrl.asm"
; =============== WEAPON SHOT CODE ===============
INCLUDE "src/game/wpn/shot_run.asm"
INCLUDE "src/game/wpn/p/shot.asm"
INCLUDE "src/game/wpn/tp/shot.asm"
INCLUDE "src/game/wpn/ar/shot.asm"
INCLUDE "src/game/wpn/wd/shot.asm"
INCLUDE "src/game/wpn/me/shot.asm"
INCLUDE "src/game/wpn/cr/shot.asm"
INCLUDE "src/game/wpn/ne/shot.asm"
INCLUDE "src/game/wpn/ha/shot.asm"
INCLUDE "src/game/wpn/mg/shot.asm"
; =============== SHOT SPRITE MAPPINGS ===============
INCLUDE "src/game/wpn/draw.asm"
INCLUDE "src/game/wpn/spr_ptr.asm"
INCLUDE "src/game/wpn/p/p_spr.asm"
INCLUDE "src/game/wpn/tp/tp_spr.asm"
INCLUDE "src/game/wpn/ar/ar_spr.asm"
INCLUDE "src/game/wpn/wd/wd_spr.asm"
INCLUDE "src/game/wpn/me/me_spr.asm"
INCLUDE "src/game/wpn/cr/cr_spr.asm"
INCLUDE "src/game/wpn/ne/ne_spr.asm"
INCLUDE "src/game/wpn/ha/ha_spr.asm"
INCLUDE "src/game/wpn/mg/mg_spr.asm"
INCLUDE "src/game/wpn/sg/sg_spr.asm"
; =============== SHOT DATA ===============
INCLUDE "src/game/wpn/me/pos_tbl.asm"
INCLUDE "src/game/wpn/wd/pos_tbl.asm"
INCLUDE "src/game/wpn/prop_tbl.asm"
; =============== PASSWORD INPUT/VIEW ===============
INCLUDE "src/password/password.asm"
INCLUDE "src/password/password_tbl.asm"
INCLUDE "src/password/password_ev.asm"
INCLUDE "src/password/passwordview.asm"
INCLUDE "src/password/passwordview_ev.asm"
; =============== GAMEPLAY CHEATS ===============
INCLUDE "src/game/cheat.asm"
; =============== CUTSCENES ===============
INCLUDE "src/scene/station/wilystation.asm"
INCLUDE "src/scene/ending/ending.asm"
INCLUDE "src/scene/credits/credits.asm"
INCLUDE "src/scene/sub.asm"
; =============== CUTSCENE BACKGROUNDS ===============
TilemapDef_WilyStationEntrance: INCLUDE "src/scene/_space/entrance_bg.asm"
TilemapDef_Earth: 				INCLUDE "src/scene/ending/earth_bg.asm"
TilemapDef_Ending_Space: 		INCLUDE "src/scene/ending/ending_space_bg.asm"
TilemapDef_Credits_Space: 		INCLUDE "src/scene/credits/space_bg.asm"
	mIncJunk "L016166"
SETCHARMAP credits
TilemapDef_Credits_Thank:		INCLUDE "src/scene/credits/thank_bg.asm"
Credits_StarfieldSprTbl:		INCLUDE "src/scene/credits/starfield_dspr.asm"
; =============== CUTSCENE SPRITE MAPPINGS ===============
INCLUDE "src/scene/spr_ptr.asm"
INCLUDE "src/scene/_space/spr/null_spr.asm"
INCLUDE "src/scene/_space/spr/wily_sm_spr.asm"
INCLUDE "src/scene/_space/spr/pl_spr.asm"
INCLUDE "src/scene/_space/spr/wily_spr.asm"
INCLUDE "src/scene/_space/spr/missile_spr.asm"
INCLUDE "src/scene/_space/spr/skulljaw_spr.asm"
INCLUDE "src/scene/_space/spr/wilycrash_spr.asm"
INCLUDE "src/scene/_space/spr/wilynuke_spr.asm"
INCLUDE "src/scene/_space/spr/expl_spr.asm"
INCLUDE "src/scene/credits/pl_spr.asm"

; =============== CAST ROLL DATA ===============
INCLUDE "src/scene/credits/credits_tbl.asm"

; =============== CAST ROLL SPRITE MAPPINGS ===============
;
; [POI] There are unused sprite mappings for some of the larger enemies.
;       They didn't make the cut as there wouldn't be enough space in OAM to display
;       them, their name and the large Rockman sprite at the same time.
;
;       None of them have entries or names in the cast roll, just unreferenced sprites.
;
INCLUDE "src/scene/credits/cast_spr/bee_spr.asm"
INCLUDE "src/scene/credits/cast_spr/chibee_spr.asm"
INCLUDE "src/scene/credits/cast_spr/wanaan_spr.asm"
INCLUDE "src/scene/credits/cast_spr/hammerjoe_spr.asm"
INCLUDE "src/scene/credits/cast_spr/neomonking_spr.asm"
INCLUDE "src/scene/credits/cast_spr/neomet_spr.asm"
INCLUDE "src/scene/credits/cast_spr/unused_pickelmanbull_spr.asm"
INCLUDE "src/scene/credits/cast_spr/unused_bikky_spr.asm"
INCLUDE "src/scene/credits/cast_spr/komasaburo_spr.asm"
INCLUDE "src/scene/credits/cast_spr/mechakkero_spr.asm"
INCLUDE "src/scene/credits/cast_spr/magfly_spr.asm"
INCLUDE "src/scene/credits/cast_spr/giantspringer_spr.asm"
INCLUDE "src/scene/credits/cast_spr/peterchy_spr.asm"
INCLUDE "src/scene/credits/cast_spr/newshotnan_spr.asm"
INCLUDE "src/scene/credits/cast_spr/yambow_spr.asm"
INCLUDE "src/scene/credits/cast_spr/hariharry_spr.asm"
INCLUDE "src/scene/credits/cast_spr/cannon_spr.asm"
INCLUDE "src/scene/credits/cast_spr/telly_spr.asm"
INCLUDE "src/scene/credits/cast_spr/unused_blocky_spr.asm"
INCLUDE "src/scene/credits/cast_spr/pipi_spr.asm"
INCLUDE "src/scene/credits/cast_spr/shotman_spr.asm"
INCLUDE "src/scene/credits/cast_spr/flyboy_spr.asm"
INCLUDE "src/scene/credits/cast_spr/springer_spr.asm"
INCLUDE "src/scene/credits/cast_spr/pierobot_spr.asm"
INCLUDE "src/scene/credits/cast_spr/mole_spr.asm"
INCLUDE "src/scene/credits/cast_spr/robbit_spr.asm"
INCLUDE "src/scene/credits/cast_spr/cook_spr.asm"
INCLUDE "src/scene/credits/cast_spr/batton_spr.asm"
INCLUDE "src/scene/credits/cast_spr/puchigoblin_spr.asm"
INCLUDE "src/scene/credits/cast_spr/scworm_spr.asm"
INCLUDE "src/scene/credits/cast_spr/matasaburo_spr.asm"
INCLUDE "src/scene/credits/cast_spr/kaminarigoro_spr.asm"
INCLUDE "src/scene/credits/cast_spr/crashman_spr.asm"
INCLUDE "src/scene/credits/cast_spr/metalman_spr.asm"
INCLUDE "src/scene/credits/cast_spr/woodman_spr.asm"
INCLUDE "src/scene/credits/cast_spr/airman_spr.asm"
INCLUDE "src/scene/credits/cast_spr/hardman_spr.asm"
INCLUDE "src/scene/credits/cast_spr/topman_spr.asm"
INCLUDE "src/scene/credits/cast_spr/magnetman_spr.asm"
INCLUDE "src/scene/credits/cast_spr/needleman_spr.asm"
INCLUDE "src/scene/credits/cast_spr/quint_spr.asm"

	mIncJunk "L016E46"

; 
; BANK $02 - Actor code
; 
SECTION "bank02", ROMX, BANK[$02]
INCLUDE "src/game/act/act_run.asm"
INCLUDE "src/game/act/expl/expl_sm.asm"
INCLUDE "src/game/act/item/item.asm"
INCLUDE "src/game/act/expl/expl_lg.asm"
INCLUDE "src/game/act/bee/bee.asm"
INCLUDE "src/game/act/bee/beehive.asm"
INCLUDE "src/game/act/bee/chibee.asm"
INCLUDE "src/game/act/wanaan/wanaan.asm"
INCLUDE "src/game/act/hammerjoe/hammerjoe.asm"
INCLUDE "src/game/act/hammerjoe/hammer.asm"
INCLUDE "src/game/act/neomonking/neomonking.asm"
INCLUDE "src/game/act/neomet/neomet.asm"
INCLUDE "src/game/act/pickelmanbull/pickelmanbull.asm"
INCLUDE "src/game/act/bikky/bikky.asm"
INCLUDE "src/game/act/komasaburo/komasaburo.asm"
INCLUDE "src/game/act/komasaburo/koma.asm"
INCLUDE "src/game/act/mechakkero/mechakkero.asm"
INCLUDE "src/game/act/spintop/spintop.asm"
INCLUDE "src/game/act/tama/tama.asm"
INCLUDE "src/game/act/tama/ball.asm"
INCLUDE "src/game/act/tama/flea.asm"
INCLUDE "src/game/act/magfly/magfly.asm"
INCLUDE "src/game/act/giantspringer/giantspringer.asm"
INCLUDE "src/game/act/giantspringer/shot.asm"
INCLUDE "src/game/act/peterchy/peterchy.asm"
INCLUDE "src/game/act/magnetfield/magnetfield.asm"
INCLUDE "src/game/act/respawner/respawner.asm"
INCLUDE "src/game/act/block/block.asm"
INCLUDE "src/game/act/newshotman/newshotman.asm"
INCLUDE "src/game/act/needlepress/needlepress.asm"
INCLUDE "src/game/act/yambow/yambow.asm"
INCLUDE "src/game/act/hariharry/hariharry.asm"
INCLUDE "src/game/act/hariharry/shot.asm"
INCLUDE "src/game/act/cannon/cannon.asm"
INCLUDE "src/game/act/cannon/shot.asm"
INCLUDE "src/game/act/telly/spawner.asm"
INCLUDE "src/game/act/lift/lift.asm"
INCLUDE "src/game/act/blocky/blocky.asm"
INCLUDE "src/game/act/pipi/pipi.asm"
INCLUDE "src/game/act/pipi/egg.asm"
INCLUDE "src/game/act/pipi/copipi.asm"
INCLUDE "src/game/act/shotman/shotman.asm"
INCLUDE "src/game/act/flyboy/flyboy.asm"
INCLUDE "src/game/act/flyboy/spawner.asm"
INCLUDE "src/game/act/springer/springer.asm"
INCLUDE "src/game/act/pierobot/gear.asm"
INCLUDE "src/game/act/pierobot/pierobot.asm"
INCLUDE "src/game/act/mole/mole.asm"
INCLUDE "src/game/act/mole/spawner.asm"
INCLUDE "src/game/act/press/press.asm"
INCLUDE "src/game/act/robbit/robbit.asm"
INCLUDE "src/game/act/robbit/carrot.asm"
INCLUDE "src/game/act/cook/cook.asm"
INCLUDE "src/game/act/cook/spawner.asm"
INCLUDE "src/game/act/batton/batton.asm"
INCLUDE "src/game/act/friender/friender.asm"
INCLUDE "src/game/act/friender/flame.asm"
INCLUDE "src/game/act/goblin/horn.asm"
INCLUDE "src/game/act/goblin/goblin.asm"
INCLUDE "src/game/act/goblin/puchigoblin.asm"
INCLUDE "src/game/act/scworm/base.asm"
INCLUDE "src/game/act/scworm/shot.asm"
INCLUDE "src/game/act/matasaburo/matasaburo.asm"
INCLUDE "src/game/act/kaminarigoro/kaminarigoro.asm"
INCLUDE "src/game/act/kaminarigoro/cloud.asm"
INCLUDE "src/game/act/kaminari/kaminari.asm"
INCLUDE "src/game/act/telly/telly.asm"
INCLUDE "src/game/act/pipi/spawner.asm"
INCLUDE "src/game/act/boss/wily/wily1/wily1.asm"
INCLUDE "src/game/act/boss/wily/wily2/wily2.asm"
INCLUDE "src/game/act/boss/wily/wily3/wily3.asm"
INCLUDE "src/game/act/boss/wily/wilyship.asm"
INCLUDE "src/game/act/boss/quint/quint.asm"
INCLUDE "src/game/act/boss/wily/wily3/part.asm"
INCLUDE "src/game/act/boss/wily/wily2/intro.asm"
INCLUDE "src/game/act/boss/quint/sakugarne.asm"
INCLUDE "src/game/act/boss/quint/debris.asm"
INCLUDE "src/game/act/boss/wily/wily1/bomb.asm"
INCLUDE "src/game/act/boss/wily/wily1/nail.asm"
INCLUDE "src/game/act/boss/wily/wily2/bomb.asm"
INCLUDE "src/game/act/boss/wily/wily2/shot.asm"
INCLUDE "src/game/act/boss/wily/wily3/missile.asm"
INCLUDE "src/game/act/boss/wily/wily3/met.asm"
INCLUDE "src/game/act/boss/wily/wilyctrl.asm"
INCLUDE "src/game/act/rushcoil/rushcoil.asm"
INCLUDE "src/game/act/rushmarine/rushmarine.asm"
INCLUDE "src/game/act/rushjet/rushjet.asm"
INCLUDE "src/game/act/sakugarne/sakugarne.asm"
INCLUDE "src/game/act/_warp/warp.asm"
INCLUDE "src/game/act/bubble/bubble.asm"
INCLUDE "src/game/act/wilycastle/wily.asm"
INCLUDE "src/game/act/teleporter/roomctrl.asm"
INCLUDE "src/game/act/teleporter/light.asm"
INCLUDE "src/game/act/boss/hardman/hardman.asm"
INCLUDE "src/game/act/boss/topman/topman.asm"
INCLUDE "src/game/act/boss/magnetman/magnetman.asm"
INCLUDE "src/game/act/boss/needleman/needleman.asm"
INCLUDE "src/game/act/boss/crashman/crashman.asm"
INCLUDE "src/game/act/boss/metalman/metalman.asm"
INCLUDE "src/game/act/boss/woodman/woodman.asm"
INCLUDE "src/game/act/boss/airman/airman.asm"
INCLUDE "src/game/act/boss/hardman/shot.asm"
INCLUDE "src/game/act/boss/topman/shot.asm"
INCLUDE "src/game/act/boss/magnetman/shot.asm"
INCLUDE "src/game/act/boss/needleman/shot.asm"
INCLUDE "src/game/act/boss/crashman/shot.asm"
INCLUDE "src/game/act/boss/metalman/shot.asm"
INCLUDE "src/game/act/boss/airman/shot.asm"
INCLUDE "src/game/act/boss/woodman/shot.asm"
INCLUDE "src/game/act/boss/crashman/shotexpl.asm"
INCLUDE "src/game/act/wilycastle/groundexpl.asm"
INCLUDE "src/game/act/neomet/shot.asm"
INCLUDE "src/game/act/newshotman/shot.asm"
INCLUDE "src/game/act/shotman/shot.asm"
INCLUDE "src/game/act/_shot/arc_spawn.asm"
; =============== SPREAD SHOTS ===============
; The following subroutines handle spawning shot patterns, all following a similar pattern.
INCLUDE "src/game/act/neomet/shot_spawn.asm"
INCLUDE "src/game/act/tama/flea_spawn.asm"
INCLUDE "src/game/act/hariharry/shot_spawn.asm"
INCLUDE "src/game/act/boss/topman/shot_spawn.asm"
INCLUDE "src/game/act/_shot/sub.asm"
INCLUDE "src/game/act/boss/intro_sub.asm"
INCLUDE "src/game/act/_bg/bgdraw_sub.asm"
	mIncJunk "L027FBA"

; 
; BANK $03 - Actor collision table, Actor & player sprite mappings
; 
SECTION "bank03", ROMX, BANK[$03]
; =============== ACTOR COLLISION TABLE ===============
INCLUDE "src/game/act/coli_tbl.asm"

; =============== ACTOR & PLAYER SPRITE MAPPING POINTERS ===============
INCLUDE "src/game/act/spr_ptr.asm"
INCLUDE "src/game/pl/spr_ptr.asm"
INCLUDE "src/game/act/_null/null_spr_ptr.asm"
INCLUDE "src/game/act/expl/expl_sm_spr_ptr.asm"
INCLUDE "src/game/act/item/extralife_spr_ptr.asm"
INCLUDE "src/game/act/item/ammolg_spr_ptr.asm"
INCLUDE "src/game/act/item/healthlg_spr_ptr.asm"
INCLUDE "src/game/act/item/healthsm_spr_ptr.asm"
INCLUDE "src/game/act/item/ammosm_spr_ptr.asm"
INCLUDE "src/game/act/item/etank_spr_ptr.asm"
INCLUDE "src/game/act/expl/expl_lg_spr_ptr.asm"
INCLUDE "src/game/act/bee/bee_spr_ptr.asm"
INCLUDE "src/game/act/bee/beehive_spr_ptr.asm"
INCLUDE "src/game/act/bee/chibee_spr_ptr.asm"
INCLUDE "src/game/act/bee/wanaan_spr_ptr.asm"
INCLUDE "src/game/act/hammerjoe/hammerjoe_spr_ptr.asm"
INCLUDE "src/game/act/hammerjoe/hammer_spr_ptr.asm"
INCLUDE "src/game/act/neomonking/neomonking_spr_ptr.asm"
INCLUDE "src/game/act/neomet/neomet_spr_ptr.asm"
INCLUDE "src/game/act/pickelmanbull/pickelmanbull_spr_ptr.asm"
INCLUDE "src/game/act/bikky/bikky_spr_ptr.asm"
INCLUDE "src/game/act/komasaburo/komasaburo_spr_ptr.asm"
INCLUDE "src/game/act/komasaburo/koma_spr_ptr.asm"
INCLUDE "src/game/act/mechakkero/mechakkero_spr_ptr.asm"
INCLUDE "src/game/act/spintop/spintop_spr_ptr.asm"
INCLUDE "src/game/act/tama/tama_spr_ptr.asm"
INCLUDE "src/game/act/tama/ball_spr_ptr.asm"
INCLUDE "src/game/act/tama/flea_spr_ptr.asm"
INCLUDE "src/game/act/magfly/magfly_spr_ptr.asm"
INCLUDE "src/game/act/giantspringer/giantspringer_spr_ptr.asm"
INCLUDE "src/game/act/giantspringer/shot_spr_ptr.asm"
INCLUDE "src/game/act/peterchy/peterchy_spr_ptr.asm"
INCLUDE "src/game/act/magnetfield/magnetfield_spr_ptr.asm"
INCLUDE "src/game/act/respawner/respawner_spr_ptr.asm"
INCLUDE "src/game/act/block/block_spr_ptr.asm"
INCLUDE "src/game/act/newshotman/newshotman_spr_ptr.asm"
INCLUDE "src/game/act/needlepress/needlepress_spr_ptr.asm"
INCLUDE "src/game/act/yambow/yambow_spr_ptr.asm"
INCLUDE "src/game/act/hariharry/hariharry_spr_ptr.asm"
INCLUDE "src/game/act/hariharry/shot_spr_ptr.asm"
INCLUDE "src/game/act/cannon/cannon_spr_ptr.asm"
INCLUDE "src/game/act/cannon/shot_spr_ptr.asm"
INCLUDE "src/game/act/telly/spawner_spr_ptr.asm"
INCLUDE "src/game/act/lift/lift_spr_ptr.asm"
INCLUDE "src/game/act/blocky/blocky_spr_ptr.asm"
INCLUDE "src/game/act/pipi/pipi_spr_ptr.asm"
INCLUDE "src/game/act/pipi/egg_spr_ptr.asm"
INCLUDE "src/game/act/pipi/copipi_spr_ptr.asm"
INCLUDE "src/game/act/shotman/shotman_spr_ptr.asm"
INCLUDE "src/game/act/flyboy/flyboy_spr_ptr.asm"
INCLUDE "src/game/act/flyboy/spawner_spr_ptr.asm"
INCLUDE "src/game/act/springer/springer_spr_ptr.asm"
INCLUDE "src/game/act/pierobot/gear_spr_ptr.asm"
INCLUDE "src/game/act/pierobot/pierobot_spr_ptr.asm"
INCLUDE "src/game/act/mole/mole_spr_ptr.asm"
INCLUDE "src/game/act/mole/spawner_spr_ptr.asm"
INCLUDE "src/game/act/press/press_spr_ptr.asm"
INCLUDE "src/game/act/robbit/robbit_spr_ptr.asm"
INCLUDE "src/game/act/robbit/carrot_spr_ptr.asm"
INCLUDE "src/game/act/cook/cook_spr_ptr.asm"
INCLUDE "src/game/act/cook/spawner_spr_ptr.asm"
INCLUDE "src/game/act/batton/batton_spr_ptr.asm"
INCLUDE "src/game/act/friender/friender_spr_ptr.asm"
INCLUDE "src/game/act/friender/flame_spr_ptr.asm"
INCLUDE "src/game/act/goblin/horn_spr_ptr.asm"
INCLUDE "src/game/act/goblin/goblin_spr_ptr.asm"
INCLUDE "src/game/act/goblin/puchigoblin_spr_ptr.asm"
INCLUDE "src/game/act/scworm/base_spr_ptr.asm"
INCLUDE "src/game/act/scworm/shot_spr_ptr.asm"
INCLUDE "src/game/act/matasaburo/matasaburo_spr_ptr.asm"
INCLUDE "src/game/act/kaminarigoro/kaminarigoro_spr_ptr.asm"
INCLUDE "src/game/act/kaminarigoro/cloud_spr_ptr.asm"
INCLUDE "src/game/act/kaminarigoro/kaminari_spr_ptr.asm"
INCLUDE "src/game/act/telly/telly_spr_ptr.asm"
INCLUDE "src/game/act/pipi/spawner_spr_ptr.asm"
INCLUDE "src/game/act/boss/wily/wily1/wily1_spr_ptr.asm"
INCLUDE "src/game/act/boss/wily/wily2/wily2_spr_ptr.asm"
INCLUDE "src/game/act/boss/wily/wily3/wily3_spr_ptr.asm"
INCLUDE "src/game/act/boss/quint/quint_spr_ptr.asm"
INCLUDE "src/game/act/boss/wily/wily3//part_spr_ptr.asm"
INCLUDE "src/game/act/boss/wily/wily2//intro_spr_ptr.asm"
INCLUDE "src/game/act/boss/quint/sakugarne_spr_ptr.asm"
INCLUDE "src/game/act/boss/quint/debris_spr_ptr.asm"
INCLUDE "src/game/act/boss/wily/wily1//bomb_spr_ptr.asm"
INCLUDE "src/game/act/boss/wily/wily1//nail_spr_ptr.asm"
INCLUDE "src/game/act/boss/wily/wily2//bomb_spr_ptr.asm"
INCLUDE "src/game/act/boss/wily/wily2//shot_spr_ptr.asm"
INCLUDE "src/game/act/boss/wily/wily3//missile_spr_ptr.asm"
INCLUDE "src/game/act/boss/wily/wily3//met_spr_ptr.asm"
INCLUDE "src/game/act/boss/wily/wilyship_spr_ptr.asm"
INCLUDE "src/game/act/rushcoil/rushcoil_spr_ptr.asm"
INCLUDE "src/game/act/rushmarine/rushmarine_spr_ptr.asm"
INCLUDE "src/game/act/rushjet/rushjet_spr_ptr.asm"
INCLUDE "src/game/act/sakugarne/sakugarne_spr_ptr.asm"
INCLUDE "src/game/act/bubble/bubble_spr_ptr.asm"
INCLUDE "src/game/act/wilycastle/wily_spr_ptr.asm"
INCLUDE "src/game/act/teleporter/roomctrl_spr_ptr.asm"
INCLUDE "src/game/act/teleporter/light_spr_ptr.asm"
INCLUDE "src/game/act/boss/hardman/hardman_spr_ptr.asm"
INCLUDE "src/game/act/boss/topman/topman_spr_ptr.asm"
INCLUDE "src/game/act/boss/magnetman/magnetman_spr_ptr.asm"
INCLUDE "src/game/act/boss/needleman/needleman_spr_ptr.asm"
INCLUDE "src/game/act/boss/crashman/crashman_spr_ptr.asm"
INCLUDE "src/game/act/boss/metalman/metalman_spr_ptr.asm"
INCLUDE "src/game/act/boss/woodman/woodman_spr_ptr.asm"
INCLUDE "src/game/act/boss/airman/airman_spr_ptr.asm"
INCLUDE "src/game/act/boss/hardman/shot_spr_ptr.asm"
INCLUDE "src/game/act/boss/topman/shot_spr_ptr.asm"
INCLUDE "src/game/act/boss/magnetman/shot_spr_ptr.asm"
INCLUDE "src/game/act/boss/needleman/shot_spr_ptr.asm"
INCLUDE "src/game/act/boss/crashman/shot_spr_ptr.asm"
INCLUDE "src/game/act/boss/metalman/shot_spr_ptr.asm"
INCLUDE "src/game/act/boss/airman/shot_spr_ptr.asm"
INCLUDE "src/game/act/boss/woodman/shot_spr_ptr.asm"
INCLUDE "src/game/act/boss/crashman/shotexpl_spr_ptr.asm"
INCLUDE "src/game/act/wilycastle/groundexpl_spr_ptr.asm"
INCLUDE "src/game/act/_shot/shot_spr_ptr.asm"

; =============== ACTOR & PLAYER SPRITE MAPPINGS ===============
INCLUDE "src/game/act/_null/null_spr.asm"
INCLUDE "src/game/act/expl/expl_spr.asm"
INCLUDE "src/game/act/item/extralife_spr.asm"
INCLUDE "src/game/act/item/ammolg_spr.asm"
INCLUDE "src/game/act/item/healthlg_spr.asm"
INCLUDE "src/game/act/item/healthsm_spr.asm"
INCLUDE "src/game/act/item/ammosm_spr.asm"
INCLUDE "src/game/act/item/etank_spr.asm"
INCLUDE "src/game/act/bee/bee_spr.asm"
INCLUDE "src/game/act/bee/beehive_spr.asm"
INCLUDE "src/game/act/bee/chibee_spr.asm"
INCLUDE "src/game/act/wanaan/wanaan_spr.asm"
INCLUDE "src/game/act/hammerjoe/hammerjoe_spr.asm"
INCLUDE "src/game/act/hammerjoe/hammer_spr.asm"
INCLUDE "src/game/act/neomonking/neomonking_spr.asm"
INCLUDE "src/game/act/neomet/neomet_spr.asm"
INCLUDE "src/game/act/pickelmanbull/pickelmanbull_spr.asm"
INCLUDE "src/game/act/bikky/bikky_spr.asm"
INCLUDE "src/game/act/komasaburo/komasaburo_spr.asm"
INCLUDE "src/game/act/komasaburo/koma_spr.asm"
INCLUDE "src/game/act/mechakkero/mechakkero_spr.asm"
INCLUDE "src/game/act/spintop/spintop_spr.asm"
INCLUDE "src/game/act/tama/tama_spr.asm"
INCLUDE "src/game/act/tama/ball_spr.asm"
INCLUDE "src/game/act/tama/flea_spr.asm"
INCLUDE "src/game/act/magfly/magfly_spr.asm"
INCLUDE "src/game/act/giantspringer/giantspringer_spr.asm"
INCLUDE "src/game/act/giantspringer/shot_spr.asm"
INCLUDE "src/game/act/peterchy/peterchy_spr.asm"
INCLUDE "src/game/act/magnetfield/magnetwave_spr.asm"
INCLUDE "src/game/act/block/block_spr.asm"
INCLUDE "src/game/act/newshotman/newshotman_spr.asm"
INCLUDE "src/game/act/needlepress/needlepress_spr.asm"
INCLUDE "src/game/act/yambow/yambow_spr.asm"
INCLUDE "src/game/act/hariharry/hariharry_spr.asm"
INCLUDE "src/game/act/hariharry/shot_spr.asm"
INCLUDE "src/game/act/cannon/cannon_spr.asm"
INCLUDE "src/game/act/cannon/shot_spr.asm"
INCLUDE "src/game/act/telly/telly_spr.asm"
INCLUDE "src/game/act/lift/lift_spr.asm"
INCLUDE "src/game/act/blocky/blocky_spr.asm"
INCLUDE "src/game/act/pipi/pipi_spr.asm"
INCLUDE "src/game/act/pipi/copipi_spr.asm"
INCLUDE "src/game/act/pipi/egg_spr.asm"
INCLUDE "src/game/act/shotman/shotman_spr.asm"
INCLUDE "src/game/act/flyboy/flyboy_spr.asm"
INCLUDE "src/game/act/springer/springer_spr.asm"
INCLUDE "src/game/act/pierobot/gear_spr.asm"
INCLUDE "src/game/act/pierobot/pierobot_spr.asm"
INCLUDE "src/game/act/mole/mole_spr.asm"
INCLUDE "src/game/act/press/press_spr.asm"
INCLUDE "src/game/act/robbit/robbit_spr.asm"
INCLUDE "src/game/act/robbit/carrot_spr.asm"
INCLUDE "src/game/act/cook/cook_spr.asm"
INCLUDE "src/game/act/batton/batton_spr.asm"
INCLUDE "src/game/act/friender/friender_spr.asm"
INCLUDE "src/game/act/friender/flame_spr.asm"
INCLUDE "src/game/act/goblin/horn_spr.asm"
INCLUDE "src/game/act/goblin/puchigoblin_spr.asm"
INCLUDE "src/game/act/scworm/base_spr.asm"
INCLUDE "src/game/act/scworm/shot_spr.asm"
INCLUDE "src/game/act/matasaburo/matasaburo_spr.asm"
INCLUDE "src/game/act/kaminarigoro/kaminarigoro_spr.asm"
INCLUDE "src/game/act/kaminarigoro/cloud_spr.asm"
INCLUDE "src/game/act/kaminarigoro/kaminari_spr.asm"
INCLUDE "src/game/act/boss/wily/wilyship_spr.asm"
INCLUDE "src/game/act/boss/wily/wily1/wily1_spr.asm"
INCLUDE "src/game/act/boss/wily/wily2/wily2_spr.asm"
INCLUDE "src/game/act/boss/wily/wily3/wily3_spr.asm"
INCLUDE "src/game/act/boss/wily/bomb_spr.asm"
INCLUDE "src/game/act/boss/wily/wily1/nail_spr.asm"
INCLUDE "src/game/act/boss/wily/wily2/bombproj_spr.asm"
INCLUDE "src/game/act/boss/wily/wily2/shot_spr.asm"
INCLUDE "src/game/act/boss/wily/wily3/missile_spr.asm"
INCLUDE "src/game/act/boss/wily/wily3/met_spr.asm"
INCLUDE "src/game/act/boss/quint/quint_spr.asm"
INCLUDE "src/game/act/boss/quint/sakugarne_spr.asm"
INCLUDE "src/game/act/boss/quint/debris_spr.asm"
INCLUDE "src/game/act/rushcoil/rushcoil_spr.asm"
INCLUDE "src/game/act/rushmarine/rushmarine_spr.asm"
INCLUDE "src/game/act/rushjet/rushjet_spr.asm"
INCLUDE "src/game/act/sakugarne/sakugarne_spr.asm"
INCLUDE "src/game/act/bubble/bubble_spr.asm"
INCLUDE "src/game/act/_warp/warp_spr.asm"
INCLUDE "src/game/act/wilycastle/wily_spr.asm"
INCLUDE "src/game/act/teleporter/light_spr.asm"
INCLUDE "src/game/act/boss/hardman/hardman_spr.asm"
INCLUDE "src/game/act/boss/topman/topman_spr.asm"
INCLUDE "src/game/act/boss/magnetman/magnetman_spr.asm"
INCLUDE "src/game/act/boss/needleman/needleman_spr.asm"
INCLUDE "src/game/act/boss/crashman/crashman_spr.asm"
INCLUDE "src/game/act/boss/metalman/metalman_spr.asm"
INCLUDE "src/game/act/boss/woodman/woodman_spr.asm"
INCLUDE "src/game/act/boss/airman/airman_spr.asm"
INCLUDE "src/game/act/boss/hardman/shot_spr.asm"
INCLUDE "src/game/act/boss/topman/shot_spr.asm"
INCLUDE "src/game/act/boss/magnetman/shot_spr.asm"
INCLUDE "src/game/act/boss/needleman/shot_spr.asm"
INCLUDE "src/game/act/boss/crashman/shot_spr.asm"
INCLUDE "src/game/act/boss/metalman/shot_spr.asm"
INCLUDE "src/game/act/boss/woodman/shot_spr.asm"
INCLUDE "src/game/act/boss/airman/shot_spr.asm"
INCLUDE "src/game/act/_shot/shot_spr.asm"
INCLUDE "src/game/act/boss/crashman/shotexpl_spr.asm"
INCLUDE "src/game/act/wilycastle/groundexpl_spr.asm"
INCLUDE "src/game/pl/pl_spr.asm"

	mIncJunk "L037908"

; 
; BANK $04 - Tilemaps
; 
SECTION "bank04", ROMX, BANK[$04]
; Game title changed in the US version.
IF REV_VER == VER_JP
TilemapDef_Title: INCLUDE "src/title/title_jp_bg.asm"
	mIncJunk "L0440FE"
ELSE
TilemapDef_Title: INCLUDE "src/title/title_us_bg.asm"
	mIncJunk "us/L044143"
ENDC
TilemapDef_StageSel: INCLUDE "src/stagesel/stagesel_bg.asm"
	mIncJunk "L04512D"
TilemapDef_GetWpn: INCLUDE "src/getwpn/getwpn_bg.asm"
	mIncJunk "L0453B9"
TilemapDef_WilyCastle: INCLUDE "src/scene/castle/wilycastle_bg.asm"
	mIncJunk "L045513"
TilemapDef_WilyStation: INCLUDE "src/scene/station/wilystation_bg.asm"
	mIncJunk "L0456DF"


; 
; BANK $05 - Level Data
; 
SECTION "bank05", ROMX, BANK[$05]
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
	INCLUDE "src/game/lvl/hard/locks.asm"
	INCLUDE "src/game/lvl/top/locks.asm"
	INCLUDE "src/game/lvl/magnet/locks.asm"
	INCLUDE "src/game/lvl/needle/locks.asm"
	INCLUDE "src/game/lvl/crash/locks.asm"
	INCLUDE "src/game/lvl/metal/locks.asm"
	INCLUDE "src/game/lvl/wood/locks.asm"
	INCLUDE "src/game/lvl/air/locks.asm"
	INCLUDE "src/game/lvl/castle/locks.asm"
	INCLUDE "src/game/lvl/station/locks.asm"

	mIncJunk "L05411A"

; =============== Lvl_RoomTrsUTbl ===============
; Room transitions, above.
Lvl_RoomTrsUTbl:
	INCLUDE "src/game/lvl/hard/trs_u.asm"
	INCLUDE "src/game/lvl/top/trs_u.asm"
	INCLUDE "src/game/lvl/magnet/trs_u.asm"
	INCLUDE "src/game/lvl/needle/trs_u.asm"
	INCLUDE "src/game/lvl/crash/trs_u.asm"
	INCLUDE "src/game/lvl/metal/trs_u.asm"
	INCLUDE "src/game/lvl/wood/trs_u.asm"
	INCLUDE "src/game/lvl/air/trs_u.asm"
	INCLUDE "src/game/lvl/castle/trs_u.asm"
	INCLUDE "src/game/lvl/station/trs_u.asm"
	; [POI] For what's worth, the padding area starts with a single $01.
	mIncJunk "L05427A"
	
; =============== Lvl_RoomTrsDTbl ===============
; Room transitions, below.
Lvl_RoomTrsDTbl:
	INCLUDE "src/game/lvl/hard/trs_d.asm"
	INCLUDE "src/game/lvl/top/trs_d.asm"
	INCLUDE "src/game/lvl/magnet/trs_d.asm"
	INCLUDE "src/game/lvl/needle/trs_d.asm"
	INCLUDE "src/game/lvl/crash/trs_d.asm"
	INCLUDE "src/game/lvl/metal/trs_d.asm"
	INCLUDE "src/game/lvl/wood/trs_d.asm"
	INCLUDE "src/game/lvl/air/trs_d.asm"
	INCLUDE "src/game/lvl/castle/trs_d.asm"
	INCLUDE "src/game/lvl/station/trs_d.asm"
	; [POI] This also starts out with a $01.
	mIncJunk "L0543FA"
	
; =============== LEVEL LAYOUTS ===============
LvlLayout_Hard: INCBIN "src/game/lvl/hard/layout.rle"
LvlLayout_Top: INCBIN "src/game/lvl/top/layout.rle"
LvlLayout_Magnet: INCBIN "src/game/lvl/magnet/layout.rle"
LvlLayout_Needle: INCBIN "src/game/lvl/needle/layout.rle"
LvlLayout_Crash: INCBIN "src/game/lvl/crash/layout.rle"
LvlLayout_Metal: INCBIN "src/game/lvl/metal/layout.rle"
LvlLayout_Wood: INCBIN "src/game/lvl/wood/layout.rle"
LvlLayout_Air: INCBIN "src/game/lvl/air/layout.rle"
LvlLayout_Castle: INCBIN "src/game/lvl/castle/layout.rle"
LvlLayout_Station: INCBIN "src/game/lvl/station/layout.rle"

	mIncJunk "L05748F"
	
; =============== 16x16 BLOCK DEFINITIONS ===============
Lvl_BlockTbl: 
BlockLayout_Hard: INCBIN "src/game/lvl/hard/block16.bin"
BlockLayout_Top: INCBIN "src/game/lvl/top/block16.bin"
BlockLayout_Magnet: INCBIN "src/game/lvl/magnet/block16.bin"
BlockLayout_Needle: INCBIN "src/game/lvl/needle/block16.bin"
BlockLayout_Crash: INCBIN "src/game/lvl/crash/block16.bin"
BlockLayout_Metal: INCBIN "src/game/lvl/metal/block16.bin"
BlockLayout_Wood: INCBIN "src/game/lvl/wood/block16.bin"
BlockLayout_Air: INCBIN "src/game/lvl/air/block16.bin"
BlockLayout_Castle: INCBIN "src/game/lvl/castle/block16.bin"
BlockLayout_Station: INCBIN "src/game/lvl/station/block16.bin"


; 
; BANK $06 - N/A
; 
SECTION "bank06", ROMX, BANK[$06]
mFillBank

; 
; BANK $07 - Sound Driver
; 
SECTION "bank07", ROMX, BANK[$07]
INCLUDE "driver/main.asm"

; 
; BANK $08 - Level & actor graphics
; 
SECTION "bank08", ROMX, BANK[$08]
GFX_ActLvlHard: INCBIN "src/game/lvl/hard/act_gfx.bin"
GFX_Bikky: INCBIN "src/game/act/bikky/bikky_gfx.bin"
GFX_ActLvlTop: INCBIN "src/game/lvl/top/act_gfx.bin"
GFX_ActLvlMagnet: INCBIN "src/game/lvl/magnet/act_gfx.bin"
GFX_MagnetMan: INCBIN "src/game/act/boss/magnetman/magnetman_gfx.bin"
GFX_ActLvlNeedle: INCBIN "src/game/lvl/needle/act_gfx.bin"
GFX_NeedleMan: INCBIN "src/game/act/boss/needleman/needleman_gfx.bin"
GFX_ActLvlCrash: INCBIN "src/game/lvl/crash/act_gfx.bin"


; 
; BANK $09 - Level & actor graphics
; 
SECTION "bank09", ROMX, BANK[$09]
GFX_CrashMan: INCBIN "src/game/act/boss/crashman/crashman_gfx.bin"
GFX_ActLvlMetal: INCBIN "src/game/lvl/metal/act_gfx.bin"
GFX_MetalMan: INCBIN "src/game/act/boss/metalman/metalman_gfx.bin"
GFX_ActLvlWood: INCBIN "src/game/lvl/wood/act_gfx.bin"
GFX_WoodMan: INCBIN "src/game/act/boss/woodman/woodman_gfx.bin"
GFX_ActLvlAir: INCBIN "src/game/lvl/air/act_gfx.bin"
GFX_AirMan: INCBIN "src/game/act/boss/airman/airman_gfx.bin"
GFX_SmallFont: INCBIN "src/font/smallfont_gfx.bin"
	mIncJunk "L097A00"
GFX_LvlHard: INCBIN "src/game/lvl/hard/bg_gfx.bin"


; 
; BANK $0A - Level graphics, Misc graphics
; 
SECTION "bank0A", ROMX, BANK[$0A]
GFX_LvlTop: INCBIN "src/game/lvl/top/bg_gfx.bin"
GFX_LvlMagnet: INCBIN "src/game/lvl/magnet/bg_gfx.bin"
GFX_LvlNeedle: INCBIN "src/game/lvl/needle/bg_gfx.bin"
GFX_LvlCrash: INCBIN "src/game/lvl/crash/bg_gfx.bin"
GFX_LvlMetal: INCBIN "src/game/lvl/metal/bg_gfx.bin"
GFX_LvlWood: INCBIN "src/game/lvl/wood/bg_gfx.bin"
GFX_LvlAir: INCBIN "src/game/lvl/air/bg_gfx.bin"
GFX_LvlStation: INCBIN "src/game/lvl/station/bg_gfx.bin"
; Game title changed in the US version.
IF REV_VER == VER_JP
GFX_Title: INCBIN "src/title/title_jp_gfx.bin"
ELSE
GFX_Title: INCBIN "src/title/title_us_gfx.bin"
ENDC
GFX_Password: INCBIN "src/password/password_gfx.bin"
GFX_TitleDots: INCBIN "src/title/dots_gfx.bin"
GFX_TitleCursor: INCBIN "src/title/cursor_gfx.bin"
GFX_StageSel: INCBIN "src/stagesel/stagesel_gfx.bin"
GFX_Pause: INCBIN "src/game/pause_gfx.bin"
GFX_BgShared: INCBIN "src/game/sharedbg_gfx.bin"
	mIncJunk "L0A7D00"
GFX_Unused_HexFont: INCBIN "src/font/unused_hexfont_gfx.bin"


; 
; BANK $0B - Player & weapon graphics, Actor graphics, Misc graphics
; 
SECTION "bank0B", ROMX, BANK[$0B]
GFX_Player: INCBIN "src/game/pl/pl_gfx.bin"

; =============== WEAPON ART SETS ===============
; Sets of weapon graphics, each 16 tiles large.
; Only one can be loaded at a time.
Marker_GFX_Wpn:
GFX_Wpn_RcWdHa: INCBIN "src/game/wpn/rc/rc_wd_ha_gfx.bin"
GFX_Wpn_Rm: INCBIN "src/game/wpn/rm/rm_gfx.bin"
GFX_Wpn_Rj: INCBIN "src/game/wpn/rj/rj_gfx.bin"
GFX_Wpn_Tp: INCBIN "src/game/wpn/tp/tp_gfx.bin"
GFX_Wpn_SgRide: INCBIN "src/game/wpn/sg/sg_ride_gfx.bin"
GFX_Wpn_SgCr: INCBIN "src/game/wpn/sg/sg_cr_gfx.bin"
GFX_Wpn_Ar: INCBIN "src/game/wpn/ar/ar_gfx.bin"
GFX_Wpn_MeNe: INCBIN "src/game/wpn/me/me_ne_gfx.bin"

GFX_Quint: INCBIN "src/game/act/boss/quint/quint_gfx.bin"
GFX_GetWpn: INCBIN "src/getwpn/getwpn_gfx.bin"
GFX_LvlCastle: INCBIN "src/game/lvl/castle/bg_gfx.bin"
GFX_Wily: INCBIN "src/game/act/boss/wily/wily_gfx.bin"
GFX_StageSel_Unused_Pics: INCBIN "src/stagesel/unused_pics_gfx.bin"
GFX_Credits: INCBIN "src/scene/credits/credits_gfx.bin"
GFX_NormalFont: INCBIN "src/font/normalfont_gfx.bin"
GFX_Unused_ShadedFont: INCBIN "src/font/unused_shadedfont_gfx.bin"



; 
; BANK $0C - Actor graphics, Cutscene graphics
; 
SECTION "bank0C", ROMX, BANK[$0C]
GFX_WilyCastle: INCBIN "src/scene/castle/wilycastle_gfx.bin"
GFX_WilyStation: INCBIN "src/scene/station/wilystation_gfx.bin"
GFX_Space: INCBIN "src/scene/_space/space_gfx.bin"
GFX_SpaceOBJ: INCBIN "src/scene/_space/space_obj_gfx.bin"
GFX_HardMan: INCBIN "src/game/act/boss/hardman/hardman_gfx.bin"
GFX_TopMan: INCBIN "src/game/act/boss/topman/topman_gfx.bin"

; 
; BANK $0D - N/A
; 
SECTION "bank0D", ROMX, BANK[$0D]
mFillBank

; 
; BANK $0E - N/A
; 
SECTION "bank0E", ROMX, BANK[$0E]
mFillBank

; 
; BANK $0F - N/A
; 
SECTION "bank0F", ROMX, BANK[$0F]
mFillBank
