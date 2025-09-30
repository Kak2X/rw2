SndHeader_BGM_03:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_03_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_03_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_03_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_03_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_BGM_03_Ch1:
	envelope $A8
	panning $11
	duty_cycle 3
	vibrato_on $01
	envelope $A8
	note F_,4, 16
	envelope $68
	note F_,4, 8
	envelope $A8
	note C_,4, 24
	note F_,4, 16
	note G_,4
	envelope $58
	note G_,4, 8
	envelope $A8
	note C_,4, 24
	note G_,4, 16
	envelope $A8
	note A_,4, 16
	envelope $68
	note A_,4, 8
	envelope $A8
	note F#,4, 24
	note A_,4, 16
	note A#,4
	envelope $68
	note A#,4, 8
	envelope $A8
	note C_,5, 16
	envelope $68
	note C_,5, 8
	envelope $A8
	note D#,5, 16
.loop0:
	fine_tune -12
	snd_call SndCall_BGM_03_Ch1_0
	snd_call SndCall_BGM_03_Ch1_1
	snd_call SndCall_BGM_03_Ch1_0
	duty_cycle 3
	envelope $C8
	note D_,5, 24
	silence 4
	envelope $88
	note D_,5
	envelope $C8
	note C_,6, 24
	silence 4
	envelope $88
	note C_,6
	envelope $C8
	note B_,5, 24
	silence 4
	envelope $88
	note B_,5
	envelope $C8
	note D_,6, 24
	silence 4
	envelope $88
	note D_,6
	envelope $C8
	note E_,6, 24
	silence 4
	envelope $88
	note E_,6
	envelope $C8
	note C_,6, 24
	silence 4
	envelope $88
	note C_,6
	envelope $C8
	note G_,5, 24
	silence 4
	envelope $88
	note G_,5
	envelope $C8
	note E_,5, 16
	silence 4
	envelope $88
	note E_,5
	envelope $C8
	note E_,5, 8
	envelope $C8
	note F_,5, 48
	silence 4
	envelope $88
	note F_,5, 8
	envelope $68
	note F_,5, 4
	envelope $C8
	note A_,5, 48
	silence 4
	envelope $88
	note A_,5, 8
	envelope $68
	note A_,5, 4
	envelope $C8
	note C_,6, 48
	silence 4
	envelope $88
	note C_,6, 8
	envelope $68
	note C_,6, 4
	envelope $C8
	note B_,5, 48
	silence 4
	envelope $88
	note B_,5, 8
	envelope $68
	note B_,5, 4
	fine_tune 12
	duty_cycle 2
	envelope $A8
	note A#,4, 48
	silence 4
	envelope $68
	note A#,4, 8
	envelope $48
	note A#,4
	silence 28
	envelope $A8
	note A#,4, 16
	silence 4
	envelope $68
	note A#,4
	envelope $A8
	note C_,5, 8
	snd_call SndCall_BGM_03_Ch1_2
	envelope $A8
	note D#,5, 48
	silence 4
	envelope $68
	note D#,5, 8
	envelope $48
	note D#,5, 4
	envelope $A8
	note F_,5, 48
	silence 4
	envelope $68
	note F_,5, 8
	envelope $48
	note F_,5
	silence 28
	envelope $A8
	note F_,5, 16
	silence 4
	envelope $68
	note F_,5
	envelope $A8
	note G_,5, 8
	envelope $A8
	note F_,5, 48
	silence 4
	envelope $68
	note F_,5, 8
	envelope $48
	note F_,5, 4
	snd_call SndCall_BGM_03_Ch1_2
	envelope $A8
	note D#,5, 48
	silence 4
	envelope $68
	note D#,5, 8
	envelope $48
	note D#,5
	silence 28
	envelope $A8
	note D#,5, 16
	silence 4
	envelope $68
	note D#,5
	envelope $A8
	note F_,5, 8
	envelope $A8
	note D#,5, 48
	silence 4
	envelope $68
	note D#,5, 8
	envelope $48
	note D#,5, 4
	envelope $A8
	note C_,5, 48
	silence 4
	envelope $68
	note C_,5, 8
	envelope $48
	note C_,5, 4
	envelope $A8
	note D_,5, 96
	continue 16
	silence 4
	envelope $68
	note D_,5, 8
	envelope $48
	note D_,5, 8
	silence 48
	silence 12
	envelope $A8
	note D_,5, 32
	note D#,5
	envelope $A8
	note D_,5, 48
	silence 4
	envelope $68
	note D_,5, 8
	envelope $48
	note D_,5
	silence 24
	silence 4
	envelope $A8
	note A#,4, 16
	silence 4
	envelope $68
	note A#,4, 4
	envelope $A8
	note C_,5, 8
	snd_call SndCall_BGM_03_Ch1_2
	envelope $A8
	note D#,5, 48
	silence 4
	envelope $68
	note D#,5, 8
	envelope $48
	note D#,5, 4
	envelope $A8
	note F_,5, 48
	silence 4
	envelope $68
	note F_,5, 8
	envelope $48
	note F_,5
	silence 24
	silence 4
	envelope $A8
	note F_,5, 16
	silence 4
	envelope $68
	note F_,5, 4
	envelope $A8
	note D#,5, 8
	snd_call SndCall_BGM_03_Ch1_2
	envelope $A8
	note G_,4, 48
	silence 4
	envelope $68
	note G_,4, 8
	envelope $48
	note G_,4, 4
	envelope $A8
	note A#,4, 48
	silence 4
	envelope $68
	note A#,4, 8
	envelope $48
	note A#,4
	silence 24
	silence 4
	envelope $A8
	note A#,4, 16
	silence 4
	envelope $68
	note A#,4, 4
	envelope $A8
	note C_,5, 8
	envelope $A8
	note A#,4, 48
	silence 4
	envelope $68
	note A#,4, 8
	envelope $48
	note A#,4, 4
	envelope $A8
	note G_,4, 48
	silence 4
	envelope $68
	note G_,4, 8
	envelope $48
	note G_,4, 4
	envelope $A8
	note A_,4, 96
	continue 16
	silence 4
	envelope $68
	note A_,4, 8
	envelope $48
	note A_,4, 4
	duty_cycle 3
	envelope $98
	note C_,5, 16
	note F#,5
	note D#,5
	note C_,5
	note A#,4
	note C_,5
	note D#,5
	note C_,5
	snd_loop .loop0
