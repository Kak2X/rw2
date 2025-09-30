SndHeader_SFX_12:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_12_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_12_Ch2:
	envelope $B2
	panning $22
	duty_cycle 2
	note G_,5, 3
	note G_,6
	chan_stop
