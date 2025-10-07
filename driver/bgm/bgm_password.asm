BGM_Password:
	dw BGM_Password_Ch1
	dw BGM_Password_Ch2
	dw BGM_Password_Ch3
	dw BGM_Password_Ch4

BGM_Password_Ch1:
	panning $FF
	timer_speed $C8
	duty_cycle $00
	envelope $C5
.loop0:
	octave $03
	note $A0
	note $89
	note $A2
	note $60
	note $5A
	wait $05
	note $11
	wait $0C
	wait $00
	note $89
	note $A2
	note $60
	note $5A
	wait $05
	note $11
	wait $0C
	note $12
	note $12
	note $53
	wait $05
	note $62
	note $8C
	note $83
	wait $05
	note $62
	note $52
	note $12
	note $5C
	note $63
	wait $05
	note $82
	note $A1
	wait $0C
	wait $00
	note $A2
	note $12
	note $53
	wait $05
	note $62
	note $8C
	wait $03
	wait $05
	note $62
	note $52
	note $12
	note $5C
	note $62
	note $83
	wait $05
	note $61
	wait $0C
	note $60
	jp .loop0

BGM_Password_Ch2:
	duty_cycle $80
	envelope $83
.loop0:
	octave $04
	call .sub0
	call .sub1
	call .sub0
	call .sub1
	call .sub0
	call .sub1
	call .sub0
	call .sub1
	call .sub2
	call .sub3
	call .sub2
	call .sub3
	jp .loop0
.sub0:
	note $63
	wait $05
	note $1C
	note $63
	wait $05
	note $1C
	note $63
	wait $05
	note $1C
	note $63
	wait $05
	note $1C
	ret
.sub1:
	note $53
	wait $05
	note $1C
	note $53
	wait $05
	note $1C
	note $53
	wait $05
	note $1C
	note $53
	wait $05
	note $1C
	ret
.sub2:
	note $63
	wait $05
	note $1C
	note $63
	wait $05
	note $8C
	note $63
	wait $05
	note $1C
	note $63
	wait $05
	note $8C
	note $63
	wait $05
	note $1C
	note $63
	wait $05
	note $8C
	note $63
	wait $05
	note $1C
	note $63
	wait $05
	note $8C
	ret
.sub3:
	note $A3
	wait $05
	note $1C
	note $63
	wait $05
	note $8C
	note $A3
	wait $05
	note $1C
	note $63
	wait $05
	note $AC
	note $A3
	wait $05
	note $1C
	note $63
	wait $05
	note $8C
	note $A3
	wait $05
	note $1C
	note $53
	wait $05
	note $6C
	ret

BGM_Password_Ch3:
	wave_noise_cutoff $E0
	wave_vol $20
.loop0:
	octave $02
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	octave $01
	call .sub1
	note $A2
	note $A2
	note $A2
	note $A2
	note $A2
	note $A2
	note $A2
	note $A2
	call .sub1
	octave $02
	note $12
	note $12
	note $12
	note $12
	note $12
	note $12
	note $12
	note $12
	jp .loop0
.sub0:
	note $62
	note $62
	note $62
	note $62
	note $12
	note $12
	note $12
	note $12
	ret
.sub1:
	note $B2
	note $B2
	note $B2
	note $B2
	note $B2
	note $B2
	note $B2
	note $B2
	ret

BGM_Password_Ch4:
	wave_noise_cutoff $01
.loop0:
	envelope $F1
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	call .sub1
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	call .sub1
	jp .loop0
.sub0:
	note $03
	note $05
	note $0C
	note $03
	note $05
	note $0C
	note $03
	note $05
	note $0C
	note $03
	note $05
	note $0C
	ret
.sub1:
	note $03
	note $05
	note $0C
	note $03
	note $05
	note $0C
	note $03
	note $05
	note $0C
	note $0C
	note $04
	note $0C
	ret


