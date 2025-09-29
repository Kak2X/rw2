SndHeader_SFX_17:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_17_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_17_Ch2:
	envelope $F5
	panning $22
	duty_cycle 0
	note G_,3, 3
	note A_,3
	note C_,4
	note D_,4
	note C_,4
	note D_,4
	note G_,4
	note A_,4
	note G_,4
	note A_,4
	note C_,5
	note D_,5
	envelope $85
	note G_,4
	note A_,4
	note C_,5
	note D_,5
	envelope $45
	note G_,4
	note A_,4
	note C_,5
	note D_,5
	envelope $25
	note G_,4
	note A_,4
	note C_,5
	note D_,5
	chan_stop
