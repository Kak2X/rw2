SndHeader_BGM_4B:
	db $03 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_4B_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_4B_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_4B_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_Unused_00039346 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_BGM_4B_Ch1:
	envelope $A8
	panning $11
	duty_cycle 2
	vibrato_on $01
	snd_call SndCall_BGM_4B_Ch1_0
.loop2:
	envelope $A2
	duty_cycle 0
	snd_call SndCall_BGM_4B_Ch1_1
	note B_,5
	note G_,5
	snd_call SndCall_BGM_4B_Ch1_1
	envelope $A8
	duty_cycle 2
	note G_,4
	note A_,4
	note A#,4, 48
	note D#,5
	note D_,5, 6
	note D#,5
	note D_,5, 72
	note F_,5, 3
	note F#,5
	note G_,5
	note G#,5
	note A_,5, 96
	duty_cycle 3
	snd_call SndCall_BGM_4B_Ch1_2
	envelope $A8
	duty_cycle 2
	note G_,4, 6
	note A_,4
	note A#,4, 48
	note D#,5
	note D_,5, 6
	note D#,5
	note D_,5, 72
	note G_,5, 3
	note G#,5
	note A_,5
	note A#,5
	note B_,5, 96
	duty_cycle 3
	snd_call SndCall_BGM_4B_Ch1_2
	envelope $A8
	note F_,3, 6
	silence 3
	envelope $88
	note F_,3
	duty_cycle 2
.loop0:
	snd_call SndCall_BGM_4B_Ch1_3
	snd_loop .loop0, $00, 3
	envelope $A8
	note C_,5, 24
	envelope $88
	note C_,5, 6
	silence 3
	envelope $68
	note C_,5
	envelope $A8
	note C#,5, 36
	envelope $88
	note C#,5, 6
	note F#,5, 3
	envelope $98
	note G_,5
	note G#,5
	envelope $A8
	note A_,5
	note A#,5
	note B_,5
	fine_tune 12
.loop1:
	snd_call SndCall_BGM_4B_Ch1_3
	snd_loop .loop1, $00, 4
	fine_tune -12
	snd_call SndCall_BGM_4B_Ch1_4
	fine_tune -6
	snd_call SndCall_BGM_4B_Ch1_4
	fine_tune 5
	snd_call SndCall_BGM_4B_Ch1_4
	fine_tune -6
	snd_call SndCall_BGM_4B_Ch1_4
	fine_tune 7
	snd_call SndCall_BGM_4B_Ch1_5
	fine_tune 2
	snd_call SndCall_BGM_4B_Ch1_3
	fine_tune -2
	snd_call SndCall_BGM_4B_Ch1_5
	fine_tune 2
	snd_call SndCall_BGM_4B_Ch1_3
	fine_tune -2
	snd_call SndCall_BGM_4B_Ch1_4
	fine_tune -6
	snd_call SndCall_BGM_4B_Ch1_4
	fine_tune 5
	snd_call SndCall_BGM_4B_Ch1_4
	fine_tune -6
	snd_call SndCall_BGM_4B_Ch1_4
	fine_tune 7
	snd_loop .loop2
SndCall_BGM_4B_Ch1_0:
	note C_,4, 72
	note E_,4, 3
	note F_,4
	note F#,4
	note G_,4
	note G#,4
	note A_,4
	note A#,4
	note B_,4
	note C_,5, 72
	note E_,5, 3
	note F_,5
	note F#,5
	note G_,5
	note G#,5
	note A_,5
	note A#,5
	note B_,5
	note C_,6, 72
	envelope $88
	note C_,6, 6
	silence 3
	envelope $68
	note C_,6
	envelope $48
	note C_,6, 6
	silence 3
	envelope $38
	note C_,6
	envelope $A8
	note C_,6, 6
	note B_,5
	note A#,5
	note A_,5
	note G#,5
	note G_,5
	note F#,5
	note F_,5
	note E_,5
	note D#,5
	note D_,5
	note C#,5
	note C_,5
	note B_,4
	note A#,4
	note A_,4
	snd_ret
SndCall_BGM_4B_Ch1_1:
	note A#,5, 6
	note G_,5
	note G#,5
	note G_,5
	note D_,6
	note G_,5
	note G#,5
	note G_,5
	note A#,5
	note G_,5
	note G#,5
	note G_,5
	note D#,6
	note G_,5
	note G#,5
	note G_,5
	note A#,5
	note G_,5
	note G#,5
	note G_,5
	note F_,6
	note G_,5
	note G#,5
	note G_,5
	note D#,6
	note G_,5
	note D_,6
	note G_,5
	note C_,6
	note G_,5
	snd_ret
