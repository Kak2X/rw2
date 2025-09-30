SndHeader_SFX_1A:
	db $03 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_1A_Ch2 ; Data ptr
	db 12 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_SFX_1A_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_1A_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_1A_Ch2:
	envelope $B8
	panning $22
	duty_cycle 2
	note C_,3, 1
	note C#,3
	note D_,3
	note D#,3
	note E_,3
	note F_,3
	note F#,3
	note G_,3
	note G#,3
	note A_,3
	note A#,3
	note B_,3
	note C_,4
	note C#,4
	note D_,4
	note D#,4
	note E_,4
	note F_,4
	note F#,4
	note G_,4
	note G#,4
	note A_,4
	note A#,4
	note B_,4
	chan_stop
SndData_SFX_1A_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	chan_stop
SndData_SFX_1A_Ch4:
	envelope $F8
	panning $88
	note4 G#,4,0, 2
	lock_envelope
	note4 A_,4,0, 2
	note4 A#,4,0, 2
	note4 B_,4,0, 2
	note4x $53, 2 ; Nearest: G#,4,0
	note4x $52, 2 ; Nearest: A_,4,0
	note4x $51, 2 ; Nearest: A#,4,0
	note4x $50, 2 ; Nearest: B_,4,0
	note4 E_,5,0, 2
	note4 F_,5,0, 2
	note4 F#,5,0, 2
	note4 G_,5,0, 2
	note4x $33, 2 ; Nearest: G#,5,0
	note4x $32, 2 ; Nearest: A_,5,0
	note4x $31, 2 ; Nearest: A#,5,0
	unlock_envelope
	envelope $F3
	note4x $30, 50 ; Nearest: B_,5,0
	chan_stop
