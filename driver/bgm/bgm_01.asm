SndHeader_BGM_01:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_01_Ch1 ; Data ptr
	db 11 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_01_Ch2 ; Data ptr
	db -1 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_01_Ch3 ; Data ptr
	db -1 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_01_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_01_Ch1:
	envelope $11
	panning $11
	duty_cycle 3
	note A#,3, 24
SndData_BGM_01_Ch1_0:
	envelope $11
	note A#,3, 96
	continue 24
	envelope $78
	note A#,3, 48
	note C_,4, 24
	note D_,4, 6
	note C_,4
	silence
	note A#,3, 72
	continue 3
	silence
	note A#,3, 4
	silence 2
	note A#,3, 4
	silence 2
	silence 12
	note A_,3, 48
	note A#,3, 12
	note D_,3, 6
	note F_,3
	snd_call SndCall_BGM_01_Ch1_0
	snd_loop SndData_BGM_01_Ch1_0
SndCall_BGM_01_Ch1_0:
	note G_,3, 60
	note G_,3, 12
	note A_,3
	note A#,3
	note C_,4, 36
	note A#,3, 6
	note A_,3
	note A#,3, 24
	note G_,3
	note A_,3, 60
	note A#,3, 12
	note C_,4
	note G_,3
	note F_,3, 24
	note D#,4, 36
	continue 6
	note D_,4
	note C_,4, 12
	note A#,3
	note A_,3, 6
	note G_,3
	silence 12
	note G_,3, 36
	note G_,3, 12
	note A_,3
	note A#,3
	note D_,4, 6
	note C_,4
	silence 12
	note C_,4, 48
	note A#,3, 24
	note A_,3, 60
	note A#,3, 12
	note C_,4
	note D_,4
	note D#,4, 12
	silence
	note D_,4, 36
	note C_,4, 24
	note D_,4, 12
	note A#,3, 60
	note G_,3, 12
	note A_,3
	note A#,3
	note C_,4, 60
	note A#,3, 12
	note A_,3, 6
	note D_,3, 18
	silence 6
	note G_,3, 18
	note A_,3, 6
	silence
	note A#,3
	silence
	note C_,4, 18
	note D_,4, 30
	note A#,3, 60
	note G_,3, 12
	note A_,3
	note A#,3
	note C_,4, 60
	note D_,4, 12
	note D#,4, 6
	note D_,4, 18
	silence 6
	note A_,3, 1
	note A#,3
	note B_,3
	note C_,4
	note C#,4
	note D_,4
	continue 12
	note C_,4, 6
	silence
	note A#,3
	silence
	note A_,3, 18
	note G#,3
	note G_,3, 12
	note F#,3, 72
	note D_,4, 4
	silence 2
	note D_,4, 4
	silence 2
	silence 12
	silence 24
	note D_,3
	note A_,3, 12
	note A#,3, 6
	note C_,4
	silence
	note D_,4
	silence
	note A#,3
	continue 24
	note D_,3
	note A_,3, 12
	note A#,3, 6
	note C_,4
	silence
	note D_,4
	silence
	note A#,3
	continue 12
	note A_,3, 6
	note G_,3, 48
	note A_,3, 18
	note A#,3, 12
	note C_,4, 6
	note A#,3
	note A_,3
	note D_,3, 72
	continue 6
	silence 24
	note D_,3
	note A_,3, 12
	note A#,3, 6
	note C_,4
	silence
	note D_,4
	silence
	note A#,3
	continue 24
	note D_,3
	note A_,3, 12
	note A#,3, 6
	note C_,4
	silence
	note D_,4
	silence
	note C_,4
	continue 6
	note A#,3
	note A_,3
	note G_,3
	note G_,3, 36
	note A_,3, 12
	note A#,3
	note C_,4
	note D#,3, 24
	note D_,4, 36
	continue 6
	note C_,4
	note A#,3, 12
	note A_,3
	note A_,3, 6
	note G_,3
	silence
	note G_,3, 72
	continue 6
	continue 96
	snd_ret
