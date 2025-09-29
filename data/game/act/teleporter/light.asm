; =============== Act_TeleporterLight ===============
; ID: ACT_TELEPORTLIGHT
; Flashing light above active teleporters.
Act_TeleporterLight:
	; Use frames $00-$01 at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	ret
	
