SndHeader_BGM_07:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_07_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_07_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_07_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_07_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_BGM_07_Ch1:
	envelope $A8
	panning $11
	duty_cycle 2
	vibrato_on $01
	note F#,3, 4
	note G_,3
	note G#,3
	note A_,3
	note A#,3
	note B_,3
	note C_,4, 12
	envelope $88
	note C_,4, 6
	silence 3
	envelope $68
	note C_,4
	envelope $48
	note C_,4, 6
	silence 3
	envelope $38
	note C_,4
	silence 48
	continue 12
	continue 96
	snd_call SndCall_BGM_07_Ch1_0
	snd_call SndCall_BGM_07_Ch1_1
	snd_call SndCall_BGM_07_Ch1_0
	fine_tune 1
	snd_call SndCall_BGM_07_Ch1_1
	fine_tune -1
	snd_call SndCall_BGM_07_Ch1_2
	note C_,5, 24
	envelope $88
	note C_,5, 6
	silence 3
	envelope $68
	note C_,5
	envelope $48
	note C_,5, 6
	silence 3
	envelope $38
	note C_,5
	silence 48
	continue 96
	snd_call SndCall_BGM_07_Ch1_0
	snd_call SndCall_BGM_07_Ch1_1
	snd_call SndCall_BGM_07_Ch1_0
	fine_tune 1
	snd_call SndCall_BGM_07_Ch1_1
	fine_tune -1
	snd_call SndCall_BGM_07_Ch1_2
	note E_,4, 12
	note A#,3
	note E_,4
	note F#,4
	note C#,4
	note F#,4
	note G#,4
	note D#,4
	note G#,4
	note A#,4
	note E_,4
	note A#,4
	note C#,5
	note G#,4
	note C#,5
	note D#,5
	note A#,4
	note D#,5
	note F_,5
	note C_,5
	note F_,5
	note G_,5
	note D_,5
	note G_,5
	note G#,5, 10
	silence 2
	note G#,5, 12
	envelope $88
	note G#,5, 6
	silence 3
	envelope $68
	note G#,5
	envelope $A8
	note G#,5, 10
	silence 2
	note G#,5, 12
	envelope $88
	note G#,5, 6
	silence 3
	envelope $68
	note G#,5
	envelope $A8
	note G#,5, 10
	silence 2
	note G#,5, 12
	envelope $88
	note G#,5, 6
	silence 3
	envelope $68
	note G#,5
	envelope $A8
	note F#,5, 6
	silence 3
	envelope $88
	note F#,5
	envelope $A8
	note E_,5, 12
	note D_,5
	note C_,5
	note A#,4
	snd_loop SndData_BGM_07_Ch1
SndCall_BGM_07_Ch1_0:
	envelope $A8
	note B_,4, 6
	silence 3
	envelope $88
	note B_,4
	envelope $A8
	note B_,4, 6
	note A#,4
	note G_,4, 12
	note A_,4
	note G#,4
	note F_,4
	envelope $88
	note F_,4, 6
	silence 3
	envelope $68
	note F_,4
	envelope $48
	note F_,4, 6
	silence 3
	envelope $38
	note F_,4
	envelope $A8
	note G_,4, 6
	silence 3
	envelope $88
	note G_,4
	envelope $A8
	note G_,4, 6
	note F#,4
	note D_,4, 12
	note F_,4
	note E_,4
	note C#,4
	note D#,4
	note C_,4
	snd_ret
SndCall_BGM_07_Ch1_1:
	envelope $A8
	note A#,4, 12
	note G_,4, 6
	silence 3
	envelope $88
	note G_,4
	envelope $A8
	note G_,4, 6
	silence 3
	envelope $88
	note G_,4
	envelope $A8
	note A#,4, 12
	note G_,4, 6
	silence 3
	envelope $88
	note G_,4
	envelope $A8
	note G_,4, 6
	silence 3
	envelope $88
	note G_,4
	envelope $A8
	note A#,4, 12
	note G_,4, 6
	silence 3
	envelope $88
	note G_,4
	snd_loop SndCall_BGM_07_Ch1_1, $00, 2
	snd_ret
