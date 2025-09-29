SndHeader_SFX_39:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_39_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_39_Ch4:
	envelope $89
	panning $88
	note4 E_,5,0, 3
	note4 F_,5,0, 3
	note4 F#,5,0, 3
	note4 G_,5,0, 3
	note4x $33, 3 ; Nearest: G#,5,0
	note4 G#,5,0, 4
	note4 A_,5,0, 4
	note4 A#,5,0, 4
	note4 B_,5,0, 4
	note4x $23, 3 ; Nearest: G#,5,0
	note4x $22, 3 ; Nearest: A_,5,0
	note4x $21, 3 ; Nearest: A#,5,0
	chan_stop
