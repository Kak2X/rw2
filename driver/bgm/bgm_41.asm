SndHeader_BGM_41:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_41_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_41_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_41_Ch3 ; Data ptr
	db 12 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_41_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_41_Ch1:
	envelope $73
	panning $11
	duty_cycle 0
	snd_call SndCall_BGM_41_Ch1_0
SndData_BGM_41_Ch1_0:
	snd_call SndCall_BGM_41_Ch1_1
	snd_call SndCall_BGM_41_Ch1_2
	snd_call SndCall_BGM_41_Ch1_1
	snd_call SndCall_BGM_41_Ch1_3
	snd_loop SndData_BGM_41_Ch1_0
SndCall_BGM_41_Ch1_0:
	note G_,4, 18
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note F_,4
	note F_,4
	note F_,4
	note F_,4
	note F_,4
	note F_,4
	note F_,4
	note F_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note F_,4
	note F_,4
	note F_,4
	note F_,4
	note F_,4
	note F_,4
	note F_,4
	note F_,4
	note F_,4
	snd_ret
SndCall_BGM_41_Ch1_1:
	envelope $11
	duty_cycle 2
	note G_,5, 18
	envelope $68
	note G_,5
	note G_,5
	note G_,5
	note G_,5
	note F_,5, 36
	note E_,5, 18
	note F_,5, 36
	note E_,5, 18
	note A_,4, 36
	envelope $58
	note A_,4
	envelope $48
	note A_,4, 18
	snd_ret
SndCall_BGM_41_Ch1_2:
	envelope $11
	note A_,4
	envelope $68
	note B_,4
	note C_,5
	note D_,5
	note C_,5
	note B_,4
	note A_,4
	note G_,4
	note G_,5, 36
	note A_,5, 18
	note E_,5, 36
	envelope $58
	note E_,5
	envelope $48
	note E_,5, 18
	snd_ret
SndCall_BGM_41_Ch1_3:
	envelope $11
	note A_,4, 36
	envelope $68
	note B_,4, 18
	note C_,5
	note D_,5
	note E_,5, 36
	note D_,5, 18
	note D_,5
	note C_,5
	note B_,4
	note C_,5, 36
	envelope $58
	note C_,5
	envelope $48
	note C_,5, 18
	envelope $11
	note A_,4, 36
	envelope $68
	note A_,4, 18
	note B_,4
	note C_,5
	note D_,5, 36
	note E_,5, 18
	note D_,5
	note E_,5
	note D_,5
	note C_,5, 36
	note B_,4, 18
	note G_,4, 36
	envelope $11
	note A_,4
	envelope $68
	note G_,5
	note F_,5
	note E_,5, 18
	note F_,5
	envelope $11
	note F_,5
	envelope $68
	note F_,5
	note E_,5
	silence
	note D_,5
	note E_,5
	silence
	note F_,5, 36
	envelope $58
	note F_,5
	envelope $48
	note F_,5
	envelope $68
	note G_,5, 18
	note A_,5
	note G_,5
	continue 36
	envelope $58
	note G_,5
	envelope $48
	note G_,5
	envelope $38
	note G_,5
	snd_ret
SndData_BGM_41_Ch2:
	envelope $63
	panning $22
	duty_cycle 1
	snd_call SndCall_BGM_41_Ch2_0
SndData_BGM_41_Ch2_0:
	snd_call SndCall_BGM_41_Ch2_1
	snd_loop SndData_BGM_41_Ch2_0
SndCall_BGM_41_Ch2_0:
	note E_,4, 18
	note E_,4
	note E_,4
	note E_,4
	note E_,4
	note E_,4
	note E_,4
	note D_,4
	note D_,4
	note D_,4
	note D_,4
	note D_,4
	note D_,4
	note D_,4
	note D_,4
	note E_,4
	note E_,4, 18
	note E_,4
	note E_,4
	note E_,4
	note E_,4
	note E_,4
	note E_,4
	note D_,4
	note D_,4
	note D_,4
	note D_,4
	note D_,4
	note D_,4
	note D_,4
	note D_,4
	note D_,4
	snd_ret
SndCall_BGM_41_Ch2_1:
	note G_,4, 18
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note F_,4
	note F_,4
	note F_,4
	note F_,4
	note F_,4
	note F_,4
	note F_,4
	note F_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	envelope $57
	note G_,4, 18
	envelope $37
	note G_,4
	envelope $57
	note G_,4
	envelope $37
	note G_,4
	envelope $57
	note C_,5
	envelope $37
	note C_,5
	envelope $57
	note E_,5
	envelope $37
	note E_,5
	envelope $63
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note G_,4
	note C_,5
	note C_,5
	note C_,5
	note C_,5
	note C_,5
	note C_,5
	note C_,5
	note C_,5
	note B_,4
	note B_,4
	note B_,4
	note B_,4
	note B_,4
	note B_,4
	note B_,4
	note B_,4
	envelope $57
	note G_,4, 18
	envelope $37
	note G_,4
	envelope $57
	note G_,4
	envelope $37
	note G_,4
	envelope $57
	note F_,4
	envelope $37
	note F_,4
	envelope $57
	note E_,4
	envelope $37
	note E_,4
	envelope $63
	note C_,5
	note C_,5
	note C_,5
	note C_,5
	note C_,5
	note C_,5
	note C_,5
	note C_,5
	note D_,5
	note D_,5
	note D_,5
	note D_,5
	note D_,5
	note D_,5
	note D_,5
	note D_,5
	note E_,5
	note E_,5
	note E_,5
	note E_,5
	note E_,5
	note E_,5
	note E_,5
	note E_,5
	note D_,5
	note D_,5
	note D_,5
	note D_,5
	note D_,5
	note C_,5
	silence
	envelope $68
	note B_,4
	continue 36
	envelope $58
	note B_,4
	envelope $48
	note B_,4
	envelope $38
	note B_,4
	envelope $11
	note D_,5, 18
	envelope $33
	note A_,4
	envelope $43
	note A_,4
	envelope $53
	note A_,4
	envelope $63
	note G_,4
	envelope $73
	note G_,4
	envelope $83
	note F_,4
	envelope $93
	note F_,4
	envelope $63
	snd_ret
