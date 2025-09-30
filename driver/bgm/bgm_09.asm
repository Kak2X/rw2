SndHeader_BGM_09:
	db $03 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_09_Ch1 ; Data ptr
	db 3 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_09_Ch2 ; Data ptr
	db 3 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_09_Ch3 ; Data ptr
	db 3 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw Padding_00037FC9 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_BGM_09_Ch1:
	envelope $11
	panning $11
	duty_cycle 2
	vibrato_on $01
	envelope $A8
	note A#,3, 32
	envelope $88
	note A#,3, 8
	silence 4
	envelope $68
	note A#,3
	envelope $A8
	note F_,3, 8
	note G_,3
	note G#,3, 16
	note A#,3
	note C_,4, 8
	note C#,4
	note D#,4
	note F_,4
	note F#,4, 32
	silence 4
	envelope $88
	note F#,4, 4
	envelope $A8
	note G#,3, 8
	note B_,3
	note D#,4
	note G#,4, 24
	silence 4
	envelope $88
	note G#,4
	envelope $A8
	note F#,4, 16
	note G#,4
	note F_,4, 32
	silence 4
	envelope $88
	note F_,4, 4
	envelope $A8
	note A#,4, 8
	note A_,4
	note A#,4
	note C_,5
	note F_,4
	note F_,5, 16
	note F_,4
	note G_,4
	note G#,4, 32
	silence 4
	envelope $88
	note G#,4
	envelope $A8
	note D#,5, 8
	note G#,4
	note C_,5
	note D#,5
	note G#,4
	note G#,5, 16
	note D#,5
	note F_,5
	duty_cycle 3
	snd_call SndCall_BGM_09_Ch1_0
	snd_call SndCall_BGM_09_Ch1_1
	snd_call SndCall_BGM_09_Ch1_5
	note D_,6, 6
	silence 2
	note D_,6, 6
	silence 2
	note D#,6, 6
	silence 2
	note E_,6, 6
	silence 2
	note F_,6, 96
	envelope $88
	note F_,6, 8
	silence 4
	envelope $68
	note F_,6
	envelope $48
	note F_,6, 8
	silence 4
	envelope $38
	note F_,6
	duty_cycle 2
	snd_call SndCall_BGM_09_Ch1_2
	note E_,5, 64
	continue 8
	envelope $88
	note E_,5
	silence 4
	envelope $68
	note E_,5
	envelope $48
	note E_,5, 8
	silence 4
	envelope $38
	note E_,5
	envelope $98
	note C_,4, 8
	envelope $48
	note D_,4
	envelope $68
	note C_,4
	note D_,4
	envelope $88
	note C_,4
	note D_,4
	envelope $A8
	note C_,4
	note D_,4
	envelope $C8
	note C_,4
	note D_,4
	envelope $D8
	note C_,4
	note D_,4
	envelope $E8
	note C_,4
	note D_,4
	envelope $F8
	note C_,4
	note D_,4
	snd_call SndCall_BGM_09_Ch1_2
	note G_,5, 64
	continue 8
	envelope $88
	note G_,5
	silence 4
	envelope $68
	note G_,5
	envelope $48
	note G_,5, 8
	silence 4
	envelope $38
	note G_,5
	envelope $98
	note D_,4, 8
	envelope $48
	note E_,4
	envelope $68
	note D_,4
	note E_,4
	envelope $88
	note D_,4
	note E_,4
	envelope $A8
	note D_,4
	note E_,4
	envelope $C8
	note D_,4
	note E_,4
	envelope $D8
	note F_,4
	note G_,4
	envelope $E8
	note A_,4
	note B_,4
	envelope $F8
	note C_,5
	note D_,5
	snd_call SndCall_BGM_09_Ch1_3
	fine_tune 1
	snd_call SndCall_BGM_09_Ch1_3
	fine_tune 2
	snd_call SndCall_BGM_09_Ch1_3
	fine_tune 2
	snd_call SndCall_BGM_09_Ch1_3
	fine_tune -5
	snd_call SndCall_BGM_09_Ch1_4
	fine_tune 3
	snd_call SndCall_BGM_09_Ch1_4
	fine_tune -3
	note D_,4, 8
	note E_,4
	note F#,4
	note G_,4
	note E_,4
	note F#,4
	note G_,4
	note A_,4
	note F_,4
	note G_,4
	note A_,4
	note B_,4
	note A_,4
	note B_,4
	note C_,5
	note D_,5
	note G#,4
	note A#,4
	note C_,5
	note C#,5
	note A#,4
	note C_,5
	note C#,5
	note D#,5
	note C_,5
	note D_,5
	note E_,5
	note F_,5
	note G_,5
	note A_,5
	note A#,5
	note B_,5
	envelope $A8
	note F_,5, 16
	silence 4
	envelope $88
	note F_,5
	envelope $A8
	note D_,5, 16
	silence 4
	envelope $88
	note D_,5
	envelope $A8
	note F_,5, 8
	silence 4
	envelope $88
	note F_,5
	envelope $A8
	note G_,5, 16
	silence 4
	envelope $88
	note G_,5
	envelope $A8
	note E_,5, 16
	silence 4
	envelope $88
	note E_,5
	envelope $A8
	note G_,5, 8
	silence 4
	envelope $88
	note G_,5
	envelope $A8
	note A_,5, 48
	envelope $88
	note A_,5, 8
	silence 4
	envelope $68
	note F_,5
	envelope $A8
	note D_,6, 16
	note B_,5
	note G_,5
	note D_,5
	envelope $A8
	note F_,5, 16
	silence 4
	envelope $88
	note F_,5
	envelope $A8
	note D_,5, 16
	silence 4
	envelope $88
	note D_,5
	envelope $A8
	note F_,5, 8
	silence 4
	envelope $88
	note F_,5
	envelope $A8
	note G_,5, 24
	silence 4
	envelope $88
	note G_,5
	envelope $A8
	note G_,5, 6
	silence 2
	note G_,5, 6
	silence 2
	note G_,5, 6
	silence 2
	note G_,5, 6
	silence 2
	note D_,6, 96
	envelope $88
	note D_,6, 8
	silence 4
	envelope $68
	note D_,6
	envelope $48
	note D_,6, 8
	silence 4
	envelope $38
	note D_,6
	snd_loop SndData_BGM_09_Ch1
