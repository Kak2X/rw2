SndHeader_BGM_03:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_03_Ch1 ; Data ptr
	db -3 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_03_Ch2 ; Data ptr
	db -3 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_03_Ch3 ; Data ptr
	db -3 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_03_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_03_Ch1:
	envelope $11
	panning $11
	duty_cycle 2
	note C#,4, 96
	continue 24
	envelope $58
	note C#,4, 24
	note F_,4
	note A#,4, 18
	envelope $56
	duty_cycle 3
	note D#,5, 6
SndData_BGM_03_Ch1_0:
	snd_call SndCall_BGM_03_Ch1_0
	snd_call SndCall_BGM_03_Ch1_1
	snd_call SndCall_BGM_03_Ch1_0
	snd_call SndCall_BGM_03_Ch1_2
	snd_call SndCall_BGM_03_Ch1_3
	snd_call SndCall_BGM_03_Ch1_4
	snd_call SndCall_BGM_03_Ch1_5
	snd_call SndCall_BGM_03_Ch1_4
	snd_call SndCall_BGM_03_Ch1_6
	snd_loop SndData_BGM_03_Ch1_0
SndCall_BGM_03_Ch1_0:
	envelope $11
	note D#,5, 6
	envelope $56
	note D#,5
	note C#,5
	note A#,4
	note C#,5
	note D#,5
	silence
	note D#,5
	silence
	note D#,5
	note C#,5
	note A#,4
	note C#,5
	note D#,5
	silence
	note D#,5
	snd_ret
SndCall_BGM_03_Ch1_1:
	envelope $11
	note G#,4, 12
	envelope $56
	note G#,4, 6
	note A#,4
	note C#,5
	note F_,5
	silence
	note F#,5
	silence
	note F#,5
	note F_,5
	silence
	note G#,5
	note F#,5
	note F_,5
	note D#,5
	snd_ret
SndCall_BGM_03_Ch1_2:
	envelope $11
	note G#,4, 12
	envelope $56
	note G#,4, 6
	note A#,4
	note C#,5
	note F_,5
	silence
	note F#,5
	silence
	note F#,5
	note F_,5
	silence
	note G#,5
	note F#,5
	note F_,5
	note C#,5
	snd_ret
SndCall_BGM_03_Ch1_3:
	envelope $78
	note D#,4, 6
	note D#,4
	note F_,4
	note F#,4
	silence
	note D#,4
	note F_,4
	note F#,4
	note A#,4, 18
	note G#,4
	note F#,4, 12
	note G#,4, 18
	note F#,4
	note F_,4, 12
	note D#,4, 18
	note F_,4, 3
	note D#,4
	note C#,4, 24
	note F_,4
	note F#,4
	note G#,4
	note C#,5, 12
	note B_,4, 24
	note A#,4, 12
	note G#,4
	note A#,4, 24
	note G#,4, 12
	note F#,4, 6
	note G#,4, 3
	note F#,4
	note F_,4, 12
	note D#,4, 6
	silence
	note F_,4
	note F#,4
	silence
	note D#,4
	note F_,4
	note F#,4
	note A#,4, 18
	note G#,4
	note F#,4, 12
	note G#,4, 18
	note F#,4
	note F_,4, 12
	note D#,4, 18
	note F_,4, 3
	note D#,4
	note C#,4, 24
	note C#,5
	note B_,4
	note A#,4
	note G#,4, 12
	note B_,4, 24
	note A#,4, 12
	note G#,4
	note A#,4, 24
	note G#,4, 12
	note F#,4, 6
	note G#,4, 3
	note F#,4
	note F_,4, 12
	note F#,4, 24
	note F_,4
	note F#,4, 18
	note G#,4, 6
	silence 12
	note G#,4
	note F#,4, 24
	note F_,4
	note D#,4, 18
	note F_,4, 6
	silence 12
	note F_,4
	note C#,4, 48
	silence 12
	note A#,3
	note B_,3
	note C#,4
	continue 72
	note C#,4, 24
	note F#,4, 24
	note F_,4
	note F#,4, 18
	note G#,4, 6
	silence 12
	note G#,4
	note F#,4, 24
	note F_,4
	note D#,4, 18
	note F_,4, 6
	silence 12
	note F_,4
	note F_,4, 48
	silence 12
	note D#,4
	note F_,4
	note F#,4
	note G#,4
	note A#,4
	note B_,4
	note A#,4, 24
	note G#,4, 12
	note F#,4, 6
	note G#,4, 3
	note F#,4
	note F_,4, 12
	snd_ret
