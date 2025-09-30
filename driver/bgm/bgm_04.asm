SndHeader_BGM_04:
	db $03 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_04_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_04_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_04_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_Unused_00039AB8 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_BGM_04_Ch1:
	envelope $A8
	panning $11
	duty_cycle 3
	vibrato_on $01
	snd_call SndCall_BGM_04_Ch1_0
	duty_cycle 2
	envelope $A8
	note D_,4, 12
	silence 6
	envelope $68
	note D_,4, 6
	envelope $A8
	note D#,4, 12
	silence 6
	envelope $68
	note D#,4, 6
	envelope $A8
	note F_,4, 12
	silence 6
	envelope $68
	note F_,4, 6
	envelope $A8
	note G_,4, 12
	silence 6
	envelope $68
	note G_,4, 6
	envelope $A8
	note G#,4, 12
	silence 6
	envelope $68
	note G#,4, 6
	envelope $A8
	note A#,4, 12
	silence 6
	envelope $68
	note A#,4, 6
	snd_call SndCall_BGM_04_Ch1_1
	duty_cycle 2
	envelope $A8
	note D_,4, 12
	silence 6
	envelope $68
	note D_,4, 6
	envelope $A8
	note D#,4, 12
	silence 6
	envelope $68
	note D#,4, 6
	envelope $A8
	note F_,4, 12
	silence 6
	envelope $68
	note F_,4, 6
	envelope $A8
	note C_,4, 12
	silence 6
	envelope $68
	note C_,4, 6
	duty_cycle 0
	envelope $82
	note C#,5, 12
	note C_,5
	envelope $88
	note A#,4, 24
	duty_cycle 2
	envelope $A3
	note D_,4, 12
	note C_,4
	note D_,4
	note D#,4
	note F_,4
	note D#,4
	note F_,4
	note G_,4
	note G#,4
	note G_,4
	note G#,4
	note A#,4
	note C_,5
	note A#,4
	note C_,5
	note D_,5
	note D#,5
	note D_,5
	note D#,5
	note F_,5
	envelope $A8
	note G_,5
	note G#,5
	note A#,5
	note C_,6
	snd_call SndCall_BGM_04_Ch1_2
	snd_call SndCall_BGM_04_Ch1_3
	snd_call SndCall_BGM_04_Ch1_2
	duty_cycle 3
	envelope $A8
	note C_,6, 6
	silence 3
	envelope $68
	note C_,6
	envelope $A8
	note B_,5, 6
	silence 3
	envelope $68
	note B_,5
	envelope $A8
	note A#,5, 6
	silence 3
	envelope $68
	note A#,5
	envelope $A8
	note A_,5, 6
	silence 3
	envelope $68
	note A_,5
	envelope $A8
	note G#,5, 6
	silence 3
	envelope $68
	note G#,5
	envelope $A8
	note G_,5, 6
	silence 3
	envelope $68
	note G_,5
	envelope $A8
	note F#,5, 6
	silence 3
	envelope $68
	note F#,5
	envelope $A8
	note F_,5, 6
	silence 3
	envelope $68
	note F_,5
	envelope $A8
	note E_,5, 6
	silence 3
	envelope $68
	note E_,5
	envelope $A8
	note D#,5, 6
	silence 3
	envelope $68
	note D#,5
	envelope $A8
	note D_,5, 6
	silence 3
	envelope $68
	note D_,5
	envelope $A8
	note C#,5, 6
	silence 3
	envelope $68
	note C#,5
	snd_call SndCall_BGM_04_Ch1_2
	snd_call SndCall_BGM_04_Ch1_3
	envelope $A8
	note G_,5, 12
	note F#,5
	note F_,5
	note E_,5
	silence 3
	envelope $68
	note E_,5, 6
	silence
	envelope $38
	note E_,5
	silence 3
	envelope $A8
	note A#,5, 12
	note A_,5
	note G#,5
	note G_,5
	silence 3
	envelope $68
	note G_,5, 6
	silence
	envelope $38
	note G_,5
	silence 3
	envelope $A8
	note C#,6, 12
	note C_,6
	note B_,5
	note A#,5
	silence 3
	envelope $68
	note A#,5, 6
	silence
	envelope $38
	note A#,5
	silence 3
	envelope $A8
	note E_,6, 12
	note D#,6
	note D_,6
	note C#,6
	silence 3
	envelope $68
	note C#,6, 6
	silence
	envelope $38
	note C#,6
	silence 3
	envelope $A8
	note D#,5, 18
	envelope $68
	note D#,5, 6
	envelope $A8
	note E_,5, 18
	envelope $68
	note E_,5, 6
	envelope $A8
	note F#,5, 18
	envelope $68
	note F#,5, 6
	envelope $A8
	note G#,5, 18
	envelope $68
	note G#,5, 6
	envelope $A8
	note A#,5, 18
	envelope $68
	note A#,5, 6
	envelope $A8
	note B_,5, 18
	envelope $68
	note B_,5, 6
	envelope $A8
	note F_,5, 18
	envelope $68
	note F_,5, 6
	envelope $A8
	note F#,5, 18
	envelope $68
	note F#,5, 6
	envelope $A8
	note G#,5, 18
	envelope $68
	note G#,5, 6
	envelope $A8
	note A#,5, 18
	envelope $68
	note A#,5, 6
	envelope $A8
	note C_,6, 18
	envelope $68
	note C_,6, 6
	envelope $A8
	note C#,6, 18
	envelope $68
	note C#,6, 6
	envelope $A2
	note G_,6, 12
	note G_,6, 6
	note F#,6
	note F_,6
	silence
	note E_,6
	silence
	note D#,6
	silence
	note D_,6
	silence
	note C#,6, 12
	note C#,6, 6
	note C_,6
	note B_,5
	silence
	note A#,5
	silence
	note A_,5
	silence
	note G#,5
	silence
	note G_,5, 12
	note G_,5, 6
	note F#,5
	note F_,5
	silence
	note E_,5
	silence
	note D#,5
	silence
	note D_,5
	silence
	envelope $A8
	note G_,4, 12
	note G#,4
	note A#,4
	note C_,5
	note D_,5
	note D#,5
	snd_loop SndData_BGM_04_Ch1
