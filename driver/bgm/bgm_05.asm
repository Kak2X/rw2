SndHeader_BGM_05:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_05_Ch1 ; Data ptr
	db 2 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_05_Ch2 ; Data ptr
	db 2 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_05_Ch3 ; Data ptr
	db 2 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_05_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_BGM_05_Ch1:
	envelope $A8
	panning $11
	duty_cycle 3
	vibrato_on $01
	silence 28
.loop0:
	snd_call SndCall_BGM_05_Ch1_0
	duty_cycle 2
	note A#,4, 14
	note C_,5
	snd_call SndCall_BGM_05_Ch1_1
	duty_cycle 2
	note A#,4, 14
	note C_,5
	snd_call SndCall_BGM_05_Ch1_1
	note G#,4, 14
	note G#,4
	silence 28
	snd_call SndCall_BGM_05_Ch1_0
	silence 3
	envelope $88
	note C#,5, 4
	envelope $A8
	note C#,5, 7
	note C#,5
	silence 3
	envelope $88
	note C#,5, 4
	envelope $88
	note C#,5, 7
	silence 3
	envelope $68
	note C#,5, 4
	snd_call SndCall_BGM_05_Ch1_2
	note A#,4, 56
	continue 14
	envelope $88
	note A#,4, 7
	silence 3
	envelope $68
	note A#,4, 4
	duty_cycle 3
	snd_call SndCall_BGM_05_Ch1_3
	envelope $98
	note D#,4, 7
	silence 3
	envelope $78
	note D#,4, 4
	envelope $98
	note A#,4, 7
	note D#,4
	note A#,3, 14
	note C_,4
	note C#,4
	envelope $78
	note C#,4, 7
	silence 3
	envelope $58
	note C#,4, 4
	snd_call SndCall_BGM_05_Ch1_2
	note G_,4, 56
	continue 14
	envelope $88
	note G_,4, 7
	silence 3
	envelope $68
	note G_,4, 4
	duty_cycle 3
	envelope $98
	note A#,4, 7
	note G#,4
	note G_,4
	note D#,4
	note A#,3
	note D#,4
	note A#,3, 14
	note C#,4, 25
	envelope $78
	note C#,4, 3
	envelope $98
	note F_,4, 14
	envelope $78
	note F_,4, 7
	silence 3
	envelope $58
	note F_,4, 4
	envelope $98
	note G#,4, 14
	envelope $78
	note G#,4, 7
	silence 3
	envelope $58
	note G#,4, 4
	envelope $98
	note A#,4, 14
	envelope $78
	note A#,4, 7
	silence 3
	envelope $58
	note A#,4, 4
	duty_cycle 2
	envelope $A8
	note F_,4, 7
	silence 3
	envelope $88
	note F_,4, 4
	envelope $A8
	note G_,4, 14
	note G#,4
	note C_,5
	note F_,4
	envelope $88
	note F_,4, 7
	silence 3
	envelope $68
	note F_,4, 4
	envelope $A8
	note C#,5, 28
	note C_,5, 14
	note A#,4
	note C_,5, 28
	note A#,4, 14
	note G#,4
	note G_,4, 56
	continue 14
	envelope $88
	note G_,4, 7
	silence 3
	envelope $68
	note G_,4, 4
	duty_cycle 3
	snd_call SndCall_BGM_05_Ch1_3
	envelope $98
	note D#,4, 7
	silence 3
	envelope $78
	note D#,4, 4
	envelope $98
	note C#,4, 14
	note F_,4
	note G#,4
	note B_,4
	envelope $A8
	note G_,5, 7
	silence 3
	envelope $88
	note G_,5, 7
	silence 4
	envelope $68
	note G_,5, 7
	snd_loop .loop0
