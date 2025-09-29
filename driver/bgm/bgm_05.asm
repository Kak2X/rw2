SndHeader_BGM_05:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_05_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_05_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_05_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_05_Ch4_0 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_05_Ch1:
	envelope $11
	panning $11
	duty_cycle 1
	note D_,4, 96
	continue 96
	continue 96
	continue 96
SndData_BGM_05_Ch1_0:
	snd_call SndCall_BGM_05_Ch1_0
	snd_call SndCall_BGM_05_Ch1_1
	fine_tune 5
	snd_call SndCall_BGM_05_Ch1_0
	fine_tune -5
	snd_call SndCall_BGM_05_Ch1_2
	snd_call SndCall_BGM_05_Ch1_3
	snd_call SndCall_BGM_05_Ch1_4
	snd_call SndCall_BGM_05_Ch1_3
	snd_call SndCall_BGM_05_Ch1_5
	fine_tune -2
	snd_call SndCall_BGM_05_Ch1_3
	snd_call SndCall_BGM_05_Ch1_4
	snd_call SndCall_BGM_05_Ch1_3
	fine_tune 2
	snd_call SndCall_BGM_05_Ch1_6
	snd_loop SndData_BGM_05_Ch1_0
SndCall_BGM_05_Ch1_0:
	duty_cycle 1
	envelope $11
	note D_,4, 24
	envelope $77
	note D_,4, 6
	note D#,4
	note D_,4
	note D#,4
	note G_,4, 36
	note F_,4, 12
	note C_,4, 6
	note C_,4
	envelope $11
	note C_,4, 12
	envelope $77
	note C_,4, 48
	note A#,3, 48
	note D_,4, 6
	note D#,4
	note D_,4
	note D#,4
	note G_,4, 36
	note F_,4, 12
	note C_,5, 6
	note C_,5
	envelope $11
	note C_,5, 12
	envelope $77
	note C_,5, 48
	note A#,4, 48
	note D_,4, 6
	note D#,4
	note D_,4
	note D#,4
	note G_,4, 36
	note F_,4, 12
	note C_,4, 6
	note C_,4
	envelope $11
	note C_,4, 12
	envelope $77
	note C_,4, 48
	note A#,3, 48
	snd_ret
SndCall_BGM_05_Ch1_1:
	note D_,4, 6
	note D#,4
	note D_,4
	note D#,4
	note G_,4
	note G#,4
	note G_,4
	note G#,4
	note B_,4
	note C_,5
	note B_,4
	note C_,5
	note G_,5, 24
	note F_,5
	note D#,5
	note C_,5
	snd_ret
SndCall_BGM_05_Ch1_2:
	note D_,4, 6
	note D#,4
	note D_,4
	note D#,4
	note G_,4
	note G#,4
	note G_,4
	note G#,4
	note B_,4
	note C_,5
	note B_,4
	note C_,5
	note G_,5, 24
	note G#,5
	note G_,5
	note F_,5
	snd_ret
SndCall_BGM_05_Ch1_3:
	note D#,5, 12
	note D#,5, 6
	note D_,5
	envelope $72
	panning $10
	duty_cycle 2
	note A#,4
	note A#,4
	note A#,4
	note A#,4
	note A#,4
	silence
	envelope $77
	panning $11
	duty_cycle 1
	note D_,5, 12
	note D#,5
	note F_,5
	snd_ret
SndCall_BGM_05_Ch1_4:
	note G_,5, 6
	note F_,5
	note D#,5
	note C_,5
	envelope $72
	panning $10
	duty_cycle 2
	note C_,5
	note C_,5
	note C_,5
	note C_,5
	note C_,5
	silence
	envelope $77
	panning $11
	duty_cycle 1
	note A#,4, 12
	silence
	note C_,5
	snd_ret
SndCall_BGM_05_Ch1_5:
	note G_,4, 24
	envelope $72
	panning $10
	duty_cycle 2
	note C_,5, 6
	note C_,5
	note C_,5
	note C_,5
	note C_,5
	envelope $11
	note C_,5, 18
	envelope $77
	panning $11
	duty_cycle 1
	note C_,5, 24
	snd_ret
SndCall_BGM_05_Ch1_6:
	note F_,4, 24
	note D#,5
	note D_,5
	note G_,5
	envelope $11
	note C_,5, 24
	envelope $74
	note C_,5, 6
	note D_,5
	note C_,5
	note D_,5
	note D#,5, 12
	note D#,5
	silence
	note C_,5
	note G#,4, 6
	note G#,4
	silence 12
	envelope $77
	note G#,4, 48
	note G_,4, 48
	envelope $74
	note C_,5, 6
	note D_,5
	note C_,5
	note D_,5
	note D#,5, 12
	note D#,5
	silence
	note G_,5
	note G#,5, 6
	note G#,5
	silence 12
	envelope $77
	note G#,5, 48
	note F_,5, 48
	envelope $74
	note D#,5, 6
	note F_,5
	note D#,5
	note F_,5
	note G_,5, 18
	note F_,5, 6
	note D#,5
	note D#,5
	note C_,5, 12
	silence 6
	note G_,4
	note G#,4
	note G_,4
	envelope $11
	note G_,4, 24
	continue 6
	envelope $74
	note G_,4
	note G#,4
	note G_,4
	note F_,4
	note D#,4
	note D_,4
	note D#,4
	note D_,4, 12
	note D_,4, 6
	envelope $77
	note C_,4, 72
	continue 6
	continue 96
	snd_ret
