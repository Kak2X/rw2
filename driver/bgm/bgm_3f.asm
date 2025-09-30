SndHeader_BGM_3F:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_3F_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_3F_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_3F_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_3F_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_BGM_3F_Ch1:
	envelope $A8
	panning $11
	duty_cycle 3
	vibrato_on $01
	snd_call SndCall_BGM_3F_Ch1_0
	snd_call SndCall_BGM_3F_Ch1_1
	snd_call SndCall_BGM_3F_Ch1_0
	fine_tune 3
	snd_call SndCall_BGM_3F_Ch1_1
	fine_tune -3
	snd_call SndCall_BGM_3F_Ch1_0
	snd_call SndCall_BGM_3F_Ch1_1
	envelope $A8
	silence 10
	note D_,5
	note C#,5
	note C_,5
	note B_,4
	note A#,4
	note A_,4
	note G#,4
	snd_call SndCall_BGM_3F_Ch1_2
	snd_call SndCall_BGM_3F_Ch1_3
	fine_tune -1
	snd_call SndCall_BGM_3F_Ch1_1
	fine_tune 1
	snd_call SndCall_BGM_3F_Ch1_5
	note C_,5, 20
	envelope $88
	note C_,5, 5
	silence 2
	envelope $68
	note C_,5, 3
	snd_call SndCall_BGM_3F_Ch1_6
	snd_call SndCall_BGM_3F_Ch1_5
	note A#,4, 20
	envelope $88
	note A#,4, 5
	silence 2
	envelope $68
	note A#,4, 3
	snd_call SndCall_BGM_3F_Ch1_6
	duty_cycle 2
	envelope $A8
	note E_,5, 10
	note D#,5
	note B_,4
	note D_,5
	note C#,5
	note A_,4
	note C_,5
	note B_,4
	note A#,4
	note F#,4
	note A_,4
	note G#,4
	note E_,4
	note G_,4
	envelope $88
	note G_,4, 5
	silence 2
	envelope $68
	note G_,4, 3
	envelope $A8
	note A#,4, 40
	continue 10
	envelope $88
	note A#,4, 10
	envelope $68
	note A#,4, 5
	silence 2
	envelope $48
	note A#,4, 3
	silence 20
	duty_cycle 1
	silence 10
	snd_call SndCall_BGM_3F_Ch1_4
	snd_call SndCall_BGM_3F_Ch1_7
	snd_call SndCall_BGM_3F_Ch1_8
	snd_call SndCall_BGM_3F_Ch1_7
	snd_call SndCall_BGM_3F_Ch1_9
	snd_call SndCall_BGM_3F_Ch1_7
	snd_call SndCall_BGM_3F_Ch1_8
	envelope $A8
	note F#,5, 5
	silence 2
	envelope $88
	note F#,5, 3
	envelope $A8
	note F#,5, 10
	note F_,5, 5
	note E_,5
	note D#,5
	note D_,5
	note E_,5, 10
	note D#,5
	note A#,4
	note D_,5
	envelope $A8
	note C#,5, 5
	silence 2
	envelope $88
	note C#,5, 3
	envelope $A8
	note G#,4, 5
	silence 2
	envelope $88
	note G#,4, 3
	envelope $A8
	note E_,5, 10
	note D#,5, 5
	silence 2
	envelope $88
	note D#,5, 3
	envelope $A8
	note A#,4, 5
	silence 2
	envelope $88
	note A#,4, 3
	envelope $A8
	note G_,5, 10
	note F#,5, 5
	silence 2
	envelope $88
	note F#,5, 3
	envelope $A8
	note C#,5, 5
	silence 2
	envelope $88
	note C#,5, 3
	snd_call SndCall_BGM_3F_Ch1_A
	snd_call SndCall_BGM_3F_Ch1_B
	snd_call SndCall_BGM_3F_Ch1_A
	snd_call SndCall_BGM_3F_Ch1_C
	snd_call SndCall_BGM_3F_Ch1_A
	snd_call SndCall_BGM_3F_Ch1_B
	snd_call SndCall_BGM_3F_Ch1_A
	snd_call SndCall_BGM_3F_Ch1_C
	snd_loop SndData_BGM_3F_Ch1
