SndHeader_SFX_39:
	db $04 ; Number of channels
.ch1:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_SFX_39_Ch1 ; Data ptr
	db -12 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_39_Ch2 ; Data ptr
	db -12 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_SFX_39_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_39_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_39_Ch1:
	envelope $F1
	panning $11
	duty_cycle 3
SndCall_SFX_39_Ch2_0:
	silence 30
	note C_,4, 1
	note E_,4
	note G_,4
	note D_,4
	note F_,4
	note A_,4
	note E_,4
	note G_,4
	note B_,4
	note F_,4
	note A_,4
	note C_,5
	note G_,4
	note B_,4
	note D_,5
	note A_,4
	note C_,5
	note E_,5
	note B_,4
	note D_,5
	note F_,5
	note C_,5
	note E_,5
	note G_,5
	note D_,5
	note F_,5
	note A_,5
	note E_,5
	note G_,5
	note B_,5
	note F_,5
	note A_,5
	note C_,6
	note G_,5
	note B_,5
	note D_,6
	note A_,5
	note C_,6
	note E_,6
	note B_,5
	note D_,6
	note F_,6
	note C_,6
	note E_,6
	note G_,6
	note D_,6
	note F_,6
	note A_,6
	note E_,6
	note G_,6
	note B_,6
	note F_,6
	note A_,6
	note C_,7
	note G_,6
	note B_,6
	note D_,7
	note A_,6
	note C_,7
	note E_,7
	note B_,6
	note D_,7
	note F_,7
	note C_,7
	note E_,7
	note G_,7
	note D_,7
	note F_,7
	note A_,7
	note E_,7
	note G_,7
	note B_,7
	chan_stop
SndData_SFX_39_Ch2:
	envelope $D1
	panning $22
	duty_cycle 3
	snd_call SndCall_SFX_39_Ch2_0
	chan_stop
SndData_SFX_39_Ch3:
	wave_vol $C0
	panning $44
	chan_stop
SndData_SFX_39_Ch4:
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
	note4x $30, 8 ; Nearest: B_,5,0
	note4x $31, 8 ; Nearest: A#,5,0
	note4x $32, 8 ; Nearest: A_,5,0
	note4x $33, 8 ; Nearest: G#,5,0
	note4 G_,5,0, 8
	note4 F#,5,0, 8
	note4 F_,5,0, 8
	note4 E_,5,0, 8
	note4 F_,5,0, 8
	note4 F#,5,0, 8
	note4 G_,5,0, 8
	note4x $33, 8 ; Nearest: G#,5,0
	note4x $32, 8 ; Nearest: A_,5,0
	note4x $31, 8 ; Nearest: A#,5,0
	note4x $30, 8 ; Nearest: B_,5,0
	unlock_envelope
	chan_stop