SndCall_BGM_09_Ch1_0:
	note A_,5, 8
	note D_,5
	note C_,6
	note G_,5
	snd_loop SndCall_BGM_09_Ch1_0, $00, 4
	snd_ret
SndCall_BGM_09_Ch1_1:
	note G#,5, 8
	note D#,5
	note C#,6
	note G#,5
	snd_loop SndCall_BGM_09_Ch1_1, $00, 4
	snd_ret
SndCall_BGM_09_Ch1_2:
	envelope $A8
	note E_,4, 32
	envelope $88
	note E_,4, 8
	silence 4
	envelope $68
	note E_,4
	envelope $A8
	note G_,4, 8
	note F_,4
	snd_loop SndCall_BGM_09_Ch1_2, $00, 3
	note E_,4, 16
	note G_,4
	note C_,5
	note E_,5
	note F_,5
	note E_,5, 6
	silence 2
	snd_ret
SndCall_BGM_09_Ch1_3:
	envelope $A8
	note E_,5, 16
	silence 4
	envelope $88
	note E_,5
	envelope $A8
	note E_,5, 16
	silence 4
	envelope $88
	note E_,5
	envelope $A8
	note E_,5, 8
	silence 4
	envelope $88
	note E_,5
	snd_ret
SndCall_BGM_09_Ch1_4:
	envelope $A8
	note D_,4, 8
	note G_,4
	note B_,4
	note D_,5, 24
	note B_,4, 8
	note G_,4
	note E_,5, 32
	note D_,5
	snd_loop SndCall_BGM_09_Ch1_4, $00, 2
	snd_ret
