SndHeader_BGM_04:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_04_Ch1 ; Data ptr
	db -4 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_04_Ch2 ; Data ptr
	db -4 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_04_Ch3 ; Data ptr
	db -4 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_04_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_04_Ch1:
	envelope $11
	panning $11
	duty_cycle 0
	note A_,4, 24
	snd_call SndCall_BGM_04_Ch1_0_0
SndData_BGM_04_Ch1_0:
	snd_call SndCall_BGM_04_Ch1_1_0
	snd_call SndCall_BGM_04_Ch1_0_0
	snd_call SndCall_BGM_04_Ch1_1_0
	snd_call SndCall_BGM_04_Ch1_2
	snd_loop SndData_BGM_04_Ch1_0
SndCall_BGM_04_Ch1_0_0:
	envelope $64
	note A_,4, 8
	note C#,5
	note E_,5
	note G#,5
	note C#,5
	note E_,5
	note A_,4
	note C#,5
	note E_,5
	note G#,5
	note C#,5
	note E_,5
	note G#,5
	note A_,4
	note C#,5
	note E_,5
	note C#,5
	note E_,5
	note G#,5
	note A_,4
	note C#,5
	note E_,5
	snd_loop SndCall_BGM_04_Ch1_0_0, $00, 2
	snd_ret
SndCall_BGM_04_Ch1_1_0:
	envelope $78
	duty_cycle 3
	note G#,5, 8
	note G#,5
	note E_,5
	note F#,5, 16
	note C#,5, 8
	silence
	note E_,5
	silence
	note B_,4
	note C#,5, 64
	envelope $11
	note C#,5, 32
	envelope $78
	note E_,5, 8
	note D_,5
	note C#,5
	note D_,5, 16
	note C#,5
	note A_,4, 8
	silence
	note A_,4
	note B_,4, 64
	envelope $11
	note B_,4, 32
	snd_loop SndCall_BGM_04_Ch1_1_0, $00, 2
	snd_ret
SndCall_BGM_04_Ch1_2:
	envelope $78
	silence 8
	note E_,5
	silence
	note F#,5
	silence 16
	note G_,5, 8
	silence
	note A_,5
	silence 16
	note B_,5, 32
	note A#,5, 1
	note A_,5
	note G#,5
	note G_,5
	note F#,5
	note F_,5
	note E_,5
	note D#,5
	envelope $11
	note G#,5, 32
	envelope $78
	duty_cycle 2
	note G#,5, 8
	note G#,5
	note F#,5
	note G#,5
	envelope $11
	note G#,5, 16
	envelope $78
	note G#,5, 8
	note A_,5
	note A#,5
	note B_,5
	note A_,5
	note G#,5
	note E_,5
	note G#,5
	note C#,5, 48
	note B_,4, 8
	note C_,5
	note C#,5
	note E_,5
	note C#,5
	note F_,5
	note C#,5
	note G#,5
	note F#,5
	note E_,5
	note G#,5
	silence
	note A_,5
	silence
	note A_,5
	silence
	note C#,5
	note C_,5
	note B_,4
	note F#,5
	snd_ret
SndData_BGM_04_Ch2:
	envelope $11
	panning $22
	duty_cycle 0
	note A_,4, 24
	snd_call SndCall_BGM_04_Ch2_0
SndData_BGM_04_Ch2_0:
	snd_call SndCall_BGM_04_Ch2_1
	snd_call SndCall_BGM_04_Ch2_2
	snd_call SndCall_BGM_04_Ch2_1
	snd_call SndCall_BGM_04_Ch2_3
	snd_call SndCall_BGM_04_Ch2_0
	snd_call SndCall_BGM_04_Ch2_1
	snd_call SndCall_BGM_04_Ch2_2
	snd_call SndCall_BGM_04_Ch2_1
	snd_call SndCall_BGM_04_Ch2_3
	snd_call SndCall_BGM_04_Ch2_4
	snd_loop SndData_BGM_04_Ch2_0
SndCall_BGM_04_Ch2_0:
	envelope $11
	note A_,3, 16
	envelope $37
	note A_,4, 8
	note C#,5
	note E_,5
	note G#,5
	note C#,5
	note E_,5
	note A_,4
	note C#,5
	note E_,5
	note G#,5
	note C#,5
	note E_,5
	note G#,5
	note A_,4
	note C#,5
	note E_,5
	note C#,5
	note E_,5
	note G#,5
	note A_,4
	note C#,5
	note E_,5
	note A_,4
	note C#,5
	note E_,5
	note G#,5
	note C#,5
	note E_,5
	note A_,4
	note C#,5
	note E_,5
	note G#,5
	note C#,5
	note E_,5
	note G#,5
	note A_,4
	note C#,5
	note E_,5
	note C#,5
	note E_,5
	note G#,5
	note A_,4
	snd_ret
