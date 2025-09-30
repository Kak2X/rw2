SndHeader_BGM_06:
	db $03 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_06_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_06_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_06_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_Unused_0003D053 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_BGM_06_Ch1:
	envelope $C8
	panning $11
	duty_cycle 3
SndCall_BGM_06_Ch2_0:
	snd_call SndCall_BGM_06_Ch1_0
	envelope $88
	snd_call SndCall_BGM_06_Ch1_2
	envelope $78
	snd_call SndCall_BGM_06_Ch1_2
	envelope $68
	snd_call SndCall_BGM_06_Ch1_2
	envelope $58
	snd_call SndCall_BGM_06_Ch1_2
	envelope $48
	snd_call SndCall_BGM_06_Ch1_2
	envelope $38
	snd_call SndCall_BGM_06_Ch1_2
	envelope $28
	snd_call SndCall_BGM_06_Ch1_2
	chan_stop
SndCall_BGM_06_Ch1_0:
	snd_call SndCall_BGM_06_Ch1_1
	fine_tune 3
	snd_call SndCall_BGM_06_Ch1_1
	fine_tune 3
	snd_call SndCall_BGM_06_Ch1_1
	fine_tune 3
	snd_call SndCall_BGM_06_Ch1_1
	fine_tune 3
	snd_call SndCall_BGM_06_Ch1_1
	fine_tune 3
	snd_call SndCall_BGM_06_Ch1_1
	fine_tune 3
	snd_call SndCall_BGM_06_Ch1_1
	fine_tune 3
	snd_call SndCall_BGM_06_Ch1_1
	fine_tune 3
	snd_call SndCall_BGM_06_Ch1_1
	fine_tune 3
	snd_call SndCall_BGM_06_Ch1_1
	fine_tune 3
	snd_call SndCall_BGM_06_Ch1_1
	fine_tune 3
	snd_call SndCall_BGM_06_Ch1_1
	fine_tune 3
	snd_call SndCall_BGM_06_Ch1_1
	fine_tune 3
	snd_call SndCall_BGM_06_Ch1_1
	fine_tune 3
	snd_call SndCall_BGM_06_Ch1_1
	fine_tune 3
	snd_call SndCall_BGM_06_Ch1_1
	snd_ret
SndCall_BGM_06_Ch1_1:
	note C_,2, 3
	note D#,2
	note F#,2
	note A_,2
	snd_ret
SndCall_BGM_06_Ch1_2:
	note C_,2, 3
	note D#,2
	note F#,2
	note A_,2
	snd_ret
SndData_BGM_06_Ch2:
	envelope $98
	panning $22
	duty_cycle 3
	silence 8
	snd_call SndCall_BGM_06_Ch2_0
	chan_stop
SndData_BGM_06_Ch3:
	wave_vol $80
	panning $44
	wave_id $02
	wave_cutoff 0
	snd_call SndCall_BGM_06_Ch1_0
	chan_stop
SndData_Unused_0003D053:
	panning $88
	chan_stop