SndCall_BGM_09_Ch1_5:
	note D_,6, 6
	silence 2
	note D_,6, 6
	silence 2
	note D_,6, 14
	silence 2
	snd_loop SndCall_BGM_09_Ch1_5, $00, 3
	snd_ret
SndData_BGM_09_Ch2:
	envelope $A8
	panning $22
	duty_cycle 3
	envelope $A8
	note F_,3, 32
	envelope $88
	note F_,3, 8
	silence 4
	envelope $68
	note F_,3
	envelope $A8
	note C_,3, 8
	note D_,3, 4
	envelope $88
	note C_,3
	envelope $A8
	note D#,3, 8
	silence 4
	envelope $88
	note D#,3
	envelope $A8
	note F_,3, 8
	silence 4
	envelope $88
	note F_,3
	envelope $A8
	note G#,3, 8
	note A#,3, 4
	envelope $88
	note G#,3
	envelope $A8
	note C_,4
	envelope $88
	note A#,3
	envelope $A8
	note C#,4
	envelope $88
	note C_,4
	envelope $A8
	note D#,4, 32
	silence 4
	envelope $88
	note D#,4
	envelope $A8
	note F_,3
	silence
	note G#,3, 4
	envelope $88
	note F_,3
	envelope $A8
	note B_,3
	envelope $88
	note G#,3
	envelope $A8
	note C#,4, 16
	envelope $88
	note C#,4, 12
	silence 4
	envelope $A8
	note B_,3, 8
	silence 4
	envelope $88
	note B_,3
	envelope $A8
	note C#,4, 8
	silence 4
	envelope $88
	note C#,4
	envelope $A8
	note C_,4, 32
	silence 4
	envelope $88
	note C_,4
	envelope $A8
	note F_,4, 8
	note E_,4, 4
	envelope $88
	note F_,4
	envelope $A8
	note F_,4
	envelope $88
	note E_,4
	envelope $A8
	note G_,4
	envelope $88
	note F_,4
	envelope $A8
	note C_,4
	envelope $88
	note G_,4
	envelope $A8
	note C_,5, 12
	envelope $88
	note C_,5, 4
	envelope $A8
	note C_,4, 12
	envelope $88
	note C_,4, 4
	envelope $A8
	note D_,4, 12
	envelope $88
	note D_,4, 4
	envelope $A8
	note D#,4, 32
	silence 4
	envelope $88
	note D#,4
	envelope $A8
	note A#,4, 8
	note F_,4, 4
	envelope $88
	note A#,4
	envelope $A8
	note G#,4
	envelope $88
	note F_,4
	envelope $A8
	note A#,4
	envelope $88
	note G#,4
	envelope $A8
	note F_,4
	envelope $88
	note A#,4
	envelope $A8
	note C_,5, 8
	silence 4
	envelope $88
	note C_,5
	envelope $A8
	note A#,4, 8
	silence 4
	envelope $88
	note A#,4
	envelope $A8
	note C#,5, 8
	silence 4
	envelope $88
	note C#,5
	snd_call SndCall_BGM_09_Ch2_0
	envelope $A8
	note A#,4, 4
	envelope $88
	note D_,4
	envelope $A8
	note B_,4
	envelope $88
	note A#,4
	envelope $A8
	note C#,5
	envelope $88
	note B_,4
	envelope $A8
	note F#,4
	envelope $88
	note C#,5
	snd_call SndCall_BGM_09_Ch2_1
