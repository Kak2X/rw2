SndHeader_BGM_3E:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_3E_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_3E_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_3E_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_3E_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_BGM_3E_Ch1:
	envelope $A8
	panning $11
	duty_cycle 2
	vibrato_on $01
	note D_,4, 7
	note E_,4
	note F_,4
	note F#,4
	note G_,4, 14
	note D_,4, 7
	note E_,4
	note F_,4
	note F#,4
	note G_,4, 14
	note C#,4, 7
	note C_,4
	note A#,3, 14
	note D_,4, 7
	note E_,4
	note F_,4
	note F#,4
	note G_,4, 14
	note D_,4, 7
	note E_,4
	note F_,4
	note F#,4
	note G_,4, 14
	note B_,3, 7
	note C_,4
	note D_,4, 14
	note D_,4, 7
	note E_,4
	note F_,4
	note F#,4
	note G_,4, 14
	note D_,4, 7
	note E_,4
	note F_,4
	note F#,4
	note G_,4, 14
	note C#,4, 7
	note C_,4
	note A#,3, 14
	note D_,4, 7
	note E_,4
	note F_,4
	note F#,4
	note G_,4, 14
	note D_,4, 7
	note E_,4
	note F_,4
	note F#,4
	note G_,4, 14
	note B_,4, 7
	note C_,5
	note D_,5, 14
	snd_call SndCall_BGM_3E_Ch1_0
	envelope $A8
	note A_,5, 7
	note F#,5
	note D_,5
	note A_,5
	note F#,5
	note D_,5
	note A_,5
	note F#,5
	note A_,5
	note F_,5
	note D_,5
	note A_,5
	note F_,5
	note D_,5
	note A_,5
	note F_,5
	note G_,5
	note E_,5
	note C_,5
	note G_,5
	note E_,5
	note C_,5
	note G_,5
	note E_,5
	note G_,5
	note D#,5
	note C_,5
	note G_,5
	note D#,5
	note C_,5
	note G_,5
	note D#,5
	note F#,5
	note D_,5
	note B_,4
	note E_,5
	note C#,5
	note A_,4
	note F_,5
	note D_,5
	note A#,4
	note G_,5
	note E_,5
	note C_,5
	note A_,5
	note F#,5
	note D_,5, 14
	snd_call SndCall_BGM_3E_Ch1_1
	snd_call SndCall_BGM_3E_Ch1_2
	snd_call SndCall_BGM_3E_Ch1_3
	snd_call SndCall_BGM_3E_Ch1_2
	snd_call SndCall_BGM_3E_Ch1_4
	snd_call SndCall_BGM_3E_Ch1_2
	snd_call SndCall_BGM_3E_Ch1_3
	snd_call SndCall_BGM_3E_Ch1_2
	snd_call SndCall_BGM_3E_Ch1_4
	envelope $A8
	note B_,4, 7
	note A_,4
	note G_,4, 14
	note C_,5, 7
	note B_,4
	note A_,4, 14
	note D_,5, 7
	note C_,5
	note B_,4, 14
	note E_,5, 7
	note D_,5
	note C_,5, 14
	note F#,5, 7
	note E_,5
	note D_,5, 14
	note G_,5, 7
	note F#,5
	note E_,5, 14
	note A_,5, 7
	note G_,5
	note F#,5, 14
	note B_,5, 7
	note A_,5
	note G_,5, 14
	note C_,6, 7
	note B_,5
	note G_,5
	note F_,5
	note G_,5
	note F_,5
	note D_,5
	note C_,5
	note A#,5
	note G_,5
	note F_,5
	note D_,5
	note G_,5
	note F_,5
	note D_,5
	note C_,5
	note B_,4, 7
	note D_,5
	silence 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note B_,4, 7
	note C#,5
	silence 3
	envelope $88
	note C#,5, 4
	envelope $A8
	note E_,5, 14
	note D_,5, 7
	note F#,5
	silence 3
	envelope $88
	note F#,5, 4
	envelope $A8
	note D_,5, 7
	note E_,5
	silence 3
	envelope $88
	note E_,5, 4
	envelope $A8
	note G_,5, 14
	envelope $A8
	note C_,5, 7
	note E_,5
	note G_,5
	note E_,5
	note A_,5
	note D_,5
	note F#,5
	note G_,5, 28
	continue 7
	envelope $88
	note G_,5, 7
	silence 3
	envelope $68
	note G_,5, 4
	envelope $48
	note G_,5, 7
	silence 3
	envelope $38
	note G_,5, 4
	snd_loop SndData_BGM_3E_Ch1
