SndHeader_BGM_02:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_02_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_02_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_02_Ch3 ; Data ptr
	db 12 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_02_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_02_Ch1:
	envelope $72
	panning $11
	duty_cycle 0
	snd_call SndCall_BGM_02_Ch1_0
SndData_BGM_02_Ch1_0:
	snd_call SndCall_BGM_02_Ch1_1
	snd_loop SndData_BGM_02_Ch1_0
SndCall_BGM_02_Ch1_0:
	note B_,4, 7
	note B_,4
	note A_,4
	note A_,4
	note B_,4, 14
	note D_,5
	note B_,4, 7
	note B_,4
	note A_,4
	note A_,4
	note B_,4
	note F#,5
	note E_,5, 14
	note B_,4, 7
	note B_,4
	note A_,4
	note A_,4
	note B_,4, 14
	note D_,5
	note B_,4, 7
	note B_,4
	note A_,4
	note A_,4
	snd_ret
SndCall_BGM_02_Ch1_1:
	envelope $78
	duty_cycle 2
	fine_tune 12
	note E_,4, 28
	note F#,4, 42
	note A_,4, 14
	note F#,4, 28
	note E_,4, 14
	note D_,4
	note B_,3, 21
	note B_,3, 7
	note B_,3, 14
	note A_,3
	note B_,3, 28
	note D_,4, 14
	note E_,4
	note F#,4, 14
	note F#,4, 7
	note E_,4
	note F#,4, 14
	note F#,4, 7
	note E_,4
	note F#,4, 14
	note A_,4
	note B_,4
	note C#,5
	note B_,4, 21
	note B_,4, 7
	note B_,4, 14
	note A_,4
	note B_,4, 28
	note B_,4
	note C#,5, 42
	note E_,5, 14
	note C#,5, 28
	note B_,4, 14
	note A_,4
	note F#,4, 21
	note F#,4, 7
	note A_,4, 14
	note E_,4
	note F#,4, 28
	note A_,4, 14
	note B_,4
	note C#,5, 14
	note C#,5, 7
	note B_,4
	note C#,5, 14
	note C#,5, 7
	note B_,4
	note C#,5, 14
	note B_,4
	note A_,4
	note E_,4
	note F#,4, 21
	note F#,4, 7
	note E_,4, 14
	note C#,4
	note F#,4, 28
	note A_,3
	note B_,3, 28
	note D_,4, 14
	note E_,4
	note F#,4, 28
	note A_,4, 14
	note B_,4
	note C#,5, 21
	note E_,5, 7
	note C#,5, 14
	note B_,4
	note A_,4
	note F#,4
	note E_,4
	note C#,4
	note B_,3, 28
	note E_,4
	note F#,4
	note A_,4
	note B_,4, 7
	note C#,5
	note B_,4
	note A_,4
	note F#,4
	note A_,4
	note F#,4
	note E_,4
	note F#,4
	note E_,4
	note C#,4
	note B_,3
	note A_,3
	note B_,3
	note C#,4
	note A_,3
	note B_,3, 112
	envelope $11
	note B_,3, 112
	envelope $78
	note F#,4, 7
	note A_,4
	note F#,4
	note E_,4
	note F#,4
	note E_,4
	note C#,4
	note A_,3
	note B_,3
	note B_,3
	note B_,3
	note A_,3
	note B_,3, 14
	note D_,4, 7
	note E_,4
	note F#,4
	note A_,4
	note B_,4
	note A_,4
	note B_,4
	note C#,5
	note E_,5
	note C#,5
	note B_,4
	note C#,5
	note B_,4
	note A_,4
	note B_,4, 14
	note A_,4, 7
	note B_,4
	note C#,5
	note E_,5
	note C#,5
	note B_,4
	note C#,5
	note B_,4
	note G#,4
	note F#,4
	note C#,4
	note C#,4
	note C#,4
	note B_,3
	note C#,4, 14
	note E_,4, 7
	note F#,4
	note G#,4
	note B_,4
	note C#,5
	note B_,4
	note C#,5
	note E_,5
	note F#,5
	note E_,5
	note C#,5
	note E_,5
	note C#,5
	note B_,4
	note C#,5, 14
	note B_,4, 7
	note C#,5
	note D_,5
	note F#,5
	note D_,5
	note C#,5
	note D_,5
	note C#,5
	note B_,4
	note C#,5
	note B_,4
	note F#,4
	note E_,4
	note F#,4
	note E_,4
	note F#,4
	note C#,4
	note B_,3
	note C#,4
	note E_,4
	note C#,4
	note B_,3
	note C#,4
	note B_,3
	note G#,3
	note B_,3
	note C#,4
	note E_,4
	note F#,4
	note A_,4
	note B_,4
	note C#,5
	note B_,4
	note A_,4
	note F#,4, 14
	note E_,4, 7
	note C#,4
	note F#,4, 14
	note E_,4, 7
	note C#,4
	note F#,4
	note F#,4
	note F#,4
	note E_,4
	note F#,4, 14
	note E_,4, 7
	note F#,4
	note G#,4
	note A_,4
	note G#,4
	note F#,4
	note E_,4, 14
	note C#,4, 7
	note E_,4
	note F#,4, 5
	note A_,4, 4
	note B_,4, 5
	note A_,4
	note B_,4, 4
	note C#,5, 5
	note B_,4, 5
	note C#,5, 4
	note B_,4, 5
	note A_,4
	note F#,4, 4
	note A_,4, 5
	note F#,4, 28
	silence 14
	note A_,4
	note F#,4, 28
	note E_,4, 14
	note D_,4
	note C#,4, 28
	note E_,4
	note F#,4
	note A_,4
	note B_,4, 42
	note C#,5, 14
	note B_,4, 21
	note C#,5, 7
	note B_,4, 14
	note A_,4
	note F#,4, 21
	note F#,4, 7
	note E_,4, 14
	note C#,4
	note F#,4, 28
	note F#,4
	continue 112
	fine_tune -12
	envelope $72
	duty_cycle 0
	note F#,4, 7
	note F#,4
	note E_,4
	note E_,4
	note F#,4, 14
	note A_,4
	note F#,4, 7
	note F#,4
	note E_,4
	note E_,4
	note F#,4
	note C#,5
	note B_,4
	note A_,4
	note F#,4, 7
	note F#,4
	note E_,4
	note E_,4
	note F#,4, 14
	note A_,4
	note F#,4, 7
	note F#,4
	note E_,4
	note E_,4
	note F#,4
	note C#,5
	note B_,4, 14
	note F#,4, 7
	note F#,4
	note E_,4
	note E_,4
	note F#,4, 14
	note A_,4
	note F#,4, 7
	note F#,4
	note E_,4
	note E_,4
	snd_ret
