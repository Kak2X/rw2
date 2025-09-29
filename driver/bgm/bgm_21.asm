SndHeader_BGM_21:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_21_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_21_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_21_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_21_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_21_Ch1:
	envelope $68
	panning $11
	duty_cycle 2
	note A#,3, 9
	note D#,4, 10
	note F_,4, 9
	note A#,4, 84
	note A#,3, 9
	note D#,4, 10
	note F_,4, 9
	note A#,4, 84
	note A#,3, 9
	note D#,4, 10
	note F_,4, 9
	note A#,4, 84
	silence 19
	note F_,5, 9
	note A#,4, 112
	continue 112
SndData_BGM_21_Ch1_0:
	snd_call SndCall_BGM_21_Ch1_0
	snd_loop SndData_BGM_21_Ch1_0
SndCall_BGM_21_Ch1_0:
	note A#,4, 56
	note F_,4, 28
	note A#,4
	note C_,5, 56
	note A_,4, 28
	note G_,5
	note G_,5, 56
	note F_,5, 28
	note D#,5
	note D_,5, 42
	note D#,5, 7
	note D_,5
	note C_,5, 28
	note F_,4
	note A#,4, 56
	note G_,4, 28
	note A#,4
	note D#,5, 56
	note A#,4
	note A#,4
	note F_,4, 28
	note A#,4
	note C_,5, 56
	note A_,4
	snd_ret
SndData_BGM_21_Ch2:
	envelope $11
	panning $22
	duty_cycle 2
	note A#,3, 14
	envelope $38
	note A#,3, 9
	note D#,4, 10
	note F_,4, 9
	note A#,4, 84
	note A#,3, 9
	note D#,4, 10
	note F_,4, 9
	note A#,4, 84
	note A#,3, 9
	note D#,4, 10
	note F_,4, 9
	note A#,4, 84
	silence 19
	note F_,5, 9
	note A#,4, 112
	continue 98
SndData_BGM_21_Ch2_0:
	snd_call SndCall_BGM_21_Ch2_0
	snd_loop SndData_BGM_21_Ch2_0
SndCall_BGM_21_Ch2_0:
	envelope $58
	duty_cycle 3
	note D_,5, 42
	note C_,5, 7
	note D_,5
	note D#,5, 28
	note A#,4
	note F_,5, 56
	note D#,5, 28
	note D_,5
	note D#,5, 56
	note D_,5, 28
	note C_,5
	note A#,4, 42
	note C_,5, 14
	note A_,4, 28
	note C_,5
	note D#,5, 56
	silence 14
	note D_,5, 7
	note D#,5
	note F_,5
	note D#,5
	note D_,5
	note C_,5
	note A#,4, 21
	note A#,4, 7
	note D#,4, 9
	note D#,4, 10
	note F#,4, 9
	note A#,4, 28
	note D#,5, 21
	note F#,5, 7
	note F_,5, 56
	note D#,5, 28
	note D_,5
	note C_,5, 56
	note F_,4
	snd_ret
SndData_BGM_21_Ch3:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 0
	note A#,3, 28
	continue 28
	note A#,3
	note G#,3, 56
	continue 28
	note G#,3
	note C#,4, 56
	continue 28
	note C#,4
	note E_,4, 56
	note A#,3, 112
	continue 112
SndData_BGM_21_Ch3_0:
	note A#,3, 112
	note A_,3
	note G#,3
	note A#,3, 56
	note F_,3
	note D#,3, 112
	note D#,3
	note A#,3
	note F_,3
	snd_loop SndData_BGM_21_Ch3_0
SndData_BGM_21_Ch4:
	panning $88
	envelope $61
	note4 F_,5,0, 5
	envelope $42
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	envelope $61
	note4 F_,5,0, 19
	note4 F_,5,0, 9
	note4 F_,5,0, 28
	envelope $42
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	envelope $62
	note4 B_,5,0, 19
	envelope $61
	note4 F_,5,0, 9
	note4 F_,5,0, 28
	envelope $42
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	envelope $61
	note4 F_,5,0, 19
	note4 F_,5,0, 9
	note4 F_,5,0, 56
SndData_BGM_21_Ch4_0:
	envelope $61
	note4 F_,5,0, 5
	envelope $42
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	snd_loop SndData_BGM_21_Ch4_0, $00, 6
	envelope $61
	note4 F_,5,0, 5
	envelope $42
	note4 B_,5,0, 4
	envelope $61
	note4 F_,5,0, 5
	envelope $42
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	envelope $61
	note4 F_,5,0, 5
	envelope $42
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	note4 B_,5,0, 5
	envelope $61
	note4 F_,5,0, 4
	envelope $62
	note4 B_,5,0, 5
SndData_BGM_21_Ch4_1:
	snd_call SndCall_BGM_21_Ch4_0
	snd_loop SndData_BGM_21_Ch4_1
SndCall_BGM_21_Ch4_0:
	envelope $62
	note4 B_,5,0, 14
	envelope $42
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	envelope $62
	note4 B_,5,0, 14
	envelope $42
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	envelope $62
	note4 B_,5,0, 9
	envelope $42
	note4 B_,5,0, 10
	envelope $62
	note4 B_,5,0, 9
	envelope $62
	note4 B_,5,0, 14
	envelope $42
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	envelope $62
	note4 B_,5,0, 14
	envelope $42
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	envelope $62
	note4 B_,5,0, 14
	envelope $42
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	envelope $62
	note4 B_,5,0, 9
	envelope $42
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 9
	envelope $62
	note4 B_,5,0, 14
	envelope $42
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	snd_ret
