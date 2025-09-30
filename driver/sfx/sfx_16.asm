SndHeader_SFX_16:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_16_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_16_Ch4:
	envelope $F8
	panning $88
	note4x $20, 2 ; Nearest: B_,5,0
	lock_envelope
	note4x $21, 2 ; Nearest: A#,5,0
	note4x $22, 2 ; Nearest: A_,5,0
	note4x $23, 2 ; Nearest: G#,5,0
	note4 B_,5,0, 2
	note4 A#,5,0, 2
	note4 A_,5,0, 2
	unlock_envelope
	envelope $F1
	note4 G#,5,0, 6
	chan_stop SNP_SFX4