SndCall_BGM_3E_Ch1_0:
	envelope $A8
	note D_,5, 7
	note F_,5, 14
	note D_,5, 7
	note F_,5, 14
	note D_,5
	note C_,5
	note D_,5, 7
	note B_,4, 21
	envelope $88
	note B_,4, 7
	silence 3
	envelope $68
	note B_,4, 4
	envelope $A8
	note D_,5, 7
	note F_,5, 14
	note D_,5, 7
	note F_,5, 14
	note D_,5
	note D#,5
	note F#,5, 7
	note D#,5, 21
	envelope $88
	note D#,5, 7
	silence 3
	envelope $68
	note D#,5, 4
	envelope $A8
	note D_,5, 7
	note F_,5, 14
	note D_,5, 7
	note F_,5, 14
	note D_,5
	note C_,5
	note D_,5, 7
	note B_,4, 21
	envelope $88
	note B_,4, 7
	silence 3
	envelope $68
	note B_,4, 4
	envelope $A8
	note D_,5, 7
	note F_,5, 14
	note D_,5, 7
	note F_,5, 14
	note D_,5
	note F#,5, 7
	note G_,5
	note F#,5
	note G_,5, 21
	envelope $88
	note G_,5, 7
	silence 3
	envelope $68
	note G_,5, 4
	snd_loop SndCall_BGM_3E_Ch1_0, $00, 2
	snd_ret
SndCall_BGM_3E_Ch1_1:
	envelope $A8
	note B_,5, 7
	note G_,5
	note A#,5
	note F#,5
	note A_,5
	note F_,5
	note G#,5
	note E_,5, 14
	note C_,6, 7
	note B_,5
	note G_,5
	note C_,6
	note B_,5
	note G_,5
	note D_,5
	note B_,5, 7
	note G_,5
	note A#,5
	note F#,5
	note A_,5
	note F_,5
	note G#,5
	note E_,5, 14
	note D_,6, 7
	note C_,6
	note A#,5
	note C_,6
	note B_,5
	note G_,5
	note F_,5
	snd_loop SndCall_BGM_3E_Ch1_1, $00, 2
	snd_ret
SndCall_BGM_3E_Ch1_2:
	envelope $A8
	note D_,5, 14
	note G_,5, 7
	note E_,5
	silence 3
	envelope $88
	note E_,5, 4
	envelope $A8
	note C_,5, 7
	silence 3
	envelope $88
	note C_,5, 4
	envelope $A8
	note D_,5, 7
	silence 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note G_,4, 12
	silence 2
	note G_,4, 7
	silence 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note G_,4, 12
	silence 2
	note G_,4, 7
	snd_ret
SndCall_BGM_3E_Ch1_3:
	envelope $A8
	note C_,5, 12
	silence 2
	note C_,5, 7
	note B_,4
	silence 3
	envelope $88
	note B_,4, 4
	envelope $A8
	note B_,4, 7
	note A_,4, 14
	note B_,4
	note E_,5, 7
	note D_,5, 21
	envelope $88
	note D_,5, 7
	silence 3
	envelope $68
	note D_,5, 4
	snd_ret
SndCall_BGM_3E_Ch1_4:
	envelope $A8
	note C_,5, 5
	silence 2
	note C_,5, 7
	note C#,5
	note D_,5
	note B_,4
	note G_,4
	note A_,4
	note G_,4, 28
	continue 7
	envelope $88
	note G_,4, 7
	silence 3
	envelope $68
	note G_,4, 4
	envelope $48
	note G_,4, 7
	silence 3
	envelope $38
	note G_,4, 4
	snd_ret
