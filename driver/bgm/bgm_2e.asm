SndHeader_BGM_2E:
	db $02 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_2E_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_2E_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.unused_ch3:
	db 0 ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_2E_Ch3_Unused ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_2E_Ch1:
	envelope $27
	panning $11
	duty_cycle 3
	note E_,5, 4
	note G#,5
	note C#,5
	note E_,5
	note A_,4
	note C#,5
	envelope $47
	note G#,4
	note C#,5
	note A_,4
	note F#,4
	note E_,4
	note A_,4
	envelope $77
	note E_,5
	note G#,5
	note C#,5
	note E_,5
	note A_,4
	note C#,5
	note G#,4
	note C#,5
	note A_,4
	note F#,4
	note E_,4
	note A_,4
	silence 15
	envelope $68
	note A_,4, 20
	envelope $58
	note A_,4, 10
	envelope $48
	note A_,4
	envelope $38
	note A_,4
	envelope $28
	note A_,4
	envelope $18
	note A_,4
	chan_stop
SndData_BGM_2E_Ch2:
	envelope $17
	panning $22
	duty_cycle 3
	silence 6
	note E_,5, 4
	note G#,5
	note C#,5
	note E_,5
	note A_,4
	envelope $27
	note C#,5
	note G#,4
	note C#,5
	note A_,4
	note F#,4
	note E_,4
	envelope $47
	note A_,4
	note E_,5
	note G#,5
	note A_,4
	note E_,5
	note A_,4
	note C#,5
	note G#,4
	note C#,5
	note A_,4
	note F#,4
	note E_,4, 2
	envelope $77
	silence 12
	envelope $68
	note F#,4, 20
	envelope $58
	note F#,4, 10
	envelope $48
	note F#,4
	envelope $38
	note F#,4
	envelope $28
	note F#,4
	envelope $18
	note F#,4
	chan_stop
SndData_BGM_2E_Ch3_Unused:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 0
	chan_stop
