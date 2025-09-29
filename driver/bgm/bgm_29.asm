SndHeader_BGM_29:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_29_Ch1 ; Data ptr
	db 2 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_29_Ch2 ; Data ptr
	db 2 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_29_Ch3 ; Data ptr
	db 2 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_29_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_29_Ch1:
	envelope $67
	panning $11
	duty_cycle 2
	note A_,4, 10
	note C_,5
	note D_,5
	note E_,5, 60
	note G_,5, 20
	note F#,5, 60
	note D_,5, 20
	note E_,5, 80
	continue 80
	note E_,5, 60
	note G_,5, 20
	note A_,5, 40
	note F#,5
	note G#,5, 80
	continue 80
	note A_,5, 60
	note G_,5, 10
	note A_,5
	note B_,5, 20
	note C_,6
	note B_,5
	note G_,5
	note E_,5, 40
	note G#,5
	note A_,5
	note G_,5, 20
	note A_,5
	note B_,5, 60
	note C_,6, 20
	note B_,5, 40
	note A_,5
	note G_,5, 120
	silence 10
	note E_,5
	note F_,5
	note G_,5
	note A_,5, 60
	note G_,5, 10
	note A_,5
	note B_,5, 20
	note C_,6
	note B_,5
	note G_,5
	note E_,5, 40
	note G#,5
	note A_,5
	note G_,5, 20
	note A_,5
	note B_,5, 60
	note C_,6, 20
	note D_,6, 40
	note D_,6
	note C#,6, 120
	silence 10
	note A_,4
	note G_,5
	note E_,5
	note F_,5, 40
	silence 10
	note F_,5
	note E_,5
	note D_,5
	note C_,5, 40
	silence 10
	note B_,4
	note F_,5
	note G_,5
	note D_,5, 30
	note E_,5, 80
	envelope $11
	note E_,5, 30
	envelope $67
	note D_,5, 10
	note E_,5
	note F_,5, 40
	silence 10
	note F_,5
	note E_,5
	note D_,5
	note C_,5, 40
	silence 10
	note B_,4
	note G_,5
	note F_,5
	note F_,5, 20
	note E_,5, 10
	note E_,5, 80
	silence 20
	note A_,4, 10
	note G_,5
	note A_,5
	note F_,5, 40
	silence 10
	note F_,5
	note E_,5
	note D_,5
	note C_,5, 40
	silence 10
	note B_,4
	note F_,5
	note G_,5
	note D_,5, 20
	note E_,5, 10
	note E_,5, 20
	note E_,5, 10
	note D_,5
	note C_,5
	note B_,4, 20
	note A_,4, 30
	note A_,4, 10
	note F_,5
	note E_,5
	note D_,5, 40
	silence 10
	note D_,5
	note C_,5
	note B_,4
	note A_,4, 20
	note G#,4
	note D_,5
	note B_,4
	note C#,5, 80
	continue 80
	silence 10
	note G#,6, 120
	continue 20
	chan_stop
SndData_BGM_29_Ch2:
	envelope $11
	panning $22
	duty_cycle 0
	note E_,4, 30
	envelope $67
	note E_,4, 80
	note F#,4
	note E_,4
	continue 80
	note E_,4
	note F#,4
	note G#,4
	silence 20
	note B_,4
	note E_,5
	note G#,5
	note C_,4, 80
	note D_,4
	note D_,4
	note C_,4
	note F_,4
	note F_,4
	note D_,4, 40
	note G_,4
	note C_,5
	note G_,4
	note C_,4, 80
	note D_,4
	note D_,4
	note C_,4
	note F_,4
	note G#,4
	note A_,2, 10
	note E_,3
	note A_,3
	note B_,3
	note C#,4
	note E_,4
	note A_,4
	note B_,4
	note C#,5, 20
	note B_,4
	note C#,5
	note E_,5
	note D_,3, 10
	note A_,3
	note D_,4
	note E_,4
	note F_,4, 40
	note G_,3, 10
	note D_,4
	note G_,4
	note A_,4
	note B_,4, 40
	note C_,3, 10
	note G_,3
	note C_,4
	note D_,4
	note E_,4, 40
	note F_,3, 10
	note C_,4
	note F_,4
	note G_,4
	note A_,4, 40
	note B_,2, 10
	note A_,3
	note D_,4
	note E_,4
	note F_,4, 40
	note E_,3, 10
	note D_,4
	note G#,4
	note A_,4
	note B_,4, 40
	note A_,2, 10
	note E_,4
	note A_,4
	note B_,4
	note C_,5
	note E_,5
	note A_,5
	note B_,5
	note C#,3
	note A_,3
	note E_,4
	note F_,4
	note G_,4
	note A_,4
	note A#,4
	note G_,4
	note D_,3
	note A_,3
	note D_,4
	note E_,4
	note F_,4, 40
	note G_,3, 10
	note D_,4
	note G_,4
	note A_,4
	note B_,4, 30
	note G_,3, 10
	note C_,3
	note G_,3
	note C_,4
	note D_,4
	note E_,4
	note G_,4
	note C_,5
	note D_,5
	note E_,5
	note C_,5
	note A_,4
	note G_,4
	note F_,4
	note C_,4
	note A_,3
	note B_,3
	note B_,2
	note A_,3
	note D_,4
	note E_,4
	note F_,4
	note A_,4
	note D_,5
	note F_,5
	note E_,3
	note D_,4
	note G#,4
	note A_,4
	note B_,4
	note C_,5
	note D_,5
	note B_,4
	note A_,3
	note E_,4
	note A_,4
	note B_,4
	note C#,5
	note E_,5
	note A_,5
	note B_,5
	note C#,6
	note E_,5
	note A_,5
	note B_,5
	note C#,6
	note E_,6
	note A_,6
	note B_,6
	silence
	note C#,7, 120
	continue 20
	chan_stop
