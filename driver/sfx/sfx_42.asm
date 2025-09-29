SndHeader_SFX_42:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_42_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_42_Ch4:
	envelope $69
	panning $88
	note4x $71, 4 ; Nearest: A#,4,0
	note4x $51, 6 ; Nearest: A#,4,0
	chan_stop
