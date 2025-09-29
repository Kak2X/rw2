SndHeader_SFX_1D:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_1D_Ch2_0 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_1D_Ch2_0:
	envelope $78
	panning $22
	duty_cycle 2
	note G#,6, 1
	note A_,6
	note A#,6
	note B_,6
	note C_,7
	note C#,7
	silence 4
	note A_,6, 1
	note A#,6
	note B_,6
	note C_,7
	note C#,7
	silence
	note D_,6
	note D#,6
	note E_,6
	note F_,6
	note F#,6
	silence
	note A#,6
	note B_,6
	note C_,7
	note C#,7
	silence 3
	note A#,6, 1
	note B_,6
	note C_,7
	note C#,7
	silence 2
	fine_tune 2
	note C#,7, 1
	note B_,6
	note A#,6
	note A_,6
	note G#,6
	note G_,6
	note F#,6
	note F_,6
	note E_,6
	note D#,6
	note D_,6
	note C#,6
	note C_,6
	silence 4
	fine_tune -2
	snd_loop SndData_SFX_1D_Ch2_0, $00, 4
	chan_stop