SndCall_BGM_05_Ch1_0:
	envelope $A8
	note D#,4, 11
	envelope $88
	note D#,4, 7
	silence 3
	envelope $68
	note D#,4, 7
	envelope $A8
	note G#,3, 56
	note C_,4, 28
	envelope $88
	note C_,4, 7
	silence 3
	envelope $68
	note C_,4, 4
	envelope $A8
	note C#,4, 28
	note A#,4, 7
	note C_,5
	note D#,5
	note F_,5
	note D#,5
	note C_,5
	note G_,5, 7
	silence 3
	envelope $88
	note G_,5, 7
	silence 4
	envelope $68
	note G_,5, 7
	envelope $A8
	note D#,4, 11
	silence 3
	envelope $88
	note D#,4, 7
	silence 3
	envelope $68
	note D#,4, 4
	envelope $A8
	note G#,3, 56
	note C_,4, 28
	envelope $88
	note C_,4, 7
	silence 3
	envelope $68
	note C_,4, 4
	envelope $A8
	note G#,3, 28
	note C#,5, 5
	silence 2
	note C#,5, 7
	snd_ret
SndCall_BGM_05_Ch1_1:
	envelope $A8
	note D#,5, 14
	envelope $88
	note D#,5, 7
	silence 3
	envelope $68
	note D#,5, 7
	silence 4
	envelope $48
	note D#,5, 7
	silence 3
	envelope $38
	note D#,5, 7
	silence 4
	envelope $A8
	note A#,4, 21
	note D#,5, 7
	envelope $88
	note D#,5, 7
	silence 3
	envelope $68
	note D#,5, 4
	envelope $A8
	note F_,5, 26
	silence 2
	note F_,5, 14
	envelope $88
	note F_,5, 7
	silence 3
	envelope $68
	note F_,5, 4
	duty_cycle 3
	envelope $88
	note C#,4, 28
	note C#,4, 7
	silence 3
	envelope $68
	note C#,4, 4
	duty_cycle 2
	envelope $A8
	note D#,5, 14
	note F_,5
	note G#,5
	note G_,5
	note D#,5, 56
	continue 14
	envelope $88
	note D#,5, 7
	silence 3
	envelope $68
	note D#,5, 4
	duty_cycle 3
	envelope $88
	note D#,4, 14
	note C_,4
	note C_,5
	note G#,4, 28
	note G#,4, 7
	silence
	snd_ret
SndCall_BGM_05_Ch1_2:
	duty_cycle 2
	envelope $A8
	note G#,4, 7
	silence 3
	envelope $88
	note G#,4, 4
	envelope $A8
	note G#,4, 14
	note G_,4
	note G#,4
	note G#,4
	envelope $88
	note G#,4, 7
	silence 3
	envelope $68
	note G#,4, 4
	envelope $A8
	note G#,4, 28
	note G_,4, 14
	note G#,4
	note C_,5, 28
	note A#,4, 14
	note G#,4
	snd_ret
SndCall_BGM_05_Ch1_3:
	envelope $98
	note D#,4, 7
	silence 3
	envelope $78
	note D#,4, 4
	envelope $98
	note A#,4, 7
	note D#,4
	envelope $78
	note D#,4, 7
	silence 3
	envelope $58
	note D#,4, 4
	snd_loop SndCall_BGM_05_Ch1_3, $00, 2
	snd_ret
SndData_BGM_05_Ch2:
	envelope $A8
	panning $22
	duty_cycle 1
	vibrato_on $01
	snd_call SndCall_BGM_05_Ch2_0
	snd_call SndCall_BGM_05_Ch2_1
	snd_call SndCall_BGM_05_Ch2_0
	snd_call SndCall_BGM_05_Ch2_2
	snd_call SndCall_BGM_05_Ch2_4
	snd_call SndCall_BGM_05_Ch2_2
	snd_call SndCall_BGM_05_Ch2_4
	snd_call SndCall_BGM_05_Ch2_2
	envelope $72
	note G_,5, 3
	envelope $52
	note C#,5, 4
	snd_call SndCall_BGM_05_Ch2_6