SndCall_BGM_3F_Ch1_0:
	envelope $A8
	note G_,4, 5
	silence 2
	envelope $88
	note G_,4, 3
	envelope $A8
	note G_,4, 18
	silence 2
	note G_,4, 8
	silence 2
	snd_ret
SndCall_BGM_3F_Ch1_1:
	envelope $A8
	note G#,4, 10
	envelope $88
	note G#,4, 5
	silence 2
	envelope $68
	note G#,4, 3
	snd_loop SndCall_BGM_3F_Ch1_1, $00, 2
	snd_ret
SndCall_BGM_3F_Ch1_2:
	envelope $88
	note A_,5, 5
	note G#,5
	note G_,5
	note G#,5
	note A_,5
	note A#,5
	note B_,5
	note A#,5
	note A_,5
	note A#,5
	note B_,5
	note C_,6
	note C#,6
	note C_,6
	note B_,5
	note C_,6
	note C#,6
	note D_,6
	note D#,6
	note D_,6
	note C#,6
	note D_,6
	note D#,6
	note E_,6
	note F_,6
	note E_,6
	note D#,6
	note E_,6
	note F_,6
	note F#,6
	note G_,6
	note G#,6
	snd_loop SndCall_BGM_3F_Ch1_2, $00, 3
	snd_ret
SndCall_BGM_3F_Ch1_3:
	envelope $A8
	note G_,4, 5
	silence 2
	envelope $88
	note G_,4, 3
	envelope $A8
	note G_,4, 8
	silence 2
	envelope $88
	note G_,4, 5
	silence 2
	envelope $68
	note G_,4, 3
	snd_loop SndCall_BGM_3F_Ch1_3, $00, 4
	snd_ret
SndCall_BGM_3F_Ch1_4:
	envelope $A8
	note G_,4, 5
	silence 2
	envelope $88
	note G_,4, 3
	envelope $A8
	note G_,4, 8
	silence 2
	envelope $88
	note G_,4, 5
	silence 2
	envelope $68
	note G_,4, 3
	snd_loop SndCall_BGM_3F_Ch1_4, $00, 2
	envelope $A8
	note G_,4, 5
	silence 2
	envelope $88
	note G_,4, 3
	snd_ret
SndCall_BGM_3F_Ch1_5:
	duty_cycle 2
	envelope $A8
	note E_,5, 10
	note D#,5
	note B_,4
	note D_,5
	note C#,5
	note A_,4
	snd_ret
SndCall_BGM_3F_Ch1_6:
	duty_cycle 1
	envelope $A8
	note A#,5, 10
	note A_,5
	envelope $88
	note A_,5, 5
	silence 2
	envelope $68
	note A_,5, 3
	envelope $A8
	note A#,5, 10
	note A_,5
	envelope $88
	note A_,5, 5
	silence 2
	envelope $68
	note A_,5, 3
	silence 10
	snd_ret
SndCall_BGM_3F_Ch1_7:
	duty_cycle 2
	envelope $A8
	note F#,5, 5
	silence 2
	envelope $88
	note F#,5, 3
	envelope $A8
	note F#,5, 10
	note F_,5, 5
	note E_,5
	note D#,5
	note D_,5
	note E_,5, 10
	note D#,5
	note A#,4
	note D_,5
	note C#,5
	note G#,4
	envelope $88
	note G#,4, 5
	silence 2
	envelope $68
	note G#,4, 3
	snd_ret
SndCall_BGM_3F_Ch1_8:
	silence 10
	envelope $A8
	note D_,4, 2
	note D#,4, 3
	note E_,4, 2
	note F_,4, 3
	note F#,4, 2
	note G_,4, 3
	note G#,4, 2
	note A_,4, 3
	note A#,4, 2
	note B_,4, 3
	note C_,5, 2
	note C#,5, 3
	note D_,5, 2
	note D#,5, 3
	note E_,5, 2
	note F_,5, 3
	snd_ret
SndCall_BGM_3F_Ch1_9:
	duty_cycle 1
	envelope $A8
	note B_,5, 10
	note A#,5
	note A_,5
	note G#,5
	note G_,5
	snd_ret
