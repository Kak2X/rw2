SndHeader_BGM_07:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_07_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_07_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_07_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_07_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_07_Ch1:
	envelope $78
	panning $11
	duty_cycle 3
	note C#,5, 20
	envelope $68
	note C#,5
	envelope $58
	note C#,5
	envelope $48
	note C#,5
	envelope $38
	note C#,5
	envelope $77
	silence 10
	note G#,4
	note C#,5
	note B_,4
	silence
	note B_,4
	continue 10
	note A_,4
	silence
	envelope $78
	note A_,4, 20
	envelope $68
	note A_,4
	envelope $58
	note A_,4
	envelope $48
	note A_,4
	envelope $38
	note A_,4, 10
	envelope $77
	silence 10
	note A_,4
	note B_,4
	note C#,5, 30
	envelope $73
	note C#,5, 10
	envelope $53
	note C#,5
	envelope $43
	note C#,5
	envelope $77
	note C#,5, 30
	envelope $73
	note C#,5, 10
	envelope $53
	note C#,5
	envelope $43
	note C#,5
	envelope $77
	note C#,5, 30
	note C#,5, 10
	note D#,5, 30
	envelope $73
	note D#,5, 10
	envelope $53
	note D#,5
	envelope $43
	note D#,5
	envelope $77
	note D#,5, 30
	envelope $73
	note D#,5, 10
	envelope $53
	note D#,5
	envelope $43
	note D#,5
	envelope $77
	note D#,5, 30
	note D#,5, 10
	silence
SndData_BGM_07_Ch1_0:
	snd_call SndCall_BGM_07_Ch1_0
	snd_call SndCall_BGM_07_Ch1_1
	snd_call SndCall_BGM_07_Ch1_0
	snd_call SndCall_BGM_07_Ch1_2
	snd_call SndCall_BGM_07_Ch1_3
	snd_call SndCall_BGM_07_Ch1_4
	snd_loop SndData_BGM_07_Ch1_0
SndCall_BGM_07_Ch1_0:
	envelope $11
	note C#,4, 20
	envelope $78
	note G#,4, 20
	note C#,5
	note F#,5, 10
	note E_,5
	continue 10
	note D#,5
	note C#,5, 30
	note B_,4, 10
	silence
	note C#,5
	envelope $11
	note C#,5, 20
	envelope $78
	note G#,4
	note C#,5
	note F#,5, 10
	note E_,5
	continue 10
	note D#,5
	note C#,5, 30
	note B_,4, 10
	silence
	note C#,5
	envelope $11
	note C#,5, 20
	envelope $78
	note G#,4
	note C#,5
	note F#,5, 10
	note E_,5, 1
	note F_,5
	note F#,5
	note G_,5
	note G#,5
	continue 5
	continue 10
	note A_,5
	note G#,5
	note F#,5, 20
	note E_,5, 10
	note F#,5
	note E_,5, 1
	note F_,5
	note F#,5
	note G_,5
	note G#,5
	continue 5
	snd_ret
SndCall_BGM_07_Ch1_1:
	note G#,5, 30
	note F#,5
	note E_,5, 20
	note D#,5, 10
	silence
	note C#,5
	note C_,5, 40
	continue 10
	snd_ret
SndCall_BGM_07_Ch1_2:
	note G#,5, 20
	note F#,5, 40
	note E_,5, 20
	note D#,5
	note E_,5, 10
	note D#,5, 40
	continue 10
	snd_ret
SndCall_BGM_07_Ch1_3:
	envelope $68
	duty_cycle 2
	note C#,5, 30
	note D#,5, 40
	continue 10
	note E_,5, 30
	note F#,5, 20
	note E_,5, 10
	note D#,5
	note C#,5
	note A_,4, 30
	note G#,5, 40
	envelope $58
	note G#,5
	envelope $48
	note G#,5, 10
	envelope $68
	note G#,5, 10
	silence
	note F#,5
	note G#,5
	note G#,5, 40
	envelope $58
	note G#,5
	envelope $48
	note G#,5, 20
	envelope $38
	note G#,5
	envelope $28
	note G#,5
	envelope $68
	silence 10
	note C#,5
	note C#,5, 30
	note D#,5, 40
	continue 10
	note E_,5, 30
	note F#,5, 20
	note E_,5, 10
	note D#,5
	note A_,4, 40
	note G#,5
	envelope $58
	note G#,5
	envelope $28
	note G#,5, 10
	envelope $68
	note G#,5, 10
	silence
	note F#,5
	note G#,5
	note G#,5, 40
	envelope $58
	note G#,5
	envelope $48
	note G#,5
	envelope $38
	note G#,5
	snd_ret
