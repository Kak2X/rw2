; =============== Sound_SFXPriorityTbl ===============
; Sound effect priority table.
; Lower values have higher priority.
; The idea is that if a SFX is playing, it can't be played over if its priority is lower.
; In practice it's a bit bugged, see Sound_Do.chkNewSfx
Sound_SFXPriorityTbl:
	db $00 ; SND_MUTE         ;X
	db $07 ; SFX_LAND
	db $08 ; SFX_SHOOT
	db $04 ; SFX_ENEMYHIT
	db $03 ; SFX_ENEMYDEAD
	db $05 ; SFX_DEFLECT
	db $00 ; SFX_EXPLODE
	db $01 ; SFX_BAR
	db $01 ; SFX_ETANK        ;X
	db $01 ; SFX_1UP
	db $00 ; SFX_SHUTTER
	db $00 ; SFX_BOSSBAR
	db $00 ; SFX_TELEPORTIN
	db $00 ; SFX_TELEPORTOUT
	db $00 ; SFX_FREEZETOGGLE ;X
	db $00 ; SFX_WEAPONABSORB ;X
	db $01 ; SFX_BLOCK
	db $00 ; SFX_UFOCRASH     ;X
	db $00 ; SFX_CURSORMOVE
	db $02 ; SFX_DAMAGED
	db $00 ; X
	db $00 ; X
	db $00 ; X
	db $00 ; X
	db $00 ; X
	db $00 ; X
	db $00 ; X
	db $00 ; X
	db $00 ; X
	db $00 ; X
	db $00 ; X
	db $00 ; X