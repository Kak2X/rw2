BGM_StageSelect:
	dw BGM_StageSelect_Ch1
	dw BGM_StageSelect_Ch2
	dw BGM_StageSelect_Ch3
	dw BGM_StageSelect_Ch4

BGM_StageSelect_Ch1:
	panning $FF
	timer_speed $DC
	duty_cycle $00
	envelope $A5
.loop0:
	octave $03
	note $33
	note $A3
	octave $04
	note $33
	octave $03
	note $33
	note $A3
	octave $04
	note $33
	octave $03
	note $33
	note $A3
	note $33
	note $A3
	octave $04
	note $33
	octave $03
	note $33
	note $A3
	octave $04
	note $33
	octave $03
	note $33
	note $A3
	call .sub0
	call .sub0
	call .sub1
	call .sub1
	call .sub2
	call .sub2
	jp .loop0
.sub0:
	octave $02
	note $B3
	octave $03
	note $63
	note $B3
	octave $02
	note $B3
	octave $03
	note $63
	note $B3
	octave $02
	note $B3
	octave $03
	note $63
	ret
.sub1:
	note $13
	note $83
	octave $04
	note $13
	octave $03
	note $13
	note $83
	octave $04
	note $13
	octave $03
	note $13
	note $83
	ret
.sub2:
	octave $02
	note $A3
	octave $03
	note $53
	note $A3
	octave $02
	note $A3
	octave $03
	note $53
	note $A3
	octave $02
	note $A3
	octave $03
	note $53
	ret

BGM_StageSelect_Ch2:
	duty_cycle $00
	envelope $A3
.loop0:
	octave $04
	note $33
	note $63
	note $A3
	note $33
	note $63
	note $A3
	note $33
	note $63
	note $33
	note $63
	note $83
	note $33
	note $A3
	note $83
	note $63
	note $83
	note $33
	note $63
	note $A3
	note $33
	note $63
	note $A3
	note $33
	note $63
	note $33
	note $63
	note $83
	note $33
	note $A3
	note $83
	note $63
	note $83
	note $33
	note $63
	note $A3
	note $33
	note $63
	note $A3
	note $33
	note $63
	note $33
	note $63
	note $83
	note $33
	note $A3
	note $83
	note $63
	note $83
	note $23
	note $33
	note $53
	note $23
	note $33
	note $53
	note $23
	note $33
	note $23
	note $33
	note $53
	note $63
	note $33
	note $53
	note $63
	note $83
	jp .loop0

BGM_StageSelect_Ch3:
	wave_noise_cutoff $E0
	wave_vol $20
.loop0:
	octave $04
	note $32
	note $52
	note $62
	note $33
	note $53
	silence $03
	note $62
	note $32
	note $52
	note $63
	note $32
	note $52
	note $62
	note $33
	note $53
	silence $03
	note $62
	note $32
	note $52
	note $63
	note $32
	note $52
	note $62
	note $33
	note $53
	silence $03
	note $62
	note $32
	note $52
	note $63
	note $22
	note $32
	note $52
	note $23
	note $33
	silence $03
	note $52
	note $22
	note $32
	note $53
	jp .loop0

BGM_StageSelect_Ch4:
	wave_noise_cutoff $01
	envelope $F1
.loop0:
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	call .sub0
	jp .loop0
.sub0:
	note $03
	note $03
	note $03
	note $03
	note $03
	note $03
	note $03
	note $03
	ret


