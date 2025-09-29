SndHeader_BGM_1F:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_1F_Ch1 ; Data ptr
	db 12 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_1F_Ch2 ; Data ptr
	db 12 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_1F_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_1F_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_1F_Ch1:
	envelope $75
	panning $11
	duty_cycle 3
	note A_,4, 7
	note A_,4
	note A_,4
	note A_,4
	silence
	note A_,4
	silence
	note A_,4
	silence
	envelope $78
	note A_,4, 21
	note G#,4, 1
	note G_,4
	note F#,4
	note F_,4
	note E_,4
	note D#,4
	note D_,4
	note C#,4
	note C_,4
	chan_stop
SndData_BGM_1F_Ch2:
	envelope $65
	panning $22
	duty_cycle 3
	note D_,4, 7
	note D_,4
	note D_,4
	note D_,4
	silence
	note D_,4
	silence
	note D_,4
	silence
	envelope $68
	note D_,4, 21
	note C#,4, 1
	note C_,4
	note B_,3
	note A#,3
	note A_,3
	note G#,3
	note G_,3
	note F#,3
	note F_,3
	chan_stop
SndData_BGM_1F_Ch3:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 20
	note E_,3, 7
	note E_,3
	note E_,3
	note E_,3
	silence
	note E_,3
	silence
	note E_,3
	silence
	wave_cutoff 0
	note E_,3, 28
	chan_stop
SndData_BGM_1F_Ch4:
	panning $88
	envelope $62
	note4 B_,5,0, 7
	note4 B_,5,0, 7
	envelope $61
	note4 F_,5,0, 7
	envelope $72
	note4 A_,5,0, 14
	envelope $72
	note4x $32, 14 ; Nearest: A_,5,0
	envelope $61
	note4 F_,5,0, 14
	envelope $62
	note4 B_,5,0, 28
	chan_stop
