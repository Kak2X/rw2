SndHeader_SFX_32:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_32_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_32_Ch4:
	envelope $29
	panning $88
	note4x $20, 1 ; Nearest: B_,5,0
	lock_envelope
	note4x $21, 1 ; Nearest: A#,5,0
	note4x $22, 1 ; Nearest: A_,5,0
	note4x $23, 1 ; Nearest: G#,5,0
	note4 B_,5,0, 1
	note4 A#,5,0, 1
	note4 A_,5,0, 1
	note4 G#,5,0, 1
	note4 G#,5,0, 1
	lock_envelope
	note4 A_,5,0, 1
	note4 A#,5,0, 1
	note4 B_,5,0, 1
	note4x $23, 1 ; Nearest: G#,5,0
	note4x $22, 1 ; Nearest: A_,5,0
	note4x $21, 1 ; Nearest: A#,5,0
	note4x $20, 1 ; Nearest: B_,5,0
	unlock_envelope
	chan_stop
