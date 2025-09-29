SndHeader_BGM_09:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_09_Ch1 ; Data ptr
	db -6 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_09_Ch2 ; Data ptr
	db -6 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_09_Ch3 ; Data ptr
	db -6 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_09_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_09_Ch1:
	envelope $11
	panning $11
	duty_cycle 2
	note C_,2, 72
SndData_BGM_09_Ch1_0:
	snd_call SndCall_BGM_09_Ch1_0
	snd_loop SndData_BGM_09_Ch1_0
SndCall_BGM_09_Ch1_0:
	envelope $68
	note D#,5, 96
	note D_,5, 72
	continue 18
	duty_cycle 3
	panning $01
	note A#,4, 6
	silence
	note C_,5
	note C_,5
	note A#,4
	note C_,5
	note C_,5, 12
	silence 6
	duty_cycle 2
	panning $11
	note D#,5, 48
	note D_,5, 72
	envelope $78
	duty_cycle 3
	note A#,4, 24
	note C_,5, 72
	continue 12
	note D#,5, 6
	note G_,5
	note G#,5, 48
	note G_,5, 24
	note D#,5
	note F_,5, 96
	continue 72
	note A#,4, 24
	note C_,5, 72
	silence 6
	note D#,5
	note F_,5
	note G_,5
	note G#,5, 48
	note A#,5, 16
	note G#,5
	note G_,5
	note G#,5, 12
	note D#,5, 6
	note F_,5, 72
	continue 6
	envelope $58
	duty_cycle 2
	note D#,4, 6
	note F_,4, 12
	note F_,4, 48
	silence 12
	envelope $78
	duty_cycle 3
	note D#,5, 6
	silence
	note F_,5
	envelope $11
	note F_,5, 24
	envelope $58
	duty_cycle 2
	note F_,4, 72
	silence 6
	note F_,4, 3
	silence
	note F_,4
	silence
	note F_,4
	silence
	note F_,4
	silence
	note F_,4, 12
	note F_,4, 6
	envelope $11
	note F_,4, 12
	envelope $58
	note F_,4, 18
	note D#,4, 12
	envelope $77
	duty_cycle 1
	note C_,5, 6
	silence
	note C_,5
	note D#,5
	note G_,5
	note A#,5
	note G#,5
	note A#,5
	note C_,6, 48
	note A#,5, 6
	silence
	note G#,5
	note D#,5
	note F_,5
	envelope $58
	duty_cycle 2
	note D#,4
	note C_,4
	note D#,4
	note F_,4
	silence
	note F_,4, 18
	note F_,4
	envelope $77
	duty_cycle 1
	note C_,5, 6
	silence
	note C_,5
	note D#,5
	note G_,5
	note A#,5
	note G#,5
	note A#,5
	note C_,6
	silence
	note C_,6
	note A#,5
	note G#,5
	note G_,5
	note G#,5
	note D#,5
	note F_,5
	continue 24
	envelope $58
	duty_cycle 2
	note D#,4, 6
	note C_,4
	note D#,4
	note F_,4
	silence
	note F_,4, 18
	note F_,4
	note F_,4, 6
	silence 12
	note F_,4, 72
	continue 12
	silence 6
	note F_,3
	note G#,3
	note C_,4
	note D#,4
	note C_,4
	note D#,4
	note F_,4
	silence
	note F_,4, 18
	note F_,4
	note F#,4, 6
	silence 12
	note F#,4, 72
	continue 12
	silence 6
	note F#,4, 3
	silence
	note F#,4
	silence
	note F#,4
	silence
	note F#,4
	silence
	note F#,4
	silence
	silence 6
	note F#,4
	silence 12
	note F#,4
	envelope $77
	duty_cycle 1
	note B_,4, 18
	note C#,5, 6
	continue 72
	continue 12
	note E_,5, 6
	note G#,5
	note A_,5, 48
	note G#,5, 24
	note E_,5, 18
	note F#,5, 6
	continue 96
	envelope $58
	duty_cycle 2
	silence 6
	note F#,3
	note A_,3
	note C#,4
	note E_,4
	note C#,4
	note E_,4
	note F#,4
	silence
	note F#,4, 18
	note F#,4
	envelope $77
	duty_cycle 1
	note C#,6, 6
	continue 48
	silence 12
	note B_,5, 6
	note A_,5
	note B_,5
	note A_,5
	note E_,5
	note F#,5
	continue 12
	envelope $58
	duty_cycle 2
	note A_,4
	note G#,4
	note F#,4
	note E_,4, 6
	note F#,4, 18
	note F#,4, 12
	note E_,4, 6
	note F#,4
	envelope $11
	note F#,4, 96
	continue 48
	continue 6
	envelope $58
	note A_,3, 18
	note A#,3
	envelope $77
	duty_cycle 1
	note B_,5, 6
	silence
	note B_,5, 36
	continue 6
	note C#,6, 12
	note B_,5, 6
	note A_,5
	note B_,5
	note A_,5
	note E_,5
	note F#,5
	silence
	note F#,5, 48
	silence 6
	note E_,5
	note F#,5
	note A_,5
	note G#,5
	note E_,5
	note F#,5
	envelope $11
	note C_,4, 12
	envelope $58
	duty_cycle 2
	note C_,4, 72
	continue 12
	silence 6
	note C_,4
	note D#,4
	note G_,4
	note A#,4
	note G_,4
	note A#,4
	note C_,5
	silence
	note C_,5, 18
	note C_,5, 24
	envelope $11
	note G_,4, 72
	continue 18
	envelope $58
	note G_,4, 6
	silence
	note G#,4
	note G#,4
	note G_,4
	note G#,4
	note G#,4, 18
	envelope $11
	note G#,4, 48
	snd_ret