SndCall_BGM_03_Ch1_0:
	duty_cycle 3
	envelope $C8
	note D_,5, 32
	note C_,6
	note B_,5
	silence 4
	envelope $88
	note B_,5
	silence
	envelope $68
	note B_,5
	silence 8
	envelope $C8
	note G_,5
	note A_,5, 16
	silence 4
	envelope $88
	note A_,5
	envelope $C8
	note F_,5, 8
	note C_,5, 64
	silence 4
	envelope $88
	note C_,5
	silence
	envelope $68
	note C_,5
	silence
	envelope $48
	note C_,5
	silence 8
	envelope $C8
	note D_,5, 32
	note C_,6
	note B_,5, 48
	silence 4
	envelope $88
	note B_,5
	envelope $C8
	note G_,5, 8
	note A_,5, 48
	envelope $98
	note A_,5, 4
	envelope $88
	note A_,5, 8
	envelope $68
	note A_,5
	envelope $48
	note A_,5, 4
	duty_cycle 2
	envelope $98
	note F_,4, 8
	note D_,4
	note F_,4
	note D_,5
	note A_,4
	note D_,5
	note F_,5
	snd_ret
SndCall_BGM_03_Ch1_1:
	duty_cycle 3
	envelope $C8
	note D_,5, 32
	note C_,6
	note B_,5
	silence 4
	envelope $88
	note B_,5
	silence
	envelope $68
	note B_,5
	silence 8
	envelope $C8
	note G_,5
	note A_,5, 16
	silence 4
	envelope $88
	note A_,5
	envelope $C8
	note F_,5, 8
	note C_,5, 48
	silence 4
	envelope $88
	note C_,5, 8
	envelope $68
	note C_,5, 4
	envelope $C8
	note C_,5, 16
	silence 8
	note C_,5
	envelope $C8
	note G_,5, 16
	silence 4
	envelope $88
	note G_,5
	envelope $C8
	note E_,5, 8
	note B_,4, 48
	silence 4
	envelope $88
	note B_,4
	silence
	envelope $68
	note B_,4
	envelope $C8
	note B_,4, 16
	silence 4
	envelope $88
	note B_,4
	envelope $C8
	note B_,4, 8
	note C_,5, 48
	envelope $88
	note C_,5, 8
	envelope $68
	note C_,5
	envelope $C8
	note F_,5, 32
	note C_,6
	snd_ret
SndCall_BGM_03_Ch1_2:
	envelope $A8
	note D_,5, 48
	silence 4
	envelope $68
	note D_,5, 8
	envelope $48
	note D_,5, 4
	snd_ret
SndData_BGM_03_Ch2:
	envelope $A8
	panning $22
	duty_cycle 1
	snd_call SndCall_BGM_03_Ch2_0
	snd_call SndCall_BGM_03_Ch2_1
