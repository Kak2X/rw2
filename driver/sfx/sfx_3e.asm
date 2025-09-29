SndHeader_SFX_3E:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_3E_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_3E_Ch4:
	envelope $F2
	panning $88
	note4x $50, 1 ; Nearest: B_,4,0
	lock_envelope
	note4x $51, 1 ; Nearest: A#,4,0
	note4x $52, 1 ; Nearest: A_,4,0
	note4x $53, 1 ; Nearest: G#,4,0
	note4 B_,4,0, 1
	note4 A#,4,0, 1
	note4 A_,4,0, 1
	note4 G#,4,0, 1
	unlock_envelope
	note4 A#,5,0, 1
	lock_envelope
	note4 B_,5,0, 1
	note4x $23, 1 ; Nearest: G#,5,0
	note4x $22, 1 ; Nearest: A_,5,0
	note4x $21, 1 ; Nearest: A#,5,0
	note4x $20 ; Nearest: B_,5,0
	unlock_envelope
	chan_stop
