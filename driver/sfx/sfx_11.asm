SndHeader_SFX_11:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_11_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_11_Ch2:
	envelope $F8
	panning $22
	duty_cycle 3
	note C_,5, 1
	note F_,5
	note G_,5
	note C_,6
	envelope $88
	note C_,5
	note F_,5
	note G_,5
	note C_,6
	chan_stop