.loop4:
	snd_call SndCall_BGM_03_Ch2_2
	snd_call SndCall_BGM_03_Ch2_3
	snd_call SndCall_BGM_03_Ch2_2
	snd_call SndCall_BGM_03_Ch2_5
	snd_call SndCall_BGM_03_Ch2_2
	snd_call SndCall_BGM_03_Ch2_3
	snd_call SndCall_BGM_03_Ch2_4
	silence 4
	envelope $48
	note G_,4, 8
	silence 4
	envelope $88
	note F_,4, 4
	silence
	note F_,4
	envelope $48
	note F_,4
	envelope $88
	note A_,3
	envelope $48
	note F_,4
	envelope $88
	note F_,4
	envelope $48
	note A_,3, 4
	silence
	note F_,4
	envelope $88
	note A_,3, 4
	silence 8
	envelope $48
	note A_,3, 4
	silence 8
	envelope $88
	note C_,4, 4
	silence
	note C_,4, 8
	note A_,4
	note F_,4
	note A_,4
	note C_,5
	snd_call SndCall_BGM_03_Ch2_2
	snd_call SndCall_BGM_03_Ch2_3
	snd_call SndCall_BGM_03_Ch2_2
	snd_call SndCall_BGM_03_Ch2_5
	silence 4
	envelope $48
	note A_,4, 8
	silence 4
	envelope $88
	note B_,4, 4
	silence
	note B_,4
	envelope $48
	note B_,4
	envelope $88
	note D_,4
	envelope $48
	note B_,4
	envelope $88
	note G_,4
	envelope $48
	note D_,4, 4
	silence
	note G_,4
	envelope $88
	note D_,4, 4
	silence 8
	envelope $48
	note D_,4, 4
	silence 8
	envelope $88
	note C_,4, 4
	silence
	note C_,4
	envelope $48
	note C_,4
	envelope $88
	note A_,4
	envelope $48
	note C_,4
	envelope $88
	note F_,4
	envelope $48
	note A_,4
	silence
	note F_,4
	envelope $88
	note A_,4
	silence
	silence 4
	envelope $48
	note A_,4, 8
	silence 4
	envelope $88
	note G_,4, 4
	silence
	note G_,4
	envelope $48
	note G_,4
	envelope $88
	note E_,4
	envelope $48
	note G_,4
	envelope $88
	note G_,4
	envelope $48
	note E_,4, 4
	silence
	note G_,4
	envelope $88
	note B_,3, 4
	silence 8
	envelope $48
	note B_,3, 4
	silence 8
	envelope $88
	note G_,3, 4
	silence
	note E_,4
	envelope $48
	note G_,3
	envelope $88
	note G_,4
	envelope $48
	note E_,4
	envelope $88
	note E_,4
	envelope $48
	note G_,4
	silence
	note E_,4
	envelope $88
	note G_,4
	silence
	silence 4
	envelope $48
	note G_,4, 8
	silence 4
	envelope $88
	note C_,5, 4
	silence
	note C_,5
	envelope $48
	note C_,5
	envelope $88
	note F_,4
	envelope $48
	note C_,5
	envelope $88
	note A_,4
	envelope $48
	note F_,4, 4
	silence
	note A_,4
	envelope $88
	note F_,4, 4
	silence 8
	envelope $48
	note F_,4, 4
	silence 8
	envelope $88
	note F_,4, 4
	silence
	note F_,4
	envelope $48
	note F_,4
	envelope $88
	note A_,4
	envelope $48
	note F_,4
	envelope $88
	note F_,4
	envelope $48
	note A_,4
	silence
	note F_,4
	envelope $88
	note C_,5
	silence
	silence 4
	envelope $48
	note C_,5
	envelope $88
	note A_,4
	silence
	note F_,4
	envelope $48
	note A_,4
	envelope $88
	note D_,4
	envelope $48
	note F_,4
	envelope $88
	note C_,4
	envelope $48
	note D_,4
	envelope $88
	note A_,3
	envelope $48
	note C_,4
	envelope $88
	note F_,3
	envelope $48
	note A_,3
	envelope $88
	note D_,3
	envelope $48
	note F_,3
	envelope $88
	note F_,3
	envelope $48
	note D_,3
	envelope $88
	note D_,3
	envelope $48
	note F_,3
	envelope $88
	note F_,3
	envelope $48
	note D_,3
	envelope $88
	note A_,3
	envelope $48
	note F_,3
	envelope $88
	note C_,4
	envelope $48
	note A_,3
	envelope $88
	note D_,4
	envelope $48
	note C_,4
	envelope $88
	note F_,4
	envelope $48
	note D_,4
	envelope $88
	note A_,4
	envelope $48
	note F_,4
	snd_call SndCall_BGM_03_Ch2_6
	snd_call SndCall_BGM_03_Ch2_7
	snd_call SndCall_BGM_03_Ch2_8
	snd_call SndCall_BGM_03_Ch2_8
	snd_call SndCall_BGM_03_Ch2_7
	snd_call SndCall_BGM_03_Ch2_7
	snd_call SndCall_BGM_03_Ch2_6
	snd_call SndCall_BGM_03_Ch2_9
	snd_call SndCall_BGM_03_Ch2_6
	snd_call SndCall_BGM_03_Ch2_7
	snd_call SndCall_BGM_03_Ch2_8
