SndHeader_BGM_0D:
	db $04 ; Number of channels
.ch1:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_0D_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_0D_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_0D_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_0D_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_0D_Ch1:
	envelope $11
	panning $11
	duty_cycle 3
	note C_,2, 1
	chan_stop
SndData_BGM_0D_Ch2:
	envelope $11
	panning $22
	duty_cycle 3
	note C_,2, 1
	chan_stop
SndData_BGM_0D_Ch3:
	wave_vol $00
	panning $44
	wave_id $03
	note C_,2, 1
	chan_stop
SndData_BGM_0D_Ch4:
	envelope $11
	panning $88
	note4 A#,6,0, 1
	chan_stop