SndData_BGM_3E_Ch2:
	envelope $11
	panning $22
	duty_cycle 1
	vibrato_on $01
	snd_call SndCall_BGM_3E_Ch2_0
	snd_call SndCall_BGM_3E_Ch2_1
	snd_call SndCall_BGM_3E_Ch2_0
	snd_call SndCall_BGM_3E_Ch2_2
	fine_tune 12
	snd_call SndCall_BGM_3E_Ch2_0
	snd_call SndCall_BGM_3E_Ch2_1
	snd_call SndCall_BGM_3E_Ch2_0
	snd_call SndCall_BGM_3E_Ch2_2
	fine_tune -12
	snd_call SndCall_BGM_3E_Ch2_3
	snd_call SndCall_BGM_3E_Ch2_4
	snd_call SndCall_BGM_3E_Ch2_3
	snd_call SndCall_BGM_3E_Ch2_5
	snd_call SndCall_BGM_3E_Ch2_3
	snd_call SndCall_BGM_3E_Ch2_4
	snd_call SndCall_BGM_3E_Ch2_3
	snd_call SndCall_BGM_3E_Ch2_6
	snd_call SndCall_BGM_3E_Ch2_3
	snd_call SndCall_BGM_3E_Ch2_4
	snd_call SndCall_BGM_3E_Ch2_3
	snd_call SndCall_BGM_3E_Ch2_5
	snd_call SndCall_BGM_3E_Ch2_3
	snd_call SndCall_BGM_3E_Ch2_4
	snd_call SndCall_BGM_3E_Ch2_3
	snd_call SndCall_BGM_3E_Ch2_6
	envelope $A8
	note F#,5, 3
	envelope $88
	note A_,5, 4
	envelope $A8
	note D_,5, 3
	envelope $88
	note F#,5, 4
	envelope $A8
	note A_,4, 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note F#,5, 3
	envelope $88
	note A_,4, 4
	envelope $A8
	note D_,5, 3
	envelope $88
	note F#,5, 4
	envelope $A8
	note D_,5, 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note F#,5, 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note D_,5, 3
	envelope $88
	note F#,5, 4
	envelope $A8
	note F_,5, 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note D_,5, 3
	envelope $88
	note F_,5, 4
	envelope $A8
	note B_,4, 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note F_,5, 3
	envelope $88
	note B_,4, 4
	envelope $A8
	note D_,5, 3
	envelope $88
	note F_,5, 4
	envelope $A8
	note B_,4, 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note F_,5, 3
	envelope $88
	note B_,4, 4
	envelope $A8
	note D_,5, 3
	envelope $88
	note F_,5, 4
	snd_call SndCall_BGM_3E_Ch2_7
	snd_call SndCall_BGM_3E_Ch2_8
	envelope $A8
	note D_,5, 3
	envelope $88
	note C_,5, 4
	envelope $A8
	note B_,4, 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note G_,4, 3
	envelope $88
	note B_,4, 4
	envelope $A8
	note C#,5, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note A_,4, 3
	envelope $88
	note C#,5, 4
	envelope $A8
	note E_,4, 3
	envelope $88
	note A_,4, 4
	envelope $A8
	note D_,5, 3
	envelope $88
	note E_,4, 4
	envelope $A8
	note A#,4, 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note G_,4, 3
	envelope $88
	note A#,4, 4
	envelope $A8
	note E_,5, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note C_,5, 3
	envelope $88
	note E_,5, 4
	envelope $A8
	note G_,4, 3
	envelope $88
	note C_,5, 4
	envelope $A8
	note F#,5, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note D_,5, 3
	envelope $88
	note F#,5, 4
	envelope $A8
	note A_,4, 7
	silence 3
	envelope $88
	note A_,4, 4
	snd_call SndCall_BGM_3E_Ch2_9
	snd_call SndCall_BGM_3E_Ch2_A
	snd_call SndCall_BGM_3E_Ch2_9
	snd_call SndCall_BGM_3E_Ch2_B
	snd_call SndCall_BGM_3E_Ch2_9
	snd_call SndCall_BGM_3E_Ch2_A
	snd_call SndCall_BGM_3E_Ch2_9
	snd_call SndCall_BGM_3E_Ch2_B
	snd_call SndCall_BGM_3E_Ch2_C
	snd_call SndCall_BGM_3E_Ch2_D
	snd_call SndCall_BGM_3E_Ch2_C
	snd_call SndCall_BGM_3E_Ch2_E
	snd_call SndCall_BGM_3E_Ch2_C
	snd_call SndCall_BGM_3E_Ch2_D
	snd_call SndCall_BGM_3E_Ch2_C
	snd_call SndCall_BGM_3E_Ch2_E
	envelope $A8
	note G_,4, 3
	silence 4
	note F#,4, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note E_,4, 7
	silence 3
	envelope $88
	note E_,4, 4
	envelope $A8
	note A_,4, 3
	silence 4
	note G_,4, 3
	envelope $88
	note A_,4, 4
	envelope $A8
	note F#,4, 7
	silence 3
	envelope $88
	note F#,4, 4
	envelope $A8
	note B_,4, 3
	silence 4
	note A_,4, 3
	envelope $88
	note B_,4, 4
	envelope $A8
	note G_,4, 7
	silence 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note C_,5, 3
	silence 4
	note B_,4, 3
	envelope $88
	note C_,5, 4
	envelope $A8
	note A_,4, 7
	silence 3
	envelope $88
	note A_,4, 4
	envelope $A8
	note D_,5, 3
	silence 4
	note C_,5, 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note B_,4, 7
	silence 3
	envelope $88
	note B_,4, 4
	envelope $A8
	note E_,5, 3
	silence 4
	note D_,5, 3
	envelope $88
	note E_,5, 4
	envelope $A8
	note C_,5, 7
	silence 3
	envelope $88
	note C_,5, 4
	envelope $A8
	note F#,5, 3
	silence 4
	note E_,5, 3
	envelope $88
	note F#,5, 4
	envelope $A8
	note D_,5, 7
	silence 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note G_,5, 3
	silence 4
	note F#,5, 3
	envelope $88
	note G_,5, 4
	envelope $A8
	note E_,5, 7
	silence 3
	envelope $88
	note E_,5, 4
	envelope $A8
	note G_,5, 7
	note F_,5, 3
	envelope $88
	note G_,5, 4
	envelope $A8
	note D_,5, 3
	envelope $88
	note F_,5, 4
	envelope $A8
	note C_,5, 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note D_,5, 3
	envelope $88
	note C_,5, 4
	envelope $A8
	note C#,5, 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note C_,5, 3
	envelope $88
	note C#,5, 4
	envelope $A8
	note G_,4, 3
	envelope $88
	note C_,5, 4
	envelope $A8
	note D_,5, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note D_,5, 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note C_,5, 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note A#,4, 3
	envelope $88
	note C_,5, 4
	envelope $A8
	note D_,5, 3
	envelope $88
	note A#,4, 4
	envelope $A8
	note D_,5, 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note A_,4, 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note G_,4, 3
	envelope $88
	note A_,4, 4
	envelope $A8
	note G_,4, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note B_,4, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note A#,4, 3
	envelope $88
	note B_,4, 4
	envelope $A8
	note G_,4, 3
	envelope $88
	note A#,4, 4
	envelope $A8
	note A_,4, 7
	envelope $68
	note A#,4, 3
	envelope $88
	note A_,4, 4
	envelope $A8
	note C#,5, 7
	silence 3
	envelope $88
	note C#,5, 4
	envelope $A8
	note B_,4, 3
	silence 4
	note D_,5, 3
	envelope $88
	note B_,4, 4
	envelope $A8
	note C#,5, 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note B_,4, 3
	envelope $88
	note C#,5, 4
	envelope $A8
	note C_,5, 7
	envelope $68
	note C#,5, 3
	envelope $88
	note C_,5, 4
	envelope $A8
	note E_,5, 7
	silence 3
	envelope $88
	note E_,5, 4
	envelope $A8
	note G_,4, 7
	note C_,5, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note E_,5, 3
	envelope $88
	note C_,5, 4
	envelope $A8
	note C_,5, 3
	envelope $88
	note E_,5, 4
	envelope $A8
	note F#,5, 3
	envelope $88
	note C_,5, 4
	envelope $A8
	note B_,4, 3
	envelope $88
	note F#,5, 4
	envelope $A8
	note D_,5, 3
	envelope $88
	note B_,4, 4
	envelope $A8
	note B_,4, 11
	envelope $88
	note B_,4, 3
	envelope $A8
	note A_,4, 7
	note G_,4, 3
	envelope $88
	note A_,4, 4
	envelope $A8
	note F#,4, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note E_,4, 3
	envelope $88
	note F#,4, 4
	envelope $A8
	note D_,4, 3
	envelope $88
	note E_,4, 4
	envelope $A8
	note C_,4, 3
	envelope $88
	note D_,4, 4
	envelope $A8
	note A_,3, 3
	envelope $88
	note C_,4, 4
	snd_loop SndData_BGM_3E_Ch2