.loop0:
	envelope $A8
	note A#,4, 4
	envelope $88
	note F#,4
	envelope $A8
	note A_,4, 4
	envelope $88
	note A#,4
	envelope $A8
	note A#,4, 8
	silence 4
	envelope $88
	note A#,4
	snd_loop .loop0, $00, 3
	envelope $A8
	note A#,4, 8
	note B_,4, 4
	envelope $88
	note A#,4
	envelope $A8
	note C_,5
	envelope $88
	note B_,4
	envelope $A8
	note C#,5
	envelope $88
	note C_,5
	envelope $98
	note D_,5, 5
	note A#,4, 6
	note D_,5, 5
	note A#,5
	note D_,5, 6
	note A#,4, 5
	envelope $88
	note D_,5, 5
	note A#,4, 6
	note D_,5, 5
	note A#,5
	note D_,5, 6
	note A#,4, 5
	envelope $78
	note D_,5, 5
	note A#,4, 6
	note D_,5, 5
	note A#,5
	note D_,5, 6
	note A#,4, 5
	envelope $58
	note D_,5, 5
	note A#,4, 6
	note D_,5, 5
	note A#,5
	note D_,5, 6
	note A#,4, 5
	snd_call SndCall_BGM_09_Ch2_2
	snd_call SndCall_BGM_09_Ch2_3
	envelope $A8
	note G_,3
	envelope $88
	note C_,4
	snd_call SndCall_BGM_09_Ch2_3
	envelope $A8
	note G_,4
	envelope $88
	note C_,4
	envelope $A8
	note E_,3
	envelope $88
	note F_,3
	envelope $58
	note F_,3
	envelope $38
	note E_,3
	envelope $68
	note G_,3
	envelope $48
	note F_,3
	envelope $68
	note F_,3
	envelope $48
	note G_,3
	envelope $78
	note E_,3
	envelope $58
	note F_,3
	envelope $78
	note F_,3
	envelope $58
	note E_,3
	envelope $88
	note G_,3
	envelope $68
	note F_,3
	envelope $88
	note F_,3
	envelope $68
	note G_,3
	envelope $98
	note E_,3
	envelope $78
	note F_,3
	envelope $98
	note F_,3
	envelope $78
	note E_,3
	envelope $A8
	note G_,3
	envelope $88
	note F_,3
	envelope $B8
	note F_,3
	envelope $98
	note G_,3
	envelope $C8
	note E_,3
	envelope $A8
	note F_,3
	envelope $D8
	note F_,3
	envelope $B8
	note E_,3
	envelope $E8
	note G_,3
	envelope $C8
	note F_,3
	envelope $F8
	note F_,3
	envelope $D8
	note G_,3
	snd_call SndCall_BGM_09_Ch2_2
	envelope $A8
	note C_,5, 12
	envelope $88
	note C_,5, 4
	envelope $A8
	note G_,5
	silence
	note C_,6
	envelope $88
	note G_,5
	envelope $A8
	note D_,5, 32
	envelope $88
	note D_,5, 8
	silence 4
	envelope $68
	note D_,5
	envelope $A8
	note G_,5
	silence
	note C_,6
	envelope $88
	note G_,5
	envelope $A8
	note D_,5, 32
