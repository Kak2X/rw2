SndHeader_BGM_08:
	db $03 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_08_Ch1 ; Data ptr
	db 4 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_08_Ch2 ; Data ptr
	db -8 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_08_Ch3 ; Data ptr
	db 4 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_Unused_0003A1D4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_BGM_08_Ch1:
	envelope $A8
	panning $11
	duty_cycle 2
	vibrato_on $01
	note A#,3, 48
	note D_,4
	note A_,4, 32
	note G_,4, 48
	note E_,4
	envelope $88
	note E_,4, 8
	silence 4
	envelope $68
	note E_,4
	envelope $A8
	note C_,4, 16
	note E_,4, 48
	note C_,4
	note G_,3, 16
	note A_,3, 64
	continue 16
	envelope $88
	note A_,3, 8
	silence 4
	envelope $68
	note A_,3, 8
	silence 4
	envelope $48
	note A_,3, 8
	silence 4
	envelope $38
	note A_,3, 8
	silence 20
	envelope $A8
	note A#,3, 48
	note D_,4
	note A_,4, 32
	note G_,4, 48
	note E_,4
	envelope $88
	note E_,4, 8
	silence 4
	envelope $68
	note E_,4
	envelope $A8
	note G_,4, 16
	note F_,4, 48
	note A_,4
	envelope $88
	note A_,4, 8
	silence 4
	envelope $68
	note A_,4, 8
	silence 4
	envelope $48
	note A_,4, 8
	envelope $A8
	silence 16
	note D_,5
	note C_,5
	note G_,4
	note A_,4
	note F_,4
	note G_,4
	note C_,4
	note A#,3, 48
	note D_,4
	note A_,4, 32
	note G_,4, 48
	note E_,4
	envelope $88
	note E_,4, 8
	silence 4
	envelope $68
	note E_,4
	envelope $A8
	note G_,4, 16
	note F_,4, 48
	note A_,4
	note C_,5, 16
	note A_,4, 48
	envelope $88
	note A_,4, 8
	silence 4
	envelope $68
	note A_,4, 4
	envelope $A8
	note D_,5, 16
	note C_,5
	note G_,4
	note A_,4
	note F_,4
	note D_,4, 48
	note A#,3
	note A_,4, 32
	note G_,4, 48
	note E_,4
	envelope $88
	note E_,4, 8
	silence 4
	envelope $68
	note E_,4, 4
	envelope $A8
	note G_,4, 16
	note F_,4, 32
	envelope $88
	note F_,4, 8
	silence 4
	envelope $68
	note F_,4, 4
	envelope $A8
	note A_,4, 64
	continue 16
	envelope $88
	note A_,4, 8
	silence 4
	envelope $68
	note A_,4, 8
	silence 4
	envelope $48
	note A_,4, 8
	silence 4
	envelope $38
	note A_,4, 8
	silence 48
	envelope $A8
	note G#,4, 4
	note A_,4
	note A#,4
	note B_,4
	note C_,5
	note C#,5
	note D_,5
	note D#,5
	note E_,5
	snd_call SndCall_BGM_08_Ch1_0
	silence 20
	envelope $A8
	note A#,4, 96
	note G_,4, 32
	note C_,5, 48
	note A#,4
	note C_,5, 16
	note E_,5
	note A_,4, 96
	envelope $88
	note A_,4, 8
	silence 4
	envelope $68
	note A_,4, 8
	silence 4
	envelope $48
	note A_,4, 8
	silence 4
	envelope $38
	note A_,4, 8
	silence 4
	duty_cycle 3
	envelope $A2
	note F_,4, 4
	silence
	note E_,4
	envelope $72
	note F_,4
	envelope $A2
	note F_,4
	envelope $72
	note E_,4
	envelope $A2
	note D_,4
	envelope $72
	note F_,4
	envelope $A2
	note E_,4
	envelope $72
	note D_,4
	envelope $A2
	note F_,4
	envelope $72
	note E_,4
	envelope $A2
	note G_,4
	envelope $72
	note F_,4
	envelope $A2
	note F_,4
	envelope $72
	note G_,4
	envelope $A2
	note G_,4
	envelope $72
	note F_,4
	envelope $A2
	note A_,4
	envelope $72
	note G_,4
	envelope $A2
	note A#,4
	envelope $72
	note A_,4
	envelope $A2
	note C_,5
	envelope $72
	note A#,4
	envelope $A2
	note D_,5
	envelope $72
	note C_,5
	envelope $A2
	note E_,5
	envelope $72
	note D_,5
	duty_cycle 2
	snd_call SndCall_BGM_08_Ch1_0
	silence 8
	envelope $A8
	note D_,4, 4
	note D#,4
	note E_,4
	envelope $A8
	note F_,4, 64
	envelope $88
	note F_,4, 8
	silence 4
	envelope $68
	note F_,4, 4
	envelope $A8
	note E_,4, 32
	note F_,4, 16
	note G_,4, 48
	note F_,4
	envelope $88
	note F_,4, 8
	silence 4
	envelope $68
	note F_,4, 4
	envelope $A8
	note F_,4, 8
	note E_,4
	envelope $A8
	note F_,4, 64
	envelope $88
	note F_,4, 8
	silence 4
	envelope $68
	note F_,4, 4
	envelope $A8
	note E_,4, 32
	note D_,4, 16
	note E_,4, 64
	envelope $88
	note E_,4, 8
	silence 4
	envelope $68
	note E_,4, 8
	silence 4
	envelope $48
	note E_,4, 8
	silence 4
	envelope $38
	note E_,4, 8
	silence 20
	snd_loop SndData_BGM_08_Ch1