.loop0:
	envelope $A8
	note F_,3, 4
	envelope $68
	note F_,4
	envelope $A8
	note D#,4
	envelope $48
	note F_,3
	envelope $A8
	note C_,4
	envelope $68
	note D#,4
	envelope $A8
	note F_,3
	envelope $68
	note C_,4
	envelope $A8
	note C_,4
	envelope $48
	note F_,3
	envelope $A8
	note A_,3
	envelope $68
	note C_,4
	envelope $A8
	note F_,3
	envelope $68
	note A_,3
	envelope $A8
	note D#,4
	envelope $48
	note F_,3
	snd_loop .loop0, $00, 2
.loop1:
	envelope $A8
	note G_,3, 4
	envelope $68
	note D#,4
	envelope $A8
	note G_,4
	envelope $48
	note G_,3
	envelope $A8
	note D_,4
	envelope $68
	note G_,4
	envelope $A8
	note G_,3
	envelope $68
	note D_,4
	envelope $A8
	note D_,4
	envelope $48
	note G_,3
	envelope $A8
	note A#,3
	envelope $68
	note D_,4
	envelope $A8
	note G_,3
	envelope $68
	note A#,3
	envelope $A8
	note G_,4
	envelope $48
	note G_,3
	snd_loop .loop1, $00, 2
.loop2:
	envelope $A8
	note G_,3, 4
	envelope $68
	note G_,4
	envelope $A8
	note G_,4
	envelope $48
	note G_,3
	envelope $A8
	note E_,4
	envelope $68
	note G_,4
	envelope $A8
	note G_,3
	envelope $68
	note E_,4
	envelope $A8
	note E_,4
	envelope $48
	note G_,3
	envelope $A8
	note A#,3
	envelope $68
	note E_,4
	envelope $A8
	note G_,3
	envelope $68
	note A#,3
	envelope $A8
	note G_,4
	envelope $48
	note G_,3
	snd_loop .loop2, $00, 2
.loop3:
	envelope $A8
	note F#,3, 4
	envelope $68
	note G_,4
	envelope $A8
	note F#,4
	envelope $48
	note F#,3
	envelope $A8
	note C_,4
	envelope $68
	note F#,4
	envelope $A8
	note F#,3
	envelope $68
	note C_,4
	envelope $A8
	note C_,4
	envelope $48
	note F#,3
	envelope $A8
	note A_,3
	envelope $68
	note C_,4
	envelope $A8
	note F#,3
	envelope $68
	note A_,3
	envelope $A8
	note F#,4
	envelope $48
	note F#,3
	snd_loop .loop3, $00, 2
	snd_call SndCall_BGM_03_Ch2_9
	snd_loop .loop4
SndCall_BGM_03_Ch2_0:
	envelope $88
	note A_,5, 4
	envelope $48
	note D_,5
	envelope $88
	note C_,5
	envelope $48
	note A_,5
	envelope $88
	note G_,5
	envelope $48
	note C_,5
	envelope $88
	note D_,5
	envelope $48
	note G_,5
	snd_loop SndCall_BGM_03_Ch2_0, $00, 4
	snd_ret
SndCall_BGM_03_Ch2_1:
	envelope $88
	note A_,5, 4
	envelope $48
	note D_,5
	envelope $88
	note C_,5
	envelope $48
	note A_,5
	envelope $88
	note F#,5
	envelope $48
	note C_,5
	envelope $88
	note D_,5
	envelope $48
	note F#,5
	snd_loop SndCall_BGM_03_Ch2_1, $00, 2
	envelope $88
	note F#,4, 16
	envelope $48
	note F#,4, 8
	envelope $88
	note G#,4, 16
	envelope $48
	note G#,4, 8
	envelope $88
	note C_,5, 16
	snd_ret
SndCall_BGM_03_Ch2_2:
	silence 4
	envelope $48
	note A_,4, 8
	silence 4
	envelope $88
	note B_,4, 4
	silence
	note B_,4
	envelope $48
	note B_,4
	envelope $88
	note D_,4
	envelope $48
	note B_,4
	envelope $88
	note G_,4
	envelope $48
	note D_,4, 4
	silence
	note G_,4
	envelope $88
	note D_,4, 4
	silence 8
	envelope $48
	note D_,4, 4
	silence 8
	envelope $88
	note D_,4, 4
	silence
	note D_,4
	envelope $48
	note D_,4
	envelope $88
	note B_,4
	envelope $48
	note D_,4
	envelope $88
	note G_,4
	envelope $48
	note B_,4
	silence
	note G_,4
	envelope $88
	note B_,4
	silence
	snd_ret
