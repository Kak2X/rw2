SndHeader_BGM_4A:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_4A_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_4A_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_4A_Ch3 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_4A_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_BGM_4A_Ch1:
	envelope $A8
	panning $11
	duty_cycle 2
	vibrato_on $01
	envelope $88
	note A_,4, 2
	envelope $A8
	note A#,4, 8
	envelope $A8
	note C_,5, 5
	silence 2
	envelope $88
	note C_,5, 3
	envelope $A8
	note D#,5, 10
	note D#,5, 5
	silence 2
	envelope $88
	note D#,5, 3
	duty_cycle 3
	envelope $A8
	note A#,4, 10
	note A_,4, 2
	note G#,4, 3
	note G_,4, 2
	note F#,4, 3
	duty_cycle 2
	envelope $88
	note A_,4, 2
	envelope $A8
	note A#,4, 18
	note D#,5, 10
	note F_,5, 40
	continue 10
	envelope $88
	note F_,5, 5
	silence 2
	envelope $68
	note F_,5, 3
	envelope $48
	note F_,5, 5
	silence 2
	envelope $38
	note F_,5, 3
	envelope $A8
	note D#,5, 10
	note F_,5
	note G#,5
	note G_,5
	silence
	note F_,5, 20
	note D#,5, 10
	silence
	note C#,5, 40
	envelope $88
	note C#,5, 5
	silence 2
	envelope $68
	note C#,5, 3
	envelope $48
	note C#,5, 5
	silence 2
	envelope $38
	note C#,5, 3
	silence 8
	envelope $A8
	note E_,5, 2
	note F_,5, 20
	snd_call SndCall_BGM_4A_Ch1_0
	chan_stop
SndCall_BGM_4A_Ch1_0:
	note D#,5, 20
	envelope $88
	note D#,5, 5
	envelope $68
	note D#,5, 2
	envelope $78
	note D#,5, 3
	envelope $68
	note D#,5, 5
	note D#,5, 2
	envelope $58
	note D#,5, 3
	envelope $48
	note D#,5, 5
	envelope $38
	note D#,5, 2
	note D#,5, 3
	snd_ret
SndData_BGM_4A_Ch2:
	envelope $A8
	panning $22
	duty_cycle 1
	vibrato_on $01
	envelope $A8
	note F_,4, 20
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $68
	note G_,3, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $A8
	note D#,5, 10
	note D_,5, 2
	note C#,5, 3
	note C_,5, 2
	note A#,4, 3
	note D#,4, 5
	silence 2
	envelope $68
	note D#,4, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $A8
	note G_,3, 5
	silence 2
	envelope $68
	note G_,3, 3
	envelope $A8
	note D#,4, 5
	silence 2
	envelope $68
	note D#,4, 3
	envelope $A8
	note D_,4, 5
	silence 2
	envelope $68
	note D_,4, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $A8
	note F_,3, 5
	silence 2
	envelope $68
	note F_,3, 3
	envelope $A8
	note D_,4, 5
	silence 2
	envelope $68
	note D_,4, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $A8
	note A_,3, 5
	silence 2
	envelope $68
	note A_,3, 3
	envelope $A8
	note A#,3, 5
	silence 2
	envelope $68
	note A#,3, 3
	envelope $A8
	note D_,4, 5
	silence 2
	envelope $68
	note D_,4, 3
	snd_call SndCall_BGM_4A_Ch2_1
	envelope $A8
	note F_,4, 5
	note G#,4
	note A#,4
	note C_,5
	note C#,6, 20
	note C_,6, 5
	note B_,5
	note A#,5, 2
	note A_,5, 3
	note G#,5
	note G_,5, 2
	note F#,5
	note F_,5, 3
	note E_,5
	note D#,5, 2
	silence 8
	note G_,5, 2
	note G#,5, 20
	fine_tune 4
	snd_call SndCall_BGM_4A_Ch1_0
	fine_tune -4
	chan_stop
SndCall_BGM_4A_Ch2_1:
	envelope $A8
	note F_,4, 5
	silence 2
	envelope $68
	note F_,4, 3
	envelope $A8
	note C#,4, 5
	silence 2
	envelope $68
	note C#,4, 3
	envelope $A8
	note G#,3, 5
	silence 2
	envelope $68
	note G#,3, 3
	snd_loop SndCall_BGM_4A_Ch2_1, $00, 2
	snd_ret
SndData_BGM_4A_Ch3:
	wave_vol $C0
	panning $44
	wave_id $03
	wave_cutoff 0
	vibrato_on $01
	note F_,4, 10
	note A#,3
	note D#,3, 8
	silence 2
	note D#,3, 5
	note A#,3, 10
	note D#,3, 20
	note C_,4, 10
	note A#,3
	note D#,3
	note D_,3, 20
	silence 10
	note D_,3, 20
	note F_,3, 10
	note A#,3, 20
	note C#,3, 10
	note G#,3, 5
	silence
	note G#,3, 10
	note C#,3
	note G#,3, 5
	silence
	note G#,3, 10
	note C#,3
	note G#,3
	note C#,3, 20
	silence 40
	note C#,3, 20
	note D#,3, 20
	chan_stop
SndData_BGM_4A_Ch4:
	panning $88
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $91
	note4 F#,5,0, 5
	envelope $91
	note4 E_,5,0, 5
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $53
	note4x $13, 10 ; Nearest: G#,6,0
	envelope $51
	note4 C_,6,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $51
	note4 C_,6,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 5
	envelope $53
	note4x $13, 15 ; Nearest: G#,6,0
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	note4 A_,5,0, 5
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 10
	envelope $C1
	note4 G#,4,0, 10
	envelope $A1
	note4 A_,5,0, 50
	note4 A_,5,0, 10
	envelope $91
	note4 E_,5,0, 20
	envelope $A1
	note4 A_,5,0, 10
	chan_stop
