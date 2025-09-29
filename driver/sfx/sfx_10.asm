SndHeader_SFX_10:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_10_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_10_Ch4:
	envelope $F2
	panning $88
	note4x $71, 5 ; Nearest: A#,4,0
	note4 B_,6,0, 1
	note4x $51, 6 ; Nearest: A#,4,0
	chan_stop
