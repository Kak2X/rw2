SndHeader_BGM_0A:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_0A_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_0A_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_0A_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_0A_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_BGM_0A_Ch1:
	envelope $A8
	panning $11
	duty_cycle 2
	vibrato_on $01
	snd_call SndCall_BGM_0A_Ch1_1
	snd_call SndCall_BGM_0A_Ch1_2
	snd_call SndCall_BGM_0A_Ch1_3
	fine_tune 5
	snd_call SndCall_BGM_0A_Ch1_3
	fine_tune -5
	snd_call SndCall_BGM_0A_Ch1_4
	snd_call SndCall_BGM_0A_Ch1_7
	snd_call SndCall_BGM_0A_Ch1_0
	snd_loop SndData_BGM_0A_Ch1
SndCall_BGM_0A_Ch1_0:
	snd_call SndCall_BGM_0A_Ch1_5
	envelope $A8
	note A#,3, 10
	note C#,4, 5
	silence 2
	envelope $88
	note C#,4, 3
	envelope $A8
	note A#,3, 10
	note D#,4
	note C#,4, 5
	silence 2
	envelope $88
	note C#,4, 3
	envelope $A8
	note A#,3, 20
	snd_call SndCall_BGM_0A_Ch1_5
	envelope $A8
	note A#,3, 10
	note C#,4, 5
	silence 2
	envelope $88
	note C#,4, 3
	envelope $A8
	note A#,3, 10
	note E_,4
	note D#,4
	note C#,4, 5
	silence 2
	envelope $88
	note C#,4, 3
	envelope $A8
	note D#,4, 10
	snd_call SndCall_BGM_0A_Ch1_5
	envelope $A8
	note A#,3, 10
	note C#,4, 5
	silence 2
	envelope $88
	note C#,4, 3
	envelope $A8
	note A#,3, 10
	note D#,4
	note C#,4, 5
	silence 2
	envelope $88
	note C#,4, 3
	envelope $A8
	note A#,3, 20
	snd_call SndCall_BGM_0A_Ch1_5
	envelope $A8
	note A#,4, 15
	silence 2
	envelope $88
	note A#,4, 3
	envelope $A8
	note A#,4, 15
	silence 2
	envelope $88
	note A#,4, 3
	envelope $A8
	note A#,4, 15
	silence 2
	envelope $88
	note A#,4, 3
	envelope $A8
	note A#,4, 15
	silence 2
	envelope $88
	note A#,4, 3
	envelope $A8
	note D#,5, 5
	silence 2
	envelope $88
	note D#,5, 3
	envelope $A8
	note D#,5, 8
	silence 2
	note D#,5, 8
	silence 2
	note D#,5, 10
	note E_,5
	note F_,5, 20
	snd_call SndCall_BGM_0A_Ch1_6
	fine_tune -5
	snd_call SndCall_BGM_0A_Ch1_6
	fine_tune 5
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $88
	note D#,4, 3
	envelope $A8
	note C#,4, 15
	silence 2
	envelope $88
	note C#,4, 3
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $88
	note D#,4, 3
	envelope $A8
	note C#,4, 15
	silence 2
	envelope $88
	note C#,4, 3
	fine_tune -12
	snd_call SndCall_BGM_0A_Ch1_6
	fine_tune 12
	snd_call SndCall_BGM_0A_Ch1_6
	fine_tune -5
	snd_call SndCall_BGM_0A_Ch1_6
	fine_tune 5
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $88
	note D#,4, 3
	envelope $A8
	note C#,4, 15
	silence 2
	envelope $88
	note C#,4, 3
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $88
	note D#,4, 3
	envelope $A8
	note C#,4, 15
	silence 2
	envelope $88
	note C#,4, 3
	fine_tune -12
	envelope $A8
	note C#,5, 5
	silence 2
	envelope $88
	note C#,5, 3
	envelope $A8
	note A#,4, 15
	silence 2
	envelope $88
	note A#,4, 3
	fine_tune 12
	envelope $A8
	note C#,4, 5
	silence 2
	envelope $88
	note C#,4, 3
	envelope $A8
	note A#,3, 30
	envelope $88
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $A8
	note G#,4, 20
	envelope $88
	note G#,4, 5
	silence 2
	envelope $68
	note G#,4, 3
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $68
	note D#,4, 3
	envelope $A8
	note E_,4, 10
	note F_,4
	snd_ret