.loop1:
	envelope $A8
	note G_,3, 4
	envelope $88
	note A_,3
	envelope $A8
	note A_,3
	envelope $88
	note G_,3
	snd_loop .loop1, $00, 5
	envelope $A8
	note A#,3
	envelope $88
	note A_,3
	envelope $A8
	note B_,3
	envelope $88
	note A#,3
	envelope $A8
	note C_,4
	envelope $88
	note B_,3
	envelope $A8
	note D_,4
	envelope $88
	note C_,4
	envelope $A8
	note E_,4
	envelope $88
	note D_,4
	envelope $A8
	note F_,4
	envelope $88
	note E_,4
	snd_call SndCall_BGM_09_Ch2_4
	fine_tune 2
	snd_call SndCall_BGM_09_Ch2_4
	fine_tune 1
	snd_call SndCall_BGM_09_Ch2_4
	fine_tune 2
	snd_call SndCall_BGM_09_Ch2_4
	fine_tune -5
	snd_call SndCall_BGM_09_Ch2_5
	snd_call SndCall_BGM_09_Ch2_6
	envelope $A8
	note A_,3, 4
	envelope $88
	note G_,5
	envelope $A8
	note B_,3
	envelope $88
	note A_,3
	envelope $A8
	note C#,4
	envelope $88
	note B_,3
	envelope $A8
	note D_,4
	envelope $88
	note C#,4
	envelope $A8
	note B_,3
	envelope $88
	note D_,4
	envelope $A8
	note C#,4
	envelope $88
	note B_,3
	envelope $A8
	note D_,4
	envelope $88
	note C#,4
	envelope $A8
	note E_,4
	envelope $88
	note D_,4
	envelope $A8
	note D_,4
	envelope $88
	note E_,4
	envelope $A8
	note E_,4
	envelope $88
	note D_,4
	envelope $A8
	note F#,4
	envelope $88
	note E_,4
	envelope $A8
	note G_,4
	envelope $88
	note F#,4
	envelope $A8
	note E_,4
	envelope $88
	note G_,4
	envelope $A8
	note F#,4
	envelope $88
	note E_,4
	envelope $A8
	note G_,4
	envelope $88
	note F#,4
	envelope $A8
	note A_,4
	envelope $88
	note G_,4
	envelope $A8
	note C#,4
	envelope $88
	note A_,4
	envelope $A8
	note D#,4
	envelope $88
	note C#,4
	envelope $A8
	note F_,4
	envelope $88
	note D#,4
	envelope $A8
	note F#,4
	envelope $88
	note F_,4
	envelope $A8
	note F#,4
	envelope $88
	note F#,4
	envelope $A8
	note G#,4
	envelope $88
	note F#,4
	envelope $A8
	note A#,4
	envelope $88
	note G#,4
	envelope $A8
	note C_,5
	envelope $88
	note A#,4
	envelope $A8
	note A_,4
	envelope $88
	note C_,5
	envelope $A8
	note A#,4
	envelope $88
	note A_,4
	envelope $A8
	note C_,5
	envelope $88
	note A#,4
	envelope $A8
	note D_,5
	envelope $88
	note C_,5
	envelope $A8
	note E_,5
	envelope $88
	note D_,5
	envelope $A8
	note F_,5
	envelope $88
	note E_,5
	envelope $A8
	note G_,5
	envelope $88
	note F_,5
	envelope $A8
	note G#,5
	envelope $88
	note G_,5
	envelope $A8
	note D_,5, 16
	silence 4
	envelope $88
	note D_,5
	envelope $A8
	note A#,4, 16
	silence 4
	envelope $88
	note A#,4
	envelope $A8
	note D_,5, 8
	silence 4
	envelope $88
	note D_,5
	envelope $A8
	note E_,5, 16
	silence 4
	envelope $88
	note E_,5
	envelope $A8
	note C_,5, 16
	silence 4
	envelope $88
	note C_,5
	envelope $A8
	note E_,5, 8
	silence 4
	envelope $88
	note E_,5
	envelope $A8
	note F#,5, 4
	silence
	note A_,5
	envelope $88
	note F#,5
	envelope $A8
	note D_,6
	envelope $88
	note A_,5
	envelope $A8
	note G_,6
	envelope $88
	note D_,6
	envelope $A8
	note F#,6
	envelope $88
	note G_,6
	envelope $A8
	note D_,6
	envelope $88
	note F#,6
	envelope $A8
	note A_,5
	envelope $88
	note D_,6
	envelope $A8
	note F#,5
	envelope $88
	note A_,5
	envelope $A8
	note G_,5, 8
	silence 4
	envelope $88
	note G_,5
	envelope $A8
	note D_,5, 8
	silence 4
	envelope $88
	note D_,5
	envelope $A8
	note B_,4, 8
	silence 4
	envelope $88
	note B_,4
	envelope $A8
	note G_,4, 8
	silence 4
	envelope $88
	note G_,4
	envelope $A8
	note D_,5, 16
	silence 4
	envelope $88
	note D_,5
	envelope $A8
	note A#,4, 16
	silence 4
	envelope $88
	note A#,4
	envelope $A8
	note D_,5, 8
	silence 4
	envelope $88
	note D_,5
	envelope $A8
	note E_,5, 16
	envelope $88
	note E_,5, 8
	silence 4
	envelope $68
	note E_,5
	envelope $A8
	note E_,5, 6
	silence 2
	note E_,5, 4
	envelope $88
	note E_,5
	envelope $A8
	note E_,5
	envelope $88
	note E_,5
	envelope $A8
	note E_,5
	envelope $88
	note E_,5
	envelope $98
	note A_,5, 5
	note D_,6, 6
	note E_,6, 5
	note A_,6
	note E_,6, 6
	note D_,6, 5
	envelope $88
	note A_,5, 5
	note D_,6, 6
	note E_,6, 5
	note A_,6
	note E_,6, 6
	note D_,6, 5
	envelope $78
	note A_,5, 5
	note D_,6, 6
	note E_,6, 5
	note A_,6
	note E_,6, 6
	note D_,6, 5
	envelope $58
	note A_,5, 5
	note D_,6, 6
	note E_,6, 5
	note A_,6
	note E_,6, 6
	note D_,6, 5
	snd_loop SndData_BGM_09_Ch2
