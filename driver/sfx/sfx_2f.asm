SndHeader_SFX_2F:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_2F_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_2F_Ch4:
	envelope $3C
	panning $88
	note4 A#,4,0, 50
	envelope $39
	note4x $52, 20 ; Nearest: A_,4,0
	chan_stop
