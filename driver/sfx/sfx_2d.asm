SndHeader_SFX_2D:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_2D_Ch2 ; Data ptr
	db -4 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_2D_Ch2:
	envelope $D1
	panning $22
	duty_cycle 0
	note C#,7, 1
	note D#,7
	silence 3
	note G#,7, 1
	note C_,8
	silence 3
	note C_,7, 1
	note D_,7
	silence 4
	note G_,7, 1
	note B_,7
	silence 4
	note B_,6, 1
	note C#,7
	silence 5
	note F#,7, 1
	note A#,7
	chan_stop
