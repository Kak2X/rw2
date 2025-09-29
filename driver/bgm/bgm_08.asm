SndHeader_BGM_08:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_08_Ch1 ; Data ptr
	db 1 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_08_Ch2 ; Data ptr
	db 1 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_08_Ch3 ; Data ptr
	db 1 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_08_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_08_Ch1:
	envelope $11
	panning $11
	duty_cycle 3
	note D_,5, 35
	envelope $77
SndData_BGM_08_Ch1_0:
	snd_call SndCall_BGM_08_Ch1_0_0
	snd_call SndCall_BGM_08_Ch1_0_0
	snd_call SndCall_BGM_08_Ch1_1
	snd_loop SndData_BGM_08_Ch1_0
SndCall_BGM_08_Ch1_0_0:
	envelope $77
	note D_,5, 7
	silence
	note D_,5
	note C#,5
	silence
	note C#,5
	note D_,5, 42
	continue 7
	note D_,5
	note C#,5, 14
	snd_loop SndCall_BGM_08_Ch1_0_0, $00, 2
	note D_,5, 7
	note C#,5
	silence
	note D_,5, 14
	note C#,5, 7
	silence
	note E_,5
	silence
	note E_,5
	note D_,5
	silence
	note C#,5, 14
	note A_,4
	snd_ret
SndCall_BGM_08_Ch1_1:
	envelope $78
	note B_,3, 56
	silence 14
	note C#,4, 7
	silence
	note D_,4
	note E_,4, 21
	note F#,4, 14
	continue 5
	silence 2
	note F#,4, 7
	note E_,4
	silence
	note G_,4, 1
	note G#,4, 2
	note A_,4, 4
	continue 21
	note G_,4, 7
	silence
	note F#,4
	note G_,4, 21
	note C#,4, 28
	note D_,4, 21
	note E_,4, 7
	silence 14
	note A_,3
	note C#,4
	note E_,4
	note G_,4, 28
	note G_,4, 1
	note G#,4, 2
	note A_,4, 4
	continue 14
	note F#,4, 7
	silence 14
	note F#,4, 7
	silence
	note E_,4
	note C#,4, 21
	note B_,3, 56
	silence 14
	note C#,4, 7
	silence
	note D_,4
	note E_,4, 21
	note F#,4
	note F#,4, 7
	note G_,4
	silence
	note E_,4, 28
	note E_,4, 7
	silence
	note F#,4
	note G_,4, 21
	note A_,4, 56
	silence 14
	note B_,4, 7
	silence
	note C#,5
	note D_,5, 21
	note E_,5, 1
	note F_,5, 2
	note F#,5, 4
	continue 21
	note E_,5, 28
	note C#,5
	note A_,4
	note B_,4, 56
	silence 14
	note C#,5
	note D_,5
	note E_,5
	note B_,4, 56
	silence 14
	note C#,5
	note D_,5, 7
	note E_,5, 21
	note E_,5, 1
	note F_,5, 2
	note F#,5, 4
	continue 21
	continue 84
	continue 84
	note A_,4, 7
	silence
	note A_,4
	note B_,4
	note F_,5, 1
	note F#,5, 2
	note G_,5, 4
	continue 7
	continue 42
	silence 14
	note F#,5
	note E_,5, 7
	note F#,5, 21
	note E_,5, 28
	note D_,5
	note C#,5
	note A_,4
	note A_,4, 1
	note A#,4, 2
	note B_,4, 4
	continue 21
	note F#,4, 84
	continue 84
	note A_,4, 7
	silence
	note A_,4
	silence
	note B_,4, 56
	silence 14
	note C#,5
	note D_,5, 7
	note E_,5, 14
	note E_,5, 1
	note F_,5, 2
	note F#,5, 4
	continue 21
	note G_,5, 7
	silence 14
	note E_,5, 28
	note C#,5, 14
	note B_,4, 7
	note C#,5, 21
	note C#,5, 28
	note D_,5, 21
	note E_,5, 7
	silence 14
	note A_,4, 21
	note E_,5, 14
	note F_,5, 1
	note F#,5, 2
	note G_,5, 4
	continue 42
	note F#,5, 7
	note E_,5
	note F#,5, 28
	note E_,5, 14
	note D_,5
	note B_,4, 56
	silence 14
	note C#,5
	note D_,5
	note E_,5
	note E_,5, 56
	silence 14
	note F#,5
	note D_,5, 7
	note C#,5, 21
	note C#,5, 14
	note D_,5, 7
	note B_,4, 84
	continue 7
	continue 84
	note A_,4, 7
	silence
	note A_,4
	silence
	note B_,4, 56
	silence 14
	note C#,5
	note D_,5, 7
	note E_,5, 14
	note F#,5, 7
	continue 28
	note B_,4, 21
	note A_,5
	note G_,5, 14
	note F#,5
	note E_,5
	note C#,5, 7
	note D_,5
	silence
	note B_,4, 84
	continue 7
	continue 112
	snd_ret