SndData_BGM_41_Ch3:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 90
	snd_call SndCall_BGM_41_Ch3_0_0
SndData_BGM_41_Ch3_0:
	wave_cutoff 90
	snd_call SndCall_BGM_41_Ch3_1_0
	snd_call SndCall_BGM_41_Ch3_2_0
	snd_loop SndData_BGM_41_Ch3_0
SndCall_BGM_41_Ch3_0_0:
	note C_,3, 54
	note C_,3, 18
	snd_loop SndCall_BGM_41_Ch3_0_0, $00, 7
	note C_,3, 36
	note C_,3
	snd_ret
SndCall_BGM_41_Ch3_1_0:
	note C_,3, 54
	note C_,3, 18
	snd_loop SndCall_BGM_41_Ch3_1_0, $00, 10
	note F_,2, 54
	note F_,2, 18
	note F_,2, 54
	note F_,2, 18
	note G_,2, 54
	note G_,2, 18
	note G_,2, 54
	note G_,2, 18
	note C_,3, 54
	note C_,3, 18
	note C_,3, 54
	note C_,3, 18
	snd_ret
SndCall_BGM_41_Ch3_2_0:
	note F_,3, 54
	note F_,3, 18
	snd_loop SndCall_BGM_41_Ch3_2_0, $00, 7
	note F_,3, 18
	note F_,3, 36
	note G_,3, 36
	wave_cutoff 40
SndCall_BGM_41_Ch3_2_1:
	note G_,3, 18
	snd_loop SndCall_BGM_41_Ch3_2_1, $00, 15
	snd_ret
SndData_BGM_41_Ch4:
	panning $88
	snd_call SndCall_BGM_41_Ch4_0_0
SndData_BGM_41_Ch4_0:
	snd_call SndCall_BGM_41_Ch4_1_0
	snd_call SndCall_BGM_41_Ch4_2
	snd_call SndCall_BGM_41_Ch4_3
	snd_call SndCall_BGM_41_Ch4_2
	snd_call SndCall_BGM_41_Ch4_4
	snd_loop SndData_BGM_41_Ch4_0
SndCall_BGM_41_Ch4_0_0:
	envelope $61
	note4 F_,5,0, 54
	note4 F_,5,0, 18
	note4 F_,5,0, 36
	envelope $62
	note4 B_,5,0, 36
	snd_loop SndCall_BGM_41_Ch4_0_0, $00, 3
	envelope $61
	note4 F_,5,0, 54
	note4 F_,5,0, 18
	note4 F_,5,0, 18
	envelope $54
	note4x $22, 18 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 18
	envelope $72
	note4x $32, 18 ; Nearest: A_,5,0
	snd_ret
SndCall_BGM_41_Ch4_1_0:
	envelope $61
	note4 F_,5,0, 54
	note4 F_,5,0, 18
	note4 F_,5,0, 36
	envelope $62
	note4 B_,5,0, 36
	snd_loop SndCall_BGM_41_Ch4_1_0, $00, 7
	envelope $61
	note4 F_,5,0, 54
	note4 F_,5,0, 18
	note4 F_,5,0, 18
	envelope $62
	note4 B_,5,0, 18
	envelope $54
	note4x $22, 9 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 9
	envelope $72
	note4x $32, 18 ; Nearest: A_,5,0
	snd_ret
SndCall_BGM_41_Ch4_2:
	envelope $61
	note4 F_,5,0, 36
	envelope $62
	note4 B_,5,0, 18
	envelope $61
	note4 F_,5,0, 18
	note4 F_,5,0, 36
	envelope $62
	note4 B_,5,0, 36
	snd_ret
SndCall_BGM_41_Ch4_3:
	envelope $61
	note4 F_,5,0, 36
	envelope $62
	note4 B_,5,0, 18
	envelope $61
	note4 F_,5,0, 18
	note4 F_,5,0, 36
	envelope $62
	note4 B_,5,0, 18
	envelope $61
	note4 F_,5,0, 18
	snd_ret
SndCall_BGM_41_Ch4_4:
	envelope $61
	note4 F_,5,0, 36
	envelope $62
	note4 B_,5,0, 18
	envelope $61
	note4 F_,5,0, 18
	note4 F_,5,0, 9
	envelope $54
	note4x $22, 9 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 18
	envelope $61
	note4 F_,5,0, 18
	envelope $62
	note4 B_,5,0, 18
	envelope $11
	note4x $11, 18 ; Nearest: A#,6,0
	envelope $21
	note4 F_,5,0, 18
	note4 F_,5,0, 18
	envelope $31
	note4 F_,5,0, 18
	note4 F_,5,0, 18
	envelope $41
	note4 F_,5,0, 18
	note4 F_,5,0, 18
	envelope $51
	note4 F_,5,0, 18
	note4 F_,5,0, 18
	envelope $32
	note4 B_,5,0, 18
	note4 B_,5,0, 18
	envelope $42
	note4 B_,5,0, 18
	note4 B_,5,0, 18
	envelope $52
	note4 B_,5,0, 18
	note4 B_,5,0, 18
	envelope $62
	note4 B_,5,0, 18
	snd_ret
