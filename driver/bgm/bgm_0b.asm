SndHeader_BGM_0B:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_0B_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_0B_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db 0 ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_0B_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_0B_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_0B_Ch1:
	envelope $77
	panning $11
	duty_cycle 3
	note C_,5, 14
	note A_,4, 7
	note C_,5
	silence
	note E_,5
	note G_,5
	note A_,5
	note E_,5
	note D_,5
	note C_,5
	note G_,5
	note F_,5
	note B_,5
	note D_,6
	note C_,6
	silence
	note G_,5, 21
	note A_,5, 28
	chan_stop
SndData_BGM_0B_Ch2:
	envelope $67
	panning $22
	duty_cycle 3
	note A_,3, 21
	note A_,3, 7
	envelope $11
	note A_,3, 28
	envelope $52
	note C_,5, 5
	note D_,5, 4
	note C_,5, 5
	note B_,4
	note C_,5, 4
	note C#,5, 5
	note D_,5
	note A_,5, 4
	note G#,5, 5
	note G_,5
	note A_,5, 4
	note E_,5, 5
	envelope $67
	silence 7
	note A_,3, 21
	note A_,3, 28
	chan_stop
SndData_BGM_0B_Ch3:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 80
	chan_stop
SndData_BGM_0B_Ch4:
	panning $88
	envelope $62
	note4 B_,5,0, 14
	envelope $61
	note4 F_,5,0, 7
	envelope $62
	note4 B_,5,0, 14
	envelope $54
	note4x $22, 7 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 7
	envelope $72
	note4x $32, 7 ; Nearest: A_,5,0
	envelope $62
	note4 B_,5,0, 5
	envelope $42
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	note4 B_,5,0, 5
	envelope $62
	note4 B_,5,0, 4
	envelope $42
	note4 B_,5,0, 5
	note4 B_,5,0, 5
	note4 B_,5,0, 4
	note4 B_,5,0, 5
	note4 B_,5,0, 5
	envelope $62
	note4 B_,5,0, 4
	envelope $42
	note4 B_,5,0, 5
	envelope $62
	note4 B_,5,0, 2
	note4 B_,5,0, 5
	envelope $61
	note4 F_,5,0, 21
	note4 F_,5,0, 28
	chan_stop