SndCall_BGM_04_Ch1_0:
	duty_cycle 2
	envelope $A8
	note D_,4, 12
	silence 6
	envelope $68
	note D_,4, 6
	envelope $A8
	note D#,4, 12
	silence 6
	envelope $68
	note D#,4, 6
	envelope $A8
	note F_,4, 12
	silence 6
	envelope $68
	note F_,4, 6
	envelope $A8
	note C_,4, 12
	silence 6
	envelope $68
	note C_,4, 6
	duty_cycle 0
	envelope $82
	note C#,5, 12
	note C_,5
	note C#,5
	note C_,5
	snd_loop SndCall_BGM_04_Ch1_0, $00, 3
	snd_ret
SndCall_BGM_04_Ch1_1:
	duty_cycle 2
	envelope $A8
	note D_,4, 12
	silence 6
	envelope $68
	note D_,4, 6
	envelope $A8
	note D#,4, 12
	silence 6
	envelope $68
	note D#,4, 6
	envelope $A8
	note F_,4, 12
	silence 6
	envelope $68
	note F_,4, 6
	envelope $A8
	note C_,4, 12
	silence 6
	envelope $68
	note C_,4, 6
	duty_cycle 0
	envelope $82
	note C#,5, 12
	note C_,5
	note C#,5
	note C_,5
	snd_loop SndCall_BGM_04_Ch1_1, $00, 2
	snd_ret