SndCall_BGM_03_Ch2_3:
	silence 4
	envelope $48
	note B_,4, 8
	silence 4
	envelope $88
	note A_,4, 4
	silence
	note A_,4
	envelope $48
	note A_,4
	envelope $88
	note C_,4
	envelope $48
	note A_,4
	envelope $88
	note F_,4
	envelope $48
	note C_,4, 4
	silence
	note F_,4
	envelope $88
	note C_,4, 4
	silence 8
	envelope $48
	note C_,4, 4
	silence 8
	envelope $88
	note C_,4, 4
	silence
	note C_,4
	envelope $48
	note C_,4
	envelope $88
	note A_,4
	envelope $48
	note C_,4
	envelope $88
	note F_,4
	envelope $48
	note A_,4
	silence
	note F_,4
	envelope $88
	note A_,4
	silence
	snd_ret
SndCall_BGM_03_Ch2_4:
	silence 4
	envelope $48
	note A_,4, 8
	silence 4
	envelope $88
	note G_,4, 4
	silence
	note G_,4
	envelope $48
	note G_,4
	envelope $88
	note B_,3
	envelope $48
	note G_,4
	envelope $88
	note E_,4
	envelope $48
	note B_,3, 4
	silence
	note E_,4
	envelope $88
	note B_,3, 4
	silence 8
	envelope $48
	note B_,3, 4
	silence 8
	envelope $88
	note B_,3, 4
	silence
	note B_,3
	envelope $48
	note B_,3
	envelope $88
	note G_,4
	envelope $48
	note B_,3
	envelope $88
	note E_,4
	envelope $48
	note G_,4
	silence
	note E_,4
	envelope $88
	note G_,4
	silence
	snd_ret
SndCall_BGM_03_Ch2_5:
	silence 4
	envelope $48
	note B_,4, 8
	silence 4
	envelope $88
	note F_,4, 4
	silence
	note F_,4
	envelope $48
	note F_,4
	envelope $88
	note A_,3
	envelope $48
	note F_,4
	envelope $88
	note D_,4
	envelope $48
	note A_,3, 4
	silence
	note D_,4
	envelope $88
	note A_,3, 4
	silence 8
	envelope $48
	note A_,3, 4
	envelope $88
	note A_,3, 8
	note F_,3
	note A_,3
	note F_,4
	note D_,4
	note F_,4
	note A_,4
	snd_ret
SndCall_BGM_03_Ch2_6:
	envelope $A8
	note F_,3, 4
	envelope $68
	note F_,4
	envelope $A8
	note F_,4
	envelope $48
	note F_,3
	envelope $A8
	note D_,4
	envelope $68
	note F_,4
	envelope $A8
	note F_,3
	envelope $68
	note D_,4
	envelope $A8
	note D_,4
	envelope $48
	note F_,3
	envelope $A8
	note A#,3
	envelope $68
	note D_,4
	envelope $A8
	note F_,3
	envelope $68
	note A#,3
	envelope $A8
	note F_,4
	envelope $48
	note F_,3
	snd_loop SndCall_BGM_03_Ch2_6, $00, 2
	snd_ret
SndCall_BGM_03_Ch2_7:
	envelope $A8
	note F_,3, 4
	envelope $68
	note F_,4
	envelope $A8
	note F_,4
	envelope $48
	note F_,3
	envelope $A8
	note D#,4
	envelope $68
	note F_,4
	envelope $A8
	note F_,3
	envelope $68
	note D#,4
	envelope $A8
	note D#,4
	envelope $48
	note F_,3
	envelope $A8
	note C_,4
	envelope $68
	note D#,4
	envelope $A8
	note F_,3
	envelope $68
	note C_,4
	envelope $A8
	note F_,4
	envelope $48
	note F_,3
	snd_loop SndCall_BGM_03_Ch2_7, $00, 2
	snd_ret
SndCall_BGM_03_Ch2_8:
	envelope $A8
	note F_,3, 4
	envelope $68
	note F_,4
	envelope $A8
	note F_,4
	envelope $48
	note F_,3
	envelope $A8
	note D_,4
	envelope $68
	note F_,4
	envelope $A8
	note F_,3
	envelope $68
	note D_,4
	envelope $A8
	note D_,4
	envelope $48
	note F_,3
	envelope $A8
	note B_,3
	envelope $68
	note D_,4
	envelope $A8
	note F_,3
	envelope $68
	note B_,3
	envelope $A8
	note F_,4
	envelope $48
	note F_,3
	snd_loop SndCall_BGM_03_Ch2_8, $00, 2
	snd_ret
SndCall_BGM_03_Ch2_9:
	envelope $A8
	note F#,3, 4
	envelope $68
	note F_,4
	envelope $A8
	note F#,4
	envelope $48
	note F#,3
	envelope $A8
	note D#,4
	envelope $68
	note F#,4
	envelope $A8
	note F#,3
	envelope $68
	note D#,4
	envelope $A8
	note D#,4
	envelope $48
	note F#,3
	envelope $A8
	note C_,4
	envelope $68
	note D#,4
	envelope $A8
	note F#,3
	envelope $68
	note C_,4
	envelope $A8
	note F#,4
	envelope $48
	note F#,3
	snd_loop SndCall_BGM_03_Ch2_9, $00, 2
	snd_ret
