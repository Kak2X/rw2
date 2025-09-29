SndHeader_BGM_0A:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_0A_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_0A_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_0A_Ch3_0 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_0A_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_0A_Ch1:
	envelope $11
	panning $11
	duty_cycle 2
	note C_,3, 96
	continue 96
SndData_BGM_0A_Ch1_0:
	snd_call SndCall_BGM_0A_Ch1_0
	snd_call SndCall_BGM_0A_Ch1_1
	snd_call SndCall_BGM_0A_Ch1_0
	snd_call SndCall_BGM_0A_Ch1_2
	snd_call SndCall_BGM_0A_Ch1_3
	snd_call SndCall_BGM_0A_Ch1_4
	snd_call SndCall_BGM_0A_Ch1_3
	snd_call SndCall_BGM_0A_Ch1_5
	snd_loop SndData_BGM_0A_Ch1_0
SndCall_BGM_0A_Ch1_0:
	envelope $11
	note A_,4, 12
	envelope $63
	note A_,4, 6
	note B_,4
	silence
	note A_,4
	note B_,4, 12
	silence 6
	note F#,4
	note A_,4
	note C#,5
	note E_,5
	note D_,5
	note C#,5
	note A_,4
	envelope $11
	note A_,4, 12
	envelope $63
	note A_,4, 6
	note B_,4
	silence
	note A_,4
	note B_,4, 12
	silence 6
	note F#,4
	note A_,4
	note E_,5
	snd_ret
SndCall_BGM_0A_Ch1_1:
	note D_,5, 24
	snd_ret
SndCall_BGM_0A_Ch1_2:
	note F#,5, 24
	snd_ret
SndCall_BGM_0A_Ch1_3:
	envelope $11
	note C#,5, 12
	envelope $63
	note C#,5, 6
	note D_,5
	silence
	note C#,5
	note D_,5, 12
	silence 6
	note A_,4
	note C#,5
	note E_,5
	note F#,5
	note E_,5
	note C#,5
	note A_,4
	envelope $11
	note C#,5, 12
	envelope $63
	note C#,5, 6
	note D_,5
	silence
	note C#,5
	note D_,5, 12
	silence 6
	snd_ret
SndCall_BGM_0A_Ch1_4:
	note A_,4, 6
	note C#,5
	note E_,5
	note D_,5, 24
	snd_ret
SndCall_BGM_0A_Ch1_5:
	note E_,5, 6
	note D_,5
	note A_,4
	note B_,4, 24
	snd_ret
SndData_BGM_0A_Ch2:
	envelope $11
	panning $22
	duty_cycle 3
	note C_,3, 96
	continue 96
SndData_BGM_0A_Ch2_0:
	snd_call SndCall_BGM_0A_Ch2_0
	snd_call SndCall_BGM_0A_Ch2_1
	snd_call SndCall_BGM_0A_Ch2_2
	snd_call SndCall_BGM_0A_Ch2_0
	snd_call SndCall_BGM_0A_Ch2_1
	snd_call SndCall_BGM_0A_Ch2_3
	snd_call SndCall_BGM_0A_Ch2_0
	snd_call SndCall_BGM_0A_Ch2_4
	snd_call SndCall_BGM_0A_Ch2_5
	snd_call SndCall_BGM_0A_Ch2_0
	snd_call SndCall_BGM_0A_Ch2_4
	snd_call SndCall_BGM_0A_Ch2_6
	snd_loop SndData_BGM_0A_Ch2_0
SndCall_BGM_0A_Ch2_0:
	envelope $11
	note F#,4, 12
	envelope $62
	note F#,4
	envelope $11
	note F#,4, 6
	envelope $62
	note F#,4, 18
	envelope $11
	note F#,4, 6
	envelope $62
	note D_,4, 18
	note C#,4, 24
	snd_ret
SndCall_BGM_0A_Ch2_1:
	envelope $11
	note C#,4, 12
	envelope $62
	note D_,4
	envelope $11
	note D_,4, 6
	envelope $62
	note D_,4, 18
	envelope $11
	note D_,4, 6
	snd_ret
