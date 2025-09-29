SndHeader_SFX_15:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_15_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_15_Ch2:
	envelope $F1
	panning $22
	duty_cycle 2
	note F#,5, 5
	envelope $F2
	note F#,5, 30
	chan_stop
