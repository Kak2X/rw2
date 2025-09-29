SndHeader_BGM_25:
	db $03 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_25_Ch1 ; Data ptr
	db 4 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_25_Ch2 ; Data ptr
	db 4 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_25_Ch3 ; Data ptr
	db 4 ; Initial fine tune
	db $81 ; Initial vibrato ID
.unused_ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_25_Ch4_Unused ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_25_Ch1:
	envelope $68
	panning $11
	duty_cycle 2
	note E_,4, 112
	continue 112
	note F_,4
	continue 56
	envelope $67
	note D_,5
SndData_BGM_25_Ch1_0:
	snd_call SndCall_BGM_25_Ch1_0
	snd_call SndCall_BGM_25_Ch1_1
	snd_call SndCall_BGM_25_Ch1_0
	snd_call SndCall_BGM_25_Ch1_2
	snd_loop SndData_BGM_25_Ch1_0
SndCall_BGM_25_Ch1_0:
	note E_,5, 56
	silence 14
	note E_,5
	note C_,5
	note G_,5
	continue 56
	silence 14
	note F_,5
	note E_,5
	note F_,5
	continue 56
	silence 14
	snd_ret
SndCall_BGM_25_Ch1_1:
	note F_,5, 14
	note E_,5
	note D_,5
	note F_,5
	note E_,5
	note D_,5
	note F_,5, 28
	note E_,5
	note D_,5, 14
	snd_ret
SndCall_BGM_25_Ch1_2:
	note F_,5, 14
	note G_,5
	note G#,5
	continue 19
	note G#,5, 18
	note G#,5, 19
	note G_,5, 28
	note F_,5
	note E_,5, 14
	note C_,5
	note G_,4
	note G_,5, 70
	continue 112
	note D_,5, 14
	note B_,4
	note G_,4
	note G_,5, 70
	continue 112
	snd_ret
SndData_BGM_25_Ch2:
	envelope $67
	panning $22
	duty_cycle 0
	snd_call SndCall_BGM_25_Ch2_0_0
	snd_call SndCall_BGM_25_Ch2_1
SndData_BGM_25_Ch2_0:
	snd_call SndCall_BGM_25_Ch2_0_0
	snd_call SndCall_BGM_25_Ch2_2_0
	snd_call SndCall_BGM_25_Ch2_0_0
	snd_call SndCall_BGM_25_Ch2_2_0
	snd_call SndCall_BGM_25_Ch2_0_0
	snd_call SndCall_BGM_25_Ch2_3_0
	snd_loop SndData_BGM_25_Ch2_0
SndCall_BGM_25_Ch2_0_0:
	envelope $11
	note G_,3, 14
	envelope $67
	note G_,3
	note D_,4
	note E_,4, 28
	note G_,3, 14
	note D_,4
	note E_,4
	snd_loop SndCall_BGM_25_Ch2_0_0, $00, 2
	snd_ret
SndCall_BGM_25_Ch2_1:
	envelope $11
	note G#,3, 14
	envelope $67
	note G#,3
	note E_,4
	note F_,4, 28
	note G#,3, 14
	note E_,4
	note F_,4, 28
	note G#,3, 14
	note E_,4
	note F_,4, 28
	note F_,4, 14
	note E_,4
	note D_,4
	snd_ret
SndCall_BGM_25_Ch2_2_0:
	envelope $11
	note G#,3, 14
	envelope $67
	note G#,3
	note E_,4
	note F_,4, 28
	note G#,3, 14
	note E_,4
	note F_,4
	snd_loop SndCall_BGM_25_Ch2_2_0, $00, 2
	snd_ret
SndCall_BGM_25_Ch2_3_0:
	envelope $11
	note G_,3, 14
	envelope $67
	note G_,3
	note F_,4
	note G_,4, 28
	note G_,3, 14
	note F_,4
	note G_,4
	snd_loop SndCall_BGM_25_Ch2_3_0, $00, 2
	snd_ret
SndData_BGM_25_Ch3:
	wave_vol $80
	panning $44
	wave_id $01
	wave_cutoff 0
	note C_,5, 112
	continue 112
	note C_,5, 112
	continue 112
	wave_cutoff 50
SndData_BGM_25_Ch3_0:
	snd_call SndCall_BGM_25_Ch3_0_0
	snd_call SndCall_BGM_25_Ch3_1
	snd_loop SndData_BGM_25_Ch3_0
SndCall_BGM_25_Ch3_0_0:
	silence 14
	note C_,4
	note G_,3
	note E_,4, 28
	note C_,4
	note G_,3
	note E_,3, 14
	note C_,3
	note G_,3, 28
	note E_,3
	note C_,3
	note C_,4, 14
	note G_,3
	note F_,4, 28
	note C_,4
	note G_,3
	note G#,3, 14
	note F_,3
	note C_,4, 28
	note G#,3
	note F_,3, 14
	snd_loop SndCall_BGM_25_Ch3_0_0, $00, 2
	snd_ret
SndCall_BGM_25_Ch3_1:
	silence 14
	note C_,4
	note G_,3
	note E_,4, 28
	note C_,4
	note G_,3
	note E_,3, 14
	note C_,3
	note G_,3, 28
	note E_,3
	note C_,3
	note G_,3, 14
	note F_,3
	note G_,3, 28
	note G_,3, 14
	note G_,3
	note G_,3
	note D_,3, 28
	note F_,3
	note G_,3
	note B_,3
	snd_ret
SndData_BGM_25_Ch4_Unused:
	panning $88
	chan_stop
