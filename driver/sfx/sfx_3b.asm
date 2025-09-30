SndHeader_SFX_3B:
	db $03 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_3B_Ch2 ; Data ptr
	db 12 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_SFX_3B_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_3B_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_3B_Ch2:
	envelope $F8
	panning $22
	duty_cycle 2
	note D_,3, 6
	note G_,3
	note C_,4
	envelope $C8
	note D_,3
	note G_,3
	note C_,4
	envelope $98
	note D_,3
	note G_,3
	note C_,4
	envelope $68
	note D_,3
	note G_,3
	note C_,4
	envelope $38
	note D_,3
	note G_,3
	note C_,4
	chan_stop
SndData_SFX_3B_Ch3:
	wave_vol $C0
	panning $44
	chan_stop
SndData_SFX_3B_Ch4:
	envelope $F2
	panning $88
	snd_call SndCall_SFX_3B_Ch4_0
	snd_call SndCall_SFX_3B_Ch4_1
	note4x $80, 15 ; Nearest: B_,3,0
	snd_call SndCall_SFX_3B_Ch4_0
	snd_call SndCall_SFX_3B_Ch4_0
	snd_call SndCall_SFX_3B_Ch4_1
	note4x $80, 5 ; Nearest: B_,3,0
	snd_call SndCall_SFX_3B_Ch4_0
	chan_stop
SndCall_SFX_3B_Ch4_0:
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
	snd_ret
SndCall_SFX_3B_Ch4_1:
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
	snd_ret