SndCall_BGM_3E_Ch2_0:
	envelope $A8
	note B_,3, 5
	silence 2
	note C_,4, 3
	envelope $88
	note B_,3, 4
	envelope $A8
	note C#,4, 3
	envelope $88
	note C_,4, 4
	envelope $A8
	note D_,4, 3
	envelope $88
	note C#,4, 4
	envelope $A8
	note D_,4, 5
	silence 2
	silence 3
	envelope $88
	note D_,4, 4
	snd_loop SndCall_BGM_3E_Ch2_0, $00, 2
	snd_ret
SndCall_BGM_3E_Ch2_1:
	envelope $A8
	note A#,3, 5
	silence 2
	note A_,3, 3
	envelope $88
	note A#,3, 4
	envelope $A8
	note G_,3, 5
	silence 2
	silence 3
	envelope $88
	note G_,3, 4
	snd_ret
SndCall_BGM_3E_Ch2_2:
	envelope $A3
	note G_,3, 5
	silence 2
	note A_,3, 3
	envelope $88
	note G_,3, 4
	envelope $A3
	note A_,3, 5
	silence 2
	silence 3
	envelope $88
	note A_,3, 4
	snd_ret
SndCall_BGM_3E_Ch2_3:
	envelope $A2
	note B_,4, 7
	note D_,5
	note G_,4
	note B_,4
	note D_,5
	note G_,4
	note B_,4
	note G_,4
	snd_ret
SndCall_BGM_3E_Ch2_4:
	note A_,4, 7
	note F_,4
	note B_,4
	note G_,4, 14
	note F#,4, 7
	note E_,4
	note D_,4
	snd_ret
SndCall_BGM_3E_Ch2_5:
	note C_,5, 7
	note G_,4
	note D#,5
	note C_,5, 14
	note A_,4, 7
	note F#,4
	note D#,4
	snd_ret
SndCall_BGM_3E_Ch2_6:
	note C#,5, 7
	note D_,5
	note C#,5
	note D_,5, 14
	duty_cycle 2
	envelope $A2
	note B_,5, 7
	note A#,5, 3
	envelope $82
	note B_,5, 4
	envelope $A2
	note A_,5, 3
	envelope $82
	note A#,5, 4
	duty_cycle 1
	snd_ret
SndCall_BGM_3E_Ch2_7:
	envelope $A8
	note E_,5, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note C_,5, 3
	envelope $88
	note E_,5, 4
	envelope $A8
	note G_,4, 3
	envelope $88
	note C_,5, 4
	snd_loop SndCall_BGM_3E_Ch2_7, $00, 2
	envelope $A8
	note E_,5, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note C_,5, 3
	envelope $88
	note E_,5, 4
	snd_ret
SndCall_BGM_3E_Ch2_8:
	envelope $A8
	note D_,5, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note C_,5, 3
	envelope $88
	note D#,5, 4
	envelope $A8
	note G_,4, 3
	envelope $88
	note C_,5, 4
	snd_loop SndCall_BGM_3E_Ch2_8, $00, 2
	envelope $A8
	note D_,5, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note C_,5, 3
	envelope $88
	note D#,5, 4
	snd_ret