SndData_BGM_09_Ch2:
	envelope $11
	panning $22
	duty_cycle 2
	note C_,2, 72
SndData_BGM_09_Ch2_0:
	snd_call SndCall_BGM_09_Ch2_0
	snd_call SndCall_BGM_09_Ch2_1
	snd_call SndCall_BGM_09_Ch2_2
	snd_call SndCall_BGM_09_Ch2_1
	snd_call SndCall_BGM_09_Ch2_3
	snd_call SndCall_BGM_09_Ch2_4
	snd_call SndCall_BGM_09_Ch2_5
	snd_call SndCall_BGM_09_Ch2_6
	snd_call SndCall_BGM_09_Ch2_5
	snd_call SndCall_BGM_09_Ch2_7
	silence 6
	note G#,3
	note C_,4
	note D#,4
	note G_,4
	note F_,4
	note G_,4
	note G#,4
	silence
	note G#,4, 18
	note G#,4
	note A_,4, 6
	silence 12
	note A_,4, 72
	continue 12
	silence 6
	note A_,4, 3
	silence
	note A_,4
	silence
	note A_,4
	silence
	note A_,4
	silence
	note A_,4
	silence
	silence 6
	note A_,4
	silence 12
	note A_,4, 18
	note G#,4, 12
	note A_,4, 6
	snd_call SndCall_BGM_09_Ch2_8_0
	snd_loop SndData_BGM_09_Ch2_0
SndCall_BGM_09_Ch2_0:
	envelope $68
	note G#,4, 96
	note G#,4, 72
	continue 18
	duty_cycle 3
	panning $20
	note G_,4, 6
	silence
	note G#,4
	note G#,4
	note G_,4
	note G#,4
	note G#,4, 12
	silence 6
	duty_cycle 2
	panning $22
	note G#,4, 48
	note G#,4, 96
	snd_ret
SndCall_BGM_09_Ch2_1:
	envelope $53
	note C_,5, 12
	note C_,5, 6
	note C_,5
	note A#,4
	note C_,5, 12
	note C_,5, 6
	silence
	note C_,5
	note A#,4
	note C_,5
	note G_,4
	note G#,4
	note A#,4
	note G#,4
	silence
	note C_,4
	note D#,4
	note G_,4
	note A#,4
	note G#,4, 12
	note C_,5, 6
	silence
	note C_,5
	note A#,4
	note C_,5
	note A#,4
	note G#,4
	note G_,4
	note D#,4
	envelope $11
	note D#,4, 24
	envelope $58
	note C_,5
	note A#,4
	note G#,4
	snd_ret
SndCall_BGM_09_Ch2_2:
	note G_,4, 6
	note G#,4, 12
	note G#,4, 48
	envelope $11
	note G#,4, 18
	envelope $58
	note G_,4, 6
	note C_,4
	snd_ret
SndCall_BGM_09_Ch2_3:
	note G_,4, 6
	note G#,4, 12
	note G#,4, 48
	envelope $11
	note G#,4, 12
	envelope $58
	note G_,5, 6
	silence
	note G#,5
	snd_ret
SndCall_BGM_09_Ch2_4:
	envelope $11
	note G#,4, 24
	envelope $58
	note G#,4, 72
	silence 6
	note G#,4, 3
	silence
	note G#,4
	silence
	note G#,4
	silence
	note G#,4
	silence
	note G#,4, 12
	note G#,4, 6
	silence 12
	note G#,4, 18
	note G_,4, 12
	note G#,4, 6
	silence 12
	note G#,4, 72
	continue 12
	snd_ret
