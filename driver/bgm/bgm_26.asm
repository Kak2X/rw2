SndHeader_BGM_26:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_26_Ch1_0 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_26_Ch2_0 ; Data ptr
	db 7 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_26_Ch3_0 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_26_Ch4_0 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_26_Ch1_0:
	envelope $77
	panning $11
	duty_cycle 3
	snd_call SndCall_BGM_26_Ch1_0
	snd_loop SndData_BGM_26_Ch1_0
SndCall_BGM_26_Ch1_0:
	note A_,2, 42
	note A_,2, 7
	note A_,2
	note E_,3, 14
	silence
	note D_,3, 28
	note A_,2, 42
	note A_,2, 7
	note A_,2
	note G_,2, 14
	silence
	note A_,2, 28
	note A_,2, 42
	note A_,2, 7
	note A_,2
	note E_,3, 14
	silence
	note D_,3, 28
	note A_,2, 42
	note A_,2, 7
	note A_,2
	note G_,2, 21
	note A_,2, 14
	note G_,2, 7
	note A_,2, 14
	note F_,2, 42
	note F_,2, 7
	note F_,2
	note E_,2, 14
	silence
	note F_,2, 28
	note F_,2, 42
	note F_,2, 7
	note F_,2
	note E_,2, 14
	silence
	note D_,3, 28
	note F_,2, 42
	note F_,2, 7
	note F_,2
	note E_,2, 14
	silence
	note F_,2, 28
	note F_,2, 42
	note F_,2, 7
	note F_,2
	note F_,3, 14
	note E_,3, 7
	note F_,3, 35
	snd_ret
SndData_BGM_26_Ch2_0:
	envelope $67
	panning $22
	duty_cycle 1
	snd_call SndCall_BGM_26_Ch1_0
	snd_loop SndData_BGM_26_Ch2_0
SndData_BGM_26_Ch3_0:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 80
	snd_call SndCall_BGM_26_Ch3_0_0
	snd_call SndCall_BGM_26_Ch3_1_0
	snd_loop SndData_BGM_26_Ch3_0
SndCall_BGM_26_Ch3_0_0:
	note A_,2, 21
	note A_,3, 7
	wave_cutoff 1
	note A_,3
	wave_cutoff 80
	note A_,2
	note A_,2, 14
	note G_,3
	note A_,2
	note A_,3, 28
	snd_loop SndCall_BGM_26_Ch3_0_0, $00, 3
	note A_,2, 21
	note A_,3, 7
	wave_cutoff 1
	note A_,3
	wave_cutoff 80
	note A_,2
	note A_,2, 14
	note G_,3, 7
	note A_,3
	note G_,3
	note E_,3
	note D_,3
	note C_,3, 14
	note A_,2, 7
	snd_ret
SndCall_BGM_26_Ch3_1_0:
	note F_,2, 21
	note F_,3, 7
	wave_cutoff 1
	note F_,3
	wave_cutoff 80
	note F_,2
	note F_,2, 14
	note E_,3
	note F_,2
	note F_,3, 28
	snd_loop SndCall_BGM_26_Ch3_1_0, $00, 4
	snd_ret
SndData_BGM_26_Ch4_0:
	panning $88
	snd_call SndCall_BGM_26_Ch4_0
	snd_call SndCall_BGM_26_Ch4_1
	snd_call SndCall_BGM_26_Ch4_0
	snd_call SndCall_BGM_26_Ch4_2
	snd_call SndCall_BGM_26_Ch4_0
	snd_call SndCall_BGM_26_Ch4_1
	snd_call SndCall_BGM_26_Ch4_0
	snd_call SndCall_BGM_26_Ch4_3
	snd_call SndCall_BGM_26_Ch4_0
	snd_call SndCall_BGM_26_Ch4_2
	snd_call SndCall_BGM_26_Ch4_0
	snd_call SndCall_BGM_26_Ch4_1
	snd_call SndCall_BGM_26_Ch4_4
	snd_loop SndData_BGM_26_Ch4_0
SndCall_BGM_26_Ch4_0:
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 14
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 14
	note4 F_,5,0, 14
	snd_ret
SndCall_BGM_26_Ch4_1:
	envelope $62
	note4 B_,5,0, 7
	envelope $53
	note4x $11, 21 ; Nearest: A#,6,0
	snd_ret
SndCall_BGM_26_Ch4_2:
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $72
	note4x $32, 7 ; Nearest: A_,5,0
	snd_ret
SndCall_BGM_26_Ch4_3:
	envelope $62
	note4 B_,5,0, 7
	envelope $54
	note4x $22, 7 ; Nearest: A_,5,0
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $72
	note4 A_,5,0, 7
	envelope $62
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $54
	note4x $22, 7 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 7
	envelope $72
	note4x $32, 21 ; Nearest: A_,5,0
	envelope $61
	note4 F_,5,0, 14
	envelope $62
	note4 B_,5,0, 7
	envelope $53
	note4x $11, 21 ; Nearest: A#,6,0
	snd_ret
SndCall_BGM_26_Ch4_4:
	envelope $61
	note4 F_,5,0, 14
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
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
	envelope $62
	note4 B_,5,0, 14
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	envelope $31
	note4x $21, 7 ; Nearest: A#,5,0
	envelope $72
	note4x $32, 7 ; Nearest: A_,5,0
	snd_ret