SndCall_BGM_07_Ch1_4:
	envelope $11
	duty_cycle 3
	note G#,4, 20
	envelope $78
	note G#,4
	note C#,5
	note F#,5, 10
	note E_,5, 1
	note F_,5
	note F#,5
	note G_,5
	note G#,5
	continue 5
	continue 20
	note F#,5, 10
	note E_,5
	silence
	note D#,5
	silence
	note C_,5, 1
	note C#,5
	note D_,5
	note D#,5
	note E_,5
	continue 5
	continue 20
	note D#,5, 10
	note C#,5
	silence
	note B_,4
	silence
	note A_,4, 1
	note A#,4
	note B_,4
	note C_,5
	note C#,5
	continue 5
	note C#,5, 30
	note C#,5, 10
	note D#,5
	note E_,5
	envelope $11
	note E_,5, 40
	envelope $78
	note D_,5, 1
	note D#,5
	note E_,5
	note F_,5
	note F#,5
	continue 15
	note E_,5, 20
	note D#,5, 10
	note D_,5, 1
	note D#,5
	note E_,5
	note F_,5
	note F#,5
	continue 5
	envelope $11
	note F#,5, 10
	envelope $78
	note F#,5
	note E_,5, 20
	note D#,5, 10
	silence
	note E_,5
	note B_,4, 1
	note C_,5
	note C#,5
	note D_,5
	note D#,5
	continue 5
	continue 20
	note C#,5
	note C_,5
	note C#,5, 10
	note E_,5, 1
	note F_,5
	note F#,5
	note G_,5
	note G#,5
	continue 5
	envelope $11
	note G#,5, 10
	envelope $88
	note G#,4
	note G#,4
	note G#,4
	note G#,4
	note G#,4
	silence
	envelope $78
	note E_,5, 1
	note F_,5
	note F#,5
	note G_,5
	note G#,5
	continue 15
	continue 10
	note F#,5, 20
	note E_,5
	note F#,5, 10
	note C_,5, 1
	note C#,5
	note D_,5
	note D#,5
	note E_,5
	continue 5
	continue 10
	note D#,5
	silence
	note C#,5
	silence
	note G#,4, 20
	note C_,5, 1
	note C#,5
	note D_,5
	note D#,5
	note E_,5
	continue 5
	continue 20
	note D#,5, 10
	note C#,5
	silence
	note B_,4
	silence
	note A_,4, 1
	note A#,4
	note B_,4
	note C_,5
	note C#,5
	continue 5
	continue 30
	note C#,5, 10
	note D#,5
	note E_,5, 30
	envelope $11
	note E_,5, 20
	envelope $78
	note D_,5, 1
	note D#,5
	note E_,5
	note F_,5
	note F#,5
	continue 15
	note G#,5, 20
	note A_,5, 10
	note G#,5
	silence
	note G#,5
	note F#,5, 20
	note E_,5, 10
	silence
	note C_,5
	note B_,4, 1
	note C_,5
	note C#,5
	note D_,5
	note D#,5
	continue 5
	continue 20
	note C#,5, 60
	continue 10
	note G#,3, 5
	silence
	envelope $11
	note G#,3, 20
	envelope $78
	note G#,3, 5
	silence
	note G#,3
	silence
	silence 10
	note C#,4
	snd_ret
SndData_BGM_07_Ch2:
	envelope $68
	panning $22
	duty_cycle 3
	note G#,4, 20
	envelope $58
	note G#,4
	envelope $48
	note G#,4
	envelope $38
	note G#,4
	envelope $28
	note G#,4
	envelope $67
	silence 10
	note C#,4
	note G#,4
	note E_,4
	silence
	note E_,4
	continue 10
	note E_,4
	silence
	envelope $68
	note E_,4, 20
	envelope $58
	note E_,4
	envelope $48
	note E_,4
	envelope $38
	note E_,4
	envelope $28
	note E_,4, 10
	envelope $67
	silence 10
	note E_,4
	note F#,4
	note A_,4, 30
	envelope $63
	note A_,4, 10
	envelope $43
	note A_,4
	envelope $33
	note A_,4
	envelope $67
	note A_,4, 30
	envelope $63
	note A_,4, 10
	envelope $43
	note A_,4
	envelope $33
	note A_,4
	envelope $67
	note A_,4, 30
	note A_,4, 10
	note C_,5, 30
	envelope $63
	note C_,5, 10
	envelope $43
	note C_,5
	envelope $33
	note C_,5
	envelope $67
	note C_,5, 30
	envelope $63
	note C_,5, 10
	envelope $43
	note C_,5
	envelope $33
	note C_,5
	envelope $67
	note C_,5, 30
	note C_,5, 10
