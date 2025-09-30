SndHeader_BGM_01:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_01_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_01_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_01_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_01_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_BGM_01_Ch1:
	envelope $98
	panning $11
	duty_cycle 0
	silence 20
	vibrato_on $01
	snd_call SndCall_BGM_01_Ch1_7
	snd_call SndCall_BGM_01_Ch1_8
	snd_call SndCall_BGM_01_Ch1_7
	snd_call SndCall_BGM_01_Ch1_9
	snd_call SndCall_BGM_01_Ch1_1
	snd_call SndCall_BGM_01_Ch1_2
	snd_call SndCall_BGM_01_Ch1_1
	snd_call SndCall_BGM_01_Ch1_3
	snd_call SndCall_BGM_01_Ch1_4
	snd_call SndCall_BGM_01_Ch1_5
	snd_call SndCall_BGM_01_Ch1_4
	snd_call SndCall_BGM_01_Ch1_6
.loop0:
	snd_call SndCall_BGM_01_Ch1_0
	envelope $A8
	note E_,5, 2
	envelope $C8
	note F_,5, 8
	note D#,5, 10
	note F_,5
	note D#,5, 40
	continue 10
	envelope $98
	note D#,5, 5
	envelope $78
	note D#,5
	envelope $68
	note D#,5
	envelope $38
	note D#,5
	silence 28
	envelope $A8
	note D_,5, 2
	envelope $C8
	note D#,5, 10
	note D#,5, 5
	silence 2
	envelope $98
	note D#,5, 5
	silence 8
	envelope $C8
	note D#,5, 20
	note D_,5, 2
	note C#,5, 3
	note C_,5, 2
	note B_,4, 3
	note A#,4, 20
	silence 8
	envelope $78
	note A#,4, 2
	envelope $A8
	note F#,5, 3
	envelope $C8
	note G_,5, 8
	note F_,5, 40
	envelope $98
	note F_,5, 5
	envelope $78
	note F_,5
	envelope $68
	note F_,5
	envelope $38
	note F_,5
	envelope $A8
	note C#,5, 2
	envelope $C8
	note D_,5, 8
	note D_,5, 5
	silence 2
	envelope $98
	note D_,5, 3
	envelope $C8
	note D_,5, 8
	envelope $A8
	note C#,5, 2
	envelope $C8
	note D_,5, 5
	silence 2
	envelope $98
	note D_,5, 3
	envelope $C8
	note D_,5, 9
	silence 1
	note D_,5, 10
	note C_,5, 20
	envelope $A8
	note A_,4, 2
	envelope $C8
	note A#,4, 17
	note C_,5, 40
	continue 10
	envelope $A8
	note C_,5, 5
	envelope $88
	note C_,5
	envelope $78
	note C_,5
	envelope $68
	note C_,5
	envelope $58
	note C_,5
	envelope $48
	note C_,5
	envelope $38
	note C_,5
	envelope $28
	note C_,5
	envelope $A8
	note G_,4, 2
	envelope $C8
	note G#,4, 18
	envelope $68
	note G#,4, 5
	envelope $38
	note G#,4
	envelope $A8
	note D#,5, 2
	envelope $C8
	note D#,5, 28
	envelope $88
	note D#,5, 5
	envelope $68
	note D#,5
	envelope $48
	note D#,5
	envelope $28
	note D#,5
	envelope $A8
	note A_,4, 2
	envelope $C8
	note A#,4, 18
	envelope $68
	note A#,4, 5
	envelope $38
	note A#,4
	envelope $A8
	note F_,5, 2
	envelope $C8
	note F_,5, 28
	envelope $A8
	note D_,5, 2
	envelope $C8
	note D#,5, 8
	note F_,5, 10
	note F#,5, 60
	envelope $88
	note F#,5, 5
	envelope $68
	note F#,5
	envelope $48
	note F#,5
	envelope $28
	note F#,5
	duty_cycle 3
	envelope $A8
	note G#,5, 20
	note G_,5, 5
	note F#,5, 2
	note F_,5, 3
	note E_,5, 2
	note D#,5, 3
	note D_,5, 2
	note C#,5, 3
	note C_,5, 2
	note B_,4, 3
	note A#,4, 2
	envelope $48
	note D_,5, 3
	note C#,5, 2
	note C_,5, 3
	note B_,4, 2
	note A#,4, 3
	duty_cycle 2
	envelope $A8
	note E_,5, 2
	envelope $C8
	note F_,5, 18
	note D#,5, 15
	envelope $78
	note D#,5, 5
	duty_cycle 3
	envelope $B8
	note A_,5, 2
	note A#,5, 8
	note A_,5, 2
	note A#,5, 23
	envelope $A8
	note A_,5, 2
	envelope $98
	note G#,5, 3
	envelope $88
	note G_,5, 2
	envelope $78
	note F#,5, 3
	envelope $68
	note A#,5, 2
	envelope $58
	note A_,5, 3
	envelope $48
	note G#,5, 2
	envelope $38
	note G_,5, 3
	envelope $28
	note F#,5, 2
	silence 3
	silence 8
	envelope $A8
	note C_,5, 2
	envelope $B8
	note C#,5, 10
	note G#,4
	note F_,4, 20
	envelope $98
	note F_,4, 5
	envelope $78
	note F_,4
	envelope $A8
	note G_,4, 2
	envelope $B8
	note G#,4, 8
	note A#,4, 10
	envelope $98
	note A#,4, 5
	envelope $78
	note A#,4
	envelope $B8
	note C_,5, 10
	note G#,4
	note C#,4, 15
	envelope $78
	note C#,4, 5
	envelope $58
	note C#,4
	envelope $38
	note C#,4
	envelope $98
	note F#,4, 2
	envelope $A8
	note G_,4, 18
	envelope $B8
	note G#,4, 10
	envelope $88
	note G#,4, 5
	envelope $68
	note G#,4
	envelope $B8
	note C#,5, 10
	envelope $88
	note C#,5, 5
	envelope $68
	note C#,5
	envelope $B8
	note D#,5, 10
	envelope $88
	note D#,5, 5
	envelope $68
	note D#,5
	snd_loop .loop0
