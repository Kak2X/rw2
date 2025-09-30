SndHeader_SFX_33:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_33_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_33_Ch4:
	envelope $F2
	panning $88
	note4x $51, 3 ; Nearest: A#,4,0
	envelope $39
	note4x $11, 1 ; Nearest: A#,6,0
	lock_envelope
	note4x $12, 1 ; Nearest: A_,6,0
	note4x $13, 1 ; Nearest: G#,6,0
	unlock_envelope
	envelope $F2
	note4 B_,6,1, 3
	chan_stop