SndCall_BGM_3E_Ch2_9:
	envelope $A8
	note G_,5, 3
	silence 4
	note E_,5, 3
	envelope $88
	note G_,5, 4
	envelope $A8
	note F#,5, 3
	envelope $88
	note E_,5, 4
	envelope $A8
	note D#,5, 3
	envelope $88
	note F#,5, 4
	envelope $A8
	note F_,5, 3
	envelope $88
	note D#,5, 4
	envelope $A8
	note D_,5, 3
	envelope $88
	note F_,5, 4
	envelope $A8
	note E_,5, 3
	envelope $88
	note D_,5, 4
	envelope $A8
	note C#,5, 7
	silence 3
	envelope $88
	note C#,5, 4
	snd_ret
SndCall_BGM_3E_Ch2_A:
	envelope $A8
	note G_,5, 5
	silence 2
	note G_,5, 3
	envelope $88
	note G_,5, 4
	envelope $A8
	note D_,5, 3
	envelope $88
	note G_,5, 4
	envelope $A8
	note G_,5, 3
	envelope $88
	note D_,5, 4
	duty_cycle 2
	envelope $A2
	note F_,5, 7
	note F#,5
	note G_,5
	duty_cycle 1
	snd_ret
SndCall_BGM_3E_Ch2_B:
	envelope $A8
	note A#,5, 5
	silence 2
	note A_,5, 3
	envelope $88
	note A#,5, 4
	envelope $A8
	note G_,5, 3
	envelope $88
	note A_,5, 4
	duty_cycle 2
	envelope $A2
	note A_,4, 7
	note D_,5
	note F_,5
	note A#,5
	duty_cycle 1
	snd_ret
SndCall_BGM_3E_Ch2_C:
	envelope $A8
	note B_,4, 3
	silence 4
	note G_,4, 3
	envelope $88
	note B_,4, 4
	envelope $A8
	note D_,4, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note C_,5, 3
	envelope $88
	note D_,4, 4
	envelope $A8
	note G_,4, 3
	envelope $88
	note C_,5, 4
	envelope $A8
	note E_,4, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note A_,4, 3
	envelope $88
	note E_,4, 4
	envelope $A8
	note B_,4, 3
	envelope $88
	note A_,4, 4
	envelope $A8
	note G_,4, 3
	envelope $88
	note B_,4, 4
	envelope $A8
	note D_,4, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note B_,3, 3
	envelope $88
	note D_,4, 4
	envelope $A8
	note G_,3, 3
	envelope $88
	note B_,3, 4
	envelope $A8
	note D_,3, 3
	envelope $88
	note G_,3, 4
	envelope $A8
	note B_,3, 3
	envelope $88
	note D_,3, 4
	envelope $A8
	note D_,4, 3
	envelope $88
	note B_,3, 4
	envelope $A8
	note G_,4, 3
	envelope $88
	note D_,4, 4
	snd_ret
SndCall_BGM_3E_Ch2_D:
	envelope $A8
	note A_,4, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note G_,4, 3
	envelope $88
	note A_,4, 4
	envelope $A8
	note E_,4, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note G_,4, 3
	envelope $88
	note E_,4, 4
	envelope $A8
	note E_,4, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note C_,4, 3
	envelope $88
	note E_,4, 4
	envelope $A8
	note F#,4, 3
	envelope $88
	note C_,4, 4
	envelope $A8
	note D_,4, 3
	envelope $88
	note F#,4, 4
	envelope $A8
	note G_,4, 3
	envelope $88
	note D_,4, 4
	envelope $A8
	note D_,4, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note C_,5, 3
	envelope $88
	note D_,4, 4
	envelope $A8
	note A_,4, 3
	envelope $88
	note C_,5, 4
	envelope $A8
	note F#,4, 3
	envelope $88
	note A_,4, 4
	envelope $A8
	note D_,4, 3
	envelope $88
	note F#,4, 4
	envelope $A8
	note C_,4, 3
	envelope $88
	note D_,4, 4
	envelope $A8
	note A_,3, 3
	envelope $88
	note C_,4, 4
	snd_ret
SndCall_BGM_3E_Ch2_E:
	envelope $A8
	note G_,4, 3
	envelope $88
	note B_,3, 4
	envelope $A8
	note A_,4, 3
	envelope $88
	note G_,4, 4
	envelope $A8
	note A#,4, 3
	envelope $88
	note A_,4, 4
	envelope $A8
	note B_,4, 3
	envelope $88
	note A#,4, 4
	envelope $A8
	note F_,4, 3
	envelope $88
	note B_,4, 4
	envelope $A8
	note D_,4, 3
	envelope $88
	note F_,4, 4
	envelope $A8
	note E_,4, 3
	envelope $88
	note D_,4, 4
	envelope $A8
	note D_,4, 14
	note G_,3, 7
	note B_,3, 3
	envelope $88
	note G_,3, 4
	envelope $A8
	note C_,4, 3
	envelope $88
	note B_,3, 4
	envelope $A8
	note D_,4, 3
	envelope $88
	note C_,4, 4
	envelope $A8
	note E_,4, 3
	envelope $88
	note D_,4, 4
	envelope $A8
	note F#,4, 3
	envelope $88
	note E_,4, 4
	envelope $A8
	note A_,4, 3
	envelope $88
	note F#,4, 4
	snd_ret
