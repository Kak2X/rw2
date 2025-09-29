SndHeader_SFX_13:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_13_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_13_Ch2:
	envelope $C1
	panning $22
	duty_cycle 2
SndData_SFX_13_Ch2_0:
	note D_,5, 4
	snd_loop SndData_SFX_13_Ch2_0