SndCall_BGM_01_Ch1_0:
	duty_cycle 2
	envelope $A8
	note A_,4, 2
	envelope $C8
	note A#,4, 8
	note C_,5, 5
	silence 2
	envelope $78
	note C_,5, 3
	envelope $C8
	note D#,5, 10
	note D#,5, 5
	silence 2
	envelope $78
	note D#,5, 3
	duty_cycle 3
	envelope $C8
	note A#,4, 10
	note A_,4, 2
	note G#,4, 3
	note G_,4, 2
	note F#,4, 3
	duty_cycle 2
	envelope $A8
	note A_,4, 2
	envelope $C8
	note A#,4, 18
	note D#,5, 10
	note F_,5, 40
	continue 10
	envelope $98
	note F_,5, 5
	envelope $78
	note F_,5
	envelope $58
	note F_,5
	envelope $38
	note F_,5
	envelope $A8
	note D_,5, 2
	envelope $C8
	note D#,5, 8
	note F_,5, 10
	envelope $A8
	note G_,5, 2
	envelope $C8
	note G#,5, 13
	note G_,5, 15
	note D#,5, 40
	envelope $A8
	note D#,5, 5
	envelope $78
	note D#,5
	envelope $58
	note D#,5
	envelope $38
	note D#,5
	duty_cycle 3
	envelope $B8
	note D#,4, 8
	silence 2
	note D#,4, 8
	envelope $78
	note D#,4, 8
	silence 2
	envelope $58
	note D#,4, 2
	envelope $B8
	note F_,4, 8
	envelope $78
	note F_,4, 2
	duty_cycle 2
	envelope $A8
	note A_,4, 2
	envelope $C8
	note A#,4, 8
	note A#,4, 10
	note C_,5
	envelope $A8
	note D_,5, 2
	envelope $C8
	note D#,5, 8
	note D#,5, 10
	silence 8
	envelope $98
	note D#,5, 10
	envelope $78
	note D#,5, 2
	envelope $A8
	note A_,4, 2
	envelope $C8
	note A#,4, 18
	note D#,5, 20
	envelope $A8
	note E_,5, 2
	envelope $C8
	note F_,5, 18
	envelope $A8
	note E_,5, 2
	envelope $C8
	note F_,5, 18
	envelope $A8
	note G_,5, 2
	envelope $C8
	note G#,5, 18
	note G_,5, 20
	snd_ret
SndCall_BGM_01_Ch1_1:
	duty_cycle 3
	envelope $C8
	note D#,4, 5
	silence 2
	envelope $78
	note D#,4, 3
	envelope $C8
	note D#,4, 5
	silence 2
	envelope $78
	note D#,4, 3
	envelope $C8
	note D#,4, 5
	silence 2
	envelope $78
	note D#,4, 3
	envelope $C8
	note F_,4, 10
	envelope $78
	note F_,4, 8
	envelope $38
	note F_,4, 2
	envelope $C8
	note F_,4, 10
	envelope $78
	note F_,4, 8
	envelope $38
	note F_,4, 2
	envelope $C8
	note G_,4, 10
	envelope $78
	note G_,4, 8
	envelope $38
	note G_,4, 2
	envelope $C8
	note D#,4, 10
	envelope $78
	note D#,4, 8
	envelope $38
	note D#,4, 2
	envelope $C8
	note F_,4, 10
	envelope $78
	note F_,4, 8
	envelope $38
	note F_,4, 2
	envelope $C8
	note D#,4, 10
	note F_,4, 20
	snd_ret
SndCall_BGM_01_Ch1_2:
	note G_,4, 20
	envelope $78
	note G_,4, 2
	duty_cycle 2
	envelope $68
	note G#,3, 5
	note A#,3
	note D#,4
	note A#,3
	note D#,4
	note F_,4
	note D#,4
	note F_,4
	note A#,4
	note F_,4
	note A#,4
	note D#,5
	note A#,4
	note D#,5
	note F_,5
	note D#,5
	note F_,5
	note A#,5
	note F_,5
	note A#,5
	note D#,6
	note A#,5
	note D#,6
	note A#,6
	note F_,6
	note D#,6
	note A#,5
	note F_,5, 3
	snd_ret
