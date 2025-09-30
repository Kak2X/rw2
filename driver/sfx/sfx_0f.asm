SndHeader_SFX_0F:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_0F_Ch2 ; Data ptr
	db 20 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_0F_Ch2:
	envelope $D8
	panning $22
	duty_cycle 3
	note C_,5, 1
	note C_,4
	note C_,4
	note C_,3
	note F_,4
	note F_,3
	note G_,4
	note G_,3
	envelope $A8
	note C_,5
	note C_,4
	note C_,4
	note C_,3
	note F_,4
	note F_,3
	note G_,4
	note G_,3
	envelope $68
	note C_,5
	note C_,4
	note C_,4
	note C_,3
	note F_,4
	note F_,3
	note G_,4
	note G_,3
	envelope $48
	note C_,5
	note C_,4
	note C_,4
	note C_,3
	note F_,4
	note F_,3
	note G_,4
	note G_,3
	envelope $28
	note C_,5
	note C_,4
	note C_,4
	note C_,3
	note F_,4
	note F_,3
	note G_,4
	note G_,3
	chan_stop
