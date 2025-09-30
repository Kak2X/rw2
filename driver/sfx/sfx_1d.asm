SndHeader_SFX_1D:
	db $04 ; Number of channels
.ch1:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_SFX_1D_Ch1 ; Data ptr
	db 12 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_1D_Ch2 ; Data ptr
	db 12 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_SFX_1D_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_1D_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_1D_Ch1:
	envelope $F8
	panning $11
	duty_cycle 3
	snd_call SndCall_SFX_1D_Ch1_0
	chan_stop
SndData_SFX_1D_Ch2:
	envelope $A8
	panning $22
	duty_cycle 3
	silence 8
	snd_call SndCall_SFX_1D_Ch1_0
	chan_stop
SndData_SFX_1D_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	chan_stop
SndData_SFX_1D_Ch4:
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
	note4x $30, 20 ; Nearest: B_,5,0
	envelope $F2
	panning $88
	note4x $40, 1 ; Nearest: B_,5,0
	lock_envelope
	note4x $41, 1 ; Nearest: A#,5,0
	note4x $42, 1 ; Nearest: A_,5,0
	note4x $43, 1 ; Nearest: G#,5,0
	note4 D#,5,0, 1
	note4 D_,5,0, 1
	note4 C#,5,0, 1
	note4 C_,5,0, 1
	unlock_envelope
	note4 F#,5,0, 1
	lock_envelope
	note4 G_,5,0, 1
	note4x $33, 1 ; Nearest: G#,5,0
	note4x $32, 1 ; Nearest: A_,5,0
	note4x $31, 1 ; Nearest: A#,5,0
	note4x $30 ; Nearest: B_,5,0
	unlock_envelope
	envelope $62
	note4x $40, 1 ; Nearest: B_,5,0
	lock_envelope
	note4x $41, 1 ; Nearest: A#,5,0
	note4x $42, 1 ; Nearest: A_,5,0
	note4x $43, 1 ; Nearest: G#,5,0
	note4 D#,5,0, 1
	note4 D_,5,0, 1
	note4 C#,5,0, 1
	note4 C_,5,0, 1
	unlock_envelope
	note4 F#,5,0, 1
	lock_envelope
	note4 G_,5,0, 1
	note4x $33, 1 ; Nearest: G#,5,0
	note4x $32, 1 ; Nearest: A_,5,0
	note4x $31, 1 ; Nearest: A#,5,0
	note4x $30 ; Nearest: B_,5,0
	unlock_envelope
	chan_stop
SndCall_SFX_1D_Ch1_0:
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
	note C_,5
	note C#,5
	note D_,5
	note D#,5
	note E_,5
	note F_,5
	note F#,5
	note G_,5
	note G#,5
	note A_,5
	note A#,5
	note B_,5
	snd_ret
