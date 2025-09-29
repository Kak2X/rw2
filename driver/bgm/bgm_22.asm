SndHeader_BGM_22:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_22_Ch1 ; Data ptr
	db -3 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_22_Ch2 ; Data ptr
	db -3 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_22_Ch3_0 ; Data ptr
	db -3 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_22_Ch4_0 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_22_Ch1:
	envelope $75
	panning $11
	duty_cycle 3
	snd_call SndCall_BGM_22_Ch1_0_0
SndData_BGM_22_Ch1_0:
	snd_call SndCall_BGM_22_Ch1_1
	snd_loop SndData_BGM_22_Ch1_0
SndCall_BGM_22_Ch1_0_0:
	note E_,5, 7
	note E_,5
	silence
	note E_,5
	note E_,5
	silence
	note F_,5
	silence
	note F_,5
	silence
	note F_,5
	silence
	note G_,5
	note G_,5
	silence
	note G_,5
	note G_,5
	silence
	note F_,5
	silence
	note F_,5
	silence
	note F_,5
	silence
	snd_loop SndCall_BGM_22_Ch1_0_0, $00, 2
	snd_ret
SndCall_BGM_22_Ch1_1:
	envelope $68
	duty_cycle 2
	note E_,6, 7
	note C_,6
	note G_,5
	note G_,6, 42
	continue 7
	note G_,6
	note A_,6
	note G_,6, 21
	note F_,6, 7
	note E_,6, 14
	note G_,6, 7
	note F_,6
	note E_,6
	note D_,6
	note A_,5
	note B_,5
	note D_,6
	note C_,6
	note A_,5
	note B_,5
	note G_,5, 56
	continue 56
	silence 14
	note G_,5
	note G_,6, 7
	note A_,6
	note G_,6
	note A_,6
	note G_,6, 56
	continue 56
	note F_,6, 14
	note E_,6
	note G_,6, 7
	note F_,6
	note E_,6
	note D_,6
	note A_,5
	note B_,5
	note D_,6
	note C_,6
	note A_,5
	note B_,5
	note G_,5, 14
	continue 56
	silence 14
	note F_,6
	snd_ret
SndData_BGM_22_Ch2:
	envelope $65
	panning $22
	duty_cycle 3
	snd_call SndCall_BGM_22_Ch2_0_0
SndData_BGM_22_Ch2_0:
	snd_call SndCall_BGM_22_Ch1_0_0
	snd_loop SndData_BGM_22_Ch2_0
SndCall_BGM_22_Ch2_0_0:
	note G_,4, 7
	note G_,4
	silence
	note G_,4
	note G_,4
	silence
	note A_,4
	silence
	note A_,4
	silence
	note A_,4
	silence
	note B_,4
	note B_,4
	silence
	note B_,4
	note B_,4
	silence
	note A_,4
	silence
	note A_,4
	silence
	note A_,4
	silence
	snd_loop SndCall_BGM_22_Ch2_0_0, $00, 2
	snd_ret
SndData_BGM_22_Ch3_0:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 40
	note C_,3, 7
	note G_,3
	note E_,4
	note C_,4
	note E_,4
	note C_,4
	note C_,3
	note A_,3
	note F_,4
	note A_,3
	note F_,4
	note A_,3
	note C_,3
	note B_,3
	note G_,4
	note B_,3
	note G_,4
	note B_,3
	note C_,3
	note A_,3
	note F_,4
	note A_,3
	note F_,4
	note A_,3
	snd_loop SndData_BGM_22_Ch3_0
SndData_BGM_22_Ch4_0:
	panning $88
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	snd_loop SndData_BGM_22_Ch4_0