SndData_BGM_08_Ch2:
	envelope $11
	panning $22
	duty_cycle 1
	note D_,5, 35
SndData_BGM_08_Ch2_0:
	snd_call SndCall_BGM_08_Ch2_0_0
	snd_call SndCall_BGM_08_Ch2_0_0
	snd_call SndCall_BGM_08_Ch2_1
	snd_call SndCall_BGM_08_Ch2_2_0
	snd_call SndCall_BGM_08_Ch2_3
	snd_call SndCall_BGM_08_Ch2_2_0
	snd_call SndCall_BGM_08_Ch2_4
	snd_call SndCall_BGM_08_Ch2_5
	snd_loop SndData_BGM_08_Ch2_0
SndCall_BGM_08_Ch2_0_0:
	envelope $57
	duty_cycle 1
	note B_,4, 7
	silence
	note B_,4
	note A_,4
	silence
	note A_,4
	note B_,4, 42
	continue 7
	note B_,4
	note A_,4, 14
	snd_loop SndCall_BGM_08_Ch2_0_0, $00, 2
	note B_,4, 7
	note A_,4
	silence
	note B_,4, 14
	note A_,4, 7
	silence
	note B_,4
	silence
	note B_,4
	note B_,4
	silence
	note A_,4, 14
	note E_,4
	snd_ret
SndCall_BGM_08_Ch2_1:
	duty_cycle 2
	envelope $58
	note D_,3, 56
	silence 14
	note E_,3, 7
	silence
	note F#,3
	note G_,3, 21
	note A_,3, 42
	note B_,3
	note A_,3, 7
	note B_,3, 21
	note A_,3, 28
	note B_,3, 21
	note C#,4, 7
	silence 14
	note E_,3
	note A_,3
	note C#,4
	note E_,4, 28
	note E_,4, 1
	note F_,4, 2
	note F#,4, 4
	continue 14
	note C#,4, 7
	silence 14
	note A_,3, 7
	silence 14
	note A_,3, 21
	note D_,3, 56
	silence 14
	note E_,3, 7
	silence
	note F#,3
	note G_,3, 21
	note B_,3, 84
	note D_,4, 7
	note D_,4, 21
	note E_,4, 56
	silence 14
	note F#,4, 7
	silence
	note E_,4
	note D_,4, 21
	note B_,3, 1
	note C_,4, 2
	note C#,4, 4
	continue 21
	note C#,4, 28
	note E_,4
	note F#,4
	snd_ret
SndCall_BGM_08_Ch2_2_0:
	envelope $42
	note F#,5, 7
	note D_,5
	note B_,4
	note G_,4
	snd_loop SndCall_BGM_08_Ch2_2_0, $00, 4
SndCall_BGM_08_Ch2_2_1:
	note F#,5, 7
	note E_,5
	note C#,5
	note A_,4
	snd_loop SndCall_BGM_08_Ch2_2_1, $00, 4
	envelope $58
	note B_,4, 56
	note D_,5, 7
	note C#,5
	note B_,4
	note A_,4
	note G_,4
	note F#,4
	note E_,4
	note F#,4
	snd_ret
