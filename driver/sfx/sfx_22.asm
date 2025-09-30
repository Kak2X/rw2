SndHeader_SFX_22:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_22_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_22_Ch4:
	envelope $F4
	panning $88
	note4x $71, 2 ; Nearest: A#,4,0
	lock_envelope
	note4 G_,4,0, 2
	note4 D#,5,0, 2
	note4 G_,4,0, 2
	note4 B_,4,0, 5
	note4x $71, 120 ; Nearest: A#,4,0
	unlock_envelope
	chan_stop