SndData_BGM_03_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	wave_cutoff 0
	note D_,4, 16
	silence 8
	note D_,4, 6
	silence 2
	snd_loop SndData_BGM_03_Ch3, $00, 6
	note G#,3, 16
	silence 8
	note G#,3, 6
	silence 2
	note G#,3, 16
	silence 8
	note G#,3, 6
	silence 2
.loop0:
	snd_call SndCall_BGM_03_Ch3_0
	note G_,3, 16
	silence 8
	note G_,3, 8
	note D_,4, 16
	silence 8
	note G_,3
	silence 16
	note G_,3, 6
	silence 2
	note G_,3, 6
	silence 2
	note D_,3, 8
	note G_,3, 24
	note F_,3, 16
	silence 8
	note F_,3, 8
	note C_,4, 16
	silence 8
	note F_,3
	silence 16
	note F_,3, 6
	silence 2
	note F_,3, 6
	silence 2
	note C_,3, 8
	note F_,3, 24
	note E_,3, 16
	silence 8
	note E_,3, 8
	note B_,3, 16
	silence 8
	note E_,3
	silence 16
	note E_,3, 6
	silence 2
	note E_,3, 6
	silence 2
	note G_,3, 16
	note B_,3
	note F_,3, 16
	silence 8
	note F_,3, 8
	note C_,4, 16
	silence 8
	note F_,3
	silence 16
	note F_,3, 6
	silence 2
	note F_,3, 6
	silence 2
	note A_,3, 16
	note C_,4
	snd_call SndCall_BGM_03_Ch3_0
	note G_,3, 16
	silence 8
	note G_,3
	silence
	note D_,4
	silence
	note G_,3
	note F_,3, 16
	silence 8
	note F_,3
	note C_,4, 16
	note F_,3
	note E_,3, 16
	silence 8
	note E_,3
	silence
	note B_,3
	silence
	note E_,3
	note A#,3, 16
	silence 8
	note A#,3
	note E_,4, 16
	note A#,3
	note F_,3, 16
	silence 8
	note F_,3
	silence
	note C_,4
	silence
	note A_,3
	note F_,4, 16
	note A_,3
	note F_,3
	note C_,4
	note G_,3, 16
	silence 8
	note G_,3
	note D_,3
	note G_,3, 16
	note D_,3, 8
	note A_,3, 16
	note B_,3
	note C_,4
	note D_,4
	snd_call SndCall_BGM_03_Ch3_1
	fine_tune -2
	snd_call SndCall_BGM_03_Ch3_1
	fine_tune -1
	snd_call SndCall_BGM_03_Ch3_1
	snd_call SndCall_BGM_03_Ch3_1
	fine_tune 2
	snd_call SndCall_BGM_03_Ch3_1
	fine_tune 1
	note G#,3, 14
	silence 2
	note G#,3, 16
	silence
	note G#,3, 14
	silence 2
	note G#,3, 14
	silence 2
	note G#,3, 16
	silence 8
	note C_,4
	note D_,4
	note D#,4
	note A#,3, 14
	silence 2
	note A#,3, 16
	silence
	note A#,3, 14
	silence 2
	note A#,3, 14
	silence 2
	note A#,3, 16
	silence 8
	note F_,4
	note D_,4
	note A#,3
	note A_,3, 14
	silence 2
	note A_,3, 16
	silence
	note A_,3, 14
	silence 2
	note A_,3, 32
	note C_,4
	snd_call SndCall_BGM_03_Ch3_1
	fine_tune -2
	snd_call SndCall_BGM_03_Ch3_1
	fine_tune -1
	snd_call SndCall_BGM_03_Ch3_1
	fine_tune -2
	snd_call SndCall_BGM_03_Ch3_1
	fine_tune 5
	note D#,3, 14
	silence 2
	note D#,3, 16
	silence
	note D#,4, 14
	silence 2
	note D#,3, 14
	silence 2
	note D#,3, 16
	silence
	note D#,3, 8
	note A#,3
	note C_,4, 14
	silence 2
	note C_,4, 16
	silence
	note C_,4, 14
	silence 2
	note C_,4, 14
	silence 2
	note C_,4, 16
	silence 8
	note E_,4
	note F#,4
	note E_,4
	note D_,4, 14
	silence 2
	note D_,4, 16
	silence
	note D_,4, 14
	silence 2
	note D_,4, 14
	silence 2
	note D_,4, 16
	silence 8
	note C_,4
	note D_,4
	note A_,3
	note G#,3, 16
	note D#,4
	note C_,4
	note G#,3
	note F#,3
	note G#,3
	note C_,4
	note G#,3
	snd_loop .loop0