SndCall_BGM_08_Ch2_3:
	note B_,3, 21
	note C#,4, 7
	silence 14
	note D_,4, 28
	silence 7
	note E_,4
	note F#,4, 14
	note G_,4
	snd_ret
SndCall_BGM_08_Ch2_4:
	note B_,3, 21
	note C#,4, 7
	silence 14
	note D_,4, 42
	note F#,4, 14
	note E_,4
	snd_ret
SndCall_BGM_08_Ch2_5:
	note D_,4, 56
	silence 14
	note E_,4
	note F#,4, 7
	note E_,4, 14
	note A_,4, 28
	note B_,4, 7
	silence 14
	note G_,4, 28
	note E_,4, 14
	silence 7
	note E_,4, 21
	note A_,3, 28
	note B_,3, 21
	note C#,4, 7
	silence 14
	note C#,4, 21
	note C#,4, 14
	note E_,4, 7
	continue 42
	note D_,4, 7
	note C#,4
	note D_,4, 28
	note C#,4, 14
	note B_,3
	note D_,4, 56
	silence 14
	note F#,4
	note G_,4
	note F#,4
	note A_,4, 56
	note G_,4, 28
	note F#,4
	note E_,4, 14
	note E_,4, 7
	note D_,4, 84
	continue 7
	continue 112
	note D_,4, 56
	silence 14
	note E_,4
	note F#,4, 7
	note G_,4, 14
	note A_,4, 7
	continue 28
	note F#,4, 21
	note F#,4
	note E_,4, 14
	note D_,4
	note C#,4
	note E_,4, 7
	note E_,4
	silence
	note B_,3, 84
	continue 7
	continue 112
	snd_ret
SndData_BGM_08_Ch3:
	wave_vol $00
	panning $44
	wave_id $03
	wave_cutoff 0
	silence 35
SndData_BGM_08_Ch3_0:
	wave_vol $80
	snd_call SndCall_BGM_08_Ch3_0
	snd_call SndCall_BGM_08_Ch3_1
	snd_call SndCall_BGM_08_Ch3_2
	snd_call SndCall_BGM_08_Ch3_1
	snd_call SndCall_BGM_08_Ch3_3
	snd_call SndCall_BGM_08_Ch3_4_0
	snd_call SndCall_BGM_08_Ch3_5
	snd_loop SndData_BGM_08_Ch3_0
SndCall_BGM_08_Ch3_0:
	wave_cutoff 0
	note B_,2, 56
	silence 7
	note E_,3
	note F#,3, 14
	note D_,3, 7
	note C#,3
	note A_,2, 14
	note G_,2, 56
	silence 7
	note G_,2
	note G_,3, 14
	silence 7
	note G_,3
	note G_,2, 14
	note E_,2, 28
	note E_,2, 7
	note E_,2, 14
	note E_,3, 7
	silence
	note F#,2, 14
	note F#,2
	note F#,2, 7
	note A_,2
	note B_,2
	wave_cutoff 35
	note B_,2, 14
	note A_,2, 7
	note B_,2
	silence 21
	note B_,2, 7
	note B_,2
	note B_,3
	note B_,2
	note B_,3
	silence
	note B_,2
	note A_,2, 14
	note G_,2
	note F#,2, 7
	note G_,2
	silence 21
	note G_,2, 7
	note G_,2
	note G_,3
	note G_,2
	note G_,3
	silence
	note G_,2
	note F#,2, 14
	note D_,2, 7
	note E_,2, 14
	note E_,2
	wave_cutoff 1
	note E_,2, 7
	note E_,2
	wave_cutoff 35
	note E_,2
	wave_cutoff 1
	note E_,2
	note F#,2
	note F#,2
	wave_cutoff 35
	note F#,2, 14
	note F#,2, 7
	note A_,2
	note B_,2
	snd_ret