.loop0:
	envelope $72
	note G_,5, 3
	envelope $52
	note A#,4, 4
	snd_call SndCall_BGM_05_Ch2_6
	snd_loop .loop0, $00, 3
	envelope $72
	note G#,5, 3
	envelope $52
	note A#,4, 4
	envelope $72
	note F_,5, 3
	envelope $52
	note G#,5, 4
	envelope $72
	note C#,5, 3
	envelope $52
	note F_,5, 4
	envelope $72
	note F_,5, 3
	envelope $52
	note C#,5, 4
	envelope $72
	note G#,5, 3
	envelope $52
	note F_,5, 4
	envelope $72
	note B_,5, 3
	envelope $52
	note G#,5, 4
	envelope $72
	note C#,6, 3
	envelope $52
	note B_,5, 4
	envelope $72
	note F_,6, 3
	envelope $52
	note C#,6, 4
	snd_loop SndData_BGM_05_Ch2
SndCall_BGM_05_Ch2_0:
	silence 28
	note G_,3, 11
	silence 17
	note F_,3, 56
	note D#,3, 28
	silence 14
	note G#,3, 28
	note G_,4, 7
	note G#,4
	note A#,4
	note C_,5
	note A#,4
	note G#,4
	note A#,4
	silence 21
	note G_,3, 11
	silence 17
	note F_,3, 56
	note D#,3, 28
	silence 14
	note F_,3, 28
	note G#,4, 7
	note G#,4
	silence
	note G_,4
	note G#,4
	silence
	snd_ret
SndCall_BGM_05_Ch2_1:
	note A#,4, 7
	silence 3
	envelope $A8
	note A#,4, 7
	silence 11
	envelope $A8
	note D#,4, 7
	silence 3
	envelope $88
	note D#,4, 4
	envelope $A8
	note G_,4, 7
	silence 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note D#,4, 7
	silence 3
	envelope $88
	note D#,4, 4
	envelope $A8
	note A#,3, 7
	silence 3
	envelope $88
	note A#,3, 4
	envelope $A8
	note G_,4, 7
	silence 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note D#,4, 7
	silence 3
	envelope $88
	note D#,4, 4
	envelope $A8
	note A#,3, 7
	silence 3
	envelope $88
	note A#,3, 4
	envelope $A8
	note F_,4, 7
	silence 3
	envelope $88
	note F_,4, 4
	envelope $A8
	note D_,4, 7
	silence 3
	envelope $88
	note D_,4, 4
	envelope $A8
	note G#,3, 28
	note G#,3, 7
	silence 3
	envelope $88
	note G#,3, 7
	silence 25
	silence 14
	envelope $A8
	note D#,4, 7
	silence 3
	envelope $88
	note D#,4, 4
	envelope $A8
	note C_,5, 7
	silence 3
	envelope $88
	note C_,5, 4
	envelope $A8
	note G#,4, 7
	silence 3
	envelope $88
	note G#,4, 4
	envelope $A8
	note D#,4, 7
	silence 3
	envelope $88
	note D#,4, 4
	envelope $A8
	note C_,4, 7
	silence 3
	envelope $88
	note C_,4, 4
	envelope $A8
	note G#,3, 7
	silence 3
	envelope $88
	note G#,3, 4
	envelope $A8
	note D#,4, 7
	silence 3
	envelope $88
	note D#,4, 4
	envelope $A8
	note C_,4, 7
	silence 3
	envelope $88
	note C_,4, 4
	envelope $A8
	note G#,3, 7
	silence 3
	envelope $88
	note G#,3, 4
	envelope $A8
	note G#,4, 7
	silence 3
	envelope $88
	note G#,4, 4
	envelope $A8
	note F_,4, 28
	note F_,4, 7
	silence 3
	envelope $88
	note F_,4, 4
	envelope $A8
	note D#,4, 7
	silence 3
	envelope $88
	note D#,4, 4
	envelope $A8
	note F_,4, 7
	silence 3
	envelope $88
	note F_,4, 4
	snd_loop SndCall_BGM_05_Ch2_1, $00, 2
	snd_ret