SndCall_BGM_3F_Ch1_A:
	envelope $A8
	note G#,4, 25
	note A_,4, 2
	note A#,4, 3
	note B_,4, 23
	note C_,5, 2
	note C#,5
	note D_,5, 3
	note D#,5, 20
	continue 5
	note E_,5, 2
	note F_,5, 3
	note F#,5, 10
	envelope $88
	note F#,5, 5
	silence 2
	envelope $68
	note F#,5, 3
	snd_ret
SndCall_BGM_3F_Ch1_B:
	envelope $A8
	note E_,5, 10
	note D#,5
	note C#,5
	note B_,4
	note F#,4
	snd_ret
SndCall_BGM_3F_Ch1_C:
	envelope $A8
	note G#,5, 10
	note F#,5
	note E_,5
	note D#,5
	note B_,4
	snd_ret
SndData_BGM_3F_Ch2:
	envelope $A8
	panning $22
	duty_cycle 1
	vibrato_on $01
	snd_call SndCall_BGM_3F_Ch2_0
	snd_call SndCall_BGM_3F_Ch2_1
	snd_call SndCall_BGM_3F_Ch2_2
	snd_call SndCall_BGM_3F_Ch2_1
	snd_call SndCall_BGM_3F_Ch2_3
	snd_call SndCall_BGM_3F_Ch2_1
	snd_call SndCall_BGM_3F_Ch2_2
	snd_call SndCall_BGM_3F_Ch2_4
	snd_call SndCall_BGM_3F_Ch2_1
	snd_call SndCall_BGM_3F_Ch2_2
	snd_call SndCall_BGM_3F_Ch2_1
	snd_call SndCall_BGM_3F_Ch2_2
	snd_call SndCall_BGM_3F_Ch2_1
	snd_call SndCall_BGM_3F_Ch2_2
	snd_call SndCall_BGM_3F_Ch2_1
	snd_call SndCall_BGM_3F_Ch2_5
	snd_call SndCall_BGM_3F_Ch2_6
	snd_call SndCall_BGM_3F_Ch2_7
	snd_call SndCall_BGM_3F_Ch2_6
	snd_call SndCall_BGM_3F_Ch2_8
	snd_call SndCall_BGM_3F_Ch2_6
	snd_call SndCall_BGM_3F_Ch2_7
	snd_call SndCall_BGM_3F_Ch2_6
	envelope $C8
	note G_,3, 18
	silence 2
	note G_,3, 10
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $88
	note G_,3, 3
	silence 10
	snd_call SndCall_BGM_3F_Ch2_9
	snd_call SndCall_BGM_3F_Ch2_A
	fine_tune 2
	snd_call SndCall_BGM_3F_Ch2_A
	fine_tune -2
	snd_call SndCall_BGM_3F_Ch2_9
	snd_call SndCall_BGM_3F_Ch2_A
	fine_tune 2
	snd_call SndCall_BGM_3F_Ch2_A
	fine_tune -2
	snd_call SndCall_BGM_3F_Ch2_9
	snd_call SndCall_BGM_3F_Ch2_A
	fine_tune 2
	snd_call SndCall_BGM_3F_Ch2_A
	fine_tune -2
	snd_call SndCall_BGM_3F_Ch2_9
	snd_call SndCall_BGM_3F_Ch2_A
	fine_tune 2
	snd_call SndCall_BGM_3F_Ch2_A
	fine_tune -2
	snd_loop SndData_BGM_3F_Ch2
SndCall_BGM_3F_Ch2_0:
	envelope $B8
	note F_,3, 5
	silence 2
	envelope $98
	note F_,3, 3
	envelope $B8
	note F_,3, 18
	silence 2
	note F_,3, 8
	silence 2
	note F_,3, 8
	silence 2
	envelope $98
	note F_,3, 5
	silence 2
	envelope $78
	note F_,3, 3
	envelope $B8
	note F_,3, 8
	silence 2
	envelope $98
	note F_,3, 5
	silence 2
	envelope $78
	note F_,3, 3
	snd_loop SndCall_BGM_3F_Ch2_0, $00, 3
	silence 10
	envelope $B8
	note A_,3
	note G#,3
	note G_,3
	note F#,3
	note F_,3
	note E_,3
	note D#,3
	snd_ret
