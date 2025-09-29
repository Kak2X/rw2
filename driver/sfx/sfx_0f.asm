SndHeader_SFX_0F:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_0F_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_0F_Ch4:
	envelope $F2
	panning $88
	note4x $71, 5 ; Nearest: A#,4,0
	note4x $41, 6 ; Nearest: A#,5,0
	chan_stop
