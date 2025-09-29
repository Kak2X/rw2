; =============== Pause_WpnGfxPtrTbl ===============
; Maps each weapon to its graphics.
;
; Specifically, it maps the selected weapon (wWpnId/WPN_*) to the high byte of a pointer to a weapon art set.
; These sets of graphics are all in BANK $0B, are all $100 bytes long, and are all aligned to a $100 byte boundary,
; making their low byte always be $00.
;
; To save space, graphics for multiple weapons may be stored into the same art set.
Pause_WpnGfxPtrTbl:
	db HIGH(GFX_Player+$500)	; WPN_P  ; [POI] This could point anywhere, it doesn't matter. It points to a completely blank area inside GFX_Player.
	db HIGH(GFX_Wpn_RcWdHa)		; WPN_RC
	db HIGH(GFX_Wpn_Rm) 		; WPN_RM
	db HIGH(GFX_Wpn_Rj) 		; WPN_RJ
	db HIGH(GFX_Wpn_Tp) 		; WPN_TP
	db HIGH(GFX_Wpn_Ar) 		; WPN_AR
	db HIGH(GFX_Wpn_RcWdHa)		; WPN_WD
	db HIGH(GFX_Wpn_MeNe)		; WPN_ME
	db HIGH(GFX_Wpn_SgCr)		; WPN_CR
	db HIGH(GFX_Wpn_MeNe)		; WPN_NE
	db HIGH(GFX_Wpn_RcWdHa)		; WPN_HA
	db HIGH(GFX_Wpn_Ar)			; WPN_MG
	db HIGH(GFX_Wpn_SgCr)		; WPN_SG (wWpnSGRide = $00)
	db HIGH(GFX_Wpn_SgRide)		; WPN_SG (wWpnSGRide = $01)