SndCall_BGM_03_Ch1_4:
	note A#,4, 6
	note A#,4
	note G#,4, 12
	note F#,4
	note D#,4
	note F#,4, 18
	note G#,4, 6
	envelope $11
	note G#,4, 18
	envelope $78
	note A#,3, 6
	note A#,4
	note A#,4
	note G#,4, 12
	note F#,4
	note D#,4
	note F#,4, 18
	note G#,4, 6
	envelope $11
	note G#,4, 24
	snd_ret
SndCall_BGM_03_Ch1_5:
	envelope $78
	note F#,4, 24
	note F_,4, 12
	note F#,4, 24
	note F_,4, 12
	note D#,4
	note F_,4
	note F_,4, 36
	note A#,4, 24
	note G#,4, 12
	note F#,4, 6
	note G#,4, 3
	note F#,4
	note F_,4, 12
	snd_ret
SndCall_BGM_03_Ch1_6:
	envelope $78
	note G#,4, 24
	note A#,4
	note B_,4, 18
	note A#,4, 6
	silence 12
	note A#,4
	note A#,4, 6
	note A#,4
	note G#,4, 12
	note A#,4
	note G#,4
	note F#,4, 18
	note G#,4
	note F#,4, 12
	note F_,4, 6
	note F#,4
	note F_,4, 12
	note D#,4, 72
	continue 96
	snd_ret
SndData_BGM_03_Ch2:
	envelope $11
	panning $22
	duty_cycle 2
	note A#,4, 96
	continue 24
	envelope $68
	note F_,4, 24
	note A#,4
	note C#,5, 18
	note D#,5, 6
SndData_BGM_03_Ch2_0:
	snd_call SndCall_BGM_03_Ch2_0
	snd_call SndCall_BGM_03_Ch2_1
	snd_call SndCall_BGM_03_Ch2_2
	snd_call SndCall_BGM_03_Ch2_3
	snd_call SndCall_BGM_03_Ch2_2
	snd_call SndCall_BGM_03_Ch2_4
	snd_call SndCall_BGM_03_Ch2_5_0
	snd_call SndCall_BGM_03_Ch2_5_0
	snd_call SndCall_BGM_03_Ch2_6
	snd_loop SndData_BGM_03_Ch2_0
SndCall_BGM_03_Ch2_0:
	duty_cycle 2
	envelope $68
	note D#,5, 24
	envelope $58
	note D#,5
	envelope $48
	note D#,5
	envelope $38
	note D#,5
	envelope $68
	note G#,5
	note F#,5
	note F_,5
	note C#,5
	note D#,5
	envelope $58
	note D#,5
	envelope $48
	note D#,5
	envelope $38
	note D#,5
	envelope $68
	note G#,5
	note F#,5
	note G#,5
	note A#,5
	snd_ret
