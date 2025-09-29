SndHeader_BGM_19:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_19_Ch1 ; Data ptr
	db 6 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_19_Ch2 ; Data ptr
	db 6 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_19_Ch3 ; Data ptr
	db 6 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_19_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_19_Ch1:
	envelope $11
	panning $11
	duty_cycle 3
	note F#,4, 6
	envelope $75
	note F#,4, 12
	note C#,4, 6
	note E_,4
	note F#,4
	note A_,4
	note F#,4
	silence
	note A_,4
	silence
	note G#,4
	note F#,4, 18
	chan_stop
SndData_BGM_19_Ch2:
	envelope $11
	panning $22
	duty_cycle 3
	note F#,4, 6
	envelope $65
	note C#,4, 12
	note A_,3, 6
	note C#,4
	note C#,4
	note F#,4
	note C#,4
	silence
	note F#,4
	silence
	note E_,4
	note C#,4, 18
	chan_stop
SndData_BGM_19_Ch3:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 40
	note F#,2, 6
	note F#,3, 12
	note F#,3
	note E_,3, 6
	note C#,3
	note A_,2
	silence
	note F#,2, 18
	wave_cutoff 0
	note F#,2, 18
	chan_stop
SndData_BGM_19_Ch4:
	panning $88
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	note4 B_,5,0, 12
	note4 B_,5,0, 6
	envelope $72
	note4 A_,5,0, 3
	note4 A_,5,0
	envelope $72
	note4x $32, 12 ; Nearest: A_,5,0
	envelope $62
	note4 B_,5,0, 18
	note4 B_,5,0, 18
	chan_stop