SndCall_BGM_4B_Ch1_2:
	envelope $A8
	note C_,4, 6
	silence 3
	envelope $88
	note C_,4
	envelope $A8
	note G_,3, 6
	silence 3
	envelope $88
	note G_,3
	envelope $A8
	note G#,3, 6
	silence 3
	envelope $88
	note G#,3
	envelope $A8
	note D#,4, 6
	silence 3
	envelope $88
	note D#,4
	envelope $A8
	note C_,4, 6
	silence 3
	envelope $88
	note C_,4
	envelope $A8
	note G_,3, 6
	silence 3
	envelope $88
	note G_,3
	envelope $A8
	note B_,3, 6
	silence 3
	envelope $88
	note B_,3
	snd_ret
SndCall_BGM_4B_Ch1_3:
	envelope $A8
	note C_,5, 24
	envelope $88
	note C_,5, 6
	silence 3
	envelope $68
	note C_,5
	envelope $A8
	note C#,5, 36
	envelope $88
	note C#,5, 6
	silence 3
	envelope $68
	note C#,5
	envelope $48
	note C#,5, 6
	silence 3
	envelope $38
	note C#,5
	snd_ret
SndCall_BGM_4B_Ch1_4:
	envelope $A8
	note G#,5, 6
	note G_,5
	note G#,5
	note C#,6, 12
	note G#,5, 6
	note G_,5
	note G#,5
	snd_ret
SndCall_BGM_4B_Ch1_5:
	envelope $A8
	note D_,5, 24
	envelope $88
	note D_,5, 6
	silence 3
	envelope $68
	note D_,5
	envelope $A8
	note D#,5, 12
	silence 3
	envelope $88
	note D#,5
	duty_cycle 0
	envelope $A8
	note A_,5, 6
	note G#,5
	note G_,5
	note F#,5
	note F_,5
	note E_,5
	note D#,5
	duty_cycle 2
	snd_ret
SndData_BGM_4B_Ch2:
	envelope $A8
	panning $22
	duty_cycle 1
	vibrato_on $01
	fine_tune -5
	snd_call SndCall_BGM_4B_Ch1_0
	fine_tune 5
.loop0:
	envelope $62
	duty_cycle 0
	silence 9
	snd_call SndCall_BGM_4B_Ch1_1
	note B_,5
	note G_,5
	snd_call SndCall_BGM_4B_Ch1_1
	note B_,5, 3
	envelope $A8
	duty_cycle 1
	snd_call SndCall_BGM_4B_Ch2_2
	note G_,3
	note C_,3
	note D_,4
	note G_,2
	note D_,4
	note G#,2
	note A#,3
	note D#,3
	note G_,5
	note C_,3
	note E_,5
	note G_,2
	note C#,5
	note B_,2
	note A#,4
	note F_,2
	snd_call SndCall_BGM_4B_Ch2_2
	note G_,4
	note C_,3
	note D_,5
	note G_,2
	note G#,4
	note G#,2
	note D#,5
	note D#,3
	note A_,4
	note C_,3
	note E_,5
	note G_,2
	note A#,4
	note B_,2
	note F_,5
	note F_,2
	envelope $88
	snd_call SndCall_BGM_4B_Ch2_3
	fine_tune 12
	snd_call SndCall_BGM_4B_Ch2_3
	fine_tune -12
	envelope $A8
	snd_call SndCall_BGM_4B_Ch2_4
	fine_tune -6
	snd_call SndCall_BGM_4B_Ch2_4
	fine_tune 5
	snd_call SndCall_BGM_4B_Ch2_4
	fine_tune -6
	snd_call SndCall_BGM_4B_Ch2_4
	fine_tune 7
	fine_tune -10
	snd_call SndCall_BGM_4B_Ch2_3
	fine_tune 10
	snd_call SndCall_BGM_4B_Ch2_4
	fine_tune -6
	snd_call SndCall_BGM_4B_Ch2_4
	fine_tune 5
	snd_call SndCall_BGM_4B_Ch2_4
	fine_tune -6
	snd_call SndCall_BGM_4B_Ch2_4
	fine_tune 7
	snd_loop .loop0
SndCall_BGM_4B_Ch2_2:
	note G_,3, 6
	note C_,3
	note D_,4
	note G_,2
	note D_,4
	note G#,2
	note A#,3
	note D#,3
	note D_,4
	note C_,3
	note D_,4
	note G_,2
	silence
	note B_,2
	note G_,3
	note F_,2
	snd_loop SndCall_BGM_4B_Ch2_2, $00, 3
	snd_ret