SndData_BGM_01_Ch2:
	envelope $11
	panning $22
	duty_cycle 3
	note G_,4, 24
SndData_BGM_01_Ch2_0:
	envelope $11
	note G_,4, 96
	continue 24
	envelope $68
	note G_,4, 48
	note A_,4, 24
	note A#,4, 6
	note A_,4
	silence
	note G_,4, 72
	continue 3
	silence
	note G_,4, 4
	silence 2
	note G_,4, 4
	silence 2
	silence 12
	note F_,4, 48
	note G_,4, 24
	snd_call SndCall_BGM_01_Ch2_0
	snd_loop SndData_BGM_01_Ch2_0
SndCall_BGM_01_Ch2_0:
	envelope $62
	duty_cycle 0
	note A_,4, 6
	note G_,2
	note A#,4
	note G_,4
	note G_,3
	note A#,4
	note D_,2
	note A_,4
	note G_,3
	note A_,4
	note G_,2
	note A#,4
	note G_,4
	note D_,3
	note A#,4, 12
	note A_,4, 6
	note D#,3
	note A#,4
	note G_,4
	note A#,3
	note A#,4
	note D#,3
	note A_,4
	note A#,3
	note A_,4
	note D#,3
	note A#,4
	note G_,4
	note D#,3
	note A#,4, 12
	note A#,4, 6
	note F_,3
	note C_,5
	note C_,3
	note A_,4
	note C_,5
	note C_,4
	note A#,4
	note F_,3
	note A#,4
	note F_,4
	note C_,5
	note A_,4
	note C_,3
	note C_,5, 12
	note C_,5, 6
	note A#,2
	note D_,5
	note A#,4
	note D_,3
	note D_,5
	note A#,3
	note C_,5
	note A#,2
	note C_,5
	note D_,3
	note D_,5
	note A#,4
	note D_,4
	note D_,5, 12
	envelope $68
	duty_cycle 2
	note G_,4, 48
	note A_,5, 6
	note G_,5
	silence
	note G_,5, 30
	note G_,4, 24
	note D_,5, 6
	note C_,5
	silence
	note D#,5, 30
	note D#,5, 24
	note D_,5, 96
	envelope $11
	note D_,5, 24
	envelope $68
	note F_,4, 72
	envelope $67
	duty_cycle 0
	silence 6
	note D#,4
	note G_,4
	note A#,4
	note D_,5, 24
	envelope $62
	duty_cycle 2
	note A#,3, 6
	note A#,4
	note A#,4
	note A#,4
	note A#,4
	note D#,3
	note A#,4, 12
	envelope $67
	duty_cycle 0
	silence 6
	note F_,4
	note A_,4
	note A#,4
	note C_,5, 24
	envelope $62
	duty_cycle 2
	silence 6
	note C_,5
	note F_,2
	note C_,5
	note F_,2
	note A_,4, 12
	note F_,4, 6
	envelope $65
	note G_,4, 6
	note G_,4, 18
	note G_,4, 6
	silence
	note G_,4
	silence
	note G_,4, 18
	note G_,4, 30
	envelope $63
	duty_cycle 0
	note D_,5, 6
	note A#,4
	note G_,4
	note D#,4
	note G_,4
	note D#,4
	note G_,4
	note A#,4
	note G_,4
	note D#,4
	note A#,4
	note G_,4
	note D#,4
	note A#,3
	note G_,3
	note A#,3
	note C_,5
	note A_,4
	note F_,4
	note C_,4
	note F_,4
	note C_,4
	note F_,4
	note A_,4
	note C_,5
	note F_,5
	note A_,5
	note F_,5
	note C_,6
	note A_,5
	note F_,5
	note C_,5
	envelope $67
	duty_cycle 2
	silence 6
	note A_,4, 18
	note A_,4, 6
	silence
	note A_,4
	silence
	note A_,4, 18
	note A_,4
	note A_,4, 12
	note A_,4, 72
	note A_,4, 4
	silence 2
	note A_,4, 4
	silence 2
	envelope $11
	note A_,4, 48
	envelope $38
	duty_cycle 3
	note D_,4, 24
	note A_,4, 12
	note A#,4, 6
	note C_,5
	silence
	note D_,5
	silence
	note A#,4
	continue 24
	note D_,4
	note A_,4, 12
	note A#,4, 6
	note C_,5
	silence
	note D_,5
	silence
	note A#,4
	continue 12
	note A_,4, 6
	note G_,4, 48
	note A_,4, 18
	note A#,4, 12
	note C_,5, 6
	note A#,4
	note A_,4
	note D_,4, 72
	continue 18
	envelope $68
	note G_,3, 24
	note D_,4, 12
	note G_,4, 6
	note G_,4
	silence
	note G_,4
	silence
	note G_,4
	continue 24
	note G_,3
	note D_,4, 12
	note G_,4, 6
	note G_,4
	silence
	note G_,4
	silence
	note G_,4
	continue 6
	note G_,4
	note E_,4
	note E_,4
	note E_,4, 36
	note E_,4, 12
	note G_,4
	note G_,4
	note A_,4, 18
	note D#,3, 6
	note A#,4, 48
	silence 12
	note A#,4
	note A#,4, 96
	continue 96
	snd_ret
