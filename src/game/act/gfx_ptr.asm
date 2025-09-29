; =============== ActS_GFXSetTbl ===============
; Sets of actor graphics usable during levels.
; These each set has a fixed size of $800 bytes.
MACRO mGfxDef2
	db BANK(\1), HIGH(\1)
ENDM
ActS_GFXSetTbl:
	mGfxDef2 GFX_Player       ; $00 ; ACTGFX_PLAYER    ; 
	mGfxDef2 GFX_Wpn_RcWdHa   ; $01 ; ACTGFX_SPACE1    ; [POI] Only loaded manually by LoadGFX_Space, not through here.
	mGfxDef2 GFX_ActLvlHard   ; $02 ; ACTGFX_LVLHARD   ; 
	mGfxDef2 GFX_Bikky        ; $03 ; ACTGFX_BIKKY     ; 
	mGfxDef2 GFX_ActLvlTop    ; $04 ; ACTGFX_LVLTOP    ; 
	mGfxDef2 GFX_ActLvlMagnet ; $05 ; ACTGFX_LVLMAGNET ; 
	mGfxDef2 GFX_MagnetMan    ; $06 ; ACTGFX_MAGNETMAN ; 
	mGfxDef2 GFX_ActLvlNeedle ; $07 ; ACTGFX_LVLNEEDLE ; 
	mGfxDef2 GFX_NeedleMan    ; $08 ; ACTGFX_NEEDLEMAN ; 
	mGfxDef2 GFX_ActLvlCrash  ; $09 ; ACTGFX_LVLCRASH  ; 
	mGfxDef2 GFX_CrashMan     ; $0A ; ACTGFX_CRASHMAN  ; 
	mGfxDef2 GFX_ActLvlMetal  ; $0B ; ACTGFX_LVLMETAL  ; 
	mGfxDef2 GFX_MetalMan     ; $0C ; ACTGFX_METALMAN  ; 
	mGfxDef2 GFX_ActLvlWood   ; $0D ; ACTGFX_LVLWOOD   ; 
	mGfxDef2 GFX_WoodMan      ; $0E ; ACTGFX_WOODMAN   ; 
	mGfxDef2 GFX_ActLvlAir    ; $0F ; ACTGFX_LVLAIR    ; 
	mGfxDef2 GFX_AirMan       ; $10 ; ACTGFX_AIRMAN    ; 
	mGfxDef2 GFX_Wily         ; $11 ; ACTGFX_WILY0     ;
	mGfxDef2 GFX_Wily         ; $12 ; ACTGFX_WILY1     ; [POI] Clone of the above 
	mGfxDef2 GFX_Quint        ; $13 ; ACTGFX_QUINT     ; 
	mGfxDef2 GFX_HardMan      ; $14 ; ACTGFX_HARDMAN   ; 
	mGfxDef2 GFX_TopMan       ; $15 ; ACTGFX_TOPMAN    ;
	
