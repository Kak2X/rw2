SndHeader_SFX_2A:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_2A_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_2A_Ch4:
	envelope $F8
	panning $88
	note4 G#,4,0, 2
	lock_envelope
	note4 A_,4,0, 2
	note4 A#,4,0, 2
	note4 B_,4,0, 2
	note4x $53, 2 ; Nearest: G#,4,0
	note4x $52, 2 ; Nearest: A_,4,0
	note4x $51, 2 ; Nearest: A#,4,0
	note4x $50, 2 ; Nearest: B_,4,0
	note4 E_,5,0, 2
	note4 F_,5,0, 2
	note4 F#,5,0, 2
	note4 G_,5,0, 2
	note4x $33, 2 ; Nearest: G#,5,0
	note4x $32, 2 ; Nearest: A_,5,0
	note4x $31, 2 ; Nearest: A#,5,0
	unlock_envelope
	envelope $F6
	note4x $30, 100 ; Nearest: B_,5,0
	chan_stop