SndCall_BGM_07_Ch1_2:
	envelope $A8
	note C_,5, 12
	note A_,4
	note G#,4
	note C_,5
	note A_,4
	note G#,4
	note C_,5
	note G#,4
	note B_,4
	note G#,4
	note G_,4
	note B_,4
	note G#,4
	note G_,4
	note B_,4
	note G_,4
	note C_,5
	note A_,4
	note G#,4
	note C_,5
	note A_,4
	note G#,4
	note C_,5
	note G#,4
	note B_,4
	note G#,4
	note G_,4
	note B_,4
	note G#,4
	note A_,4
	note A#,4
	note B_,4
	snd_ret
SndData_BGM_07_Ch2:
	envelope $A8
	panning $22
	duty_cycle 1
	note C#,3, 4
	note D_,3
	note D#,3
	note E_,3
	note F_,3
	note F#,3
	silence 12
	snd_call SndCall_BGM_07_Ch2_0
	snd_call SndCall_BGM_07_Ch2_1
	snd_call SndCall_BGM_07_Ch2_2
	snd_call SndCall_BGM_07_Ch2_2
	silence 6
	envelope $68
	note D_,4, 3
	silence
	snd_call SndCall_BGM_07_Ch2_1
	snd_call SndCall_BGM_07_Ch2_3
	snd_call SndCall_BGM_07_Ch2_3
	snd_call SndCall_BGM_07_Ch2_4
	fine_tune -1
	snd_call SndCall_BGM_07_Ch2_4
	fine_tune 1
	snd_call SndCall_BGM_07_Ch2_4
	snd_call SndCall_BGM_07_Ch2_5
	silence 6
	envelope $68
	note G_,4, 3
	silence
	snd_call SndCall_BGM_07_Ch2_0
	snd_call SndCall_BGM_07_Ch2_1
	snd_call SndCall_BGM_07_Ch2_6
	snd_call SndCall_BGM_07_Ch2_6
	silence 6
	envelope $38
	note A#,5, 3
	silence
	snd_call SndCall_BGM_07_Ch2_1
	snd_call SndCall_BGM_07_Ch2_6
	envelope $88
	note A#,6, 6
	note C_,6
	note D_,6
	note E_,6
	note F#,6
	note D_,6
	note E_,6
	note F#,6
	note G#,6
	note A#,6
	note F#,6
	note G#,6
	note A#,6
	note C_,7
	note D_,7
	note E_,7
	snd_call SndCall_BGM_07_Ch2_4
	fine_tune -1
	snd_call SndCall_BGM_07_Ch2_4
	fine_tune 1
	snd_call SndCall_BGM_07_Ch2_4
	snd_call SndCall_BGM_07_Ch2_5
	envelope $A8
	note A#,3, 6
	silence 3
	envelope $88
	note A#,3
	envelope $A8
	note E_,3, 6
	silence 3
	envelope $88
	note E_,3
	envelope $A8
	note A#,3, 6
	silence 3
	envelope $88
	note A#,3
	envelope $A8
	note C#,4, 6
	silence 3
	envelope $88
	note C#,4
	envelope $A8
	note F#,3, 6
	silence 3
	envelope $88
	note F#,3
	envelope $A8
	note C#,4, 6
	silence 3
	envelope $88
	note C#,4
	envelope $A8
	note D#,4, 6
	silence 3
	envelope $88
	note D#,4
	envelope $A8
	note G#,3, 6
	silence 3
	envelope $88
	note G#,3
	envelope $A8
	note D#,4, 6
	silence 3
	envelope $88
	note D#,4
	envelope $A8
	note E_,4, 6
	silence 3
	envelope $88
	note E_,4
	envelope $A8
	note A#,3, 6
	silence 3
	envelope $88
	note A#,3
	envelope $A8
	note E_,4, 6
	silence 3
	envelope $88
	note E_,4
	envelope $A8
	note G#,4, 6
	silence 3
	envelope $88
	note G#,4
	envelope $A8
	note C#,4, 6
	silence 3
	envelope $88
	note C#,4
	envelope $A8
	note G#,4, 6
	silence 3
	envelope $88
	note G#,4
	envelope $A8
	note A#,4, 6
	silence 3
	envelope $88
	note A#,4
	envelope $A8
	note D#,4, 6
	silence 3
	envelope $88
	note D#,4
	envelope $A8
	note A#,4, 6
	silence 3
	envelope $88
	note A#,4
	envelope $A8
	note C_,5, 6
	silence 3
	envelope $88
	note C_,5
	envelope $A8
	note F_,4, 6
	silence 3
	envelope $88
	note F_,4
	envelope $A8
	note C_,5, 6
	silence 3
	envelope $88
	note C_,5
	envelope $A8
	note D_,5, 6
	silence 3
	envelope $88
	note D_,5
	envelope $A8
	note G_,4, 6
	silence 3
	envelope $88
	note G_,4
	envelope $A8
	note D_,5, 6
	silence 3
	envelope $88
	note D_,5