SndCall_BGM_01_Ch1_3:
	note C_,4, 20
	envelope $78
	note C_,4, 8
	envelope $38
	note C_,4, 2
	envelope $C8
	note D#,4, 30
	note F#,4, 20
	envelope $78
	note F#,4, 8
	envelope $38
	note F#,4, 2
	envelope $C8
	note F_,4, 20
	envelope $78
	note F_,4, 8
	envelope $38
	note F_,4, 2
	envelope $C8
	note D#,4, 20
	envelope $78
	note D#,4, 8
	envelope $38
	note D#,4, 2
	envelope $C8
	note A#,4, 40
	continue 10
	envelope $A8
	note A#,4
	envelope $98
	note A#,4
	envelope $88
	note A#,4
	envelope $78
	note A#,4
	snd_ret
SndCall_BGM_01_Ch1_4:
	silence 20
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
	snd_ret
SndCall_BGM_01_Ch1_5:
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
	snd_ret
SndCall_BGM_01_Ch1_6:
	note A#,3, 18
	silence 2
	note A#,3, 20
	note C_,4
	note D#,4
	note B_,3, 15
	note C#,4, 5
	silence 10
	note G#,3, 20
	envelope $98
	note G#,3, 5
	envelope $78
	note G#,3
	snd_ret
SndData_BGM_01_Ch2:
	envelope $98
	panning $22
	duty_cycle 0
	silence 20
	vibrato_on $01
	silence 80
	silence 80
	silence 80
	silence 80
	snd_call SndCall_BGM_01_Ch1_7
	snd_call SndCall_BGM_01_Ch1_8
	snd_call SndCall_BGM_01_Ch1_7
	snd_call SndCall_BGM_01_Ch1_9
	snd_call SndCall_BGM_01_Ch1_7
	snd_call SndCall_BGM_01_Ch1_8
	envelope $87
	duty_cycle 2
	note G#,4, 30
	note C_,5
	note D#,5
	note C#,5
	note C_,5
	envelope $A2
	duty_cycle 0
	note D#,5, 5
	note A#,3
.loop0:
	note F_,4, 5
	note A#,5
	note D#,5
	note A#,3
	snd_loop .loop0, $00, 3
	note F_,4
	note A#,5
	note D#,5, 2
	envelope $98
	duty_cycle 1
	note C_,5, 3
	note C#,6
	note D_,6, 2
	snd_call SndCall_BGM_01_Ch2_3
	note D#,5, 10
	envelope $68
	note D#,5, 5
	envelope $38
	note D#,5
	envelope $A8
	note A#,3, 10
	envelope $78
	note A#,3, 5
	envelope $58
	note A#,3
	envelope $A8
	note C#,4, 40
	note B_,3, 30
	note C#,4, 20
	note B_,3, 5
	silence
	note G#,5, 10
	note A#,5, 5
	silence
	envelope $A7
	duty_cycle 2
	note D#,4, 20
	note G#,4
	note A#,4
	note D#,5
	note E_,5, 15
	note F#,5, 5
	silence 10
	note D#,5, 30
	envelope $A8
	duty_cycle 1
	note G#,4, 20
