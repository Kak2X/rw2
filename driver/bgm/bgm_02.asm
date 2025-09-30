SndHeader_BGM_02:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_02_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_02_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_02_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_02_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_BGM_02_Ch1:
	envelope $A8
	panning $11
	duty_cycle 2
	vibrato_on $01
	snd_call SndCall_BGM_01_Ch1_0
	envelope $A8
	note E_,5, 2
	envelope $C8
	note F_,5, 8
	note D#,5, 10
	note F_,5
	note D#,5, 30
	envelope $98
	note D#,5, 5
	envelope $78
	note D#,5
	envelope $68
	note D#,5
	envelope $38
	note D#,5
	duty_cycle 3
	envelope $C8
	note D#,4, 40
	note G#,3, 20
	duty_cycle 2
	envelope $C8
	note F_,5
	note D#,5, 15
	silence 5
	duty_cycle 3
	envelope $C8
	note D#,4, 10
	envelope $78
	note D#,4, 5
	silence
	envelope $C8
	note F_,4, 40
	envelope $C8
	note D#,4, 30
	note F_,4, 20
	note D#,4, 10
	note F_,4, 20
	envelope $98
	note F_,4, 5
	envelope $78
	note F_,4
	envelope $58
	note F_,4
	envelope $38
	note F_,4
	envelope $C8
	note D#,4, 10
	envelope $78
	note D#,4, 5
	silence
	envelope $C8
	note F_,4, 40
	note D#,4, 30
	note C#,4
	envelope $98
	note C#,4, 5
	envelope $78
	note C#,4
	envelope $58
	note C#,4
	envelope $38
	note C#,4
	snd_call SndCall_BGM_02_Ch1_1
	silence 40
	envelope $A8
	note C_,5, 2
	envelope $C8
	note C#,5, 18
	note C_,5, 20
	note A#,4
	note G#,4, 10
	note A#,4, 20
	envelope $98
	note A#,4, 5
	envelope $78
	note A#,4
	envelope $58
	note A#,4
	envelope $38
	note A#,4
	envelope $28
	note A#,4
	silence 40
	continue 5
	snd_call SndCall_BGM_02_Ch1_1
	envelope $A8
	note D_,4, 2
	envelope $B8
	note D#,4, 18
	note F_,4, 20
	note F#,4
	envelope $98
	note F#,4, 5
	envelope $78
	note F#,4
	envelope $58
	note F#,4
	envelope $38
	note F#,4
	envelope $A8
	note A_,4, 2
	envelope $B8
	note A#,4, 8
	note G#,4, 10
	note F#,4
	note G#,4, 30
	envelope $98
	note G#,4, 5
	envelope $78
	note G#,4
	envelope $58
	note G#,4
	envelope $38
	note G#,4
	envelope $28
	note G#,4
	silence 30
	continue 5
	snd_call SndCall_BGM_02_Ch1_1
	silence 20
	envelope $A8
	note D_,4, 2
	envelope $C8
	note D#,4, 8
	note D#,4, 10
	envelope $A8
	note D_,5, 2
	envelope $C8
	note D#,5, 18
	envelope $A8
	note D_,5, 2
	envelope $C8
	note D#,5, 18
	envelope $A8
	note E_,5, 2
	envelope $C8
	note F_,5, 18
	note D_,5, 10
	note D#,5, 30
	envelope $98
	note D#,5, 5
	envelope $78
	note D#,5
	envelope $58
	note D#,5
	envelope $38
	note D#,5
	envelope $28
	note D#,5
	silence 15
	envelope $A8
	note D_,5, 2
	envelope $C8
	note D#,5, 8
	note D#,5, 10
	envelope $A8
	note D_,5, 2
	envelope $C8
	note D#,5, 18
	envelope $A8
	note D_,5, 2
	envelope $C8
	note D#,5, 8
	envelope $98
	note D#,5, 2
	silence 5
	envelope $78
	note D#,5, 3
	envelope $A8
	note C#,5, 2
	envelope $C8
	note D_,5, 18
	note C_,5, 20
	note A#,4, 30
	envelope $A8
	note B_,4, 2
	envelope $C8
	note C_,5, 23
	envelope $98
	note C_,5, 2
	envelope $78
	note C_,5, 3
	envelope $A8
	note E_,4, 2
	envelope $C8
	note F_,4, 8
	note G_,4, 10
	note G#,4, 20
	envelope $A8
	note G_,4, 2
	envelope $C8
	note G#,4, 18
	note G_,4, 20
	note F_,4, 10
	envelope $A8
	note D_,4, 2
	envelope $C8
	note D#,4, 8
	note D#,4, 30
	envelope $98
	note D#,4, 5
	envelope $78
	note D#,4
	envelope $58
	note D#,4
	envelope $38
	note D#,4
	duty_cycle 3
	envelope $C8
	note A#,4, 5
	note C_,5
	note D_,5
	note D#,5
	note F_,5
	note F#,5
	note G_,5, 20
	envelope $98
	note G_,5, 5
	envelope $78
	note G_,5
	envelope $58
	note G_,5
	envelope $38
	note G_,5
	duty_cycle 2
	envelope $A8
	note A_,4, 2
	envelope $C8
	note A#,4, 18
	note C_,5, 20
	note C#,5
	envelope $98
	note C#,5, 5
	envelope $78
	note C#,5
	envelope $58
	note C#,5
	envelope $38
	note C#,5
	envelope $A8
	note E_,5, 2
	envelope $C8
	note F_,5, 3
	silence 2
	envelope $68
	note F_,5, 3
	envelope $A8
	note E_,5, 2
	envelope $C8
	note F_,5, 18
	note D#,5, 30
	envelope $98
	note D#,5, 5
	envelope $78
	note D#,5
	envelope $A8
	note D_,5, 2
	envelope $C8
	note D#,5, 18
	note C_,5, 10
	note A#,4
	note G#,4
	envelope $98
	note G#,4, 5
	envelope $78
	note G#,4
	envelope $58
	note G#,4
	envelope $38
	note G#,4
	silence 10
	envelope $A8
	note A_,4, 2
	envelope $C8
	note A#,4, 18
	note G_,4, 10
	note F_,4
	note G_,4
	note F_,4
	note D#,4
	envelope $98
	note D#,4, 5
	envelope $78
	note D#,4
	envelope $58
	note D#,4
	envelope $38
	note D#,4
	envelope $A8
	note A_,4, 2
	envelope $C8
	note A#,4, 18
	note C_,5, 20
	note C#,5
	envelope $98
	note C#,5, 5
	envelope $78
	note C#,5
	envelope $58
	note C#,5
	envelope $38
	note C#,5
	envelope $A8
	note E_,5, 2
	envelope $C8
	note F_,5, 3
	silence 2
	envelope $68
	note F_,5, 3
	envelope $C8
	note F_,5, 20
	note E_,5
	envelope $78
	note E_,5, 5
	envelope $58
	note E_,5
	envelope $A8
	note D#,5, 2
	envelope $C8
	note E_,5, 18
	note F_,5, 10
	note G_,5
	envelope $78
	note G_,5, 5
	envelope $58
	note G_,5
	envelope $A8
	note G_,5, 2
	envelope $C8
	note G#,5, 8
	vibrato_on $01
	continue 60
	vibrato_on $01
	continue 10
	envelope $98
	note G#,5, 5
	envelope $78
	note G#,5
	envelope $58
	note G#,5
	envelope $38
	note G#,5
	envelope $A8
	note G_,5, 2
	envelope $C8
	note G#,5, 3
	silence 2
	envelope $68
	note G#,5, 3
	envelope $A8
	note G#,5, 10
	note G#,5
	envelope $A8
	note F#,5, 2
	envelope $C8
	note G_,5, 3
	silence 2
	envelope $68
	note G_,5, 3
	envelope $C8
	note G_,5, 10
	note F_,5
	note D#,5
	envelope $A8
	note E_,5, 2
	envelope $C8
	note F_,5, 18
	envelope $98
	note F_,5, 5
	envelope $78
	note F_,5
	envelope $58
	note F_,5
	envelope $38
	note F_,5
	envelope $28
	note F_,5
	silence 15
	duty_cycle 3
	envelope $C8
	note F_,4, 5
	silence 2
	envelope $68
	note F_,4, 3
	envelope $C8
	note F_,4, 5
	silence 2
	envelope $68
	note F_,4, 3
	envelope $C8
	note A#,3, 15
	note C_,4, 5
	silence 10
	note D_,4, 30
	snd_loop SndData_BGM_02_Ch1
