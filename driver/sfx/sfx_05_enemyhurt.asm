SndHeader_SFX_05_EnemyHurt:
	db $04 ; Number of channels
.ch1:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_SFX_05_EnemyHurt_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $56 ; Initial vibrato ID
.ch2:
	db SIS_SFX ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_05_EnemyHurt_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $56 ; Initial vibrato ID
.ch3:
	db SIS_SFX ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_SFX_05_EnemyHurt_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $56 ; Initial vibrato ID
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_05_EnemyHurt_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $56 ; Initial vibrato ID
SndData_SFX_05_EnemyHurt_Ch1:
	panning $11
.P00:
	envelope $00
	note D_,2, 16
	envelope $F0
	duty_cycle 1
	sweep $1B
	note D_,6, 5
	chan_stop
SndData_SFX_05_EnemyHurt_Ch2:
	chan_stop
SndData_SFX_05_EnemyHurt_Ch3:
	chan_stop
SndData_SFX_05_EnemyHurt_Ch4:
	panning $88
.P00:
	envelope $56
	note4 E_,6,0, 4
	note4 D#,5,0, 60
	chan_stop