SndCall_BGM_04_Ch1_2:
	duty_cycle 2
	envelope $A8
	note G_,5, 24
	silence 3
	envelope $68
	note G_,5, 6
	silence
	envelope $38
	note G_,5
	silence 3
	envelope $A8
	note G_,5, 24
	envelope $A8
	note A#,5, 24
	silence 3
	envelope $68
	note A#,5, 6
	silence
	envelope $38
	note A#,5
	silence 3
	envelope $A8
	note A#,5, 24
	snd_ret
SndCall_BGM_04_Ch1_3:
	envelope $A8
	note D#,5, 24
	silence 3
	envelope $68
	note D#,5, 6
	silence
	envelope $38
	note D#,5
	silence 3
	envelope $A8
	note D#,5, 24
	envelope $A8
	note F#,5, 24
	silence 3
	envelope $68
	note F#,5, 6
	silence
	envelope $38
	note F#,5
	silence 3
	envelope $A8
	note F#,5, 24
	snd_ret
SndData_BGM_04_Ch2:
	envelope $A8
	panning $22
	duty_cycle 0
	vibrato_on $01
	envelope $48
	note C_,5, 6
	silence 3
	envelope $28
	note C_,5
	envelope $38
	note C_,5, 6
	silence 3
	envelope $18
	note C_,5
	snd_call SndCall_BGM_04_Ch2_0
	snd_call SndCall_BGM_04_Ch2_1
	envelope $48
	note F_,5, 6
	silence 3
	envelope $28
	note F_,5
	envelope $38
	note F_,5, 6
	silence 3
	envelope $18
	note F_,5
	snd_call SndCall_BGM_04_Ch2_0
	snd_call SndCall_BGM_04_Ch2_2
	envelope $48
	note D_,5, 6
	silence 3
	envelope $28
	note D_,5
	envelope $38
	note D_,5, 6
	silence 3
	envelope $18
	note D_,5
	snd_call SndCall_BGM_04_Ch2_0
	snd_call SndCall_BGM_04_Ch2_1
	envelope $A8
	note G#,5, 6
	envelope $A8
	note G#,6, 3
	envelope $78
	note G#,5
	envelope $A8
	note G_,5
	envelope $78
	note G#,6
	envelope $A8
	note G_,6
	envelope $78
	note G_,5
	envelope $A8
	note F_,5
	envelope $78
	note G_,6
	envelope $A8
	note F_,6
	envelope $78
	note F_,5
	envelope $A8
	note D#,5
	envelope $78
	note F_,6
	envelope $A8
	note D#,6
	envelope $78
	note D#,5
	envelope $A8
	note D_,5
	envelope $78
	note D#,6
	envelope $A8
	note D_,6
	envelope $78
	note D_,5
	envelope $A8
	note G#,4
	envelope $78
	note D_,6
	envelope $A8
	note G#,5
	envelope $78
	note G#,4
	envelope $A8
	note A#,4
	envelope $78
	note G#,5
	envelope $A8
	note A#,5
	envelope $78
	note A#,4
	envelope $A8
	note C_,5
	envelope $78
	note A#,5
	envelope $A8
	note C_,6
	envelope $78
	note C_,5
	envelope $A8
	note D_,5
	envelope $78
	note C_,6
	envelope $A8
	note D_,6
	envelope $78
	note D_,5
	envelope $A8
	note D#,5
	envelope $78
	note D_,6
	envelope $A8
	note D#,6
	envelope $78
	note D#,5
	envelope $A8
	note F_,5
	envelope $78
	note D#,6
	envelope $A8
	note F_,6
	envelope $78
	note F_,5
	envelope $A8
	note G_,5
	envelope $78
	note F_,6
	envelope $A8
	note G_,6
	envelope $78
	note G_,5
	silence 3
	envelope $78
	note G_,6
	silence
	envelope $38
	note G_,5
	envelope $48
	note G_,6, 6
	silence 3
	envelope $18
	note G_,5
	snd_call SndCall_BGM_04_Ch2_0
	snd_call SndCall_BGM_04_Ch2_1
	envelope $48
	note F_,5, 6
	silence 3
	envelope $28
	note F_,5
	envelope $38
	note F_,5, 6
	silence 3
	envelope $18
	note F_,5
	snd_call SndCall_BGM_04_Ch2_0
	snd_call SndCall_BGM_04_Ch2_2
	envelope $48
	note D_,5, 6
	silence 3
	envelope $28
	note D_,5
	envelope $38
	note D_,5, 6
	silence 3
	envelope $18
	note D_,5
	snd_call SndCall_BGM_04_Ch2_0
	snd_call SndCall_BGM_04_Ch2_1
	envelope $A3
	note F_,4, 12
	note D#,4
	note F_,4
	note G_,4
	note G#,4
	note G_,4
	note G#,4
	note A#,4
	note C_,5
	note A#,4
	note C_,5
	note D_,5
	note D#,5
	note D_,5
	note D#,5
	note F_,5
	note G_,5
	note F_,5
	note G_,5
	note G#,5
	note A#,5
	note C_,6
	note D_,6
	note D#,6
	envelope $68
	note D#,6, 9
	envelope $38
	note D#,6, 3
	snd_call SndCall_BGM_04_Ch2_3
	envelope $68
	note A#,4, 6
	silence 3
	envelope $38
	note A#,4, 3
	snd_call SndCall_BGM_04_Ch2_3
	envelope $68
	note A#,4, 6
	silence 3
	envelope $38
	note A#,4, 3
	snd_call SndCall_BGM_04_Ch2_4
	envelope $68
	note G_,4, 6
	silence 3
	envelope $38
	note G_,4
	snd_call SndCall_BGM_04_Ch2_3
	envelope $68
	note A#,4, 6
	silence 3
	envelope $38
	note A#,4, 3
	snd_call SndCall_BGM_04_Ch2_3
	envelope $A3
	note F#,5, 12
	note F_,5
	note E_,5
	note D#,5
	note D_,5
	note C#,5
	note C_,5
	note B_,4
	note A#,4
	note A_,4
	note G#,4
	note G_,4
	envelope $68
	note G_,4, 9
	envelope $38
	note G_,4, 3
	snd_call SndCall_BGM_04_Ch2_3
	envelope $68
	note A#,4, 6
	silence 3
	envelope $38
	note A#,4, 3
	snd_call SndCall_BGM_04_Ch2_3
	envelope $68
	note A#,4, 6
	silence 3
	envelope $38
	note A#,4, 3
	snd_call SndCall_BGM_04_Ch2_4
	envelope $A3
	note D#,5, 12
	note D_,5
	note C#,5
	note C_,5, 36
	note F#,5, 12
	note F_,5
	note E_,5
	note D#,5, 36
	note A_,5, 12
	note G#,5
	note G_,5
	note F#,5, 36
	note C_,6, 12
	note B_,5
	note A#,5
	note A_,5, 36
	envelope $68
	note G_,4, 6
	silence 3
	envelope $38
	note G_,4, 3
	snd_call SndCall_BGM_04_Ch2_5
	envelope $68
	note F#,4, 6
	silence 3
	envelope $38
	note F#,4, 3
	snd_call SndCall_BGM_04_Ch2_5
	envelope $68
	note F#,4, 6
	silence 3
	envelope $38
	note F#,4, 3
	fine_tune 2
	snd_call SndCall_BGM_04_Ch2_5
	envelope $68
	note F#,4, 6
	silence 3
	envelope $38
	note F#,4, 3
	snd_call SndCall_BGM_04_Ch2_5
	fine_tune -2
	envelope $A2
	note D_,6, 12
	note D_,6, 6
	note C#,6
	note C_,6, 12
	note B_,5
	note A#,5
	note A_,5
	note G#,5, 12
	note G#,5, 6
	note G_,5
	note F#,5, 12
	note F_,5
	note E_,5
	note D#,5
	note D_,5, 12
	note D_,5, 6
	note C#,5
	note C_,5, 12
	note B_,4
	note A#,4
	note A_,4
	envelope $A8
	note A#,4
	note C_,5
	note D_,5
	note D#,5
	note F_,5
	note G_,5
	snd_loop SndData_BGM_04_Ch2