SndData_BGM_3E_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	wave_cutoff 0
	snd_call SndCall_BGM_3E_Ch3_0
	note B_,3, 14
	note C_,4
	snd_call SndCall_BGM_3E_Ch3_0
	note F_,4, 14
	note E_,4
	snd_call SndCall_BGM_3E_Ch3_0
	note B_,3, 14
	note C_,4
	snd_call SndCall_BGM_3E_Ch3_0
	note F_,4, 14
	note E_,4
	snd_call SndCall_BGM_3E_Ch3_1
	snd_call SndCall_BGM_3E_Ch3_2
	snd_call SndCall_BGM_3E_Ch3_1
	snd_call SndCall_BGM_3E_Ch3_3
	snd_call SndCall_BGM_3E_Ch3_1
	snd_call SndCall_BGM_3E_Ch3_2
	snd_call SndCall_BGM_3E_Ch3_1
	snd_call SndCall_BGM_3E_Ch3_3
	note D_,4, 7
	note F#,3, 12
	silence 2
	note F#,3, 7
	silence
	note F#,3
	note D_,4
	note F#,3
	note F_,4
	note F_,3, 12
	silence 2
	note A_,3, 7
	silence
	note A_,3, 5
	silence 2
	note F_,4, 5
	silence 2
	note A_,3, 7
	note C_,4, 7
	note G_,3, 12
	silence 2
	note G_,3, 7
	silence
	note C_,4
	note D_,4
	note C_,4
	note D#,4, 5
	silence 2
	note G_,3, 14
	note C_,4, 7
	silence
	note D#,4, 5
	silence 2
	note D#,4, 5
	silence 2
	note D#,4, 5
	silence 2
	note B_,3, 14
	note F#,3, 7
	note A_,3, 14
	note E_,3, 7
	note A#,3, 14
	note F_,3, 7
	note C_,4, 14
	note G_,3, 7
	note D_,4
	silence
	note D_,4, 14
	snd_call SndCall_BGM_3E_Ch3_4
	snd_call SndCall_BGM_3E_Ch3_5
	snd_call SndCall_BGM_3E_Ch3_6
	snd_call SndCall_BGM_3E_Ch3_5
	snd_call SndCall_BGM_3E_Ch3_7
	snd_call SndCall_BGM_3E_Ch3_5
	snd_call SndCall_BGM_3E_Ch3_6
	snd_call SndCall_BGM_3E_Ch3_5
	snd_call SndCall_BGM_3E_Ch3_7
	note G_,3, 7
	note B_,3, 14
	note G_,3, 7
	note A_,3
	note F#,3, 14
	note A_,3, 7
	note B_,3
	note G_,3, 14
	note B_,3, 7
	note C_,4
	note E_,3
	note G_,3
	note C_,4
	note D_,4
	note F#,3, 14
	note D_,4, 7
	note E_,4
	note A_,3, 14
	note E_,4, 7
	note F#,4
	note A_,3
	note D_,4
	note F#,3
	note G_,3
	note A_,3, 14
	note B_,3, 7
	note C_,4
	note G_,3
	note A#,3
	note C_,4
	silence
	note C_,4
	note G_,3
	note C_,4
	note A#,3
	note F_,3
	note G_,3
	note A#,3
	silence
	note A#,3
	note F_,3, 14
	note G_,3, 7
	silence
	note G_,3, 14
	note A_,3, 7
	silence
	note A_,3, 14
	note B_,3, 7
	silence
	note B_,3, 14
	note C_,4, 7
	silence
	note E_,3
	note A_,3
	note C_,4
	note A_,3
	note B_,3
	note C_,4
	note D_,4
	note E_,4
	note F#,4
	note G_,4
	silence
	note G_,4
	note B_,3
	note G_,4, 5
	silence 2
	note G_,4, 7
	note F#,4
	note E_,4
	note D_,4
	snd_loop SndData_BGM_3E_Ch3
SndCall_BGM_3E_Ch3_0:
	note G_,3, 14
	note D_,4, 3
	silence 4
	note G_,3, 3
	silence 4
	note G_,3, 14
	note D_,4, 7
	note G_,3, 14
	note F#,3, 7
	note G_,3, 14
	snd_ret
SndCall_BGM_3E_Ch3_1:
	note B_,3, 14
	silence 7
	note G_,3, 21
	note B_,3, 5
	silence 2
	note B_,3, 5
	silence 2
	note C_,4, 14
	silence 7
	note C_,4, 19
	silence 2
	note G_,3, 5
	silence 2
	note C_,4, 5
	silence 2
	note D_,4, 14
	silence 7
	note G_,3, 19
	silence 2
	note D_,4, 5
	silence 2
	note D_,4, 5
	silence 2
	snd_ret
SndCall_BGM_3E_Ch3_2:
	note D#,4, 14
	silence 7
	note G_,3, 19
	silence 2
	note D#,4, 5
	silence 2
	note D#,4, 5
	silence 2
	snd_ret
SndCall_BGM_3E_Ch3_3:
	note G_,3, 5
	silence 2
	note G_,3, 7
	silence
	note G_,3
	silence
	note G_,3
	note F#,3
	note G_,3
	snd_ret
