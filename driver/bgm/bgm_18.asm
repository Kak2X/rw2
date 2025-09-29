SndHeader_BGM_18:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_18_Ch1_0 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_18_Ch2_0 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_18_Ch3_0 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_18_Ch4_0 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_18_Ch1_0:
	envelope $76
	panning $11
	duty_cycle 3
	snd_call SndCall_BGM_18_Ch1_0
	fine_tune 5
	snd_call SndCall_BGM_18_Ch1_0
	fine_tune -5
	envelope $11
	note E_,5, 24
	continue 6
	envelope $76
	note E_,5
	note D#,5
	note D_,5
	envelope $56
	note D_,5
	envelope $46
	note D_,5
	envelope $36
	note D_,5
	envelope $26
	note D_,5
	envelope $16
	note D_,5
	envelope $76
	note D_,5
	note C#,5
	note C_,5
	envelope $56
	note C_,5
	envelope $46
	note C_,5
	envelope $77
	note C#,5, 12
	note C_,5, 6
	note C_,5, 12
	note C#,5, 6
	envelope $11
	note C#,5, 12
	envelope $77
	note C#,5, 6
	silence
	note E_,5
	note F_,5, 18
	snd_loop SndData_BGM_18_Ch1_0
SndCall_BGM_18_Ch1_0:
	envelope $11
	note F#,2, 12
	envelope $76
	note F#,2
	note E_,3, 6
	note F#,3, 12
	note F#,3, 6
	silence
	note E_,3
	note F#,3
	note C#,3
	note B_,2
	note C_,3
	note A_,2
	note F#,2
	envelope $11
	note A_,4, 12
	envelope $76
	note A_,4, 6
	silence
	note B_,4, 18
	note B_,4, 6
	note A_,4
	note G#,4
	silence
	note G#,4, 24
	continue 6
	snd_ret
SndData_BGM_18_Ch2_0:
	envelope $11
	panning $22
	duty_cycle 3
	snd_call SndCall_BGM_18_Ch2_0
	fine_tune 5
	snd_call SndCall_BGM_18_Ch2_0
	fine_tune -5
	envelope $11
	note E_,5, 24
	continue 6
	envelope $76
	note C#,5
	note C#,5
	note B_,4
	envelope $56
	note B_,4
	envelope $46
	note B_,4
	envelope $36
	note B_,4
	envelope $26
	note B_,4
	envelope $16
	note B_,4
	envelope $76
	note B_,4
	note A_,4
	note A_,4
	envelope $56
	note A_,4
	envelope $46
	note A_,4
	envelope $77
	note G#,4, 12
	note G#,4, 6
	note G#,4, 12
	note G#,4, 6
	envelope $11
	note G#,4, 12
	envelope $77
	note A_,4, 6
	silence
	note C#,5
	note B_,4, 18
	snd_loop SndData_BGM_18_Ch2_0
SndCall_BGM_18_Ch2_0:
	envelope $11
	note F#,4, 96
	continue 12
	envelope $76
	note F#,4, 6
	silence
	note F#,4, 18
	note G#,4, 6
	note F#,4
	note E_,4
	silence
	note E_,4, 24
	continue 6
	snd_ret
SndData_BGM_18_Ch3_0:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 60
	snd_call SndCall_BGM_18_Ch3_0
	fine_tune 5
	snd_call SndCall_BGM_18_Ch3_0
	fine_tune -5
	note C#,3, 6
	note C#,3, 12
	note C#,4, 18
	note C#,3, 12
	note B_,2, 6
	note B_,2, 12
	note B_,3, 18
	note B_,2, 12
	note C#,3, 6
	note C#,3, 12
	note C#,3, 6
	note C_,3
	note C_,3, 12
	note C_,3, 6
	note C#,3, 12
	note D#,3
	note E_,3, 6
	note F_,3, 18
	snd_loop SndData_BGM_18_Ch3_0
SndCall_BGM_18_Ch3_0:
	wave_cutoff 1
	note F#,2, 12
	wave_cutoff 60
	note F#,2
	note E_,3, 6
	note F#,3, 12
	note F#,3, 6
	wave_cutoff 1
	note F#,3
	wave_cutoff 60
	note E_,3
	note F#,3
	note C#,3
	note B_,2
	note C_,3
	note A_,2
	note F#,2
	wave_cutoff 1
	note F#,2, 72
	wave_cutoff 60
	note C#,3, 24
	snd_ret
SndData_BGM_18_Ch4_0:
	panning $88
	snd_call SndCall_BGM_18_Ch4_0
	snd_call SndCall_BGM_18_Ch4_1
	snd_call SndCall_BGM_18_Ch4_2
	snd_call SndCall_BGM_18_Ch4_1
	snd_call SndCall_BGM_18_Ch4_3_0
	snd_loop SndData_BGM_18_Ch4_0
SndCall_BGM_18_Ch4_0:
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	snd_ret
SndCall_BGM_18_Ch4_1:
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 12
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	envelope $72
	note4x $32, 6 ; Nearest: A_,5,0
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	snd_ret
SndCall_BGM_18_Ch4_2:
	envelope $61
	note4 F_,5,0, 12
	note4 F_,5,0, 6
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $62
	note4 B_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	snd_ret
SndCall_BGM_18_Ch4_3_0:
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 12
	envelope $54
	note4x $22, 3 ; Nearest: A_,5,0
	note4x $22, 3 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 6
	envelope $72
	note4x $32, 6 ; Nearest: A_,5,0
	snd_loop SndCall_BGM_18_Ch4_3_0, $00, 2
	envelope $31
	note4x $21, 18 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	note4 B_,5,0, 6
	note4 B_,5,0, 6
	envelope $54
	note4x $22, 12 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 12
	envelope $62
	note4 B_,5,0, 6
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	snd_ret
