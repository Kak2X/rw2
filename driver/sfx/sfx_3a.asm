SndHeader_SFX_3A:
	db $02 ; Number of channels
.ch1:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_SFX_3A_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_3A_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_3A_Ch1:
	chan_stop
