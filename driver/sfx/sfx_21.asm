SndHeader_SFX_21:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_21_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_21_Ch4:
	envelope $A7
	panning $88
	note4 C_,5,0, 1
	lock_envelope
	note4 G_,5,0, 1
	note4 A#,4,0, 1
	unlock_envelope
	chan_stop