SndData_BGM_02_Ch2:
	envelope $62
	panning $22
	duty_cycle 0
	snd_call SndCall_BGM_02_Ch2_0
SndData_BGM_02_Ch2_0:
	snd_call SndCall_BGM_02_Ch2_1
	snd_call SndCall_BGM_02_Ch2_2
	fine_tune 12
	snd_call SndCall_BGM_02_Ch2_0
	snd_call SndCall_BGM_02_Ch2_0
	fine_tune -12
	snd_call SndCall_BGM_02_Ch2_3
	snd_call SndCall_BGM_02_Ch2_1
	snd_call SndCall_BGM_02_Ch2_1
	snd_loop SndData_BGM_02_Ch2_0
SndCall_BGM_02_Ch2_0:
	note F#,4, 7
	note F#,4
	note E_,4
	note E_,4
	note F#,4, 14
	note A_,4
	note F#,4, 7
	note F#,4
	note E_,4
	note E_,4
	note F#,4
	note C#,5
	note B_,4, 14
	note F#,4, 7
	note F#,4
	note E_,4
	note E_,4
	note F#,4, 14
	note A_,4
	note F#,4, 7
	note F#,4
	note E_,4
	note E_,4
	note F#,4
	note C#,5
	note B_,4
	note A_,4
	snd_ret
SndCall_BGM_02_Ch2_1:
	note B_,4, 7
	note B_,4
	note A_,4
	note A_,4
	note B_,4, 14
	note D_,5
	note B_,4, 7
	note B_,4
	note A_,4
	note A_,4
	note B_,4
	note F#,5
	note E_,5, 14
	note B_,4, 7
	note B_,4
	note A_,4
	note A_,4
	note B_,4, 14
	note D_,5
	note B_,4, 7
	note B_,4
	note A_,4
	note A_,4
	note B_,4
	note F#,5
	note E_,5
	note D_,5
	snd_ret
