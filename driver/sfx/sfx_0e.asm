SndHeader_SFX_0E:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_0E_Ch2 ; Data ptr
	db 18 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_0E_Ch2:
	envelope $F8
	panning $22
	duty_cycle 3
	note G_,3, 2
	note C_,4
	note D_,4
	note G_,4
	note G_,4
	note C_,5
	note D_,5
	note G_,5
	envelope $88
	note G_,3
	note C_,4
	note D_,4
	note G_,4
	envelope $78
	note G_,4
	note C_,5
	note D_,5
	note G_,5
	envelope $68
	note G_,3
	note C_,4
	note D_,4
	note G_,4
	envelope $58
	note G_,4
	note C_,5
	note D_,5
	note G_,5
	envelope $48
	note G_,3
	note C_,4
	note D_,4
	note G_,4
	envelope $38
	note G_,4
	note C_,5
	note D_,5
	note G_,5
	envelope $28
	note G_,3
	note C_,4
	note D_,4
	note G_,4
	envelope $18
	note G_,4
	note C_,5
	note D_,5
	note G_,5
	chan_stop
