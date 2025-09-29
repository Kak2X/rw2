SndHeader_SFX_30:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_30_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_30_Ch4:
	envelope $A9
	panning $88
	note4 G#,4,0, 2
	lock_envelope
	note4 A_,4,0, 2
	note4 A#,4,0, 2
	note4 B_,4,0, 2
	note4x $53, 2 ; Nearest: G#,4,0
	note4 C_,5,0, 2
	note4 C#,5,0, 2
	note4 D_,5,0, 2
	note4 D#,5,0, 2
	note4x $43, 2 ; Nearest: G#,5,0
	note4x $42, 2 ; Nearest: A_,5,0
	note4x $41, 2 ; Nearest: A#,5,0
	unlock_envelope
	chan_stop