SndCall_BGM_02_Ch2_2:
	note B_,4, 7
	note B_,4
	note A_,4
	note A_,4
	note B_,4, 14
	note D_,5
	note B_,4, 7
	note B_,4
	note A_,4
	note A_,4
	note B_,4
	note F#,5
	note E_,5, 14
	note B_,4, 7
	note B_,4
	note A_,4
	note A_,4
	note B_,4, 21
	note D_,5, 7
	note B_,4
	note B_,4
	note A_,4
	note A_,4
	note B_,4
	note F#,5
	note E_,5
	note D_,5
	snd_ret
SndCall_BGM_02_Ch2_3:
	note B_,4, 7
	note B_,4
	note A_,4
	note A_,4
	note B_,4, 14
	note D_,5
	note B_,4, 7
	note B_,4
	note A_,4
	note A_,4
	note B_,4
	note F#,5
	note E_,5, 14
	note F#,5, 7
	note F#,5
	note E_,5
	note E_,5
	note F#,5, 14
	note A_,5
	note F#,5, 7
	note F#,5
	note E_,5
	note E_,5
	note F#,5
	note C#,6
	note B_,5, 14
	note B_,5, 7
	note F#,6
	note E_,6
	note D_,6
	note E_,6
	note D_,6
	note C#,6
	note A_,5
	note B_,4
	note D_,5
	note E_,5
	note A_,5
	note B_,4, 5
	note E_,5, 4
	note F#,5, 5
	note A_,5
	note B_,5, 4
	note D_,6, 5
	note B_,5, 28
	envelope $11
	note B_,5, 84
	envelope $62
	note B_,5, 3
	note B_,4, 4
	note B_,5, 7
	note A_,5, 3
	note A_,4, 4
	note A_,5, 7
	note F#,5, 3
	note F#,4, 4
	note F#,5, 7
	note E_,5, 3
	note E_,4, 4
	note E_,5, 7
	note B_,4, 3
	note B_,3, 4
	note B_,4, 7
	note A_,4, 3
	note A_,3, 4
	note A_,4, 7
	note F#,4, 3
	note F#,3, 4
	note F#,4, 7
	note E_,4, 3
	note E_,3, 4
	note E_,4, 7
	note B_,4, 7
	note B_,4
	note A_,4
	note A_,4
	note B_,4
	note A_,4
	note B_,4, 14
	note F#,5, 7
	note F#,5
	note E_,5
	note E_,5
	note F#,5
	note E_,5
	note F#,5, 14
	note B_,5, 7
	note B_,5
	note A_,5
	note A_,5
	note B_,5, 14
	note B_,5
	note F#,6, 7
	note F#,6
	note E_,6
	note E_,6
	note F#,6, 14
	note F#,6
	note B_,5, 7
	note B_,5
	note A_,5
	note A_,5
	note B_,5, 14
	note B_,5
	note F#,6, 7
	note E_,6
	note C#,6
	note B_,5
	note C#,6
	note B_,5
	note A_,5
	note E_,5
	note C#,6
	note C#,6
	note B_,5
	note B_,5
	note C#,6, 14
	note C#,6
	note G#,6, 7
	note G#,6
	note F#,6
	note F#,6
	note G#,6, 14
	note G#,6
	note C#,6, 7
	note C#,6
	note B_,5
	note B_,5
	note C#,6, 21
	note C#,6, 7
	note G#,6
	note F#,6
	note C#,6
	note B_,5
	note C#,6
	note B_,5
	note G#,5
	note F#,5
	note B_,5, 7
	note B_,5
	note A_,5
	note A_,5
	note B_,5, 14
	note B_,5
	note A_,6, 7
	note A_,6
	note G#,6
	note G#,6
	note A_,6, 14
	note A_,6
	note C#,6, 7
	note C#,6
	note B_,5
	note B_,5
	note C#,6, 21
	note C#,6, 7
	note G#,6
	note F#,6
	note C#,6
	note B_,5
	note C#,6
	note B_,5
	note G#,5
	note F#,5
	note D_,6
	note D_,6
	note C#,6
	note C#,6
	note D_,6, 14
	note D_,6
	note D_,6, 7
	note D_,6
	note C#,6
	note C#,6
	note D_,6
	note A_,6
	note G#,6, 14
	note C#,6, 7
	note C#,6
	note B_,5
	note B_,5
	note C#,6, 21
	note C#,6, 7
	note C#,6
	note C#,6
	note B_,5
	note B_,5
	note C#,6
	note F#,6
	note E_,6
	note C#,6
	note B_,5
	note B_,5
	note A_,5
	note A_,5
	note B_,5, 14
	note B_,5
	note B_,5, 7
	note B_,5
	note A_,5
	note A_,5
	note B_,5
	note D_,6
	note C#,6, 14
	note A_,5, 7
	note A_,5
	note F#,5
	note F#,5
	note A_,5, 14
	note A_,5
	note A_,5, 7
	note A_,5
	note F#,5
	note F#,5
	note A_,5
	note C#,6
	note B_,5
	note A_,5
	note G_,5
	note G_,5
	note E_,5
	note E_,5
	note G_,5, 14
	note G_,5
	note G_,5, 7
	note G_,5
	note E_,5
	note E_,5
	note G_,5
	note B_,5
	note A_,5, 14
	note F#,5, 7
	note F#,5
	note E_,5
	note E_,5
	note F#,5, 14
	note F#,5
	note F#,5, 7
	note F#,5
	note E_,5
	note E_,5
	note F#,5
	note C#,6
	note B_,5
	note A_,5
	snd_ret