SndCall_BGM_08_Ch3_1:
	wave_cutoff 35
	note B_,2, 28
	wave_cutoff 1
	note B_,2, 21
	wave_cutoff 35
	note B_,2, 7
	note B_,2, 28
	note B_,2, 14
	wave_cutoff 1
	note B_,2, 7
	note B_,2
	wave_cutoff 35
	note G_,2, 28
	wave_cutoff 1
	note G_,2, 21
	wave_cutoff 35
	note G_,2, 7
	note G_,2, 28
	note G_,2, 14
	wave_cutoff 1
	note G_,2, 7
	note G_,2
	wave_cutoff 35
	note A_,2, 28
	wave_cutoff 1
	note A_,2, 21
	wave_cutoff 35
	note A_,2, 7
	note A_,2, 28
	note A_,2, 14
	wave_cutoff 1
	note A_,2, 7
	note A_,2
	snd_ret
SndCall_BGM_08_Ch3_2:
	wave_cutoff 35
	note F#,2, 28
	wave_cutoff 1
	note F#,2, 21
	wave_cutoff 35
	note F#,2, 7
	note F#,2, 28
	note F#,2, 14
	note F#,2, 7
	note F#,3
	snd_ret
SndCall_BGM_08_Ch3_3:
	wave_cutoff 35
	note F#,2, 21
	wave_cutoff 1
	note F#,2, 7
	wave_cutoff 35
	note F#,2, 28
	note F#,2, 7
	note E_,2, 14
	note B_,2
	note E_,3
	note F#,3, 7
	snd_ret
SndCall_BGM_08_Ch3_4_0:
	note G_,2, 14
	wave_cutoff 1
	note G_,2, 7
	wave_cutoff 35
	note G_,2
	wave_cutoff 1
	note G_,2, 7
	wave_cutoff 35
	note G_,2, 14
	wave_cutoff 1
	note G_,2, 7
	wave_cutoff 35
	note G_,2, 28
	wave_cutoff 1
	note G_,2, 7
	wave_cutoff 35
	note G_,2
	note F#,3, 14
	note A_,2, 14
	wave_cutoff 1
	note A_,2, 7
	wave_cutoff 35
	note A_,2
	wave_cutoff 1
	note A_,2
	wave_cutoff 35
	note A_,2, 14
	wave_cutoff 1
	note A_,2, 7
	wave_cutoff 35
	note A_,2, 28
	wave_cutoff 1
	note A_,2, 7
	note A_,2
	note A_,2
	wave_cutoff 35
	note A_,3
	note B_,2, 14
	wave_cutoff 1
	note B_,2, 7
	wave_cutoff 35
	note B_,2, 14
	wave_cutoff 1
	note B_,2, 7
	wave_cutoff 35
	note A_,2, 14
	wave_cutoff 1
	note A_,2, 7
	note B_,2
	wave_cutoff 35
	note B_,2, 14
	wave_cutoff 1
	note B_,2, 7
	wave_cutoff 35
	note B_,3
	note A_,2, 14
	note B_,2, 14
	wave_cutoff 1
	note B_,2, 7
	wave_cutoff 35
	note B_,2, 14
	wave_cutoff 1
	note B_,2, 7
	wave_cutoff 35
	note A_,2, 14
	wave_cutoff 1
	note A_,2, 7
	wave_cutoff 35
	note B_,2
	note B_,2, 14
	note B_,2, 7
	note A_,2, 21
	snd_loop SndCall_BGM_08_Ch3_4_0, $00, 2
	snd_ret