SndCall_BGM_0A_Ch1_1:
	envelope $A8
	note F_,4, 10
	note E_,4, 5
	silence 2
	envelope $88
	note E_,4, 3
	envelope $A8
	note C#,4, 10
	note A#,3, 20
	envelope $88
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $A8
	note F_,4, 10
	note E_,4, 5
	silence 2
	envelope $88
	note E_,4, 3
	envelope $A8
	note C#,4, 10
	note A#,3
	envelope $88
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $A8
	note F_,4, 20
	note A#,3, 5
	silence 2
	envelope $88
	note A#,3, 3
	envelope $A8
	note C#,4, 10
	note E_,4
	envelope $A8
	note F_,4, 10
	note G_,4, 5
	silence 2
	envelope $88
	note G_,4, 3
	envelope $A8
	note G#,4, 10
	note A#,4, 20
	note G#,4, 10
	note G_,4
	note F_,4
	envelope $A8
	note G_,4, 5
	silence 2
	envelope $88
	note G_,4, 3
	envelope $A8
	note E_,4, 5
	silence 2
	envelope $88
	note E_,4, 3
	envelope $A8
	note F_,4, 10
	note G_,4
	note G#,4
	note A#,4
	envelope $A8
	note C_,5, 15
	silence 2
	envelope $88
	note C_,5, 3
	snd_loop SndCall_BGM_0A_Ch1_1, $00, 2
	snd_ret
SndCall_BGM_0A_Ch1_2:
	envelope $A8
	note C#,5, 5
	silence 2
	envelope $88
	note C#,5, 3
	envelope $A8
	note A#,4, 20
	envelope $A8
	note C#,5, 5
	silence 2
	envelope $88
	note C#,5, 3
	envelope $A8
	note A#,4, 20
	envelope $A8
	note D_,5, 5
	silence 2
	envelope $88
	note D_,5, 3
	envelope $A8
	note A#,4, 20
	envelope $A8
	note D_,5, 5
	silence 2
	envelope $88
	note D_,5, 3
	envelope $A8
	note A#,4, 20
	envelope $A8
	note D#,5, 5
	silence 2
	envelope $88
	note D#,5, 3
	envelope $A8
	note A#,4, 20
	envelope $A8
	note D#,5, 5
	silence 2
	envelope $88
	note D#,5, 3
	envelope $A8
	note A#,4, 20
	envelope $A8
	note E_,5, 10
	envelope $88
	note E_,5, 5
	silence 2
	envelope $68
	note E_,5, 3
	envelope $A8
	note E_,5, 10
	note F_,5, 20
	envelope $88
	note F_,5, 5
	silence 2
	envelope $68
	note F_,5, 3
	snd_loop SndCall_BGM_0A_Ch1_2, $00, 2
	snd_ret
SndCall_BGM_0A_Ch1_3:
	envelope $A8
	note C#,5, 5
	silence 2
	envelope $88
	note C#,5, 3
	envelope $A8
	note C#,5, 10
	note C_,5, 20
	silence 3
	envelope $88
	note C_,5, 5
	silence 2
	envelope $68
	note C_,5, 5
	silence 2
	envelope $48
	note C_,5, 3
	envelope $A8
	note C#,5, 5
	silence
	note C#,5, 10
	note C_,5, 20
	envelope $88
	note C_,5, 5
	silence 2
	envelope $68
	note C_,5, 3
	envelope $A8
	note C#,5, 20
	envelope $88
	note C_,5, 5
	silence 2
	envelope $68
	note C_,5, 3
	envelope $A8
	note A#,4, 10
	note C_,5
	snd_loop SndCall_BGM_0A_Ch1_3, $00, 2
	snd_ret