SndCall_BGM_03_Ch3_0:
	note G_,3, 16
	silence 8
	note G_,3, 8
	note D_,4, 16
	silence 8
	note G_,3
	silence 16
	note G_,3, 6
	silence 2
	note G_,3, 6
	silence 2
	note D_,3, 8
	note G_,3, 24
	note D_,4, 16
	silence 8
	note D_,4, 8
	note A_,4, 16
	silence 8
	note D_,4
	silence 16
	note D_,4, 6
	silence 2
	note D_,4, 6
	silence 2
	note A_,3, 8
	note D_,3, 24
	note G_,3, 16
	silence 8
	note G_,3, 8
	note D_,4, 16
	silence 8
	note G_,3
	silence 16
	note G_,3, 6
	silence 2
	note G_,3, 6
	silence 2
	note D_,3, 8
	note G_,3, 16
	note D_,3, 8
	note G_,3, 16
	silence 8
	note G_,3, 8
	note D_,4, 16
	silence 8
	note G_,3
	silence 16
	note G_,3, 6
	silence 2
	note G_,3, 6
	silence 2
	note D_,3, 8
	note F_,3, 24
	snd_ret
SndCall_BGM_03_Ch3_1:
	note A#,3, 14
	silence 2
	note A#,3, 16
	silence
	note A#,3, 14
	silence 2
	note A#,3, 14
	silence 2
	note A#,3, 16
	silence
	note A#,3, 8
	note F_,3
	snd_ret
SndData_BGM_03_Ch4:
	panning $88
	envelope $C1
	note4 G#,4,0, 8
	envelope $51
	note4 C_,6,0, 8
	envelope $53
	note4x $13, 8 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 8
	envelope $A1
	note4 A_,5,0, 8
	envelope $51
	note4 C_,6,0, 8
	envelope $53
	note4x $13, 8 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 8
	snd_loop SndData_BGM_03_Ch4, $00, 3
	envelope $C1
	note4 G#,4,0, 8
	envelope $51
	note4 C_,6,0, 8
	envelope $53
	note4x $13, 8 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 8
	envelope $A1
	note4 A_,5,0, 8
	note4 A_,5,0, 8
	note4 A_,5,0, 8
	note4 A_,5,0, 8
.loop0:
	snd_call SndCall_BGM_03_Ch4_0
	snd_call SndCall_BGM_03_Ch4_1
	snd_call SndCall_BGM_03_Ch4_0
	envelope $C1
	note4 G#,4,0, 8
	note4 G#,4,0, 8
	envelope $51
	note4 C_,6,0, 16
	envelope $A1
	note4 A_,5,0, 16
	envelope $C1
	note4 G#,4,0, 8
	note4 G#,4,0, 8
	envelope $51
	note4 C_,6,0, 8
	envelope $53
	note4x $13, 8 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 8
	envelope $51
	note4 C_,6,0, 8
	envelope $A1
	note4 A_,5,0, 8
	note4 A_,5,0, 8
	envelope $91
	note4 G_,5,0, 8
	envelope $91
	note4 E_,5,0, 8
	snd_call SndCall_BGM_03_Ch4_0
	snd_call SndCall_BGM_03_Ch4_1
	snd_call SndCall_BGM_03_Ch4_2
	snd_call SndCall_BGM_03_Ch4_3
	envelope $C1
	note4 G#,4,0, 16
	envelope $51
	note4 C_,6,0, 16
	envelope $A1
	note4 A_,5,0, 16
	envelope $51
	note4 C_,6,0, 8
	note4 C_,6,0, 8
	envelope $C1
	note4 G#,4,0, 8
	envelope $A1
	note4 A_,5,0, 8
	envelope $51
	note4 C_,6,0, 16
	envelope $A1
	note4 A_,5,0, 16
	envelope $53
	note4x $13, 16 ; Nearest: G#,6,0
	snd_call SndCall_BGM_03_Ch4_3
	envelope $C1
	note4 G#,4,0, 16
	envelope $51
	note4 C_,6,0, 16
	envelope $A1
	note4 A_,5,0, 16
	envelope $51
	note4 C_,6,0, 8
	note4 C_,6,0, 8
	envelope $C1
	note4 G#,4,0, 8
	envelope $A1
	note4 A_,5,0, 8
	envelope $51
	note4 C_,6,0, 8
	note4 C_,6,0, 8
	envelope $A1
	note4 A_,5,0, 8
	note4 A_,5,0, 8
	envelope $53
	note4x $13, 16 ; Nearest: G#,6,0
	snd_call SndCall_BGM_03_Ch4_3
	envelope $C1
	note4 G#,4,0, 16
	envelope $51
	note4 C_,6,0, 16
	envelope $A1
	note4 A_,5,0, 16
	envelope $51
	note4 C_,6,0, 8
	note4 C_,6,0, 8
	envelope $C1
	note4 G#,4,0, 8
	envelope $A1
	note4 A_,5,0, 8
	envelope $51
	note4 C_,6,0, 16
	envelope $A1
	note4 A_,5,0, 16
	envelope $53
	note4x $13, 16 ; Nearest: G#,6,0
	snd_call SndCall_BGM_03_Ch4_3
	envelope $C1
	note4 G#,4,0, 16
	envelope $51
	note4 C_,6,0, 16
	envelope $A1
	note4 A_,5,0, 8
	note4 A_,5,0, 8
	envelope $51
	note4 C_,6,0, 8
	envelope $C1
	note4 G#,4,0, 8
	note4 G#,4,0, 8
	envelope $A1
	note4 A_,5,0, 8
	envelope $51
	note4 C_,6,0, 8
	envelope $C1
	note4 G#,4,0, 8
	envelope $A1
	note4 A_,5,0, 8
	note4 A_,5,0, 8
	note4 A_,5,0, 8
	envelope $C1
	note4 G#,4,0, 8
	snd_loop .loop0