SndCall_BGM_3E_Ch3_4:
	note F_,4, 7
	note F_,3
	silence
	note F_,3
	silence
	note F_,3
	note F_,4
	note F_,3
	note G_,3, 5
	silence 2
	note G_,3, 12
	silence 2
	note G_,3, 12
	silence 2
	note G_,3, 7
	note F#,3
	note G_,3
	note F_,4, 7
	note F_,3
	silence
	note F_,3
	silence
	note F_,3
	note F_,4
	note F_,3
	note C_,4, 5
	silence 2
	note C_,4, 12
	silence 2
	note D_,4, 12
	silence 2
	note D_,4, 7
	note C_,4
	note D_,4
	snd_loop SndCall_BGM_3E_Ch3_4, $00, 2
	snd_ret
SndCall_BGM_3E_Ch3_5:
	note G_,3, 14
	note D_,3, 7
	note G_,3
	silence
	note G_,3
	note B_,3
	note C_,4
	snd_loop SndCall_BGM_3E_Ch3_5, $00, 2
	snd_ret
SndCall_BGM_3E_Ch3_6:
	note C_,4, 14
	note G_,3, 7
	note C_,4
	silence
	note C_,4
	note B_,3
	note C_,4
	note D_,4, 14
	note A_,3, 7
	note D_,4
	silence
	note D_,4
	note C_,4
	note A_,3
	snd_ret
SndCall_BGM_3E_Ch3_7:
	note C_,4, 7
	note E_,3
	note G_,3
	note C_,4
	note D_,4
	note A_,3
	note D_,4
	note F#,3
	note G_,3, 12
	silence 2
	note G_,3, 5
	silence 2
	note G_,3, 7
	silence
	note G_,3
	note B_,3
	note D_,4
	snd_ret
SndData_BGM_3E_Ch4:
	panning $88
	snd_call SndCall_BGM_3E_Ch4_0
	snd_call SndCall_BGM_3E_Ch4_1
	snd_call SndCall_BGM_3E_Ch4_2
	snd_call SndCall_BGM_3E_Ch4_1
	snd_call SndCall_BGM_3E_Ch4_3
	snd_call SndCall_BGM_3E_Ch4_1
	snd_call SndCall_BGM_3E_Ch4_2
	snd_call SndCall_BGM_3E_Ch4_1
	snd_call SndCall_BGM_3E_Ch4_4
	snd_call SndCall_BGM_3E_Ch4_5
	snd_call SndCall_BGM_3E_Ch4_6
	snd_call SndCall_BGM_3E_Ch4_5
	snd_call SndCall_BGM_3E_Ch4_7
	snd_call SndCall_BGM_3E_Ch4_5
	snd_call SndCall_BGM_3E_Ch4_6
	snd_call SndCall_BGM_3E_Ch4_5
	snd_call SndCall_BGM_3E_Ch4_4
	snd_call SndCall_BGM_3E_Ch4_8
	snd_call SndCall_BGM_3E_Ch4_9
	snd_call SndCall_BGM_3E_Ch4_A
	snd_call SndCall_BGM_3E_Ch4_9
	snd_call SndCall_BGM_3E_Ch4_B
	snd_call SndCall_BGM_3E_Ch4_9
	snd_call SndCall_BGM_3E_Ch4_A
	snd_call SndCall_BGM_3E_Ch4_9
	snd_call SndCall_BGM_3E_Ch4_B
	snd_call SndCall_BGM_3E_Ch4_C
	snd_call SndCall_BGM_3E_Ch4_D
	snd_call SndCall_BGM_3E_Ch4_C
	snd_call SndCall_BGM_3E_Ch4_E
	snd_call SndCall_BGM_3E_Ch4_C
	snd_call SndCall_BGM_3E_Ch4_D
	snd_call SndCall_BGM_3E_Ch4_C
	snd_call SndCall_BGM_3E_Ch4_F
	snd_call SndCall_BGM_3E_Ch4_C
	snd_call SndCall_BGM_3E_Ch4_D
	snd_call SndCall_BGM_3E_Ch4_C
	snd_call SndCall_BGM_3E_Ch4_E
	snd_call SndCall_BGM_3E_Ch4_C
	snd_call SndCall_BGM_3E_Ch4_D
	snd_call SndCall_BGM_3E_Ch4_C
	snd_call SndCall_BGM_3E_Ch4_F
	snd_call SndCall_BGM_3E_Ch4_10
.loop0:
	envelope $A1
	note4 A_,5,0, 7
	snd_loop .loop0, $00, 6
	envelope $C1
	note4 G#,4,0, 7
	note4 G#,4,0, 7
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	envelope $C1
	note4 G#,4,0, 7
	note4 G#,4,0, 7
	note4 G#,4,0, 7
	note4 G#,4,0, 7
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	snd_call SndCall_BGM_3E_Ch4_11
	envelope $C1
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $A1
	note4 A_,5,0, 7
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 7
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	envelope $C1
	note4 G#,4,0, 7
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	envelope $91
	note4 G_,5,0, 7
	envelope $91
	note4 F#,5,0, 7
	envelope $91
	note4 E_,5,0, 7
	snd_loop SndData_BGM_3E_Ch4
