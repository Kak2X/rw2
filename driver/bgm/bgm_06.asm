SndHeader_BGM_06:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_06_Ch1 ; Data ptr
	db -3 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_06_Ch2 ; Data ptr
	db -3 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_06_Ch3 ; Data ptr
	db -3 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_06_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_06_Ch1:
	envelope $11
	panning $11
	duty_cycle 2
	note C_,2, 112
	note C_,2, 112
	note C_,2, 112
	note C_,2, 112
SndData_BGM_06_Ch1_0:
	snd_call SndCall_BGM_06_Ch1_0
	snd_call SndCall_BGM_06_Ch1_1_0
	snd_call SndCall_BGM_06_Ch1_2_0
	snd_call SndCall_BGM_06_Ch1_3
	snd_loop SndData_BGM_06_Ch1_0
SndCall_BGM_06_Ch1_0:
	envelope $11
	note C_,2, 112
	note C_,2, 112
	note C_,2, 112
	note C_,2, 112
	snd_ret
SndCall_BGM_06_Ch1_1_0:
	envelope $58
	duty_cycle 2
	note C#,5, 1
	note D_,5, 2
	note D#,5
	note D#,5
	continue 21
	note F#,5, 21
	note D#,5, 7
	silence
	note C#,5, 1
	note D_,5, 2
	note D#,5
	note D#,5
	continue 14
	note C#,5, 7
	silence
	note F#,4
	silence
	note C#,4, 1
	note D_,4, 2
	note D#,4
	note D#,4
	continue 21
	note C#,5, 21
	note B_,4, 7
	silence
	note G#,4, 14
	note A#,4, 7
	note B_,4, 28
	snd_loop SndCall_BGM_06_Ch1_1_0, $00, 2
	note A#,4, 28
	note E_,4, 1
	note F_,4, 2
	note F#,4
	note F#,4
	continue 21
	silence 14
	note C#,5, 7
	note D#,5
	note C#,5
	note B_,4
	note A#,4, 14
	note E_,4, 28
	note F#,4
	silence 7
	note C#,5, 14
	note D#,5, 7
	note C#,5
	note B_,4
	note A#,4
	note G#,4
	note A#,4, 28
	note C#,5, 21
	note F#,4, 7
	silence 14
	note C#,5, 7
	note D#,5
	note C#,5
	note B_,4
	note A#,4, 14
	note E_,4, 28
	note E_,4, 21
	silence 7
	silence
	note C#,5, 14
	note D#,5, 7
	note C#,5
	note B_,4
	note A#,4
	note C#,5
	snd_ret
SndCall_BGM_06_Ch1_2_0:
	note C#,5, 1
	note D_,5, 2
	note D#,5
	note D#,5
	continue 21
	note F#,5, 21
	note D#,5, 7
	silence
	note C#,5, 1
	note D_,5, 2
	note D#,5
	note D#,5
	continue 14
	note C#,5, 7
	silence
	note F#,4
	silence
	note C#,4, 1
	note D_,4, 2
	note D#,4
	note D#,4
	continue 21
	note C#,5, 21
	note B_,4, 7
	silence
	note G#,4, 14
	note A#,4, 7
	note B_,4, 28
	snd_loop SndCall_BGM_06_Ch1_2_0, $00, 2
	snd_ret
SndCall_BGM_06_Ch1_3:
	note B_,4, 28
	note A#,4, 21
	note G#,4, 7
	silence 14
	note G#,4
	note A#,4, 7
	note B_,4, 21
	note C#,5, 42
	note B_,4, 7
	note A#,4
	note F#,4, 14
	note F#,4
	note G#,4, 7
	note F#,4, 21
	note E_,4, 28
	note G#,4
	note B_,4, 14
	note D#,5, 28
	note C#,5, 7
	note B_,4
	note A#,4, 42
	note B_,4, 7
	note C#,5
	note D#,4
	note D#,5
	note C#,4
	note C#,5
	note C#,4
	note D#,5
	note F#,5
	note A#,5
	envelope $77
	duty_cycle 3
	note G#,5
	note G#,5
	note B_,5
	note G#,5
	note A#,5
	silence
	note F#,5
	note G#,5
	silence
	note G#,5
	note B_,5
	note G#,5
	note A#,5
	note B_,5
	note G#,5, 14
	note A#,5, 28
	note B_,5, 21
	note C#,6, 7
	note B_,5, 14
	note A#,5
	note D#,5
	note F#,5
	note G#,5, 7
	note G#,5
	note B_,5
	note G#,5
	note A#,5
	silence
	note F#,5
	note G#,5
	silence
	note G#,5
	note B_,5
	note G#,5
	note A#,5
	note B_,5
	note G#,5, 14
	note A#,5, 28
	note B_,5, 21
	note C#,6, 7
	note B_,5, 14
	note A#,5
	silence 7
	note D#,5
	note F#,5
	note A#,5
	envelope $78
	note G#,5, 56
	envelope $68
	note G#,5
	envelope $58
	note G#,5
	envelope $48
	note G#,5
	snd_ret