SndCall_BGM_05_Ch2_2:
	envelope $72
	note C_,6, 3
	envelope $52
	note G_,5, 4
	snd_call SndCall_BGM_05_Ch2_3
.loop0:
	envelope $72
	note C_,6, 3
	envelope $52
	note D#,5, 4
	snd_call SndCall_BGM_05_Ch2_3
	snd_loop .loop0, $00, 3
	envelope $72
	note C_,6, 3
	envelope $52
	note D#,5, 4
	envelope $72
	note F_,5, 3
	envelope $52
	note C_,6, 4
	envelope $72
	note D#,5, 3
	envelope $52
	note F_,5, 4
	envelope $72
	note F_,5, 3
	envelope $52
	note D#,5, 4
	envelope $72
	note C_,6, 3
	envelope $52
	note F_,5, 4
	envelope $72
	note G#,5, 3
	envelope $52
	note C_,6, 4
	envelope $72
	note F_,5, 3
	envelope $52
	note G#,5, 4
	envelope $72
	note C#,5, 3
	envelope $52
	note F_,5, 4
	snd_ret
SndCall_BGM_05_Ch2_3:
	envelope $72
	note F_,5, 3
	envelope $52
	note C_,6, 4
	envelope $72
	note D#,5, 3
	envelope $52
	note F_,5, 4
	envelope $72
	note F_,5, 3
	envelope $52
	note D#,5, 4
	envelope $72
	note C_,6, 3
	envelope $52
	note F_,5, 4
	envelope $72
	note D#,5, 3
	envelope $52
	note C_,6, 4
	snd_ret
SndCall_BGM_05_Ch2_4:
	envelope $72
	note G_,5, 3
	envelope $52
	note C#,5, 4
	snd_call SndCall_BGM_05_Ch2_5
.loop0:
	envelope $72
	note G_,5, 3
	envelope $52
	note C_,5, 4
	snd_call SndCall_BGM_05_Ch2_5
	snd_loop .loop0, $00, 3
	envelope $72
	note G_,5, 3
	envelope $52
	note C_,5, 4
	envelope $72
	note C#,5, 3
	envelope $52
	note G_,5, 4
	envelope $72
	note C_,5, 3
	envelope $52
	note C#,5, 4
	envelope $72
	note C#,5, 3
	envelope $52
	note C_,5, 4
	envelope $72
	note G_,5, 3
	envelope $52
	note C#,5, 4
	envelope $72
	note D#,5, 3
	envelope $52
	note G_,5, 4
	envelope $72
	note A#,4, 3
	envelope $52
	note D#,5, 4
	envelope $72
	note G_,5, 3
	envelope $52
	note A#,4, 4
	snd_ret
SndCall_BGM_05_Ch2_5:
	envelope $72
	note C#,5, 3
	envelope $52
	note G_,5, 4
	envelope $72
	note C_,5, 3
	envelope $52
	note C#,5, 4
	envelope $72
	note C#,5, 3
	envelope $52
	note C_,5, 4
	envelope $72
	note G_,5, 3
	envelope $52
	note C#,5, 4
	envelope $72
	note C_,5, 3
	envelope $52
	note G_,5, 4
	snd_ret
SndCall_BGM_05_Ch2_6:
	envelope $72
	note D#,5, 3
	envelope $52
	note G_,5, 4
	envelope $72
	note A#,4, 3
	envelope $52
	note D#,5, 4
	envelope $72
	note D#,5, 3
	envelope $52
	note A#,4, 4
	envelope $72
	note G_,5, 3
	envelope $52
	note D#,5, 4
	envelope $72
	note A#,4, 3
	envelope $52
	note G_,5, 4
	snd_ret
