SndHeader_SFX_34:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_34_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_34_Ch4:
	envelope $69
	panning $88
	note4x $11, 3 ; Nearest: A#,6,0
	lock_envelope
	note4x $12, 3 ; Nearest: A_,6,0
	note4x $13, 3 ; Nearest: G#,6,0
	note4 D#,6,0, 3
	note4 D_,6,0, 3
	note4 C#,6,0, 3
	note4 C_,6,0, 3
	note4x $23, 3 ; Nearest: G#,5,0
	note4 B_,5,0, 3
	note4 A#,5,0, 3
	note4 A_,5,0, 3
	note4 G#,5,0, 3
	note4x $33, 2 ; Nearest: G#,5,0
	note4 G_,5,0, 2
	note4 F#,5,0, 2
	note4 F_,5,0, 2
	note4 E_,5,0, 2
	unlock_envelope
	chan_stop