SndCall_BGM_3F_Ch2_1:
	envelope $B8
	note G_,3, 20
	envelope $98
	note G_,3, 5
	silence 2
	envelope $78
	note G_,3, 3
	envelope $B8
	note F#,3, 30
	note G_,3, 20
	envelope $98
	note G_,3, 5
	silence 2
	envelope $78
	note G_,3, 3
	snd_ret
SndCall_BGM_3F_Ch2_2:
	envelope $B8
	note A#,3, 30
	note G_,3, 10
	envelope $98
	note G_,3, 5
	silence 2
	envelope $78
	note G_,3, 3
	envelope $B8
	note F#,3, 10
	envelope $98
	note F#,3, 5
	silence 2
	envelope $78
	note F#,3, 3
	snd_ret
SndCall_BGM_3F_Ch2_3:
	envelope $A8
	note A#,4, 5
	silence 2
	envelope $88
	note A#,4, 3
	envelope $A8
	note A_,4, 5
	silence 2
	envelope $88
	note A_,4, 3
	snd_loop SndCall_BGM_3F_Ch2_3, $00, 2
	envelope $A8
	note G_,4, 5
	silence 2
	envelope $88
	note G_,4, 3
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $88
	note D#,4, 3
	envelope $A8
	note F_,4, 5
	silence 2
	envelope $88
	note F_,4, 3
	snd_ret
SndCall_BGM_3F_Ch2_4:
	envelope $A8
	note E_,4, 5
	silence 2
	envelope $88
	note E_,4, 3
	envelope $A8
	note E_,4, 10
	envelope $88
	note E_,4, 5
	silence 2
	envelope $68
	note E_,4, 3
	snd_loop SndCall_BGM_3F_Ch2_4, $00, 4
	envelope $A8
	note E_,4, 10
	envelope $88
	note E_,4, 5
	silence 2
	envelope $68
	note E_,4, 3
	envelope $A8
	note E_,4, 10
	envelope $88
	note E_,4, 5
	silence 2
	envelope $68
	note E_,4, 3
	snd_ret
SndCall_BGM_3F_Ch2_5:
	envelope $A8
	note E_,4, 5
	silence 2
	envelope $88
	note E_,4, 3
	envelope $A8
	note E_,4, 10
	envelope $88
	note E_,4, 5
	silence 2
	envelope $68
	note E_,4, 3
	snd_loop SndCall_BGM_3F_Ch2_5, $00, 2
	envelope $A8
	note E_,4, 5
	silence 2
	envelope $88
	note E_,4, 3
	snd_ret
SndCall_BGM_3F_Ch2_6:
	envelope $C8
	note F#,2, 8
	silence 2
	note F#,2, 10
	envelope $A8
	note F#,2, 5
	silence 2
	envelope $88
	note F#,2, 3
	envelope $C8
	note C_,3, 18
	silence 2
	note C_,3, 10
	envelope $A8
	note C_,3, 5
	silence 2
	envelope $88
	note C_,3, 3
	envelope $C8
	note B_,2, 18
	silence 2
	note B_,2, 10
	envelope $A8
	note B_,2, 5
	silence 2
	envelope $88
	note B_,2, 3
	snd_ret
SndCall_BGM_3F_Ch2_7:
	silence 10
	envelope $C8
	note A_,2
	note G#,2
	note G_,2
	note D#,2
	snd_ret
SndCall_BGM_3F_Ch2_8:
	envelope $A8
	note F#,4, 10
	note F_,4
	note E_,4
	note D#,4
	note D_,4
	snd_ret
SndCall_BGM_3F_Ch2_9:
	envelope $88
	note G#,5, 5
	silence 2
	envelope $68
	note G#,5, 3
	envelope $88
	note G#,5, 5
	note D#,5
	note A#,4
	note D#,5
	snd_loop SndCall_BGM_3F_Ch2_9, $00, 2
	note G#,5
	note D#,5
	note A#,4
	note D#,5
	snd_ret
SndCall_BGM_3F_Ch2_A:
	note A_,5, 5
	note E_,5
	note C#,5
	note E_,5
	note A_,5
	note E_,5
	note C#,5
	note E_,5
	snd_ret
