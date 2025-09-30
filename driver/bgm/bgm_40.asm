SndHeader_BGM_40:
	db $03 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_40_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_40_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_40_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_Unused_00035330 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_BGM_40_Ch1:
	envelope $A8
	panning $11
	duty_cycle 2
	vibrato_on $01
	note D_,4, 14
	note E_,4
	note F_,4
	note D_,4, 42
	envelope $88
	note D_,4, 7
	silence 3
	envelope $68
	note D_,4, 4
	envelope $48
	note D_,4, 7
	silence 3
	envelope $38
	note D_,4, 4
	silence 14
	envelope $A8
	note C_,4, 42
	note A#,3
	note A_,3, 14
	note F_,3
	note A_,3
	note A#,3, 56
	continue 14
	envelope $88
	note A#,3, 7
	silence 3
	envelope $68
	note A#,3, 4
	silence 7
	envelope $48
	note A#,3, 7
	silence 4
	envelope $38
	note A#,3, 7
	silence 17
	envelope $A8
	note G_,4, 7
	note F_,4
	note E_,4
	note C_,4
	note A_,3
	note F_,3
	note D_,3, 28
	chan_stop
SndData_BGM_40_Ch2:
	envelope $88
	panning $22
	duty_cycle 1
	vibrato_on $01
	envelope $88
	note F_,4, 7
	silence 3
	envelope $68
	note F_,4, 4
	envelope $88
	note G_,4, 7
	silence 3
	envelope $68
	note G_,4, 4
	envelope $88
	note A_,4, 7
	silence 3
	envelope $68
	note A_,4, 4
	envelope $88
	note F_,4, 28
	envelope $68
	note F_,4, 7
	silence 3
	envelope $48
	note F_,4, 4
	envelope $88
	note G_,5, 7
	note F_,5
	note E_,5
	note D_,5
	note C_,5
	note A#,4
	note A_,4, 28
	envelope $68
	note A_,4, 7
	silence 3
	envelope $48
	note A_,4, 4
	envelope $88
	note G_,4, 28
	envelope $68
	note G_,4, 7
	silence 3
	envelope $48
	note G_,4, 4
	envelope $88
	note F_,4, 7
	silence 3
	envelope $68
	note F_,4, 4
	envelope $88
	note D_,4, 7
	silence 3
	envelope $68
	note D_,4, 4
	envelope $88
	note F_,4, 7
	silence 3
	envelope $68
	note F_,4, 4
	envelope $88
	note G_,4, 56
	continue 14
	silence 3
	envelope $68
	note G_,4, 7
	silence 4
	envelope $48
	note G_,4, 7
	silence 3
	envelope $38
	note G_,4, 7
	silence 25
	envelope $88
	note A#,4, 7
	note A_,4
	note G_,4
	note A_,4
	note E_,4
	note C_,4
	note A_,3, 28
	chan_stop
SndData_BGM_40_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	wave_cutoff 0
	vibrato_on $01
	note D_,3, 112
	continue 14
	note G_,3, 42
	note F_,3
	note D_,3
	note D#,3, 84
	silence 42
	note C_,5, 7
	note A_,4
	note G_,4
	note E_,4
	note C_,4
	note A_,3
	note D_,3, 28
	chan_stop
SndData_Unused_00035330:
	panning $88
	chan_stop
