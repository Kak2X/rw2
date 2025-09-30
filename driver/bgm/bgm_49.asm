SndHeader_BGM_49:
	db $03 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_49_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_49_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_49_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_Unused_0003E6AD ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_BGM_49_Ch1:
	envelope $A8
	panning $11
	duty_cycle 3
	vibrato_on $01
	snd_call SndCall_BGM_49_Ch1_0
	fine_tune -1
	snd_call SndCall_BGM_49_Ch1_0
	fine_tune 1
	snd_call SndCall_BGM_49_Ch1_1
	fine_tune -3
	snd_call SndCall_BGM_49_Ch1_0
	fine_tune -1
	snd_call SndCall_BGM_49_Ch1_0
	fine_tune 4
	fine_tune -3
	snd_call SndCall_BGM_49_Ch1_1
	fine_tune 3
	duty_cycle 2
	snd_call SndCall_BGM_49_Ch1_2
	duty_cycle 3
	snd_call SndCall_BGM_49_Ch1_0
	fine_tune -1
	snd_call SndCall_BGM_49_Ch1_0
	fine_tune 1
	snd_call SndCall_BGM_49_Ch1_1
	fine_tune -3
	snd_call SndCall_BGM_49_Ch1_0
	fine_tune -1
	snd_call SndCall_BGM_49_Ch1_0
	fine_tune 4
	fine_tune -3
	snd_call SndCall_BGM_49_Ch1_1
	fine_tune 3
	duty_cycle 2
	snd_call SndCall_BGM_49_Ch1_2
	snd_call SndCall_BGM_49_Ch1_3
	snd_call SndCall_BGM_49_Ch1_2
	snd_loop SndData_BGM_49_Ch1
SndCall_BGM_49_Ch1_0:
	envelope $A8
	note A#,5, 32
	envelope $88
	note A#,5, 8
	silence 4
	envelope $68
	note A#,5
	envelope $A8
	note F_,5, 16
	envelope $88
	note F_,5, 8
	silence 4
	envelope $68
	note F_,5
	envelope $48
	note F_,5, 8
	silence 4
	envelope $38
	note F_,5
	snd_ret
SndCall_BGM_49_Ch1_1:
	envelope $A8
	note G#,5, 16
	envelope $88
	note G#,5, 8
	silence 4
	envelope $68
	note G#,5
	envelope $A8
	note D#,5, 16
	envelope $88
	note D#,5, 8
	silence 4
	envelope $68
	note D#,5
	snd_ret
SndCall_BGM_49_Ch1_2:
	envelope $A8
	note C_,5, 8
	silence 4
	envelope $88
	note C_,5
	envelope $A8
	note D#,4, 8
	silence 4
	envelope $88
	note D#,4
	envelope $A8
	note G_,4, 8
	silence 4
	envelope $88
	note G_,4
	envelope $A8
	note C#,5, 8
	envelope $88
	note C#,5
	silence 4
	envelope $68
	note C#,5
	envelope $48
	note C#,5, 8
	envelope $A8
	note C#,5, 8
	silence 4
	envelope $88
	note C#,5
	envelope $A8
	note C_,5, 8
	note A#,4
	note G#,4
	note D#,4
	snd_loop SndCall_BGM_49_Ch1_2, $00, 4
	snd_ret
SndCall_BGM_49_Ch1_3:
	envelope $A8
	note A#,5, 16
	silence 4
	envelope $88
	note A#,5
	envelope $A8
	note A_,5, 24
	note G#,5, 16
	silence 4
	envelope $88
	note G#,5
	envelope $A8
	note G_,5, 24
	note F#,5, 8
	silence 4
	envelope $88
	note F#,5
	envelope $A8
	note F_,5, 8
	silence 4
	envelope $88
	note F_,5
	envelope $A8
	note E_,5, 16
	silence 4
	envelope $88
	note E_,5
	envelope $A8
	note D#,5, 24
	note D_,5, 16
	silence 4
	envelope $88
	note D_,5
	envelope $A8
	note C#,5, 24
	note C_,5, 8
	silence 4
	envelope $88
	note C_,5
	envelope $A8
	note B_,4, 8
	silence 4
	envelope $88
	note B_,4
	snd_loop SndCall_BGM_49_Ch1_3, $00, 2
	snd_ret
