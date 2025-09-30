SndHeader_SFX_13:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_13_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_13_Ch2:
	envelope $C1
	panning $22
	duty_cycle 2
	note B_,6, 2
	chan_stop
