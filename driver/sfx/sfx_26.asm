SndHeader_SFX_26:
	db $01 ; Number of channels
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_26_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_26_Ch2:
	envelope $F8
	panning $22
	duty_cycle 2
	note C_,8, 7
	snd_call SndCall_SFX_26_Ch2_0
	snd_call SndCall_SFX_26_Ch2_1
	fine_tune -12
	envelope $E8
	snd_call SndCall_SFX_26_Ch2_0
	envelope $D8
	snd_call SndCall_SFX_26_Ch2_1
	fine_tune -12
	envelope $C8
	snd_call SndCall_SFX_26_Ch2_0
	envelope $B8
	snd_call SndCall_SFX_26_Ch2_1
	fine_tune -12
	envelope $A8
	snd_call SndCall_SFX_26_Ch2_0
	envelope $98
	snd_call SndCall_SFX_26_Ch2_1
	fine_tune -12
	envelope $88
	snd_call SndCall_SFX_26_Ch2_0
	envelope $68
	snd_call SndCall_SFX_26_Ch2_1
	fine_tune -12
	envelope $48
	snd_call SndCall_SFX_26_Ch2_0
	envelope $28
	snd_call SndCall_SFX_26_Ch2_1
	chan_stop
SndCall_SFX_26_Ch2_0:
	note B_,7, 2
	note A#,7
	note A_,7
	note G#,7
	note G_,7
	note F#,7
	snd_ret
SndCall_SFX_26_Ch2_1:
	note F_,7, 1
	note E_,7
	note D#,7
	note D_,7
	note C#,7
	note C_,7
	snd_ret
