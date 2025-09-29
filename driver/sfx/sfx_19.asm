SndHeader_SFX_19:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_19_Ch2 ; Data ptr
	db 12 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_19_Ch2:
	envelope $F8
	panning $22
	duty_cycle 1
	note D_,3, 4
	note D_,2
	note D_,3, 1
	lock_envelope
	note E_,3
	note F#,3
	note G_,3
	note A_,3
	note B_,3
	note C#,4
	note D_,4
	unlock_envelope
	envelope $C8
	note D_,3, 1
	lock_envelope
	note E_,3
	note F#,3
	note G_,3
	note A_,3
	note B_,3
	note C#,4
	note D_,4
	unlock_envelope
	envelope $98
	note D_,3, 1
	lock_envelope
	note E_,3
	note F#,3
	note G_,3
	note A_,3
	note B_,3
	note C#,4
	note D_,4
	unlock_envelope
	envelope $68
	note D_,3, 1
	lock_envelope
	note E_,3
	note F#,3
	note G_,3
	note A_,3
	note B_,3
	note C#,4
	note D_,4
	unlock_envelope
	envelope $38
	note D_,3, 1
	lock_envelope
	note E_,3
	note F#,3
	note G_,3
	note A_,3
	note B_,3
	note C#,4
	note D_,4
	unlock_envelope
	chan_stop