SndCall_BGM_08_Ch3_5:
	note B_,2, 28
	wave_cutoff 1
	note B_,2, 21
	wave_cutoff 35
	note B_,2, 7
	note B_,2, 28
	note B_,2, 21
	note G_,2, 21
	wave_cutoff 1
	note G_,2, 7
	wave_cutoff 35
	note E_,2
	wave_cutoff 1
	note E_,2, 14
	wave_cutoff 35
	note E_,2
	wave_cutoff 1
	note E_,2, 7
	wave_cutoff 35
	note E_,2, 14
	note D_,3, 21
	note D_,2, 7
	note E_,2
	note A_,2, 28
	wave_cutoff 1
	note A_,2, 21
	wave_cutoff 35
	note A_,2, 7
	note A_,2, 28
	note C#,3, 21
	note D_,3, 28
	wave_cutoff 1
	note D_,3, 7
	wave_cutoff 35
	note D_,3, 21
	note D_,2, 7
	note D_,2, 28
	note D_,2, 14
	note C#,3, 7
	note D_,3
	note G_,2, 14
	wave_cutoff 1
	note G_,2, 7
	wave_cutoff 35
	note G_,2
	wave_cutoff 1
	note G_,2
	note G_,2
	note G_,2
	wave_cutoff 35
	note G_,2
	note G_,2, 28
	note G_,2, 14
	note F#,3, 7
	note G_,3
	note A_,2, 14
	wave_cutoff 1
	note A_,2, 7
	wave_cutoff 35
	note A_,2
	wave_cutoff 1
	note A_,2
	wave_cutoff 35
	note A_,2, 14
	note A_,2, 7
	note A_,2, 28
	note A_,2, 14
	note G_,3
	note B_,2, 14
	note B_,2, 7
	note B_,2, 28
	wave_cutoff 1
	note B_,2, 7
	wave_cutoff 35
	note B_,2, 3
	wave_cutoff 1
	note B_,2, 4
	wave_cutoff 35
	note B_,2, 7
	note B_,2, 14
	wave_cutoff 1
	note B_,2, 7
	wave_cutoff 35
	note B_,2
	note A_,2, 14
	note B_,2, 14
	note B_,2, 7
	note B_,3
	note B_,2
	note B_,2
	note C#,3
	note D_,3
	note B_,2
	note B_,3
	note B_,2
	note B_,3
	note B_,2
	note B_,3
	note A_,2, 14
	note G_,2, 14
	wave_cutoff 1
	note G_,2, 7
	wave_cutoff 35
	note G_,2
	wave_cutoff 1
	note G_,2, 7
	wave_cutoff 35
	note G_,2, 14
	wave_cutoff 1
	note G_,2, 7
	wave_cutoff 35
	note G_,2, 28
	wave_cutoff 1
	note G_,2, 7
	wave_cutoff 35
	note G_,2
	note F#,3, 14
	note A_,2, 14
	wave_cutoff 1
	note A_,2, 7
	wave_cutoff 35
	note A_,2
	wave_cutoff 1
	note A_,2
	note A_,2, 14
	wave_cutoff 35
	note A_,2, 7
	note A_,2
	wave_cutoff 1
	note A_,2
	wave_cutoff 35
	note A_,2, 21
	note F#,2, 7
	note A_,2, 14
	note B_,2, 14
	wave_cutoff 1
	note B_,2, 7
	wave_cutoff 35
	note B_,2
	wave_cutoff 1
	note B_,2
	wave_cutoff 35
	note B_,2, 14
	note B_,3, 7
	note B_,2, 21
	note B_,2, 7
	wave_cutoff 1
	note B_,2
	wave_cutoff 35
	note B_,2, 14
	note B_,2, 7
	note B_,2, 14
	wave_cutoff 1
	note B_,2, 7
	wave_cutoff 35
	note B_,2
	wave_cutoff 1
	note B_,2
	wave_cutoff 35
	note B_,2, 14
	note B_,3, 7
	note B_,2
	note E_,3, 14
	note A_,3
	note E_,3
	note E_,3, 7
	snd_ret
SndData_BGM_08_Ch4:
	panning $88
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 28
SndData_BGM_08_Ch4_0:
	envelope $61
	note4 F_,5,0, 28
	note4 F_,5,0, 28
	envelope $31
	note4x $21, 28 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 28
	snd_loop SndData_BGM_08_Ch4_0, $00, 2
	envelope $61
	note4 F_,5,0, 21
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	envelope $72
	note4x $32, 7 ; Nearest: A_,5,0