SndCall_BGM_09_Ch2_8_0:
	envelope $11
	note A_,4, 12
	envelope $58
	note A_,4, 72
	continue 12
	silence 6
	note A_,3
	note C#,4
	note E_,4
	note G#,4
	note F#,4
	note G#,4
	note A_,4
	silence
	note A_,4, 18
	note A_,4
	note A_,4, 6
	snd_loop SndCall_BGM_09_Ch2_8_0, $00, 2
	envelope $11
	note A_,4, 12
	envelope $58
	note A_,4, 72
	continue 12
	silence
	note C#,5
	note B_,4
	note A_,4
	note G#,4, 6
	note A_,4, 18
	note A_,4, 12
	note G#,4, 6
	note A_,4
	envelope $11
	note A_,4, 96
	continue 48
	continue 6
	envelope $58
	note E_,4, 18
	note F_,4
	note F#,4, 6
	silence
	note F#,4, 18
	envelope $11
	note F#,4, 48
	continue 18
	envelope $58
	note F#,4, 6
	silence
	note F#,4, 3
	silence
	note F#,4
	silence
	note F#,4
	silence
	note F#,4
	silence
	note F#,4, 12
	note F#,4, 6
	silence
	note F#,4, 12
	note F#,4, 6
	note F#,4, 12
	note C_,4, 6
	note C#,4
	silence 12
	note D#,4, 72
	continue 12
	silence 6
	note D#,4
	note G_,4
	note A#,4
	note D_,5
	note C_,5
	note D_,5
	note D#,5
	silence
	note D#,5, 18
	note D#,5, 24
	envelope $11
	note A#,4, 72
	continue 18
	envelope $58
	note A#,4, 6
	silence
	note C_,5
	note C_,5
	note A#,4
	note C_,5
	note C_,5, 18
	envelope $11
	note C_,5, 48
	snd_ret
SndCall_BGM_09_Ch2_5:
	silence 6
	note G#,3
	note C_,4
	note D#,4
	note G_,4
	note F_,4
	note G_,4
	note G#,4
	silence
	note G#,4, 18
	note G#,4
	note G#,4, 6
	snd_ret
SndCall_BGM_09_Ch2_6:
	silence 6
	note G#,4, 3
	silence
	note G#,4, 3
	silence
	note G#,4, 3
	silence
	note G#,4, 3
	silence
	note G#,4, 12
	note G#,4, 6
	silence
	note G#,4, 12
	note G#,4, 6
	note G#,4, 18
	note G#,3, 6
	snd_ret
SndCall_BGM_09_Ch2_7:
	envelope $11
	note G#,4, 12
	envelope $58
	note G#,4, 72
	continue 12
	snd_ret
SndCall_BGM_09_Ch2_Unused_:
	envelope $11
	note A_,4, 12
	envelope $58
	note A_,4, 72
	snd_ret
SndData_BGM_09_Ch3:
	wave_vol $00
	panning $44
	wave_id $03
	wave_cutoff 25
	note F_,3, 72
	wave_vol $80
SndData_BGM_09_Ch3_0:
	snd_call SndCall_BGM_09_Ch3_0
	snd_call SndCall_BGM_09_Ch3_1
	snd_call SndCall_BGM_09_Ch3_2
	snd_call SndCall_BGM_09_Ch3_1
	snd_call SndCall_BGM_09_Ch3_3
	snd_call SndCall_BGM_09_Ch3_1
	snd_call SndCall_BGM_09_Ch3_2
	snd_call SndCall_BGM_09_Ch3_1
	snd_call SndCall_BGM_09_Ch3_3
	snd_call SndCall_BGM_09_Ch3_4
	snd_call SndCall_BGM_09_Ch3_5
	snd_call SndCall_BGM_09_Ch3_5
	snd_call SndCall_BGM_09_Ch3_5
	snd_call SndCall_BGM_09_Ch3_6
	fine_tune 1
	snd_call SndCall_BGM_09_Ch3_5
	snd_call SndCall_BGM_09_Ch3_5
	fine_tune -1
	snd_call SndCall_BGM_09_Ch3_7
	fine_tune 1
	snd_call SndCall_BGM_09_Ch3_5
	fine_tune -1
	snd_call SndCall_BGM_09_Ch3_8
	snd_loop SndData_BGM_09_Ch3_0