SndData_BGM_02_Ch3:
	wave_vol $00
	panning $44
	wave_id $03
	wave_cutoff 0
	note B_,2, 112
	continue 56
	continue 7
	wave_vol $80
	note B_,3, 14
	note A_,3, 7
	note F#,3
	note E_,3
	note D_,3
	note A_,2
	wave_cutoff 25
SndData_BGM_02_Ch3_0:
	snd_call SndCall_BGM_02_Ch3_0
	snd_loop SndData_BGM_02_Ch3_0
SndCall_BGM_02_Ch3_0:
	note B_,2, 7
	note B_,2
	note B_,2
	note B_,2
	note B_,2, 14
	note F#,3
	note B_,2, 7
	note B_,2
	note B_,2
	note B_,2
	note B_,2
	note D_,3
	note A_,2, 14
	note B_,2, 7
	note B_,2
	note B_,2
	note B_,2
	note B_,2, 14
	note F#,3, 28
	note B_,2, 7
	note B_,2
	note B_,2
	note D_,3
	note A_,2, 14
	note B_,2, 7
	note B_,2
	note B_,2
	note B_,2
	note B_,2, 14
	note F#,3
	note B_,2, 7
	note B_,2
	note B_,2
	note B_,2
	note B_,2
	note D_,3
	note A_,2, 14
	note B_,2, 7
	note B_,2
	note B_,2
	note B_,2
	note B_,2
	note E_,3, 14
	note F#,3, 7
	note B_,2, 14
	note B_,2, 7
	note B_,2
	note B_,2
	note D_,3
	note C#,3
	note E_,3
	note F#,3, 7
	note F#,3
	note F#,3
	note F#,3
	note F#,3, 14
	note C#,4
	note F#,3, 7
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note A_,3
	note E_,3, 14
	note F#,3, 7
	note F#,3
	note F#,3
	note F#,3
	note F#,3, 14
	note C#,4, 28
	note F#,3, 7
	note F#,3
	note F#,3
	note A_,3
	note E_,3, 14
	note F#,3, 7
	note F#,3
	note F#,3
	note F#,3
	note F#,3, 14
	note C#,4
	note F#,3, 7
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note A_,3
	note E_,3, 14
	note F#,3, 7
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note B_,3, 14
	note C#,4, 7
	note F#,3, 14
	note F#,3, 7
	note F#,3
	note F#,3
	note A_,3
	note G#,3
	note E_,3
	note B_,2, 7
	note B_,2
	note B_,2
	note B_,2
	note B_,2, 14
	note F#,3
	note B_,2, 7
	note B_,2
	note B_,2
	note B_,2
	note B_,2
	note D_,3
	note E_,3, 14
	note F#,3, 7
	note F#,3
	note F#,3
	note F#,3
	note F#,3, 14
	note C#,4
	note F#,3, 7
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note A_,3
	note E_,3, 14
	note B_,2, 14
	note B_,2, 7
	note B_,2
	note B_,2
	note E_,3
	note F#,3
	note A_,3
	note F#,3
	note A_,3
	note B_,3
	note A_,3
	note E_,3
	note F#,3
	note A_,2, 14
	note B_,2, 28
	note B_,2
	note B_,2, 7
	note E_,3
	note F#,3
	note E_,3
	note D_,3
	note C#,3
	note A_,2
	note C#,3
	wave_cutoff 0
	note B_,2, 112
	wave_cutoff 25
	note B_,2, 7
	note E_,3
	note F#,3
	note A_,3
	note F#,3
	note A_,3
	note B_,3
	note D_,4
	note E_,4
	note D_,4
	note B_,3
	note A_,3
	note B_,3
	note A_,3
	note F#,3
	note E_,3
	note B_,2, 7
	note B_,2
	note B_,2
	note B_,2
	note B_,2
	note F#,3
	note B_,2, 14
	note B_,2
	note B_,2, 7
	note B_,2
	note B_,2
	note D_,3
	note A_,2, 14
	note B_,2, 7
	note B_,2
	note B_,2
	note B_,2
	note B_,2, 14
	note F#,3, 28
	note B_,2, 7
	note B_,2
	note B_,2
	note C#,3
	note D_,3, 14
	note C#,3, 7
	note C#,3
	note C#,3
	note C#,3
	note C#,3, 14
	note G#,3
	note C#,3, 7
	note C#,3
	note C#,3
	note C#,3
	note C#,3
	note E_,3
	note B_,2, 14
	note C#,3, 7
	note C#,3
	note C#,3
	note C#,3
	note C#,3
	note C#,3, 14
	note G#,3, 7
	note C#,3, 14
	note C#,3, 7
	note C#,3
	note C#,3
	note E_,3
	note C#,3, 14
	note D_,3, 7
	note D_,3
	note D_,3
	note D_,3
	note D_,3, 14
	note A_,3
	note D_,3, 7
	note D_,3
	note D_,3
	note D_,3
	note D_,3
	note A_,3
	note F#,3, 14
	note C#,3, 7
	note C#,3
	note C#,3
	note C#,3
	note C#,3, 14
	note G#,3, 28
	note C#,3, 7
	note C#,3
	note C#,3
	note C#,3
	note G#,3, 14
	note D_,3, 7
	note D_,3
	note D_,3
	note D_,3
	note D_,3, 14
	note A_,3
	note D_,3, 7
	note D_,3
	note D_,3
	note D_,3
	note D_,3
	note A_,3
	note F#,3, 14
	note C#,3, 7
	note C#,3
	note C#,3
	note C#,3
	note C#,3
	note C#,3, 14
	note G#,3, 7
	note C#,3, 14
	note C#,3, 7
	note C#,3
	note C#,3
	note E_,3
	note B_,2, 14
	note B_,2, 7
	note B_,2
	note B_,2
	note B_,2
	note B_,2
	note F#,3
	note B_,2, 14
	note B_,2
	note B_,2, 7
	note B_,2
	note B_,2
	note D_,3
	note A_,2, 14
	note A_,2, 7
	note A_,2
	note A_,2
	note A_,2
	note A_,2, 14
	note E_,3, 28
	note A_,2, 7
	note A_,2
	note A_,2
	note E_,3
	note C#,3, 14
	note G_,2, 7
	note G_,2
	note G_,2
	note G_,2
	note G_,2, 14
	note D_,3
	note G_,2, 7
	note G_,2
	note G_,2
	note G_,2
	note G_,2
	note D_,3
	note B_,2, 14
	note F#,2, 7
	note F#,2
	note F#,2
	note F#,2
	note F#,2, 14
	note C#,3, 28
	note F#,2, 7
	note F#,2
	note F#,2
	note F#,3
	note C#,3, 14
	note B_,2, 7
	note B_,2
	note B_,2
	note B_,2
	note B_,2
	note F#,3
	note B_,2, 14
	note B_,2, 7
	note B_,2
	note B_,2
	note B_,2
	note B_,2
	note D_,3
	note A_,2, 14
	note B_,2, 7
	note B_,2
	note B_,2
	note B_,2
	note B_,2, 14
	note F#,3, 28
	note B_,2, 7
	note B_,2
	note B_,2
	note D_,3
	note A_,2, 14
	note B_,2, 7
	note B_,2
	note B_,2
	note B_,2
	note B_,2, 14
	note F#,3
	note B_,2, 7
	note B_,2
	note B_,2
	note B_,2
	note B_,2
	note D_,3
	note A_,2, 14
	note B_,2, 7
	note B_,2
	note B_,2
	note B_,2
	note B_,2, 14
	note F#,3, 21
	note B_,3, 14
	note A_,3, 7
	note F#,3
	note E_,3
	note D_,3
	note A_,2
	snd_ret