SndData_BGM_08_Ch4_1:
	snd_call SndCall_BGM_08_Ch4_0_0
	snd_call SndCall_BGM_08_Ch4_1
	snd_call SndCall_BGM_08_Ch4_2
	snd_call SndCall_BGM_08_Ch4_1
	snd_call SndCall_BGM_08_Ch4_3
	snd_call SndCall_BGM_08_Ch4_4_0
	snd_call SndCall_BGM_08_Ch4_5
	snd_call SndCall_BGM_08_Ch4_4_0
	snd_call SndCall_BGM_08_Ch4_6
	snd_call SndCall_BGM_08_Ch4_7
	snd_call SndCall_BGM_08_Ch4_8
	snd_call SndCall_BGM_08_Ch4_7
	snd_call SndCall_BGM_08_Ch4_9
	snd_call SndCall_BGM_08_Ch4_A
	snd_loop SndData_BGM_08_Ch4_1
SndCall_BGM_08_Ch4_0_0:
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 14
	note4 F_,5,0, 7
	note4 F_,5,0, 14
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	snd_loop SndCall_BGM_08_Ch4_0_0, $00, 2
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 3
	note4 B_,5,0, 4
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	envelope $72
	note4x $32, 7 ; Nearest: A_,5,0
	note4x $32, 7 ; Nearest: A_,5,0
	snd_ret
SndCall_BGM_08_Ch4_1:
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $53
	note4x $11, 7 ; Nearest: A#,6,0
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	snd_ret
SndCall_BGM_08_Ch4_2:
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	snd_ret
SndCall_BGM_08_Ch4_3:
	envelope $62
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 14
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 21
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 7
	envelope $54
	note4x $22, 3 ; Nearest: A_,5,0
	note4x $22, 4 ; Nearest: A_,5,0
	note4x $22, 7 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	envelope $72
	note4x $32, 7 ; Nearest: A_,5,0
	note4x $32, 7 ; Nearest: A_,5,0
	note4x $32, 7 ; Nearest: A_,5,0
	snd_ret
SndCall_BGM_08_Ch4_4_0:
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	snd_loop SndCall_BGM_08_Ch4_4_0, $00, 3
	snd_ret
SndCall_BGM_08_Ch4_5:
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 3
	note4 B_,5,0, 4
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	envelope $72
	note4x $32, 7 ; Nearest: A_,5,0
	envelope $61
	note4 F_,5,0, 7
	snd_ret
SndCall_BGM_08_Ch4_6:
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	envelope $54
	note4x $22, 7 ; Nearest: A_,5,0
	envelope $72
	note4x $32, 7 ; Nearest: A_,5,0
	note4x $32, 7 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	envelope $72
	note4x $32, 7 ; Nearest: A_,5,0
	note4x $32, 7 ; Nearest: A_,5,0
	snd_ret
SndCall_BGM_08_Ch4_7:
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	snd_ret
SndCall_BGM_08_Ch4_8:
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
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
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $53
	note4x $11, 7 ; Nearest: A#,6,0
	snd_ret
SndCall_BGM_08_Ch4_9:
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	snd_ret
SndCall_BGM_08_Ch4_A:
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 3
	note4 F_,5,0, 4
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $53
	note4x $11, 7 ; Nearest: A#,6,0
	envelope $61
	note4 F_,5,0, 14
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 14
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $53
	note4x $11, 7 ; Nearest: A#,6,0
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $53
	note4x $11, 7 ; Nearest: A#,6,0
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 14
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	envelope $61
	note4 F_,5,0, 14
	note4 F_,5,0, 7
	envelope $54
	note4x $22, 7 ; Nearest: A_,5,0
	note4x $22, 7 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	envelope $72
	note4x $32, 7 ; Nearest: A_,5,0
	note4x $32, 7 ; Nearest: A_,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	envelope $72
	note4x $32, 7 ; Nearest: A_,5,0
	note4x $32, 7 ; Nearest: A_,5,0
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 14
	envelope $62
	note4 B_,5,0, 14
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
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
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
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	envelope $72
	note4 A_,5,0, 7
	envelope $72
	note4x $32, 7 ; Nearest: A_,5,0
	snd_ret