SndData_BGM_29_Ch3:
	wave_vol $80
	panning $44
	wave_id $02
	wave_cutoff 1
	note A_,3, 30
	wave_cutoff 0
	note A_,3, 80
	note D_,4
	note A_,3, 20
	note E_,3
	note A_,3
	note G_,4
	note A_,4, 40
	note G_,2
	note A_,3, 80
	note D_,4
	note E_,3, 10
	note B_,3
	note E_,4
	note F#,4
	note G#,4
	note B_,4
	note E_,5
	note F#,5
	note G#,5, 80
	note F_,3, 20
	note C_,4
	note A_,4, 40
	note G_,3, 20
	note D_,4
	note B_,4, 40
	note E_,3, 20
	note B_,3
	note G#,4, 40
	note F_,3, 20
	note E_,4
	note A_,4, 40
	note D_,3, 20
	note A_,3
	note F_,4, 40
	note G_,3, 20
	note D_,4
	note G_,4, 40
	note C_,3, 10
	note G_,3
	note C_,4
	note D_,4
	note E_,4
	note G_,4
	note C_,5
	note D_,5
	note E_,5, 20
	note D_,5
	note C_,5
	note G_,4
	note F_,3
	note C_,4
	note A_,4
	note C_,4
	note G_,3
	note D_,4
	note B_,4
	note D_,4
	note E_,3
	note B_,3
	note G#,4
	note B_,3
	note F_,3
	note C_,4
	note A_,4
	note C_,4
	note D_,3
	note A_,3
	note F_,4
	note A_,3
	note E_,3
	note B_,3
	note G#,4
	note B_,3
	wave_id $03
	note A_,2, 80
	note A_,3, 75
	note A_,2, 5
	note D_,3, 40
	note D_,3, 30
	note G_,3, 10
	note G_,3
	note G_,3
	note G_,3, 20
	note G_,2, 40
	note C_,3, 40
	note C_,3, 30
	note F_,3, 10
	note F_,3
	note F_,3
	note F_,3, 20
	note F_,3, 40
	note B_,2, 80
	note E_,3
	note A_,2
	note C#,3
	note D_,3
	note G_,3, 60
	continue 10
	note G_,2
	note C_,3, 80
	note F_,3, 40
	note F_,3, 30
	note F_,2, 10
	note B_,2, 80
	note E_,3, 60
	continue 10
	note E_,2
	note A_,2, 80
	continue 80
	continue 80
	chan_stop
SndData_BGM_29_Ch4:
	panning $88
	envelope $11
	note4x $21, 30 ; Nearest: A#,5,0
	snd_call SndCall_BGM_29_Ch4_0_0
	snd_call SndCall_BGM_29_Ch4_1
	chan_stop
SndCall_BGM_29_Ch4_0_0:
	envelope $11
	note4x $21, 80 ; Nearest: A#,5,0
	snd_loop SndCall_BGM_29_Ch4_0_0, $00, 22
	snd_ret
SndCall_BGM_29_Ch4_1:
	envelope $61
	note4 F_,5,0, 30
	envelope $54
	note4x $22, 5 ; Nearest: A_,5,0
	note4x $22, 5 ; Nearest: A_,5,0
	note4x $22, 10 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $72
	note4 A_,5,0, 10
	note4 A_,5,0, 10
	note4 A_,5,0, 10
	envelope $72
	note4x $32, 5 ; Nearest: A_,5,0
	note4x $32, 5 ; Nearest: A_,5,0
	note4x $32, 10 ; Nearest: A_,5,0
	note4x $32, 10 ; Nearest: A_,5,0
	note4x $32, 10 ; Nearest: A_,5,0
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
SndCall_BGM_29_Ch4_1_0:
	envelope $61
	note4 F_,5,0, 20
	envelope $31
	note4x $21, 20 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 20
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 20
	note4 F_,5,0, 20
	envelope $62
	note4 B_,5,0, 20
	envelope $31
	note4x $21, 20 ; Nearest: A#,5,0
	snd_loop SndCall_BGM_29_Ch4_1_0, $00, 6
	envelope $61
	note4 F_,5,0, 20
	envelope $31
	note4x $21, 20 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 20
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 20
	note4 F_,5,0, 20
	envelope $62
	note4 B_,5,0, 20
	envelope $72
	note4x $32, 20 ; Nearest: A_,5,0
	envelope $61
	note4 F_,5,0, 80
	snd_ret