SndData_BGM_05_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	wave_cutoff 0
	snd_call SndCall_BGM_05_Ch3_0
	silence 28
	snd_call SndCall_BGM_05_Ch3_1
	snd_call SndCall_BGM_05_Ch3_0
	note A#,3, 28
	snd_call SndCall_BGM_05_Ch3_2
	note D#,4, 7
	silence
	note A#,3
	silence
	note G_,3
	silence
	note D#,3
	silence
	snd_call SndCall_BGM_05_Ch3_2
	note D#,4, 7
	silence
	note A#,3
	silence
	note G_,3
	silence
	note D#,3
	silence
	snd_call SndCall_BGM_05_Ch3_2
	note F_,3, 7
	silence
	note G#,3
	silence
	note C_,4
	silence
	note C#,4
	silence
	snd_loop SndData_BGM_05_Ch3
SndCall_BGM_05_Ch3_0:
	note D#,4, 14
	silence
	note A#,3
	note C_,4
	note C#,4, 21
	note D#,4, 7
	silence 28
	note G#,3, 7
	silence
	note A#,3
	silence
	note C_,4, 14
	note F_,3, 42
	silence 14
	note C_,4, 7
	note C#,4
	note D#,4, 14
	silence
	note A#,3
	note C_,4
	note C#,4, 21
	note D#,4, 7
	silence 28
	note G#,3, 7
	silence
	note A#,3
	silence
	note C_,4, 14
	note C#,4, 42
	snd_ret
SndCall_BGM_05_Ch3_1:
	note D#,4, 14
	silence
	note A#,3
	note G_,3
	note D#,4, 21
	note D#,4, 7
	silence 28
	note F_,3, 7
	silence
	note A#,3
	silence
	note D_,4, 14
	note F_,3, 42
	silence 14
	note G#,3, 7
	note C#,4
	note D#,4, 14
	silence
	note G#,3
	note C_,4
	note D#,4, 21
	note D#,4, 7
	silence 28
	note G#,3, 7
	silence
	note C_,4
	silence
	note D#,4, 14
	note C#,4, 42
	note A#,3, 28
	snd_loop SndCall_BGM_05_Ch3_1, $00, 2
	snd_ret
SndCall_BGM_05_Ch3_2:
	note C#,4, 7
	silence
	note C#,4
	silence
	note G#,3
	silence
	note C#,4, 21
	silence 7
	note C#,4
	silence
	note F_,3
	silence
	note C#,4
	silence
	note C#,4
	silence
	note C#,4
	silence
	note G#,3
	silence
	note F_,3
	silence
	note C#,4
	silence
	note C#,4
	silence
	note C#,4
	silence
	note C#,4
	silence
	note D#,4, 7
	silence
	note D#,4
	silence
	note A#,3
	silence
	note D#,4, 21
	silence 7
	note D#,4
	silence
	note G_,3
	silence
	note D#,4
	silence
	note D#,4
	silence
	note D#,4
	silence
	note A#,3
	silence
	note G_,3
	silence
	snd_ret