SndCall_BGM_03_Ch2_1:
	envelope $11
	duty_cycle 2
	note A#,4, 24
	envelope $55
	note A#,4, 36
	note A#,4, 6
	silence
	note A#,4
	note A#,4
	note A#,4
	envelope $11
	note B_,4, 6
	continue 72
	envelope $55
	note A#,4, 6
	silence
	note B_,4
	envelope $11
	note G#,4, 24
	continue 6
	envelope $55
	note G#,4, 36
	note G#,4, 6
	silence
	note G#,4
	note G#,4
	note G#,4
	silence
	note A#,5, 24
	note G#,5
	note F#,5
	note F_,5
	envelope $11
	note A#,4, 24
	envelope $55
	note A#,4, 36
	note A#,4, 6
	silence
	note A#,4
	note A#,4
	note A#,4
	note D#,5
	silence
	note D#,5
	note C#,5
	note A#,4
	note D#,5
	note C#,5
	note A#,4
	note D#,5
	note C#,5
	note A#,4
	note D#,5
	note C#,5
	note C#,5, 12
	note D#,5
	envelope $11
	note G#,4, 24
	envelope $55
	note G#,4, 36
	note G#,4, 6
	silence
	note G#,4
	note G#,4
	note G#,4
	note D#,5
	silence
	note D#,5
	note C#,5
	note A#,4
	note D#,5
	note C#,5
	note A#,4
	note D#,5
	note C#,5
	note A#,4
	note D#,5
	note C#,5
	note A#,4, 12
	note C#,5
	snd_ret
SndCall_BGM_03_Ch2_2:
	envelope $57
	duty_cycle 2
	note A#,3, 6
	note A#,4
	note D#,5
	note F#,5
	note A#,5, 24
	duty_cycle 1
	note D#,5, 6
	silence
	note D#,5
	note D#,5
	envelope $11
	note D#,5, 24
	envelope $57
	duty_cycle 2
	note A#,3, 6
	note A#,4
	note D#,5
	note F#,5
	note G#,5, 24
	duty_cycle 1
	note D#,5, 6
	silence
	note D#,5
	note D#,5
	envelope $11
	note D#,5, 24
	envelope $57
	duty_cycle 2
	note C#,6, 24
	note B_,5
	note A#,5
	note G#,5
	snd_ret
SndCall_BGM_03_Ch2_3:
	note G#,5, 36
	note A#,5, 12
	duty_cycle 1
	silence 6
	note C#,5
	note D#,5
	note F_,5
	note D#,5
	note C#,5
	note B_,4
	note G#,4
	snd_ret
SndCall_BGM_03_Ch2_4:
	note B_,5, 24
	note A#,5
	note G#,4, 6
	note A#,4
	note C#,5
	note F_,5
	note G#,4, 4
	note A#,4
	note C#,5
	note F_,5
	note G#,5
	note A#,5
	snd_ret
SndCall_BGM_03_Ch2_5_0:
	envelope $56
	note D#,5, 6
	note D#,5
	note C#,5
	note A#,4
	note C#,5
	note D#,5
	silence
	note D#,5
	note C#,5
	note A#,4
	note C#,5
	note D#,5
	silence
	note D#,5, 12
	silence 6
	snd_loop SndCall_BGM_03_Ch2_5_0, $00, 2
	envelope $11
	note G#,4, 12
	envelope $56
	note G#,4, 6
	note A#,4
	note C#,5
	note F_,5, 12
	silence 6
	note A#,4
	note C#,5
	note F_,5
	note G#,5
	silence
	note G#,5, 12
	envelope $11
	note G#,4, 18
	envelope $56
	note G#,4, 6
	note A#,4
	note C#,5
	note F_,5, 12
	silence 6
	note A#,4
	note C#,5
	note F_,5
	note G#,5, 12
	note F#,5, 6
	note F_,5
	note D#,5
	snd_ret
SndCall_BGM_03_Ch2_6:
	envelope $58
	note A#,4, 96
	note C#,3, 6
	note D#,3
	note F#,3
	note A#,3
	note C#,4
	note D#,4
	note F#,4
	note A#,4
	note C#,5, 6
	note D#,5
	note F#,5
	note A#,5
	note C#,6
	note D#,6
	note F#,6
	note A#,6
	snd_ret
