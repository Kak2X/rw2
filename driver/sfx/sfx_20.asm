SndHeader_SFX_20:
	db $03 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_20_Ch2 ; Data ptr
	db 12 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_SFX_20_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_20_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_20_Ch2:
	envelope $A8
	panning $22
	duty_cycle 3
	note C_,4, 2
	note B_,3
	note A#,3
	note A_,3
	note G#,3
	note G_,3
	note F#,3
	note F_,3
	note E_,3
	note D#,3
	note D_,3
	note C#,3
	note C_,3
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
SndData_SFX_20_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	chan_stop
SndData_SFX_20_Ch4:
	envelope $F8
	panning $88
	note4 G#,4,0, 6
	lock_envelope
	note4 A_,4,0, 6
	note4 A#,4,0, 6
	note4 B_,4,0, 6
	note4x $53, 6 ; Nearest: G#,4,0
	note4x $52, 6 ; Nearest: A_,4,0
	note4x $51, 6 ; Nearest: A#,4,0
	unlock_envelope
	envelope $F3
	note4x $50, 40 ; Nearest: B_,4,0
	chan_stop