SndCall_BGM_09_Ch3_0:
	note F_,4, 18
	note F_,3, 6
	note F_,3, 12
	note F_,3, 6
	note F_,3, 18
	note F_,3, 6
	note F_,3
	note F_,3, 12
	note F_,3, 6
	note F_,3
	note F_,3, 12
	note F_,3, 6
	note F_,3
	note F_,3, 12
	note F_,3, 6
	note F_,3, 12
	note A#,3, 6
	note G#,3
	note F_,3
	note A#,3, 12
	note G#,3
	snd_ret
SndCall_BGM_09_Ch3_1:
	note F_,3, 12
	note F_,3, 6
	note F_,3
	note F_,3, 12
	note F_,3, 6
	note F_,3, 18
	note F_,3, 6
	note F_,3
	note F_,3, 12
	note F_,3, 6
	note F_,3
	snd_ret
SndCall_BGM_09_Ch3_2:
	note F_,3, 12
	note F_,3, 6
	note F_,3
	note F_,3, 12
	note F_,3, 6
	note F_,3, 12
	note A#,3, 6
	note G#,3
	note F_,3
	note A#,3, 12
	note C_,4, 6
	note D#,3
	snd_ret
SndCall_BGM_09_Ch3_3:
	note F_,3, 12
	note F_,3, 6
	note F_,3
	note F_,3, 12
	note F_,3, 6
	note F_,3, 12
	note A#,3, 6
	note G#,3
	note F_,3
	note A#,3, 12
	note G#,3
	snd_ret
SndCall_BGM_09_Ch3_4:
	note A#,3, 12
	note A#,3, 6
	note A#,3
	note A#,3, 12
	note A#,3, 6
	note A#,3, 18
	note A#,3, 6
	note A#,3
	note A#,3, 12
	note A#,3, 6
	note A#,3
	note A#,3, 12
	note A#,3, 6
	note A#,3
	note A#,3, 12
	note A#,3, 6
	note A#,3, 12
	note C_,4, 6
	note A#,3
	note G#,3
	note A#,3, 12
	note C_,4, 6
	note F_,3
	snd_ret
SndCall_BGM_09_Ch3_5:
	silence 6
	note F_,3
	note G#,3
	note C_,4
	note D#,4
	note D_,4, 12
	note F_,4
	note F_,4, 6
	note D#,4
	note F_,4
	note D#,4
	note A#,3
	note G#,3
	note F_,3
	silence
	note F_,3
	note G#,3
	note C_,4
	note D#,4
	note D_,4
	note D#,4
	note F_,4
	silence
	note F_,4, 18
	note F_,4, 12
	note D#,3, 6
	note F_,3
	snd_ret
SndCall_BGM_09_Ch3_6:
	silence 6
	note F_,3
	note G#,3
	note C_,4
	note D#,4
	note D_,4, 12
	note F_,4
	note F_,4, 6
	note D#,4
	note F_,4
	note D#,4
	note A#,3
	note G#,3
	note F_,3
	silence
	note F_,3
	note G#,3
	note C_,4
	note D#,4
	note D_,4
	note D#,4
	note F_,4
	silence
	note F_,4, 18
	note F_,4, 12
	note D#,3, 6
	note F#,3
	snd_ret
SndCall_BGM_09_Ch3_7:
	silence 6
	note B_,3
	note D_,4
	note F#,4
	note A_,4
	note G#,4, 12
	note B_,4
	note B_,4, 6
	note A_,4
	note B_,4
	note A_,4
	note E_,4
	note D_,4
	note B_,3
	silence
	note B_,3
	note D_,4
	note F#,4
	note A_,4
	note G#,4
	note A_,4
	note B_,4
	silence
	note B_,4, 18
	note B_,4, 12
	note A_,3, 6
	note F#,3
	snd_ret