SndCall_BGM_09_Ch2_0:
	envelope $A8
	note F_,4, 4
	envelope $88
	note D_,4
	envelope $A8
	note A_,4
	envelope $88
	note F_,4
	envelope $A8
	note C_,5
	envelope $88
	note A_,4
	envelope $A8
	note D_,4
	envelope $88
	note C_,5
	snd_loop SndCall_BGM_09_Ch2_0, $00, 4
	snd_ret
SndCall_BGM_09_Ch2_1:
	envelope $A8
	note A#,4, 4
	envelope $88
	note F#,4
	envelope $A8
	note B_,4
	envelope $88
	note A#,4
	envelope $A8
	note C#,5
	envelope $88
	note B_,4
	envelope $A8
	note F#,4
	envelope $88
	note C#,5
	snd_loop SndCall_BGM_09_Ch2_1, $00, 3
	snd_ret
SndCall_BGM_09_Ch2_2:
	envelope $A8
	note C_,4, 8
	silence 4
	envelope $88
	note C_,4
	envelope $A8
	note G_,5
	silence
	note C_,6
	envelope $88
	note G_,5
	envelope $A8
	note C_,4
	envelope $88
	note C_,6
	silence
	note C_,4
	envelope $A8
	note E_,4, 8
	note D_,4, 4
	envelope $88
	note E_,4
	snd_loop SndCall_BGM_09_Ch2_2, $00, 3
	envelope $A8
	note C_,4, 8
	silence 4
	envelope $88
	note C_,4
	envelope $A8
	note E_,5
	silence
	note C_,6
	envelope $88
	note E_,5
	envelope $A8
	note G_,4, 8
	silence 4
	envelope $88
	note G_,4
	envelope $A8
	note C_,5, 8
	silence 4
	envelope $88
	note C_,5
	snd_ret
SndCall_BGM_09_Ch2_3:
	envelope $A8
	note C_,5, 12
	envelope $88
	note C_,5, 4
	envelope $A8
	note G_,5
	silence
	note C_,6
	envelope $88
	note G_,5
	envelope $A8
	note G_,4
	envelope $88
	note C_,6
	envelope $A8
	note E_,4
	envelope $88
	note G_,4
	envelope $A8
	note C_,4
	envelope $88
	note E_,4
	snd_ret
SndCall_BGM_09_Ch2_4:
	envelope $A8
	note G_,4, 16
	silence 4
	envelope $88
	note G_,4
	envelope $A8
	note C_,4, 16
	silence 4
	envelope $88
	note C_,4
	envelope $A8
	note G_,4, 8
	silence 4
	envelope $88
	note G_,4
	snd_ret