SndCall_BGM_03_Ch4_0:
	envelope $C1
	note4 G#,4,0, 8
	note4 G#,4,0, 8
	envelope $51
	note4 C_,6,0, 16
	envelope $A1
	note4 A_,5,0, 16
	envelope $C1
	note4 G#,4,0, 8
	note4 G#,4,0, 8
	envelope $51
	note4 C_,6,0, 8
	envelope $53
	note4x $13, 8 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 8
	envelope $51
	note4 C_,6,0, 8
	envelope $A1
	note4 A_,5,0, 8
	envelope $C1
	note4 G#,4,0, 8
	envelope $51
	note4 C_,6,0, 8
	envelope $53
	note4x $13, 8 ; Nearest: G#,6,0
	snd_loop SndCall_BGM_03_Ch4_0, $00, 3
	snd_ret
SndCall_BGM_03_Ch4_1:
	envelope $C1
	note4 G#,4,0, 8
	note4 G#,4,0, 8
	envelope $51
	note4 C_,6,0, 16
	envelope $A1
	note4 A_,5,0, 16
	envelope $C1
	note4 G#,4,0, 8
	note4 G#,4,0, 8
	envelope $51
	note4 C_,6,0, 8
	envelope $53
	note4x $13, 8 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 8
	envelope $51
	note4 C_,6,0, 8
	envelope $A1
	note4 A_,5,0, 8
	envelope $C1
	note4 G#,4,0, 8
	envelope $51
	note4 C_,6,0, 8
	envelope $A1
	note4 A_,5,0, 8
	snd_ret
SndCall_BGM_03_Ch4_2:
	envelope $C1
	note4 G#,4,0, 8
	note4 G#,4,0, 8
	envelope $51
	note4 C_,6,0, 8
	envelope $C1
	note4 G#,4,0, 8
	envelope $53
	note4x $13, 8 ; Nearest: G#,6,0
	envelope $A1
	note4 A_,5,0, 8
	envelope $51
	note4 C_,6,0, 8
	envelope $C1
	note4 G#,4,0, 8
	note4 G#,4,0, 8
	envelope $51
	note4 C_,6,0, 8
	envelope $53
	note4x $13, 8 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 8
	envelope $A1
	note4 A_,5,0, 8
	envelope $51
	note4 C_,6,0, 8
	envelope $C1
	note4 G#,4,0, 8
	envelope $53
	note4x $13, 8 ; Nearest: G#,6,0
	snd_loop SndCall_BGM_03_Ch4_2, $00, 3
	envelope $C1
	note4 G#,4,0, 8
	note4 G#,4,0, 8
	envelope $51
	note4 C_,6,0, 16
	envelope $A1
	note4 A_,5,0, 8
	envelope $C1
	note4 G#,4,0, 8
	envelope $51
	note4 C_,6,0, 8
	envelope $C1
	note4 G#,4,0, 8
	envelope $A1
	note4 A_,5,0, 8
	note4 A_,5,0, 8
	envelope $C1
	note4 G#,4,0, 8
	note4 G#,4,0, 8
	envelope $A1
	note4 A_,5,0, 8
	envelope $C1
	note4 G#,4,0, 8
	envelope $A1
	note4 A_,5,0, 8
	note4 A_,5,0, 8
	snd_ret
SndCall_BGM_03_Ch4_3:
	envelope $C1
	note4 G#,4,0, 16
	envelope $51
	note4 C_,6,0, 16
	envelope $A1
	note4 A_,5,0, 16
	envelope $51
	note4 C_,6,0, 8
	note4 C_,6,0, 8
	envelope $C1
	note4 G#,4,0, 16
	envelope $51
	note4 C_,6,0, 16
	envelope $A1
	note4 A_,5,0, 16
	envelope $53
	note4x $13, 16 ; Nearest: G#,6,0
	snd_loop SndCall_BGM_03_Ch4_3, $00, 3
	snd_ret