SndCall_BGM_02_Ch1_1:
	duty_cycle 2
	envelope $A8
	note A_,4, 2
	envelope $B8
	note A#,4, 3
	silence 2
	envelope $68
	note A#,4, 3
	envelope $C8
	note A#,4, 10
	note G#,4, 5
	silence 2
	envelope $68
	note G#,4, 3
	envelope $C8
	note G#,4, 10
	note G_,4, 20
	note F_,4, 10
	note D#,4, 20
	envelope $98
	note D#,4, 5
	envelope $78
	note D#,4
	envelope $58
	note D#,4
	envelope $48
	note D#,4
	envelope $38
	note D#,4
	envelope $28
	note D#,4
	snd_ret
SndData_BGM_02_Ch2:
	envelope $88
	panning $22
	duty_cycle 2
	vibrato_on $01
	note G#,4, 20
	duty_cycle 1
	snd_call SndCall_BGM_01_Ch2_4
	envelope $A8
	note G_,4, 5
	silence 2
	envelope $68
	note G_,4, 3
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $68
	note G_,3, 3
	envelope $C8
	note C_,4, 10
	note D#,4, 5
	silence
	note C_,5, 15
	note B_,4
	note A#,4, 5
	silence
	note A_,4, 40
	note A#,4
	envelope $98
	snd_call SndCall_BGM_01_Ch2_3
	envelope $88
	note D#,4, 10
	note A#,3, 5
	silence 2
	envelope $58
	note A#,3, 3
	envelope $88
	note G_,3, 5
	silence 2
	envelope $58
	note G_,3, 3
	envelope $88
	note D#,4, 10
	note A#,3, 5
	silence 2
	envelope $58
	note A#,3, 3
	envelope $A8
	note A#,3, 5
	note C_,4
	note D#,4, 10
	note A#,3
	envelope $88
	note G_,3, 10
	note A#,3, 5
	silence 2
	envelope $58
	note A#,3, 3
	envelope $88
	note D#,3, 5
	silence 2
	envelope $58
	note D#,3, 3
	envelope $88
	note G_,3, 5
	silence 2
	envelope $58
	note G_,3, 3
	envelope $A8
	note G_,4, 5
	note G#,4
	note A#,4, 20
	envelope $88
	note G_,3, 5
	silence 2
	envelope $58
	note G_,3, 3
	envelope $88
	note D#,3, 5
	silence 2
	envelope $58
	note D#,3, 3
	envelope $88
	note D#,3, 10
	note C#,3, 5
	silence 2
	envelope $58
	note C#,3, 3
	envelope $88
	note D#,3, 10
	note D#,3, 5
	silence 2
	envelope $58
	note D#,3, 3
	envelope $A8
	note C#,3, 5
	note D#,3
	note F#,3, 10
	note F#,3
	envelope $88
	note D#,3, 5
	silence 2
	envelope $58
	note D#,3, 3
	envelope $88
	note D#,3, 10
	note C#,3, 5
	silence 2
	envelope $58
	note C#,3, 3
	envelope $A8
	note F#,4, 20
	note F#,4, 10
	note A#,3, 5
	note G#,3
	note F#,3, 10
	note D#,3
	envelope $88
	note A#,3, 5
	silence 2
	envelope $58
	note A#,3, 3
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $78
	note D#,4, 3
	envelope $88
	note A#,3, 5
	silence 2
	envelope $58
	note A#,3, 3
	envelope $88
	note G_,3, 5
	silence 2
	envelope $58
	note G_,3, 3
	envelope $A8
	note A#,3, 5
	note C_,4
	note D#,4, 10
	note A#,3
	envelope $A8
	note G_,4, 5
	silence 2
	envelope $78
	note G_,4, 3
	envelope $88
	note A#,3, 10
	envelope $A8
	note F_,4, 5
	silence 2
	envelope $78
	note F_,4, 3
	envelope $88
	note A#,3, 10
	note G_,3, 5
	silence 2
	envelope $58
	note G_,3, 3
	envelope $A8
	note A#,3, 20
	envelope $88
	note C#,4, 10
	envelope $88
	note F#,3, 5
	silence 2
	envelope $58
	note F#,3, 3
	envelope $88
	note G#,3, 10
	envelope $A8
	note B_,3
	envelope $88
	note G#,3
	note F#,4, 5
	silence 2
	envelope $58
	note F#,4, 3
	envelope $A8
	note B_,3, 20
	note D#,4, 10
	envelope $88
	note F#,3, 5
	silence 2
	envelope $58
	note F#,3, 3
	envelope $C8
	note D#,5, 5
	silence 2
	envelope $98
	note D#,5, 3
	envelope $A8
	note B_,3, 10
	envelope $C8
	note B_,4, 5
	silence 2
	envelope $98
	note B_,4, 3
	envelope $88
	note D#,4, 5
	silence 2
	envelope $58
	note D#,4, 3
	envelope $C8
	note G#,4, 5
	silence 2
	envelope $98
	note G#,4, 3
	envelope $A8
	note B_,3, 10
	envelope $C8
	note F_,4
	envelope $88
	note D#,4, 10
	note A#,3, 5
	silence 2
	envelope $58
	note A#,3, 3
	envelope $88
	note G_,3, 5
	silence 2
	envelope $58
	note G_,3, 3
	envelope $88
	note D#,4, 10
	note A#,3, 5
	silence 2
	envelope $58
	note A#,3, 3
	envelope $A8
	note A#,3, 5
	note C_,4
	note D#,4, 10
	note A#,3
	envelope $88
	note G_,3
	envelope $C8
	note F_,5
	note F#,5
	note G_,5
	envelope $B8
	note C_,4, 5
	silence 2
	envelope $88
	note C_,4, 3
	envelope $B8
	note D_,4, 5
	silence 2
	envelope $88
	note D_,4, 3
	envelope $B8
	note G_,3, 5
	silence 2
	envelope $88
	note G_,3, 3
	envelope $B8
	note F_,4, 5
	silence 2
	envelope $88
	note F_,4, 3
	envelope $B8
	note G_,4, 20
	envelope $88
	note C_,4, 5
	silence 2
	envelope $58
	note C_,4, 3
	envelope $88
	note C_,4, 5
	silence 2
	envelope $58
	note C_,4, 3
	envelope $B8
	note F_,4, 5
	silence 2
	envelope $88
	note F_,4, 5
	silence 3
	envelope $B8
	note G#,4, 5
	silence 2
	envelope $88
	note G#,4, 5
	silence 3
	envelope $B8
	note G_,4, 20
	envelope $88
	note A#,4, 5
	silence 2
	envelope $58
	note A#,4, 3
	envelope $88
	note A#,4, 5
	silence 2
	envelope $58
	note A#,4, 3
	envelope $B8
	note C_,5, 5
	silence 2
	envelope $88
	note C_,5, 3
	envelope $B8
	note D#,5, 5
	silence 2
	envelope $88
	note D#,5, 3
	envelope $B8
	note C_,5, 5
	silence 2
	envelope $88
	note C_,5, 3
	envelope $B8
	note D_,5, 5
	silence 2
	envelope $88
	note D_,5, 3
	envelope $B8
	note D#,5, 5
	silence 2
	envelope $88
	note D#,5, 3
	envelope $B8
	note G_,5, 20
	envelope $88
	note C_,4, 5
	silence 2
	envelope $58
	note C_,4, 3
	envelope $88
	note C_,4, 5
	silence 2
	envelope $58
	note C_,4, 3
	envelope $B8
	note F_,5, 10
	envelope $88
	note C_,4, 5
	silence 2
	envelope $58
	note C_,4, 3
	envelope $B8
	note D#,5, 10
	envelope $88
	note C_,4, 5
	silence 2
	envelope $58
	note C_,4, 3
	envelope $B8
	note G_,5, 10
	envelope $88
	note D_,4, 5
	silence 2
	envelope $58
	note D_,4, 3
	envelope $88
	note D_,4, 5
	silence 2
	envelope $58
	note D_,4, 3
	envelope $B8
	note A#,5, 10
	envelope $88
	note G_,3, 5
	silence 2
	envelope $58
	note G_,3, 3
	envelope $88
	note G_,3, 5
	silence 2
	envelope $58
	note G_,3, 3
	envelope $B8
	note D#,5, 10
	envelope $88
	note C_,4, 5
	silence 2
	envelope $58
	note C_,4, 3
	envelope $88
	note D#,4, 5
	silence 2
	envelope $58
	note D#,4, 3
	envelope $B8
	note F_,4, 2
	silence 3
	envelope $B8
	note G_,4, 2
	envelope $88
	note F_,4, 3
	envelope $B8
	note F_,4, 2
	envelope $88
	note G_,4, 3
	envelope $B8
	note A#,4, 2
	envelope $88
	note F_,4, 3
	envelope $B8
	note B_,4, 2
	envelope $88
	note A#,4, 3
	envelope $B8
	note C_,5, 2
	envelope $88
	note B_,4, 3
	envelope $B8
	note A#,4, 2
	envelope $88
	note C_,5, 3
	envelope $B8
	note C_,5, 2
	envelope $88
	note A#,4, 3
	envelope $B8
	note D_,5, 2
	envelope $88
	note C_,5, 3
	envelope $B8
	note D#,5, 2
	envelope $88
	note D_,5, 3
	envelope $B8
	note F_,5, 2
	envelope $88
	note D#,5, 3
	envelope $B8
	note G_,5, 2
	envelope $88
	note F_,5, 3
	envelope $B8
	note G#,5, 2
	envelope $88
	note G_,5, 3
	envelope $B8
	note A_,5, 2
	envelope $88
	note G#,5, 3
	envelope $B8
	note A#,5, 10
	envelope $98
	note G_,3, 5
	silence 2
	envelope $68
	note G_,3, 3
	envelope $98
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $98
	note G_,3, 5
	silence 2
	envelope $68
	note G_,3, 3
	envelope $98
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $B8
	note G_,4, 2
	silence 3
	envelope $B8
	note G#,4, 2
	envelope $88
	note G_,4, 3
	envelope $B8
	note A#,4, 2
	envelope $88
	note G#,4, 3
	envelope $B8
	note C_,5, 2
	envelope $88
	note A#,4, 3
	envelope $B8
	note D_,5, 2
	envelope $88
	note C_,5, 3
	envelope $B8
	note D#,5, 2
	envelope $88
	note D_,5, 3
	duty_cycle 2
	envelope $97
	note F_,6, 10
	duty_cycle 1
	envelope $88
	note G_,3, 5
	duty_cycle 2
	envelope $97
	note D#,6, 10
	duty_cycle 1
	envelope $88
	note G_,3, 5
	duty_cycle 2
	envelope $97
	note A#,5, 20
	duty_cycle 1
	envelope $98
	note F_,3, 5
	silence 2
	envelope $68
	note F_,3, 3
	envelope $98
	note C_,4, 5
	silence 2
	envelope $68
	note C_,4, 3
	envelope $98
	note F_,3, 5
	silence 2
	envelope $68
	note F_,3, 3
	snd_call SndCall_BGM_02_Ch2_2
	envelope $A8
	note C_,3, 5
	silence 2
	envelope $88
	note C_,3, 3
	envelope $A8
	note C_,3, 5
	silence 2
	envelope $88
	note C_,3, 3
	envelope $A8
	note D#,3, 5
	silence 2
	envelope $88
	note D#,3, 3
	envelope $A8
	note G#,3, 5
	silence 2
	envelope $88
	note G#,3, 3
	envelope $A8
	note C_,4, 5
	silence 2
	envelope $88
	note C_,4, 3
	envelope $A8
	note G#,3, 5
	silence 2
	envelope $88
	note G#,3, 3
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $88
	note D#,4, 3
	envelope $A8
	note C_,4, 5
	silence 2
	envelope $88
	note C_,4, 3
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $88
	note G_,3, 3
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $88
	note G_,3, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $88
	note A#,3, 3
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $88
	note D#,4, 3
	envelope $A8
	note G_,4, 5
	silence 2
	envelope $88
	note G_,4, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $88
	note A#,3, 3
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $88
	note D#,4, 3
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $88
	note G_,3, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $88
	note A#,3, 3
	envelope $A8
	note G_,4, 5
	silence 2
	envelope $88
	note G_,4, 3
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $88
	note G_,3, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $88
	note A#,3, 3
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $88
	note D#,4, 3
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $88
	note G_,3, 3
	envelope $A8
	note D#,3, 5
	silence 2
	envelope $88
	note D#,3, 3
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $88
	note G_,3, 3
	snd_call SndCall_BGM_02_Ch2_2
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $88
	note G_,3, 3
	envelope $A8
	note A#,4, 5
	silence 2
	envelope $88
	note A#,4, 3
	envelope $A8
	note E_,4, 5
	silence 2
	envelope $88
	note E_,4, 3
	envelope $A8
	note G_,4, 5
	silence 2
	envelope $88
	note G_,4, 3
	envelope $A8
	note C_,4, 5
	silence 2
	envelope $88
	note C_,4, 3
	envelope $A8
	note E_,4, 5
	silence 2
	envelope $88
	note E_,4, 3
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $88
	note G_,3, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $88
	note A#,3, 3
	envelope $A8
	note C_,4, 5
	silence 2
	envelope $88
	note C_,4, 3
	envelope $A8
	note G#,3, 5
	silence 2
	envelope $88
	note G#,3, 3
	envelope $A8
	note F_,4, 5
	silence 2
	envelope $88
	note F_,4, 3
	envelope $A8
	note C_,4, 5
	silence 2
	envelope $88
	note C_,4, 3
	envelope $A8
	note G#,4, 5
	silence 2
	envelope $88
	note G#,4, 3
	envelope $A8
	note F_,4, 5
	silence 2
	envelope $88
	note F_,4, 3
	envelope $A8
	note G#,3, 5
	silence 2
	envelope $88
	note G#,3, 3
	envelope $A8
	note C_,4, 5
	silence 2
	envelope $88
	note C_,4, 3
	envelope $A8
	note F_,3, 5
	silence 2
	envelope $88
	note F_,3, 3
	envelope $A8
	note C#,4, 5
	silence 2
	envelope $88
	note C#,4, 3
	envelope $A8
	note G#,3, 5
	silence 2
	envelope $88
	note G#,3, 3
	envelope $A8
	note F_,4, 5
	silence 2
	envelope $88
	note F_,4, 3
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $88
	note G_,3, 3
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $88
	note D#,4, 3
	envelope $A8
	note G_,4, 5
	silence 2
	envelope $88
	note G_,4, 3
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
	envelope $A8
	note C_,4, 5
	silence 2
	envelope $88
	note C_,4, 3
	duty_cycle 2
	envelope $88
	note G_,6, 5
	silence 2
	envelope $68
	note G_,6, 3
	envelope $88
	note F_,6, 5
	silence 2
	envelope $68
	note F_,6, 3
	envelope $88
	note C_,6, 5
	silence 2
	envelope $68
	note C_,6, 3
	envelope $88
	note A_,5, 5
	silence 2
	envelope $68
	note A_,5, 3
	envelope $88
	note F_,5, 5
	silence 2
	envelope $68
	note F_,5, 3
	envelope $88
	note C_,5, 5
	silence 2
	envelope $68
	note C_,5, 3
	duty_cycle 1
	envelope $C8
	note F#,4, 15
	note G#,4, 5
	silence 10
	note A#,4, 30
	snd_loop SndData_BGM_02_Ch2