SndData_BGM_05_Ch4:
	panning $88
	snd_call SndCall_BGM_05_Ch4_0
	envelope $C1
	note4 G#,4,0, 14
	envelope $A1
	note4 A_,5,0, 14
	note4 A_,5,0, 14
	envelope $C1
	note4 G#,4,0, 7
	note4 G#,4,0, 7
	envelope $A1
	note4 A_,5,0, 14
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	envelope $C1
	note4 G#,4,0, 7
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 14
	snd_call SndCall_BGM_05_Ch4_0
	snd_call SndCall_BGM_05_Ch4_2
	snd_call SndCall_BGM_05_Ch4_0
	envelope $C1
	note4 G#,4,0, 14
	envelope $A1
	note4 A_,5,0, 14
	note4 A_,5,0, 7
	envelope $C1
	note4 G#,4,0, 7
	envelope $53
	note4x $13, 14 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	envelope $91
	note4 G_,5,0, 14
	envelope $91
	note4 F#,5,0, 7
	note4 F#,5,0, 7
	envelope $91
	note4 E_,5,0, 7
	note4 E_,5,0, 7
	snd_call SndCall_BGM_05_Ch4_0
	snd_call SndCall_BGM_05_Ch4_2
	snd_call SndCall_BGM_05_Ch4_3
	snd_call SndCall_BGM_05_Ch4_4
	snd_call SndCall_BGM_05_Ch4_3
	snd_call SndCall_BGM_05_Ch4_5
	snd_call SndCall_BGM_05_Ch4_3
	snd_call SndCall_BGM_05_Ch4_4
	snd_call SndCall_BGM_05_Ch4_3
	snd_call SndCall_BGM_05_Ch4_5
	snd_call SndCall_BGM_05_Ch4_3
	snd_call SndCall_BGM_05_Ch4_4
.loop0:
	envelope $C1
	note4 G#,4,0, 14
	envelope $53
	note4x $13, 14 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 14
	envelope $53
	note4x $13, 14 ; Nearest: G#,6,0
	snd_loop .loop0, $00, 2
	envelope $C1
	note4 G#,4,0, 14
	envelope $53
	note4x $13, 14 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	envelope $91
	note4 F#,5,0, 14
	envelope $91
	note4 E_,5,0, 14
	envelope $C1
	note4 G#,4,0, 7
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 14
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	snd_loop SndData_BGM_05_Ch4
SndCall_BGM_05_Ch4_0:
	snd_call SndCall_BGM_05_Ch4_1
	envelope $C1
	note4 G#,4,0, 14
	note4 G#,4,0, 14
	envelope $A1
	note4 A_,5,0, 14
	envelope $51
	note4 C_,6,0, 14
	envelope $53
	note4x $13, 14 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 14
	envelope $A1
	note4 A_,5,0, 7
	envelope $C1
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $A1
	note4 A_,5,0, 7
	snd_call SndCall_BGM_05_Ch4_1
	snd_ret
SndCall_BGM_05_Ch4_1:
	envelope $C1
	note4 G#,4,0, 14
	envelope $51
	note4 C_,6,0, 14
	envelope $A1
	note4 A_,5,0, 14
	envelope $C1
	note4 G#,4,0, 14
	note4 G#,4,0, 14
	envelope $51
	note4 C_,6,0, 7
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 14
	envelope $53
	note4x $13, 14 ; Nearest: G#,6,0
	snd_ret
SndCall_BGM_05_Ch4_2:
	envelope $C1
	note4 G#,4,0, 14
	note4 G#,4,0, 14
	envelope $A1
	note4 A_,5,0, 14
	envelope $53
	note4x $13, 14 ; Nearest: G#,6,0
	envelope $51
	note4 C_,6,0, 14
	envelope $C1
	note4 G#,4,0, 14
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $91
	note4 F#,5,0, 7
	snd_ret
SndCall_BGM_05_Ch4_3:
	envelope $C1
	note4 G#,4,0, 14
	envelope $53
	note4x $13, 14 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 14
	envelope $53
	note4x $13, 14 ; Nearest: G#,6,0
	snd_loop SndCall_BGM_05_Ch4_3, $00, 3
	snd_ret
SndCall_BGM_05_Ch4_4:
	envelope $C1
	note4 G#,4,0, 14
	envelope $53
	note4x $13, 14 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 14
	envelope $C1
	note4 G#,4,0, 7
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	snd_ret
SndCall_BGM_05_Ch4_5:
	envelope $C1
	note4 G#,4,0, 14
	envelope $53
	note4x $13, 14 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 14
	note4 A_,5,0, 7
	envelope $C1
	note4 G#,4,0, 7
	snd_ret