SndCall_BGM_09_Ch3_8:
	silence 6
	note F#,2
	note A_,2
	note C#,3
	note E_,3
	note D#,3, 12
	note F#,3
	note F#,3, 6
	note E_,3
	note F#,3
	note E_,3
	note B_,2
	note A_,2
	note F#,2
	silence
	note F#,2
	note A_,2
	note C#,3
	note E_,3
	note D#,3
	note E_,3
	note F#,3
	silence
	note F#,3, 18
	note F#,3, 12
	note A#,2, 6
	note B_,2
	silence 6
	note B_,2
	note D_,3
	note F#,3
	note A_,3
	note G#,3, 12
	note B_,3
	note B_,3, 6
	note A_,3
	note B_,3
	note A_,3
	note E_,3
	note D_,3
	note B_,2
	silence
	note B_,2
	note D_,3
	note F#,3
	note A_,3
	note G#,3
	note A_,3
	note B_,3
	silence
	note B_,3, 18
	note B_,3, 12
	note A_,2, 6
	note C_,3
	silence 6
	note C_,3
	note D#,3
	note G_,3
	note A#,3
	note A_,3, 12
	note C_,4
	note C_,4, 6
	note A#,3
	note C_,4
	note A#,3
	note F_,3
	note D#,3
	note C_,3
	silence
	note C_,3
	note D#,3
	note G_,3
	note A#,3
	note A_,3
	note A#,3
	note C_,4
	silence
	note C_,4, 18
	note C_,4, 12
	note D#,3, 6
	note F_,3
	silence 6
	note F_,3
	note G#,3
	note C_,4
	note D#,4
	note D_,4, 12
	note F_,4
	note F_,4, 6
	note D#,4
	note F_,4
	note D#,4
	note A#,3
	note G#,3
	note F_,3
	silence 12
	note F_,3, 6
	note F_,3
	note F_,3, 12
	note F_,3, 6
	note F_,3, 12
	note A#,3, 6
	note G#,3
	note F_,3
	note A#,3, 12
	note G#,3
	snd_ret
SndData_BGM_09_Ch4:
	panning $88
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 3
	note4 F_,5,0, 3
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
SndData_BGM_09_Ch4_0:
	snd_call SndCall_BGM_09_Ch4_0_0
	snd_call SndCall_BGM_09_Ch4_1
	snd_call SndCall_BGM_09_Ch4_0_0
	snd_call SndCall_BGM_09_Ch4_1
	snd_call SndCall_BGM_09_Ch4_0_0
	snd_call SndCall_BGM_09_Ch4_2
	snd_call SndCall_BGM_09_Ch4_3
	snd_call SndCall_BGM_09_Ch4_4_0
	snd_call SndCall_BGM_09_Ch4_5
	snd_call SndCall_BGM_09_Ch4_6
	snd_call SndCall_BGM_09_Ch4_7
	snd_call SndCall_BGM_09_Ch4_6
	snd_call SndCall_BGM_09_Ch4_5
	snd_call SndCall_BGM_09_Ch4_6
	snd_call SndCall_BGM_09_Ch4_7
	snd_call SndCall_BGM_09_Ch4_6
	snd_call SndCall_BGM_09_Ch4_5
	snd_call SndCall_BGM_09_Ch4_6
	envelope $31
	note4x $21, 12 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 3
	note4 F_,5,0, 3
	envelope $62
	note4 B_,5,0, 12
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	snd_call SndCall_BGM_09_Ch4_8
	snd_loop SndData_BGM_09_Ch4_0
SndCall_BGM_09_Ch4_0_0:
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
	envelope $61
	note4 F_,5,0, 6
	snd_loop SndCall_BGM_09_Ch4_0_0, $00, 3
	snd_ret
SndCall_BGM_09_Ch4_1:
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
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	snd_ret
SndCall_BGM_09_Ch4_2:
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
	envelope $62
	note4 B_,5,0, 12
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	snd_ret
SndCall_BGM_09_Ch4_3:
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $61
	note4 F_,5,0, 12
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
	envelope $61
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 12
	snd_ret
SndCall_BGM_09_Ch4_4_0:
	envelope $61
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 12
	envelope $61
	note4 F_,5,0, 12
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
	envelope $61
	note4 F_,5,0, 12
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
	envelope $61
	note4 F_,5,0, 12
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
	envelope $61
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	snd_loop SndCall_BGM_09_Ch4_4_0, $00, 2
	snd_ret
SndCall_BGM_09_Ch4_5:
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $61
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	snd_ret
SndCall_BGM_09_Ch4_6:
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $61
	note4 F_,5,0, 12
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
	envelope $61
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	snd_ret
SndCall_BGM_09_Ch4_7:
	envelope $31
	note4x $21, 12 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 12
	envelope $61
	note4 F_,5,0, 12
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
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	snd_ret
SndCall_BGM_09_Ch4_8:
	envelope $31
	note4x $21, 12 ; Nearest: A#,5,0
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
	envelope $31
	note4x $21, 12 ; Nearest: A#,5,0
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
	envelope $31
	note4x $21, 12 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 12
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
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
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 12
	note4 F_,5,0, 12
	note4 F_,5,0, 12
	note4 F_,5,0, 12
	envelope $61
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 12
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 12 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 12
	note4 B_,5,0, 12
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
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
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
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
	envelope $31
	note4x $21, 12 ; Nearest: A#,5,0
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
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 12
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	snd_ret
