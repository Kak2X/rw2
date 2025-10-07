BGM_StageClear:
	dw BGM_StageClear_Ch1
	dw BGM_StageClear_Ch2
	dw BGM_StageClear_Ch3
	dw BGM_StageClear_Ch4

BGM_StageClear_Ch1:
	panning $FF
	timer_speed $C4
	duty_cycle $C0
	envelope $C3
	octave $04
	note $13
	note $54
	note $14
	note $54
	note $64
	note $84
	octave $05
	note $04
	note $11
	chan_stop

BGM_StageClear_Ch2:
	duty_cycle $80
	envelope $C3
	octave $05
	note $14
	note $54
	note $64
	note $84
	note $54
	note $64
	note $84
	octave $06
	note $04
	octave $04
	note $84
	note $84
	note $8A
	chan_stop

BGM_StageClear_Ch3:
	wave_noise_cutoff $E0
	wave_vol $20
	octave $02
	note $81
	note $54
	note $54
	note $5A
	chan_stop

BGM_StageClear_Ch4:
	wave_noise_cutoff $01
	envelope $C1
	note $44
	note $44
	note $44
	note $44
	note $44
	note $44
	note $44
	note $44
	note $45
	note $45
	note $45
	note $45
	note $45
	note $45
	note $45
	note $45
	note $45
	note $45
	note $45
	note $45
	note $45
	note $45
	note $45
	note $45
	chan_stop