SndData_BGM_06_Ch2:
	envelope $57
	panning $22
	duty_cycle 1
	snd_call SndCall_BGM_06_Ch2_0_0
SndData_BGM_06_Ch2_0:
	snd_call SndCall_BGM_06_Ch2_1_0
	snd_call SndCall_BGM_06_Ch2_1_0
	snd_call SndCall_BGM_06_Ch2_2_0
	snd_call SndCall_BGM_06_Ch2_1_0
	snd_call SndCall_BGM_06_Ch2_3
	snd_loop SndData_BGM_06_Ch2_0
SndCall_BGM_06_Ch2_0_0:
	note G#,2, 28
	note A#,2
	note B_,2, 7
	silence
	note C#,3, 42
	silence 7
	note G#,2
	silence
	note G#,2
	note A#,2, 28
	note B_,2, 21
	note C#,3, 7
	silence 14
	note D#,2
	snd_loop SndCall_BGM_06_Ch2_0_0, $00, 2
	snd_ret
SndCall_BGM_06_Ch2_1_0:
	envelope $43
	duty_cycle 1
	fine_tune 12
	note G#,3, 7
	note C#,4
	note D#,4
	note C#,4
	note B_,3
	note C#,4
	note B_,3
	note F#,3
	silence
	note G#,3
	silence
	note D#,3
	note F#,3
	note G#,3
	note C#,4
	note D#,4
	silence
	note C#,3
	note D#,3
	note F#,3
	note G#,3
	note A#,3
	note B_,3
	note F#,3
	silence
	note G#,3
	silence
	note D#,3
	note C#,4
	note D#,4
	note B_,3
	note F#,3
	fine_tune -12
	snd_loop SndCall_BGM_06_Ch2_1_0, $00, 2
	snd_ret
SndCall_BGM_06_Ch2_2_0:
	fine_tune 12
	note F#,3, 7
	note B_,3
	note C#,4
	note B_,3
	note A#,3
	note B_,3
	note A#,3
	note E_,3
	silence
	note F#,3
	silence
	note C#,3
	note E_,3
	note F#,3
	note B_,3
	note C#,4
	silence
	note B_,2
	note C#,3
	note E_,3
	note F#,3
	note G#,3
	note A#,3
	note E_,3
	silence
	note F#,3
	silence
	note C#,3
	note B_,3
	note C#,4
	note A#,3
	note E_,3
	fine_tune -12
	snd_loop SndCall_BGM_06_Ch2_2_0, $00, 2
	snd_ret
SndCall_BGM_06_Ch2_3:
	fine_tune 12
	note E_,3, 7
	note A#,3
	note B_,3
	note A#,3
	note G#,3
	note A#,3
	note G#,3
	note D#,3
	silence
	note B_,3
	silence
	note G#,3
	note G#,3
	note B_,3
	note D#,4
	note E_,4
	silence
	note D#,3
	note F#,3
	note G#,3
	note A#,3
	note B_,3
	note A#,3
	note F#,3
	silence
	note D#,3
	silence
	note F#,3
	note D#,3
	note F#,3
	note G#,3
	note A#,3
	silence
	note G#,3
	note A#,3
	note B_,3
	silence
	note G#,3
	note A#,3
	note B_,3
	envelope $47
	note D#,3, 28
	note E_,3
	envelope $43
	silence 7
	note A#,3
	note B_,3
	note C#,4
	silence
	note A#,3
	note B_,3
	note C#,4
	envelope $47
	note E_,3, 28
	note F#,3
	fine_tune -12
SndCall_BGM_06_Ch2_3_0:
	envelope $67
	duty_cycle 2
	note D#,5, 7
	note D#,5
	note G#,5
	note D#,5
	note F#,5
	silence
	note C#,5
	note D#,5
	silence
	note D#,5
	note G#,5
	note D#,5
	note F#,5
	note G#,5
	note C#,5, 14
	envelope $53
	duty_cycle 1
	silence 7
	note C#,4
	note E_,4
	note F#,4
	silence
	note C#,4
	note E_,4
	note F#,4
	silence
	note F#,4
	silence
	note C#,4
	note B_,4
	note C#,5
	note A#,4
	note E_,4
	snd_loop SndCall_BGM_06_Ch2_3_0, $00, 2
	envelope $57
	silence 7
	note G#,4
	note B_,4
	note C#,5
	note D#,5, 84
	silence 7
	note F#,4
	note A#,4
	note B_,4
	note C#,5
	note B_,4
	note A#,4
	note C#,5, 35
	note F#,4, 28
	snd_ret