SndCall_BGM_04_Ch2_1:
	envelope $68
	duty_cycle 2
	note G#,4, 8
	note G#,4
	note E_,4
	note F#,4, 16
	note C#,4, 8
	silence
	note E_,4
	silence
	note B_,3
	note C#,4, 64
	envelope $11
	note C#,4, 32
	snd_ret
SndCall_BGM_04_Ch2_2:
	envelope $68
	note B_,4, 8
	note A_,4
	note G#,4
	note A_,4, 16
	note G#,4
	note E_,4, 8
	silence
	note E_,4
	note F#,4, 64
	envelope $11
	note F#,4, 32
	snd_ret
SndCall_BGM_04_Ch2_3:
	envelope $68
	note A_,5, 8
	note G_,5
	note F#,5
	note G_,5, 16
	note F#,5
	note D_,5, 8
	silence
	note D_,5
	note E_,5, 64
	envelope $11
	note E_,5, 32
	snd_ret
SndCall_BGM_04_Ch2_4:
	envelope $68
	silence 8
	note E_,4
	silence
	note F#,4
	silence 16
	note G_,4, 8
	silence
	note A_,4
	silence 16
	note B_,4, 32
	note A#,4, 1
	note A_,4
	note G#,4
	note G_,4
	note F#,4
	note F_,4
	note E_,4
	note D#,4
	envelope $11
	note G#,5, 48
	envelope $38
	duty_cycle 2
	note G#,5, 8
	note G#,5
	note F#,5
	note G#,5
	envelope $11
	note G#,5, 16
	envelope $38
	note G#,5, 8
	note A_,5
	note A#,5
	note B_,5
	note A_,5
	note G#,5
	note E_,5
	note G#,5
	note C#,5, 48
	note B_,4, 8
	note C_,5
	note C#,5
	note E_,5
	note C#,5
	note F_,5
	note C#,5
	note G#,5
	note F#,5
	note E_,5
	note G#,5
	silence
	note A_,5
	silence
	note A_,5
	silence
	note C#,5
	note C_,5
	snd_ret
SndData_BGM_04_Ch3:
	wave_vol $00
	panning $44
	wave_id $03
	wave_cutoff 30
	note A_,4, 24
	wave_vol $80
SndData_BGM_04_Ch3_0:
	snd_call SndCall_BGM_04_Ch3_0_0
	snd_call SndCall_BGM_04_Ch3_1_0
	snd_loop SndData_BGM_04_Ch3_0
SndCall_BGM_04_Ch3_0_0:
	note F#,3, 8
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note A_,3
	silence
	note E_,3, 16
	note F#,3, 8
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note A_,3
	silence
	note E_,3, 16
	note F#,3, 8
	silence
	note F#,3
	snd_loop SndCall_BGM_04_Ch3_0_0, $00, 2
	snd_ret
SndCall_BGM_04_Ch3_1_0:
	note F#,3, 8
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note A_,3
	silence
	note E_,3, 16
	note F#,3, 8
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note A_,3
	silence
	note E_,3, 16
	note F#,3, 8
	silence
	note F#,3
	snd_loop SndCall_BGM_04_Ch3_1_0, $00, 10
	silence 8
	note E_,3
	note E_,3
	note F#,3
	silence 16
	note G_,3, 8
	silence
	note A_,3
	silence 16
	note B_,3, 32
	continue 8
	snd_ret
SndData_BGM_04_Ch4:
	panning $88
	envelope $61
	note4 F_,5,0, 4
	note4 F_,5,0, 4
	envelope $62
	note4 B_,5,0, 8
	note4 B_,5,0, 8
	snd_call SndCall_BGM_04_Ch4_0
	snd_call SndCall_BGM_04_Ch4_1
	snd_call SndCall_BGM_04_Ch4_0
	snd_call SndCall_BGM_04_Ch4_2
SndData_BGM_04_Ch4_0:
	snd_call SndCall_BGM_04_Ch4_0
	snd_call SndCall_BGM_04_Ch4_1
	snd_call SndCall_BGM_04_Ch4_0
	snd_call SndCall_BGM_04_Ch4_1
	snd_call SndCall_BGM_04_Ch4_0
	snd_call SndCall_BGM_04_Ch4_1
	snd_call SndCall_BGM_04_Ch4_0
	snd_call SndCall_BGM_04_Ch4_1
	snd_call SndCall_BGM_04_Ch4_0
	snd_call SndCall_BGM_04_Ch4_1
	snd_call SndCall_BGM_04_Ch4_3
	snd_call SndCall_BGM_04_Ch4_4
	snd_call SndCall_BGM_04_Ch4_5
	snd_call SndCall_BGM_04_Ch4_6
	snd_call SndCall_BGM_04_Ch4_5
	snd_call SndCall_BGM_04_Ch4_7
	snd_call SndCall_BGM_04_Ch4_0
	snd_call SndCall_BGM_04_Ch4_1
	snd_call SndCall_BGM_04_Ch4_0
	snd_call SndCall_BGM_04_Ch4_1
	snd_loop SndData_BGM_04_Ch4_0