.loop0:
	envelope $A8
	note D_,5, 6
	silence 3
	envelope $88
	note D_,5
	envelope $A8
	note D_,5, 6
	silence 3
	envelope $88
	note D_,5, 6
	silence 3
	envelope $68
	note D_,5, 6
	snd_loop .loop0, $00, 3
	envelope $A8
	note C_,5, 6
	silence 3
	envelope $88
	note C_,5
	envelope $A8
	note A#,4, 12
	note G#,4
	note F#,4
	note E_,4
	snd_loop SndData_BGM_07_Ch2
SndCall_BGM_07_Ch2_0:
	envelope $78
	note A#,5, 6
	silence 3
	envelope $58
	note A#,5
	envelope $78
	note D_,5, 12
	note A#,5, 6
	silence 3
	envelope $58
	note A#,5, 6
	silence 3
	envelope $38
	note A#,5, 3
	silence
	snd_loop SndCall_BGM_07_Ch2_0, $00, 4
	snd_ret
SndCall_BGM_07_Ch2_1:
	envelope $78
	note A#,5, 6
	silence 3
	envelope $58
	note A#,5
	envelope $78
	note D_,5, 12
	note A#,5, 6
	silence 3
	envelope $58
	note A#,5, 6
	silence 3
	envelope $38
	note A#,5, 3
	silence
	snd_loop SndCall_BGM_07_Ch2_1, $00, 3
	envelope $78
	note A#,5, 6
	silence 3
	envelope $58
	note A#,5
	envelope $78
	note D_,5, 12
	note A#,5, 6
	silence 3
	envelope $58
	note A#,5
	snd_ret
SndCall_BGM_07_Ch2_2:
	envelope $A8
	note F_,4, 12
	note D_,4, 6
	silence 3
	envelope $88
	note D_,4
	envelope $A8
	note D_,4, 6
	silence 3
	envelope $88
	note D_,4
	snd_loop SndCall_BGM_07_Ch2_2, $00, 2
	envelope $A8
	note F_,4, 12
	note D_,4, 6
	silence 3
	envelope $88
	note D_,4
	snd_ret
SndCall_BGM_07_Ch2_3:
	envelope $A8
	note F_,4, 12
	note E_,4, 6
	silence 3
	envelope $88
	note E_,4
	envelope $A8
	note E_,4, 6
	silence 3
	envelope $88
	note E_,4
	snd_loop SndCall_BGM_07_Ch2_3, $00, 2
	envelope $A8
	note F_,4, 12
	note E_,4, 6
	silence 3
	envelope $88
	note E_,4
	snd_ret
SndCall_BGM_07_Ch2_4:
	envelope $A8
	note F_,4, 6
	silence 3
	envelope $88
	note F_,4
	snd_loop SndCall_BGM_07_Ch2_4, $00, 8
	snd_ret
SndCall_BGM_07_Ch2_5:
	envelope $A8
	note E_,4, 6
	silence 3
	envelope $88
	note E_,4
	snd_loop SndCall_BGM_07_Ch2_5, $00, 5
	envelope $A8
	note F_,4, 6
	silence 3
	envelope $88
	note F_,4
	envelope $A8
	note F#,4, 6
	silence 3
	envelope $88
	note F#,4
	envelope $A8
	note G_,4, 6
	silence 3
	envelope $88
	note G_,4
	snd_ret
