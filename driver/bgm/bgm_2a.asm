SndHeader_BGM_2A:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_2A_Ch1 ; Data ptr
	db -4 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_2A_Ch2_0 ; Data ptr
	db -4 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_2A_Ch3 ; Data ptr
	db -4 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_2A_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_2A_Ch1:
	envelope $74
	panning $11
	duty_cycle 3
	snd_call SndCall_BGM_2A_Ch1_0_0
	snd_call SndCall_BGM_2A_Ch1_1
SndData_BGM_2A_Ch1_0:
	snd_call SndCall_BGM_2A_Ch1_2_0
	snd_loop SndData_BGM_2A_Ch1_0
SndCall_BGM_2A_Ch1_0_0:
	envelope $74
	note E_,5, 13
	note E_,5, 7
	note E_,5
	note A#,4, 6
	note G_,4, 7
	silence 20
	note G_,4, 13
	note G_,4, 7
	note A#,4
	note G_,4, 6
	note D_,4, 7
	silence
	note A#,3, 6
	envelope $77
	note G_,3, 7
	continue 40
	snd_loop SndCall_BGM_2A_Ch1_0_0, $00, 2
	snd_ret
SndCall_BGM_2A_Ch1_1:
	envelope $64
	duty_cycle 2
	silence 20
	note F_,6, 13
	note D_,6, 7
	note E_,6, 13
	note D_,6, 7
	silence 13
	note C#,6, 20
	note D_,6, 7
	silence 13
	note F_,4, 27
	note F_,5, 7
	note G#,5, 6
	note F_,5, 7
	note G#,5, 13
	note G_,5, 20
	note F_,5, 7
	silence 13
	note D_,5, 7
	note G_,5, 13
	note D_,5, 7
	note F_,5, 13
	note D#,5, 14
	note C_,5, 13
	note D#,5, 13
	note G_,2, 14
	note G_,3, 13
	note G_,4, 20
	silence 7
	note C_,5, 6
	note D_,5, 7
	note F_,5, 7
	note E_,5, 6
	note G_,5, 7
	note C_,5
	note D_,5, 6
	note A#,5, 7
	note A_,5, 13
	note C_,6, 7
	note D_,6, 13
	note F_,6, 14
	note G_,6, 13
	note G_,6
	note F_,6, 7
	note G_,6, 13
	note C_,7, 7
	silence 13
	note C_,7, 7
	silence 13
	note C_,7, 7
	note D_,7, 13
	note A_,6, 7
	note D_,7, 20
	note E_,7, 13
	note F_,7, 7
	silence 13
	note E_,7, 7
	silence 13
	note D_,7, 7
	note F_,7, 13
	note G#,7, 20
	note G_,4, 27
	note F_,7, 7
	note G#,7, 6
	note E_,7, 7
	note D_,7, 13
	note C_,7, 20
	note A#,6, 7
	silence 13
	note C_,7, 20
	note G_,6, 7
	note F_,6, 7
	note G_,6, 6
	note E_,6, 7
	note F_,3, 13
	note C_,6, 7
	note B_,5, 7
	note C_,6, 6
	note C#,6, 7
	note G#,5
	note A_,5, 6
	note A#,5, 7
	note D_,5, 7
	note D#,5, 6
	note C_,5, 7
	note A#,4, 13
	note F_,4, 7
	note E_,4, 13
	note C_,4, 7
	note A_,3
	note G_,3, 6
	note D#,3, 7
	snd_ret
SndCall_BGM_2A_Ch1_2_0:
	envelope $74
	duty_cycle 3
	silence 13
	note D#,4, 7
	silence 20
	note D#,4, 7
	silence 27
	continue 6
	note D#,4, 7
	silence 27
	note D#,4, 13
	silence 27
	continue 6
	snd_loop SndCall_BGM_2A_Ch1_2_0, $00, 2
	silence 13
	note F_,4, 7
	silence 20
	note F_,4, 7
	silence 27
	continue 6
	note F_,4, 7
	silence 27
	note F_,4, 13
	silence 27
	continue 6
	silence 13
	note D#,4, 7
	silence 20
	note D#,4, 7
	silence 27
	continue 6
	note D#,4, 7
	silence 27
	note D#,4, 13
	silence 27
	continue 6
	silence 13
	note F_,4, 7
	silence 20
	note F_,4, 7
	silence 40
	continue 6
	note D_,4, 7
	silence 20
	note D_,4, 13
	silence 27
	silence 13
	note F_,4, 7
	silence 20
	note F_,4, 7
	silence 27
	continue 6
	note F_,4, 7
	silence 27
	note F_,4, 13
	silence 27
	continue 6
	snd_ret
SndData_BGM_2A_Ch2_0:
	envelope $64
	panning $22
	duty_cycle 3
	note D_,5, 27
	continue 6
	note D_,5, 7
	silence 13
	note C_,3, 7
	note D_,5, 40
	note D_,5, 7
	silence 6
	envelope $67
	note A#,4, 7
	continue 40
	snd_loop SndData_BGM_2A_Ch2_0, $00, 2
SndData_BGM_2A_Ch2_1:
	snd_call SndCall_BGM_2A_Ch2_0_0
	snd_loop SndData_BGM_2A_Ch2_1
