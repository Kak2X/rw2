SndHeader_SFX_17:
	db $04 ; Number of channels
.ch1:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_SFX_17_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_17_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_SFX_17_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_17_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_17_Ch1:
	envelope $A8
	panning $11
	duty_cycle 3
	vibrato_on $01
	note G_,2, 28
	note C#,4
	note C_,4
	note D#,4, 112
	chan_stop
SndData_SFX_17_Ch2:
	envelope $A8
	panning $22
	duty_cycle 3
	vibrato_on $01
	note C_,2, 28
	note G_,3
	note F#,3
	note A_,3, 112
	chan_stop
SndData_SFX_17_Ch3:
	wave_vol $C0
	panning $44
	vibrato_on $01
	note C_,4, 84
	continue 112
	chan_stop
SndData_SFX_17_Ch4:
	panning $88
	note4x $80, 28 ; Nearest: B_,3,0
	note4x $80 ; Nearest: B_,3,0
	note4x $80 ; Nearest: B_,3,0
	note4x $80, 112 ; Nearest: B_,3,0
	chan_stop