SndCall_BGM_0A_Ch2_2:
	envelope $62
	note C#,4, 18
	note F#,4, 6
	note E_,4
	note F#,4
	note A_,4
	snd_ret
SndCall_BGM_0A_Ch2_3:
	envelope $62
	note C#,4, 18
	note D_,4, 6
	note E_,4
	note F#,4
	note A_,4
	snd_ret
SndCall_BGM_0A_Ch2_4:
	envelope $11
	note F#,4, 12
	envelope $62
	note F#,4
	envelope $11
	note F#,4, 6
	envelope $62
	note F#,4, 18
	envelope $11
	note F#,4, 6
	snd_ret
SndCall_BGM_0A_Ch2_5:
	envelope $62
	note C#,4, 18
	note F#,4, 6
	note A_,4
	note B_,4
	note C#,5
	snd_ret
SndCall_BGM_0A_Ch2_6:
	envelope $62
	note C#,4, 18
	note F#,4, 6
	note C#,4
	note D_,4
	note A_,3
	snd_ret
SndData_BGM_0A_Ch3_0:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 25
	note B_,2, 12
	note A_,3, 6
	note B_,3, 12
	note F#,3, 6
	note A_,3
	note B_,3, 12
	note E_,3, 6
	note F#,3
	note A_,3
	note B_,3
	note A_,3
	note F#,3
	note E_,3
	note B_,2, 12
	note A_,3, 6
	note B_,3, 12
	note F#,3, 6
	note A_,3
	note B_,3, 12
	note E_,3, 6
	note F#,3
	note A_,3
	note B_,3, 12
	note A_,2
	snd_loop SndData_BGM_0A_Ch3_0
SndData_BGM_0A_Ch4:
	panning $88
	envelope $31
	note4x $21, 24 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 24
	envelope $31
	note4x $21, 24 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 24
	envelope $31
	note4x $21, 24 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 24
	note4 F_,5,0, 6
	envelope $54
	note4x $22, 6 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 6
	envelope $61
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	note4 B_,5,0, 6
	note4 B_,5,0, 6
SndData_BGM_0A_Ch4_0:
	snd_call SndCall_BGM_0A_Ch4_0
	snd_call SndCall_BGM_0A_Ch4_1
	snd_call SndCall_BGM_0A_Ch4_0
	snd_call SndCall_BGM_0A_Ch4_2
	snd_call SndCall_BGM_0A_Ch4_0
	snd_call SndCall_BGM_0A_Ch4_1
	snd_call SndCall_BGM_0A_Ch4_0
	snd_call SndCall_BGM_0A_Ch4_3
	snd_loop SndData_BGM_0A_Ch4_0
SndCall_BGM_0A_Ch4_0:
	envelope $61
	note4 F_,5,0, 18
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $61
	note4 F_,5,0, 12
	note4 F_,5,0, 6
	note4 F_,5,0, 6
	note4 F_,5,0, 12
	envelope $62
	note4 B_,5,0, 12
	envelope $61
	note4 F_,5,0, 12
	snd_ret
SndCall_BGM_0A_Ch4_1:
	envelope $61
	note4 F_,5,0, 18
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 24
	snd_ret
SndCall_BGM_0A_Ch4_2:
	envelope $61
	note4 F_,5,0, 18
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	envelope $54
	note4x $22, 12 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 6
	snd_ret
SndCall_BGM_0A_Ch4_3:
	envelope $61
	note4 F_,5,0, 18
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 12
	envelope $61
	note4 F_,5,0, 12
	envelope $31
	note4x $21, 6 ; Nearest: A#,5,0
	note4x $21, 6 ; Nearest: A#,5,0
	envelope $61
	note4 F_,5,0, 6
	note4 F_,5,0, 6
	envelope $62
	note4 B_,5,0, 6
	envelope $54
	note4x $22, 6 ; Nearest: A_,5,0
	envelope $72
	note4 A_,5,0, 12
	snd_ret