.loop1:
	snd_call SndCall_BGM_01_Ch2_4
	envelope $A8
	note G_,4, 5
	silence 2
	envelope $68
	note G_,4, 3
	envelope $A8
	note C_,4, 5
	silence 2
	envelope $68
	note C_,4, 3
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $68
	note D#,4, 3
	envelope $A8
	note G_,4, 5
	silence 2
	envelope $68
	note G_,4, 3
	envelope $A8
	note C_,4, 5
	silence 2
	envelope $68
	note C_,4, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $A8
	note F#,4, 2
	envelope $C8
	note G_,4, 8
	note F_,4, 5
	silence 2
	envelope $A8
	note F_,4, 3
	envelope $C8
	note C_,4, 15
	note A#,3, 5
	silence 3
	envelope $68
	note A#,3, 5
	silence 2
	envelope $C8
	note G_,3, 30
	note C_,5, 5
	note F_,5
	note G_,5
	note G#,5
	note A#,5
	envelope $A8
	note G#,5, 2
	note A#,5, 3
	note C_,4, 5
	silence 2
	envelope $68
	note C_,4, 3
	envelope $A8
	note G_,4, 5
	silence 2
	envelope $68
	note G_,4, 3
	envelope $A8
	note C_,4, 5
	silence 2
	envelope $68
	note C_,4, 3
	envelope $A8
	note A#,4, 5
	silence 2
	envelope $68
	note A#,4, 3
	envelope $A8
	note C_,4, 5
	silence 2
	envelope $68
	note C_,4, 3
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $68
	note D#,4, 3
	envelope $A8
	note G_,4, 5
	silence 2
	envelope $68
	note G_,4, 3
	envelope $A8
	note A#,4, 5
	silence 2
	envelope $68
	note A#,4, 3
	envelope $A8
	note D_,4, 5
	silence 2
	envelope $68
	note D_,4, 3
	envelope $A8
	note C#,5, 2
	envelope $C8
	note D_,5, 8
	note D_,5, 5
	silence 2
	envelope $68
	note D_,5, 3
	envelope $C8
	note C#,5, 10
	note F_,5, 5
	silence 2
	envelope $68
	note F_,5, 3
	envelope $A8
	note F_,4, 5
	silence 2
	envelope $68
	note F_,4, 3
	envelope $A8
	note F_,3, 5
	silence 2
	envelope $68
	note F_,3, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $68
	note G_,3, 3
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
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $68
	note G_,3, 3
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
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $68
	note D#,4, 3
	envelope $A8
	note C_,4, 5
	silence 2
	envelope $68
	note C_,4, 3
	envelope $A8
	note A#,4, 5
	silence 2
	envelope $68
	note A#,4, 3
	envelope $A8
	note F#,5, 2
	envelope $C8
	note G_,5, 18
	envelope $A8
	note C_,4, 5
	silence 2
	envelope $68
	note C_,4, 3
	envelope $A8
	note A#,4, 5
	silence 2
	envelope $68
	note A#,4, 3
	envelope $A8
	note C_,4, 5
	silence 2
	envelope $68
	note C_,4, 3
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $68
	note D#,4, 3
	envelope $B8
	note D_,5, 2
	silence 3
	envelope $B8
	note D#,5, 2
	envelope $68
	note D_,5, 3
	envelope $B8
	note C_,5, 2
	envelope $68
	note D#,5, 3
	envelope $B8
	note D_,5, 2
	envelope $68
	note C_,5, 3
	envelope $B8
	note F_,5, 2
	envelope $68
	note D_,5, 3
	envelope $B8
	note G_,5, 2
	envelope $68
	note F_,5, 3
	envelope $B8
	note F_,5, 2
	envelope $68
	note G_,5, 3
	envelope $B8
	note G_,5, 2
	envelope $68
	note F_,5, 3
	envelope $B8
	note G#,5, 2
	envelope $68
	note G_,5, 3
	envelope $B8
	note C_,5, 2
	envelope $68
	note G#,5, 3
	envelope $B8
	note F_,5, 2
	envelope $68
	note C_,5, 3
	envelope $B8
	note G_,5, 2
	envelope $68
	note F_,5, 3
	envelope $B8
	note G_,5, 2
	envelope $68
	note F_,5, 3
	envelope $B8
	note G#,5, 2
	envelope $68
	note G_,5, 3
	envelope $B8
	note F_,5, 2
	envelope $68
	note G#,5, 3
	envelope $B8
	note D_,5, 5
	envelope $68
	note F_,5, 2
	note D_,5, 3
	envelope $B8
	note G_,4, 2
	silence 3
	envelope $B8
	note C_,5, 2
	envelope $68
	note G_,4, 3
	envelope $B8
	note D_,5, 2
	envelope $68
	note C_,5, 3
	envelope $B8
	note D#,5, 2
	envelope $68
	note D_,5, 3
	envelope $B8
	note D_,5, 2
	envelope $68
	note D#,5, 3
	envelope $B8
	note G_,5, 2
	envelope $68
	note D_,5, 3
	envelope $B8
	note D_,5, 2
	envelope $68
	note G_,5, 3
	envelope $B8
	note G_,5, 2
	envelope $68
	note D_,5, 3
	envelope $B8
	note G#,5, 2
	envelope $68
	note G_,5, 3
	envelope $B8
	note D_,5, 2
	envelope $68
	note G#,5, 3
	envelope $B8
	note G#,5, 2
	envelope $68
	note G_,5, 3
	envelope $B8
	note A#,5, 2
	envelope $68
	note G#,5, 3
	envelope $B8
	note C_,6, 2
	envelope $68
	note A#,5, 3
	envelope $B8
	note A#,5, 2
	envelope $68
	note C_,6, 3
	envelope $B8
	note D#,5, 2
	envelope $68
	note A#,5, 3
	envelope $B8
	note B_,4, 2
	envelope $68
	note D#,5, 3
	envelope $B8
	note A#,4, 2
	envelope $68
	note B_,4, 3
	envelope $B8
	note B_,4, 2
	envelope $68
	note A#,4, 3
	envelope $B8
	note A#,4, 2
	envelope $68
	note B_,4, 3
	envelope $B8
	note G#,4, 2
	envelope $68
	note A#,4, 3
	envelope $B8
	note F#,4, 2
	envelope $68
	note G#,4, 3
	envelope $B8
	note F_,4, 2
	envelope $68
	note F#,4, 3
	envelope $B8
	note D#,4, 2
	envelope $68
	note F_,4, 3
	envelope $B8
	note C#,4, 2
	envelope $68
	note D#,4, 3
	envelope $B8
	note D#,4, 2
	envelope $68
	note C#,4, 3
	envelope $C8
	note G#,5, 2
	envelope $68
	note D#,4, 3
	envelope $C8
	note A#,5, 5
	note B_,5
	note C_,6
	note C#,6, 20
	note C_,6, 5
	note B_,5
	note A#,5, 2
	note A_,5, 3
	note G#,5, 2
	note G_,5, 3
	note F#,5, 2
	note F_,5, 3
	note E_,5, 2
	note D#,5, 3
	silence 30
	silence 20
	envelope $B8
	note D_,6, 2
	note D#,6, 8
	note D_,6, 2
	note D#,6, 18
	silence 5
	envelope $A8
	note A#,3, 2
	silence 3
	note D#,4, 2
	envelope $58
	note A#,3, 3
	silence 2
	note D#,4, 3
	envelope $A8
	note G_,4, 2
	silence 5
	envelope $58
	note G_,4, 3
	silence 10
	envelope $A8
	note G_,4, 2
	silence 5
	envelope $58
	note G_,4, 3
	envelope $A8
	note D#,4, 2
	silence 3
	note G_,4, 2
	envelope $58
	note D#,4, 3
	silence 2
	note G_,4, 3
	envelope $A8
	note A#,3, 2
	silence 5
	envelope $58
	note A#,3, 3
	envelope $A8
	note G_,4, 2
	silence 5
	envelope $58
	note G_,4, 3
	envelope $A8
	note A#,3, 2
	silence 3
	envelope $C8
	note C_,5, 2
	note C#,5, 8
	note D#,5, 10
	silence 10
	envelope $A8
	note G_,4, 2
	silence 5
	envelope $58
	note G_,4, 3
	envelope $A8
	note D#,4, 2
	silence 3
	note G_,4, 2
	envelope $58
	note D#,4, 3
	silence 2
	note G_,4, 3
	envelope $A8
	note A#,3, 2
	silence 5
	envelope $58
	note A#,3, 3
	envelope $A8
	note G_,4, 2
	silence 5
	envelope $58
	note G_,4, 3
	envelope $A8
	note A#,3, 2
	silence 3
	envelope $A8
	note A_,4, 2
	envelope $B8
	note A#,4, 18
	envelope $A8
	note C#,5, 10
	envelope $78
	note C#,5, 5
	envelope $48
	note C#,5
	envelope $A8
	note F#,5, 10
	envelope $78
	note F#,5, 5
	envelope $48
	note F#,5
	envelope $A8
	note G#,5, 10
	envelope $78
	note G#,5, 5
	envelope $48
	note G#,5
	envelope $A8
	note C#,6, 10
	envelope $78
	note C#,6, 5
	envelope $48
	note C#,6
	snd_loop .loop1
