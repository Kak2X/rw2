SndHeader_BGM_28:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_28_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_28_Ch2_0 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_28_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_28_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_28_Ch1:
	envelope $11
	panning $11
	duty_cycle 2
	note A_,4, 112
	continue 112
SndData_BGM_28_Ch1_1:
	envelope $58
	note A_,5, 42
	note C_,6, 14
	note D_,6, 28
	note E_,6
	note D_,6, 42
	note G_,5, 14
	note A_,5, 28
	note C_,6, 14
	note G_,5
SndData_BGM_28_Ch1_0:
	note A_,5, 7
	silence
	note A_,5
	note G_,5
	note A_,5, 7
	silence
	note A_,5
	note G_,5
	note A_,5, 7
	silence
	note A_,5
	note G_,5
	note A_,5
	note A_,5
	note C_,6
	note G_,5
	snd_loop SndData_BGM_28_Ch1_0, $00, 2
	snd_loop SndData_BGM_28_Ch1_1
SndData_BGM_28_Ch2_0:
	envelope $52
	panning $22
	duty_cycle 2
	note D_,5, 7
	note E_,5
	note C_,5
	note D_,5
	note A_,4
	note C_,5
	note G_,4
	note A_,4
	note E_,4
	note G_,4
	note D_,4
	note E_,4
	note C_,4
	note D_,4
	note A_,3
	note C_,4
	snd_loop SndData_BGM_28_Ch2_0, $00, 2
	snd_loop SndData_BGM_28_Ch2_0
SndData_BGM_28_Ch3:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 1
	note A_,3, 112
	wave_cutoff 25
	note A_,3, 14
	note A_,3, 98
SndData_BGM_28_Ch3_0:
	snd_call SndCall_BGM_28_Ch3_0_0
	snd_call SndCall_BGM_28_Ch3_1_0
	snd_loop SndData_BGM_28_Ch3_0
SndCall_BGM_28_Ch3_0_0:
	note A_,3, 14
	note A_,3, 98
	snd_loop SndCall_BGM_28_Ch3_0_0, $00, 2
	snd_ret
SndCall_BGM_28_Ch3_1_0:
	note A_,3, 14
	note A_,3, 7
	note A_,3
	snd_loop SndCall_BGM_28_Ch3_1_0, $00, 3
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	wave_cutoff 60
	note A_,3, 28
	note A_,3
	note A_,3
	wave_cutoff 25
	note A_,3, 14
	note A_,3, 7
	note A_,3
	snd_ret
SndData_BGM_28_Ch4:
	panning $88
	envelope $11
	note4x $11, 112 ; Nearest: A#,6,0
	envelope $11
	note4x $11, 112 ; Nearest: A#,6,0
SndData_BGM_28_Ch4_0:
	envelope $11
	note4x $11, 14 ; Nearest: A#,6,0
	envelope $52
	note4 B_,5,0, 28
	note4 B_,5,0, 28
	note4 B_,5,0, 28
	note4 B_,5,0, 28
	note4 B_,5,0, 28
	note4 B_,5,0, 28
	note4 B_,5,0, 7
	note4 B_,5,0, 21
	note4 B_,5,0, 28
	note4 B_,5,0, 7
	note4 B_,5,0, 21
	note4 B_,5,0, 7
	note4 B_,5,0, 21
	note4 B_,5,0, 7
	note4 B_,5,0, 21
	note4 B_,5,0, 7
	note4 B_,5,0, 21
	note4 B_,5,0, 28
	note4 B_,5,0, 14
	note4 B_,5,0, 5
	envelope $22
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	envelope $32
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	envelope $42
	note4 B_,5,0, 5
	note4 B_,5,0, 5
	envelope $52
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	envelope $62
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	envelope $72
	note4 B_,5,0, 5
	snd_loop SndData_BGM_28_Ch4_0
