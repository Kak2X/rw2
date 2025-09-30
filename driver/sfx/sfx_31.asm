SndHeader_SFX_31:
	db $02 ; Number of channels
.ch1:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_SFX_31_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_31_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_31_Ch1:
	envelope $C2
	panning $11
	duty_cycle 0
	note C_,7, 8
	note D_,7
	note E_,7
	note G_,7
	snd_loop SndData_SFX_31_Ch1, $00, 60
	chan_stop
SndData_SFX_31_Ch2:
	envelope $A2
	panning $22
	duty_cycle 0
	vibrato_on $08
	silence 12
.loop0:
	note C_,7, 8
	note D_,7
	note E_,7
	note G_,7
	snd_loop .loop0, $00, 60
	chan_stop
