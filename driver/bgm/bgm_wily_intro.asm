BGM_WilyIntro:
	dw BGM_WilyIntro_Ch1
	dw BGM_WilyIntro_Ch2
	dw BGM_WilyIntro_Ch3
	dw BGM_WilyIntro_Ch4

BGM_WilyIntro_Ch1:
	panning $FF
	timer_speed $C0
	duty_cycle $80
	envelope $C7
	octave $03
	note $AA
	note $94
	note $A4
	octave $04
	note $0A
	octave $03
	note $A4
	note $94
	note $AA
	note $94
	note $A4
	octave $04
	note $03
	octave $03
	note $A3
	note $93
	note $73
	note $3A
	note $A1
	wait $03
	note $A1
	note $33
	note $53
	note $73
	note $93
	note $A4
	note $A4
	note $A9
	wait $03 ;X
	chan_stop ;X

BGM_WilyIntro_Ch2:
	duty_cycle $40
	envelope $83
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	octave $06
	note $24
	note $24
	note $29
	wait $03 ;X
	chan_stop ;X
.sub0:
	octave $06
	note $34
	note $24
	note $04
	octave $05
	note $A4
	note $94
	note $A4
	octave $06
	note $04
	octave $05
	note $94
	ret

BGM_WilyIntro_Ch3:
	wave_noise_cutoff $E0
	wave_vol $20
	octave $01
	call .sub0
	call .sub0
	note $33
	note $33
	note $33
	note $33
	note $33
	note $33
	note $33
	note $33
	note $33
	note $33
	note $33
	note $33
	note $33
	note $33
	note $53
	note $53
	note $74
	note $74
	note $79
	wait $03 ;X
	chan_stop ;X
.sub0:
	note $73
	note $73
	note $73
	note $73
	note $73
	note $73
	note $73
	note $73
	ret

BGM_WilyIntro_Ch4:
	wave_noise_cutoff $01
	envelope $C1
	note $42
	note $42
	note $42
	note $42
	note $42
	note $42
	note $42
	note $42
	note $42
	note $42
	note $42
	note $42
	note $42
	note $42
	note $42
	note $42
	note $54
	note $54
	note $59
	wait $03 ;X
	chan_stop ;X


