SndHeader_SFX_16:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_16_Ch2 ; Data ptr
	db 12 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_16_Ch2:
	envelope $F5
	panning $22
	duty_cycle 2
	note B_,3, 4
	note E_,4
	note A_,4, 7
	envelope $85
	note B_,3, 4
	note E_,4
	note A_,4, 7
	envelope $45
	note B_,3, 4
	note E_,4
	note A_,4, 7
	envelope $25
	note B_,3, 4
	note E_,4
	note A_,4, 7
	chan_stop