SndData_BGM_07_Ch2_0:
	snd_call SndCall_BGM_07_Ch2_0_0
	snd_call SndCall_BGM_07_Ch2_1
	snd_call SndCall_BGM_07_Ch2_2
	snd_call SndCall_BGM_07_Ch2_0_0
	snd_call SndCall_BGM_07_Ch2_1
	snd_call SndCall_BGM_07_Ch2_3
	snd_call SndCall_BGM_07_Ch2_4
	snd_call SndCall_BGM_07_Ch2_0_0
	snd_call SndCall_BGM_07_Ch2_5
	snd_loop SndData_BGM_07_Ch2_0
SndCall_BGM_07_Ch2_0_0:
	envelope $65
	duty_cycle 2
	note F#,4, 30
	note E_,4, 10
	envelope $11
	note E_,4, 20
	envelope $65
	note F#,4, 10
	note F#,4
	note E_,4
	silence
	note E_,3
	envelope $11
	note E_,3, 20
	envelope $65
	note E_,3
	silence 10
	snd_loop SndCall_BGM_07_Ch2_0_0, $00, 2
	note G#,4, 30
	note F#,4, 10
	envelope $11
	note F#,4, 20
	envelope $65
	note G#,4, 10
	note G#,4
	note F#,4
	silence
	note F#,3
	envelope $11
	note F#,3, 20
	envelope $65
	note F#,3
	silence 10
	note C#,4, 30
	note D#,4, 10
	envelope $11
	note F#,4, 20
	envelope $65
	snd_ret
SndCall_BGM_07_Ch2_1:
	note C#,4, 10
	note C#,4
	note D#,4
	snd_ret
SndCall_BGM_07_Ch2_5:
	note C_,4, 10
	note C#,4
	note D#,4
	envelope $75
	silence
	note D#,4
	note D#,4
	note D#,4
	note D#,4
	note D#,4
	silence
	envelope $65
SndCall_BGM_07_Ch2_5_0:
	note F#,4, 30
	note E_,4, 10
	envelope $11
	note E_,4, 20
	envelope $65
	note F#,4, 10
	note F#,4
	note E_,4
	silence
	note E_,3
	envelope $11
	note E_,3, 20
	envelope $65
	note E_,3
	silence 10
	snd_loop SndCall_BGM_07_Ch2_5_0, $00, 2
	note E_,4, 30
	note D#,4, 20
	silence 10
	note E_,4
	note E_,4
	note D#,4
	silence
	note D#,4
	envelope $11
	note D#,4, 20
	envelope $65
	note D#,4
	note D#,4, 10
	envelope $68
	note F#,4, 30
	note E_,4, 60
	continue 10
	envelope $65
	note C#,4
	envelope $11
	note C#,4, 20
	envelope $65
	note C#,4, 10
	note C#,4
	silence
	snd_ret
SndCall_BGM_07_Ch2_Unused_:
	snd_ret
SndCall_BGM_07_Ch2_2:
	silence
	note D#,3
	envelope $11
	note D#,3, 20
	envelope $65
	note D#,3
	note D#,4, 10
	snd_ret
SndCall_BGM_07_Ch2_3:
	envelope $11
	note C_,3, 10
	envelope $65
	note C_,3
	note C_,3
	note C_,3
	note C_,3
	note C_,3
	envelope $11
	note C_,3, 20
	envelope $67
	duty_cycle 0
	snd_ret
SndCall_BGM_07_Ch2_4:
	note C#,4, 10
	note B_,3
	note C#,4
	note G#,4, 40
	continue 10
	silence
	note A_,3
	note C#,4
	note G#,4, 20
	note F#,4, 10
	note E_,4
	note D#,4
	note E_,4
	note F#,3
	note A_,3
	note E_,4, 40
	continue 10
	silence
	note F#,3
	note A_,3
	note E_,4, 20
	note D#,4, 10
	note C#,4
	envelope $65
	note F#,4, 30
	note E_,4, 10
	envelope $11
	note E_,4, 20
	envelope $65
	note F#,4, 10
	note F#,4
	note E_,4
	silence
	note C#,4
	envelope $11
	note C#,4, 20
	envelope $65
	note C#,4, 10
	note C#,4
	silence
	note C#,4, 20
	envelope $67
	note A_,3, 10
	note C#,4
	note G#,4, 40
	continue 10
	silence
	note A_,3
	note C#,4
	note G#,4, 20
	note F#,4, 10
	note E_,4
	note B_,3
	note D#,4
	note B_,3
	note D#,4
	note B_,4, 40
	continue 10
	note F#,4, 10
	note B_,3
	note D#,4
	note B_,4, 20
	note A_,4, 10
	note G#,4
	envelope $65
	note E_,4, 30
	note D#,4, 10
	envelope $11
	note D#,4, 20
	envelope $65
	note E_,4, 10
	note E_,4
	note D#,4
	silence
	note D#,4
	envelope $11
	note D#,4, 20
	envelope $65
	note D#,4, 10
	note D#,4
	note D#,4
	snd_ret
