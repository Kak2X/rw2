; =============== Credits_CastGfxSetTbl ===============
; Maps each entry in the cast roll to its art set.
Credits_CastGfxSetTbl:
	db ACTGFX_LVLHARD    ; Bee
	db ACTGFX_LVLHARD    ; Chibee
	db ACTGFX_LVLHARD    ; Wanaan
	db ACTGFX_LVLHARD    ; HammerJoe
	db ACTGFX_LVLHARD    ; NeoMonking
	db ACTGFX_LVLNEEDLE  ; NeoMet
	db ACTGFX_LVLTOP     ; Komasaburo
	db ACTGFX_LVLTOP     ; Mechakkero
	db ACTGFX_LVLMAGNET  ; MagFly
	db ACTGFX_LVLMAGNET  ; GiantSpringer
	db ACTGFX_LVLMAGNET  ; Peterchy
	db ACTGFX_LVLMAGNET  ; NewShotnan
	db ACTGFX_LVLNEEDLE  ; Yambow
	db ACTGFX_LVLNEEDLE  ; HariHarry
	db ACTGFX_LVLNEEDLE  ; Cannon
	db ACTGFX_LVLCRASH   ; Telly
	db ACTGFX_LVLCRASH   ; Pipi
	db ACTGFX_LVLCRASH   ; ShotMan
	db ACTGFX_LVLCRASH   ; FlyBoy
	db ACTGFX_LVLMETAL   ; Springer
	db ACTGFX_LVLMETAL   ; PieroBot
	db ACTGFX_LVLMETAL   ; Mole
	db ACTGFX_LVLWOOD    ; Robbit
	db ACTGFX_LVLWOOD    ; Cook
	db ACTGFX_LVLWOOD    ; Batton
	db ACTGFX_LVLAIR     ; PuchiGoblin
	db ACTGFX_LVLAIR     ; Scworm
	db ACTGFX_LVLAIR     ; Matasaburo
	db ACTGFX_LVLAIR     ; KaminariGoro
	db ACTGFX_CRASHMAN   ; CrashMan
	db ACTGFX_METALMAN   ; MetalMan
	db ACTGFX_WOODMAN    ; WoodMan
	db ACTGFX_AIRMAN     ; AirMan
	db ACTGFX_HARDMAN    ; HardMan
	db ACTGFX_TOPMAN     ; TopMan
	db ACTGFX_MAGNETMAN  ; MagnetMan
	db ACTGFX_NEEDLEMAN  ; NeedleMan
	db ACTGFX_QUINT      ; Quint
.end: ; [POI] Dummy unused entries
	db ACTGFX_LVLHARD
	db ACTGFX_LVLHARD
	db ACTGFX_LVLHARD
	db ACTGFX_LVLHARD
	db ACTGFX_LVLHARD
	db ACTGFX_LVLHARD
	db ACTGFX_LVLHARD
	
; =============== SprMapPtrTbl_Credits_CastPic ===============
; Sprite mappings used for the enemies in the cast roll.
; Goes without saying, these are separate from the ones used during gameplay.
SprMapPtrTbl_Credits_CastPic:
	dw SprMap_Cast_Bee
	dw SprMap_Cast_Chibee
	dw SprMap_Cast_Wanaan
	dw SprMap_Cast_HammerJoe
	dw SprMap_Cast_NeoMonking
	dw SprMap_Cast_NeoMet
	dw SprMap_Cast_Komasaburo
	dw SprMap_Cast_Mechakkero
	dw SprMap_Cast_MagFly
	dw SprMap_Cast_GiantSpringer
	dw SprMap_Cast_Peterchy
	dw SprMap_Cast_NewShotnan
	dw SprMap_Cast_Yambow
	dw SprMap_Cast_HariHarry
	dw SprMap_Cast_Cannon
	dw SprMap_Cast_Telly
	dw SprMap_Cast_Pipi
	dw SprMap_Cast_ShotMan
	dw SprMap_Cast_FlyBoy
	dw SprMap_Cast_Springer
	dw SprMap_Cast_PieroBot
	dw SprMap_Cast_Mole
	dw SprMap_Cast_Robbit
	dw SprMap_Cast_Cook
	dw SprMap_Cast_Batton
	dw SprMap_Cast_PuchiGoblin
	dw SprMap_Cast_Scworm
	dw SprMap_Cast_Matasaburo
	dw SprMap_Cast_KaminariGoro
	dw SprMap_Cast_CrashMan
	dw SprMap_Cast_MetalMan
	dw SprMap_Cast_WoodMan
	dw SprMap_Cast_AirMan
	dw SprMap_Cast_HardMan
	dw SprMap_Cast_TopMan
	dw SprMap_Cast_MagnetMan
	dw SprMap_Cast_NeedleMan
	dw SprMap_Cast_Quint
	
	mIncJunk "L016618"

