; =============== Wpn_ShootTypeTbl ===============
; Shooting animations used by the player for each weapon.
Wpn_ShootTypeTbl: 
	db PSA_SHOOT ; WPN_P  
	db PSA_SHOOT ; WPN_RC 
	db PSA_SHOOT ; WPN_RM 
	db PSA_SHOOT ; WPN_RJ 
	db PSA_NONE  ; WPN_TP 
	db PSA_THROW ; WPN_AR 
	db PSA_NONE  ; WPN_WD 
	db PSA_THROW ; WPN_ME ; [TCRF] The correct value, unreferenced because for some reason the Metal Blade ctrl code doesn't go through WpnCtrlS_StartShootAnim
	db PSA_THROW ; WPN_CR 
	db PSA_SHOOT ; WPN_NE 
	db PSA_SHOOT ; WPN_HA 
	db PSA_SHOOT ; WPN_MG 
	db PSA_SHOOT ; WPN_SG 

; =============== Wpn_PropTbl ===============
; Weapon properties table, indexed by weapon ID.
; Each entry is 4 bytes long.
;
; FORMAT
; - 0: Collision box, horizontal radius (origin: center)
; - 1: Collision box, vertical radius (origin: center)
; - 2: Ammo cost, out of $98.
;      Most weapons use up ammo (ie: call WpnS_UseAmmo) when firing them, but nothing 
;      prevents you from using different logic, which a few of the weapons do.
; - 3: "Piercing level" of the current weapon (WPNPIERCE_*)
Wpn_PropTbl:
	;  H    V   COST  PIERCE LEVEL      ; ID     ; Use ammo when...
	db $02, $02, $00, WPNPIERCE_NONE    ; WPN_P  ; N/A
	db $02, $02, $18, WPNPIERCE_NONE    ; WPN_RC ; Jumping on it
	db $02, $02, $01, WPNPIERCE_NONE    ; WPN_RM ; 1 unit / 16 frames while riding it
	db $02, $02, $01, WPNPIERCE_NONE    ; WPN_RJ ; 1 unit / 8 frames while riding it
	db $08, $0C, $08, WPNPIERCE_ALWAYS  ; WPN_TP ; On contact with an enemy weak to it
	db $06, $06, $10, WPNPIERCE_NONE    ; WPN_AR ; Firing
	db $06, $06, $18, WPNPIERCE_ALWAYS  ; WPN_WD ; Thrown
	db $06, $06, $02, WPNPIERCE_LASTHIT ; WPN_ME ; Firing
	db $06, $06, $20, WPNPIERCE_NONE    ; WPN_CR ; Firing
	db $06, $03, $02, WPNPIERCE_NONE    ; WPN_NE ; Firing
	db $06, $03, $10, WPNPIERCE_LASTHIT ; WPN_HA ; Firing
	db $06, $06, $10, WPNPIERCE_NONE    ; WPN_MG ; Firing
	db $03, $03, $01, WPNPIERCE_NONE    ; WPN_SG ; 1 unit / 4 frames while riding it
	