SndCall_BGM_07_Ch2_6:
	envelope $78
	note A#,5, 6
	note C_,6
	note D_,6
	note E_,6
	note F#,6
	note G#,6
	note A#,6
	note C_,7
	note D_,7
	note C_,7
	note A#,6
	note G#,6
	note F#,6
	note E_,6
	note D_,6
	note C_,6
	snd_ret
SndData_BGM_07_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	wave_cutoff 0
	note F#,3, 4
	note G_,3
	note G#,3
	note A_,3
	note A#,3
	note B_,3
	snd_call SndCall_BGM_07_Ch3_0
	snd_call SndCall_BGM_07_Ch3_0
	snd_call SndCall_BGM_07_Ch3_1
	snd_call SndCall_BGM_07_Ch3_0
	snd_call SndCall_BGM_07_Ch3_2
	snd_call SndCall_BGM_07_Ch3_3
	fine_tune -1
	snd_call SndCall_BGM_07_Ch3_3
	fine_tune 1
	snd_call SndCall_BGM_07_Ch3_3
	snd_call SndCall_BGM_07_Ch3_4
	snd_call SndCall_BGM_07_Ch3_0
	snd_call SndCall_BGM_07_Ch3_0
	snd_call SndCall_BGM_07_Ch3_1
	snd_call SndCall_BGM_07_Ch3_0
	snd_call SndCall_BGM_07_Ch3_2
	snd_call SndCall_BGM_07_Ch3_3
	fine_tune -1
	snd_call SndCall_BGM_07_Ch3_3
	fine_tune 1
	snd_call SndCall_BGM_07_Ch3_3
	snd_call SndCall_BGM_07_Ch3_4
	note A#,3, 22
	silence 2
	note A#,3, 12
	note G#,3, 22
	silence 2
	note G#,3, 12
	note F#,3, 22
	silence 2
	note F#,3, 12
	note E_,3, 22
	silence 2
	note E_,3, 12
	note D_,3, 22
	silence 2
	note D_,4, 12
	note C#,4, 22
	silence 2
	note C#,4, 12
	note B_,3, 22
	silence 2
	note B_,3, 12
	note A_,3, 22
	silence 2
	note A_,3, 12
	note A#,3, 10
	silence 2
	note A#,3, 12
	silence
	note A#,3, 10
	silence 2
	note A#,3, 12
	silence
	note A#,3, 10
	silence 2
	note A#,3, 12
	silence
	note D_,5, 6
	silence
	note C_,5, 12
	note A#,4
	note G#,4
	note F#,4
	snd_loop SndData_BGM_07_Ch3
SndCall_BGM_07_Ch3_0:
	note C_,4, 12
	note G_,3, 6
	silence
	note A#,3, 12
	note G_,3, 6
	silence
	note C_,4, 12
	note A#,3, 6
	silence
	note G_,3
	silence
	note C_,4, 12
	note A#,3, 6
	silence
	note G_,3
	silence
	note C_,4, 12
	note A#,3, 6
	silence
	note G_,3
	silence
	note C_,4, 12
	note A#,3, 6
	silence
	note G_,3
	silence
	snd_ret
SndCall_BGM_07_Ch3_1:
	note G_,3, 12
	note F_,4, 6
	silence
	note F_,4
	silence
	note G_,3, 12
	note F_,4, 6
	silence
	note F_,4
	silence
	note G_,3, 12
	note F_,4, 6
	silence
	snd_loop SndCall_BGM_07_Ch3_1, $00, 2
	snd_ret
SndCall_BGM_07_Ch3_2:
	note G#,3, 12
	note D_,4, 6
	silence
	note D_,4
	silence
	note G#,3, 12
	note D_,4, 6
	silence
	note D_,4
	silence
	note G#,3, 12
	note D_,4, 6
	silence
	snd_loop SndCall_BGM_07_Ch3_2, $00, 2
	snd_ret
SndCall_BGM_07_Ch3_3:
	note A_,3, 12
	note A_,4, 6
	silence
	snd_loop SndCall_BGM_07_Ch3_3, $00, 4
	snd_ret
SndCall_BGM_07_Ch3_4:
	note G#,3, 12
	note G#,4, 6
	silence
	note G#,3, 12
	note G#,4, 6
	silence
	note G#,3, 12
	note A_,3
	note A#,3
	note B_,3
	snd_ret