SndData_BGM_06_Ch3:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 80
	snd_call SndCall_BGM_06_Ch3_0_0
SndData_BGM_06_Ch3_0:
	snd_call SndCall_BGM_06_Ch3_1_0
	snd_call SndCall_BGM_06_Ch3_1_0
	snd_call SndCall_BGM_06_Ch3_2_0
	snd_call SndCall_BGM_06_Ch3_1_0
	snd_call SndCall_BGM_06_Ch3_3
	snd_call SndCall_BGM_06_Ch3_4_0
	snd_loop SndData_BGM_06_Ch3_0
SndCall_BGM_06_Ch3_0_0:
	note G#,2, 28
	note A#,2
	note B_,2, 7
	silence
	note C#,3, 42
	silence 7
	note G#,2
	silence
	note G#,2
	note A#,2, 28
	note B_,2, 21
	note C#,3, 7
	silence 14
	note D#,2
	snd_loop SndCall_BGM_06_Ch3_0_0, $00, 2
	snd_ret
SndCall_BGM_06_Ch3_1_0:
	note G#,2, 21
	note G#,2
	note G#,2, 14
	silence 7
	note B_,2, 14
	note G#,2, 7
	note C#,3, 14
	note B_,2
	note G#,2, 21
	note G#,2
	note G#,2, 14
	silence 7
	note B_,2, 14
	note G#,2, 7
	note C#,3
	note D#,3
	note F#,2
	note F#,2
	snd_loop SndCall_BGM_06_Ch3_1_0, $00, 2
	snd_ret
SndCall_BGM_06_Ch3_2_0:
	note F#,2, 21
	note F#,2
	note F#,2, 14
	silence 7
	note A#,2, 14
	note F#,2, 7
	note B_,2, 14
	note A#,2
	note F#,2, 21
	note F#,2
	note F#,2, 14
	silence 7
	note A#,2, 14
	note F#,2, 7
	note B_,2
	note C#,3
	note E_,2
	note E_,2
	snd_loop SndCall_BGM_06_Ch3_2_0, $00, 2
	snd_ret
SndCall_BGM_06_Ch3_3:
	fine_tune 12
	note E_,2, 21
	note E_,2
	note E_,2, 14
	silence 7
	note G#,2, 14
	note E_,2, 7
	note A#,2, 14
	note G#,2
	note D#,2, 21
	note D#,2
	note D#,2, 14
	silence 7
	note F#,2, 14
	note D#,2, 7
	note G#,2
	note A#,2
	note D#,2
	note D#,2
	note E_,2, 21
	note E_,2
	note E_,2, 14
	silence 7
	note G#,2, 14
	note E_,2, 7
	note B_,2, 14
	note A#,2
	note F#,2, 21
	note F#,2
	note F#,2, 14
	silence 7
	note F#,2, 14
	note F#,2, 7
	note B_,2
	note C#,3
	note F#,2
	note F#,2
	fine_tune -12
	snd_ret
SndCall_BGM_06_Ch3_4_0:
	wave_cutoff 30
	note G#,2, 14
	note G#,2, 7
	note G#,2
	note G#,2, 14
	note G#,2, 7
	note G#,2, 14
	note B_,2
	note G#,2, 7
	note C#,3
	note D#,3
	note G#,2
	note G#,2
	note F#,2, 14
	note F#,2, 7
	note F#,2
	note F#,2, 14
	note F#,2, 7
	note F#,2, 14
	note A#,2
	note F#,2, 7
	note B_,2
	note C#,3
	note F#,2
	note F#,2
	snd_loop SndCall_BGM_06_Ch3_4_0, $00, 2
	wave_cutoff 80
	note E_,2, 21
	note E_,2
	note E_,2, 14
	silence 7
	note G#,2, 14
	note E_,2, 7
	note B_,2, 14
	note A#,2
	note F#,2, 21
	note F#,2
	note F#,2, 14
	silence 7
	note A#,2, 14
	note F#,2, 7
	note B_,2
	note C#,3
	note F#,2
	note F#,2
	snd_ret
SndData_BGM_06_Ch4:
	panning $88
	snd_call SndCall_BGM_06_Ch4_0
	snd_call SndCall_BGM_06_Ch4_1
	snd_call SndCall_BGM_06_Ch4_0
	snd_call SndCall_BGM_06_Ch4_2
	snd_call SndCall_BGM_06_Ch4_0
	snd_call SndCall_BGM_06_Ch4_1
	snd_call SndCall_BGM_06_Ch4_0
	snd_call SndCall_BGM_06_Ch4_3