SndCall_BGM_04_Ch2_0:
	envelope $A8
	note G#,5, 6
	silence 3
	envelope $78
	note G#,5, 6
	envelope $48
	note G#,5, 6
	silence 3
	envelope $A8
	note G#,5, 6
	envelope $78
	note G#,5, 6
	silence 3
	envelope $48
	note G#,5, 3
	envelope $58
	note G#,5, 6
	silence 3
	envelope $28
	note G#,5, 6
	envelope $38
	note G#,5, 6
	silence 3
	envelope $18
	note G#,5, 6
	snd_ret
SndCall_BGM_04_Ch2_1:
	envelope $A8
	note F#,5, 6
	silence 3
	envelope $78
	note F#,5, 3
	envelope $A8
	note F_,5, 6
	silence 3
	envelope $78
	note F_,5, 3
	envelope $A8
	note F#,5, 6
	silence 3
	envelope $78
	note F#,5, 3
	envelope $A8
	note F_,5, 6
	silence 3
	envelope $78
	note F_,5, 3
	snd_ret
SndCall_BGM_04_Ch2_2:
	envelope $A8
	note D#,5, 6
	silence 3
	envelope $78
	note D#,5, 3
	envelope $A8
	note D_,5, 6
	silence 3
	envelope $78
	note D_,5, 3
	envelope $A8
	note D#,5, 6
	silence 3
	envelope $78
	note D#,5, 3
	envelope $A8
	note D_,5, 6
	silence 3
	envelope $78
	note D_,5, 3
	snd_ret