SndCall_BGM_0A_Ch1_4:
	envelope $A8
	note F_,5, 5
	silence 2
	envelope $88
	note F_,5, 3
	envelope $A8
	note F_,5, 10
	note D#,5, 20
	silence 3
	envelope $88
	note D#,5, 5
	silence 2
	envelope $68
	note D#,5, 5
	silence 2
	envelope $48
	note D#,5, 3
	envelope $A8
	note F_,5, 5
	silence
	note F_,5, 10
	note D#,5, 20
	envelope $88
	note D#,5, 5
	silence 2
	envelope $68
	note D#,5, 3
	envelope $A8
	note F_,5, 20
	envelope $88
	note D#,5, 5
	silence 2
	envelope $68
	note D#,5, 3
	envelope $A8
	note D_,5, 10
	note D#,5
	snd_loop SndCall_BGM_0A_Ch1_4, $00, 2
	snd_ret
SndCall_BGM_0A_Ch1_5:
	envelope $A8
	note F_,4, 5
	silence 2
	envelope $88
	note F_,4, 3
	envelope $A8
	note F_,4, 10
	note G_,4, 5
	silence 2
	envelope $88
	note G_,4, 3
	envelope $A8
	note G_,4, 10
	note G#,4, 5
	silence 2
	envelope $88
	note G#,4, 3
	envelope $A8
	note G#,4, 10
	note A_,4
	note A#,4, 15
	silence 2
	envelope $88
	note A#,4, 3
	snd_ret
SndCall_BGM_0A_Ch1_6:
	envelope $A8
	note C#,5, 5
	silence 2
	envelope $88
	note C#,5, 3
	envelope $A8
	note A#,4, 15
	silence 2
	envelope $88
	note A#,4, 3
	snd_loop SndCall_BGM_0A_Ch1_6, $00, 2
	snd_ret
SndCall_BGM_0A_Ch1_7:
	envelope $A8
	note D#,5, 15
	envelope $88
	note D#,5, 5
	envelope $A8
	note D_,5, 15
	envelope $88
	note D_,5, 5
	envelope $A8
	note C#,5, 5
	silence 2
	envelope $88
	note C#,5, 3
	envelope $A8
	note C_,5, 15
	envelope $88
	note C_,5, 5
	envelope $A8
	note B_,4, 15
	silence 2
	envelope $88
	note B_,4, 3
	envelope $A8
	note A#,4, 15
	envelope $88
	note A#,4, 5
	envelope $A8
	note A_,4, 15
	envelope $88
	note A_,4, 5
	envelope $A8
	note G#,4, 5
	silence 2
	envelope $88
	note G#,4, 3
	envelope $A8
	note G_,4, 15
	envelope $88
	note G_,4, 5
	envelope $A8
	note F#,4, 15
	envelope $88
	note F#,4, 5
	envelope $A8
	note F_,4, 15
	envelope $88
	note F_,4, 5
	envelope $A8
	note E_,4, 5
	silence 2
	envelope $88
	note E_,4, 3
	envelope $A8
	note D#,4, 15
	envelope $88
	note D#,4, 5
	envelope $A8
	note D_,4, 15
	silence 2
	envelope $88
	note D_,4, 3
	envelope $A8
	note C#,4, 15
	envelope $88
	note C#,4, 5
	envelope $A8
	note C_,4, 15
	envelope $88
	note C_,4, 5
	envelope $A8
	note B_,3, 5
	silence 2
	envelope $88
	note B_,3, 3
	envelope $A8
	note C_,4, 5
	silence 2
	envelope $88
	note C_,4, 3
	envelope $A8
	note C#,4, 5
	silence 2
	envelope $88
	note C#,4, 3
	snd_ret
