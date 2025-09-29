SndHeader_BGM_20:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_20_Ch1 ; Data ptr
	db 4 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_20_Ch2 ; Data ptr
	db 4 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_20_Ch3 ; Data ptr
	db 4 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_20_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_20_Ch1:
	envelope $11
	panning $11
	duty_cycle 3
	note C_,4, 5
	envelope $77
	note C_,4
	note E_,4
	note B_,4
	note C_,5, 2
	note D_,5, 3
	note E_,5, 2
	note G_,5, 3
	note B_,5, 5
	envelope $57
	note C_,5, 2
	note D_,5, 3
	note E_,5, 2
	note G_,5, 3
	note B_,5, 5
	envelope $47
	note C_,5, 2
	note D_,5, 3
	note E_,5, 2
	note G_,5, 3
	note B_,5, 5
	chan_stop
SndData_BGM_20_Ch2:
	envelope $11
	panning $22
	duty_cycle 2
	note E_,3, 5
	envelope $57
	note E_,3
	note G_,3
	note C_,4
	note E_,4
	note G_,4, 10
	note B_,4, 5
	silence
	note G_,4, 10
	note B_,4, 5
	chan_stop
SndData_BGM_20_Ch3:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 40
	note C_,3, 5
	note B_,3, 10
	note C_,4, 5
	note G_,4
	note B_,4
	note C_,5
	note E_,5
	silence
	wave_cutoff 90
	note E_,5, 15
	chan_stop
SndData_BGM_20_Ch4:
	panning $88
	envelope $61
	note4 F_,5,0, 5
	envelope $54
	note4x $22, 2 ; Nearest: A_,5,0
	note4x $22, 8 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 5
	envelope $72
	note4x $32, 5 ; Nearest: A_,5,0
	note4x $32, 5 ; Nearest: A_,5,0
	envelope $61
	note4 F_,5,0, 5
	envelope $62
	note4 B_,5,0, 5
	chan_stop