SndCall_BGM_04_Ch2_3:
	envelope $A8
	note A_,4, 6
	silence 3
	envelope $78
	note A_,4, 3
	envelope $A8
	note A#,4, 6
	silence 3
	envelope $78
	note A#,4, 3
	envelope $A8
	note D_,5, 6
	silence 3
	envelope $78
	note D_,5, 3
	envelope $A8
	note A_,4, 6
	silence 3
	envelope $78
	note A_,4, 3
	envelope $A8
	note A#,4, 6
	silence 3
	envelope $78
	note A#,4, 3
	snd_ret
SndCall_BGM_04_Ch2_4:
	envelope $A8
	note A_,4, 6
	silence 3
	envelope $78
	note A_,4, 3
	envelope $A8
	note A#,4, 6
	silence 3
	envelope $78
	note A#,4, 3
	envelope $A8
	note D#,5, 6
	silence 3
	envelope $78
	note D#,5, 3
	envelope $A8
	note C#,5, 6
	silence 3
	envelope $78
	note C#,5, 3
	envelope $A8
	note A#,4, 6
	silence 3
	envelope $78
	note A#,4, 3
	envelope $A8
	note C#,5, 6
	silence 3
	envelope $78
	note C#,5, 3
	envelope $A8
	note C_,5
	note C#,5, 6
	envelope $78
	note C_,5, 3
	envelope $A8
	note A#,4, 6
	envelope $78
	note C_,5, 3
	note A#,4
	envelope $A8
	note A_,4, 6
	silence 3
	envelope $78
	note A_,4, 3
	envelope $A8
	note G#,4, 6
	silence 3
	envelope $78
	note G#,4, 3
	envelope $A8
	note G_,4, 6
	silence 3
	envelope $78
	note G_,4, 3
	snd_ret
