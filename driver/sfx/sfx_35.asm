SndHeader_SFX_35:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_35_Ch4_0 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_35_Ch4_0:
	envelope $29
	panning $88
	note4 C_,5,0, 2
	lock_envelope
	note4 C#,5,0, 2
	note4 D_,5,0, 2
	note4 D#,5,0, 2
	note4x $43, 2 ; Nearest: G#,5,0
	note4x $42, 2 ; Nearest: A_,5,0
	note4x $41, 2 ; Nearest: A#,5,0
	note4x $40, 2 ; Nearest: B_,5,0
	unlock_envelope
	snd_loop SndData_SFX_35_Ch4_0, $00, 10
	chan_stop
