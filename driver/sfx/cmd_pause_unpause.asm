SndHeader_Pause:
	db $01 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_Pause_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndHeader_Unpause:
	db $01 ; Number of channels
.ch1:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_Unpause_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_Pause_Ch1:
	envelope $B1
	panning $11
	duty_cycle 2
	note C_,5, 5
	note E_,5
	note G_,5, 20
	continue 100
	continue 100
	continue 100
	continue 100
	chan_stop
SndData_Unpause_Ch1:
	chan_stop