SndData_BGM_05_Ch2:
	envelope $11
	panning $22
	duty_cycle 2
	note D_,5, 96
	continue 96
	continue 96
	continue 48
	envelope $48
	note D_,4
SndData_BGM_05_Ch2_0:
	snd_call SndCall_BGM_05_Ch2_0
	snd_call SndCall_BGM_05_Ch2_1
	snd_call SndCall_BGM_05_Ch2_2
	snd_call SndCall_BGM_05_Ch2_1
	snd_call SndCall_BGM_05_Ch2_3
	fine_tune -2
	snd_call SndCall_BGM_05_Ch2_1
	snd_call SndCall_BGM_05_Ch2_2
	snd_call SndCall_BGM_05_Ch2_1
	fine_tune 2
	snd_call SndCall_BGM_05_Ch2_4
	snd_loop SndData_BGM_05_Ch2_0
SndCall_BGM_05_Ch2_0:
	fine_tune -12
	note D#,5, 96
	note F_,5
	note D#,5
	note D_,5, 48
	note G#,4
	note A#,5, 96
	note A_,5
	note G#,5
	note G_,5, 24
	note C_,6
	note D#,6
	note G_,6
	fine_tune 12
	envelope $11
	note G_,4, 48
	envelope $54
	note G_,4, 6
	note G#,4
	note G_,4
	note G#,4
	envelope $57
	note G_,4, 24
	continue 24
	note A#,4
	envelope $54
	note C_,5, 6
	envelope $57
	note C_,5, 18
	note C_,5, 72
	envelope $54
	note G_,4, 6
	note G#,4
	note G_,4
	note G#,4
	envelope $57
	note G_,4, 24
	continue 24
	note D#,4
	envelope $54
	note D_,4, 6
	envelope $57
	note D_,4, 18
	note C#,4, 72
	envelope $54
	note G_,4, 6
	note G#,4
	note G_,4
	note G#,4
	envelope $57
	note G_,4, 24
	continue 24
	note A#,4
	envelope $54
	note C_,5, 6
	envelope $57
	note C_,5, 18
	note C_,5, 24
	continue 12
	duty_cycle 1
	note G_,3
	note D#,4
	note G_,3
	note D#,4
	note G_,3
	note G_,4
	note C_,4
SndCall_BGM_05_Ch2_0_0:
	envelope $63
	note C_,4, 6
	note D_,4
	note C_,4, 12
	snd_loop SndCall_BGM_05_Ch2_0_0, $00, 4
	snd_ret
SndCall_BGM_05_Ch2_1:
	envelope $64
	duty_cycle 0
	note G_,4, 12
	note G_,4, 6
	note F_,4
	envelope $62
	panning $02
	duty_cycle 2
	note D_,4
	note D_,4
	note D_,4
	note D_,4
	note D_,4
	silence
	envelope $67
	panning $22
	duty_cycle 0
	note F_,4, 12
	note G_,4
	note G#,4
	snd_ret
SndCall_BGM_05_Ch2_2:
	note D#,4, 24
	envelope $62
	panning $02
	duty_cycle 2
	note D#,4, 6
	note D#,4
	note D#,4
	note D#,4
	note D#,4
	silence
	envelope $67
	panning $22
	duty_cycle 0
	note D_,4, 24
	note D#,4, 12
	snd_ret
SndCall_BGM_05_Ch2_3:
	note D#,4, 24
	envelope $62
	panning $02
	duty_cycle 2
	note D#,4, 6
	note D#,4
	note D#,4
	note D#,4
	note D#,4
	envelope $11
	note D#,4, 18
	envelope $67
	panning $22
	duty_cycle 0
	note G_,4, 24
	snd_ret
SndCall_BGM_05_Ch2_4:
	note C#,4, 24
	envelope $62
	panning $02
	duty_cycle 2
	note C#,4, 6
	note C#,4
	note C#,4
	note C#,4
	envelope $67
	panning $22
	duty_cycle 0
	note F_,4, 24
	note D#,4
	envelope $58
	duty_cycle 2
	note C_,5, 24
	envelope $48
	note C_,5
	envelope $38
	note C_,5
	envelope $28
	note C_,5
	envelope $58
	note F_,4
	envelope $48
	note F_,4
	envelope $38
	note F_,4
	envelope $58
	note D#,4
	note D_,4
	envelope $48
	note D_,4
	envelope $38
	note D_,4
	envelope $28
	note D_,4
	envelope $58
	note D#,4
	note F_,4
	note G_,4
	note C_,5
	note D#,5
	envelope $48
	note D#,5
	envelope $38
	note D#,5
	envelope $28
	note D#,5
	envelope $58
	note F_,5
	envelope $48
	note F_,5
	envelope $58
	note D#,5
	envelope $48
	note D#,5
	envelope $58
	note D_,5
	note C_,5
	envelope $48
	note C_,5
	envelope $38
	note C_,5