SndCall_BGM_4B_Ch2_3:
	note D_,4, 3
	silence
	note G_,4
	silence
	note G_,3
	silence
	note D_,4
	silence
	note G_,4
	silence
	note G_,3
	silence
	note D#,4
	silence
	note G#,4
	silence
	note G#,3
	silence
	note D#,4
	silence
	note G#,4
	silence
	note G#,3
	silence
	note D#,4
	silence
	note G#,4
	silence
	note G#,3
	silence
	note D#,4
	silence
	note D_,4
	silence
	note G_,4
	silence
	note G_,3
	silence
	note D_,4
	silence
	note G_,4
	silence
	note G_,3
	silence
	note D#,4
	silence
	note G#,4
	silence
	note G#,3
	silence
	note D#,4
	silence
	note G#,4
	silence
	note G#,3
	silence
	note A#,4
	silence
	note A_,4
	silence
	note G#,4
	silence
	note G_,4
	silence
	snd_loop SndCall_BGM_4B_Ch2_3, $00, 2
	snd_ret
SndCall_BGM_4B_Ch2_4:
	note D#,5, 3
	silence
	note D#,4
	silence
	note D#,4
	silence
	note D#,5
	silence
	note D#,4
	silence
	note D#,4
	silence
	note D#,5
	silence
	note D#,4
	silence
	snd_ret
SndData_BGM_4B_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	wave_cutoff 0
	snd_call SndCall_BGM_4B_Ch3_0
.loop1:
	snd_call SndCall_BGM_4B_Ch3_1
.loop0:
	snd_call SndCall_BGM_4B_Ch3_2
	snd_loop .loop0, $00, 8
	snd_call SndCall_BGM_4B_Ch3_3
	fine_tune -6
	snd_call SndCall_BGM_4B_Ch3_3
	fine_tune 5
	snd_call SndCall_BGM_4B_Ch3_3
	fine_tune -6
	snd_call SndCall_BGM_4B_Ch3_3
	fine_tune 7
	snd_call SndCall_BGM_4B_Ch3_4
	fine_tune 2
	snd_call SndCall_BGM_4B_Ch3_2
	fine_tune -2
	snd_call SndCall_BGM_4B_Ch3_4
	fine_tune 2
	snd_call SndCall_BGM_4B_Ch3_2
	fine_tune -2
	snd_call SndCall_BGM_4B_Ch3_3
	fine_tune -6
	snd_call SndCall_BGM_4B_Ch3_3
	fine_tune 5
	snd_call SndCall_BGM_4B_Ch3_3
	fine_tune -6
	snd_call SndCall_BGM_4B_Ch3_3
	fine_tune 7
	snd_loop .loop1
SndCall_BGM_4B_Ch3_0:
	note C_,4, 6
	silence
	note G_,3
	silence
	note D#,3
	silence
	note C_,4
	silence
	note G_,3
	silence
	note D#,3
	silence
	note C_,4
	silence
	note D#,3
	silence
	snd_loop SndCall_BGM_4B_Ch3_0, $00, 4
	snd_ret
SndCall_BGM_4B_Ch3_1:
	note C_,4, 6
	silence
	note G_,3
	silence
	note G#,3
	silence
	note D#,4
	silence
	note C_,4
	silence
	note G_,3
	silence
	note B_,3
	silence
	note F_,3
	silence
	snd_loop SndCall_BGM_4B_Ch3_1, $00, 12
	snd_ret
SndCall_BGM_4B_Ch3_2:
	note C_,4, 10
	silence 2
	note C_,4, 4
	silence 2
	note C_,4, 6
	silence
	note C_,4, 10
	silence 2
	note C_,4, 4
	silence 2
	note C_,4, 10
	silence 2
	note C_,4, 4
	silence 2
	note C_,4, 6
	silence
	note A#,3, 10
	silence 2
	note B_,3, 4
	silence 2
	snd_ret
SndCall_BGM_4B_Ch3_3:
	note A#,3, 12
	note G#,3, 6
	note A_,3
	note A#,3
	note G#,3, 12
	note A#,3, 6
	snd_ret
SndCall_BGM_4B_Ch3_4:
	note D_,4, 10
	silence 2
	note D_,4, 4
	silence 2
	note D_,4, 6
	silence
	note D_,4, 10
	silence 2
	note D_,4, 4
	silence 2
	note D_,4, 10
	silence 2
	note D_,4, 4
	silence 2
	note D_,4, 6
	silence
	note A_,3, 10
	silence 2
	note A_,3, 4
	silence 2
	snd_ret
SndData_Unused_00039346:
	panning $88
	chan_stop