SndData_BGM_3F_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	wave_cutoff 0
	note C_,5, 5
	silence
	note C_,5, 18
	silence 2
	note C_,5, 10
	note B_,4, 15
	silence 5
	note B_,4, 20
	note C_,5, 5
	silence
	note C_,5, 18
	silence 2
	note C_,5, 10
	note C#,5, 15
	silence 5
	note C#,5, 20
	note C_,5, 5
	silence
	note C_,5, 18
	silence 2
	note C_,5, 10
	note B_,4, 15
	silence 5
	note B_,4, 20
	silence 10
	note E_,5
	note D#,5
	note D_,5
	note C#,5
	note C_,5
	note B_,4
	note A#,4
	snd_call SndCall_BGM_3F_Ch3_0
	snd_call SndCall_BGM_3F_Ch3_1
	snd_call SndCall_BGM_3F_Ch3_2
	snd_call SndCall_BGM_3F_Ch3_3
	note C#,6, 10
	note C_,5
	note B_,5
	note A#,5
	note A_,5
	snd_call SndCall_BGM_3F_Ch3_3
	note D_,5, 18
	silence 2
	note D_,5, 10
	silence 20
	snd_call SndCall_BGM_3F_Ch3_4
	snd_loop SndData_BGM_3F_Ch3
SndCall_BGM_3F_Ch3_0:
	note C_,4, 8
	silence 2
	note B_,3, 10
	note C_,4, 8
	silence 2
	note D#,4, 8
	silence 2
	note B_,3, 10
	note C_,4, 8
	silence 2
	note C_,4, 8
	silence 2
	note B_,3, 10
	note C_,4, 8
	silence 2
	note D#,4, 8
	silence 2
	note B_,3, 10
	note C_,4, 8
	silence 2
	note C_,4, 8
	silence 2
	note G_,4, 10
	note C_,4
	note B_,3
	snd_loop SndCall_BGM_3F_Ch3_0, $00, 3
	snd_ret
SndCall_BGM_3F_Ch3_1:
	note A#,4, 5
	silence
	note A#,4, 10
	silence
	snd_loop SndCall_BGM_3F_Ch3_1, $00, 4
	note A#,4
	note A_,4
	note G#,4
	note F_,4
	snd_ret
SndCall_BGM_3F_Ch3_2:
	note C_,4, 8
	silence 2
	note B_,3, 10
	note C_,4, 8
	silence 2
	note D#,4, 8
	silence 2
	note B_,3, 10
	note C_,4, 8
	silence 2
	note C_,4, 8
	silence 2
	note B_,3, 10
	note C_,4, 8
	silence 2
	note D#,4, 8
	silence 2
	note B_,3, 10
	note C_,4, 8
	silence 2
	note C_,4, 8
	silence 2
	note D#,4, 10
	note C_,4
	note B_,3
	snd_loop SndCall_BGM_3F_Ch3_2, $00, 3
	note C_,4, 8
	silence 2
	note B_,3, 10
	note C_,4, 8
	silence 2
	note D#,4, 8
	silence 2
	note B_,3, 10
	note C_,4, 8
	silence 2
	note C_,4, 8
	silence 2
	note B_,3, 10
	note A#,3, 5
	silence
	note A#,4
	silence
	note A#,4, 10
	silence
	note A#,4, 5
	silence
	note A#,4, 10
	silence
	note A#,4, 5
	silence
	snd_ret
SndCall_BGM_3F_Ch3_3:
	note C#,4, 8
	silence 2
	note C#,4, 10
	silence
	note G_,4, 18
	silence 2
	note G_,4, 10
	silence
	note F#,4, 18
	silence 2
	note F#,4, 10
	silence 20
	note E_,4, 10
	note D#,4
	note D_,4
	note A#,3
	note C#,4, 8
	silence 2
	note C#,4, 10
	silence
	note G_,4, 18
	silence 2
	note G_,4, 10
	silence
	note G#,4, 18
	silence 2
	note G#,4, 10
	silence
	snd_ret
SndCall_BGM_3F_Ch3_4:
	note C#,4, 8
	silence 2
	note C#,4, 10
	note G#,3
	silence
	note B_,3
	note F#,3
	silence
	note A_,3
	silence
	note E_,3
	silence
	note A_,3
	note G#,3
	note F#,3
	note E_,3
	note D#,3
	snd_loop SndCall_BGM_3F_Ch3_4, $00, 4
	snd_ret
