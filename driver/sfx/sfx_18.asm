SndHeader_SFX_18:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_18_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_18_Ch4:
	envelope $F6
	panning $88
	note4 A#,4,0, 3
	note4 C_,5,0, 3
	note4 A#,4,0, 3
	lock_envelope
	note4 E_,5,0, 3
	note4 C_,5,0, 8
	unlock_envelope
	envelope $F3
	note4 C_,5,0, 10
	envelope $83
	note4 C_,5,0, 10
	envelope $33
	note4 C_,5,0, 10
	chan_stop
