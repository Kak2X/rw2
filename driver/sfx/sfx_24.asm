SndHeader_SFX_24:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_24_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_24_Ch4:
	envelope $F8
	panning $88
	note4x $61, 2 ; Nearest: A#,4,0
	note4 B_,4,0, 1
	note4 D#,5,0, 1
	note4 E_,5,0, 1
	envelope $A3
	note4x $42, 40 ; Nearest: A_,5,0
	chan_stop