SndCall_BGM_01_Ch1_7:
	envelope $42
	note D#,5, 2
	envelope $22
	note A#,5, 3
	envelope $72
	note D#,6, 2
	envelope $22
	note A#,5, 3
	envelope $72
	note D#,7, 2
	envelope $52
	note A#,6, 3
	envelope $42
	note D#,5, 2
	envelope $52
	note A#,7, 3
	envelope $72
	note D#,6, 2
	envelope $22
	note A#,5, 3
	envelope $72
	note D#,7, 2
	envelope $52
	note A#,6, 3
	envelope $72
	note D#,6, 2
	envelope $52
	note A#,7, 3
	envelope $42
	note D#,5, 2
	envelope $52
	note A#,6, 3
	envelope $72
	note D#,6, 2
	envelope $22
	note A#,5, 3
	envelope $42
	note D#,5, 2
	envelope $52
	note A#,6, 3
	envelope $72
	note D#,6, 2
	envelope $22
	note A#,5, 3
	envelope $72
	note D#,6, 2
	envelope $52
	note A#,6, 3
	envelope $42
	note D#,5, 2
	envelope $52
	note A#,6, 3
	envelope $72
	note D#,7, 2
	envelope $22
	note A#,5, 3
	envelope $42
	note D#,5, 2
	envelope $52
	note A#,7, 3
	envelope $42
	note D#,5, 2
	envelope $22
	note A#,5, 3
	snd_ret
SndCall_BGM_01_Ch1_8:
	envelope $42
	note D#,5, 2
	envelope $22
	note A#,5, 3
	envelope $72
	note D#,6, 2
	envelope $22
	note A#,5, 3
	envelope $42
	note D#,5, 2
	envelope $52
	note A#,6, 3
	envelope $42
	note D#,5, 2
	envelope $22
	note A#,5, 3
	envelope $72
	note D#,6, 2
	envelope $22
	note A#,5, 3
	envelope $42
	note D#,5, 2
	envelope $52
	note A#,6, 3
	envelope $42
	note D#,5, 2
	envelope $22
	note A#,5, 3
	envelope $42
	note D#,5, 2
	envelope $22
	note A#,5, 3
	envelope $72
	note D#,6, 2
	envelope $22
	note A#,5, 3
	envelope $42
	note D#,5, 2
	envelope $52
	note A#,6, 3
	envelope $72
	note D#,6, 2
	envelope $22
	note A#,5, 3
	envelope $72
	note D#,6, 2
	envelope $52
	note A#,6, 3
	envelope $42
	note D#,5, 2
	envelope $52
	note A#,6, 3
	envelope $72
	note D#,6, 2
	envelope $22
	note A#,5, 3
	envelope $42
	note D#,5, 2
	envelope $52
	note A#,6, 3
	envelope $42
	note D#,5, 2
	envelope $22
	note A#,5, 3
	snd_ret
