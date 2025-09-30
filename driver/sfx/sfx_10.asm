SndHeader_SFX_10:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_10_Ch2 ; Data ptr
	db -2 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_10_Ch2:
	envelope $F8
	panning $22
	duty_cycle 3
	note D#,5, 1
	lock_envelope
	note G#,5
	note G_,5
	note F_,5, 3
	unlock_envelope
	envelope $88
	note G#,5, 1
	lock_envelope
	note G_,5
	note F_,5, 3
	unlock_envelope
	envelope $48
	note G#,5, 1
	lock_envelope
	note G_,5
	note F_,5, 3
	unlock_envelope
	chan_stop
