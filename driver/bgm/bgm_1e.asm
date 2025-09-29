SndHeader_BGM_1E:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_1E_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_1E_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_1E_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_1E_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_1E_Ch1:
	envelope $11
	panning $11
	duty_cycle 3
	note G_,5, 6
	envelope $77
	note G_,5, 12
	note F#,5, 24
	continue 6
	duty_cycle 2
	note C_,5, 6
	note F#,5, 12
	note F_,5, 24
	continue 6
	note C_,4, 6
	note F_,4, 18
	duty_cycle 3
	note A_,5, 36
	continue 6
	note E_,5, 12
	note D_,5, 6
	note C_,5
	note G_,4
	note A_,4
	note A_,4, 18
	chan_stop
SndData_BGM_1E_Ch2:
	envelope $11
	panning $22
	duty_cycle 3
	note C_,5, 6
	envelope $67
	note C_,5, 12
	note C_,5, 24
	continue 6
	duty_cycle 2
	note A_,4, 6
	note C_,5, 12
	note C_,5, 24
	continue 6
	note A_,3, 6
	note C_,4, 18
	duty_cycle 3
	note F_,5, 36
	continue 6
	note C_,5, 12
	note G_,4, 6
	note G_,4
	note E_,4
	note E_,4
	note E_,4, 18
	chan_stop
SndData_BGM_1E_Ch3:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 50
	note A_,2, 6
	note A_,3
	note A_,2
	wave_cutoff 0
	note A_,2, 72
	continue 6
	continue 24
	wave_cutoff 50
	note A_,2
	note A_,2
	note A_,2
	note A_,2, 6
	note A_,3, 18
	chan_stop
SndData_BGM_1E_Ch4:
	panning $88
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $61
	note4 F_,5,0, 18
	envelope $54
	note4x $22, 4 ; Nearest: A_,5,0
	note4x $22, 4 ; Nearest: A_,5,0
	note4x $22, 4 ; Nearest: A_,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $54
	note4x $22, 12 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 6
	envelope $54
	note4x $22, 4 ; Nearest: A_,5,0
	note4x $22, 4 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 4
	note4 A_,5,0, 4
	envelope $72
	note4x $32, 4 ; Nearest: A_,5,0
	note4x $32, 4 ; Nearest: A_,5,0
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 18
	envelope $61
	note4 F_,5,0, 6
	envelope $72
	note4 A_,5,0, 12
	envelope $72
	note4x $32, 6 ; Nearest: A_,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $72
	note4 A_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 18
	chan_stop