SndData_BGM_07_Ch3:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 0
	note C#,3, 80
	continue 30
	note C#,3, 10
	note C#,4
	note B_,3
	silence
	note A_,3
	continue 80
	continue 40
	silence 10
	note A_,3
	note G#,3
	note F#,3, 20
	wave_cutoff 25
	note F#,3, 10
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	wave_cutoff 60
	note G#,3, 20
	wave_cutoff 25
	note G#,3, 10
	note G#,3
	note G#,3
	note G#,3
	note G#,3
	note G#,3
	note G#,3
	note G#,3
	note G#,3
	note G#,3
	note G#,3
	note G#,3
	note G#,3
	note G#,3
SndData_BGM_07_Ch3_0:
	snd_call SndCall_BGM_07_Ch3_0
	snd_call SndCall_BGM_07_Ch3_1
	snd_call SndCall_BGM_07_Ch3_0
	snd_call SndCall_BGM_07_Ch3_2
	snd_call SndCall_BGM_07_Ch3_3
	snd_call SndCall_BGM_07_Ch3_0
	snd_call SndCall_BGM_07_Ch3_4
	snd_call SndCall_BGM_07_Ch3_5
	snd_loop SndData_BGM_07_Ch3_0
SndCall_BGM_07_Ch3_0:
	wave_cutoff 60
	note C#,4, 20
	wave_cutoff 25
	note C#,4, 10
	note C#,4
	note C#,4
	note C#,4
	note C#,4
	note C#,4
	note C#,4
	note C#,4
	note C#,4
	note C#,4
	note C#,3
	note C#,4
	note B_,3, 20
	wave_cutoff 60
	note A_,3
	wave_cutoff 25
	note A_,3, 10
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	note G#,3
	wave_cutoff 60
	note F#,3, 20
	wave_cutoff 25
	note F#,3, 10
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note F#,3
	note D#,3, 20
	wave_cutoff 60
	note G#,3, 20
	wave_cutoff 25
	note G#,3, 10
	note G#,3
	note G#,3
	note G#,3
	note G#,3
	note G#,3
	note G#,3
	snd_ret
SndCall_BGM_07_Ch3_1:
	note G#,3, 10
	note G#,3
	note G#,3
	note G#,3
	note G#,3
	note G#,3, 20
	snd_ret
SndCall_BGM_07_Ch3_2:
	note G#,3, 10
	note G#,3
	note G#,3
	note G#,3
	note G#,3
	note G#,3, 30
	snd_ret
SndCall_BGM_07_Ch3_4:
	note G#,3, 10
	note G#,4
	note G#,4
	note G#,4
	note G#,4
	note G#,4, 20
	snd_ret
SndCall_BGM_07_Ch3_3:
	wave_cutoff 90
	note A_,3, 30
	note A_,3, 40
	continue 10
	note A_,3, 30
	note A_,3, 20
	note A_,3, 10
	note G#,3, 20
	note F#,3, 30
	note F#,3, 40
	continue 10
	note F#,3, 30
	note F#,3, 20
	note F#,3, 10
	note G#,3
	note C#,3, 20
	note C#,3, 10
	note E_,3
	note G#,3
	note B_,3
	note A#,3, 20
	note C#,3, 10
	note D#,3
	note G#,3
	note B_,3
	note A#,3, 30
	note C#,3, 10
	note A_,3, 40
	note A_,3
	continue 10
	note A_,3, 30
	note A_,3, 20
	note A_,3, 10
	note A_,3
	note B_,3, 40
	note B_,3
	continue 10
	note B_,3, 30
	note B_,3, 20
	note B_,3, 10
	note B_,3
	note G#,3, 20
	note G#,3, 10
	note C_,4
	note D#,4
	note G#,4
	note F#,4, 20
	note G#,4
	wave_cutoff 25
	note G#,3, 10
	note G#,3
	note G#,3
	note G#,3
	note G#,3
	note G#,3
	snd_ret
