SndHeader_BGM_27:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_27_Ch1 ; Data ptr
	db 2 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_27_Ch2_0 ; Data ptr
	db 2 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_27_Ch3_0 ; Data ptr
	db 2 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_27_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_27_Ch1:
	envelope $73
	panning $11
	duty_cycle 0
	snd_call SndCall_BGM_27_Ch1_0_0
	fine_tune 2
	snd_call SndCall_BGM_27_Ch1_0_0
	fine_tune -2
SndData_BGM_27_Ch1_0:
	snd_call SndCall_BGM_27_Ch1_1
	snd_loop SndData_BGM_27_Ch1_0
SndCall_BGM_27_Ch1_0_0:
	note G_,4, 13
	note G_,4, 14
	note G_,4, 13
	snd_loop SndCall_BGM_27_Ch1_0_0, $00, 4
	snd_ret
SndCall_BGM_27_Ch1_1:
	envelope $68
	duty_cycle 2
	note G_,4, 13
	note C_,5, 14
	note B_,4, 13
	note C_,5, 40
	silence 13
	note B_,4, 14
	note C_,5, 13
	note B_,4
	note A_,4, 14
	note G_,4, 13
	note A_,4, 27
	note F_,4, 13
	note E_,5, 27
	note D_,5, 53
	note E_,5, 27
	note F_,5, 13
	note G_,5, 27
	note G_,5, 13
	note G_,5, 27
	note G_,5, 13
	note D_,6, 40
	silence 13
	note B_,5, 14
	note G_,5, 13
	note G_,5, 27
	note F_,5, 13
	silence
	note G_,5, 14
	note A_,5, 13
	note D_,5
	note E_,5, 14
	note F_,5, 13
	note G_,5
	note A_,5, 14
	note A_,4, 13
	snd_ret
SndData_BGM_27_Ch2_0:
	envelope $63
	panning $22
	duty_cycle 0
	note D_,4, 13
	note D_,4, 14
	note D_,4, 13
	note C_,4
	note C_,4, 14
	note C_,4, 13
	note B_,3
	note B_,3, 14
	note B_,3, 13
	note C_,4
	note C_,4, 14
	note C_,4, 13
	note E_,4
	note E_,4, 14
	note E_,4, 13
	note D_,4
	note D_,4, 14
	note D_,4, 13
	note C#,4
	note C#,4, 14
	note C#,4, 13
	note D_,4
	note D_,4, 14
	note D_,4, 13
	snd_loop SndData_BGM_27_Ch2_0
SndData_BGM_27_Ch3_0:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 0
	note C_,4, 120
	silence 27
	note G_,3, 13
	note D_,3, 120
	silence 27
	note G_,3, 13
	snd_loop SndData_BGM_27_Ch3_0
SndData_BGM_27_Ch4:
	panning $88
	envelope $61
	note4 F_,5,0, 13
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	note4x $21, 13 ; Nearest: A#,5,0
	envelope $53
	note4x $11, 120 ; Nearest: A#,6,0
	note4x $11, 13 ; Nearest: A#,6,0
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	note4x $21, 13 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 27
	envelope $31
	note4x $21, 13 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 13
	envelope $54
	note4x $22, 14 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 13
	note4 A_,5,0, 13
	envelope $72
	note4x $32, 14 ; Nearest: A_,5,0
	note4x $32, 13 ; Nearest: A_,5,0
SndData_BGM_27_Ch4_0:
	envelope $61
	note4 F_,5,0, 13
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	note4x $21, 13 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 27
	envelope $61
	note4 F_,5,0, 13
	note4 F_,5,0, 13
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	envelope $53
	note4x $11, 13 ; Nearest: A#,6,0
	envelope $62
	note4 B_,5,0, 13
	envelope $31
	note4x $21, 14 ; Nearest: A#,5,0
	note4x $21, 13 ; Nearest: A#,5,0
	snd_loop SndData_BGM_27_Ch4_0