SndData_BGM_02_Ch4:
	panning $88
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 28 ; Nearest: A#,5,0
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 28 ; Nearest: A#,5,0
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 28 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 14
	envelope $62
	note4 B_,5,0, 7
	envelope $54
	note4x $22, 7 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 14
SndData_BGM_02_Ch4_0:
	snd_call SndCall_BGM_02_Ch4_0
	snd_call SndCall_BGM_02_Ch4_1
	snd_call SndCall_BGM_02_Ch4_0
	snd_call SndCall_BGM_02_Ch4_2
	snd_call SndCall_BGM_02_Ch4_3
	snd_call SndCall_BGM_02_Ch4_1
	snd_call SndCall_BGM_02_Ch4_0
	snd_call SndCall_BGM_02_Ch4_2
	snd_call SndCall_BGM_02_Ch4_3
	snd_call SndCall_BGM_02_Ch4_4
	snd_call SndCall_BGM_02_Ch4_0
	snd_call SndCall_BGM_02_Ch4_1
	snd_call SndCall_BGM_02_Ch4_0
	snd_call SndCall_BGM_02_Ch4_2
	snd_call SndCall_BGM_02_Ch4_0
	snd_call SndCall_BGM_02_Ch4_1
	snd_call SndCall_BGM_02_Ch4_0
	snd_call SndCall_BGM_02_Ch4_2
	snd_call SndCall_BGM_02_Ch4_0
	snd_call SndCall_BGM_02_Ch4_1
	snd_call SndCall_BGM_02_Ch4_0
	snd_call SndCall_BGM_02_Ch4_5
	snd_loop SndData_BGM_02_Ch4_0