SndData_BGM_0A_Ch2:
	envelope $A8
	panning $22
	duty_cycle 3
	snd_call SndCall_BGM_0A_Ch2_4
	duty_cycle 0
	snd_call SndCall_BGM_0A_Ch2_5
	fine_tune 1
	snd_call SndCall_BGM_0A_Ch2_5
	fine_tune 1
	snd_call SndCall_BGM_0A_Ch2_5
	fine_tune -2
	snd_call SndCall_BGM_0A_Ch2_6
	snd_call SndCall_BGM_0A_Ch2_5
	fine_tune 1
	snd_call SndCall_BGM_0A_Ch2_5
	fine_tune 1
	snd_call SndCall_BGM_0A_Ch2_5
	fine_tune -2
	snd_call SndCall_BGM_0A_Ch2_6
	snd_call SndCall_BGM_0A_Ch2_7
	snd_call SndCall_BGM_0A_Ch2_8
	snd_call SndCall_BGM_0A_Ch2_9
	duty_cycle 3
	fine_tune 3
	snd_call SndCall_BGM_0A_Ch1_7
	fine_tune -3
	fine_tune -5
	snd_call SndCall_BGM_0A_Ch1_0
	fine_tune 5
	snd_loop SndData_BGM_0A_Ch2
SndCall_BGM_0A_Ch2_4:
	envelope $A8
	note A#,3, 10
	note A_,3, 5
	silence 2
	envelope $88
	note A_,3, 3
	envelope $A8
	note G#,3, 10
	note F_,3, 20
	envelope $88
	note F_,3, 5
	silence 2
	envelope $68
	note F_,3, 3
	envelope $A8
	note A#,3, 10
	note A_,3, 5
	silence 2
	envelope $88
	note A_,3, 3
	envelope $A8
	note G#,3, 10
	note F_,3
	envelope $88
	note F_,3, 5
	silence 2
	envelope $68
	note F_,3, 3
	envelope $A8
	note A#,3, 20
	note F_,3, 5
	silence 2
	envelope $88
	note F_,3, 3
	envelope $A8
	note G#,3, 10
	note A#,3
	envelope $A8
	note C#,4, 10
	note D#,4, 5
	silence 2
	envelope $88
	note D#,4, 3
	envelope $A8
	note F_,4, 10
	note G_,4, 20
	note F_,4, 10
	note D#,4
	note C#,4
	envelope $A8
	note E_,4, 5
	silence 2
	envelope $88
	note E_,4, 3
	envelope $A8
	note C_,4, 5
	silence 2
	envelope $88
	note C_,4, 3
	envelope $A8
	note D_,4, 10
	note E_,4
	note F_,4
	note G_,4
	envelope $A8
	note G#,4, 15
	silence 2
	envelope $88
	note G#,4, 3
	snd_loop SndCall_BGM_0A_Ch2_4, $00, 2
	snd_ret
SndCall_BGM_0A_Ch2_5:
	envelope $A2
	note G#,5, 2
	envelope $82
	note D#,5, 3
	envelope $A2
	note F_,5, 2
	envelope $82
	note G#,5, 3
	envelope $A2
	note C_,6, 2
	envelope $82
	note F_,5, 3
	envelope $A2
	note F_,5, 2
	envelope $82
	note C_,6, 3
	envelope $A2
	note G#,5, 2
	envelope $82
	note F_,5, 3
	envelope $A2
	note D#,5, 2
	envelope $82
	note G#,5, 3
	snd_loop SndCall_BGM_0A_Ch2_5, $00, 2
	snd_ret