SndData_BGM_01_Ch3:
	wave_vol $00
	panning $44
	wave_id $03
	wave_cutoff 30
	note G_,3, 24
SndData_BGM_01_Ch3_0:
	wave_vol $80
	snd_call SndCall_BGM_01_Ch3_0_0
	snd_call SndCall_BGM_01_Ch3_1
	snd_call SndCall_BGM_01_Ch3_2
	snd_call SndCall_BGM_01_Ch3_3
	snd_call SndCall_BGM_01_Ch3_2
	snd_call SndCall_BGM_01_Ch3_4
	snd_loop SndData_BGM_01_Ch3_0
SndCall_BGM_01_Ch3_0_0:
	note G_,3, 12
	note G_,3, 6
	note F_,3
	note G_,3, 12
	note G_,3, 6
	note F_,3
	note G_,3
	note A#,3, 12
	note A_,3
	note F_,3, 6
	note D_,3, 12
	note G_,3, 12
	note G_,3, 6
	note F_,3
	note G_,3, 12
	note G_,3, 6
	note F_,3
	note G_,3
	note A#,3, 12
	note C_,4, 18
	note D_,4, 12
	snd_loop SndCall_BGM_01_Ch3_0_0, $00, 2
	snd_ret
SndCall_BGM_01_Ch3_1:
	note G_,3, 12
	note G_,3, 6
	note F_,3
	note G_,3, 12
	note G_,3, 6
	note F_,3
	note G_,3
	note A#,3, 12
	note A_,3
	note F_,3, 6
	note D_,3, 12
	note D#,3, 12
	note D#,3, 6
	note D_,3
	note D#,3, 12
	note D#,3, 6
	note D_,3
	note D#,3
	note G_,3, 12
	note A_,3, 18
	note A#,3, 12
	note F_,3, 12
	note F_,3, 6
	note E_,3
	note F_,3, 12
	note F_,3, 6
	note E_,3
	note F_,3
	note A_,3, 12
	note A#,3
	note A#,3, 6
	note C_,4, 12
	note A#,2, 12
	note A#,2, 6
	note A_,2
	note A#,2, 12
	note A#,2, 6
	note A_,2
	note D_,3
	note F_,3, 12
	note A#,3
	note A_,3, 6
	note G_,3
	note F_,3
	note D#,3, 12
	note D#,3, 6
	note D_,3
	note D#,3, 12
	note D#,3, 6
	note D_,3
	note D#,3
	note A#,3, 12
	note A_,3
	note F_,3, 6
	note D_,3, 12
	note C_,3, 12
	note C_,3, 6
	note A#,2
	note C_,3, 12
	note C_,3, 6
	note A#,2
	note C_,3
	note D#,3, 12
	note F_,3, 18
	note G_,3, 12
	note D_,3, 12
	note D_,3, 6
	note C_,3
	note D_,3, 12
	note D_,3, 6
	note C_,3
	note D_,3
	note A#,3, 12
	note A_,3
	note F_,3, 6
	note D_,3, 12
	note D_,3, 24
	wave_cutoff 80
	note D_,3, 30
	wave_cutoff 30
	note A#,3, 12
	note A_,3, 6
	note G_,3, 12
	note F_,3
	note D#,3, 12
	note D#,3, 6
	note D_,3
	note D#,3, 12
	note D#,3, 6
	note D_,3
	note D#,3
	note A#,3, 12
	note A_,3
	note F_,3, 6
	note D#,3, 12
	note F_,3, 12
	note F_,3, 6
	note E_,3
	note F_,3, 12
	note F_,3, 6
	note E_,3
	note F_,3
	note A_,3, 12
	note A#,3, 18
	note C_,4, 12
	note G_,3, 6
	note G_,3, 18
	note G_,3, 12
	note G_,3, 6
	note G_,3
	silence
	note A_,3
	note A#,3
	wave_cutoff 80
	note A#,3, 30
	wave_cutoff 30
	note D#,3, 12
	note D#,3, 6
	note D_,3
	note D#,3, 12
	note D#,3, 6
	note D_,3
	note D#,3
	note A#,3, 12
	note A_,3
	note G_,3, 6
	note D#,3, 12
	note F_,3, 12
	note F_,3, 6
	note E_,3
	note F_,3, 12
	note F_,3, 6
	note E_,3
	note F_,3
	note A_,3, 12
	note A#,3, 18
	note C_,4, 6
	note D_,4
	note D_,4
	wave_cutoff 80
	note D_,4, 18
	wave_cutoff 30
	note D_,4, 12
	note C_,4
	wave_cutoff 80
	note A#,3, 18
	note A_,3
	note G#,3, 12
	wave_cutoff 30
	note C_,4
	note C_,4, 6
	note D_,4
	silence
	note C_,4
	note C_,4
	note D_,4, 30
	wave_cutoff 80
	note D_,5, 18
	note D_,4, 6
	wave_cutoff 30
	snd_ret