SndCall_BGM_08_Ch1_0:
	envelope $A8
	note F_,5, 64
	envelope $88
	note F_,5, 8
	silence 4
	envelope $68
	note F_,5, 4
	envelope $A8
	note E_,5, 32
	note C_,5, 16
	envelope $A8
	note D_,5, 32
	envelope $88
	note D_,5, 8
	silence 4
	envelope $68
	note D_,5, 4
	envelope $A8
	note C_,5, 48
	envelope $88
	note C_,5, 8
	silence 4
	envelope $68
	note C_,5, 4
	envelope $A8
	note C_,5, 8
	note E_,5
	note A_,4, 32
	envelope $88
	note A_,4, 8
	silence 4
	envelope $68
	note A_,4, 4
	envelope $A8
	note C_,5, 64
	note E_,4, 16
	note D_,4, 64
	envelope $88
	note D_,4, 8
	silence 4
	envelope $68
	note D_,4, 8
	silence 4
	envelope $48
	note D_,4, 8
	silence 4
	envelope $38
	note D_,4, 8
	snd_ret
SndData_BGM_08_Ch2:
	envelope $88
	panning $22
	duty_cycle 3
	snd_call SndCall_BGM_08_Ch2_0
	snd_call SndCall_BGM_08_Ch2_1
	snd_call SndCall_BGM_08_Ch2_1
	snd_call SndCall_BGM_08_Ch2_0
	snd_call SndCall_BGM_08_Ch2_1
	envelope $82
	note D_,6, 4
	envelope $62
	note C_,6
	envelope $82
	note A_,5
	envelope $62
	note D_,6
	fine_tune 12
	envelope $A8
	note A_,4, 12
	envelope $88
	note A_,4, 4
	envelope $A8
	note G_,4, 12
	envelope $88
	note G_,4, 4
	envelope $A8
	note D_,4, 12
	envelope $88
	note D_,4, 4
	envelope $A8
	note F_,4, 12
	envelope $88
	note F_,4, 4
	envelope $A8
	note C_,4, 12
	envelope $88
	note C_,4, 4
	envelope $A8
	note D_,4, 12
	envelope $88
	note D_,4, 4
	envelope $A8
	note G_,3, 12
	envelope $88
	note G_,3, 4
	fine_tune -12
	snd_call SndCall_BGM_08_Ch2_0
	snd_call SndCall_BGM_08_Ch2_1
	snd_call SndCall_BGM_08_Ch2_1
	snd_call SndCall_BGM_08_Ch2_0
	snd_call SndCall_BGM_08_Ch2_1
	snd_call SndCall_BGM_08_Ch2_1
	snd_call SndCall_BGM_08_Ch2_2
	snd_call SndCall_BGM_08_Ch2_3
	snd_call SndCall_BGM_08_Ch2_2
	snd_call SndCall_BGM_08_Ch2_4
	snd_loop SndData_BGM_08_Ch2
