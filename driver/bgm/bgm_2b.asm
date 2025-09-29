SndHeader_BGM_2B:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_2B_Ch1 ; Data ptr
	db -3 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_2B_Ch2 ; Data ptr
	db 9 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_2B_Ch3 ; Data ptr
	db -3 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_2B_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_2B_Ch1:
	envelope $22
	panning $11
	duty_cycle 2
	note C_,5, 10
	note G_,5
	note C_,6
	note C_,5
	envelope $32
	note G_,5
	note C_,6
	note C_,5
	note G_,5
	envelope $42
	note C_,6
	note C_,5
	note G_,5
	note C_,5
	envelope $51
	note C_,5
	note G_,5
	note C_,6
	note C_,5
	envelope $61
	snd_call SndCall_BGM_2B_Ch1_0_0
	chan_stop
SndCall_BGM_2B_Ch1_0_0:
	note C_,5, 10
	note G_,5
	note C_,6
	note C_,5
	note G_,5
	note C_,6
	note C_,5
	note G_,5
	note C_,6
	note C_,5
	note G_,5
	note C_,5
	note C_,5
	note G_,5
	note C_,6
	note C_,5
	snd_loop SndCall_BGM_2B_Ch1_0_0, $00, 3
	envelope $11
	note C_,5, 80
	continue 80
	continue 20
	envelope $68
	duty_cycle 2
	note F_,4, 10
	note E_,4
	silence
	note F_,4
	silence
	note G_,4, 40
	note F_,4, 5
	note E_,4
	note D_,4, 40
	silence 10
	note E_,4
	note F_,4
	note G_,4, 20
	note C_,5
	note F_,5, 40
	note E_,5, 5
	note D_,5
	note C_,5, 20
	note D_,5, 10
	note D#,5, 40
	note D_,5, 5
	note C_,5
	note G#,4, 20
	note G#,4, 10
	note F_,5, 40
	note D#,5, 5
	note D_,5
	note A#,4, 10
	note A#,4
	silence
	note C_,5
	continue 80
	continue 60
	note D_,5, 10
	note D#,5, 40
	note D_,5, 5
	note C_,5
	note G#,4, 30
	note F_,5, 40
	note D#,5, 5
	note D_,5
	note A#,4, 20
	note D_,5, 10
	note E_,5
	continue 80
	continue 80
	snd_ret
SndData_BGM_2B_Ch2:
	envelope $11
	panning $22
	duty_cycle 3
	note C_,3, 80
	continue 80
	continue 20
	envelope $65
	note C_,3, 10
	silence
	note C_,3, 20
	silence
	snd_call SndCall_BGM_2B_Ch2_0_0
	chan_stop
SndCall_BGM_2B_Ch2_0_0:
	note C_,3, 10
	silence
	note C_,3, 20
	note A#,2, 10
	note A#,2
	note C_,3
	note C_,3, 30
	note C_,3, 10
	silence
	note C_,3, 20
	silence
	snd_loop SndCall_BGM_2B_Ch2_0_0, $00, 2
	note C_,3, 10
	silence
	note C_,3, 20
	note A#,2, 10
	note A#,2
	note C_,3
	note C_,3, 30
	note G#,2, 10
	silence
	note A#,2, 30
	envelope $67
	note G_,2, 10
	continue 80
	envelope $11
	note C_,3, 20
	envelope $65
	note C_,3, 10
	silence
	note C_,3, 40
	note C_,3, 10
	silence
	note C_,3, 20
	note A#,2, 10
	note A#,2
	note C_,3
	note C_,3, 30
	note C_,3, 10
	silence
	note C_,3, 40
	note C_,3, 10
	silence
	note C_,3, 20
	note A#,2, 10
	note A#,2
	note C_,3
	note C_,3, 30
	note C_,3, 10
	silence
	note C_,3, 30
	note D_,3
	note D_,3, 10
	silence
	note D_,3
	note D_,3
	silence
	envelope $67
	note C_,3
	continue 80
	envelope $65
	silence 10
	note F_,3
	note E_,3
	note C_,3
	note F_,3
	note E_,3
	note C_,3
	note G#,2
	silence 20
	note C_,3, 10
	silence
	note C_,3, 30
	note D_,3
	note D_,3, 10
	silence
	note D_,3
	note D_,3
	silence
	envelope $67
	note C_,3
	continue 80
	envelope $65
	silence 10
	note F_,3
	note E_,3
	note C_,3
	note F_,3
	note E_,3
	note C_,3
	note C_,4
	snd_ret