SndData_BGM_06_Ch4_0:
	snd_call SndCall_BGM_06_Ch4_4_0
	snd_call SndCall_BGM_06_Ch4_5
	snd_call SndCall_BGM_06_Ch4_4_0
	snd_call SndCall_BGM_06_Ch4_6
	snd_call SndCall_BGM_06_Ch4_4_0
	snd_call SndCall_BGM_06_Ch4_5
	snd_call SndCall_BGM_06_Ch4_4_0
	snd_call SndCall_BGM_06_Ch4_5
	snd_call SndCall_BGM_06_Ch4_4_0
	snd_call SndCall_BGM_06_Ch4_5
	snd_call SndCall_BGM_06_Ch4_4_0
	snd_call SndCall_BGM_06_Ch4_7
	snd_call SndCall_BGM_06_Ch4_4_0
	snd_call SndCall_BGM_06_Ch4_5
	snd_call SndCall_BGM_06_Ch4_4_0
	snd_call SndCall_BGM_06_Ch4_8
	snd_call SndCall_BGM_06_Ch4_4_0
	snd_call SndCall_BGM_06_Ch4_9
	snd_call SndCall_BGM_06_Ch4_4_0
	snd_call SndCall_BGM_06_Ch4_A
	snd_call SndCall_BGM_06_Ch4_B
	snd_call SndCall_BGM_06_Ch4_C
	snd_call SndCall_BGM_06_Ch4_B
	snd_call SndCall_BGM_06_Ch4_D
	snd_call SndCall_BGM_06_Ch4_B
	snd_call SndCall_BGM_06_Ch4_C
	snd_call SndCall_BGM_06_Ch4_B
	snd_call SndCall_BGM_06_Ch4_E
	snd_call SndCall_BGM_06_Ch4_B
	snd_call SndCall_BGM_06_Ch4_E
	snd_call SndCall_BGM_06_Ch4_F
	snd_loop SndData_BGM_06_Ch4_0
SndCall_BGM_06_Ch4_0:
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
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
	snd_ret
SndCall_BGM_06_Ch4_1:
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	snd_ret
SndCall_BGM_06_Ch4_2:
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	snd_ret
SndCall_BGM_06_Ch4_3:
	envelope $62
	note4 B_,5,0, 7
	envelope $54
	note4x $22, 7 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 7
	envelope $72
	note4x $32, 7 ; Nearest: A_,5,0
	snd_ret
SndCall_BGM_06_Ch4_4_0:
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	snd_loop SndCall_BGM_06_Ch4_4_0, $00, 3
	snd_ret
SndCall_BGM_06_Ch4_5:
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	snd_ret
SndCall_BGM_06_Ch4_6:
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	snd_ret
SndCall_BGM_06_Ch4_7:
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	snd_ret
SndCall_BGM_06_Ch4_8:
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	snd_ret
SndCall_BGM_06_Ch4_9:
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	snd_ret
SndCall_BGM_06_Ch4_A:
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	snd_ret
SndCall_BGM_06_Ch4_B:
	envelope $61
	note4 F_,5,0, 14
	envelope $53
	note4x $11, 14 ; Nearest: A#,6,0
	envelope $62
	note4 B_,5,0, 14
	envelope $53
	note4x $11, 14 ; Nearest: A#,6,0
	envelope $61
	note4 F_,5,0, 14
	envelope $53
	note4x $11, 14 ; Nearest: A#,6,0
	snd_ret
SndCall_BGM_06_Ch4_C:
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	envelope $53
	note4x $11, 14 ; Nearest: A#,6,0
	snd_ret
SndCall_BGM_06_Ch4_D:
	envelope $62
	note4 B_,5,0, 14
	note4 B_,5,0, 7
	envelope $53
	note4x $11, 7 ; Nearest: A#,6,0
	snd_ret
SndCall_BGM_06_Ch4_E:
	envelope $62
	note4 B_,5,0, 14
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	snd_ret
SndCall_BGM_06_Ch4_F:
	envelope $61
	note4 F_,5,0, 14
	envelope $53
	note4x $11, 14 ; Nearest: A#,6,0
	envelope $62
	note4 B_,5,0, 14
	envelope $53
	note4x $11, 7 ; Nearest: A#,6,0
	envelope $61
	note4 F_,5,0, 14
	envelope $62
	note4 B_,5,0, 7
	envelope $53
	note4x $11, 7 ; Nearest: A#,6,0
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	snd_ret