SndCall_BGM_08_Ch2_0:
	envelope $82
	note D_,6, 4
	envelope $62
	note C_,6
	envelope $82
	note C_,6
	envelope $62
	note D_,6
	envelope $82
	note D_,6
	envelope $62
	note C_,6
	envelope $82
	note C_,6
	envelope $62
	note D_,6
	envelope $82
	note G_,5
	envelope $62
	note C_,6
	silence
	note G_,5
	envelope $82
	note D_,6
	silence
	note C_,6
	envelope $62
	note D_,6
	envelope $82
	note D_,6
	envelope $62
	note C_,6
	envelope $82
	note C_,6
	envelope $62
	note D_,6
	envelope $82
	note G_,5
	envelope $62
	note C_,6
	silence
	note G_,5
	silence 8
	envelope $82
	note E_,5, 4
	silence
	note A#,5
	envelope $62
	note E_,5
	envelope $82
	note C_,6
	envelope $62
	note A#,5
	snd_loop SndCall_BGM_08_Ch2_0, $00, 2
	snd_ret
SndCall_BGM_08_Ch2_1:
	envelope $82
	note D_,6, 4
	envelope $62
	note C_,6
	envelope $82
	note A_,5
	envelope $62
	note D_,6
	envelope $82
	note D_,6
	envelope $62
	note A_,5
	envelope $82
	note E_,5
	envelope $62
	note D_,6
	envelope $82
	note D_,5
	envelope $62
	note E_,5
	silence
	note D_,5
	envelope $82
	note D_,6
	silence
	note A_,5
	envelope $62
	note D_,6
	envelope $82
	note D_,6
	envelope $62
	note A_,5
	envelope $82
	note E_,5
	envelope $62
	note D_,6
	envelope $82
	note D_,5
	envelope $62
	note E_,5
	silence
	note D_,5
	silence 8
	envelope $82
	note E_,5, 4
	silence
	note A_,5
	envelope $62
	note E_,5
	envelope $82
	note C_,6
	envelope $62
	note A_,5
	snd_ret
SndCall_BGM_08_Ch2_2:
	envelope $82
	note D_,6, 8
	silence 4
	envelope $62
	note D_,6
	envelope $82
	note A#,5, 8
	silence 4
	envelope $62
	note A#,5
	envelope $82
	note G_,6, 8
	silence 4
	envelope $62
	note G_,6
	envelope $82
	note A#,5, 8
	silence 4
	envelope $62
	note A#,5
	envelope $82
	note D_,6, 8
	silence 4
	envelope $62
	note D_,6
	envelope $82
	note A#,5, 8
	silence 4
	envelope $62
	note A#,5
	envelope $82
	note F_,6, 8
	silence 4
	envelope $62
	note F_,6
	envelope $82
	note A#,5, 8
	silence 4
	envelope $62
	note A#,5
	envelope $82
	note D_,6, 8
	silence 4
	envelope $62
	note D_,6
	envelope $82
	note A#,5, 8
	silence 4
	envelope $62
	note A#,5
	envelope $82
	note G_,6, 8
	silence 4
	envelope $62
	note G_,6
	envelope $82
	note A#,5, 8
	silence 4
	envelope $62
	note A#,5
	envelope $82
	note D_,6, 8
	silence 4
	envelope $62
	note D_,6
	envelope $82
	note A#,5, 8
	silence 4
	envelope $62
	note A#,5
	envelope $82
	note E_,6, 8
	silence 4
	envelope $62
	note E_,6
	envelope $82
	note G_,5, 8
	silence 4
	envelope $62
	note G_,5
	envelope $82
	note C_,6, 8
	silence 4
	envelope $62
	note C_,6
	envelope $82
	note A_,5, 8
	silence 4
	envelope $62
	note A_,5
	envelope $82
	note G_,6, 8
	silence 4
	envelope $62
	note G_,6
	envelope $82
	note A_,5, 8
	silence 4
	envelope $62
	note A_,5
	envelope $82
	note C_,6, 8
	silence 4
	envelope $62
	note C_,6
	envelope $82
	note A_,5, 8
	silence 4
	envelope $62
	note A_,5
	envelope $82
	note E_,6, 8
	silence 4
	envelope $62
	note E_,6
	envelope $82
	note G_,5, 8
	silence 4
	envelope $62
	note G_,5
	envelope $82
	note C_,6, 8
	silence 4
	envelope $62
	note C_,6
	envelope $82
	note A_,5, 8
	silence 4
	envelope $62
	note A_,5
	envelope $82
	note F_,6, 8
	silence 4
	envelope $62
	note F_,6
	envelope $82
	note A_,5, 8
	silence 4
	envelope $62
	note A_,5
	envelope $82
	note C_,6, 8
	silence 4
	envelope $62
	note C_,6
	envelope $82
	note A_,5, 8
	silence 4
	envelope $62
	note A_,5
	envelope $82
	note E_,5, 8
	silence 4
	envelope $62
	note E_,5
	envelope $82
	note A_,5, 8
	silence 4
	envelope $62
	note A_,5
	snd_ret
