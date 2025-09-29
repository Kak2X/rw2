SndHeader_BGM_23:
	db $03 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_23_Ch1_0 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_23_Ch2_1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_23_Ch3_0 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.unused_ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_23_Ch4_Unused ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_23_Ch1_0:
	envelope $68
	panning $11
	duty_cycle 3
	note B_,4, 14
	note G_,5
	note F#,5, 7
	note E_,5
	note D_,5
	note C_,5
	note B_,4
	note C_,5
	note B_,4
	note A_,4
	note G_,4
	note F#,4
	note E_,4
	note B_,4
	note E_,4, 14
	note B_,4, 28
	note E_,5
	note G_,5, 42
	envelope $11
	note G_,5, 112
	continue 112
	envelope $68
	note A_,4, 9
	note G_,4, 10
	note A_,4, 9
	note B_,4
	note A_,4, 10
	note B_,4, 9
	note A_,4
	note C_,5, 19
	note D_,5, 9
	note D#,5, 10
	note E_,5, 9
	note F_,5, 112
	note C#,5, 21
	note C#,5
	note C#,5, 7
	note C#,5
	note C_,5, 28
	note B_,4
	note G#,4, 112
	snd_loop SndData_BGM_23_Ch1_0
SndData_BGM_23_Ch2_1:
	envelope $53
	panning $22
	duty_cycle 2
	note G_,5, 7
	note F#,5
	note E_,5
	note F#,5
	note G_,5
	note F#,5
	note E_,5
	note F#,5
	note G_,5
	note F#,5
	note E_,5
	note F#,5
	note A_,5
	note G_,5
	note F#,5
	note G_,5
	note E_,5
	note F#,5
	note E_,5
	note D_,5
	note E_,5
	note F#,5
	note G_,5
	note F#,5
	note E_,5
	note F#,5
	note E_,5
	note D_,5
	note E_,5
	note F#,5
	note G_,5
	note F#,5
SndData_BGM_23_Ch2_0:
	note E_,4, 7
	note F#,4
	note E_,4
	note D_,4
	snd_loop SndData_BGM_23_Ch2_0, $00, 6
	note E_,4
	note F_,4
	note F#,4
	note G_,4
	note G#,4
	note A_,4
	note A#,4
	note B_,4
	envelope $58
	note D_,5, 112
	note C_,5
	note F#,5, 56
	note G_,5, 28
	note B_,5
	note C#,6, 112
	snd_loop SndData_BGM_23_Ch2_1
SndData_BGM_23_Ch3_0:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 0
	note E_,3, 28
	note B_,3, 14
	note E_,4, 28
	note G_,4, 14
	note F#,4
	note D_,4
	note E_,4
	note F#,4
	note G_,4, 28
	note F#,4, 14
	note G_,4
	note A_,4, 28
	note E_,3, 14
	note E_,3, 28
	note E_,3
	note E_,3, 14
	note E_,3
	note E_,3, 28
	note E_,3, 28
	note E_,3, 14
	note E_,3, 21
	note B_,3
	note E_,4, 14
	note A_,3, 42
	note A_,3, 7
	note B_,3
	note C_,4, 21
	note G_,4
	note F_,4, 14
	note A_,4, 42
	note G#,4
	note G_,4, 28
	note F#,4, 112
	note D_,4
	snd_loop SndData_BGM_23_Ch3_0
SndData_BGM_23_Ch4_Unused:
	panning $88
	chan_stop
