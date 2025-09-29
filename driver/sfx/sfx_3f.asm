SndHeader_SFX_3F:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_3F_Ch2 ; Data ptr
	db 16 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_3F_Ch2:
	envelope $F2
	panning $22
	duty_cycle 2
	note E_,5, 4
	note C_,5, 2
	note A_,4
	envelope $82
	note E_,5, 4
	note C_,5, 2
	note A_,4
	envelope $42
	note E_,5, 4
	note C_,5, 2
	note A_,4
	envelope $22
	note E_,5, 4
	note C_,5, 2
	note A_,4
	chan_stop