SndCall_BGM_07_Ch3_5:
	wave_cutoff 60
	note C#,4, 20
	wave_cutoff 25
	note C#,4, 10
	note C#,4
	note C#,4
	note C#,4
	note C#,4
	note C#,4
	note C#,4
	note C#,4
	note C#,4
	note C#,4
	note C#,3
	note C#,4
	note B_,3, 20
	wave_cutoff 60
	note A_,3
	wave_cutoff 25
	note A_,3, 10
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	note A_,3
	wave_cutoff 60
	note B_,3, 20
	wave_cutoff 25
	note B_,3, 10
	note B_,3
	note B_,3
	note B_,3
	note B_,3
	note B_,3
	note B_,3
	note C_,4
	note C_,4
	note C_,4
	note C_,4
	note C_,4
	note C_,4, 20
	wave_cutoff 0
	note C#,4, 10
	continue 80
	wave_cutoff 25
	note C#,3, 10
	note C#,4, 20
	note C#,3, 10
	note C#,4
	note C#,4, 20
	snd_ret
SndData_BGM_07_Ch4:
	panning $88
	envelope $31
	note4x $21, 20 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 20
	envelope $31
	note4x $21, 20 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 20
	envelope $31
	note4x $21, 20 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 20
	envelope $62
	note4 B_,5,0, 10
	note4 B_,5,0, 5
	envelope $31
	note4x $21, 5 ; Nearest: A#,5,0
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 20 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 20
	envelope $31
	note4x $21, 20 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 20
	envelope $31
	note4x $21, 20 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 20
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $72
	note4 A_,5,0, 5
	envelope $61
	note4 F_,5,0, 5
	envelope $72
	note4x $32, 10 ; Nearest: A_,5,0
	envelope $61
	note4 F_,5,0, 10
SndData_BGM_07_Ch4_0:
	snd_call SndCall_BGM_07_Ch4_0_0
	snd_call SndCall_BGM_07_Ch4_1
	snd_call SndCall_BGM_07_Ch4_2
	snd_call SndCall_BGM_07_Ch4_3_0
	snd_call SndCall_BGM_07_Ch4_4
	snd_call SndCall_BGM_07_Ch4_3_0
	snd_call SndCall_BGM_07_Ch4_5
	snd_loop SndData_BGM_07_Ch4_0
SndCall_BGM_07_Ch4_0_0:
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	snd_loop SndCall_BGM_07_Ch4_0_0, $00, 3
	snd_ret
SndCall_BGM_07_Ch4_1:
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	note4 B_,5,0, 10
	note4 B_,5,0, 10
	note4 B_,5,0, 10
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 2
	envelope $62
	note4 B_,5,0, 3
	envelope $72
	note4 A_,5,0, 15
	envelope $72
	note4x $32, 10 ; Nearest: A_,5,0
	snd_ret
SndCall_BGM_07_Ch4_2:
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 5 ; Nearest: A#,5,0
	note4x $21, 5 ; Nearest: A#,5,0
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $72
	note4 A_,5,0, 10
	envelope $72
	note4x $32, 20 ; Nearest: A_,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 5 ; Nearest: A#,5,0
	note4x $21, 5 ; Nearest: A#,5,0
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $72
	note4 A_,5,0, 10
	envelope $72
	note4x $32, 10 ; Nearest: A_,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
SndCall_BGM_07_Ch4_2_0:
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	note4x $21, 10 ; Nearest: A#,5,0
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 5 ; Nearest: A#,5,0
	note4x $21, 5 ; Nearest: A#,5,0
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $72
	note4 A_,5,0, 10
	envelope $72
	note4x $32, 10 ; Nearest: A_,5,0
	envelope $61
	note4 F_,5,0, 10
	snd_loop SndCall_BGM_07_Ch4_2_0, $00, 2
SndCall_BGM_07_Ch4_2_1:
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	snd_loop SndCall_BGM_07_Ch4_2_1, $00, 2
	snd_ret
SndCall_BGM_07_Ch4_3_0:
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	snd_loop SndCall_BGM_07_Ch4_3_0, $00, 3
	snd_ret
SndCall_BGM_07_Ch4_4:
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	note4 B_,5,0, 10
	note4 B_,5,0, 10
	note4 B_,5,0, 10
	note4 B_,5,0, 10
	envelope $72
	note4x $32, 10 ; Nearest: A_,5,0
	envelope $61
	note4 F_,5,0, 10
	snd_ret
SndCall_BGM_07_Ch4_5:
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	note4 B_,5,0, 10
	envelope $72
	note4x $32, 10 ; Nearest: A_,5,0
	envelope $61
	note4 F_,5,0, 10
	snd_ret