SndData_BGM_49_Ch2:
	envelope $88
	panning $22
	duty_cycle 1
	vibrato_on $01
	fine_tune -5
	snd_call SndCall_BGM_49_Ch1_0
	fine_tune -1
	snd_call SndCall_BGM_49_Ch1_0
	fine_tune 1
	snd_call SndCall_BGM_49_Ch1_1
	fine_tune -3
	snd_call SndCall_BGM_49_Ch1_0
	fine_tune -1
	snd_call SndCall_BGM_49_Ch1_0
	fine_tune 4
	fine_tune -3
	snd_call SndCall_BGM_49_Ch1_1
	fine_tune 3
	fine_tune 5
	snd_call SndCall_BGM_49_Ch2_2
	fine_tune -5
	snd_call SndCall_BGM_49_Ch1_0
	fine_tune -1
	snd_call SndCall_BGM_49_Ch1_0
	fine_tune 1
	snd_call SndCall_BGM_49_Ch1_1
	fine_tune -3
	snd_call SndCall_BGM_49_Ch1_0
	fine_tune -1
	snd_call SndCall_BGM_49_Ch1_0
	fine_tune 4
	fine_tune -3
	snd_call SndCall_BGM_49_Ch1_1
	fine_tune 3
	fine_tune 5
	snd_call SndCall_BGM_49_Ch2_2
	snd_call SndCall_BGM_49_Ch2_3
	snd_call SndCall_BGM_49_Ch2_2
	snd_loop SndData_BGM_49_Ch2
SndCall_BGM_49_Ch2_2:
	envelope $68
	note G_,5, 16
	envelope $88
	note C_,6, 8
	silence 4
	envelope $68
	note C_,6
	envelope $88
	note C_,6, 8
	silence 4
	envelope $68
	note C_,6
	note G#,5, 16
	envelope $88
	note C#,6, 8
	silence 4
	envelope $68
	note C#,6
	envelope $88
	note C#,6, 8
	silence 4
	envelope $68
	note C#,6
	envelope $88
	note D#,5, 8
	note G#,5
	envelope $68
	note D#,5, 4
	note G#,5
	silence
	envelope $48
	note G#,5
	snd_loop SndCall_BGM_49_Ch2_2, $00, 4
	snd_ret
SndCall_BGM_49_Ch2_3:
	envelope $A8
	note C_,5, 16
	silence 4
	envelope $88
	note C_,5
	envelope $A8
	note B_,4, 16
	silence 4
	envelope $88
	note B_,4
	envelope $A8
	note A#,4, 16
	silence 4
	envelope $88
	note A#,4
	envelope $A8
	note A_,4, 16
	silence 4
	envelope $88
	note A_,4
	envelope $A8
	note G#,4, 8
	silence 4
	envelope $88
	note G#,4
	envelope $A8
	note G_,4, 8
	silence 4
	envelope $88
	note G_,4
	envelope $A8
	note F#,4, 16
	silence 4
	envelope $88
	note F#,4
	envelope $A8
	note F_,4, 16
	silence 4
	envelope $88
	note F_,4
	envelope $A8
	note E_,4, 16
	silence 4
	envelope $88
	note E_,4
	envelope $A8
	note D#,4, 16
	silence 4
	envelope $88
	note D#,4
	envelope $A8
	note D_,4, 8
	silence 4
	envelope $88
	note D_,4
	envelope $A8
	note G_,4, 8
	silence 4
	envelope $88
	note G_,4
	snd_loop SndCall_BGM_49_Ch2_3, $00, 2
	snd_ret
SndData_BGM_49_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	wave_cutoff 0
	snd_call SndCall_BGM_49_Ch3_0
	snd_call SndCall_BGM_49_Ch3_0
	snd_call SndCall_BGM_49_Ch3_0
	snd_call SndCall_BGM_49_Ch3_0
	snd_call SndCall_BGM_49_Ch3_1
	snd_call SndCall_BGM_49_Ch3_0
	snd_loop SndData_BGM_49_Ch3
SndCall_BGM_49_Ch3_0:
	note C_,4, 8
	silence
	note D#,4
	silence
	note G_,4
	silence
	note C_,4
	silence
	note D_,4
	silence
	note G_,4
	silence
	note F_,4
	note D#,4
	note D_,4
	note G_,3
	snd_loop SndCall_BGM_49_Ch3_0, $00, 4
	snd_ret
SndCall_BGM_49_Ch3_1:
	note C_,5, 8
	note C_,4
	note D#,4
	note G_,4
	note D_,4
	note G_,3
	note C_,5
	note C_,4
	note D#,4
	note G_,4
	note D_,4
	note G_,3
	note F_,4
	note D#,4
	note D_,4
	note G_,3
	snd_loop SndCall_BGM_49_Ch3_1, $00, 4
	snd_ret
SndData_Unused_0003E6AD:
	panning $88
	chan_stop
