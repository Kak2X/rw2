SndHeader_BGM_0C:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_0C_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_0C_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_0C_Ch3 ; Data ptr
	db 12 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_0C_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_0C_Ch1:
	envelope $77
	panning $11
	duty_cycle 3
	note A_,4, 18
	silence 6
	note A_,4, 18
	silence 6
	note A_,4, 18
	envelope $78
	note D_,5, 1
	lock_envelope
	note C#,5
	note C_,5
	note B_,4
	note A#,4
	note A_,4
	note G#,4
	note G_,4
	note F#,4
	note F_,4
	note E_,4
	note D#,4
	note D_,4
	note C#,4
	note C_,4
	note B_,4
	unlock_envelope
	silence 4
	note G#,4, 1
	lock_envelope
	note G_,4
	note F#,4
	note F_,4
	note E_,4
	note D#,4
	note D_,4
	note C#,4
	note C_,4
	note B_,3
	note A#,3
	note A_,3
	note G#,3
	note G_,3
	note F#,3
	note F_,3
	unlock_envelope
	silence 4
	note E_,4, 1
	lock_envelope
	note D#,4
	note D_,4
	note C#,4
	note C_,4
	note B_,3
	note A#,3
	note A_,3
	note G#,3
	note G_,3
	note F#,3
	note F_,3
	note E_,3
	note D#,3
	note D_,3
	note C#,3
	unlock_envelope
	chan_stop
SndData_BGM_0C_Ch2:
	envelope $77
	panning $22
	duty_cycle 3
	note E_,4, 18
	silence 6
	note E_,4, 18
	silence 6
	note E_,4, 18
	silence 6
	envelope $38
	note D_,5, 1
	lock_envelope
	note C#,5
	note C_,5
	note B_,4
	note A#,4
	note A_,4
	note G#,4
	note G_,4
	note F#,4
	note F_,4
	note E_,4
	note D#,4
	note D_,4
	note C#,4
	note C_,4
	note B_,4
	unlock_envelope
	silence 4
	note G#,4, 1
	lock_envelope
	note G_,4
	note F#,4
	note F_,4
	note E_,4
	note D#,4
	note D_,4
	note C#,4
	note C_,4
	note B_,3
	note A#,3
	note A_,3
	note G#,3
	note G_,3
	note F#,3
	note F_,3
	unlock_envelope
	silence 4
	note E_,4, 1
	lock_envelope
	note D#,4
	note D_,4
	note C#,4
	note C_,4
	note B_,3
	note A#,3
	note A_,3
	note G#,3
	note G_,3
	note F#,3
	note F_,3
	note E_,3
	note D#,3
	note D_,3
	note C#,3
	unlock_envelope
	chan_stop
SndData_BGM_0C_Ch3:
	wave_vol $80
	panning $44
	wave_id $03
	note B_,3, 18
	silence 6
	note B_,3, 18
	silence 6
	note B_,3, 12
	chan_stop
SndData_BGM_0C_Ch4:
	panning $88
	envelope $62
	note4 B_,5,0, 24
	note4 B_,5,0, 24
	note4 B_,5,0, 18
	envelope $61
	note4 F_,5,0, 6
	envelope $57
	note4x $10, 24 ; Nearest: B_,6,0
	chan_stop