SndData_BGM_07_Ch4:
	panning $88
	note4x $80, 24 ; Nearest: B_,3,0
.loop0:
	snd_call SndCall_BGM_07_Ch4_0
	snd_call SndCall_BGM_07_Ch4_1
	snd_call SndCall_BGM_07_Ch4_0
	snd_call SndCall_BGM_07_Ch4_2
	snd_call SndCall_BGM_07_Ch4_0
	snd_call SndCall_BGM_07_Ch4_1
	snd_call SndCall_BGM_07_Ch4_3
	snd_call SndCall_BGM_07_Ch4_4
	envelope $A1
	note4 A_,5,0, 12
	note4 A_,5,0, 12
	envelope $91
	note4 G_,5,0, 6
	note4 G_,5,0, 6
	envelope $91
	note4 F#,5,0, 12
	snd_call SndCall_BGM_07_Ch4_0
	snd_call SndCall_BGM_07_Ch4_1
	snd_call SndCall_BGM_07_Ch4_3
	snd_call SndCall_BGM_07_Ch4_4
	envelope $A1
	note4 A_,5,0, 6
	note4 A_,5,0, 6
	envelope $91
	note4 G_,5,0, 6
	note4 G_,5,0, 6
	envelope $91
	note4 F#,5,0, 6
	note4 F#,5,0, 6
	envelope $91
	note4 E_,5,0, 6
	note4 E_,5,0, 6
	snd_call SndCall_BGM_07_Ch4_5
	snd_call SndCall_BGM_07_Ch4_6
	snd_call SndCall_BGM_07_Ch4_5
	snd_call SndCall_BGM_07_Ch4_7
	snd_call SndCall_BGM_07_Ch4_5
	snd_call SndCall_BGM_07_Ch4_6
	snd_call SndCall_BGM_07_Ch4_8
	snd_call SndCall_BGM_07_Ch4_0
	snd_call SndCall_BGM_07_Ch4_1
	snd_call SndCall_BGM_07_Ch4_0
	snd_call SndCall_BGM_07_Ch4_2
	snd_call SndCall_BGM_07_Ch4_0
	snd_call SndCall_BGM_07_Ch4_1
	snd_call SndCall_BGM_07_Ch4_3
	snd_call SndCall_BGM_07_Ch4_4
	envelope $A1
	note4 A_,5,0, 12
	note4 A_,5,0, 12
	envelope $91
	note4 G_,5,0, 6
	note4 G_,5,0, 6
	envelope $91
	note4 F#,5,0, 12
	snd_call SndCall_BGM_07_Ch4_0
	snd_call SndCall_BGM_07_Ch4_1
	snd_call SndCall_BGM_07_Ch4_3
	snd_call SndCall_BGM_07_Ch4_4
	envelope $A1
	note4 A_,5,0, 6
	note4 A_,5,0, 6
	envelope $91
	note4 G_,5,0, 6
	note4 G_,5,0, 6
	envelope $91
	note4 F#,5,0, 6
	note4 F#,5,0, 6
	envelope $91
	note4 E_,5,0, 6
	note4 E_,5,0, 6
	snd_call SndCall_BGM_07_Ch4_5
	snd_call SndCall_BGM_07_Ch4_6
	snd_call SndCall_BGM_07_Ch4_5
	snd_call SndCall_BGM_07_Ch4_7
	snd_call SndCall_BGM_07_Ch4_5
	snd_call SndCall_BGM_07_Ch4_6
	snd_call SndCall_BGM_07_Ch4_8
	snd_call SndCall_BGM_07_Ch4_9
	note4x $80, 96 ; Nearest: B_,3,0
	snd_loop .loop0
SndCall_BGM_07_Ch4_0:
	envelope $A1
	note4 A_,5,0, 6
	envelope $51
	note4 C_,6,0, 6
	envelope $53
	note4x $13, 6 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 6
	envelope $A1
	note4 A_,5,0, 6
	envelope $C1
	note4 G#,4,0, 6
	envelope $51
	note4 C_,6,0, 6
	envelope $C1
	note4 G#,4,0, 6
	envelope $A1
	note4 A_,5,0, 6
	envelope $51
	note4 C_,6,0, 6
	envelope $53
	note4x $13, 6 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 6
	envelope $A1
	note4 A_,5,0, 6
	envelope $C1
	note4 G#,4,0, 6
	snd_ret