SndCall_BGM_0A_Ch2_6:
	envelope $A2
	note B_,5, 2
	envelope $82
	note F_,5, 3
	envelope $A2
	note G#,5, 2
	envelope $82
	note B_,5, 3
	envelope $A2
	note D_,6, 2
	envelope $82
	note G#,5, 3
	envelope $A2
	note G#,5, 2
	envelope $82
	note D_,6, 3
	envelope $A2
	note B_,5, 2
	envelope $82
	note G#,5, 3
	envelope $A2
	note G#,5, 2
	envelope $82
	note B_,5, 3
	envelope $A2
	note D_,6, 2
	envelope $82
	note G#,5, 3
	envelope $A2
	note C#,6, 2
	envelope $82
	note D_,6, 3
	envelope $A2
	note C_,6, 2
	envelope $82
	note C#,6, 3
	envelope $A2
	note B_,5, 2
	envelope $82
	note C_,6, 3
	envelope $A2
	note A#,5, 2
	envelope $82
	note B_,5, 3
	envelope $A2
	note A_,5, 2
	envelope $82
	note A#,5, 3
	snd_ret
SndCall_BGM_0A_Ch2_7:
	envelope $A2
	note G#,5, 5
	silence 2
	envelope $82
	note G#,5, 3
	envelope $A2
	note F_,5, 5
	silence 2
	envelope $82
	note F_,5, 3
	envelope $A2
	note C_,6, 5
	silence 2
	envelope $82
	note C_,6, 3
	envelope $A2
	note F_,5, 5
	silence 2
	envelope $82
	note F_,5, 3
	snd_loop SndCall_BGM_0A_Ch2_7, $00, 8
	snd_ret
SndCall_BGM_0A_Ch2_8:
	envelope $A2
	note A#,5, 5
	silence 2
	envelope $82
	note A#,5, 3
	envelope $A2
	note F#,6, 5
	silence 2
	envelope $82
	note F#,6, 3
	envelope $A2
	note C#,6, 5
	silence 2
	envelope $82
	note C#,6, 3
	envelope $A2
	note F#,6, 5
	silence 2
	envelope $82
	note F#,6, 3
	snd_loop SndCall_BGM_0A_Ch2_8, $00, 8
	snd_ret
SndCall_BGM_0A_Ch2_9:
	envelope $A2
	note G#,5, 5
	silence 2
	envelope $82
	note G#,5, 3
	envelope $A2
	note G_,5, 5
	silence 2
	envelope $82
	note G_,5, 3
	envelope $A2
	note C#,6, 5
	silence 2
	envelope $82
	note C#,6, 3
	envelope $A2
	note G_,5, 5
	silence 2
	envelope $82
	note G_,5, 3
	snd_loop SndCall_BGM_0A_Ch2_9, $00, 8
	snd_ret
SndData_BGM_0A_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	wave_cutoff 0
	snd_call SndCall_BGM_0A_Ch3_0
	snd_call SndCall_BGM_0A_Ch3_1
	snd_call SndCall_BGM_0A_Ch3_2
	snd_call SndCall_BGM_0A_Ch3_3
	snd_call SndCall_BGM_0A_Ch3_4
	note A#,3, 10
	note F_,3, 5
	silence
	note B_,3, 10
	note F_,3, 5
	silence
	note C_,4
	silence
	note C#,4, 13
	silence 7
	note D_,4, 20
	note D#,4, 10
	note A#,3
	note E_,4, 13
	silence 7
	note F_,4, 10
	note F#,4, 20
	note F_,4, 10
	note A#,3, 5
	silence
	note E_,4, 10
	note A#,3, 5
	silence
	note D#,4
	silence
	note D_,4, 13
	silence 7
	note C#,4, 20
	note C_,4, 5
	silence
	note F_,3
	silence
	note B_,3, 20
	note A#,3, 5
	silence
	note A_,3, 10
	note F_,3
	snd_call SndCall_BGM_0A_Ch3_5
	note A#,3, 10
	note F_,3, 5
	silence
	note A#,3, 10
	note F_,3, 5
	silence
	note A#,3
	silence
	note C_,4, 20
	note C#,4, 15
	silence 5
	note C#,4, 15
	silence 5
	note C#,4, 15
	silence 5
	note C#,4, 15
	silence 5
	note C#,4, 15
	silence 5
	note D#,4, 8
	silence 2
	note D#,4, 5
	silence
	note D#,4
	silence
	note D#,4, 10
	note E_,4, 5
	silence
	note F_,4, 20
	snd_call SndCall_BGM_0A_Ch3_6
	note A#,3, 5
	silence
	note A#,3, 10
	note F_,4
	note A#,3, 8
	silence 2
	snd_call SndCall_BGM_0A_Ch3_6
	note A#,3, 5
	silence
	note A#,3, 10
	note F_,4
	note A#,3, 20
	note F_,3, 10
	note F_,4, 20
	silence 10
	note B_,3, 5
	silence
	note C_,4, 10
	note C#,4
	snd_loop SndData_BGM_0A_Ch3
