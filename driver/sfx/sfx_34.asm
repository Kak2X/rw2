SndHeader_SFX_34:
	db $04 ; Number of channels
.ch1:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH1_PTR ; Sound channel ptr
	dw SndData_SFX_34_Ch1 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch2:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH2_PTR ; Sound channel ptr
	dw SndData_SFX_34_Ch2 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
.ch3:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH3_PTR ; Sound channel ptr
	dw SndData_SFX_34_Ch3 ; Data ptr
	db -5 ; Initial fine tune
	db $81 ; Unused
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_34_Ch4 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Unused
SndData_SFX_34_Ch1:
	envelope $F8
	panning $11
	duty_cycle 3
	vibrato_on $09
	note G#,4, 1
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
	envelope $F7
	note G#,5, 120
	chan_stop
SndData_SFX_34_Ch2:
	envelope $A8
	panning $22
	duty_cycle 3
	vibrato_on $09
	silence 6
	note G#,4, 1
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
	envelope $F7
	note G#,5, 120
	chan_stop
SndData_SFX_34_Ch3:
	wave_vol $C0
	panning $44
	wave_id $06
	vibrato_on $09
	note G#,4, 1
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
	note G#,5, 80
	chan_stop
SndData_SFX_34_Ch4:
	envelope $F8
	panning $88
	note4 A#,4,0, 2
	lock_envelope
	note4 F#,4,0, 2
	note4 G#,4,0, 3
	note4 A_,4,0, 3
	note4 A#,4,0, 3
	note4 B_,4,0, 3
	note4x $53, 3 ; Nearest: G#,4,0
	note4x $52, 3 ; Nearest: A_,4,0
	note4x $61, 4 ; Nearest: A#,4,0
	unlock_envelope
	envelope $F7
	note4x $62, 120 ; Nearest: A_,4,0
	chan_stop