; =============== Credits_CastTextPtrTbl ===============
; Enemy names for the cast roll.
MACRO mCastStr
	db $60|\1 ; Left padding, in tiles. The $60 marker doesn't have any effect.
	db \2     ; String
	db "\0"   ; Terminator
ENDM
Credits_CastTextPtrTbl:
	dw Str_Bee
	dw Str_Chibee
	dw Str_Wanaan
	dw Str_HammerJoe
	dw Str_NeoMonking
	dw Str_NeoMet
	dw Str_Komasaburo
	dw Str_Mechakkero
	dw Str_MagFly
	dw Str_GiantSpringer
	dw Str_Peterchy
	dw Str_NewShotnan
	dw Str_Yambow
	dw Str_HariHarry
	dw Str_Cannon
	dw Str_Telly
	dw Str_Pipi
	dw Str_ShotMan
	dw Str_FlyBoy
	dw Str_Springer
	dw Str_PieroBot
	dw Str_Mole
	dw Str_Robbit
	dw Str_Cook
	dw Str_Batton
	dw Str_PuchiGoblin
	dw Str_Scworm
	dw Str_Matasaburo
	dw Str_KaminariGoro
	dw Str_CrashMan
	dw Str_MetalMan
	dw Str_WoodMan
	dw Str_AirMan
	dw Str_HardMan
	dw Str_TopMan
	dw Str_MagnetMan
	dw Str_NeedleMan
	dw Str_Quint
	
SETCHARMAP credits
Str_Bee:           mCastStr $07, "HAVE'SU'BEE"
Str_Chibee:        mCastStr $08, "CHIBEE"
Str_Wanaan:        mCastStr $08, "WANAAAN"
Str_HammerJoe:     mCastStr $08, "HAMMER\nJOE"
Str_NeoMonking:    mCastStr $06, "KAETTEKITA\nMONKING"
Str_NeoMet:        mCastStr $08, "METALL"
Str_Komasaburo:    mCastStr $07, "KOMASABURO"
Str_Mechakkero:    mCastStr $09, "MECHA\nKERO"
Str_MagFly:        mCastStr $08, "MAG FLY"
Str_GiantSpringer: mCastStr $07, "G.SPRINGER"
Str_Peterchy:      mCastStr $07, "PETERCHY"
Str_NewShotnan:    mCastStr $08, "NEW\nSHOTMAN"
Str_Yambow:        mCastStr $09, "YAMBO"
Str_HariHarry:     mCastStr $06, "HARI HARRY"
Str_Cannon:        mCastStr $08, "HOUDAI"
Str_Telly:         mCastStr $09, "TELLY"
Str_Pipi:          mCastStr $09, "PIPI"
Str_ShotMan:       mCastStr $08, "SHOTMAN"
Str_FlyBoy:        mCastStr $08, "FLY BOY"
Str_Springer:      mCastStr $08, "SPRINGER"
Str_PieroBot:      mCastStr $07, "PIEROBOT"
Str_Mole:          mCastStr $09, "MOLE"
Str_Robbit:        mCastStr $08, "ROBBIT"
Str_Cook:          mCastStr $09, "COOK"
Str_Batton:        mCastStr $08, "BATTON"
Str_PuchiGoblin:   mCastStr $09, "PUTI\nGOBLIN"
Str_Scworm:        mCastStr $08, "SCWORM"
Str_Matasaburo:    mCastStr $06, "MATASABURO"
Str_KaminariGoro:  mCastStr $08, "KAMINARI\nGORO"
Str_CrashMan:      mCastStr $07, "CLASHMAN"
Str_MetalMan:      mCastStr $07, "METALMAN"
Str_WoodMan:       mCastStr $08, "WOODMAN"
Str_AirMan:        mCastStr $08, "AIRMAN"
Str_HardMan:       mCastStr $08, "HARDMAN"
Str_TopMan:        mCastStr $08, "TOPMAN"
Str_MagnetMan:     mCastStr $07, "MAGNETMAN"
Str_NeedleMan:     mCastStr $07, "NEEDLEMAN"
Str_Quint:         mCastStr $09, "QUINT"