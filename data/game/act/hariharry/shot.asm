; =============== Act_HariHarryShot ===============
; ID: ACT_HARISHOT
; An individual needle fired by Act_HariHarry.
; Spawned by Act_Hari_SpawnShots
Act_HariHarryShot:
	; Move in both directions, if any
	call ActS_MoveBySpeedX
	call ActS_MoveBySpeedY
	ret
	