SndCall_BGM_01_Ch1_9:
	envelope $42
	note D#,5, 2
	envelope $22
	note A#,5, 3
	envelope $72
	note D#,6, 2
	envelope $22
	note A#,5, 3
	envelope $42
	note D#,5, 2
	envelope $52
	note A#,6, 3
	envelope $42
	note D#,5, 2
	envelope $22
	note A#,5, 3
	envelope $72
	note D#,6, 2
	envelope $22
	note A#,5, 3
	envelope $42
	note D#,5, 2
	envelope $52
	note A#,6, 3
	envelope $42
	note D#,5, 2
	envelope $22
	note A#,5, 3
	envelope $42
	note D#,5, 2
	envelope $22
	note A#,5, 3
	envelope $72
	note D#,7, 2
	envelope $22
	note A#,5, 3
	envelope $42
	note D#,5, 2
	envelope $52
	note A#,7, 3
	envelope $72
	note D#,6, 2
	envelope $22
	note A#,5, 3
	envelope $72
	note D#,5, 2
	envelope $52
	note A#,6, 3
	envelope $72
	note D#,6, 2
	envelope $52
	note A#,5, 3
	envelope $72
	note D#,7, 2
	envelope $52
	note A#,6, 3
	envelope $72
	note D#,5, 2
	envelope $52
	note A#,7, 3
	envelope $42
	note D#,6, 2
	envelope $52
	note A#,5, 3
	snd_ret
SndCall_BGM_01_Ch2_3:
	note D#,6, 15
	note D_,6, 2
	note C#,6, 3
	note C_,6
	note B_,5, 2
	note A#,5
	note A_,5, 3
	note G#,5
	note G_,5, 2
	note F#,5
	note F_,5, 3
	note E_,5
	note D#,5, 2
	note D_,5
	note C#,5, 3
	envelope $48
	note F_,5, 2
	note E_,5, 3
	note D#,5
	note D_,5, 2
	envelope $A8
	note C#,4, 20
	note B_,3, 30
	note C#,4, 20
	note B_,3, 5
	silence
	note G#,5, 10
	note A#,5, 5
	silence
	envelope $78
	note G#,5, 10
	envelope $58
	note A#,5, 5
	silence
	envelope $A8
	note A#,3, 10
	envelope $78
	note A#,3, 5
	envelope $58
	note A#,3
	envelope $A8
	note C#,4, 40
	note B_,3, 30
	note A#,3, 20
	envelope $A8
	note E_,5, 2
	note F_,5, 3
	note F#,5, 5
	note F_,5, 10
	note E_,5
	snd_ret
SndCall_BGM_01_Ch2_4:
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $68
	note G_,3, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $C8
	note D#,5, 10
	note D_,5, 2
	note C#,5, 3
	note C_,5, 2
	note A#,4, 3
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $68
	note D#,4, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $68
	note G_,3, 3
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $68
	note D#,4, 3
	envelope $A8
	note D_,4, 5
	silence 2
	envelope $68
	note D_,4, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $A8
	note F_,3, 5
	silence 2
	envelope $68
	note F_,3, 3
	envelope $A8
	note D_,4, 5
	silence 2
	envelope $68
	note D_,4, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $A8
	note A_,3, 5
	silence 2
	envelope $68
	note A_,3, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $A8
	note D_,4, 5
	silence 2
	envelope $68
	note D_,4, 3
	envelope $A8
	note F_,4, 5
	silence 2
	envelope $68
	note F_,4, 3
	envelope $A8
	note C#,4, 5
	silence 2
	envelope $68
	note C#,4, 3
	envelope $A8
	note G#,3, 5
	silence 2
	envelope $68
	note G#,3, 3
	envelope $A8
	note F_,4, 5
	silence 2
	envelope $68
	note F_,4, 3
	envelope $A8
	note C#,4, 5
	silence 2
	envelope $68
	note C#,4, 3
	envelope $A8
	note G#,3, 5
	silence 2
	envelope $68
	note G#,3, 3
	envelope $C8
	note F_,4, 5
	note G#,4
	note A#,4
	note C_,5
	silence 2
	envelope $68
	note C_,5, 3
	silence 5
	envelope $C8
	note C_,5, 8
	envelope $68
	note C_,5, 2
	envelope $C8
	note C_,5, 8
	envelope $68
	note C_,5, 2
	silence 10
	envelope $C8
	note D_,5, 8
	envelope $68
	note D_,5, 2
	envelope $C8
	note A#,5, 20
	envelope $98
	note A#,5, 2
	envelope $78
	note A#,5, 3
	envelope $58
	note A#,5, 2
	envelope $38
	note A#,5, 3
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $68
	note G_,3, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $C8
	note D#,5, 10
	note D_,5, 2
	note C#,5, 3
	note C_,5, 2
	note A#,4, 3
	envelope $A8
	note D#,4, 5
	note A#,4, 2
	envelope $68
	note D#,4, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $68
	note G_,3, 3
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $68
	note D#,4, 3
	envelope $A8
	note C_,4, 5
	silence 2
	envelope $68
	note C_,4, 3
	envelope $A8
	note G#,3, 5
	silence 2
	envelope $68
	note G#,3, 3
	envelope $A8
	note F_,3, 5
	silence 2
	envelope $68
	note F_,3, 3
	envelope $A8
	note D_,4, 5
	silence 2
	envelope $68
	note D_,4, 3
	envelope $A8
	note B_,3, 5
	silence 2
	envelope $68
	note B_,3, 3
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $68
	note G_,3, 3
	envelope $A8
	note B_,3, 5
	silence 2
	envelope $68
	note B_,3, 3
	envelope $A8
	note D_,4, 5
	silence 2
	envelope $68
	note D_,4, 3
	snd_ret
