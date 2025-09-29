SndHeader_SFX_3C:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_3C_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_3C_Ch4:
	envelope $29
	panning $88
	note4 A#,5,0, 6
	note4 B_,6,0, 1
	envelope $29
	note4 A#,5,0, 6
	envelope $C2
	note4 A#,5,0, 40
	chan_stop
