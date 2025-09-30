SndHeader_SFX_1B:
	db $03 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_1B_Ch2 ; Data ptr
	db 6 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_SFX_1B_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_1B_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_1B_Ch2:
	envelope $F8
	panning $22
	duty_cycle 3
	note C_,3, 1
	note B_,2
	note A#,2
	note A_,2
	note G#,2
	note G_,2
	note F#,2
	note F_,2
	note E_,2
	note D#,2
	note D_,2
	note C#,2
	note C_,2
	chan_stop
SndData_SFX_1B_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	chan_stop
SndData_SFX_1B_Ch4:
	envelope $B2
	panning $88
	note4 F#,5,0, 1
	lock_envelope
	note4 G_,5,0, 1
	note4x $33, 1 ; Nearest: G#,5,0
	note4x $32, 1 ; Nearest: A_,5,0
	note4x $31, 1 ; Nearest: A#,5,0
	note4x $30, 1 ; Nearest: B_,5,0
	note4x $20, 1 ; Nearest: B_,5,0
	note4x $21, 1 ; Nearest: A#,5,0
	note4x $22, 1 ; Nearest: A_,5,0
	note4x $23, 1 ; Nearest: G#,5,0
	note4 B_,5,0, 1
	note4 A#,5,0, 1
	note4 A_,5,0, 1
	note4 G#,5,0, 1
	chan_stop