SndCall_BGM_09_Ch2_5:
	envelope $A8
	note B_,3, 4
	envelope $88
	note G_,5
	envelope $A8
	note D_,4
	envelope $88
	note B_,3
	envelope $A8
	note G_,4
	envelope $88
	note D_,4
	envelope $A8
	note B_,4
	envelope $88
	note G_,4
	envelope $A8
	note A_,5
	envelope $88
	note B_,4
	envelope $A8
	note G_,5
	envelope $88
	note A_,5
	envelope $A8
	note G_,4
	envelope $88
	note G_,5
	envelope $A8
	note D_,4
	envelope $88
	note G_,4
	envelope $A8
	note C#,5, 8
	silence 4
	envelope $88
	note C#,5
	envelope $A8
	note A_,5
	silence
	note G_,5
	envelope $88
	note A_,5
	envelope $A8
	note B_,4, 8
	silence 4
	envelope $88
	note B_,4
	envelope $A8
	note A_,5
	silence
	note G_,5
	envelope $88
	note A_,5
	snd_loop SndCall_BGM_09_Ch2_5, $00, 2
	snd_ret
SndCall_BGM_09_Ch2_6:
	envelope $A8
	note D_,4, 4
	envelope $88
	note G_,5
	envelope $A8
	note F_,4
	envelope $88
	note D_,4
	envelope $A8
	note A#,4
	envelope $88
	note F_,4
	envelope $A8
	note D_,5
	envelope $88
	note A#,4
	envelope $A8
	note A_,5
	envelope $88
	note D_,5
	envelope $A8
	note G_,5
	envelope $88
	note A_,5
	envelope $A8
	note A#,4
	envelope $88
	note G_,5
	envelope $A8
	note F_,4
	envelope $88
	note A#,4
	envelope $A8
	note E_,5, 8
	silence 4
	envelope $88
	note E_,5
	envelope $A8
	note A_,5
	silence
	note G_,5
	envelope $88
	note A_,5
	envelope $A8
	note D_,5, 8
	silence 4
	envelope $88
	note D_,5
	envelope $A8
	note A_,5
	silence
	note G_,5
	envelope $88
	note A_,5
	snd_loop SndCall_BGM_09_Ch2_6, $00, 2
	snd_ret