SndData_BGM_2B_Ch3:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 0
	silence 80
	continue 80
	continue 20
	note C_,3, 60
	continue 40
	wave_cutoff 30
	silence 10
	note A#,2
	note A#,2
	wave_cutoff 60
	note C_,3, 20
	wave_cutoff 30
	note C_,3, 10
	note C_,3
	note C_,3
	note C_,3
	note C_,3
	note C_,3
	note C_,3
	note C_,3
	note C_,3
	note C_,3
	note C_,3
	note A#,2
	note A#,2
	note C_,3
	wave_cutoff 60
	note C_,3, 20
	wave_cutoff 30
	note C_,3, 10
	note C_,3
	note C_,3
	note C_,3
	note C_,3
	note C_,3
	wave_cutoff 60
	note C_,3, 20
	wave_cutoff 30
	note C_,3, 10
	note C_,3
	note C_,3
	note A#,2
	note A#,2
	note C_,3
	wave_cutoff 60
	note C_,3, 30
	note G#,2, 20
	note A#,2
	silence 10
	note G_,2
	wave_cutoff 30
	silence
	note G_,2
	note G_,2
	note G_,2
	note G_,2
	note G_,2
	note G_,2
	fine_tune 12
SndData_BGM_2B_Ch3_0:
	wave_cutoff 60
	note C_,3, 20
	wave_cutoff 30
	note C_,3, 10
	note C_,3
	note C_,3
	note C_,3
	note C_,3
	note C_,3
	wave_cutoff 60
	note A#,2, 20
	wave_cutoff 30
	note A#,2, 10
	note A#,2
	note A#,2
	note A#,2
	note A#,2
	note A#,2
	snd_loop SndData_BGM_2B_Ch3_0, $00, 2
	wave_cutoff 60
	note G#,2, 20
	wave_cutoff 30
	note G#,2, 10
	note G#,2
	note G#,2
	note G#,2
	note G#,2
	note G#,2
	wave_cutoff 60
	note A#,2, 20
	wave_cutoff 30
	note A#,2, 10
	note A#,2
	note A#,2
	note A#,2
	note A#,2
	silence
	wave_cutoff 0
	note C_,3
	continue 80
	continue 40
	wave_cutoff 30
	silence 10
	note A#,2
	note C_,3
	wave_cutoff 60
	note G#,2, 20
	wave_cutoff 30
	note G#,2, 10
	note G#,2
	note G#,2
	note G#,2
	note G#,2
	note G#,2
	wave_cutoff 60
	note A#,2, 20
	wave_cutoff 30
	note A#,2, 10
	note A#,2, 20
	note A#,2, 10
	note A#,2
	note A#,2
	wave_cutoff 0
	note C_,3
	continue 80
	continue 10
	wave_cutoff 30
	note C_,3
	note C_,3
	note C_,3
	note A#,2
	note A#,2
	note C_,3
	note C_,3
	chan_stop
SndData_BGM_2B_Ch4:
	panning $88
	envelope $11
	note4x $21, 80 ; Nearest: A#,5,0
	envelope $11
	note4x $21, 80 ; Nearest: A#,5,0
	envelope $31
	note4x $21, 20 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 20
	envelope $31
	note4x $21, 20 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 20
	envelope $31
	note4x $21, 20 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 20
	envelope $31
	note4x $21, 20 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	snd_call SndCall_BGM_2B_Ch4_0
	snd_call SndCall_BGM_2B_Ch4_1
	snd_call SndCall_BGM_2B_Ch4_0
	snd_call SndCall_BGM_2B_Ch4_2
	snd_call SndCall_BGM_2B_Ch4_3
	snd_call SndCall_BGM_2B_Ch4_1
	snd_call SndCall_BGM_2B_Ch4_0
	snd_call SndCall_BGM_2B_Ch4_2
	snd_call SndCall_BGM_2B_Ch4_4
	snd_call SndCall_BGM_2B_Ch4_5
	snd_call SndCall_BGM_2B_Ch4_4
	snd_call SndCall_BGM_2B_Ch4_6
	chan_stop
SndCall_BGM_2B_Ch4_0:
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	snd_ret
SndCall_BGM_2B_Ch4_1:
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	snd_ret
SndCall_BGM_2B_Ch4_2:
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	snd_ret
SndCall_BGM_2B_Ch4_3:
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $54
	note4x $22, 20 ; Nearest: A_,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	note4 B_,5,0, 10
	note4 B_,5,0, 10
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	snd_ret
SndCall_BGM_2B_Ch4_4:
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $72
	note4x $32, 10 ; Nearest: A_,5,0
	snd_ret
SndCall_BGM_2B_Ch4_5:
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	note4x $21, 10 ; Nearest: A#,5,0
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	snd_ret
SndCall_BGM_2B_Ch4_6:
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $72
	note4x $32, 5 ; Nearest: A_,5,0
	note4x $32, 5 ; Nearest: A_,5,0
	envelope $54
	note4x $22, 10 ; Nearest: A_,5,0
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	envelope $72
	note4x $32, 50 ; Nearest: A_,5,0
	envelope $54
	note4x $22, 5 ; Nearest: A_,5,0
	note4x $22, 5 ; Nearest: A_,5,0
	envelope $72
	note4x $32, 10 ; Nearest: A_,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $72
	note4x $32, 10 ; Nearest: A_,5,0
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	note4x $21, 10 ; Nearest: A#,5,0
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	note4 F_,5,0, 10
	envelope $31
	note4x $21, 10 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	note4 B_,5,0, 10
	snd_ret