SndCall_BGM_0A_Ch3_0:
	note A#,3, 10
	note F_,3, 5
	silence
	note F_,3, 10
	note C#,4
	note F_,3, 5
	silence
	note F_,3, 10
	note A#,3
	note F_,3, 5
	silence
	note F_,3, 10
	note C#,4
	note F_,3, 5
	silence
	note F_,3, 10
	note A#,3, 5
	silence
	note A#,3, 10
	note C#,4
	note A#,3
	note G#,3, 20
	note F_,3, 10
	note C#,4, 18
	silence 2
	note F_,3, 10
	note G_,3, 20
	note E_,3, 10
	note C#,4, 30
	note G#,3, 5
	silence
	note G#,3, 10
	note C#,4
	note G#,3
	snd_loop SndCall_BGM_0A_Ch3_0, $00, 2
	snd_ret
SndCall_BGM_0A_Ch3_1:
	note A#,3, 5
	silence
	note A#,3, 10
	note F_,3
	note A#,3, 5
	silence
	note A#,3, 10
	note F_,3
	note B_,3, 5
	silence
	note B_,3, 10
	note F_,3
	note B_,3, 5
	silence
	note B_,3, 10
	note F_,3
	note C_,4, 5
	silence
	note C_,4, 10
	note F_,3
	note C_,4, 5
	silence
	note C_,4, 10
	note F_,3
	note C#,4, 5
	silence
	note C#,4, 8
	silence 2
	note C#,4, 5
	silence
	note D_,4, 5
	silence
	note D_,4, 8
	silence 2
	note D_,4, 5
	silence
	snd_loop SndCall_BGM_0A_Ch3_1, $00, 2
	snd_ret
SndCall_BGM_0A_Ch3_2:
	note F_,3, 5
	silence
	note F_,3, 10
	note D#,3
	note G#,3
	snd_loop SndCall_BGM_0A_Ch3_2, $00, 8
	snd_ret
SndCall_BGM_0A_Ch3_3:
	note F#,3, 5
	silence
	note F#,3, 10
	note D#,3
	note F_,3
	snd_loop SndCall_BGM_0A_Ch3_3, $00, 8
	snd_ret
SndCall_BGM_0A_Ch3_4:
	note G_,3, 5
	silence
	note G_,3, 10
	note D#,3
	note F_,3
	snd_loop SndCall_BGM_0A_Ch3_4, $00, 8
	snd_ret
SndCall_BGM_0A_Ch3_5:
	note A#,3, 10
	note F_,3, 5
	silence
	note A#,3, 10
	note F_,3, 5
	silence
	note A#,3
	silence
	note C_,4, 20
	note C#,4
	note F_,3, 5
	silence
	note C#,4
	silence
	note G#,3, 15
	silence 5
	note A_,3, 10
	note A#,3
	note F_,3
	snd_loop SndCall_BGM_0A_Ch3_5, $00, 3
	snd_ret