SndData_BGM_03_Ch3:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 25
	note A#,2, 12
	note A#,2
	note A#,2
	note A#,2
	note A#,2, 6
	note A#,3
	note A#,2, 12
	note A#,2
	note A#,2
	note A#,2
	note A#,2
	note A#,2
	note A#,2
	note A#,2, 6
	note A#,3
	note A#,2, 12
	note A#,2, 6
	note A#,3
	note A#,2, 12
SndData_BGM_03_Ch3_0:
	snd_call SndCall_BGM_03_Ch3_0
	snd_call SndCall_BGM_03_Ch3_1
	snd_call SndCall_BGM_03_Ch3_2
	snd_call SndCall_BGM_03_Ch3_1
	snd_call SndCall_BGM_03_Ch3_3
	snd_call SndCall_BGM_03_Ch3_4
	snd_call SndCall_BGM_03_Ch3_5
	snd_call SndCall_BGM_03_Ch3_6
	snd_call SndCall_BGM_03_Ch3_5
	snd_call SndCall_BGM_03_Ch3_7
	snd_loop SndData_BGM_03_Ch3_0
SndCall_BGM_03_Ch3_0:
	note D#,3, 12
	note D#,3
	note D#,3
	note D#,3
	note D#,3, 6
	note D#,3
	note D#,3, 12
	note D#,3
	note D#,3
	note B_,2
	note B_,2
	note B_,2
	note B_,2
	note C#,3, 6
	note C#,4
	note C#,3, 12
	note C#,3, 6
	note C#,4
	note C#,3, 12
	note D#,3
	note D#,3
	note D#,3
	note D#,3
	note D#,3, 6
	note D#,3
	note D#,3, 12
	note D#,3
	note D#,3
	note B_,2
	note B_,2
	note B_,2
	note B_,2
	note C#,3, 6
	note C#,4
	note C#,3
	note C#,3
	note C#,4, 12
	note C#,3
	snd_ret
SndCall_BGM_03_Ch3_1:
	note D#,3, 12
	note D#,3
	note D#,3
	note D#,3
	note D#,3, 6
	note D#,3
	note D#,3, 12
	note D#,3
	note D#,3
	note B_,2
	note B_,2
	note B_,2
	note B_,2
	note B_,2, 6
	note A#,3
	note B_,2, 12
	note B_,2, 6
	note A#,3
	note B_,2, 12
	note C#,3
	note C#,3
	note C#,3
	note C#,3
	note C#,3, 6
	note C#,3
	note C#,3, 12
	note C#,3
	note C#,3
	snd_ret
SndCall_BGM_03_Ch3_2:
	note F#,2, 12
	note F#,2
	note F#,2
	note F#,2
	note A#,2, 6
	note A#,3
	note A#,2
	note A#,2
	note A#,3, 12
	note G#,3
	snd_ret
SndCall_BGM_03_Ch3_3:
	note A#,2, 12
	note A#,2
	note A#,2
	note A#,2
	note A#,2, 6
	note A#,3
	note A#,2
	note A#,2
	note A#,3, 12
	note A#,2
	snd_ret
SndCall_BGM_03_Ch3_4:
	note B_,2, 12
	note B_,3
	note B_,2
	note B_,3
	note B_,2
	note B_,3
	note B_,2
	note B_,3
	note G#,2
	note G#,3
	note G#,2
	note G#,3
	note G#,2
	note G#,3
	note G#,2
	note G#,3
	note A#,2
	note A#,3
	note A#,2
	note A#,3
	note A#,2
	note A#,3
	note A#,2
	note A#,3
	note F#,2
	note F#,3
	note F#,2
	note F#,3
	note F#,2, 6
	note F#,3
	note F#,2, 18
	note F#,3, 6
	note F#,3, 12
	note B_,2
	note B_,3
	note B_,2
	note B_,3
	note B_,2, 6
	note B_,2
	note B_,3, 12
	note B_,2
	note B_,3
	note G#,2
	note G#,3
	note G#,2
	note G#,3
	note G#,2, 6
	note G#,2
	note G#,3, 12
	note G#,2
	note G#,3
	note A#,2
	note A#,3
	note A#,2
	note A#,3
	note A#,2
	note A#,3
	note A#,2
	note A#,3
	note A#,2
	note A#,3
	note A#,2
	note A#,3
	note A#,2
	note A#,3, 6
	note A#,3
	note A#,2
	note A#,3
	note A#,2
	note A#,3
	snd_ret
