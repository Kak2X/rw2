SndHeader_SFX_14:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_14_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_14_Ch2:
	envelope $C1
	panning $22
	duty_cycle 2
	note D_,5, 6
	envelope $C3
	note B_,4, 60
	chan_stop