SndCall_BGM_07_Ch4_1:
	envelope $53
	note4x $13, 12 ; Nearest: G#,6,0
	snd_ret
SndCall_BGM_07_Ch4_2:
	envelope $53
	note4x $13, 6 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 6
	snd_ret
SndCall_BGM_07_Ch4_3:
	envelope $A1
	note4 A_,5,0, 6
	envelope $51
	note4 C_,6,0, 6
	envelope $53
	note4x $13, 6 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 6
	envelope $A1
	note4 A_,5,0, 6
	envelope $C1
	note4 G#,4,0, 6
	envelope $51
	note4 C_,6,0, 6
	envelope $C1
	note4 G#,4,0, 6
	envelope $A1
	note4 A_,5,0, 6
	envelope $51
	note4 C_,6,0, 6
	envelope $53
	note4x $13, 6 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 6
	envelope $A1
	note4 A_,5,0, 6
	note4 A_,5,0, 6
	note4 A_,5,0, 6
	note4 A_,5,0, 6
	snd_ret
SndCall_BGM_07_Ch4_4:
	envelope $C1
	note4 G#,4,0, 12
	envelope $A1
	note4 A_,5,0, 12
	note4 A_,5,0, 12
	envelope $C1
	note4 G#,4,0, 12
	envelope $A1
	note4 A_,5,0, 12
	note4 A_,5,0, 12
	envelope $C1
	note4 G#,4,0, 12
	envelope $A1
	note4 A_,5,0, 12
	envelope $C1
	note4 G#,4,0, 12
	envelope $A1
	note4 A_,5,0, 12
	note4 A_,5,0, 12
	envelope $C1
	note4 G#,4,0, 12
	snd_ret
SndCall_BGM_07_Ch4_5:
	envelope $C1
	note4 G#,4,0, 6
	note4 G#,4,0, 6
	envelope $53
	note4x $13, 12 ; Nearest: G#,6,0
	note4x $13, 12 ; Nearest: G#,6,0
	snd_loop SndCall_BGM_07_Ch4_5, $00, 2
	snd_ret
SndCall_BGM_07_Ch4_6:
	envelope $A1
	note4 A_,5,0, 6
	note4 A_,5,0, 6
	envelope $91
	note4 F#,5,0, 12
	snd_ret
SndCall_BGM_07_Ch4_7:
	envelope $A1
	note4 A_,5,0, 6
	note4 A_,5,0, 6
	envelope $C1
	note4 G#,4,0, 6
	envelope $A1
	note4 A_,5,0, 6
	snd_ret
SndCall_BGM_07_Ch4_8:
	envelope $C1
	note4 G#,4,0, 6
	note4 G#,4,0, 6
	envelope $53
	note4x $13, 12 ; Nearest: G#,6,0
	note4x $13, 12 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 6
	note4 G#,4,0, 6
	envelope $A1
	note4 A_,5,0, 6
	note4 A_,5,0, 6
	envelope $C1
	note4 G#,4,0, 6
	note4 G#,4,0, 6
	envelope $A1
	note4 A_,5,0, 12
	note4 A_,5,0, 6
	note4 A_,5,0, 6
	snd_ret
SndCall_BGM_07_Ch4_9:
	envelope $C1
	note4 G#,4,0, 12
	envelope $51
	note4 C_,6,0, 6
	note4 C_,6,0, 6
	envelope $53
	note4x $13, 12 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 12
	envelope $51
	note4 C_,6,0, 6
	note4 C_,6,0, 6
	envelope $53
	note4x $13, 12 ; Nearest: G#,6,0
	snd_loop SndCall_BGM_07_Ch4_9, $00, 4
	envelope $A1
	note4 A_,5,0, 6
	envelope $53
	note4x $13, 6 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 12
	envelope $C1
	note4 G#,4,0, 12
	envelope $A1
	note4 A_,5,0, 6
	envelope $53
	note4x $13, 6 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 12
	envelope $C1
	note4 G#,4,0, 12
	envelope $A1
	note4 A_,5,0, 6
	envelope $53
	note4x $13, 6 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 12
	snd_ret