SndData_BGM_01_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	wave_cutoff 0
	silence 20
	silence 80
	continue 80
	continue 60
	continue 10
	continue 2
	note C_,4, 3
	note C#,4, 2
	note D_,4, 3
	note D#,4, 40
	note D#,4, 8
	note D_,4, 2
	note C#,4
	note C_,4, 3
	note B_,3, 2
	note A#,3, 3
	note A_,3, 2
	note G#,3, 3
	note G_,3, 2
	note F#,3, 3
	note F_,3, 2
	note E_,3, 3
	note D#,3, 2
	note D_,3, 3
	snd_call SndCall_BGM_01_Ch3_0
	wave_vol $80
	note A#,4, 5
	note G#,4
	note A#,4
	note D#,5
	note A#,4
	note D#,5
	note F_,5
	note D#,5
	note F_,5
	note A#,5
	note F_,5
	note A#,5
	note D#,6
	note A#,5
	note D#,6
	note F_,6
	note D#,6
	note F_,6
	note A#,6
	note F_,6
	note A#,6
	note D#,7
	note A#,6
	note D#,7
	note A#,7
	note F_,7
	note D#,7
	note A#,6
	note F_,6
	note D#,6
	note A#,5
	note F_,5
	wave_vol $C0
	snd_call SndCall_BGM_01_Ch3_0
	note A#,3, 30
	note C#,4
	note E_,4
	note D#,4
	note C#,4
	note A#,3, 20
	silence 10
	note A#,3, 15
	note D#,4, 5
	note F_,4
	note G#,4
	note A#,4
	note C_,5
	note D#,5
	note A#,4
	note G#,4
	note F_,4
	snd_call SndCall_BGM_01_Ch3_1
.loop1:
	snd_call SndCall_BGM_01_Ch3_2
	note A#,3, 20
	note F_,4, 10
	note A#,3
	silence 20
	note A#,3
	note G#,3
	silence 10
	note G#,3
	silence
	note G_,3
	note G#,3, 8
	silence 2
	note A_,3, 8
	silence 2
	note A#,3, 28
	silence 2
	note A#,3, 40
	continue 8
	silence 2
	note G_,3, 28
	silence 2
	note G_,3, 18
	silence 2
	note G_,3, 10
	note D_,4, 8
	silence 2
	note C_,4, 28
	silence 2
	note C_,4, 8
	silence 2
	note C_,4, 20
	note D_,4, 10
	note D#,4, 8
	silence 2
	note G#,3, 8
	silence 2
	note F_,3, 28
	silence 2
	note F_,4, 18
	silence 2
	note F_,4, 10
	note C_,4, 8
	silence 2
	note F_,3, 10
	note G_,3, 8
	silence 2
	note G_,3, 18
	silence 2
	note A#,3, 5
	note C_,4
	note D_,4, 10
	note G_,4, 20
	note A#,3, 10
.loop0:
	note B_,3, 8
	silence 2
	note F#,3, 10
	snd_loop .loop0, $00, 4
	note C#,4, 30
	note C_,4, 2
	note B_,3, 3
	note A#,3, 2
	note A_,3, 3
	note G#,3, 2
	note G_,3, 3
	note F#,3, 2
	note F_,3, 3
	silence 30
	note D#,3, 20
	silence 10
	note D#,4, 15
	silence 5
	note A#,3, 10
	note C#,4
	note A#,3
	note D#,3, 8
	silence 2
	note D#,3, 8
	silence 2
	note D#,4, 8
	silence 2
	note D#,4, 15
	silence 5
	note G#,3, 8
	silence 2
	note A_,3, 10
	note A#,3
	note D#,3, 8
	silence 2
	note D#,3, 8
	silence 2
	note D#,4, 8
	silence 2
	note D#,4, 15
	silence 5
	note F_,4, 8
	silence 2
	note E_,4, 10
	note D#,4
	note C#,4, 8
	silence 2
	note G#,3, 10
	note C#,4, 8
	silence 2
	note G#,3, 10
	note C#,4, 8
	silence 2
	note G#,3, 10
	note C#,4, 8
	silence 2
	note G#,3, 10
	snd_loop .loop1
SndCall_BGM_01_Ch3_0:
	note C#,3, 20
	note F_,3, 10
	note C#,3
	silence
	note C#,3
	note G#,3
	note C#,3
	snd_loop SndCall_BGM_01_Ch3_0, $00, 2
	snd_ret
SndCall_BGM_01_Ch3_1:
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
	note F#,3, 8
	silence 2
	note F_,3, 10
	note E_,3
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
	note D#,4, 20
	note C#,4
	note C_,4
	note A#,3
	note B_,3, 15
	note C#,4, 5
	silence 10
	note A#,3, 30
	note F_,4, 10
	note A#,3
	snd_ret
