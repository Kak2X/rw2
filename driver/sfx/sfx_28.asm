SndHeader_SFX_28:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_28_Ch2 ; Data ptr
	db 12 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_28_Ch2:
	envelope $D1
	panning $22
	duty_cycle 2
	note C_,4, 1
	note E_,4
	note G_,4
	note D_,4
	note F_,4
	note A_,4
	note E_,4
	note G_,4
	note B_,4
	note F_,4
	note A_,4
	note C_,5
	note G_,4
	note B_,4
	note D_,5
	note A_,4
	note C_,5
	note E_,5
	note B_,4
	note D_,5
	note F_,5
	note C_,5
	note E_,5
	note G_,5
	note D_,5
	note F_,5
	note A_,5
	note E_,5
	note G_,5
	note B_,5
	note F_,5
	note A_,5
	note C_,6
	chan_stop