SndCall_BGM_02_Ch4_0:
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $61
	note4 F_,5,0, 14
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	snd_ret
SndCall_BGM_02_Ch4_1:
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $61
	note4 F_,5,0, 28
	note4 F_,5,0, 7
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	snd_ret
SndCall_BGM_02_Ch4_2:
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 14
	note4 F_,5,0, 7
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	snd_ret
SndCall_BGM_02_Ch4_3:
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $61
	note4 F_,5,0, 14
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	snd_ret
SndCall_BGM_02_Ch4_4:
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 14
	envelope $62
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 21
	envelope $61
	note4 F_,5,0, 21
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $61
	note4 F_,5,0, 28
	note4 F_,5,0, 7
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	note4 B_,5,0, 14
	envelope $61
	note4 F_,5,0, 21
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $61
	note4 F_,5,0, 14
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 14
	envelope $61
	note4 F_,5,0, 28
	note4 F_,5,0, 28
	note4 F_,5,0, 28
	note4 F_,5,0, 42
	envelope $31
	note4x $21, 28 ; Nearest: A#,5,0
	note4x $21, 21 ; Nearest: A#,5,0
	envelope $54
	note4x $22, 7 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	envelope $72
	note4x $32, 7 ; Nearest: A_,5,0
	note4x $32, 7 ; Nearest: A_,5,0
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $72
	note4x $32, 7 ; Nearest: A_,5,0
	snd_ret
SndCall_BGM_02_Ch4_5:
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 14
	envelope $62
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 14
	note4 F_,5,0, 14
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 14
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $61
	note4 F_,5,0, 14
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 14
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $54
	note4x $22, 7 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 7
	envelope $72
	note4x $32, 7 ; Nearest: A_,5,0
	snd_ret
