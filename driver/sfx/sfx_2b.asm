SndHeader_SFX_2B:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_2B_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_2B_Ch2:
	envelope $F8
	panning $22
	duty_cycle 3
	snd_call SndCall_SFX_2B_Ch2_0
	fine_tune 1
	snd_call SndCall_SFX_2B_Ch2_0
	fine_tune 1
	snd_call SndCall_SFX_2B_Ch2_0
	fine_tune 1
	snd_call SndCall_SFX_2B_Ch2_0
	fine_tune -3
	chan_stop
SndCall_SFX_2B_Ch2_0:
	note C_,2, 2
	note F#,2, 1
	note A_,3
	note A#,3
	note B_,3
	note C_,4
	silence 2
	snd_ret
