SndHeader_SFX_14:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_14_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_14_Ch2:
	envelope $F8
	panning $22
	duty_cycle 2
	note C_,5, 2
	note D_,5
	note E_,5
	note G_,5
	chan_stop