SndCall_BGM_03_Ch3_5:
	note D#,3, 12
	note D#,3
	note D#,3
	note D#,3
	note D#,3, 6
	note D#,3
	note D#,3, 12
	note D#,3
	note D#,3
	note B_,2
	note B_,2
	note B_,2
	note B_,2
	note B_,2, 6
	note B_,2
	note B_,2, 12
	note B_,2
	note B_,2
	note G#,2
	note G#,2
	note G#,2
	note G#,2
	note G#,2, 6
	note G#,2
	note G#,2, 12
	note G#,2
	note G#,2
	snd_ret
SndCall_BGM_03_Ch3_6:
	note A#,2, 12
	note A#,2
	note A#,2
	note A#,2
	note A#,2, 6
	note A#,3
	note A#,2
	note A#,2
	note A#,3, 12
	note G#,3
	snd_ret
SndCall_BGM_03_Ch3_7:
	note A#,2, 12
	note A#,2
	note A#,2
	note A#,2
	note A#,2, 6
	note A#,3
	note A#,2
	note A#,2
	note A#,3
	note A#,3, 12
	note A#,2, 6
	note D#,3, 12
	note D#,3
	note D#,3
	note D#,3
	note D#,3, 6
	note D#,3
	note D#,3, 12
	note D#,3
	note D#,3
	note D#,3
	note D#,3
	note D#,3
	note D#,3
	note D#,3, 6
	note D#,2
	note D#,3, 12
	note D#,2, 6
	note D#,3
	note D#,3
	note D#,2
	snd_ret
SndData_BGM_03_Ch4:
	panning $88
	snd_call SndCall_BGM_03_Ch4_0
SndData_BGM_03_Ch4_0:
	snd_call SndCall_BGM_03_Ch4_1_0
	snd_call SndCall_BGM_03_Ch4_2_0
	snd_call SndCall_BGM_03_Ch4_3_0
	snd_call SndCall_BGM_03_Ch4_4
	snd_call SndCall_BGM_03_Ch4_3_0
	snd_call SndCall_BGM_03_Ch4_5
	snd_call SndCall_BGM_03_Ch4_6_0
	snd_loop SndData_BGM_03_Ch4_0
SndCall_BGM_03_Ch4_0:
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 12 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 12 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 12
	envelope $53
	note4x $11, 12 ; Nearest: A#,6,0
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 12 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 12 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 12
	envelope $54
	note4x $22, 12 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 6
	note4 A_,5,0, 6
	envelope $72
	note4x $22, 12 ; Nearest: A_,5,0
	snd_ret
SndCall_BGM_03_Ch4_1_0:
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	snd_loop SndCall_BGM_03_Ch4_1_0, $00, 23
	envelope $61
	note4 F_,5,0, 6
	envelope $54
	note4x $22, 6 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	snd_ret
SndCall_BGM_03_Ch4_2_0:
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	snd_loop SndCall_BGM_03_Ch4_2_0, $00, 15
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	snd_ret
SndCall_BGM_03_Ch4_3_0:
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	snd_loop SndCall_BGM_03_Ch4_3_0, $00, 7
	snd_ret
SndCall_BGM_03_Ch4_4:
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	snd_ret
SndCall_BGM_03_Ch4_5:
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	snd_ret
SndCall_BGM_03_Ch4_6_0:
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	snd_loop SndCall_BGM_03_Ch4_6_0, $00, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	snd_ret