SndCall_BGM_02_Ch2_2:
	envelope $A8
	note F_,3, 5
	silence 2
	envelope $88
	note F_,3, 3
	envelope $A8
	note F_,3, 5
	silence 2
	envelope $88
	note F_,3, 3
	envelope $A8
	note G#,3, 5
	silence 2
	envelope $88
	note G#,3, 3
	envelope $A8
	note C#,4, 5
	silence 2
	envelope $88
	note C#,4, 3
	envelope $A8
	note F_,4, 5
	silence 2
	envelope $88
	note F_,4, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $88
	note A#,3, 3
	envelope $A8
	note C#,4, 5
	silence 2
	envelope $88
	note C#,4, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $88
	note A#,3, 3
	snd_ret
SndData_BGM_02_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	wave_cutoff 0
	note F_,4, 10
	note A#,3
	snd_call SndCall_BGM_01_Ch3_2
	note A_,3, 40
	note A#,3
	note D#,3, 20
	note D#,4, 10
	note D#,4
	silence
	note A#,3
	note C#,4
	note A#,3
	note D#,3, 20
	note D#,4, 10
	note D#,4
	silence
	note A#,3, 5
	silence
	note A#,3, 10
	note C#,4
	note D#,3, 20
	note D#,4, 10
	note D#,4
	silence
	note A#,3
	note C#,4
	note A#,3
	note D#,3, 20
	note D#,4, 10
	note D#,4
	silence
	note A#,3, 8
	silence 2
	note C#,4, 10
	note D#,4
	note D#,3, 20
	silence 10
	note D#,3
	silence 30
	note A#,3, 10
	note D#,3, 20
	silence 10
	note D#,3
	silence 20
	note D#,3, 5
	silence
	note D#,3, 10
	note F#,3, 20
	silence 10
	note F#,3
	silence 30
	note C#,4, 10
	note F#,3, 20
	silence 10
	note F#,3
	silence
	note F#,3, 8
	silence 2
	note F_,3, 8
	silence 2
	note E_,3, 10
	note D#,3, 20
	silence 10
	note D#,3
	silence 30
	note A#,3, 10
	note D#,3, 20
	silence 10
	note D#,3
	silence
	note D#,3
	note A#,3
	note A_,3
	note G#,3, 20
	silence 10
	note G#,3
	silence
	note D#,3
	note A#,3
	note C_,4
	note C#,4, 20
	silence 10
	note C#,4
	silence
	note C#,4
	note G#,3
	note C#,4
	note D#,3, 20
	silence 10
	note D#,3
	silence 30
	note A#,3, 10
	note D#,3, 20
	silence 10
	note D#,3
	silence
	note D#,3
	note A#,3
	note A_,3, 5
	silence
	note G#,3, 20
	silence 10
	note G#,3
	note G_,3, 20
	silence 10
	note G_,3
	note C_,4, 20
	silence 10
	note C_,4, 20
	note G_,3, 5
	silence
	note C_,4, 10
	note A#,3
	note G#,3, 20
	silence 10
	note G#,3, 20
	note D#,4, 5
	silence
	note G#,3, 20
	note G_,3, 5
	silence
	note A#,3, 10
	note B_,3, 5
	silence
	note C_,4, 20
	note D_,4, 10
	note D#,4
	note G_,3
	note F_,3, 20
	silence 10
	note F_,3
	note A#,3, 20
	silence 10
	note A#,3
	note D#,4, 20
	silence 10
	note D#,4, 20
	note A#,3, 5
	silence
	note D#,4, 10
	note A#,3
	note D#,4, 5
	silence
	note A#,3, 10
	note D#,3
	note F_,3, 5
	silence
	note C#,4
	silence
	note A#,3, 10
	note F_,4, 5
	silence
	note C#,4, 10
	note A#,3, 20
	silence 10
	note A#,3, 20
	note F_,3, 5
	silence
	note A#,3, 10
	note F_,3
	note G#,3, 20
	silence 10
	note G#,3, 20
	note C_,4, 5
	silence
	note C#,4
	silence
	note D_,4, 10
	note D#,4, 20
	silence 10
	note D#,4, 30
	silence 10
	note A#,3, 5
	silence
	note D#,4, 20
	silence 10
	note D#,4, 20
	note A#,3, 5
	silence
	note G#,3, 10
	note A_,3, 5
	silence
	note A#,3, 20
	silence 10
	note A#,3, 30
	silence 10
	note B_,3, 5
	silence
	note C_,4, 20
	silence 10
	note C_,4, 20
	note A#,3, 5
	silence
	note G#,3
	silence
	note G_,3, 10
	note F_,3, 15
	silence 5
	note F_,3, 10
	note C_,4
	note F#,4, 2
	note G_,4, 8
	note F_,4, 10
	note C_,4
	note F_,3
	note C#,4, 5
	silence
	note G#,3, 10
	note C#,4
	note G#,3
	note D#,4
	note A#,3
	note D#,4
	note A#,3
	note F_,3
	note C_,4
	note G#,3, 2
	note G_,4, 8
	note F_,4, 10
	note D#,4
	note C#,4, 5
	silence
	note C_,4
	silence
	note F_,3, 10
	note F#,3, 15
	note G#,3, 5
	silence 10
	note A#,3, 20
	note B_,3, 2
	note C_,4, 3
	note C#,4, 5
	snd_loop SndData_BGM_02_Ch3