SndData_BGM_3F_Ch4:
	panning $88
	snd_call SndCall_BGM_3F_Ch4_0
	snd_call SndCall_BGM_3F_Ch4_1
	snd_call SndCall_BGM_3F_Ch4_2
	snd_call SndCall_BGM_3F_Ch4_3
	snd_call SndCall_BGM_3F_Ch4_4
	snd_call SndCall_BGM_3F_Ch4_1
	snd_call SndCall_BGM_3F_Ch4_2
	snd_call SndCall_BGM_3F_Ch4_1
	snd_call SndCall_BGM_3F_Ch4_5
	snd_call SndCall_BGM_3F_Ch4_6
	snd_call SndCall_BGM_3F_Ch4_7
	snd_call SndCall_BGM_3F_Ch4_6
	snd_call SndCall_BGM_3F_Ch4_8
	snd_call SndCall_BGM_3F_Ch4_6
	snd_call SndCall_BGM_3F_Ch4_7
	snd_call SndCall_BGM_3F_Ch4_6
	snd_call SndCall_BGM_3F_Ch4_8
	snd_call SndCall_BGM_3F_Ch4_9
	snd_loop SndData_BGM_3F_Ch4
SndCall_BGM_3F_Ch4_0:
	envelope $C1
	note4 G#,4,0, 10
	note4 G#,4,0, 20
	note4 G#,4,0, 5
	note4 G#,4,0, 5
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	snd_loop SndCall_BGM_3F_Ch4_0, $00, 3
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $C1
	note4 G#,4,0, 5
	note4 G#,4,0, 5
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $C1
	note4 G#,4,0, 5
	note4 G#,4,0, 5
	envelope $A1
	note4 A_,5,0, 10
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	snd_ret
SndCall_BGM_3F_Ch4_1:
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 10
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	snd_loop SndCall_BGM_3F_Ch4_1, $00, 3
	snd_ret
SndCall_BGM_3F_Ch4_2:
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 10
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	snd_ret
SndCall_BGM_3F_Ch4_3:
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 10
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	snd_loop SndCall_BGM_3F_Ch4_3, $00, 2
	snd_ret
SndCall_BGM_3F_Ch4_4:
	envelope $A1
	note4 A_,5,0, 5
	envelope $C1
	note4 G#,4,0, 5
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $C1
	note4 G#,4,0, 5
	envelope $53
	note4x $13, 5 ; Nearest: G#,6,0
	snd_loop SndCall_BGM_3F_Ch4_4, $00, 4
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $C1
	note4 G#,4,0, 5
	envelope $53
	note4x $13, 5 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 5
	envelope $91
	note4 G_,5,0, 5
	envelope $91
	note4 F#,5,0, 5
	envelope $91
	note4 E_,5,0, 5
	snd_ret
SndCall_BGM_3F_Ch4_5:
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $C1
	note4 G#,4,0, 5
	note4 G#,4,0, 5
	envelope $A1
	note4 A_,5,0, 5
	envelope $C1
	note4 G#,4,0, 5
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $53
	note4x $13, 5 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $C1
	note4 G#,4,0, 5
	snd_ret
SndCall_BGM_3F_Ch4_6:
	envelope $C1
	note4 G#,4,0, 10
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $C1
	note4 G#,4,0, 5
	envelope $51
	note4 C_,6,0, 5
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	snd_ret
SndCall_BGM_3F_Ch4_7:
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 10
	envelope $91
	note4 G_,5,0, 5
	note4 G_,5,0, 5
	envelope $91
	note4 F#,5,0, 5
	note4 F#,5,0, 5
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	snd_ret
SndCall_BGM_3F_Ch4_8:
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	note4 A_,5,0, 10
	note4 A_,5,0, 10
	snd_ret
SndCall_BGM_3F_Ch4_9:
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 5
	envelope $53
	note4x $13, 5 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 5
	note4 G#,4,0, 5
	snd_loop SndCall_BGM_3F_Ch4_9, $00, 14
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 5
	envelope $53
	note4x $13, 5 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 5
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $91
	note4 G_,5,0, 5
	note4 G_,5,0, 5
	envelope $91
	note4 F#,5,0, 5
	note4 F#,5,0, 5
	envelope $91
	note4 E_,5,0, 5
	note4 E_,5,0, 5
	snd_ret