SndCall_BGM_0A_Ch3_6:
	note A#,3, 5
	silence
	note A#,3, 10
	note C#,4
	note A#,3, 8
	silence 2
	note A#,3, 5
	silence
	note A#,3, 10
	note C#,4
	note A#,3, 8
	silence 2
	note A#,3, 5
	silence
	note A#,3, 10
	note D#,4
	note A#,3, 8
	silence 2
	note A#,3, 5
	silence
	note A#,3, 10
	note D#,4
	note A#,3, 8
	silence 2
	note A#,3, 5
	silence
	note A#,3, 10
	note E_,4
	note A#,3, 8
	silence 2
	snd_ret
SndData_BGM_0A_Ch4:
	panning $88
	snd_call SndCall_BGM_0A_Ch4_0
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 5
	envelope $51
	note4 C_,6,0, 5
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 5
	envelope $51
	note4 C_,6,0, 5
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	snd_call SndCall_BGM_0A_Ch4_1
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $91
	note4 G_,5,0, 5
	note4 G_,5,0, 5
	envelope $91
	note4 F#,5,0, 5
	note4 F#,5,0, 5
	snd_call SndCall_BGM_0A_Ch4_1
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $C1
	note4 G#,4,0, 5
	note4 G#,4,0, 5
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	snd_call SndCall_BGM_0A_Ch4_2
	snd_call SndCall_BGM_0A_Ch4_3
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 5
	envelope $C1
	note4 G#,4,0, 10
	note4 G#,4,0, 5
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	snd_call SndCall_BGM_0A_Ch4_3
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 5
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 5
	envelope $A1
	note4 A_,5,0, 10
	note4 A_,5,0, 10
	note4 A_,5,0, 10
	note4 A_,5,0, 10
	snd_call SndCall_BGM_0A_Ch4_4
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $C1
	note4 G#,4,0, 10
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $51
	note4 C_,6,0, 10
	envelope $A1
	note4 A_,5,0, 10
	note4 A_,5,0, 10
	note4 A_,5,0, 10
	note4 A_,5,0, 10
	note4 A_,5,0, 10
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	snd_call SndCall_BGM_0A_Ch4_5
	envelope $C1
	note4 G#,4,0, 5
	envelope $51
	note4 C_,6,0, 5
	envelope $C1
	note4 G#,4,0, 5
	envelope $51
	note4 C_,6,0, 5
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	note4 A_,5,0, 10
	note4 A_,5,0, 10
	snd_loop SndData_BGM_0A_Ch4
SndCall_BGM_0A_Ch4_0:
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 5
	envelope $51
	note4 C_,6,0, 5
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 5
	envelope $51
	note4 C_,6,0, 5
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 5 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 5
	snd_loop SndCall_BGM_0A_Ch4_0, $00, 3
	snd_ret
SndCall_BGM_0A_Ch4_1:
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $C1
	note4 G#,4,0, 10
	note4 G#,4,0, 10
	snd_loop SndCall_BGM_0A_Ch4_1, $00, 7
	snd_ret
SndCall_BGM_0A_Ch4_2:
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $C1
	note4 G#,4,0, 5
	envelope $51
	note4 C_,6,0, 5
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 5
	envelope $53
	note4x $13, 5 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	snd_loop SndCall_BGM_0A_Ch4_2, $00, 6
	snd_ret
SndCall_BGM_0A_Ch4_3:
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
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
	snd_ret
SndCall_BGM_0A_Ch4_4:
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $C1
	note4 G#,4,0, 10
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $C1
	note4 G#,4,0, 10
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
	snd_loop SndCall_BGM_0A_Ch4_4, $00, 3
	snd_ret
SndCall_BGM_0A_Ch4_5:
	envelope $C1
	note4 G#,4,0, 5
	envelope $51
	note4 C_,6,0, 5
	envelope $C1
	note4 G#,4,0, 5
	envelope $51
	note4 C_,6,0, 5
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 5
	envelope $53
	note4x $13, 5 ; Nearest: G#,6,0
	snd_loop SndCall_BGM_0A_Ch4_5, $00, 12
	snd_ret