SndCall_BGM_3E_Ch4_0:
	envelope $C1
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $A1
	note4 A_,5,0, 7
	envelope $C1
	note4 G#,4,0, 7
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $A1
	note4 A_,5,0, 14
	envelope $C1
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $A1
	note4 A_,5,0, 7
	envelope $C1
	note4 G#,4,0, 7
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $A1
	note4 A_,5,0, 7
	envelope $C1
	note4 G#,4,0, 7
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $A1
	note4 A_,5,0, 14
	envelope $C1
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $A1
	note4 A_,5,0, 7
	envelope $C1
	note4 G#,4,0, 7
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	envelope $91
	note4 G_,5,0, 7
	envelope $91
	note4 E_,5,0, 7
	snd_loop SndCall_BGM_3E_Ch4_0, $00, 2
	snd_ret
SndCall_BGM_3E_Ch4_1:
	envelope $C1
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $53
	note4x $13, 14 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 14
	envelope $51
	note4 C_,6,0, 7
	envelope $C1
	note4 G#,4,0, 7
	snd_ret
SndCall_BGM_3E_Ch4_2:
	envelope $C1
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $53
	note4x $13, 14 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 14
	envelope $51
	note4 C_,6,0, 7
	envelope $A1
	note4 A_,5,0, 7
	snd_ret
SndCall_BGM_3E_Ch4_3:
	envelope $C1
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $53
	note4x $13, 14 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 14
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	snd_ret
SndCall_BGM_3E_Ch4_4:
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	note4 A_,5,0, 14
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	snd_ret
SndCall_BGM_3E_Ch4_5:
	envelope $C1
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $A1
	note4 A_,5,0, 14
	envelope $C1
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $A1
	note4 A_,5,0, 7
	envelope $C1
	note4 G#,4,0, 7
	snd_ret
SndCall_BGM_3E_Ch4_6:
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 7
	envelope $A1
	note4 A_,5,0, 14
	envelope $51
	note4 C_,6,0, 7
	envelope $C1
	note4 G#,4,0, 7
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	snd_ret
SndCall_BGM_3E_Ch4_7:
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 7
	envelope $A1
	note4 A_,5,0, 14
	envelope $51
	note4 C_,6,0, 7
	envelope $C1
	note4 G#,4,0, 7
	envelope $A1
	note4 A_,5,0, 7
	envelope $C1
	note4 G#,4,0, 7
	snd_ret
SndCall_BGM_3E_Ch4_8:
	envelope $91
	note4 G_,5,0, 7
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	envelope $91
	note4 F#,5,0, 7
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	envelope $91
	note4 E_,5,0, 7
	envelope $C1
	note4 G#,4,0, 7
	snd_loop SndCall_BGM_3E_Ch4_8, $00, 4
	envelope $C1
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 7
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 7
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	snd_ret
SndCall_BGM_3E_Ch4_9:
	envelope $C1
	note4 G#,4,0, 7
	note4 G#,4,0, 7
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	envelope $C1
	note4 G#,4,0, 7
	note4 G#,4,0, 7
	snd_ret
SndCall_BGM_3E_Ch4_A:
	envelope $51
	note4 C_,6,0, 7
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 7
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	envelope $C1
	note4 G#,4,0, 7
	envelope $A1
	note4 A_,5,0, 7
	envelope $C1
	note4 G#,4,0, 7
	snd_ret
SndCall_BGM_3E_Ch4_B:
	envelope $51
	note4 C_,6,0, 7
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 7
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	envelope $91
	note4 G_,5,0, 7
	envelope $91
	note4 F#,5,0, 7
	envelope $91
	note4 E_,5,0, 7
	snd_ret
SndCall_BGM_3E_Ch4_C:
	envelope $C1
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $A1
	note4 A_,5,0, 7
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	snd_loop SndCall_BGM_3E_Ch4_C, $00, 2
	snd_ret
SndCall_BGM_3E_Ch4_D:
	envelope $C1
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $A1
	note4 A_,5,0, 7
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	snd_ret
SndCall_BGM_3E_Ch4_E:
	envelope $C1
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $A1
	note4 A_,5,0, 7
	envelope $91
	note4 G_,5,0, 7
	envelope $C1
	note4 G#,4,0, 7
	envelope $91
	note4 F#,5,0, 7
	envelope $A1
	note4 A_,5,0, 7
	envelope $91
	note4 E_,5,0, 7
	snd_ret
SndCall_BGM_3E_Ch4_F:
	envelope $C1
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $A1
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	note4 A_,5,0, 7
	snd_ret
SndCall_BGM_3E_Ch4_10:
	envelope $A1
	note4 A_,5,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 7
	note4 G#,4,0, 7
	envelope $51
	note4 C_,6,0, 7
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 7
	snd_loop SndCall_BGM_3E_Ch4_10, $00, 4
	snd_ret
SndCall_BGM_3E_Ch4_11:
	envelope $C1
	note4 G#,4,0, 7
	envelope $53
	note4x $13, 7 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 7
	envelope $C1
	note4 G#,4,0, 7
	note4 G#,4,0, 7
	envelope $91
	note4 G_,5,0, 7
	envelope $A1
	note4 A_,5,0, 7
	envelope $91
	note4 E_,5,0, 7
	snd_loop SndCall_BGM_3E_Ch4_11, $00, 2
	snd_ret