SndCall_BGM_04_Ch4_0:
	envelope $61
	note4 F_,5,0, 16
	envelope $31
	note4 B_,5,0, 8
	envelope $61
	note4 F_,5,0, 8
	envelope $62
	note4 B_,5,0, 8
	envelope $61
	note4 F_,5,0, 8
	envelope $31
	note4 B_,5,0, 8
	envelope $61
	note4 F_,5,0, 8
	envelope $31
	note4 B_,5,0, 16
	envelope $61
	note4 F_,5,0, 8
	envelope $62
	note4 B_,5,0, 8
	envelope $31
	note4 B_,5,0, 8
	envelope $61
	note4 F_,5,0, 8
	envelope $31
	note4 B_,5,0, 16
	envelope $61
	note4 F_,5,0, 8
	note4 F_,5,0, 8
	envelope $31
	note4 B_,5,0, 16
	snd_ret
SndCall_BGM_04_Ch4_1:
	envelope $62
	note4 B_,5,0, 16
	snd_ret
SndCall_BGM_04_Ch4_2:
	envelope $62
	note4 B_,5,0, 8
	note4 B_,5,0, 8
	snd_ret
SndCall_BGM_04_Ch4_3:
	envelope $61
	note4 F_,5,0, 16
	envelope $31
	note4 B_,5,0, 8
	envelope $61
	note4 F_,5,0, 8
	envelope $62
	note4 B_,5,0, 8
	envelope $61
	note4 F_,5,0, 8
	envelope $31
	note4 B_,5,0, 8
	envelope $61
	note4 F_,5,0, 8
	envelope $31
	note4 B_,5,0, 16
	snd_ret
SndCall_BGM_04_Ch4_4:
	envelope $61
	note4 F_,5,0, 8
	envelope $62
	note4 B_,5,0, 8
	envelope $31
	note4 B_,5,0, 8
	envelope $61
	note4 F_,5,0, 8
	envelope $31
	note4 B_,5,0, 16
	envelope $61
	note4 F_,5,0, 8
	note4 F_,5,0, 8
	envelope $62
	note4 B_,5,0, 8
	note4 B_,5,0, 4
	note4 B_,5,0, 4
	envelope $61
	note4 F_,5,0, 8
	envelope $62
	note4 B_,5,0, 8
	snd_ret
SndCall_BGM_04_Ch4_5:
	envelope $61
	note4 F_,5,0, 16
	envelope $62
	note4 B_,5,0, 8
	envelope $61
	note4 F_,5,0, 8
	envelope $31
	note4 B_,5,0, 16
	envelope $62
	note4 B_,5,0, 16
	envelope $31
	note4 B_,5,0, 8
	envelope $61
	note4 F_,5,0, 8
	envelope $62
	note4 B_,5,0, 16
	envelope $61
	note4 F_,5,0, 16
	envelope $62
	note4 B_,5,0, 8
	envelope $61
	note4 F_,5,0, 8
	envelope $31
	note4 B_,5,0, 16
	envelope $62
	note4 B_,5,0, 16
	envelope $61
	note4 F_,5,0, 16
	envelope $62
	note4 B_,5,0, 16
	envelope $61
	note4 F_,5,0, 16
	envelope $62
	note4 B_,5,0, 8
	envelope $61
	note4 F_,5,0, 8
	envelope $31
	note4 B_,5,0, 16
	envelope $62
	note4 B_,5,0, 16
	snd_ret
SndCall_BGM_04_Ch4_6:
	envelope $31
	note4 B_,5,0, 8
	envelope $61
	note4 F_,5,0, 8
	envelope $62
	note4 B_,5,0, 16
	envelope $61
	note4 F_,5,0, 16
	envelope $62
	note4 B_,5,0, 16
	envelope $61
	note4 F_,5,0, 16
	envelope $62
	note4 B_,5,0, 16
	snd_ret
SndCall_BGM_04_Ch4_7:
	envelope $31
	note4 B_,5,0, 8
	envelope $61
	note4 F_,5,0, 8
	envelope $62
	note4 B_,5,0, 16
	envelope $61
	note4 F_,5,0, 16
	envelope $62
	note4 B_,5,0, 16
	note4 B_,5,0, 8
	envelope $72
	note4 A_,5,0, 4
	envelope $72
	note4x $32, 4 ; Nearest: A_,5,0
	envelope $62
	note4 B_,5,0, 8
	note4 B_,5,0, 8
	note4 B_,5,0, 8
	envelope $61
	note4 F_,5,0, 16
	note4 F_,5,0, 16
	envelope $62
	note4 B_,5,0, 8
	note4 B_,5,0, 16
	envelope $61
	note4 F_,5,0, 16
	envelope $62
	note4 B_,5,0, 8
	envelope $61
	note4 F_,5,0, 13
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 21
	snd_ret
