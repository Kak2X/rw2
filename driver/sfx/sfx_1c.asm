SndHeader_SFX_1C:
	db $04 ; Number of channels
.ch1:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_SFX_1C_Ch1 ; Data ptr
	db 18 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_1C_Ch2 ; Data ptr
	db 6 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_SFX_1C_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_1C_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_1C_Ch1:
	envelope $F4
	panning $11
	duty_cycle 0
	silence 6
	note A_,4, 1
	note A_,5
	lock_envelope
	note A#,5
	unlock_envelope
	note A_,5, 50
	chan_stop
SndData_SFX_1C_Ch2:
	envelope $F4
	panning $22
	duty_cycle 0
	silence 6
	note A_,4, 1
	note A_,5
	lock_envelope
	note A#,5
	unlock_envelope
	note A_,5, 50
	chan_stop
SndData_SFX_1C_Ch3:
	chan_stop