SndCall_BGM_2A_Ch2_0_0:
	envelope $74
	silence 13
	note A_,4, 7
	silence 20
	note A_,4, 7
	silence 27
	continue 6
	note A_,4, 7
	silence 27
	note A_,4, 13
	silence 27
	continue 6
	snd_loop SndCall_BGM_2A_Ch2_0_0, $00, 2
	silence 13
	note G#,4, 7
	silence 20
	note G#,4, 7
	silence 27
	continue 6
	note G#,4, 7
	silence 27
	note G#,4, 13
	silence 27
	continue 6
	silence 13
	note A_,4, 7
	silence 20
	note A_,4, 7
	silence 27
	continue 6
	note A_,4, 7
	silence 27
	note A_,4, 13
	silence 27
	continue 6
	silence 13
	note A_,4, 7
	silence 20
	note A_,4, 7
	silence 40
	continue 6
	note G_,4, 7
	silence 20
	note G_,4, 13
	silence 27
	silence 13
	note A_,4, 7
	silence 20
	note A_,4, 7
	silence 27
	continue 6
	note A_,4, 7
	silence 27
	note A_,4, 13
	silence 27
	continue 6
	snd_ret
SndData_BGM_2A_Ch3:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 90
	note C_,4, 20
	continue 7
	continue 6
	note C_,5, 7
	silence 20
	note C_,4, 40
	note C_,4, 13
	note E_,4, 7
	continue 40
	note C_,4, 20
	continue 7
	continue 6
	note C_,5, 7
	silence 20
	note C_,4, 40
	silence 13
	note E_,4, 7
	continue 40
	wave_cutoff 70
SndData_BGM_2A_Ch3_0:
	snd_call SndCall_BGM_2A_Ch3_0
	snd_loop SndData_BGM_2A_Ch3_0
SndCall_BGM_2A_Ch3_0:
	note F_,3, 20
	note C_,4
	note D#,4
	note F_,4
	note F#,4
	note F_,4
	note D#,4
	note C_,4
	note F_,3, 13
	wave_cutoff 1
	note F_,3, 7
	wave_cutoff 70
	note C_,4, 20
	note D#,4
	note F_,4
	note F#,4
	note F_,4
	note A#,4
	note C_,5
	note A#,4
	note F_,4
	note G#,4
	note A#,4
	note B_,4
	note A#,4
	note G#,4
	note F_,4
	note F_,3, 13
	wave_cutoff 1
	note F_,3, 7
	wave_cutoff 70
	note C_,4, 20
	note D#,4
	note F_,4
	note F#,4
	note F_,4
	note A#,4
	note C_,5
	note G_,4
	note A_,4
	note A#,4
	note B_,4
	note G_,4
	note C_,4
	note E_,4
	note G_,4
	note F_,4, 13
	wave_cutoff 1
	note F_,3, 7
	wave_cutoff 70
	note C_,4, 20
	note D#,4
	note F_,4
	note F#,4
	note F_,4
	note D#,4
	note C_,4
	snd_ret
SndData_BGM_2A_Ch4:
	panning $88
	envelope $61
	note4 F_,5,0, 13
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 13
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 13 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 13
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 13
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 13 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 13
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 13
	envelope $61
	note4 F_,5,0, 7
	envelope $31
	note4x $21, 13 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 13
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 13
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 13
SndData_BGM_2A_Ch4_0:
	snd_call SndCall_BGM_2A_Ch4_0
	snd_call SndCall_BGM_2A_Ch4_1_0
	snd_loop SndData_BGM_2A_Ch4_0
SndCall_BGM_2A_Ch4_0:
	envelope $61
	note4 F_,5,0, 20
	envelope $31
	note4x $21, 13 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $53
	note4x $11, 13 ; Nearest: A#,6,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 13 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 13
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 13 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $53
	note4x $11, 13 ; Nearest: A#,6,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 7
	envelope $61
	note4 F_,5,0, 13
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	note4x $21, 13 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $53
	note4x $11, 13 ; Nearest: A#,6,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 13 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $53
	note4x $11, 13 ; Nearest: A#,6,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 13 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 13
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 7
	envelope $61
	note4 F_,5,0, 20
	envelope $31
	note4x $21, 13 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $53
	note4x $11, 13 ; Nearest: A#,6,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 13 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 13
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 13 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $53
	note4x $11, 13 ; Nearest: A#,6,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 7
	snd_ret
SndCall_BGM_2A_Ch4_1_0:
	envelope $61
	note4 F_,5,0, 20
	envelope $31
	note4x $21, 13 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	envelope $53
	note4x $11, 13 ; Nearest: A#,6,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 13 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 13
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 13 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $53
	note4x $11, 13 ; Nearest: A#,6,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 7
	snd_loop SndCall_BGM_2A_Ch4_1_0, $00, 2
	envelope $61
	note4 F_,5,0, 20
	envelope $31
	note4x $21, 13 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $53
	note4x $11, 13 ; Nearest: A#,6,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 13 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 13
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 13 ; Nearest: A#,5,0
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $53
	note4x $11, 13 ; Nearest: A#,6,0
	envelope $62
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 7
	snd_ret
