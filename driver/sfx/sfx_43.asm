SndHeader_SFX_43:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_43_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_43_Ch4:
	envelope $A9
	panning $88
	note4 C_,5,0, 2
	lock_envelope
	note4 C#,5,0, 2
	note4 D_,5,0, 2
	note4 D#,5,0, 2
	note4x $43, 2 ; Nearest: G#,5,0
	note4 E_,5,0, 2
	note4 F_,5,0, 2
	note4 F#,5,0, 2
	note4 G_,5,0, 2
	note4x $33, 2 ; Nearest: G#,5,0
	note4x $32, 2 ; Nearest: A_,5,0
	note4x $31, 2 ; Nearest: A#,5,0
	unlock_envelope
	envelope $F3
	note4x $30, 20 ; Nearest: B_,5,0
	chan_stop