SndData_BGM_09_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	wave_cutoff 0
	note D_,4, 64
	note C_,4, 16
	note D_,4
	note D#,4, 8
	note F_,4
	note F#,4
	note G#,4
	note C#,4, 32
	continue 6
	silence 2
	note C#,4, 6
	silence 2
	note C#,4, 6
	silence 2
	note C#,4, 8
	note F_,4, 32
	note D#,4, 16
	note F_,4
	note A#,3, 8
	note F_,4
	note A#,4, 16
	note A#,3, 8
	note F_,4
	note A#,4, 16
	note A#,3, 8
	note F_,4
	note A#,4, 16
	note A#,3, 8
	note F_,4
	note A#,4, 16
	note C#,4, 8
	note G#,3
	note F_,4, 16
	note C#,4, 8
	note G#,3
	note F_,4, 16
	note C#,4, 8
	note G#,3
	note F_,4, 16
	note C#,4, 8
	note G#,3
	note F_,4, 16
	note A#,3, 32
	silence 16
	note A#,3, 6
	silence 2
	note A#,3, 8
	note F_,4, 64
	note C#,4, 32
	silence 16
	note C#,4, 6
	silence 2
	note C#,4, 8
	note G#,4, 64
	note F_,4, 8
	note F_,3
	note F_,4, 14
	silence 2
	note F_,4, 8
	note F_,3
	note F_,4, 14
	silence 2
	note F_,4, 8
	note F_,3
	note F_,4, 14
	silence 2
	note F_,3, 8
	note A#,3
	note D_,4
	note D#,4
	note A#,3, 30
	silence 2
	note G#,3, 30
	silence 2
	note G_,3, 30
	silence 2
	note F_,3, 30
	silence 2
	note C_,4, 16
	note G_,3
	note C_,4
	note G_,3
	note C_,4
	note G_,3
	note C_,4
	note G_,3, 8
	note A_,3
	note A#,3, 16
	note F_,3
	note A#,3
	note F_,3
	note A#,3
	note F_,3
	note A#,3
	note F_,3, 8
	note A#,3
	note A_,3, 16
	note F_,3
	note A_,3
	note F_,3
	note A_,3
	note F_,3
	note A_,3
	note F_,3, 8
	note A_,3
	note F_,3, 14
	silence 2
	note F_,3, 16
	note E_,3
	note F_,3
	note G_,3
	note D_,3
	note G_,3
	note B_,3
	note C_,4, 16
	note E_,3, 8
	note G_,3
	note C_,4, 16
	note E_,3, 8
	note G_,3
	note C_,4, 16
	note E_,3, 8
	note G_,3
	note C_,4, 16
	note E_,3, 8
	note G_,3
	note A#,3, 16
	note E_,3, 8
	note G_,3
	note A#,3, 16
	note E_,3, 8
	note G_,3
	note A#,3, 16
	note E_,3, 8
	note G_,3
	note A#,3, 16
	note E_,3, 8
	note G_,3
	note F_,3, 14
	silence 2
	note F_,3, 6
	silence 2
	note F_,3, 6
	silence 2
	note F_,3, 14
	silence 2
	note F_,3, 6
	silence 2
	note F_,3, 6
	silence 2
	note F_,3, 14
	silence 2
	note F_,3, 6
	silence 2
	note F_,3, 6
	silence 2
	note F_,3, 14
	silence 2
	note F_,3, 6
	silence 2
	note F_,3, 6
	silence 2
	note G_,3, 16
	note D_,3
	note G_,3
	note D_,3
	note G_,3
	note A_,3
	note A#,3
	note B_,3
	note C_,4, 24
	note E_,3
	note C_,3, 16
	note D_,4, 24
	note F_,3
	note D_,4, 16
	note D#,4, 24
	note G_,3
	note D#,4, 16
	note F_,4, 24
	note A_,3
	note F_,4, 16
	snd_call SndCall_BGM_09_Ch3_0
	fine_tune 3
	snd_call SndCall_BGM_09_Ch3_0
	fine_tune -3
	note D_,4, 8
	note A_,3
	note D_,4, 14
	silence 2
	note D_,4, 8
	note A_,3
	note D_,4, 14
	silence 2
	note D_,4, 8
	note A_,3
	note D_,4, 14
	silence 2
	note D_,4, 8
	note A_,3
	note D_,4, 14
	silence 2
	note D#,4, 8
	note A#,3
	note D#,4, 14
	silence 2
	note D#,4, 8
	note A#,3
	note D#,4, 14
	silence 2
	note F_,4, 8
	note G_,3
	note A_,3
	note A#,3
	note C_,4
	note D_,4
	note D#,4
	note F_,4
	note A#,4, 24
	note F_,4
	note A#,4, 16
	note C_,5, 24
	note G_,4
	note C_,5, 16
	note D_,4
	note A_,3
	note D_,4
	note A_,4
	note D_,5
	note B_,4
	note G_,4
	note D_,4
	note A#,4, 24
	note F_,4
	note A#,4, 16
	note C_,4, 32
	note C_,5, 8
	note E_,5
	note G_,5
	note C_,5
	note F#,5, 96
	wave_vol $80
	note F#,5, 8
	silence 4
	note F#,5, 8
	silence 4
	wave_vol $40
	note F#,5, 4
	note F#,5
	snd_loop SndData_BGM_09_Ch3
SndCall_BGM_09_Ch3_0:
	note G_,3, 8
	note A_,3
	note B_,3
	note C#,4
	note D_,4
	note E_,4
	note D_,4
	note C#,4
	note G_,4
	note F#,4
	note E_,4
	note D_,4
	note E_,4
	note F#,4
	note G#,4
	note A_,4
	snd_loop SndCall_BGM_09_Ch3_0, $00, 2
	snd_ret
Padding_00037FC9:
	panning $88
	chan_stop