SndCall_BGM_08_Ch2_3:
	envelope $82
	note D_,6, 8
	silence 4
	envelope $62
	note D_,6
	envelope $82
	note A#,5, 8
	silence 4
	envelope $62
	note A#,5
	envelope $82
	note G_,6, 8
	silence 4
	envelope $62
	note G_,6
	envelope $82
	note A#,5, 8
	silence 4
	envelope $62
	note A#,5
	envelope $82
	note D_,6, 8
	silence 4
	envelope $62
	note D_,6
	envelope $82
	note A#,5, 8
	silence 4
	envelope $62
	note A#,5
	envelope $82
	note F_,6, 8
	silence 4
	envelope $62
	note F_,6
	envelope $82
	note A#,5, 8
	silence 4
	envelope $62
	note A#,5
	envelope $82
	note E_,6, 8
	silence 4
	envelope $62
	note E_,6
	envelope $82
	note A#,5, 8
	silence 4
	envelope $62
	note A#,5
	envelope $82
	note G_,6, 8
	silence 4
	envelope $62
	note G_,6
	envelope $82
	note A#,5, 8
	silence 4
	envelope $62
	note A#,5
	envelope $82
	note E_,6, 8
	silence 4
	envelope $62
	note E_,6
	envelope $82
	note A#,5, 8
	silence 4
	envelope $62
	note A#,5
	envelope $82
	note D_,6, 8
	silence 4
	envelope $62
	note D_,6
	envelope $82
	note G_,5, 8
	silence 4
	envelope $62
	note G_,5
	envelope $82
	note C_,6, 8
	silence 4
	envelope $62
	note C_,6
	envelope $82
	note F_,5, 8
	silence 4
	envelope $62
	note F_,5
	envelope $82
	note E_,6, 8
	silence 4
	envelope $62
	note E_,6
	envelope $82
	note F_,5, 8
	silence 4
	envelope $62
	note F_,5
	envelope $82
	note C_,6, 8
	silence 4
	envelope $62
	note C_,6
	envelope $82
	note F_,5, 8
	silence 4
	envelope $62
	note F_,5
	envelope $82
	note A_,5, 8
	silence 4
	envelope $62
	note A_,5
	envelope $82
	note F_,5, 8
	silence 4
	envelope $62
	note F_,5
	envelope $82
	note C_,6, 8
	silence 4
	envelope $62
	note C_,6
	envelope $82
	note F_,5, 8
	silence 4
	envelope $62
	note F_,5
	envelope $82
	note E_,6, 8
	silence 4
	envelope $62
	note E_,6
	envelope $82
	note F_,5, 8
	silence 4
	envelope $62
	note F_,5
	envelope $82
	note A_,5, 8
	silence 4
	envelope $62
	note A_,5
	envelope $82
	note F_,5, 8
	silence 4
	envelope $62
	note F_,5
	envelope $82
	note E_,5, 8
	silence 4
	envelope $62
	note E_,5
	envelope $82
	note C_,5, 8
	silence 4
	envelope $62
	note C_,5
	snd_ret
SndCall_BGM_08_Ch2_4:
	envelope $82
	note D_,6, 8
	silence 4
	envelope $62
	note D_,6
	envelope $82
	note A_,5, 8
	silence 4
	envelope $62
	note A_,5
	envelope $82
	note F_,6, 8
	silence 4
	envelope $62
	note F_,6
	envelope $82
	note A_,5, 8
	silence 4
	envelope $62
	note A_,5
	snd_loop SndCall_BGM_08_Ch2_4, $00, 4
