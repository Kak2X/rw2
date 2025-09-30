SndHeader_SFX_1E:
	db $04 ; Number of channels
.ch1:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_SFX_1E_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_1E_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_SFX_1E_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_1E_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_1E_Ch1:
	envelope $F7
	panning $11
	duty_cycle 2
	note C_,2, 5
	silence 1
	note C_,3, 6
	vibrato_on $08
	note C_,5, 120
	continue 120
	chan_stop
SndData_SFX_1E_Ch2:
	envelope $F7
	panning $22
	duty_cycle 2
	note G_,2, 5
	silence 1
	note G_,3, 6
	vibrato_on $08
	note G_,4, 120
	continue 120
	chan_stop
SndData_SFX_1E_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	chan_stop
SndData_SFX_1E_Ch4:
	envelope $F8
	panning $88
	note4x $71, 5 ; Nearest: A#,4,0
	note4 B_,6,0, 1
	note4 F#,5,0, 6
	chan_stop
