SndHeader_SFX_3A:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_3A_Ch4_0 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_3A_Ch4_0:
	envelope $69
	panning $88
	note4 E_,5,0, 1
	lock_envelope
	note4 F_,5,0, 1
	note4 F#,5,0, 1
	note4 G_,5,0, 1
	note4x $33, 1 ; Nearest: G#,5,0
	note4x $32, 1 ; Nearest: A_,5,0
	note4x $31, 1 ; Nearest: A#,5,0
	note4x $30, 1 ; Nearest: B_,5,0
	unlock_envelope
	snd_loop SndData_SFX_3A_Ch4_0, $00, 10
	chan_stop