.loop1:
	envelope $82
	note A#,5, 8
	silence 4
	envelope $62
	note A#,5
	envelope $82
	note G_,5, 8
	silence 4
	envelope $62
	note G_,5
	envelope $82
	note D_,6, 8
	silence 4
	envelope $62
	note D_,6
	envelope $82
	note G_,5, 8
	silence 4
	envelope $62
	note G_,5
	snd_loop .loop1, $00, 2
	envelope $82
	note A#,5, 8
	silence 4
	envelope $62
	note A#,5
	envelope $82
	note G_,5, 8
	silence 4
	envelope $62
	note G_,5
	envelope $82
	note C_,6, 8
	silence 4
	envelope $62
	note C_,6
	envelope $82
	note G_,5, 8
	silence 4
	envelope $62
	note G_,5
	envelope $82
	note A#,5, 8
	silence 4
	envelope $62
	note A#,5
	envelope $82
	note G_,5, 8
	silence 4
	envelope $62
	note G_,5
	envelope $82
	note E_,5, 8
	silence 4
	envelope $62
	note E_,5
	envelope $82
	note G_,5, 8
	silence 4
	envelope $62
	note G_,5
	snd_ret
SndData_BGM_08_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	wave_cutoff 0
	snd_call SndCall_BGM_08_Ch3_0
	snd_call SndCall_BGM_08_Ch3_1
	snd_call SndCall_BGM_08_Ch3_2
	snd_call SndCall_BGM_08_Ch3_1
	note B_,3, 16
	note F_,4, 8
	silence
	note F_,4, 16
	note B_,3
	silence
	note B_,3
	note F_,3
	note A_,3
	note B_,3, 16
	note F_,4, 8
	silence
	note F_,4, 16
	note B_,3
	silence
	note D_,4
	note F_,4
	note A_,4
	note C_,4, 16
	note G_,4, 8
	silence
	note G_,4, 16
	note C_,4
	silence
	note C_,4
	note G_,3
	note A#,3
	note C_,4, 16
	note G_,4
	note E_,4
	note C_,4
	note G_,3
	note E_,3
	note C_,4
	note A#,3
	snd_loop SndData_BGM_08_Ch3
SndCall_BGM_08_Ch3_0:
	note G_,3, 32
	silence 16
	note G_,3, 32
	note D_,3, 16
	note F_,3
	note D_,3
	note C_,4, 32
	silence 16
	note C_,4, 32
	note G_,3, 16
	note C_,4
	note E_,3
	note D_,4, 32
	silence 16
	note D_,3, 32
	note A_,3, 16
	note C_,4
	note F_,3
	note D_,4, 32
	silence 16
	note D_,3, 32
	note F_,3, 16
	note C_,4
	note A_,3
	snd_loop SndCall_BGM_08_Ch3_0, $00, 4
	snd_ret
SndCall_BGM_08_Ch3_1:
	note G_,3, 16
	note D_,4, 8
	silence
	note D_,4, 16
	note G_,3
	silence
	note G_,3
	note F_,4
	note G_,3
	note C_,4, 16
	note G_,4, 8
	silence
	note G_,4, 16
	note C_,4
	silence
	note C_,4
	note A#,3
	note C_,4
	note F_,3, 16
	note C_,4, 8
	silence
	note C_,4, 16
	note F_,3
	silence
	note F_,3
	note E_,4
	note F_,3
	note A#,3, 16
	note F_,4, 8
	silence
	note F_,4, 16
	note A#,3
	silence
	note A#,3
	note A_,4
	note A#,3
	snd_ret
SndCall_BGM_08_Ch3_2:
	note G_,3, 16
	note D_,4, 8
	silence
	note D_,4, 16
	note G_,3
	silence
	note G_,3
	note F_,4
	note G_,3
	note E_,3, 16
	note A#,3, 8
	silence
	note A#,3, 16
	note E_,3
	silence
	note E_,3
	note C_,4
	note E_,3
	note F_,3, 16
	note C_,4, 8
	silence
	note C_,4, 16
	note F_,3
	silence
	note F_,3
	note E_,4
	note F_,3
	note F_,3, 16
	note C_,4, 8
	silence
	note C_,4, 16
	note F_,3
	silence
	note F_,3
	note C_,4
	note E_,4
	snd_ret
SndData_Unused_0003A1D4:
	panning $88
	chan_stop