SndData_BGM_02_Ch4:
	panning $88
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $91
	note4 F#,5,0, 5
	envelope $91
	note4 E_,5,0, 5
	snd_call SndCall_BGM_01_Ch4_4
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 5
	note4 G#,4,0, 5
	envelope $91
	note4 G_,5,0, 10
	envelope $91
	note4 F#,5,0, 10
	envelope $91
	note4 G_,5,0, 5
	envelope $91
	note4 F#,5,0, 5
	envelope $91
	note4 E_,5,0, 10
	snd_call SndCall_BGM_01_Ch4_4
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $51
	note4 C_,6,0, 5
	envelope $53
	note4x $13, 5 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $91
	note4 E_,5,0, 10
.loop0:
	envelope $C1
	note4 G#,4,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 5
	envelope $53
	note4x $13, 15 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	snd_loop .loop0, $00, 3
	envelope $C1
	note4 G#,4,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
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
.loop1:
	snd_call SndCall_BGM_02_Ch4_1
	snd_loop .loop1, $00, 7
	envelope $C1
	note4 G#,4,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 5
	envelope $A1
	note4 A_,5,0, 5
	envelope $51
	note4 C_,6,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $91
	note4 F#,5,0, 10
.loop2:
	snd_call SndCall_BGM_02_Ch4_1
	snd_loop .loop2, $00, 8
	envelope $C1
	note4 G#,4,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 5
	envelope $A1
	note4 A_,5,0, 5
	envelope $91
	note4 F#,5,0, 10
	envelope $91
	note4 E_,5,0, 10
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $91
	note4 G_,5,0, 10
	snd_call SndCall_BGM_02_Ch4_2
	envelope $C1
	note4 G#,4,0, 10
	note4 G#,4,0, 10
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
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 5
	envelope $53
	note4x $13, 15 ; Nearest: G#,6,0
	note4x $13, 20 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 5
	note4 G#,4,0, 5
	snd_loop SndData_BGM_02_Ch4
SndCall_BGM_02_Ch4_1:
	envelope $C1
	note4 G#,4,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 5
	envelope $A1
	note4 A_,5,0, 5
	envelope $51
	note4 C_,6,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	snd_ret
SndCall_BGM_02_Ch4_2:
	envelope $C1
	note4 G#,4,0, 10
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
	envelope $C1
	note4 G#,4,0, 10
	snd_loop SndCall_BGM_02_Ch4_2, $00, 8
	snd_ret
