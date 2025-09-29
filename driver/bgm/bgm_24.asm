SndHeader_BGM_24:
	db $04 ; Number of channels
.ch1:
	db SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_BGM_24_Ch1_0 ; Data ptr
	db -3 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch2:
	db SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_BGM_24_Ch2_0 ; Data ptr
	db 9 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch3:
	db SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_BGM_24_Ch3_0 ; Data ptr
	db -3 ; Initial fine tune
	db $81 ; Initial vibrato ID
.ch4:
	db SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_BGM_24_Ch4_0 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_BGM_24_Ch1_0:
	envelope $67
	panning $11
	duty_cycle 2
	snd_call SndCall_BGM_24_Ch1_0
	snd_loop SndData_BGM_24_Ch1_0
SndCall_BGM_24_Ch1_0:
	note G#,5, 20
	note F_,5, 10
	note G_,5
	note G#,5, 20
	note F_,5, 10
	note G_,5
	note G#,5, 20
	note G_,5, 10
	note F_,5
	note F_,5
	note E_,5
	note C_,5, 20
	note A#,5, 20
	note G_,5, 10
	note G#,5
	note A#,5, 20
	note G_,5, 10
	note G#,5
	note A#,5, 20
	note G#,5, 10
	note G_,5
	note G_,5
	note F_,5
	note F_,5, 20
	note C_,6, 30
	note A#,5, 10
	note G#,5, 20
	note A#,5, 10
	note C_,6
	note C#,6
	note D#,6
	note F_,6
	note G#,6
	note G_,6, 20
	note F_,6
	note C_,6, 10
	note D_,6
	note E_,6
	note F_,6
	note G_,6
	note G#,6
	note A#,6
	note G_,6
	note F_,6
	note E_,6
	note F_,6
	note G_,6
	note F_,6, 20
	note F_,6
	snd_ret
SndData_BGM_24_Ch2_0:
	envelope $64
	panning $22
	duty_cycle 1
	snd_call SndCall_BGM_24_Ch2_0_0
	snd_call SndCall_BGM_24_Ch2_1_0
	snd_call SndCall_BGM_24_Ch2_0_0
	snd_call SndCall_BGM_24_Ch2_2
	snd_loop SndData_BGM_24_Ch2_0
SndCall_BGM_24_Ch2_0_0:
	note F_,3, 10
	note G#,3
	note C_,3
	note G#,3
	snd_loop SndCall_BGM_24_Ch2_0_0, $00, 3
	snd_ret
SndCall_BGM_24_Ch2_1_0:
	note E_,3, 10
	note G_,3
	note C_,3
	note G_,3
	snd_loop SndCall_BGM_24_Ch2_1_0, $00, 4
	snd_ret
SndCall_BGM_24_Ch2_2:
	note A#,3, 10
	note C#,4
	note F_,3
	note C#,4
	note A#,3
	note C#,4
	note F_,3
	note C#,4
	note G_,3
	note C_,4
	note E_,3
	note C_,4
	note G_,3
	note C_,4
	note E_,3
	note C_,4
	note G_,3
	note C_,4
	note G_,3
	note G#,3
	note G_,3
	note C_,3
	note F_,3
	note G#,3
	snd_ret
SndData_BGM_24_Ch3_0:
	wave_vol $80
	panning $44
	wave_id $03
	wave_cutoff 30
	note F_,3, 10
	note C_,4
	note C_,3
	note C_,4
	note F_,3
	note C_,4
	note C_,3
	note C_,4
	note F_,3
	note C_,4
	note F_,3
	note G_,3
	note E_,3
	note C_,4
	note C_,3
	note C_,4
	note E_,3
	note C_,4
	note C_,3
	note C_,4
	note E_,3
	note C_,4
	note C_,3
	note C_,4
	note E_,3
	note C_,4
	note C_,3
	note E_,3
	note F_,3
	note C_,4
	note C_,3
	note C_,4
	note F_,3
	note C_,4
	note C_,3
	note C_,4
	note F_,3
	note C_,4
	note C_,3
	note C_,4
	note A#,3
	note F_,4
	note F_,3
	note F_,4
	note A#,3
	note F_,4
	note F_,3
	note F_,4
	note C_,4
	note G_,4
	note G_,3
	note G_,4
	note C_,4
	note G_,4
	note G_,3
	note G_,4
	note F_,3
	note C_,4
	note C_,3
	note C_,4
	note F_,3
	note C_,4
	note C_,3
	note E_,3
	snd_loop SndData_BGM_24_Ch3_0
SndData_BGM_24_Ch4_0:
	panning $88
	snd_call SndCall_BGM_24_Ch4_0_0
	snd_call SndCall_BGM_24_Ch4_1
	snd_call SndCall_BGM_24_Ch4_0_0
	snd_call SndCall_BGM_24_Ch4_1
	snd_call SndCall_BGM_24_Ch4_0_0
	snd_call SndCall_BGM_24_Ch4_0_0
	snd_call SndCall_BGM_24_Ch4_0_0
	snd_call SndCall_BGM_24_Ch4_1
	snd_loop SndData_BGM_24_Ch4_0
SndCall_BGM_24_Ch4_0_0:
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	snd_loop SndCall_BGM_24_Ch4_0_0, $00, 4
	snd_ret
SndCall_BGM_24_Ch4_1:
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
	envelope $62
	note4 B_,5,0, 5
	note4 B_,5,0, 5
	envelope $61
	note4 F_,5,0, 10
	envelope $62
	note4 B_,5,0, 10
	snd_ret