SndCall_BGM_05_Ch2_4_0:
	envelope $63
	duty_cycle 1
	note C_,4, 6
	note D_,4
	note C_,4, 12
	snd_loop SndCall_BGM_05_Ch2_4_0, $00, 4
	envelope $48
	duty_cycle 2
	snd_ret
SndData_BGM_05_Ch3:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 40
	snd_call SndCall_BGM_05_Ch3_0
SndData_BGM_05_Ch3_0:
	snd_call SndCall_BGM_05_Ch3_1_0
	snd_call SndCall_BGM_05_Ch3_2
	snd_call SndCall_BGM_05_Ch3_3
	fine_tune -2
	snd_call SndCall_BGM_05_Ch3_2
	fine_tune 2
	snd_call SndCall_BGM_05_Ch3_4
	snd_call SndCall_BGM_05_Ch3_5_0
	snd_loop SndData_BGM_05_Ch3_0
SndCall_BGM_05_Ch3_0:
	note C_,3, 24
	note G_,3, 12
	note C_,3
	note C_,3, 6
	note C_,3
	note C_,3, 12
	note G_,3
	note C_,3, 18
	note C_,3, 6
	note D_,3, 12
	note G_,3
	note A_,3, 18
	note C_,3, 12
	note C_,3, 6
	note G_,3, 12
	note C_,3
	note C_,3, 18
	note C_,3, 6
	note G_,3, 12
	note C_,3
	note C_,3, 6
	note C_,3
	note C_,3, 12
	note G_,3
	note C_,3, 18
	note C_,3, 6
	note D_,3, 12
	note G_,3
	note A_,3, 18
	note C_,3, 12
	note C_,3, 6
	note G_,3, 12
	note C_,3
	snd_ret
SndCall_BGM_05_Ch3_1_0:
	note C_,3, 18
	note C_,3, 6
	note G_,3, 12
	note C_,3
	note C_,3, 6
	note C_,3
	note C_,3, 12
	note G_,3
	note C_,3, 18
	note C_,3, 6
	note D_,3, 12
	note G_,3
	note A_,3, 18
	note C_,3, 12
	note C_,3, 6
	note G_,3, 12
	note C_,3
	snd_loop SndCall_BGM_05_Ch3_1_0, $00, 8
	snd_ret
SndCall_BGM_05_Ch3_2:
	note A#,3, 12
	note A#,3, 6
	note A#,3
	note A#,3, 12
	note A#,3
	note A#,3, 6
	note A#,3
	note A#,3, 12
	note G_,3
	note G_,3
	note C_,4, 18
	note C_,4, 6
	note G_,4, 12
	note C_,4
	note C_,4, 6
	note C_,4
	note C_,4, 12
	note G_,4
	note C_,4
	note A#,3, 12
	note A#,3, 6
	note A#,3
	note A#,3, 12
	note A#,3
	note A#,3, 6
	note A#,3
	note A#,3, 12
	note G_,3
	note G_,3
	snd_ret
SndCall_BGM_05_Ch3_3:
	note C_,4, 18
	note C_,4, 6
	note G_,4, 12
	note C_,4
	note G_,3, 6
	note G_,3
	note G_,3, 12
	note G_,3
	note G_,3
	snd_ret
SndCall_BGM_05_Ch3_4:
	note A#,3, 18
	note A#,3, 6
	note F_,4, 12
	note A#,3
	note G_,3, 6
	note G_,3
	note G_,3, 12
	note G_,4
	note G_,3
	snd_ret
SndCall_BGM_05_Ch3_5_0:
	note C_,3, 18
	note C_,3, 6
	note G_,3, 12
	note C_,3
	note C_,3, 6
	note C_,3
	note C_,3, 12
	note G_,3
	note C_,3, 18
	note D_,3, 6
	note D#,3, 12
	note G#,3
	note D_,3, 18
	note D_,3, 12
	note D_,3, 6
	note G#,3, 12
	note D_,3
	snd_loop SndCall_BGM_05_Ch3_5_0, $00, 2
	note D#,3, 18
	note D#,3, 6
	note A#,3, 12
	note D#,3
	note D#,3, 6
	note D#,3
	note D#,3, 12
	note A#,3
	note D#,3, 18
	note D_,3, 6
	note D#,3, 12
	note G_,3
	note G#,3, 18
	note G_,2, 12
	note G_,2, 6
	note G_,3, 12
	note G_,2
	note C_,3, 18
	note C_,3, 6
	note G_,3, 12
	note C_,3
	note C_,3, 6
	note C_,3
	note C_,3, 12
	note G_,3
	note C_,3, 18
	note C_,3, 6
	note D_,3, 12
	note G_,3
	note A_,3, 18
	note C_,3, 12
	note C_,3, 6
	note G_,3, 12
	note C_,3
	snd_ret
SndData_BGM_05_Ch4_0:
	panning $88
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
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	snd_loop SndData_BGM_05_Ch4_0