SndCall_BGM_01_Ch3_2:
	note D#,3, 10
	note D#,3
	note D#,4, 8
	silence 2
	note D#,4, 3
	silence 2
	note D#,4, 5
	silence 10
	note A#,3
	note C_,4, 5
	silence
	note D#,4, 8
	silence 2
	note D_,4, 10
	silence 5
	note C_,4, 8
	silence 7
	note A#,3, 20
	note A_,3, 8
	silence 2
	note A#,3, 8
	silence 2
	note C_,4, 8
	silence 2
	note C#,4, 10
	silence 5
	note G#,3, 10
	silence 5
	note C#,4, 15
	silence 5
	note C#,4, 8
	silence 2
	note C_,4, 10
	note A#,3
	silence
	note G#,3, 8
	silence 2
	note G#,3, 10
	silence
	note A#,3, 8
	silence 2
	note G#,3, 8
	silence 2
	note G_,3, 8
	silence 2
	note F_,3, 8
	silence 2
	note D#,3, 10
	note D#,3
	note D#,4, 8
	silence 2
	note D#,4, 3
	silence 2
	note D#,4, 5
	silence 10
	note A#,3
	note C_,4, 5
	silence
	note D#,4, 8
	silence 2
	note D_,4, 10
	note F_,3
	note G#,3
	note G_,3
	silence
	note G_,3, 8
	silence 2
	note D_,4, 10
	note G_,3
	note C_,4, 20
	silence 10
	note C_,4
	silence
	note G_,3
	note C_,4
	note B_,3
	snd_ret
SndData_BGM_01_Ch4:
	panning $88
	envelope $91
	note4 F#,5,0, 20
	snd_call SndCall_BGM_01_Ch4_0
	snd_call SndCall_BGM_01_Ch4_1
	snd_call SndCall_BGM_01_Ch4_2
	snd_call SndCall_BGM_01_Ch4_3
	snd_call SndCall_BGM_01_Ch4_1
	snd_call SndCall_BGM_01_Ch4_2
	envelope $C1
	note4 G#,4,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 30
	note4 G#,4,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 20
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $91
	note4 G_,5,0, 10
	envelope $91
	note4 F#,5,0, 10
	envelope $91
	note4 E_,5,0, 10
	envelope $C1
	note4 G#,4,0, 30
	envelope $C1
	note4 G#,4,0, 5
	note4 G#,4,0, 5
.loop0:
	envelope $A1
	note4 A_,5,0, 5
	snd_loop .loop0, $00, 10
.loop1:
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
	snd_loop .loop1, $00, 5
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
	envelope $91
	note4 G_,5,0, 10
	envelope $91
	note4 F#,5,0, 10
	envelope $91
	note4 E_,5,0, 10
.loop2:
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	snd_loop .loop2, $00, 4
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
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $91
	note4 F#,5,0, 5
	envelope $91
	note4 E_,5,0, 5
.loop3:
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
	snd_call SndCall_BGM_01_Ch4_5
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
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
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
	note4 A_,5,0, 50
	envelope $C1
	note4 G#,4,0, 10
	envelope $91
	note4 F#,5,0, 20
	snd_call SndCall_BGM_01_Ch4_6
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 5
	envelope $53
	note4x $13, 5 ; Nearest: G#,6,0
	envelope $51
	note4 C_,6,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $91
	note4 F#,5,0, 10
	envelope $91
	note4 G_,5,0, 5
	note4 G_,5,0, 5
	envelope $91
	note4 E_,5,0, 10
	snd_loop .loop3
SndCall_BGM_01_Ch4_0:
	envelope $91
	note4 E_,5,0, 10
	envelope $C1
	note4 G#,4,0, 5
	envelope $91
	note4 E_,5,0, 5
	envelope $91
	note4 G_,5,0, 10
	envelope $91
	note4 F#,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $91
	note4 F#,5,0, 10
	note4 F#,5,0, 10
	note4 F#,5,0, 10
	snd_loop SndCall_BGM_01_Ch4_0, $00, 3
	snd_ret
SndCall_BGM_01_Ch4_1:
	envelope $91
	note4 E_,5,0, 10
	envelope $C1
	note4 G#,4,0, 5
	envelope $91
	note4 E_,5,0, 5
	envelope $91
	note4 G_,5,0, 10
	envelope $91
	note4 F#,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
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
SndCall_BGM_01_Ch4_2:
	envelope $C1
	note4 G#,4,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	snd_loop SndCall_BGM_01_Ch4_2, $00, 8
	snd_ret
SndCall_BGM_01_Ch4_3:
	envelope $91
	note4 E_,5,0, 10
	envelope $C1
	note4 G#,4,0, 5
	envelope $91
	note4 E_,5,0, 5
	envelope $91
	note4 G_,5,0, 10
	envelope $91
	note4 F#,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $91
	note4 F#,5,0, 10
	note4 F#,5,0, 10
	note4 F#,5,0, 10
	snd_ret
SndCall_BGM_01_Ch4_4:
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
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $51
	note4 C_,6,0, 10
	snd_loop SndCall_BGM_01_Ch4_4, $00, 3
	snd_ret
SndCall_BGM_01_Ch4_5:
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 5
	envelope $53
	note4x $13, 5 ; Nearest: G#,6,0
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
	snd_loop SndCall_BGM_01_Ch4_5, $00, 4
	snd_ret
SndCall_BGM_01_Ch4_6:
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 5
	envelope $53
	note4x $13, 5 ; Nearest: G#,6,0
	envelope $51
	note4 C_,6,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	snd_loop SndCall_BGM_01_Ch4_6, $00, 2
	snd_ret