SndCall_BGM_01_Ch3_2:
	note G_,3, 12
	note G_,3, 6
	note F_,3
	note G_,3, 12
	note G_,3, 6
	note F_,3
	note G_,3, 12
	note A#,3, 6
	note C_,4
	silence 12
	note G_,3
	note F_,3, 12
	note F_,3, 6
	note D#,3
	note F_,3, 12
	note F_,3, 6
	note D#,3
	note F_,3, 12
	note A_,3, 6
	note A#,3
	silence
	note A#,3
	note C_,4
	wave_cutoff 80
	note E_,3
	continue 12
	wave_cutoff 30
	note E_,3, 6
	note D_,3
	note E_,3, 12
	note E_,3, 6
	note D_,3
	note E_,3
	note A_,3, 12
	note A#,3, 6
	silence 12
	note C_,4
	snd_ret
SndCall_BGM_01_Ch3_3:
	note D#,3, 12
	note D#,3, 6
	note D_,3
	note D#,3, 12
	note D#,3, 6
	note D_,3
	note D#,3
	note A#,3, 12
	note A_,3, 6
	note F_,3, 12
	note D_,3
	snd_ret
SndCall_BGM_01_Ch3_4:
	wave_cutoff 80
	note D#,3, 18
	note D#,3, 6
	note D_,4, 36
	continue 6
	wave_cutoff 30
	note A_,3, 6
	note F_,3, 12
	note D_,3
	wave_cutoff 0
	note G_,3, 96
	note F_,3, 48
	wave_cutoff 30
	silence 6
	note F_,3
	note A_,3
	note A#,3
	note C_,4
	note A#,3
	note A_,3
	note F_,3
	snd_ret