SndCall_BGM_04_Ch2_5:
	envelope $A8
	note F_,4, 6
	silence 3
	envelope $78
	note F_,4, 3
	envelope $A8
	note F#,4, 6
	silence 3
	envelope $78
	note F#,4, 3
	envelope $A8
	note A#,4, 6
	silence 3
	envelope $78
	note A#,4, 3
	envelope $A8
	note F_,4, 6
	silence 3
	envelope $78
	note F_,4, 3
	envelope $A8
	note F#,4, 6
	silence 3
	envelope $78
	note F#,4, 3
	snd_ret
SndData_BGM_04_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	wave_cutoff 0
	snd_call SndCall_BGM_04_Ch3_0
	note A#,3, 12
	silence
	note A#,3
	silence 36
	note A#,3, 12
	silence 48
	silence 12
	note A#,3, 12
	silence
	note C_,4
	silence
	note D_,4
	silence
	note D#,4
	silence
	note F_,4
	silence
	note G_,4
	silence
	snd_call SndCall_BGM_04_Ch3_0
	note A#,3, 12
	silence
	note A#,3
	silence 36
	note A#,3, 12
	silence 36
	note G#,3, 24
	note A#,3, 36
	note G#,3
	note F_,3
	note D#,3
	note D_,3
	note A#,3
	note F_,3
	note C_,4
	snd_call SndCall_BGM_04_Ch3_1
	note D#,4, 6
	silence 18
	note D#,4, 6
	silence 18
	note D#,4, 24
	note A#,3, 6
	silence 18
	note A#,3, 6
	silence 18
	note A#,3, 24
	note D_,5, 6
	silence
	note C#,5
	silence
	note C_,5
	silence
	note B_,4
	silence
	note A#,4
	silence
	note A_,4
	silence
	note G#,4
	silence
	note G_,4
	silence
	note F#,4
	silence
	note F_,4
	silence
	note E_,4
	silence
	note C#,4
	silence
	snd_call SndCall_BGM_04_Ch3_1
	silence 48
	note D#,4, 12
	note D_,4
	note C#,4
	note C_,4
	silence 24
	note F#,4, 12
	note F_,4
	note E_,4
	note D#,4
	silence 24
	note A_,4, 12
	note G#,4
	note G_,4
	note F#,4
	silence
	note C_,5
	note B_,4
	note A#,4
	note B_,3, 24
	note A#,3, 12
	note B_,3
	note A#,3, 6
	silence
	note B_,3
	silence
	note B_,3, 24
	note A#,3, 12
	note B_,3
	note A#,3
	note F#,3
	note C#,4, 24
	note C_,4, 12
	note C#,4
	note C_,4, 6
	silence
	note C#,4
	silence
	note C#,4, 24
	note C_,4, 12
	note C#,4
	note C_,4
	note G#,3
	note D#,4, 24
	note D_,4, 12
	note D#,4
	note C_,4, 6
	silence
	note D#,4
	silence
	note D#,4, 24
	note D_,4, 12
	note D#,4
	note C_,4, 6
	silence
	note D#,4
	silence
	note D#,4, 12
	note A#,3
	note D#,4
	note A#,3
	note D#,4
	note A#,3
	note D#,3
	note F_,3
	note G_,3
	note G#,3
	note A#,3
	note C_,4
	snd_loop SndData_BGM_04_Ch3
SndCall_BGM_04_Ch3_0:
	note A#,3, 12
	silence
	note A#,3
	silence 36
	note A#,3, 12
	silence 48
	silence 12
	snd_loop SndCall_BGM_04_Ch3_0, $00, 2
	snd_ret
SndCall_BGM_04_Ch3_1:
	note D#,4, 6
	silence 18
	note D#,4, 6
	silence 18
	note D#,4, 24
	note A#,3, 6
	silence 18
	note A#,3, 6
	silence 18
	note A#,3, 24
	note C#,4, 6
	silence 18
	note C#,4, 6
	silence 18
	note C#,4, 24
	note G#,3, 6
	silence 18
	note G#,3, 6
	silence 18
	note G#,3, 24
	snd_ret
SndData_Unused_00039AB8:
	chan_stop