SndData_BGM_01_Ch4:
	panning $88
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 3
	note4 B_,5,0, 6
	note4 B_,5,0, 3
	note4 B_,5,0, 6
SndData_BGM_01_Ch4_0:
	snd_call SndCall_BGM_01_Ch4_0_0
	snd_call SndCall_BGM_01_Ch4_1
	snd_call SndCall_BGM_01_Ch4_2_0
	snd_call SndCall_BGM_01_Ch4_3
	snd_call SndCall_BGM_01_Ch4_4_0
	snd_loop SndData_BGM_01_Ch4_0
SndCall_BGM_01_Ch4_0_0:
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	snd_loop SndCall_BGM_01_Ch4_0_0, $00, 3
	snd_ret
SndCall_BGM_01_Ch4_1:
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 12
	note4 B_,5,0, 6
	note4 B_,5,0, 3
	note4 B_,5,0, 9
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	snd_ret
SndCall_BGM_01_Ch4_2_0:
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 12 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	snd_loop SndCall_BGM_01_Ch4_2_0, $00, 3
	snd_ret
SndCall_BGM_01_Ch4_3:
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 4 ; Nearest: A#,5,0
	note4x $21, 4 ; Nearest: A#,5,0
	note4x $21, 4 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 3
	note4 F_,5,0, 3
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 12 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 12 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 3
	note4 B_,5,0, 3
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 3
	note4 B_,5,0, 3
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	envelope $62
	note4 B_,5,0, 3
	note4 B_,5,0, 9
	envelope $31
	note4x $21, 12 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $54
	note4x $22, 3 ; Nearest: A_,5,0
	note4x $22, 3 ; Nearest: A_,5,0
	note4x $22, 6 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 6
	note4 A_,5,0, 6
	envelope $72
	note4x $32, 6 ; Nearest: A_,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $72
	note4x $32, 6 ; Nearest: A_,5,0
	snd_ret
SndCall_BGM_01_Ch4_4_0:
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	snd_loop SndCall_BGM_01_Ch4_4_0, $00, 2
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 12 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 12
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 3
	note4 B_,5,0, 3
	note4 B_,5,0, 12
	envelope $72
	note4x $32, 6 ; Nearest: A_,5,0
	note4x $32, 6 ; Nearest: A_,5,0
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 12 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 12
	envelope $61
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 12
	envelope $72
	note4x $32, 6 ; Nearest: A_,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 24 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
SndCall_BGM_01_Ch4_4_1:
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	snd_loop SndCall_BGM_01_Ch4_4_1, $00, 2
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	envelope $72
	note4 A_,5,0, 3
	note4 A_,5,0, 3
	note4 A_,5,0, 6
	envelope $54
	note4x $22, 6 ; Nearest: A_,5,0
	envelope $72
	note4x $32, 6 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 6
	note4 A_,5,0, 6
	envelope $72
	note4x $32, 6 ; Nearest: A_,5,0
	note4x $32, 3 ; Nearest: A_,5,0
	note4x $32, 3 ; Nearest: A_,5,0
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $54
	note4x $22, 6 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 12
	envelope $62
	note4 B_,5,0, 12
	envelope $72
	note4x $32, 6 ; Nearest: A_,5,0
	note4x $32, 6 ; Nearest: A_,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $54
	note4x $22, 6 ; Nearest: A_,5,0
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $72
	note4 A_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $72
	note4x $32, 6 ; Nearest: A_,5,0
	note4x $32, 12 ; Nearest: A_,5,0
SndCall_BGM_01_Ch4_4_2:
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	snd_loop SndCall_BGM_01_Ch4_4_2, $00, 6
	envelope $31
	note4x $21, 12 ; Nearest: A#,5,0
	note4x $21, 12 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	snd_ret
