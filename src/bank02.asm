L024000:;C
	ld   h, $CD
	ld   a, [$CF37]
L024005:;R
	ld   [$CF2F], a
	ld   l, a
	ld   a, [hl]
	or   a
	jr   z, L024045
	push hl
	push hl
	ld   de, $FFA0
	ld   b, $10
L024014:;R
	ldi  a, [hl]
	ld   [de], a
	inc  de
	dec  b
	jr   nz, L024014
	ld   a, $00
	ld   [$CF38], a
	call L002421
	ldh  a, [$FFA0]
	bit  7, a
	jr   z, L024038
	call L02405B
	ldh  a, [$FFA0]
	bit  7, a
	jr   z, L024038
	ldh  a, [$FF97]
	cp   $A0
	call c, L00244C
L024038:;R
	pop  de
	ld   hl, $FFA0
	ld   b, $10
L02403E:;R
	ldi  a, [hl]
	ld   [de], a
	inc  de
	dec  b
	jr   nz, L02403E
	pop  hl
L024045:;R
	ld   a, [$CF37]
	ld   b, a
	ld   a, l
	add  a, $10
	cp   a, b
	jr   nz, L024005
	ldh  a, [$FF97]
	cp   $A0
	ret  nz
	ld   a, [$CF30]
	ld   [$CF37], a
	ret  
L02405B:;C
	ldh  a, [$FFA0]
	and  a, $7F
	rst  $00
L024060: db $60
L024061: db $41
L024062: db $92
L024063: db $41
L024064: db $92
L024065: db $41
L024066: db $92
L024067: db $41
L024068: db $92
L024069: db $41
L02406A: db $92
L02406B: db $41
L02406C: db $92
L02406D: db $41
L02406E: db $27
L02406F: db $42
L024070: db $46
L024071: db $42
L024072: db $EC
L024073: db $42
L024074: db $8A
L024075: db $43
L024076: db $F9
L024077: db $43
L024078: db $7C
L024079: db $44
L02407A: db $08
L02407B: db $45
L02407C: db $52
L02407D: db $45
L02407E: db $F3
L02407F: db $45
L024080: db $AA
L024081: db $46
L024082: db $F5
L024083: db $46
L024084: db $6A
L024085: db $47
L024086: db $CC
L024087: db $47
L024088: db $17
L024089: db $48
L02408A: db $86
L02408B: db $48
L02408C: db $A8
L02408D: db $48
L02408E: db $CD
L02408F: db $48
L024090: db $5F
L024091: db $49
L024092: db $9B
L024093: db $49
L024094: db $F8
L024095: db $49
L024096: db $4E
L024097: db $4A
L024098: db $DA
L024099: db $4A
L02409A: db $89
L02409B: db $4B
L02409C: db $CA
L02409D: db $4B
L02409E: db $E7;X
L02409F: db $4B;X
L0240A0: db $EA
L0240A1: db $4B
L0240A2: db $EA
L0240A3: db $4B
L0240A4: db $EA
L0240A5: db $4B
L0240A6: db $EA
L0240A7: db $4B
L0240A8: db $79
L0240A9: db $4C
L0240AA: db $37
L0240AB: db $4D
L0240AC: db $DC
L0240AD: db $4D
L0240AE: db $7E
L0240AF: db $4E
L0240B0: db $3D
L0240B1: db $4F
L0240B2: db $44
L0240B3: db $4F
L0240B4: db $0E
L0240B5: db $50
L0240B6: db $2F
L0240B7: db $50
L0240B8: db $70
L0240B9: db $50
L0240BA: db $70
L0240BB: db $50
L0240BC: db $70
L0240BD: db $50
L0240BE: db $69
L0240BF: db $51
L0240C0: db $F2
L0240C1: db $52
L0240C2: db $71
L0240C3: db $53
L0240C4: db $BB
L0240C5: db $53
L0240C6: db $13
L0240C7: db $54
L0240C8: db $BE
L0240C9: db $54
L0240CA: db $F2
L0240CB: db $54
L0240CC: db $A5
L0240CD: db $55
L0240CE: db $27
L0240CF: db $56
L0240D0: db $5C
L0240D1: db $56
L0240D2: db $15
L0240D3: db $57
L0240D4: db $07
L0240D5: db $58
L0240D6: db $80
L0240D7: db $58
L0240D8: db $3C
L0240D9: db $59
L0240DA: db $78
L0240DB: db $59
L0240DC: db $D0
L0240DD: db $59
L0240DE: db $3F
L0240DF: db $5A
L0240E0: db $53
L0240E1: db $5A
L0240E2: db $C9
L0240E3: db $5A
L0240E4: db $FC
L0240E5: db $5A
L0240E6: db $DF
L0240E7: db $5B
L0240E8: db $72
L0240E9: db $5C
L0240EA: db $A5
L0240EB: db $5C
L0240EC: db $FA
L0240ED: db $5C
L0240EE: db $A0
L0240EF: db $5D
L0240F0: db $1C
L0240F1: db $5E
L0240F2: db $44
L0240F3: db $5E
L0240F4: db $BD
L0240F5: db $5E
L0240F6: db $1F
L0240F7: db $5F
L0240F8: db $80
L0240F9: db $5F
L0240FA: db $CE
L0240FB: db $5F
L0240FC: db $0D
L0240FD: db $60
L0240FE: db $4B
L0240FF: db $60
L024100: db $81
L024101: db $60
L024102: db $CB
L024103: db $61
L024104: db $FB
L024105: db $62
L024106: db $76
L024107: db $64
L024108: db $19
L024109: db $66
L02410A: db $60
L02410B: db $66
L02410C: db $83
L02410D: db $66
L02410E: db $F0
L02410F: db $66
L024110: db $71
L024111: db $67
L024112: db $A6
L024113: db $67
L024114: db $BD
L024115: db $67
L024116: db $2D
L024117: db $68
L024118: db $44
L024119: db $68
L02411A: db $6E
L02411B: db $68
L02411C: db $99
L02411D: db $68
L02411E: db $60;X
L02411F: db $41;X
L024120: db $10
L024121: db $6A
L024122: db $59
L024123: db $6A
L024124: db $3F
L024125: db $6B
L024126: db $3B
L024127: db $6C
L024128: db $18
L024129: db $6E
L02412A: db $78
L02412B: db $6E
L02412C: db $79
L02412D: db $6E
L02412E: db $3B
L02412F: db $6F
L024130: db $41
L024131: db $6F
L024132: db $F7
L024133: db $70
L024134: db $AD
L024135: db $71
L024136: db $DD
L024137: db $72
L024138: db $24
L024139: db $74
L02413A: db $F3
L02413B: db $74
L02413C: db $EA
L02413D: db $75
L02413E: db $38
L02413F: db $77
L024140: db $89
L024141: db $78
L024142: db $03
L024143: db $79
L024144: db $54
L024145: db $79
L024146: db $9D
L024147: db $79
L024148: db $B4
L024149: db $79
L02414A: db $F3
L02414B: db $79
L02414C: db $11
L02414D: db $7A
L02414E: db $74
L02414F: db $7A
L024150: db $40
L024151: db $7B
L024152: db $5A
L024153: db $7B
L024154: db $92
L024155: db $7B
L024156: db $AF
L024157: db $7B
L024158: db $CD
L024159: db $7B
L02415A: db $D9
L02415B: db $7B
L02415C: db $FA
L02415D: db $7B
L02415E: db $11
L02415F: db $7C
L024160:;I
	ldh  a, [$FFA1]
	and  a, $7F
	rst  $00
L024165: db $69
L024166: db $41
L024167: db $7C
L024168: db $41
L024169:;I
	ld   h, $CE
	ld   a, [$CF2F]
	ld   l, a
	inc  l
	ldh  a, [$FFA7]
	sub  a, [hl]
	ldh  [$FFA7], a
	ld   a, $04
	ldh  [$FF99], a
	jp   L001EB1
L02417C:;I
	ldh  a, [$FFA2]
	add  a, $02
	and  a, $1F
	ldh  [$FFA2], a
	srl  a
	srl  a
	srl  a
	and  a, $03
	cp   $03
	ret  nz
	jp   L00242F
L024192:;I
	ldh  a, [$FFA1]
	rst  $00
L024195: db $A3
L024196: db $41
L024197: db $A9
L024198: db $41
L024199: db $C8
L02419A: db $41
L02419B: db $EB
L02419C: db $41
L02419D: db $F7
L02419E: db $41
L02419F: db $03
L0241A0: db $42
L0241A1: db $16
L0241A2: db $42
L0241A3:;I
	ld   c, $01
	call L001F43
	ret  
L0241A9:;I
	ld   h, $CE
	ld   a, [$CF2F]
	ld   l, a
	inc  l
	ldh  a, [$FFA7]
	sub  a, [hl]
	ldh  [$FFA7], a
	ld   c, $01
	call L001F43
	ld   bc, $0300
	call L001E95
	ld   b, $00
	call L001F16
	jp   L001EB1
L0241C8:;I
	ld   c, $01
	call L001F43
	ldh  a, [$FFAA]
	ld   c, a
	ldh  a, [$FFAB]
	ld   b, a
	ldh  a, [$FFA6]
	sub  a, c
	ldh  a, [$FFA7]
	sbc  a, b
	and  a, $F0
	cp   $00
	jr   z, L0241E3
	call L002328
	ret  c
L0241E3:;R
	ld   b, $06
	call L001F16
	jp   L001EB1
L0241EB:;I
	ld   c, $01
	call L001F43
	call L0023A8
	ret  c
	jp   L001EB1
L0241F7:;I
	ld   c, $01
	call L001F43
	ld   a, $B4
	ldh  [$FFAC], a
	jp   L001EB1
L024203:;I
	ld   c, $01
	call L001F43
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $78
	ldh  [$FFAC], a
	jp   L001EB1
L024216:;I
	ld   bc, $0302
	call L001F5F
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	xor  a
	ldh  [$FFA0], a
	ret  
L024227:;I
	ldh  a, [$FFA1]
	rst  $00
L02422A: db $2E
L02422B: db $42
L02422C: db $39
L02422D: db $42
L02422E:;I
	ld   a, [$CF60]
	cp   $01
	call nz, L0020D8
	jp   L001EB1
L024239:;I
	ld   bc, $0301
	call L001F5F
	call L002150
	call L00220A
	ret  
L024246:;I
	ldh  a, [$FFA1]
	rst  $00
L024249: db $55
L02424A: db $42
L02424B: db $64
L02424C: db $42
L02424D: db $8C
L02424E: db $42
L02424F: db $AD
L024250: db $42
L024251: db $C8
L024252: db $42
L024253: db $E3
L024254: db $42
L024255:;I
	ld   a, $09
	ld   bc, $000C
	call L001D35
	ret  c
	ld   a, l
	ldh  [$FFAD], a
	jp   L001EB1
L024264:;I
	call L001DE4
	ret  c
	ld   c, $02
	call L001F43
	call L001ED7
	ld   bc, $0200
	call L001E8E
	ld   bc, $0020
	call L001E95
	ld   b, $10
	ldh  a, [$FFA2]
	bit  7, a
	jr   z, L024286
	ld   b, $90
L024286:;R
	ld   a, b
	ldh  [$FFAC], a
	jp   L001EB1
L02428C:;I
	call L001DE4
	ret  c
	ld   c, $02
	call L001F43
	call L002150
	ldh  a, [$FFA5]
	and  a, $F0
	ld   b, a
	ldh  a, [$FFAC]
	and  a, $F0
	cp   a, b
	ret  nz
	call L001E9C
	ld   a, $00
	ldh  [$FFAC], a
	jp   L001EB1
L0242AD:;I
	call L001DE4
	ret  c
	ld   c, $02
	call L001F43
	call L00220A
	ldh  a, [$FFAC]
	add  a, $01
	ldh  [$FFAC], a
	cp   $14
	ret  nz
	call L001EA3
	jp   L001EB1
L0242C8:;I
	call L001DE4
	ret  c
	ld   c, $02
	call L001F43
	call L00220A
	ldh  a, [$FFAC]
	add  a, $01
	ldh  [$FFAC], a
	cp   $28
	ret  nz
	call L001E9C
	jp   L001EB1
L0242E3:;I
	ld   c, $02
	call L001F43
	call L002150
	ret  
L0242EC:;I
	ldh  a, [$FFA1]
	rst  $00
L0242EF: db $F9
L0242F0: db $42
L0242F1: db $18
L0242F2: db $43
L0242F3: db $2D
L0242F4: db $43
L0242F5: db $3F
L0242F6: db $43
L0242F7: db $56
L0242F8: db $43
L0242F9:;I
	call L001ED7
	ld   bc, $0200
	call L001E8E
	ld   bc, $0020
	call L001E95
	ld   b, $10
	ldh  a, [$FFA2]
	bit  7, a
	jr   z, L024312
	ld   b, $90
L024312:;R
	ld   a, b
	ldh  [$FFAC], a
	jp   L001EB1
L024318:;I
	call L002150
	ldh  a, [$FFA5]
	and  a, $F0
	ld   b, a
	ldh  a, [$FFAC]
	and  a, $F0
	cp   a, b
	ret  nz
	ld   a, $00
	ldh  [$FFAC], a
	jp   L001EB1
L02432D:;I
	call L00220A
	ldh  a, [$FFAC]
	add  a, $01
	ldh  [$FFAC], a
	cp   $14
	ret  nz
	call L001EA3
	jp   L001EB1
L02433F:;I
	call L00220A
	ldh  a, [$FFAC]
	add  a, $01
	ldh  [$FFAC], a
	cp   $28
	ret  nz
	xor  a
	ldh  [$FFA2], a
	xor  a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	jp   L001EB1
L024356:;I
	call L0023A8
	ret  c
	xor  a
	ldh  [$FFA0], a
	ld   a, $0A
	ld   bc, $F0F0
	call L001D35
	ret  c
	ld   a, $0A
	ld   bc, $10F0
	call L001D35
	ret  c
	ld   a, $0A
	ld   bc, $F010
	call L001D35
	ret  c
	ld   a, $0A
	ld   bc, $1010
	call L001D35
	ret  c
	ld   a, $0A
	ld   bc, $0000
	call L001D35
	ret  
L02438A:;I
	ldh  a, [$FFA1]
	rst  $00
L02438D: db $93
L02438E: db $43
L02438F: db $A9
L024390: db $43
L024391: db $D2
L024392: db $43
L024393:;I
	ldh  a, [$FFA2]
	add  a, $02
	and  a, $1F
	ldh  [$FFA2], a
	srl  a
	srl  a
	srl  a
	and  a, $03
	cp   $03
	ret  nz
	jp   L001EB1
L0243A9:;I
	ld   a, $03
	ld   [$CF38], a
	ld   c, $02
	call L001F43
	call L001FB9
	ld   a, [$CF52]
	ld   b, a
	ld   a, [$CF53]
	or   a, b
	cp   $10
	jr   c, L0243CC
	call L0020CB
	call L002150
	call L00220A
	ret  
L0243CC:;R
	call L002038
	jp   L001EB1
L0243D2:;I
	ld   a, $03
	ld   [$CF38], a
	ld   c, $02
	call L001F43
	ldh  a, [$FFAC]
	add  a, $01
	ldh  [$FFAC], a
	cp   $B0
	jr   c, L0243EA
	ld   a, $01
	ldh  [$FFA1], a
L0243EA:;R
	ld   a, $02
	call L002047
	call L0020CB
	call L002150
	call L00220A
	ret  
L0243F9:;I
	ldh  a, [$FFA1]
	rst  $00
L0243FC: db $06
L0243FD: db $44
L0243FE: db $1A
L0243FF: db $44
L024400: db $2F
L024401: db $44
L024402: db $47
L024403: db $44
L024404: db $60
L024405: db $44
L024406:;I
	ld   b, $00
	call L001F16
	ldh  a, [$FFA5]
	add  a, $08
	ldh  [$FFA5], a
	ld   bc, $0200
	call L001E95
	jp   L001EB1
L02441A:;I
	ld   a, [$CF16]
	ld   b, a
	ldh  a, [$FFA7]
	sub  a, b
	ret  c
	call L001EBB
	cp   $14
	ret  nc
	ld   a, $1E
	ldh  [$FFAC], a
	jp   L001EB1
L02442F:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $01
	call L001F34
	ld   b, $03
	call L001F16
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L024447:;I
	call L00220A
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $02
	call L001F34
	call L001EA3
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L024460:;I
	call L00220A
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $00
	call L001F34
	ld   b, $00
	call L001F16
	call L001EA3
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L02447C:;I
	ldh  a, [$FFA1]
	rst  $00
L02447F: db $85
L024480: db $44
L024481: db $A0
L024482: db $44
L024483: db $EC
L024484: db $44
L024485:;I
	ld   a, $0D
	ld   bc, $00E2
	call L001D35
	ld   a, l
	ldh  [$FFAD], a
	add  a, $08
	ld   l, a
	ld   a, $00
	ldi  [hl], a
	ld   a, $02
	ld   [hl], a
	ld   a, $00
	ldh  [$FFAC], a
	jp   L001EB1
L0244A0:;I
	call L001DE4
	ret  c
	ld   c, $01
	call L001F43
	call L001ED7
	ld   h, $CD
	ldh  a, [$FFAD]
	inc  a
	inc  a
	ld   l, a
	ldh  a, [$FFA2]
	and  a, $80
	ld   b, a
	ld   a, [hl]
	and  a, $7F
	or   a, b
	ld   [hl], a
	ldh  a, [$FFAC]
	add  a, $01
	ldh  [$FFAC], a
	ld   b, $03
	cp   $5A
	jr   z, L0244D9
	cp   $3C
	jr   c, L0244D4
	ld   a, $02
	ld   [$CF38], a
	ld   b, $02
L0244D4:;R
	ld   b, b
	call L001F16
	ret  
L0244D9:;R
	ld   a, $00
	ldh  [$FFAC], a
	call L001EAA
	ld   h, $CD
	ldh  a, [$FFAD]
	inc  a
	ld   l, a
	ld   a, $01
	ldi  [hl], a
	jp   L001EB1
L0244EC:;I
	call L001DE4
	ret  c
	ld   a, $04
	ld   [$CF38], a
	ldh  a, [$FFAC]
	add  a, $01
	ldh  [$FFAC], a
	cp   $3C
	ret  nz
	ld   b, $03
	call L001F16
	ld   a, $00
	ldh  [$FFA1], a
	ret  
L024508:;I
	ldh  a, [$FFA1]
	rst  $00
L02450B: db $11
L02450C: db $45
L02450D: db $17
L02450E: db $45
L02450F: db $44
L024510: db $45
L024511:;I
	ld   c, $02
	call L001F51
	ret  
L024517:;I
	ld   a, $00
	call L001F34
	ld   a, $04
	ld   [$CF38], a
	ld   b, $02
	call L001F16
	ldh  a, [$FFA7]
	add  a, $12
	ldh  [$FFA7], a
	ldh  a, [$FFA2]
	bit  7, a
	jr   nz, L02453B
	ldh  a, [$FFA5]
	sub  a, $18
	ldh  [$FFA5], a
	jp   L001EB1
L02453B:;R
	ldh  a, [$FFA5]
	add  a, $18
	ldh  [$FFA5], a
	jp   L001EB1
L024544:;I
	ld   c, $01
	call L001F43
	ld   a, $04
	ld   [$CF38], a
	call L002150
	ret  
L024552:;I
	ldh  a, [$FFA1]
	rst  $00
L024555: db $63
L024556: db $45
L024557: db $7A
L024558: db $45
L024559: db $98
L02455A: db $45
L02455B: db $B6
L02455C: db $45
L02455D: db $C2
L02455E: db $45
L02455F: db $D7
L024560: db $45
L024561: db $E4
L024562: db $45
L024563:;I
	ld   c, $01
	call L001F43
	call L001ED7
	call L001EBB
	cp   $40
	ret  nc
	ld   bc, $0400
	call L001E95
	jp   L001EB1
L02457A:;I
	ld   c, $01
	call L001F43
	call L001ED7
	call L00220A
	ldh  a, [$FFA5]
	ld   [$CF0D], a
	ldh  a, [$FFA7]
	sub  a, $18
	ld   [$CF0E], a
	call L00332F
	ret  c
	jp   L001EB1
L024598:;I
	ld   c, $01
	call L001F51
	ld   a, $02
	ld   [$CF38], a
	call L001ED7
	call L001EBB
	cp   $10
	ret  nc
	call L001EAA
	xor  a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	jp   L001EB1
L0245B6:;I
	ld   a, $06
	ld   [$CF38], a
	call L0023A8
	ret  c
	jp   L001EB1
L0245C2:;I
	xor  a
	ldh  [$FFA2], a
	call L001ED7
	ld   bc, $0180
	call L001E8E
	ld   bc, $0300
	call L001E95
	jp   L001EB1
L0245D7:;I
	call L002180
	call nc, L001E9C
	call L002328
	ret  c
	jp   L001EB1
L0245E4:;I
	call L002180
	call nc, L001E9C
	call L0023A8
	ret  c
	ld   a, $04
	ldh  [$FFA1], a
	ret  
L0245F3:;I
	ldh  a, [$FFA1]
	rst  $00
L0245F6: db $06
L0245F7: db $46
L0245F8: db $1D
L0245F9: db $46
L0245FA: db $27
L0245FB: db $46
L0245FC: db $3C
L0245FD: db $46
L0245FE: db $54
L0245FF: db $46
L024600: db $65
L024601: db $46
L024602: db $73
L024603: db $46
L024604: db $A1
L024605: db $46
L024606:;I
	ld   bc, $0080
	call L001E8E
	ld   b, $03
	call L001F16
	ld   a, $00
	call L001F34
	ld   a, $3C
	ldh  [$FFAC], a
	jp   L001EB1
L02461D:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	jp   L001EB1
L024627:;I
	call L001ED7
	call L001EBB
	cp   $40
	ret  nc
	ld   a, $01
	call L001F34
	ld   a, $08
	ldh  [$FFAC], a
	jp   L001EB1
L02463C:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $02
	call L001F34
	ld   b, $02
	call L001F16
	ld   a, $14
	ldh  [$FFAC], a
	jp   L001EB1
L024654:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	call L027C64
	ld   a, $3C
	ldh  [$FFAC], a
	jp   L001EB1
L024665:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $30
	ldh  [$FFAC], a
	jp   L001EB1
L024673:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	jr   nz, L024680
	ld   a, $00
	ldh  [$FFA1], a
	ret  
L024680:;R
	ld   a, $03
	ld   [$CF38], a
	ld   c, $01
	call L001F43
	call L002180
	jp   nc, L001E9C
	call L002117
	ld   a, [$CF26]
	cp   $03
	ret  nz
	xor  a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	jp   L001EB1
L0246A1:;I
	call L0023A8
	ret  c
	ld   a, $00
	ldh  [$FFA1], a
	ret  
L0246AA:;I
	ldh  a, [$FFA1]
	rst  $00
L0246AD: db $B3
L0246AE: db $46
L0246AF: db $BC
L0246B0: db $46
L0246B1: db $DA
L0246B2: db $46
L0246B3:;I
	ld   bc, $0080
	call L001E8E
	jp   L001EB1
L0246BC:;I
	ld   c, $01
	call L001F43
	call L002180
	jp   nc, L001E9C
	call L0020F1
	jp   c, L001E9C
	call L000755
	cp   $08
	ret  nc
	ld   a, $1E
	ldh  [$FFAC], a
	jp   L001EB1
L0246DA:;I
	ld   c, $01
	call L001F43
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	jp   z, L001EB6
	ldh  a, [$FFAC]
	ld   hl, $FFA5
	bit  2, a
	jr   z, L0246F3
	dec  [hl]
	ret  
L0246F3:;R
	inc  [hl]
	ret  
L0246F5:;I
	ldh  a, [$FFA1]
	rst  $00
L0246F8: db $02
L0246F9: db $47
L0246FA: db $1F
L0246FB: db $47
L0246FC: db $3C
L0246FD: db $47
L0246FE: db $4E
L0246FF: db $47
L024700: db $5B
L024701: db $47
L024702:;I
	ld   bc, $0080
	call L001E8E
	ld   bc, $0300
	call L001E95
	ld   b, $03
	call L001F16
	ld   a, $00
	call L001F34
	ld   a, $3C
	ldh  [$FFAC], a
	jp   L001EB1
L02471F:;I
	ld   c, $01
	call L001F43
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   b, $02
	call L001F16
	ld   a, $02
	call L001F34
	ld   a, $14
	ldh  [$FFAC], a
	jp   L001EB1
L02473C:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $03
	call L001F34
	call L001ED7
	jp   L001EB1
L02474E:;I
	call L002180
	call nc, L001E9C
	call L002328
	ret  c
	jp   L001EB1
L02475B:;I
	call L002180
	call nc, L001E9C
	call L0023A8
	ret  c
	ld   a, $00
	ldh  [$FFA1], a
	ret  
L02476A:;I
	ldh  a, [$FFA1]
	rst  $00
L02476D: db $77
L02476E: db $47
L02476F: db $83
L024770: db $47
L024771: db $8F
L024772: db $47
L024773: db $9E
L024774: db $47
L024775: db $C0
L024776: db $47
L024777:;I
	call L001ED7
	ldh  a, [$FFA5]
	add  a, $08
	ldh  [$FFA5], a
	jp   L001EB1
L024783:;I
	ld   c, $02
	call L001F43
	ld   a, $3C
	ldh  [$FFAC], a
	jp   L001EB1
L02478F:;I
	ld   c, $02
	call L001F43
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	jp   L001EB1
L02479E:;I
	ld   a, $13
	call L001E63
	ld   a, b
	cp   $03
	ret  nc
	ld   a, $13
	ld   bc, $0000
	call L001D35
	jr   c, L0247B4
	call L001E7C
L0247B4:;X
	ld   a, $02
	call L001F34
	ld   a, $0C
	ldh  [$FFAC], a
	jp   L001EB1
L0247C0:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L0247CC:;I
	ldh  a, [$FFA1]
	rst  $00
L0247CF: db $D5
L0247D0: db $47
L0247D1: db $E2
L0247D2: db $47
L0247D3: db $09
L0247D4: db $48
L0247D5:;I
	ld   bc, $0180
	call L001E8E
	ld   a, $B4
	ldh  [$FFAC], a
	jp   L001EB1
L0247E2:;I
	ld   c, $02
	call L001F43
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	jr   nz, L0247F2
	jp   L001E11
L0247F2:;R
	call L002180
	call nc, L001E9C
	call L002117
	ld   a, [$CF26]
	cp   $03
	ret  nz
	xor  a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	jp   L001EB1
L024809:;I
	ld   c, $02
	call L001F43
	call L0023A8
	ret  c
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L024817:;I
	ldh  a, [$FFA1]
	rst  $00
L02481A: db $24
L02481B: db $48
L02481C: db $3F
L02481D: db $48
L02481E: db $4C
L02481F: db $48
L024820: db $62
L024821: db $48
L024822: db $75
L024823: db $48
L024824:;I
	ld   bc, $0100
	call L001E8E
	ld   bc, $0200
	call L001E95
	call L001ED7
	ld   a, $02
	call L001F34
	ld   a, $5A
	ldh  [$FFAC], a
	jp   L001EB1
L02483F:;I
	call L002180
	call nc, L001E9C
	call L002328
	ret  c
	jp   L001EB1
L02484C:;I
	call L002180
	call nc, L001E9C
	call L0023A8
	ret  c
	ld   a, $00
	call L001F34
	ld   a, $0C
	ldh  [$FFAC], a
	jp   L001EB1
L024862:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $01
	call L001F34
	ld   a, $0C
	ldh  [$FFAC], a
	jp   L001EB1
L024875:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $00
	call L001F34
	ld   a, $00
	ldh  [$FFA1], a
	ret  
L024886:;I
	ldh  a, [$FFA1]
	rst  $00
L024889: db $8D
L02488A: db $48
L02488B: db $96
L02488C: db $48
L02488D:;I
	ld   bc, $0080
	call L001E95
	jp   L001EB1
L024896:;I
	ld   c, $04
	call L001F51
	call L00220A
	ldh  a, [$FFA7]
	cp   $10
	ret  nz
	ld   a, $9F
	ldh  [$FFA7], a
	ret  
L0248A8:;I
	ldh  a, [$FFA1]
	rst  $00
L0248AB: db $AF
L0248AC: db $48
L0248AD: db $BB
L0248AE: db $48
L0248AF:;I
	ld   bc, $0080
	call L001E95
	call L001EA3
	jp   L001EB1
L0248BB:;I
	ld   c, $04
	call L001F51
	call L00220A
	ldh  a, [$FFA7]
	cp   $9F
	ret  nz
	ld   a, $10
	ldh  [$FFA7], a
	ret  
L0248CD:;I
	ldh  a, [$FFA1]
	rst  $00
L0248D0: db $DC
L0248D1: db $48
L0248D2: db $E2
L0248D3: db $48
L0248D4: db $EC
L0248D5: db $48
L0248D6: db $16
L0248D7: db $49
L0248D8: db $2D
L0248D9: db $49
L0248DA: db $51
L0248DB: db $49
L0248DC:;I
	call L027E4C
	jp   L001EB1
L0248E2:;I
	call L027E55
	ret  c
	xor  a
	ldh  [$FFAD], a
	jp   L001EB1
L0248EC:;I
	call L027E55
	ret  c
	ld   c, $01
	call L001F43
	ld   a, $18
	call L001E63
	ld   a, b
	or   a
	ret  nz
	ld   a, $19
	call L001E63
	ld   a, b
	or   a
	ret  nz
	ld   a, $1E
	ldh  [$FFAC], a
	ldh  a, [$FFAD]
	xor  $01
	ldh  [$FFAD], a
	or   a
	jp   nz, L001EB1
	jp   L027C9F
L024916:;I
	call L027E55
	ret  c
	ld   c, $01
	call L001F43
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $1E
	ldh  [$FFAC], a
	jp   L001EB1
L02492D:;I
	call L027E55
	ret  c
	ld   a, $02
	ld   [$CF38], a
	ld   c, $01
	call L001F43
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $0F
	ldh  [$FFAC], a
	ld   a, $18
	ld   bc, $E8FC
	call L001D35
	jp   L001EB1
L024951:;I
	call L027E55
	ret  c
	ld   c, $01
	call L001F43
	ld   a, $02
	ldh  [$FFA1], a
	ret  
L02495F:;I
	ldh  a, [$FFA1]
	rst  $00
L024962: db $6A
L024963: db $49
L024964: db $76
L024965: db $49
L024966: db $7F
L024967: db $49
L024968: db $8C
L024969: db $49
L02496A:;I
	call L001ED7
	ld   bc, $0080
	call L001E8E
	jp   L001EB1
L024976:;I
	ld   bc, $0200
	call L001E95
	jp   L001EB1
L02497F:;I
	call L002180
	call nc, L001E9C
	call L002328
	ret  c
	jp   L001EB1
L02498C:;I
	call L002180
	call nc, L001E9C
	call L0023A8
	ret  c
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L02499B:;I
	ldh  a, [$FFA1]
	rst  $00
L02499E: db $A6
L02499F: db $49
L0249A0: db $B1
L0249A1: db $49
L0249A2: db $BE
L0249A3: db $49
L0249A4: db $DA
L0249A5: db $49
L0249A6:;I
	ld   a, $01
	call L001F34
	call L001ED7
	jp   L001EB1
L0249B1:;I
	call L002180
	call nc, L001E9C
	call L002328
	ret  c
	jp   L001EB1
L0249BE:;I
	call L002180
	call nc, L001E9C
	call L0023A8
	ret  c
	ld   bc, $0303
	call L001F0C
	ld   a, $00
	call L001F34
	ld   a, $3C
	ldh  [$FFAC], a
	jp   L001EB1
L0249DA:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   bc, $0305
	call L001F0C
	ld   bc, $0080
	call L001E8E
	ld   bc, $0300
	call L001E95
	ld   a, $00
	ldh  [$FFA1], a
	ret  
L0249F8:;I
	ldh  a, [$FFA1]
	rst  $00
L0249FB: db $FF
L0249FC: db $49
L0249FD: db $08
L0249FE: db $4A
L0249FF:;I
	ld   bc, $0080
	call L001E8E
	jp   L001EB1
L024A08:;I
	ld   c, $01
	call L001F43
	call L002150
	ld   a, [$CF42]
	ld   b, a
	ld   a, [$CF43]
	or   a, b
	ret  nz
	ld   a, [$CF1D]
	cp   $04
	ret  nc
	ldh  a, [$FFA5]
	ld   b, a
	ld   a, [$CF15]
	sub  a, b
	jr   nc, L024A2C
	xor  $FF
	inc  a
	scf  
L024A2C:;R
	cp   $04
	ret  nc
	ldh  a, [$FFA2]
	ld   bc, $0080
	call L0018B9
	ldh  a, [$FFA7]
	add  a, $0C
	ld   b, a
	ld   a, [$CF16]
	cp   a, b
	ret  c
	xor  a
	ld   [$CF1B], a
	inc  a
	ld   [$CF1A], a
	inc  a
	ld   [$CF1D], a
	ret  
L024A4E:;I
	ldh  a, [$FFA1]
	rst  $00
L024A51: db $5B
L024A52: db $4A
L024A53: db $64
L024A54: db $4A
L024A55: db $9E;X
L024A56: db $4A;X
L024A57: db $A7
L024A58: db $4A
L024A59: db $C0
L024A5A: db $4A
L024A5B:;I
	ld   bc, $0010
	call L001E8E
	jp   L001EB1
L024A64:;I
	call L001ED7
	call L001EBB
	cp   $20
	jr   nc, L024A73
	ld   a, $04
	ldh  [$FFA1], a
	ret  
L024A73:;R
	ld   a, $1C
	call L001E63
	ld   a, b
	or   a
	jr   nz, L024A8A
	ld   a, $01
	call L001F34
	ld   a, $1E
	ldh  [$FFAC], a
	ld   a, $03
	ldh  [$FFA1], a
	ret  
L024A8A:;R
	call L002180
	call L002117
	ld   a, [$CF26]
	cp   $03
	ret  nz
L024A96: db $AF;X
L024A97: db $E0;X
L024A98: db $AA;X
L024A99: db $E0;X
L024A9A: db $AB;X
L024A9B: db $C3;X
L024A9C: db $B1;X
L024A9D: db $1E;X
L024A9E: db $CD;X
L024A9F: db $A8;X
L024AA0: db $23;X
L024AA1: db $D8;X
L024AA2: db $3E;X
L024AA3: db $01;X
L024AA4: db $E0;X
L024AA5: db $A1;X
L024AA6: db $C9;X
L024AA7:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $1C
	ld   bc, $00E8
	call L001D35
	ld   a, $00
	call L001F34
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L024AC0:;I
	ld   a, $02
	ld   [$CF38], a
	ld   c, $01
	call L001F51
	call L001EBB
	cp   $20
	ret  c
	ld   a, $00
	call L001F34
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L024ADA:;I
	ldh  a, [$FFA1]
	rst  $00
L024ADD: db $E5
L024ADE: db $4A
L024ADF: db $F7
L024AE0: db $4A
L024AE1: db $2C
L024AE2: db $4B
L024AE3: db $82
L024AE4: db $4B
L024AE5:;I
	ld   a, $0F
	ldh  [$FFAC], a
	ld   bc, $0100
	call L001E95
	ld   a, $02
	call L001F34
	jp   L001EB1
L024AF7:;I
	call L00220A
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $00
	ldh  [$FFAC], a
	ldh  a, [$FFA5]
	ld   b, a
	ld   a, [$CF15]
	sub  a, b
	jr   nc, L024B12
	xor  $FF
	inc  a
	scf  
L024B12:;R
	rra  
	and  a, $80
	ldh  [$FFA2], a
	ld   a, $02
	ldh  [$FFAD], a
	ld   a, $58
	ldh  [$FFAE], a
	xor  a
	ldh  [$FFAF], a
	ldh  [$FFAC], a
	ld   a, $00
	call L001F34
	jp   L001EB1
L024B2C:;I
	ldh  a, [$FFAC]
	add  a, $01
	ldh  [$FFAC], a
	cp   $B0
	jp   c, L024B3B
	ld   a, $00
	ldh  [$FFAC], a
L024B3B:;J
	ld   a, $02
	call L002047
	call L002150
	call L00220A
	ldh  a, [$FFA8]
	cp   $FF
	ret  nz
	call L001EBB
	cp   $30
	ret  c
	ld   a, [$CF16]
	sub  a, $0C
	ld   b, a
	ldh  a, [$FFA7]
	sub  a, b
	jr   nc, L024B60
	xor  $FF
	inc  a
	scf  
L024B60:;R
	cp   $40
	ret  nc
	ld   a, [$CF15]
	ld   b, a
	ldh  a, [$FFA5]
	cp   a, b
	jr   c, L024B77
	ldh  a, [$FFA2]
	bit  7, a
	ret  nz
	call L001FB9
	jp   L001EB1
L024B77:;R
	ldh  a, [$FFA2]
	bit  7, a
	ret  z
L024B7C: db $CD;X
L024B7D: db $B9;X
L024B7E: db $1F;X
L024B7F: db $C3;X
L024B80: db $B1;X
L024B81: db $1E;X
L024B82:;I
	call L002150
	call L00220A
	ret  
L024B89:;I
	ldh  a, [$FFA1]
	rst  $00
L024B8C: db $92
L024B8D: db $4B
L024B8E: db $9E
L024B8F: db $4B
L024B90: db $BB
L024B91: db $4B
L024B92:;I
	ld   bc, $0080
	call L001E8E
	call L001ED7
	jp   L001EB1
L024B9E:;I
	ld   bc, $0602
	call L001F5F
	call L002180
	call nc, L001E9C
	call L002117
	ld   a, [$CF26]
	cp   $03
	ret  nz
	xor  a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	jp   L001EB1
L024BBB:;I
	ld   bc, $0602
	call L001F5F
	call L0023A8
	ret  c
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L024BCA:;I
	ldh  a, [$FFA1]
	rst  $00
L024BCD: db $D1
L024BCE: db $4B
L024BCF: db $E0
L024BD0: db $4B
L024BD1:;I
	ldh  a, [$FFA5]
	sub  a, $10
	ldh  [$FFA5], a
	ldh  a, [$FFA7]
	add  a, $04
	ldh  [$FFA7], a
	jp   L001EB1
L024BE0:;I
	ld   bc, $0301
	call L001F5F
	ret  
L024BE7: db $C3;X
L024BE8: db $25;X
L024BE9: db $1C;X
L024BEA:;I
	ldh  a, [$FFA1]
	rst  $00
L024BED: db $F9
L024BEE: db $4B
L024BEF: db $18
L024BF0: db $4C
L024BF1: db $2F
L024BF2: db $4C
L024BF3: db $42
L024BF4: db $4C
L024BF5: db $55
L024BF6: db $4C
L024BF7: db $68
L024BF8: db $4C
L024BF9:;I
	ld   b, $00
	call L001F16
	ld   a, $00
	call L001F34
	ld   a, [$CF4D]
	and  a, $03
	ld   b, a
	ldh  a, [$FFA0]
	and  a, $7F
	sub  a, $20
	cp   a, b
	ret  nz
	ld   a, $3C
	ldh  [$FFAC], a
	jp   L001EB1
L024C18:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $10
	ldh  [$FF99], a
	ld   b, $04
	call L001F16
	ld   a, $0A
	ldh  [$FFAC], a
	jp   L001EB1
L024C2F:;I
	ld   a, $01
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $0A
	ldh  [$FFAC], a
	jp   L001EB1
L024C42:;I
	ld   a, $02
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $14
	ldh  [$FFAC], a
	jp   L001EB1
L024C55:;I
	ld   a, $03
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $3C
	ldh  [$FFAC], a
	jp   L001EB1
L024C68:;I
	ld   a, $04
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $00
	ldh  [$FFA1], a
	ret  
L024C79:;I
	ldh  a, [$FFA1]
	rst  $00
L024C7C: db $90
L024C7D: db $4C
L024C7E: db $9F
L024C7F: db $4C
L024C80: db $E3
L024C81: db $4C
L024C82: db $EF
L024C83: db $4C
L024C84: db $E3
L024C85: db $4C
L024C86: db $EF
L024C87: db $4C
L024C88: db $E3
L024C89: db $4C
L024C8A: db $EF
L024C8B: db $4C
L024C8C: db $18
L024C8D: db $4D
L024C8E: db $22
L024C8F: db $4D
L024C90:;I
	xor  a
	ldh  [$FFA2], a
	ld   c, $01
	call L001F43
	ld   a, $3C
	ldh  [$FFAC], a
	jp   L001EB1
L024C9F:;I
	ld   c, $01
	call L001F43
	ldh  a, [$FF8F]
	bit  7, a
	jr   z, L024CD9
	call L001EBB
	cp   $30
	jr   nc, L024CD9
	ld   a, $00
	call L001F34
	ld   a, $02
	ld   [$CF38], a
	ld   a, $1E
	ldh  [$FFAC], a
	xor  a
	ld   de, $017D
	ld   bc, $00F0
	call L027C29
	ld   a, $80
	ld   de, $017D
	ld   bc, $00F0
	call L027C29
	ld   a, $09
	ldh  [$FFA1], a
	ret  
L024CD9:;R
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	jp   L001EB1
L024CE3:;I
	ld   c, $01
	call L001F43
	ld   a, $1E
	ldh  [$FFAC], a
	jp   L001EB1
L024CEF:;I
	ld   c, $01
	call L001F43
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $7E
	ld   bc, $F8F8
	call L001D35
	jr   c, L024D15
	call L001E7C
	ld   a, $7E
	ld   bc, $08F8
	call L001D35
	jr   c, L024D15
	call L001E84
L024D15:;X
	jp   L001EB1
L024D18:;I
	ld   c, $01
	call L001F43
	ld   a, $00
	ldh  [$FFA1], a
	ret  
L024D22:;I
	ld   a, $02
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $3C
	ldh  [$FFAC], a
	ld   a, $03
	ldh  [$FFA1], a
	ret  
L024D37:;I
	ldh  a, [$FFA1]
	rst  $00
L024D3A: db $42
L024D3B: db $4D
L024D3C: db $58
L024D3D: db $4D
L024D3E: db $65
L024D3F: db $4D
L024D40: db $6F
L024D41: db $4D
L024D42:;I
	ld   b, $00
	call L001F16
	ld   hl, $FFA5
	inc  [hl]
	ld   a, [$CF6D]
	xor  $01
	ld   [$CF6D], a
	ldh  [$FFAC], a
	jp   L001EB1
L024D58:;I
	ld   a, [$CF4D]
	and  a, $01
	ld   b, a
	ldh  a, [$FFAC]
	cp   a, b
	ret  nz
	jp   L001EB1
L024D65:;I
	xor  a
	ldh  [$FFAD], a
	ld   a, $0C
	ldh  [$FFAC], a
	jp   L001EB1
L024D6F:;I
	ldh  a, [$FFAD]
	ld   hl, $4DBF
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	cp   $FF
	jr   nz, L024D82
	ld   a, $02
	ldh  [$FFA1], a
	ret  
L024D82:;R
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	push hl
	ld   a, [hl]
	ld   hl, $4DD8
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   c, [hl]
	ld   b, $03
	call L001F0C
	pop  hl
	push hl
	ld   b, $03
	ld   a, [hl]
	or   a
	jr   nz, L024DA2
	ld   b, $00
L024DA2:;R
	call L001F16
	pop  hl
	ldi  a, [hl]
	sla  a
	sla  a
	sla  a
	ldh  [$FFA2], a
	ldh  a, [$FFA7]
	add  a, [hl]
	ldh  [$FFA7], a
	ldh  a, [$FFAD]
	add  a, $02
	ldh  [$FFAD], a
	ld   a, $0C
	ldh  [$FFAC], a
	ret  
L024DBF: db $00
L024DC0: db $00
L024DC1: db $00
L024DC2: db $00
L024DC3: db $00
L024DC4: db $00
L024DC5: db $01
L024DC6: db $08
L024DC7: db $02
L024DC8: db $08
L024DC9: db $03
L024DCA: db $10
L024DCB: db $03
L024DCC: db $00
L024DCD: db $03
L024DCE: db $00
L024DCF: db $02
L024DD0: db $F0
L024DD1: db $01
L024DD2: db $F8
L024DD3: db $00
L024DD4: db $F8
L024DD5: db $00
L024DD6: db $00
L024DD7: db $FF
L024DD8: db $03
L024DD9: db $03
L024DDA: db $07
L024DDB: db $0F
L024DDC:;I
	ldh  a, [$FFA1]
	rst  $00
L024DDF: db $EF
L024DE0: db $4D
L024DE1: db $FE
L024DE2: db $4D
L024DE3: db $0F
L024DE4: db $4E
L024DE5: db $21
L024DE6: db $4E
L024DE7: db $36
L024DE8: db $4E
L024DE9: db $4E
L024DEA: db $4E
L024DEB: db $66
L024DEC: db $4E
L024DED: db $75
L024DEE: db $4E
L024DEF:;I
	ld   bc, $0200
	call L001E8E
	ld   bc, $0280
	call L001E95
	jp   L001EB1
L024DFE:;I
	ld   c, $02
	call L001F43
	call L001ED7
	call L001EBB
	cp   $30
	ret  nc
	jp   L001EB1
L024E0F:;I
	ld   c, $02
	call L001F43
	call L002150
	call L001EBB
	and  a, $F0
	or   a
	ret  nz
	jp   L001EB1
L024E21:;I
	ld   c, $02
	call L001F43
	call L002150
	call L001EBB
	cp   $30
	ret  c
	ld   a, $1E
	ldh  [$FFAC], a
	jp   L001EB1
L024E36:;I
	ld   c, $02
	call L001F43
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	call L001E9C
	ldh  a, [$FFA2]
	or   a, $40
	ldh  [$FFA2], a
	jp   L001EB1
L024E4E:;I
	ld   c, $02
	call L001F43
	call L00220A
	call L001EC9
	and  a, $F0
	swap a
	or   a
	ret  nz
	ld   a, $1E
	ldh  [$FFAC], a
	jp   L001EB1
L024E66:;I
	ld   c, $02
	call L001F43
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	jp   L001EB1
L024E75:;I
	ld   c, $02
	call L001F43
	call L002150
	ret  
L024E7E:;I
	ldh  a, [$FFA1]
	rst  $00
L024E81: db $93
L024E82: db $4E
L024E83: db $A5
L024E84: db $4E
L024E85: db $AF
L024E86: db $4E
L024E87: db $BE
L024E88: db $4E
L024E89: db $AF
L024E8A: db $4E
L024E8B: db $BE
L024E8C: db $4E
L024E8D: db $E8
L024E8E: db $4E
L024E8F: db $F7
L024E90: db $4E
L024E91: db $2A
L024E92: db $4F
L024E93:;I
	ld   b, $02
	call L001F16
	ld   bc, $0180
	call L001E8E
	ld   a, $78
	ldh  [$FFAC], a
	jp   L001EB1
L024EA5:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	jp   L001EB1
L024EAF:;I
	ld   a, $00
	ldh  [$FFAC], a
	call L001ED7
	ld   a, $00
	call L001F34
	jp   L001EB1
L024EBE:;I
	ldh  a, [$FFAC]
	add  a, $01
	ldh  [$FFAC], a
	cp   $18
	jr   nz, L024ECD
	push af
	call L027CD8
	pop  af
L024ECD:;R
	srl  a
	srl  a
	srl  a
	srl  a
	cp   $03
	jr   z, L024EE0
	and  a, $01
	ld   a, a
	ld   [$CF38], a
	ret  
L024EE0:;R
	ld   a, $00
	ld   [$CF38], a
	jp   L001EB1
L024EE8:;I
	ld   a, $5A
	ldh  [$FFAC], a
	ld   b, $03
	call L001F16
	call L001ED7
	jp   L001EB1
L024EF7:;I
	ld   a, $02
	ld   [$CF38], a
	ld   c, $01
	call L001F43
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	jr   nz, L024F13
	ld   b, $02
	call L001F16
	ld   a, $02
	ldh  [$FFA1], a
	ret  
L024F13:;R
	call L002180
	call nc, L001E9C
	call L002117
	ld   a, [$CF26]
	cp   $03
	ret  nz
	xor  a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	jp   L001EB1
L024F2A:;I
	ld   a, $02
	ld   [$CF38], a
	ld   c, $01
	call L001F43
	call L0023A8
	ret  c
	ld   a, $07
	ldh  [$FFA1], a
	ret  
L024F3D:;I
	call L002150
	call L00220A
	ret  
L024F44:;I
	ldh  a, [$FFA1]
	rst  $00
L024F47: db $53
L024F48: db $4F
L024F49: db $5C
L024F4A: db $4F
L024F4B: db $70
L024F4C: db $4F
L024F4D: db $8D
L024F4E: db $4F
L024F4F: db $D8
L024F50: db $4F
L024F51: db $F0
L024F52: db $4F
L024F53:;I
	ldh  a, [$FFA5]
	add  a, $08
	ldh  [$FFA5], a
	jp   L001EB1
L024F5C:;I
	call L001ED7
	call L001EBB
	cp   $48
	ret  nc
	ld   de, $0003
	ld   c, $0C
	call L001F7D
	jp   L001EB1
L024F70:;I
	call L001ED7
	call L001F8B
	ret  z
	ld   a, $00
	call L001F34
	ld   a, $03
	ld   [$CF38], a
	ld   b, $02
	call L001F16
	ld   a, $00
	ldh  [$FFAC], a
	jp   L001EB1
L024F8D:;I
	call L001ED7
	ldh  a, [$FFAC]
	add  a, $01
	ldh  [$FFAC], a
	cp   $1E
	jr   nc, L024FA0
	ld   a, $03
	ld   [$CF38], a
	ret  
L024FA0:;R
	cp   $28
	push af
	call z, L024FFC
	pop  af
	jr   nc, L024FAF
	ld   a, $02
	ld   [$CF38], a
	ret  
L024FAF:;R
	cp   $46
	jr   nc, L024FB9
	ld   a, $03
	ld   [$CF38], a
	ret  
L024FB9:;R
	cp   $50
	push af
	call z, L024FFC
	pop  af
	jr   nc, L024FC8
	ld   a, $02
	ld   [$CF38], a
	ret  
L024FC8:;R
	ld   a, $02
	ld   [$CF38], a
	ld   de, $0306
	ld   c, $0C
	call L001F7D
	jp   L001EB1
L024FD8:;I
	call L001ED7
	call L001F8B
	ret  z
	ld   a, $00
	call L001F34
	ld   b, $03
	call L001F16
	ld   a, $3C
	ldh  [$FFAC], a
	jp   L001EB1
L024FF0:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L024FFC:;C
	ld   bc, $F8FC
	ldh  a, [$FFA2]
	and  a, $80
	jr   z, L025008
	ld   bc, $08FC
L025008:;R
	ld   de, $022A
	jp   L027C29
L02500E:;I
	ldh  a, [$FFA1]
	rst  $00
L025011: db $15
L025012: db $50
L025013: db $22
L025014: db $50
L025015:;I
	call L002180
	call nc, L001E9C
	call L002328
	ret  c
	jp   L001EB1
L025022:;I
	call L002180
	call nc, L001E9C
	call L0023A8
	ret  c
	jp   L001E11
L02502F:;I
	ldh  a, [$FFA1]
	rst  $00
L025032: db $38
L025033: db $50
L025034: db $3F
L025035: db $50
L025036: db $62
L025037: db $50
L025038:;I
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB1
L02503F:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $20
	ldh  [$FFAC], a
	ld   a, $4E
	call L001E63
	ld   a, b
	cp   $03
	ret  nc
	ld   a, $4E
	ld   bc, $0000
	call L001D35
	ld   a, $FF
	ldh  [$FFAC], a
	jp   L001EB1
L025062:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB6
L025070:;I
	ldh  a, [$FFA1]
	rst  $00
L025073: db $7D
L025074: db $50
L025075: db $89
L025076: db $50
L025077: db $A8
L025078: db $50
L025079: db $E8
L02507A: db $50
L02507B: db $09
L02507C: db $51
L02507D:;I
	ldh  a, [$FFA0]
	and  a, $7F
	sub  a, $2C
	ld   [$CF5A], a
	jp   L001EB1
L025089:;I
	ldh  a, [$FFA5]
	add  a, $05
	ldh  [$FFA5], a
	ldh  a, [$FFA7]
	sub  a, $04
	ldh  [$FFA7], a
	xor  a
	ld   [$CF5B], a
	ld   bc, $0080
	call L001E8E
	ld   bc, $0080
	call L001E95
	jp   L001EB1
L0250A8:;RI
	ld   hl, $5118
	ld   a, [$CF5A]
	add  a
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   e, [hl]
	inc  hl
	ld   d, [hl]
	ld   l, e
	ld   h, d
	ld   a, [$CF5B]
	add  a
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldi  a, [hl]
	cp   $FF
	jr   nz, L0250CB
	xor  a
	ld   [$CF5B], a
	jr   L0250A8
L0250CB:;R
	push af
	and  a, $C0
	ld   b, a
	ldh  a, [$FFA2]
	and  a, $3F
	or   a, b
	ldh  [$FFA2], a
	ld   a, [hl]
	ld   a, a
	ldh  [$FFAC], a
	ld   hl, $CF5B
	inc  [hl]
	pop  af
	rrca 
	jp   c, L001EB1
	ld   a, $04
	ldh  [$FFA1], a
	ret  
L0250E8:;I
	call L002150
	ld   a, [$CF2F]
	ld   b, a
	ld   a, [$CF4A]
	cp   a, b
	jr   nz, L0250FD
	ldh  a, [$FFA2]
	ld   bc, $0080
	call L0018B9
L0250FD:;R
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $02
	ldh  [$FFA1], a
	ret  
L025109:;I
	call L00220A
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $02
	ldh  [$FFA1], a
	ret  
L025118: db $1E
L025119: db $51
L02511A: db $27
L02511B: db $51
L02511C: db $44
L02511D: db $51
L02511E: db $40
L02511F: db $40
L025120: db $01
L025121: db $E0
L025122: db $00
L025123: db $40
L025124: db $81
L025125: db $E0
L025126: db $FF
L025127: db $40
L025128: db $80
L025129: db $01
L02512A: db $80
L02512B: db $00
L02512C: db $20
L02512D: db $81
L02512E: db $40
L02512F: db $00
L025130: db $20
L025131: db $81
L025132: db $20
L025133: db $00
L025134: db $20
L025135: db $01
L025136: db $40
L025137: db $40
L025138: db $20
L025139: db $01
L02513A: db $60
L02513B: db $00
L02513C: db $20
L02513D: db $81
L02513E: db $40
L02513F: db $00
L025140: db $20
L025141: db $81
L025142: db $80
L025143: db $FF
L025144: db $40
L025145: db $A0
L025146: db $01
L025147: db $C0
L025148: db $00
L025149: db $20
L02514A: db $81
L02514B: db $A0
L02514C: db $00
L02514D: db $60
L02514E: db $01
L02514F: db $20
L025150: db $40
L025151: db $40
L025152: db $01
L025153: db $60
L025154: db $00
L025155: db $10
L025156: db $81
L025157: db $40
L025158: db $00
L025159: db $10
L02515A: db $01
L02515B: db $40
L02515C: db $00
L02515D: db $10
L02515E: db $81
L02515F: db $40
L025160: db $00
L025161: db $10
L025162: db $01
L025163: db $60
L025164: db $00
L025165: db $20
L025166: db $81
L025167: db $C0
L025168: db $FF
L025169:;I
	ldh  a, [$FFA1]
	rst  $00
L02516C: db $78
L02516D: db $51
L02516E: db $C9
L02516F: db $51
L025170: db $01
L025171: db $52
L025172: db $0C
L025173: db $52
L025174: db $6E
L025175: db $52
L025176: db $85
L025177: db $52
L025178:;I
	ld   bc, $0040
	call L001E8E
	ld   a, $18
	ldh  [$FFAD], a
	xor  a
	ldh  [$FFAE], a
	ld   a, $30
	ld   bc, $00F0
	call L001D35
	ld   de, $000D
	add  hl, de
	ld   [hl], $08
	inc  hl
	ld   [hl], $F0
	ld   a, $30
	ld   bc, $0010
	call L001D35
	ld   de, $000D
	add  hl, de
	ld   [hl], $08
	inc  hl
	ld   [hl], $10
	ld   a, $30
	ld   bc, $0020
	call L001D35
	ld   de, $000D
	add  hl, de
	ld   [hl], $18
	inc  hl
	ld   [hl], $20
	ld   hl, $CCD0
	xor  a
	ldi  [hl], a
	ldi  [hl], a
	ldh  a, [$FFA7]
	ldi  [hl], a
	ld   b, $02
	call L001F16
	jp   L001EB1
L0251C9:;I
	ldh  a, [$FFAD]
	add  a, $08
	and  a, $7C
	sub  a, $01
	ld   a, $00
	adc  a
	ld   [$CF38], a
	call L0252CF
	call L0252A2
	call L001F2A
	cp   $11
	ret  nc
	ld   hl, $CCD0
	inc  [hl]
	inc  hl
	ld   [hl], $00
	ld   a, $01
	call L001F34
	ld   b, $03
	call L001F16
	ld   b, $11
	call L001F20
	xor  a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	jp   L001EB1
L025201:;I
	call L0023A8
	ret  c
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L02520C:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $10
	ldh  [$FFAC], a
	ld   a, $30
	call L001E63
	ld   a, b
	and  a
	ret  nz
	ld   a, $18
	ldh  [$FFAD], a
	xor  a
	ldh  [$FFAE], a
	ld   a, $31
	ld   bc, $0000
	call L001D35
	ld   de, $0007
	add  hl, de
	ld   [hl], $A0
	dec  de
	add  hl, de
	ld   [hl], $08
	inc  hl
	ld   [hl], $F0
	ld   a, $31
	ld   bc, $0000
	call L001D35
	ld   de, $0007
	add  hl, de
	ld   [hl], $B0
	dec  de
	add  hl, de
	ld   [hl], $08
	inc  hl
	ld   [hl], $10
	ld   a, $31
	ld   bc, $0000
	call L001D35
	ld   de, $0007
	add  hl, de
	ld   [hl], $C0
	dec  de
	add  hl, de
	ld   [hl], $18
	inc  hl
	ld   [hl], $20
	ld   hl, $CCD0
	xor  a
	ldi  [hl], a
	ld   [hl], a
	jp   L001EB1
L02526E:;I
	ld   a, [$CCD1]
	cp   $03
	ret  nz
	ld   a, $00
	call L001F34
	ld   b, $02
	call L001F16
	ld   hl, $CCD0
	inc  [hl]
	jp   L001EB1
L025285:;I
	ldh  a, [$FFAD]
	add  a, $08
	and  a, $7C
	sub  a, $01
	ld   a, $00
	adc  a
	ld   [$CF38], a
	call L0252CF
	call L0252A2
	call L001E03
	ret  nc
	ld   hl, $CCD0
	inc  [hl]
	ret  
L0252A2:;C
	ld   a, [$CCD2]
	ld   hl, $FFAE
	add  a, [hl]
	ldh  [$FFA7], a
	call L002150
	ldh  a, [$FFAD]
	and  a, $10
	rrca 
	rrca 
	rrca 
	rrca 
	ld   h, a
	ld   l, $00
	ld   de, $FF80
	add  hl, de
	ldh  a, [$FFA4]
	ld   e, a
	ldh  a, [$FFA5]
	ld   d, a
	add  hl, de
	ld   a, l
	ldh  [$FFA4], a
	ld   a, h
	ldh  [$FFA5], a
	ld   hl, $FFAD
	inc  [hl]
	ret  
L0252CF:;C
	ldh  a, [$FFA5]
	sub  a, $07
	ld   [$CF0D], a
	ldh  a, [$FFA7]
	add  a, $20
	ld   [$CF0E], a
	call L00332F
	ret  nc
	ldh  a, [$FFA5]
	add  a, $07
	ld   [$CF0D], a
	call L00332F
	ret  nc
	ld   hl, $CCD2
	inc  [hl]
	inc  [hl]
	ret  
L0252F2:;I
	ldh  a, [$FFA1]
	rst  $00
L0252F5: db $FF
L0252F6: db $52
L0252F7: db $08
L0252F8: db $53
L0252F9: db $35
L0252FA: db $53
L0252FB: db $3F
L0252FC: db $53
L0252FD: db $5E
L0252FE: db $53
L0252FF:;I
	ld   bc, $0040
	call L001E8E
	jp   L001EB1
L025308:;I
	call L0252A2
	ld   a, [$CCD0]
	and  a
	ret  z
	xor  a
	ldh  [$FFAF], a
	ldh  a, [$FFAE]
	add  a, $10
	rrca 
	rrca 
	ld   hl, $5361
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   de, $FFA8
	ldi  a, [hl]
	ld   [de], a
	inc  de
	ldi  a, [hl]
	ld   [de], a
	inc  de
	ldi  a, [hl]
	ld   [de], a
	inc  de
	ldi  a, [hl]
	ld   [de], a
	inc  de
	call L001ED7
	jp   L001EB1
L025335:;I
	call L002180
	call L002328
	ret  c
	jp   L001EB1
L02533F:;I
	call L002180
	call L0023A8
	ret  c
	ldh  a, [$FFAF]
	and  a
	jp   nz, L001EB1
	inc  a
	ldh  [$FFAF], a
	ld   bc, $0000
	call L001E8E
	ld   bc, $0200
	call L001E95
	jp   L001EB6
L02535E:;I
	jp   L001E11
L025361: db $80
L025362: db $02
L025363: db $00
L025364: db $03
L025365: db $00;X
L025366: db $00;X
L025367: db $00;X
L025368: db $00;X
L025369: db $00
L02536A: db $02
L02536B: db $80
L02536C: db $02
L02536D: db $80
L02536E: db $01
L02536F: db $80
L025370: db $01
L025371:;I
	ldh  a, [$FFA1]
	rst  $00
L025374: db $7C
L025375: db $53
L025376: db $95
L025377: db $53
L025378: db $A6
L025379: db $53
L02537A: db $AE
L02537B: db $53
L02537C:;I
	ldh  a, [$FFA2]
	and  a, $BF
	ldh  [$FFA2], a
	ld   bc, $0040
	call L001E8E
	ld   bc, $0200
	call L001E95
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB1
L025395:;I
	call L00220A
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   hl, $CCD1
	inc  [hl]
	jp   L001EB1
L0253A6:;I
	ld   a, [$CCD0]
	and  a
	ret  z
	jp   L001EB1
L0253AE:;I
	call L0252A2
	ld   a, [$CCD0]
	cp   $02
	ret  nz
	xor  a
	ldh  [$FFA0], a
	ret  
L0253BB:;I
	ldh  a, [$FFA1]
	rst  $00
L0253BE: db $C4
L0253BF: db $53
L0253C0: db $CF
L0253C1: db $53
L0253C2: db $F4
L0253C3: db $53
L0253C4:;I
	ldh  a, [$FFA5]
	ldh  [$FFAD], a
	ld   a, $40
	ldh  [$FFAC], a
	jp   L001EB1
L0253CF:;I
	ldh  a, [$FFAD]
	ldh  [$FFA5], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	call L001ED7
	ld   bc, $00C0
	call L001E8E
	ld   a, $33
	ld   bc, $0008
	call L001D35
	ld   a, l
	ldh  [$FFAE], a
	ld   a, h
	ldh  [$FFAF], a
	jp   L001EB1
L0253F4:;I
	ld   c, $01
	call L001F43
	call L002150
	call L001E03
	ret  nc
	ld   a, $33
	call L001E63
	ld   a, b
	and  a
	ret  z
	ldh  a, [$FFAE]
	add  a, $0D
	ld   l, a
	ldh  a, [$FFAF]
	ld   h, a
	ld   [hl], $FF
	ret  
L025413:;I
	ldh  a, [$FFA1]
	rst  $00
L025416: db $1E
L025417: db $54
L025418: db $3D
L025419: db $54
L02541A: db $50
L02541B: db $54
L02541C: db $62
L02541D: db $54
L02541E:;I
	call L001ED7
	ld   bc, $00C0
	call L001E8E
	ld   bc, $00C0
	call L001E95
	ldh  a, [$FFA2]
	or   a, $40
	ldh  [$FFA2], a
	xor  a
	ldh  [$FFAD], a
	ld   a, $40
	ldh  [$FFAC], a
	jp   L001EB1
L02543D:;I
	call L002150
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	jp   z, L001EB1
	ldh  a, [$FFAD]
	and  a
	ret  z
	jp   L001E11
L025450:;I
	call L002150
	call L001EBB
	cp   $30
	jp   c, L001EB1
	ldh  a, [$FFAD]
	and  a
	ret  z
	jp   L001E11
L025462:;I
	call L00223A
	ldh  a, [$FFA7]
	cp   $9C
	jp   nc, L0254A2
	call L00332F
	ret  c
	ld   de, $54A6
	ld   b, $06
L025475:;R
	push bc
	push de
	ld   a, $34
	ld   bc, $0000
	call L001D35
	pop  de
	inc  hl
	inc  hl
	ld   a, [hl]
	and  a, $3F
	ld   [hl], a
	ld   a, $06
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [de]
	ld   [hl], a
	inc  hl
	inc  de
	ld   a, [de]
	ld   [hl], a
	inc  hl
	inc  de
	ld   a, [de]
	ld   [hl], a
	inc  hl
	inc  de
	ld   a, [de]
	ld   [hl], a
	inc  de
	pop  bc
	dec  b
	jr   nz, L025475
	jp   L001E11
L0254A2:;J
	xor  a
	ldh  [$FFA0], a
	ret  
L0254A6: db $00
L0254A7: db $00
L0254A8: db $01
L0254A9: db $FF
L0254AA: db $4C
L0254AB: db $FF
L0254AC: db $B4
L0254AD: db $00
L0254AE: db $01
L0254AF: db $FF
L0254B0: db $00
L0254B1: db $00
L0254B2: db $00
L0254B3: db $00
L0254B4: db $FF
L0254B5: db $00
L0254B6: db $FF
L0254B7: db $00
L0254B8: db $00
L0254B9: db $00
L0254BA: db $B4
L0254BB: db $00
L0254BC: db $B4
L0254BD: db $00
L0254BE:;I
	ldh  a, [$FFA1]
	rst  $00
L0254C1: db $C7
L0254C2: db $54
L0254C3: db $CE
L0254C4: db $54
L0254C5: db $E6
L0254C6: db $54
L0254C7:;I
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB1
L0254CE:;I
	ld   c, $01
	call L001F43
	call L002150
	call L00220A
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	call L001FB9
	jp   L001EB1
L0254E6:;I
	ld   c, $01
	call L001F43
	call L002150
	call L00220A
	ret  
L0254F2:;I
	ldh  a, [$FFA1]
	rst  $00
L0254F5: db $FF
L0254F6: db $54
L0254F7: db $0F
L0254F8: db $55
L0254F9: db $40
L0254FA: db $55
L0254FB: db $53
L0254FC: db $55
L0254FD: db $84
L0254FE: db $55
L0254FF:;I
	ld   a, $00
	call L001F34
	ld   a, $06
	ldh  [$FFAD], a
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB1
L02550F:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $7F
	ld   bc, $F4F8
	call L001D35
	ld   de, $0300
	ld   bc, $0200
	call nc, L025599
	ld   a, $20
	ldh  [$FFAC], a
	ld   hl, $FFAD
	dec  [hl]
	ret  nz
	ld   a, $06
	ldh  [$FFAD], a
	ld   a, $01
	call L001F34
	ld   a, $08
	ldh  [$FFAC], a
	jp   L001EB1
L025540:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $02
	call L001F34
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB1
L025553:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $7F
	ld   bc, $F4F4
	call L001D35
	ld   de, $0080
	ld   bc, $0380
	call nc, L025599
	ld   a, $20
	ldh  [$FFAC], a
	ld   hl, $FFAD
	dec  [hl]
	ret  nz
	ld   a, $06
	ldh  [$FFAD], a
	ld   a, $01
	call L001F34
	ld   a, $08
	ldh  [$FFAC], a
	jp   L001EB1
L025584:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $00
	call L001F34
	ld   a, $20
	ldh  [$FFAC], a
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L025599:;C
	ld   a, l
	add  a, $08
	ld   l, a
	ld   [hl], e
	inc  hl
	ld   [hl], d
	inc  hl
	ld   [hl], c
	inc  hl
	ld   [hl], b
	ret  
L0255A5:;I
	ldh  a, [$FFA1]
	rst  $00
L0255A8: db $B2
L0255A9: db $55
L0255AA: db $C5
L0255AB: db $55
L0255AC: db $D3
L0255AD: db $55
L0255AE: db $EC
L0255AF: db $55
L0255B0: db $16
L0255B1: db $56
L0255B2:;I
	ld   a, $00
	call L001F34
	ld   bc, $0040
	call L001E8E
	xor  a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	jp   L001EB1
L0255C5:;I
	call L002180
	call L0023A8
	ret  c
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB1
L0255D3:;I
	ld   c, $01
	call L001F43
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   bc, $0040
	call L001E95
	ld   a, $C0
	ldh  [$FFAC], a
	jp   L001EB1
L0255EC:;I
	ld   c, $01
	call L001F43
	call L00223A
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	call L001ED7
	call L001EBB
	ld   c, a
	ld   b, $00
	call L001E8E
	call L0020D8
	call L0020D8
	ld   bc, $0200
	call L001E95
	jp   L001EB1
L025616:;I
	ld   c, $01
	call L001F43
	call L002180
	call L002328
	ret  c
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L025627:;I
	ldh  a, [$FFA1]
	rst  $00
L02562A: db $2E
L02562B: db $56
L02562C: db $35
L02562D: db $56
L02562E:;I
	ld   a, $C0
	ldh  [$FFAC], a
	jp   L001EB1
L025635:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $C0
	ldh  [$FFAC], a
	ld   a, $36
	call L001E63
	ld   a, b
	cp   $02
	jp   nc, L001EB6
	ld   a, $36
	ld   bc, $0000
	call L001D35
	ret  c
	ld   a, l
	add  a, $06
	ld   l, a
	xor  a
	ldi  [hl], a
	ld   [hl], a
	ret  
L02565C:;I
	ldh  a, [$FFA1]
	rst  $00
L02565F: db $6D
L025660: db $56
L025661: db $81
L025662: db $56
L025663: db $A3
L025664: db $56
L025665: db $AC
L025666: db $56
L025667: db $CE
L025668: db $56
L025669: db $D7
L02566A: db $56
L02566B: db $E2
L02566C: db $56
L02566D:;I
	ld   a, $00
	call L001F34
	ldh  a, [$FFA2]
	and  a, $7F
	ldh  [$FFA2], a
	ld   bc, $0040
	call L001E8E
	jp   L001EB1
L025681:;I
	call L025709
	jp   c, L025700
	call L002180
	jp   nc, L001EB1
	call L0020F1
	jp   c, L001EB1
	call L001EC9
	and  a
	ret  nz
	ld   bc, $0200
	call L001E8E
	ld   a, $03
	ldh  [$FFA1], a
	ret  
L0256A3:;I
	ldh  a, [$FFA2]
	xor  $80
	ldh  [$FFA2], a
	jp   L001EB6
L0256AC:;I
	call L025709
	jp   c, L025700
	call L002180
	jp   nc, L001EB1
	call L0020F1
	jp   c, L001EB1
	call L001EC9
	and  a
	ret  z
	ld   bc, $0040
	call L001E8E
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L0256CE:;I
	ldh  a, [$FFA2]
	xor  $80
	ldh  [$FFA2], a
	jp   L001EB6
L0256D7:;I
	ld   a, $20
	ldh  [$FFAE], a
	ld   a, $08
	ldh  [$FFAC], a
	jp   L001EB1
L0256E2:;I
	ldh  a, [$FFAE]
	and  a, $03
	inc  a
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $08
	ldh  [$FFAC], a
	ldh  a, [$FFAE]
	dec  a
	ldh  [$FFAE], a
	ret  nz
	ldh  a, [$FFAF]
	ldh  [$FFA1], a
	ret  
L025700:;J
	ldh  a, [$FFA1]
	ldh  [$FFAF], a
	ld   a, $05
	ldh  [$FFA1], a
	ret  
L025709:;C
	call L001EBB
	cp   $07
	ret  nc
	call L001EC9
	cp   $07
	ret  
L025715:;I
	ldh  a, [$FFA1]
	rst  $00
L025718: db $24
L025719: db $57
L02571A: db $33
L02571B: db $57
L02571C: db $6C
L02571D: db $57
L02571E: db $8C
L02571F: db $57
L025720: db $A2
L025721: db $57
L025722: db $C5
L025723: db $57
L025724:;I
	ld   c, $01
	call L001F43
	xor  a
	ldh  [$FFAF], a
	ld   a, $40
	ldh  [$FFAC], a
	jp   L001EB1
L025733:;I
	ld   c, $01
	call L001F43
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $3A
	ld   bc, $00F0
	call L001D35
	ld   a, l
	ldh  [$FFAE], a
	add  a, $07
	ld   l, a
	ld   a, h
	ldh  [$FFAF], a
	xor  a
	ld   [hl], a
	ld   a, $06
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldh  a, [$FFA7]
	sub  a, $17
	ldi  [hl], a
	ld   a, [$CF2F]
	ldi  [hl], a
	xor  a
	ld   [hl], a
	ldh  [$FFAF], a
	ld   a, $80
	ldh  [$FFAC], a
	jp   L001EB1
L02576C:;I
	call L0257D4
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ldh  a, [$FFAF]
	and  a
	jp   nz, L001EB1
	ldh  a, [$FFAE]
	ld   l, a
	ld   h, $CD
	inc  hl
	ld   [hl], $03
	xor  a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	jp   L001EB1
L02578C:;I
	call L0257D4
	call L0257EB
	call L0023A8
	ret  c
	call L001ED7
	ld   bc, $00C0
	call L001E8E
	jp   L001EB1
L0257A2:;I
	call L0257D4
	call L002180
	jp   nc, L001EB1
	call L002117
	ld   a, [$CF26]
	cp   $03
	ret  nz
	ld   bc, $0100
	call L001E8E
	call L002180
	xor  a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	jp   L001EB6
L0257C5:;I
	call L0257D4
	call L0257F2
	ldh  a, [$FFA2]
	xor  $80
	ldh  [$FFA2], a
	jp   L001EB6
L0257D4:;C
	ld   c, $01
	call L001F43
	call L001E03
	ret  nc
	pop  hl
	ldh  a, [$FFAF]
	and  a
	ret  nz
	ldh  a, [$FFAE]
	ld   l, a
	ld   h, $CD
	inc  hl
	ld   [hl], $04
	ret  
L0257EB:;C
	ldh  a, [$FFA7]
	cp   $9A
	ret  c
L0257F0: db $18;X
L0257F1: db $05;X
L0257F2:;C
	ldh  a, [$FFA5]
	cp   $B0
	ret  c
	call L001E11
	pop  hl
	ldh  a, [$FFAF]
	and  a
	ret  nz
	ldh  a, [$FFAE]
	ld   l, a
	ld   h, $CD
	ld   [hl], $00
	ret  
L025807:;I
	ldh  a, [$FFA1]
	rst  $00
L02580A: db $16
L02580B: db $58
L02580C: db $21
L02580D: db $58
L02580E: db $38
L02580F: db $58
L025810: db $42
L025811: db $58
L025812: db $56
L025813: db $58
L025814: db $61
L025815: db $58
L025816:;I
	call L025868
	xor  a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	jp   L001EB1
L025821:;I
	call L025868
	call L0022F7
	ldh  a, [$FFAD]
	ld   hl, $FFA7
	cp   a, [hl]
	ret  nc
	ld   [hl], a
	ld   bc, $0200
	call L001E95
	jp   L001EB1
L025838:;I
	call L025868
	call L002328
	ret  c
	jp   L001EB6
L025842:;I
	call L025868
	ldh  a, [$FFAE]
	add  a, $05
	ld   l, a
	ld   h, $CD
	ldi  a, [hl]
	ldh  [$FFA5], a
	inc  hl
	ld   a, [hl]
	sub  a, $17
	ldh  [$FFA7], a
	ret  
L025856:;I
	call L025868
	xor  a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	jp   L001EB1
L025861:;I
	call L025868
	call L0022F7
	ret  
L025868:;C
	ld   c, $01
	call L001F43
	call L001E03
	ret  nc
	pop  bc
	ldh  a, [$FFAF]
	and  a
	ret  nz
	ldh  a, [$FFAE]
	add  a, $0F
	ld   l, a
	ld   h, $CD
	ld   [hl], $FF
	ret  
L025880:;I
	ldh  a, [$FFA1]
	rst  $00
L025883: db $91
L025884: db $58
L025885: db $BB
L025886: db $58
L025887: db $C3
L025888: db $58
L025889: db $D1
L02588A: db $58
L02588B: db $E0
L02588C: db $58
L02588D: db $EF
L02588E: db $58
L02588F: db $FD
L025890: db $58
L025891:;I
	call L000755
	ld   l, a
	ld   e, a
	xor  a
	ld   h, a
	ld   d, a
	add  hl, hl
	add  hl, hl
	add  hl, de
	ld   a, h
	sub  a, $02
	add  a
	add  a
	add  a
	add  a
	ld   hl, $FFA5
	add  a, [hl]
	ld   [hl], a
	call L001EBB
	cp   $10
	ret  c
	ld   bc, $0200
	call L001E95
	ld   a, $02
	ldh  [$FFAC], a
	jp   L001EB1
L0258BB:;I
	call L025901
	and  a
	ret  nz
	jp   L001EB1
L0258C3:;I
	call L025901
	and  a
	ret  z
	ld   bc, $0020
	call L001E95
	jp   L001EB1
L0258D1:;I
	call L025901
	cp   $03
	ret  nz
	ld   bc, $0080
	call L001E95
	jp   L001EB1
L0258E0:;I
	call L025901
	cp   $03
	ret  z
	ld   bc, $0020
	call L001E95
	jp   L001EB1
L0258EF:;I
	call L025901
	and  a
	ret  nz
	ld   bc, $0200
	call L001E95
	jp   L001EB1
L0258FD:;I
	call L00220A
	ret  
L025901:;C
	ldh  a, [$FFAD]
	ld   [$CF38], a
	call L00220A
	ldh  a, [$FFA5]
	ld   [$CF0D], a
	ldh  a, [$FFA7]
	ld   [$CF0E], a
	call L00332F
	ld   a, $00
	adc  a
	ld   b, a
	ld   a, [$CF0E]
	sub  a, $0E
	ld   [$CF0E], a
	push bc
	call L00332F
	ld   a, $00
	adc  a
	add  a
	pop  bc
	add  a, b
	ld   hl, $FFAC
	dec  [hl]
	ret  nz
	push af
	ldh  a, [$FFAD]
	xor  $01
	ldh  [$FFAD], a
	ld   [hl], $02
	pop  af
	ret  
L02593C:;I
	ldh  a, [$FFA1]
	rst  $00
L02593F: db $43
L025940: db $59
L025941: db $6E
L025942: db $59
L025943:;I
	ld   a, $3B
	ld   bc, $0000
	call L001D35
	ld   a, $80
	ldh  [$FFAC], a
	inc  hl
	inc  hl
	call L000755
	and  a, $40
	ld   b, a
	xor  a, [hl]
	ld   [hl], a
	ld   de, $0005
	add  hl, de
	ld   a, b
	add  a
	xor  $80
	ld   b, a
	add  a, $18
	ld   [hl], a
	add  hl, de
	inc  hl
	ld   a, b
	rlca 
	rlca 
	ld   [hl], a
	jp   L001EB1
L02596E:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	jp   L001EB6
L025978:;I
	ldh  a, [$FFA1]
	rst  $00
L02597B: db $85
L02597C: db $59
L02597D: db $97
L02597E: db $59
L02597F: db $A0
L025980: db $59
L025981: db $B3
L025982: db $59
L025983: db $C4
L025984: db $59
L025985:;I
	ldh  a, [$FFA5]
	add  a, $08
	ldh  [$FFA5], a
	ldh  a, [$FFA7]
	ldh  [$FFAD], a
	xor  a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	jp   L001EB1
L025997:;I
	call L001EBB
	cp   $20
	ret  nc
	jp   L001EB1
L0259A0:;I
	call L0023A8
	ret  c
	ld   bc, $0040
	call L001E95
	ldh  a, [$FFA2]
	and  a, $BF
	ldh  [$FFA2], a
	jp   L001EB1
L0259B3:;I
	call L00220A
	ldh  a, [$FFA7]
	ld   b, a
	ldh  a, [$FFAD]
	cp   a, b
	ret  nz
	ld   a, $5A
	ldh  [$FFAC], a
	jp   L001EB1
L0259C4:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L0259D0:;I
	ldh  a, [$FFA1]
	rst  $00
L0259D3: db $DD
L0259D4: db $59
L0259D5: db $F4
L0259D6: db $59
L0259D7: db $FE
L0259D8: db $59
L0259D9: db $15
L0259DA: db $5A
L0259DB: db $33
L0259DC: db $5A
L0259DD:;I
	call L001ED7
	ld   bc, $0100
	call L001E8E
	ld   bc, $0240
	call L001E95
	ld   a, $01
	call L001F34
	jp   L001EB1
L0259F4:;I
	call L002180
	call L002328
	ret  c
	jp   L001EB1
L0259FE:;I
	call L002180
	call L0023A8
	ret  c
	ld   a, $03
	ldh  [$FFAD], a
	ld   a, $00
	call L001F34
	ld   a, $40
	ldh  [$FFAC], a
	jp   L001EB1
L025A15:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	call L001ED7
	ld   a, $3F
	ld   bc, $0000
	call L001D35
	ld   hl, $FFAD
	dec  [hl]
	ld   a, $40
	ldh  [$FFAC], a
	ret  nz
	jp   L001EB1
L025A33:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $00
	ldh  [$FFA1], a
	ret  
L025A3F:;I
	ldh  a, [$FFA1]
	rst  $00
L025A42: db $46
L025A43: db $5A
L025A44: db $4C
L025A45: db $5A
L025A46:;I
	call L001FB9
	jp   L001EB1
L025A4C:;I
	call L002150
	call L00220A
	ret  
L025A53:;I
	ldh  a, [$FFA1]
	rst  $00
L025A56: db $5E
L025A57: db $5A
L025A58: db $70
L025A59: db $5A
L025A5A: db $9B
L025A5B: db $5A
L025A5C: db $B4
L025A5D: db $5A
L025A5E:;I
	ld   bc, $0120
	call L001E8E
	xor  a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB1
L025A70:;I
	ld   c, $01
	call L001F51
	call L002150
	call L002117
	ld   a, [$CF26]
	cp   $03
	jp   z, L001EB1
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ldh  a, [$FFA2]
	and  a, $C0
	ldh  [$FFA2], a
	ld   bc, $0300
	call L001E95
	ld   a, $03
	ldh  [$FFA1], a
	ret  
L025A9B:;I
	ldh  a, [$FFA2]
	and  a, $C0
	ldh  [$FFA2], a
	ld   a, $01
	ld   [$CF38], a
	call L002150
	call L0023A8
	ret  c
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB6
L025AB4:;I
	ldh  a, [$FFA2]
	and  a, $C0
	ldh  [$FFA2], a
	ld   a, $01
	ld   [$CF38], a
	call L002150
	call L002328
	ret  c
	jp   L001EB6
L025AC9:;I
	ldh  a, [$FFA1]
	rst  $00
L025ACC: db $D0
L025ACD: db $5A
L025ACE: db $F2
L025ACF: db $5A
L025AD0:;I
	ld   a, $40
	ldh  [$FFAC], a
	ld   a, $40
	call L001E63
	ld   a, b
	and  a
	jp   nz, L001EB1
	ld   a, $40
	ld   bc, $0000
	call L001D35
	jp   c, L001EB1
	ld   a, l
	add  a, $05
	ld   l, a
	ld   [hl], $B0
	jp   L001EB1
L025AF2:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	jp   L001EB6
L025AFC:;I
	ldh  a, [$FFA1]
	rst  $00
L025AFF: db $0D
L025B00: db $5B
L025B01: db $14
L025B02: db $5B
L025B03: db $26
L025B04: db $5B
L025B05: db $54
L025B06: db $5B
L025B07: db $7A
L025B08: db $5B
L025B09: db $8D
L025B0A: db $5B
L025B0B: db $BC
L025B0C: db $5B
L025B0D:;I
	ld   a, $F0
	ldh  [$FFAC], a
	jp   L001EB1
L025B14:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $01
	ldh  [$FFAD], a
	ld   a, $08
	ldh  [$FFAC], a
	jp   L001EB1
L025B26:;I
	ldh  a, [$FFAD]
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $08
	ldh  [$FFAC], a
	ldh  a, [$FFAD]
	inc  a
	ldh  [$FFAD], a
	cp   $05
	ret  nz
	call L001FB9
	call L0020CB
	ld   b, $02
	call L001F16
	ld   a, $08
	ldh  [$FFAE], a
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L025B54:;I
	call L025BC6
	call L002150
	call L00220A
	ld   a, [$CF5D]
	ld   b, a
	ld   a, [$CF2F]
	cp   a, b
	jp   z, L001EB1
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	call L001FB9
	call L0020CB
	ld   a, $10
	ldh  [$FFAC], a
	ret  
L025B7A:;I
	ldh  a, [$FFA2]
	and  a, $BF
	ldh  [$FFA2], a
	ld   bc, $0080
	call L001E95
	ld   a, $08
	ldh  [$FFAE], a
	jp   L001EB1
L025B8D:;I
	call L025BC6
	call L00223A
	jp   nc, L001EB1
	ldh  a, [$FFA7]
	sub  a, $08
	ld   [$CF0E], a
	and  a, $F0
	cp   $10
	jp   z, L001EB1
	ldh  a, [$FFA5]
	ld   [$CF0D], a
	call L00332F
	cp   $03
	jp   z, L001EB1
	cp   $04
	jp   z, L001EB1
	cp   $05
	jp   z, L001EB1
	ret  
L025BBC:;I
	ld   b, $03
	call L001F16
	ld   a, $00
	ldh  [$FFA1], a
	ret  
L025BC6:;C
	ldh  a, [$FFAD]
	ld   [$CF38], a
	ld   hl, $FFAE
	dec  [hl]
	ret  nz
	ld   [hl], $08
	ldh  a, [$FFAD]
	inc  a
	ldh  [$FFAD], a
	cp   $08
	ret  nz
	ld   a, $05
	ldh  [$FFAD], a
	ret  
L025BDF:;I
	ldh  a, [$FFA1]
	rst  $00
L025BE2: db $EE
L025BE3: db $5B
L025BE4: db $F8
L025BE5: db $5B
L025BE6: db $16
L025BE7: db $5C
L025BE8: db $29
L025BE9: db $5C
L025BEA: db $47
L025BEB: db $5C
L025BEC: db $59
L025BED: db $5C
L025BEE:;I
	call L027E4C
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L025BF8:;I
	call L027E61
	ret  c
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $02
	call L001F34
	call L000755
	and  a, $03
	add  a, $03
	ld   a, $04
	ldh  [$FFAD], a
	jp   L001EB1
L025C16:;I
	call L027E61
	ret  c
	ld   a, $44
	ld   bc, $F000
	call L001D35
	ld   a, $04
	ldh  [$FFAC], a
	jp   L001EB1
L025C29:;I
	call L027E61
	ret  c
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   hl, $FFAD
	dec  [hl]
	jp   nz, L001EB6
	ld   a, $00
	call L001F34
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L025C47:;I
	call L027E61
	ret  c
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB1
L025C59:;I
	call L027E61
	ret  c
	ld   c, $01
	call L001F43
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $10
	ldh  [$FFAC], a
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L025C72:;I
	ldh  a, [$FFA1]
	rst  $00
L025C75: db $79
L025C76: db $5C
L025C77: db $8E
L025C78: db $5C
L025C79:;I
	ldh  a, [$FFA2]
	or   a, $40
	ldh  [$FFA2], a
	ld   bc, $01C0
	call L001E8E
	ld   bc, $0300
	call L001E95
	jp   L001EB1
L025C8E:;I
	call L002150
	call L00220A
	ldh  a, [$FFAA]
	ld   l, a
	ldh  a, [$FFAB]
	ld   h, a
	ld   de, $FFE0
	add  hl, de
	ld   a, l
	ldh  [$FFAA], a
	ld   a, h
	ldh  [$FFAB], a
	ret  
L025CA5:;I
	ldh  a, [$FFA1]
	rst  $00
L025CA8: db $B0
L025CA9: db $5C
L025CAA: db $C2
L025CAB: db $5C
L025CAC: db $D3
L025CAD: db $5C
L025CAE: db $EC
L025CAF: db $5C
L025CB0:;I
	ld   hl, $FFA2
	res  6, [hl]
	ld   bc, $0020
	call L001E95
	ld   a, $40
	ldh  [$FFAC], a
	jp   L001EB1
L025CC2:;I
	call L00220A
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $40
	ldh  [$FFAC], a
	jp   L001EB1
L025CD3:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   hl, $FFA2
	set  6, [hl]
	ld   bc, $0080
	call L001E95
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L025CEC:;I
	call L00220A
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	xor  a
	ldh  [$FFA0], a
	ret  
L025CFA:;I
	ldh  a, [$FFA1]
	rst  $00
L025CFD: db $03
L025CFE: db $5D
L025CFF: db $1F
L025D00: db $5D
L025D01: db $59
L025D02: db $5D
L025D03:;I
	ld   a, [$CF00]
	and  a
	ret  nz
	call L001EBB
	cp   $40
	ret  nc
	call L027E6D
	xor  a
	ldh  [$FFAD], a
	ld   a, $10
	ldh  [$FFAC], a
	ld   a, $10
	ldh  [$FFAE], a
	jp   L001EB1
L025D1F:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	jp   nz, L001EB1
	ld   a, $40
	ldh  [$FFAC], a
	call L001EBB
	cp   $20
	jp   nc, L001EB1
	ld   a, $47
	call L001E63
	ld   a, b
	cp   $03
	jp   nc, L001EB1
	ld   a, $47
	ld   bc, $00FE
	call L001D35
	jp   c, L001EB1
	inc  hl
	inc  hl
	ldh  a, [$FFAD]
	xor  a, [hl]
	ld   [hl], a
	ldh  a, [$FFAD]
	xor  $80
	ldh  [$FFAD], a
	jp   L001EB1
L025D59:;I
	ld   hl, $FFAE
	dec  [hl]
	jp   nz, L001EB6
	ld   [hl], $80
	ldh  a, [$FFA5]
	cp   $B0
	ret  nc
	ld   a, $45
	ld   bc, $EEE8
	call L001D35
	jp   c, L001EB6
	ld   de, $0005
	add  hl, de
	ldh  a, [$FF91]
	and  a, $07
	ld   b, a
	add  a, [hl]
	and  a, $F8
	sub  a, b
	add  a, $05
	ld   [hl], a
	ld   a, $45
	ld   bc, $14E8
	call L001D35
	jp   c, L001EB6
	ld   de, $0005
	add  hl, de
	ldh  a, [$FF91]
	and  a, $07
	ld   b, a
	add  a, [hl]
	and  a, $F8
	sub  a, b
	add  a, $03
	ld   [hl], a
	jp   L001EB6
L025DA0:;I
	ldh  a, [$FFA1]
	rst  $00
L025DA3: db $AB
L025DA4: db $5D
L025DA5: db $C1
L025DA6: db $5D
L025DA7: db $DD
L025DA8: db $5D
L025DA9: db $FC
L025DAA: db $5D
L025DAB:;I
	ld   bc, $1000
	call L001E8E
	call L002150
	ld   bc, $0040
	call L001E8E
	ld   a, $40
	ldh  [$FFAC], a
	jp   L001EB1
L025DC1:;I
	ld   c, $01
	call L001F43
	call L002150
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   bc, $0140
	call L001E95
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB1
L025DDD:;I
	ld   c, $01
	call L001F43
	call L00220A
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	call L001FB9
	call L0020CB
	call L0020CB
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L025DFC:;I
	ld   c, $01
	call L001F43
	call L002150
	call L00220A
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	call L001FB9
	call L0020CB
	call L0020CB
	ld   a, $10
	ldh  [$FFAC], a
	ret  
L025E1C:;I
	ldh  a, [$FFA1]
	rst  $00
L025E1F: db $23
L025E20: db $5E
L025E21: db $2A
L025E22: db $5E
L025E23:;I
	ld   a, $30
	ldh  [$FFAC], a
	jp   L001EB1
L025E2A:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $30
	ldh  [$FFAC], a
	call L001EBB
	cp   $40
	ret  nc
	ld   a, $49
	ld   bc, $00F8
	call L001D35
	ret  
L025E44:;I
	ldh  a, [$FFA1]
	rst  $00
L025E47: db $51
L025E48: db $5E
L025E49: db $5C
L025E4A: db $5E
L025E4B: db $85
L025E4C: db $5E
L025E4D: db $92
L025E4E: db $5E
L025E4F: db $A3
L025E50: db $5E
L025E51:;I
	ld   de, $0002
	ld   c, $08
	call L001F7D
	jp   L001EB1
L025E5C:;I
	call L001F8B
	ret  z
	call L001ED7
	call L001EBB
	ld   l, a
	ld   h, $00
	add  hl, hl
	add  hl, hl
	push hl
	call L000755
	pop  hl
	and  a, $0F
	ld   e, a
	ld   d, $00
	add  hl, de
	ld   a, l
	ldh  [$FFA8], a
	ld   a, h
	ldh  [$FFA9], a
	ld   bc, $0300
	call L001E95
	jp   L001EB1
L025E85:;I
	call L025EB0
	call L002180
	call L002328
	ret  c
	jp   L001EB1
L025E92:;I
	call L025EB0
	call L002180
	call L0023A8
	ret  c
	ld   a, $40
	ldh  [$FFAC], a
	jp   L001EB1
L025EA3:;I
	call L025EB0
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	jp   L001E11
L025EB0:;C
	ldh  a, [$FF8F]
	rrca 
	rrca 
	rrca 
	and  a, $01
	add  a, $02
	ld   [$CF38], a
	ret  
L025EBD:;I
	ldh  a, [$FFA1]
	rst  $00
L025EC0: db $C6
L025EC1: db $5E
L025EC2: db $CD
L025EC3: db $5E
L025EC4: db $F5
L025EC5: db $5E
L025EC6:;I
	ld   a, $40
	ldh  [$FFAC], a
	jp   L001EB1
L025ECD:;I
	call L001EBB
	jr   c, L025EDE
	cp   $60
	jr   nc, L025EDE
	ld   a, $00
	ld   bc, $0080
	call L0018B9
L025EDE:;R
	ldh  a, [$FF8F]
	rrca 
	rrca 
	and  a, $01
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L025EF5:;I
	call L001EBB
	jr   c, L025F06
	cp   $60
	jr   nc, L025F06
	ld   a, $00
	ld   bc, $0080
	call L0018B9
L025F06:;R
	ldh  a, [$FF8F]
	rrca 
	rrca 
	and  a, $01
	add  a, $02
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $40
	ldh  [$FFAC], a
	jp   L001EB6
L025F1F:;I
	ldh  a, [$FFA1]
	rst  $00
L025F22: db $28
L025F23: db $5F
L025F24: db $33
L025F25: db $5F
L025F26: db $59
L025F27: db $5F
L025F28:;I
	ld   a, $40
	ldh  [$FFA2], a
	ld   a, $80
	ldh  [$FFAC], a
	jp   L001EB1
L025F33:;I
	ld   c, $01
	call L001F43
	call L025F71
	call L001ED7
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $10
	ldh  [$FFAC], a
	ld   a, $02
	ld   [$CF38], a
	ld   a, $4D
	ld   bc, $00F8
	call L001D35
	jp   L001EB1
L025F59:;I
	ld   a, $03
	ld   [$CF38], a
	call L025F71
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $80
	ldh  [$FFAC], a
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L025F71:;C
	ldh  a, [$FFAD]
	ld   l, a
	ld   h, $CD
	ldi  a, [hl]
	ldh  [$FFA5], a
	inc  hl
	ld   a, [hl]
	sub  a, $10
	ldh  [$FFA7], a
	ret  
L025F80:;I
	ldh  a, [$FFA1]
	rst  $00
L025F83: db $87
L025F84: db $5F
L025F85: db $A3
L025F86: db $5F
L025F87:;I
	call L002038
	ld   a, $40
	ldh  [$FFA2], a
	ld   a, $4B
	ld   bc, $00F0
	call L001D35
	ld   de, $000D
	add  hl, de
	ld   a, [$CF2F]
	add  a, $05
	ld   [hl], a
	jp   L001EB1
L025FA3:;I
	ldh  a, [$FF8F]
	rrca 
	rrca 
	and  a, $01
	ld   [$CF38], a
	ld   a, $01
	call L002047
	call L0020CB
	call L002150
	call L00220A
	ld   a, [$CF2F]
	ld   b, a
	ld   a, [$CF4A]
	cp   a, b
	ret  nz
	ldh  a, [$FFA8]
	ld   c, a
	ldh  a, [$FFA9]
	ld   b, a
	ldh  a, [$FFA2]
	jp   L0018B9
L025FCE:;I
	ldh  a, [$FFA1]
	rst  $00
L025FD1: db $D7
L025FD2: db $5F
L025FD3: db $F2
L025FD4: db $5F
L025FD5: db $01
L025FD6: db $60
L025FD7:;I
	call L001ED7
	ld   bc, $0800
	call L001E8E
	call L002150
	ld   bc, $0100
	call L001E8E
	ld   bc, $0200
	call L001E95
	jp   L001EB1
L025FF2:;I
	ld   c, $02
	call L001F43
	call L002150
	call L0022C6
	ret  c
	jp   L001EB1
L026001:;I
	ld   c, $02
	call L001F43
	call L002150
	call L0022F7
	ret  
L02600D:;I
	ldh  a, [$FFA1]
	rst  $00
L026010: db $14
L026011: db $60
L026012: db $2A
L026013: db $60
L026014:;I
	ld   bc, $0601
	call L001F5F
	call L001FB9
	call L0020CB
	call L0020CB
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L02602A:;I
	ld   bc, $0601
	call L001F5F
	call L002150
	call L00220A
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	call L001FB9
	call L0020CB
	call L0020CB
	ld   a, $10
	ldh  [$FFAC], a
	ret  
L02604B:;I
	ldh  a, [$FFA1]
	rst  $00
L02604E: db $52
L02604F: db $60
L026050: db $59
L026051: db $60
L026052:;I
	ld   a, $40
	ldh  [$FFAC], a
	jp   L001EB1
L026059:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $00
	ldh  [$FFA1], a
	ld   a, $32
	call L001E63
	ld   a, b
	and  a
	ret  nz
	ld   a, $32
	ld   bc, $0000
	call L001D35
	ld   a, l
	add  a, $05
	ld   l, a
	ld   a, [$CF12]
	rrca 
	ld   [hl], a
	rrca 
	add  a, [hl]
	ld   [hl], a
	ret  
L026081:;I
	ldh  a, [$FFA1]
	rst  $00
L026084: db $96
L026085: db $7D
L026086: db $9A
L026087: db $60
L026088: db $BA
L026089: db $60
L02608A: db $CC
L02608B: db $60
L02608C: db $E6
L02608D: db $60
L02608E: db $FF
L02608F: db $60
L026090: db $12
L026091: db $61
L026092: db $28
L026093: db $61
L026094: db $3E
L026095: db $61
L026096: db $57
L026097: db $61
L026098: db $6D
L026099: db $61
L02609A:;I
	call L0261A3
	call L026181
	call L001EBB
	ld   l, a
	ld   h, $00
	add  hl, hl
	add  hl, hl
	ld   a, l
	ldh  [$FFA8], a
	ld   a, h
	ldh  [$FFA9], a
	ld   bc, $0380
	call L001E95
	call L001ED7
	jp   L001EB1
L0260BA:;I
	call L0261A3
	ld   a, $01
	ld   [$CF38], a
	call L002180
	call L002328
	ret  c
	jp   L001EB1
L0260CC:;I
	call L0261A3
	ld   a, $00
	ld   [$CF38], a
	call L002180
	call L0023A8
	ret  c
	ld   a, $58
	ld   bc, $0000
	call L001D35
	jp   L001EB1
L0260E6:;I
	call L0261A3
	call L026181
	ld   a, $58
	call L001E63
	ld   a, b
	and  a
	ret  nz
	ld   a, $59
	ld   bc, $0000
	call L001D35
	jp   L001EB1
L0260FF:;I
	call L0261A3
	call L026181
	ld   a, $59
	call L001E63
	ld   a, b
	and  a
	ret  nz
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L026112:;I
	call L0261A3
	ld   a, $00
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L026128:;I
	call L0261A3
	ld   a, $02
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L02613E:;I
	call L0261A3
	ld   a, $03
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	call L001ED7
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L026157:;I
	call L0261A3
	ld   a, $02
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L02616D:;I
	call L0261A3
	ld   a, $00
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ldh  a, [$FFAD]
	ldh  [$FFA1], a
	ret  
L026181:;C
	ldh  a, [$FFA2]
	ld   b, a
	and  a, $C0
	ld   c, a
	push bc
	call L001ED7
	pop  bc
	ld   hl, $FFA2
	ld   a, [hl]
	and  a, $C0
	cp   a, c
	ld   [hl], b
	ret  z
	ld   a, $10
	ldh  [$FFAC], a
	ld   hl, $FFA1
	ld   a, [hl]
	ldh  [$FFAD], a
	ld   [hl], $06
	pop  hl
	ret  
L0261A3:;C
	call L001F2A
	cp   $08
	ret  nc
	ld   a, $FF
	ld   [$CCFD], a
	ldh  a, [$FFA7]
	sub  a, $18
	ld   [$CCEE], a
	ld   [$CF2C], a
	ldh  a, [$FFA5]
	ld   [$CF2B], a
	ld   [$CCEF], a
	call L001C8D
	ld   a, $06
	ldh  [$FF99], a
	pop  hl
	jp   L001E11
L0261CB:;I
	ldh  a, [$FFA1]
	rst  $00
L0261CE: db $96
L0261CF: db $7D
L0261D0: db $DE
L0261D1: db $61
L0261D2: db $F1
L0261D3: db $61
L0261D4: db $14
L0261D5: db $62
L0261D6: db $30
L0261D7: db $62
L0261D8: db $57
L0261D9: db $62
L0261DA: db $70
L0261DB: db $62
L0261DC: db $91;X
L0261DD: db $62;X
L0261DE:;I
	ld   b, $F4
	call L001F16
	call L0262D3
	ld   a, $02
	ldh  [$FFAD], a
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB1
L0261F1:;I
	ld   a, $02
	ld   [$CF38], a
	call L0262D3
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $5B
	ld   bc, $00F8
	call L001D35
	ld   a, $20
	ldh  [$FFAC], a
	ld   hl, $FFAD
	dec  [hl]
	ret  nz
	jp   L001EB1
L026214:;I
	ld   c, $01
	call L001F43
	call L0262D3
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   bc, $0080
	call L001E8E
	ld   a, $60
	ldh  [$FFAC], a
	jp   L001EB1
L026230:;I
	ld   c, $01
	call L001F43
	call L0262D3
	call L002150
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $5A
	ld   bc, $0000
	call L001D35
	ld   bc, $FF80
	call L001E8E
	ld   a, $80
	ldh  [$FFAC], a
	jp   L001EB1
L026257:;I
	call L0262B1
	call L0262D3
	ld   c, $01
	call L001F43
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $60
	ldh  [$FFAC], a
	jp   L001EB1
L026270:;I
	ld   c, $01
	call L001F43
	call L0262D3
	call L002150
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   bc, $0080
	call L001E8E
	ld   a, $60
	ldh  [$FFAC], a
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L026291: db $21;X
L026292: db $A2;X
L026293: db $FF;X
L026294: db $CB;X
L026295: db $9E;X
L026296: db $3E;X
L026297: db $03;X
L026298: db $EA;X
L026299: db $38;X
L02629A: db $CF;X
L02629B: db $CD;X
L02629C: db $D3;X
L02629D: db $62;X
L02629E: db $F0;X
L02629F: db $AC;X
L0262A0: db $D6;X
L0262A1: db $01;X
L0262A2: db $E0;X
L0262A3: db $AC;X
L0262A4: db $C0;X
L0262A5: db $CD;X
L0262A6: db $D7;X
L0262A7: db $1E;X
L0262A8: db $3E;X
L0262A9: db $80;X
L0262AA: db $E0;X
L0262AB: db $AC;X
L0262AC: db $3E;X
L0262AD: db $06;X
L0262AE: db $E0;X
L0262AF: db $A1;X
L0262B0: db $C9;X
L0262B1:;C
	ldh  a, [$FFA2]
	ld   c, a
	and  a, $80
	ld   b, a
	push bc
	call L001ED7
	pop  bc
	ld   hl, $FFA2
	ld   a, [hl]
	and  a, $80
	cp   a, b
	ld   [hl], c
	ret  z
L0262C5: db $3E;X
L0262C6: db $10;X
L0262C7: db $E0;X
L0262C8: db $AC;X
L0262C9: db $21;X
L0262CA: db $A1;X
L0262CB: db $FF;X
L0262CC: db $7E;X
L0262CD: db $E0;X
L0262CE: db $AD;X
L0262CF: db $36;X
L0262D0: db $07;X
L0262D1: db $E1;X
L0262D2: db $C9;X
L0262D3:;C
	call L001F2A
	cp   $08
	ret  nc
	ld   a, $FF
	ld   [$CCFD], a
	ldh  a, [$FFA7]
	sub  a, $10
	ld   [$CCEE], a
	ld   [$CF2C], a
	ldh  a, [$FFA5]
	ld   [$CF2B], a
	ld   [$CCEF], a
	call L001C8D
	ld   a, $06
	ldh  [$FF99], a
	pop  hl
	jp   L001E11
L0262FB:;I
	ldh  a, [$FFA1]
	rst  $00
L0262FE: db $0C
L0262FF: db $63
L026300: db $96
L026301: db $7D
L026302: db $0D
L026303: db $63
L026304: db $27
L026305: db $63
L026306: db $41
L026307: db $63
L026308: db $97
L026309: db $63
L02630A: db $A5
L02630B: db $63
L02630C:;I
	ret  
L02630D:;I
	ld   b, $F0
	call L001F16
	ld   hl, $FFA2
	res  7, [hl]
	xor  a
	ldh  [$FFAD], a
	ld   bc, $0080
	call L001E8E
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L026327:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $5C
	ld   bc, $00F0
	call L001D35
	ld   a, $04
	ldh  [$FFAD], a
	ld   a, $80
	ldh  [$FFAC], a
	jp   L001EB1
L026341:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $5D
	ld   bc, $10E0
	call L001D35
	ld   de, $0008
	add  hl, de
	ld   [hl], $20
	inc  hl
	ld   [hl], $00
	ld   a, $5D
	ld   bc, $10E0
	call L001D35
	ld   de, $0008
	add  hl, de
	ld   [hl], $E0
	inc  hl
	ld   [hl], $00
	ld   a, $5D
	ld   bc, $10E0
	call L001D35
	ld   de, $0008
	add  hl, de
	ld   [hl], $80
	inc  hl
	ld   [hl], $01
	ld   a, $5D
	ld   bc, $10E0
	call L001D35
	ld   de, $0008
	add  hl, de
	ld   [hl], $20
	inc  hl
	ld   [hl], $02
	ld   a, $06
	ldh  [$FFAD], a
	ld   a, $80
	ldh  [$FFAC], a
	jp   L001EB1
L026397:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB1
L0263A5:;I
	ld   a, $01
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $80
	ldh  [$FFAC], a
	ld   a, $03
	ldh  [$FFA1], a
	ret  
L0263BA:;C
	ldh  a, [$FFAD]
	rst  $00
L0263BD: db $CB
L0263BE: db $63
L0263BF: db $E1
L0263C0: db $63
L0263C1: db $03
L0263C2: db $64
L0263C3: db $1A
L0263C4: db $64
L0263C5: db $34
L0263C6: db $64
L0263C7: db $56
L0263C8: db $64
L0263C9: db $68;X
L0263CA: db $64;X
L0263CB:;I
	ld   a, $00
	call L001F34
	ld   c, $01
	call L001F43
	call L001ED7
	ld   a, $80
	ldh  [$FFAC], a
	ld   hl, $FFAD
	inc  [hl]
	ret  
L0263E1:;I
	ld   c, $01
	call L001F43
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   bc, $0080
	call L001E8E
	ld   bc, $0080
	call L001E95
	ld   hl, $FFA2
	res  6, [hl]
	ld   hl, $FFAD
	inc  [hl]
	ret  
L026403:;I
	ld   c, $01
	call L001F43
	call L00220A
	ldh  a, [$FFA7]
	cp   $38
	ret  nz
	ld   hl, $FFA2
	set  7, [hl]
	ld   hl, $FFAD
	inc  [hl]
	ret  
L02641A:;I
	ld   c, $01
	call L001F43
	ldh  a, [$FFA5]
	cp   $90
	jp   c, L002150
	ld   hl, $FFA2
	set  6, [hl]
	ld   a, $80
	ldh  [$FFAC], a
	ld   hl, $FFAD
	inc  [hl]
	ret  
L026434:;I
	ld   c, $01
	call L001F43
	ld   hl, $FFA4
	ldh  a, [$FFA8]
	add  a, [hl]
	ld   [hl], a
	call c, L026469
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   hl, $FFA2
	res  7, [hl]
	set  6, [hl]
	ld   hl, $FFAD
	inc  [hl]
	ret  
L026456:;I
	ld   c, $01
	call L001F43
	call L00220A
	ldh  a, [$FFA7]
	cp   $70
	ret  nz
	ld   hl, $FFAD
	inc  [hl]
	ret  
L026468: db $C9;X
L026469:;C
	push hl
	call L000DDB
	pop  hl
	ldh  a, [$FFA5]
	cp   $91
	ret  nc
	inc  hl
	inc  [hl]
	ret  
L026476:;I
	ldh  a, [$FFA1]
	rst  $00
L026479: db $95
L02647A: db $64
L02647B: db $9C
L02647C: db $64
L02647D: db $C7
L02647E: db $64
L02647F: db $DE
L026480: db $64
L026481: db $F0
L026482: db $64
L026483: db $07
L026484: db $65
L026485: db $22
L026486: db $65
L026487: db $6D
L026488: db $65
L026489: db $A2
L02648A: db $65
L02648B: db $B7
L02648C: db $65
L02648D: db $C6
L02648E: db $65
L02648F: db $DC
L026490: db $65
L026491: db $EF
L026492: db $65
L026493: db $00
L026494: db $66
L026495:;I
	ld   a, $80
	ldh  [$FFAC], a
	jp   L001EB1
L02649C:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $03
	ld   [$CF38], a
	ld   a, $56
	ld   bc, $0000
	call L001D35
	ld   de, $0005
	add  hl, de
	ld   [hl], $60
	inc  hl
	inc  hl
	ld   [hl], $40
	inc  de
	add  hl, de
	ld   [hl], $00
	ld   a, l
	ldh  [$FFAE], a
	ld   a, h
	ldh  [$FFAF], a
	jp   L001EB1
L0264C7:;I
	ld   a, $03
	ld   [$CF38], a
	ldh  a, [$FFAE]
	ld   l, a
	ldh  a, [$FFAF]
	ld   h, a
	ld   a, [hl]
	and  a
	ret  z
	ld   bc, $0380
	call L001E95
	jp   L001EB1
L0264DE:;I
	ld   a, $04
	ld   [$CF38], a
	call L002328
	ret  c
	ld   bc, $0000
	call L001E8E
	jp   L001EB1
L0264F0:;I
	call L02660D
	ret  c
	ld   a, $05
	ld   [$CF38], a
	call L002180
	call L0023A8
	ret  c
	ld   a, $08
	ldh  [$FFAC], a
	jp   L001EB1
L026507:;I
	call L02660D
	ret  c
	ld   a, $06
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $0C
	ldh  [$FFAD], a
	ld   a, $08
	ldh  [$FFAC], a
	jp   L001EB1
L026522:;I
	call L02660D
	ret  c
	ld   a, $05
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $08
	ldh  [$FFAC], a
	ldh  a, [$FFAD]
	cp   $06
	jp   c, L001EB1
	rrca 
	jp   nc, L001EB1
	ld   a, $57
	ld   bc, $FA00
	call L001D35
	ld   a, $57
	ld   bc, $FE00
	call L001D35
	inc  hl
	ld   [hl], $01
	ld   a, $57
	ld   bc, $0200
	call L001D35
	inc  hl
	ld   [hl], $02
	ld   a, $57
	ld   bc, $0600
	call L001D35
	inc  hl
	ld   [hl], $03
	jp   L001EB1
L02656D:;I
	call L02660D
	ret  c
	ld   a, $06
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $08
	ldh  [$FFAC], a
	ld   hl, $FFAD
	dec  [hl]
	jp   nz, L001EB6
	call L001ED7
	call L001EBB
	ld   l, a
	ld   h, $00
	add  hl, hl
	add  hl, hl
	ld   a, l
	ldh  [$FFA8], a
	ld   a, h
	ldh  [$FFA9], a
	ld   bc, $0380
	call L001E95
	jp   L001EB1
L0265A2:;I
	call L02660D
	ret  c
	ld   a, $05
	ld   [$CF38], a
	call L002180
	call L002328
	ret  c
	ld   a, $04
	ldh  [$FFA1], a
	ret  
L0265B7:;I
	call L0023A8
	ret  c
	ld   de, $070A
	ld   c, $04
	call L001F7D
	jp   L001EB1
L0265C6:;I
	call L001F8B
	ret  z
	ld   hl, $FFA2
	res  6, [hl]
	ld   bc, $0400
	call L001E95
	ld   a, $0D
	ldh  [$FF99], a
	jp   L001EB1
L0265DC:;I
	ld   a, $0B
	ld   [$CF38], a
	call L00220A
	ldh  a, [$FFA7]
	cp   $18
	ret  nc
	xor  a
	ldh  [$FFA7], a
	jp   L001EB1
L0265EF:;I
	ld   a, [$CF1D]
	or   a
	ret  nz
	ld   a, $15
	ld   [$CF1D], a
	ld   a, $3C
	ldh  [$FFAC], a
	jp   L001EB1
L026600:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $02
	ld   [$CF60], a
	ret  
L02660D:;C
	call L001F2A
	cp   $11
	ret  nc
	ld   a, $09
	ldh  [$FFA1], a
	scf  
	ret  
L026619:;I
	ldh  a, [$FFA1]
	rst  $00
L02661C: db $22
L02661D: db $66
L02661E: db $37
L02661F: db $66
L026620: db $47
L026621: db $66
L026622:;I
	ldh  a, [$FFAD]
	ld   [$CF38], a
	ldh  a, [$FFAE]
	sub  a, $08
	ld   l, a
	ld   h, $CD
	ld   a, [hl]
	ldh  [$FFA5], a
	cp   $88
	ret  nz
	jp   L001EB1
L026637:;I
	call L026658
	ld   [$CF38], a
	sub  a, [hl]
	ret  nz
	ld   [hl], a
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB1
L026647:;I
	call L026658
	inc  a
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	jp   L001EB6
L026658:;C
	ldh  a, [$FFAE]
	ld   l, a
	ld   h, $CD
	ldh  a, [$FFAD]
	ret  
L026660:;I
	ldh  a, [$FFA1]
	rst  $00
L026663: db $69
L026664: db $66
L026665: db $77
L026666: db $66
L026667: db $82
L026668: db $66
L026669:;I
	ld   bc, $0080
	call L001E8E
	ld   hl, $FFAD
	res  7, [hl]
	jp   L001EB1
L026677:;I
	call L002150
	ldh  a, [$FFA5]
	cp   $90
	ret  nz
	jp   L001EB1
L026682:;I
	ret  
L026683:;I
	ldh  a, [$FFA1]
	rst  $00
L026686: db $92
L026687: db $66
L026688: db $9A
L026689: db $66
L02668A: db $A5
L02668B: db $66
L02668C: db $C9
L02668D: db $66
L02668E: db $D3
L02668F: db $66
L026690: db $E5
L026691: db $66
L026692:;I
	xor  a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	jp   L001EB1
L02669A:;I
	call L0023A8
	ret  c
	ld   a, $04
	ldh  [$FFAC], a
	jp   L001EB1
L0266A5:;I
	ld   a, $01
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $FF
	ldh  [$FFAD], a
	ld   hl, $FFA2
	set  7, [hl]
	ld   bc, $0140
	call L001E8E
	ld   bc, $0380
	call L001E95
	jp   L001EB1
L0266C9:;I
	call L002150
	call L002328
	ret  c
	jp   L001EB1
L0266D3:;I
	call L002150
	call L0023A8
	ldh  a, [$FFA5]
	cp   $90
	ret  c
	ld   a, $04
	ldh  [$FFAC], a
	jp   L001EB1
L0266E5:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	xor  a
	ldh  [$FFA0], a
	ret  
L0266F0:;I
	ldh  a, [$FFA1]
	rst  $00
L0266F3: db $FF
L0266F4: db $66
L0266F5: db $16
L0266F6: db $67
L0266F7: db $2D
L0266F8: db $67
L0266F9: db $46
L0266FA: db $67
L0266FB: db $5D
L0266FC: db $67
L0266FD: db $67
L0266FE: db $67
L0266FF:;I
	ld   bc, $0060
	call L001E8E
	ld   bc, $0240
	call L001E95
	ldh  a, [$FFA2]
	and  a, $3F
	ldh  [$FFA2], a
	ld   a, $04
	ldh  [$FFA1], a
	ret  
L026716:;I
	ld   bc, $0020
	call L001E8E
	ld   bc, $02C0
	call L001E95
	ldh  a, [$FFA2]
	and  a, $3F
	ldh  [$FFA2], a
	ld   a, $04
	ldh  [$FFA1], a
	ret  
L02672D:;I
	ld   bc, $0020
	call L001E8E
	ld   bc, $02C0
	call L001E95
	ldh  a, [$FFA2]
	and  a, $3F
	or   a, $80
	ldh  [$FFA2], a
	ld   a, $04
	ldh  [$FFA1], a
	ret  
L026746:;I
	ld   bc, $0060
	call L001E8E
	ld   bc, $0240
	call L001E95
	ldh  a, [$FFA2]
	and  a, $3F
	or   a, $80
	ldh  [$FFA2], a
	jp   L001EB1
L02675D:;I
	call L002150
	call L002328
	ret  c
	jp   L001EB1
L026767:;I
	call L002150
	call L0023A8
	ret  c
	jp   L001E11
L026771:;I
	ldh  a, [$FFA1]
	rst  $00
L026774: db $7A
L026775: db $67
L026776: db $8C
L026777: db $67
L026778: db $96
L026779: db $67
L02677A:;I
	call L001ED7
	ld   bc, $0100
	call L001E8E
	ld   bc, $0300
	call L001E95
	jp   L001EB1
L02678C:;I
	call L002150
	call L0022C6
	ret  c
	jp   L001EB1
L026796:;I
	call L002150
	call L0023A8
	ret  c
	ld   bc, $0300
	call L001E95
	jp   L001EB6
L0267A6:;I
	ldh  a, [$FFA1]
	rst  $00
L0267A9: db $AD
L0267AA: db $67
L0267AB: db $B9
L0267AC: db $67
L0267AD:;I
	call L001ED7
	ld   bc, $0200
	call L001E8E
	jp   L001EB1
L0267B9:;I
	call L002150
	ret  
L0267BD:;I
	ldh  a, [$FFA1]
	rst  $00
L0267C0: db $CA
L0267C1: db $67
L0267C2: db $D6
L0267C3: db $67
L0267C4: db $E0
L0267C5: db $67
L0267C6: db $12
L0267C7: db $68
L0267C8: db $26
L0267C9: db $68
L0267CA:;I
	call L001ED7
	ld   bc, $0080
	call L001E8E
	jp   L001EB1
L0267D6:;I
	call L002150
	call L002328
	ret  c
	jp   L001EB1
L0267E0:;I
	call L002150
	call L0023A8
	ret  c
	ld   bc, $0380
	call L001E95
	ldh  a, [$FFA2]
	push af
	call L001ED7
	pop  af
	ld   hl, $FFA2
	cp   a, [hl]
	ld   [hl], a
	jp   z, L001EB6
	res  6, [hl]
	ld   a, $5A
	ld   bc, $0000
	call L001D35
	inc  hl
	ld   [hl], $03
	inc  hl
	ldh  a, [$FFA2]
	xor  $80
	ld   [hl], a
	jp   L001EB1
L026812:;I
	ld   a, $01
	call L001F34
	ld   bc, $0100
	call L001E8E
	ld   bc, $0100
	call L001E95
	jp   L001EB1
L026826:;I
	call L002150
	call L00220A
	ret  
L02682D:;I
	ldh  a, [$FFA1]
	rst  $00
L026830: db $34
L026831: db $68
L026832: db $3D
L026833: db $68
L026834:;I
	call L001FB9
	call L0020D8
	jp   L001EB1
L02683D:;I
	call L002150
	call L00220A
	ret  
L026844:;I
	ldh  a, [$FFA1]
	rst  $00
L026847: db $4D
L026848: db $68
L026849: db $54
L02684A: db $68
L02684B: db $67
L02684C: db $68
L02684D:;I
	ld   a, $40
	ldh  [$FFAC], a
	jp   L001EB1
L026854:;I
	call L001FB9
	call L002150
	call L00220A
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	jp   L001EB1
L026867:;I
	call L002150
	call L00220A
	ret  
L02686E:;I
	ldh  a, [$FFA1]
	rst  $00
L026871: db $77
L026872: db $68
L026873: db $83
L026874: db $68
L026875: db $8D
L026876: db $68
L026877:;I
	call L001ED7
	ld   bc, $0440
	call L001E95
	jp   L001EB1
L026883:;I
	call L002150
	call L0022C6
	ret  c
	jp   L001EB1
L02688D:;I
	ld   a, $01
	ld   [$CF38], a
	call L002150
	call L0022F7
	ret  
L026899:;I
	ldh  a, [$FFA1]
	rst  $00
L02689C: db $B0
L02689D: db $68
L02689E: db $CE
L02689F: db $68
L0268A0: db $F1
L0268A1: db $68
L0268A2: db $13
L0268A3: db $69
L0268A4: db $3C
L0268A5: db $69
L0268A6: db $6B
L0268A7: db $69
L0268A8: db $7A
L0268A9: db $69
L0268AA: db $90
L0268AB: db $69
L0268AC: db $C9
L0268AD: db $69
L0268AE: db $F9
L0268AF: db $69
L0268B0:;I
	ld   b, $00
	call L001F16
	xor  a
	ld   [$CCFD], a
	ld   a, $98
	ldh  [$FFA7], a
	ld   a, $50
	ld   bc, $0000
	call L001D35
	ld   de, $0007
	add  hl, de
	ld   [hl], $80
	jp   L001EB1
L0268CE:;I
	ld   a, $02
	ld   [$CF38], a
	ld   a, [$CCFD]
	and  a
	ret  z
	xor  a
	ld   [$CCFD], a
	ld   a, [$CCEE]
	ldh  [$FFA7], a
	ld   a, [$CCEF]
	ldh  [$FFA5], a
	ld   b, $03
	call L001F16
	xor  a
	ldh  [$FFAD], a
	jp   L001EB1
L0268F1:;I
	call L0263BA
	ldh  a, [$FFAD]
	cp   $04
	ret  nz
	ld   a, $55
	ld   bc, $0000
	call L001D35
	ld   a, l
	ldh  [$FFAE], a
	add  a, $05
	ld   l, a
	ld   a, h
	ldh  [$FFAF], a
	ld   [hl], $C0
	inc  hl
	inc  hl
	ld   [hl], $80
	jp   L001EB1
L026913:;I
	call L0263BA
	ldh  a, [$FFAD]
	cp   $06
	ret  nz
	ldh  a, [$FFAE]
	ld   l, a
	ldh  a, [$FFAF]
	ld   h, a
	ld   [hl], $00
	ld   a, $98
	ldh  [$FFA7], a
	ld   b, $00
	call L001F16
	ld   a, $02
	ld   [$CF3A], a
	ld   a, $51
	ld   bc, $00E8
	call L001D35
	jp   L001EB1
L02693C:;I
	ld   a, $02
	ld   [$CF38], a
	ld   a, [$CCFD]
	and  a
	ret  z
	xor  a
	ld   [$CCFD], a
	ld   a, [$CCEE]
	ldh  [$FFA7], a
	ld   a, [$CCEF]
	ldh  [$FFA5], a
	ld   b, $03
	call L001F16
	xor  a
	ldh  [$FFAD], a
	ld   bc, $0B80
	ld   hl, $6000
	ld   de, $9000
	call L000646
	jp   L001EB1
L02696B:;I
	call L0263BA
	ldh  a, [$FFAD]
	cp   $04
	ret  nz
	ld   a, $60
	ldh  [$FFAC], a
	jp   L001EB1
L02697A:;I
	ld   c, $01
	call L001F43
	call L002150
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB1
L026990:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $52
	ld   bc, $0000
	call L001D35
	ld   a, l
	add  a, $0D
	ldh  [$FFAE], a
	xor  a
	call L0269FD
	ld   a, $54
	ld   bc, $0000
	call L001D35
	ld   a, $04
	call L0269FD
	ld   a, $54
	ld   bc, $0000
	call L001D35
	ld   a, $06
	call L0269FD
	ld   a, $80
	ldh  [$FFA8], a
	jp   L001EB1
L0269C9:;I
	ldh  a, [$FFA8]
	ld   hl, $FFA4
	add  a, [hl]
	ld   [hl], a
	jr   nc, L0269DD
	call L000DDB
	ldh  a, [$FFAE]
	sub  a, $08
	ld   l, a
	ld   h, $CD
	dec  [hl]
L0269DD:;R
	ldh  a, [$FFAE]
	sub  a, $08
	ld   l, a
	ld   h, $CD
	ld   a, [hl]
	cp   $88
	ret  nz
	ldh  a, [$FFAE]
	sub  a, $0C
	ld   l, a
	ld   h, $CD
	ld   [hl], $01
	ld   a, $02
	ld   [$CF3A], a
	jp   L001EB1
L0269F9:;I
	xor  a
	ldh  [$FFA0], a
	ret  
L0269FD:;C
	ld   de, $0005
	add  hl, de
	ld   [hl], $C8
	inc  hl
	inc  hl
	ld   [hl], $80
	ld   de, $0006
	add  hl, de
	ldi  [hl], a
	ldh  a, [$FFAE]
	ld   [hl], a
	ret  
L026A10:;I
	ldh  a, [$FFA1]
	rst  $00
L026A13: db $D0
L026A14: db $6C
L026A15: db $17
L026A16: db $6A
L026A17:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	cp   $3C
	jr   nc, L026A35
	push af
	sla  a
	and  a, $08
	ld   [$CF38], a
	pop  af
	or   a
	jr   nz, L026A35
	ld   a, $06
	ld   [$CFF1], a
	jp   L001EB6
L026A35:;R
	ld   a, [$CF6A]
	ld   b, a
	ld   a, [$CF2F]
	cp   a, b
	ret  nz
	ldh  a, [$FFA2]
	bit  3, a
	ret  nz
	or   a, $08
	ldh  [$FFA2], a
	ld   a, $02
	ld   [$CF1D], a
	ld   a, $04
	ld   [$CF1A], a
	ld   a, $80
	ld   [$CF1B], a
	jp   L003A0B
L026A59:;I
	ldh  a, [$FFA1]
	rst  $00
L026A5C: db $D0
L026A5D: db $6C
L026A5E: db $64
L026A5F: db $6A
L026A60: db $9B
L026A61: db $6A
L026A62: db $E3
L026A63: db $6A
L026A64:;I
	ld   a, [$CF6F]
	or   a
	jr   z, L026A93
	ldh  a, [$FFA5]
	ld   [$CF0D], a
	ldh  a, [$FFA7]
	ld   [$CF0E], a
	call L00332F
	cp   $10
	jr   z, L026A7F
	cp   $18
	jr   nz, L026A93
L026A7F:;R
	ldh  a, [$FFA7]
	sub  a, $0F
	ld   [$CF0E], a
	call L00332F
	cp   $10
	jp   z, L001EB1
L026A8E: db $FE;X
L026A8F: db $18;X
L026A90: db $CA;X
L026A91: db $B1;X
L026A92: db $1E;X
L026A93:;R
	ld   a, $06
	ld   [$CFF1], a
	jp   L001EB6
L026A9B:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	cp   $3C
	jr   nc, L026ABB
	push af
	sla  a
	and  a, $08
	ld   [$CF38], a
	pop  af
	or   a
	jr   nz, L026ABB
	ld   a, $06
	ld   [$CFF1], a
	ld   a, $00
	ldh  [$FFA1], a
	ret  
L026ABB:;R
	ld   a, [$CF6A]
	ld   b, a
	ld   a, [$CF2F]
	cp   a, b
	ret  nz
	xor  a
	ld   [$CF75], a
	ld   [$CF76], a
	ld   [$CF77], a
	ld   [$CF78], a
	ld   a, [$CF15]
	ldh  [$FFA5], a
	ldh  a, [$FFA7]
	ld   [$CF16], a
	ld   a, $11
	ld   [$CF1D], a
	jp   L001EB1
L026AE3:;I
	ld   c, $01
	call L001F43
	ld   a, [$CF42]
	or   a
	jr   z, L026AF6
	ldh  a, [$FF8F]
	and  a, $02
	add  a, $0A
	jr   L026B06
L026AF6:;R
	ld   a, [$CF43]
	or   a
	jr   z, L026B04
	ldh  a, [$FF8F]
	and  a, $02
	add  a, $08
	jr   L026B06
L026B04:;R
	ld   a, $0A
L026B06:;R
	ld   [$CF38], a
	ld   a, [$CF15]
	ldh  [$FFA5], a
	ld   a, [$CF16]
	ldh  [$FFA7], a
	ld   a, [$CF12]
	rrca 
	and  a, $80
	ld   b, a
	ldh  a, [$FFA2]
	and  a, $7F
	or   a, b
	ldh  [$FFA2], a
	ld   a, [$CF5E]
	sub  a, $10
	ld   [$CF5E], a
	call c, L003A0B
	ld   a, [$CFE0]
	or   a
	ret  nz
	xor  a
	ld   [$CF1D], a
	ld   a, $06
	ld   [$CFF1], a
	ld   a, $00
	ldh  [$FFA1], a
	ret  
L026B3F:;I
	ldh  a, [$FFA1]
	rst  $00
L026B42: db $D0
L026B43: db $6C
L026B44: db $4A
L026B45: db $6B
L026B46: db $70
L026B47: db $6B
L026B48: db $A8
L026B49: db $6B
L026B4A:;I
	ld   a, [$CF6F]
	or   a
	jr   z, L026B65
	ldh  a, [$FFA5]
	ld   [$CF0D], a
	ldh  a, [$FFA7]
	ld   [$CF0E], a
	call L00332F
	cp   $10
	jr   z, L026B68
	cp   $18
	jr   z, L026B68
L026B65:;R
	jp   L001EB1
L026B68:;R
	ld   a, $06
	ld   [$CFF1], a
	jp   L001EB6
L026B70:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	cp   $3C
	jr   nc, L026B90
L026B7A: db $F5;X
L026B7B: db $CB;X
L026B7C: db $27;X
L026B7D: db $E6;X
L026B7E: db $08;X
L026B7F: db $EA;X
L026B80: db $38;X
L026B81: db $CF;X
L026B82: db $F1;X
L026B83: db $B7;X
L026B84: db $20;X
L026B85: db $0A;X
L026B86: db $3E;X
L026B87: db $06;X
L026B88: db $EA;X
L026B89: db $F1;X
L026B8A: db $CF;X
L026B8B: db $3E;X
L026B8C: db $00;X
L026B8D: db $E0;X
L026B8E: db $A1;X
L026B8F: db $C9;X
L026B90:;R
	ld   a, [$CF2F]
	ld   b, a
	ld   a, [$CF6A]
	cp   a, b
	ret  nz
	ld   bc, $0100
	call L001E8E
	ld   bc, $0100
	call L001E95
	jp   L001EB1
L026BA8:;I
	call L001EBB
	or   a
	jr   z, L026BB4
	call L001ED7
	call L002180
L026BB4:;R
	ld   a, [$CF2F]
	ld   b, a
	ld   a, [$CF4A]
	cp   a, b
	ret  nz
	ldh  a, [$FF8A]
	rla  
	jr   nc, L026BEF
	ldh  a, [$FFA7]
	cp   $90
	jr   nc, L026C31
	ld   a, [$CF6F]
	or   a
	jr   z, L026BE4
	ldh  a, [$FFA5]
	ld   [$CF0D], a
	ldh  a, [$FFA7]
	inc  a
	ld   [$CF0E], a
	call L00332F
	cp   $10
	jr   z, L026C21
	cp   $18
	jr   z, L026C21
L026BE4:;R
	ldh  a, [$FFA2]
	or   a, $40
	ldh  [$FFA2], a
	call L00223A
	jr   L026C21
L026BEF:;R
	rla  
	jr   nc, L026C21
	ld   a, [$CF16]
	cp   $18
	jr   c, L026C21
	sub  a, $18
	ld   [$CF0E], a
	ld   a, [$CF15]
	sub  a, $06
	ld   [$CF0D], a
	call L00332F
	jr   nc, L026C21
	ld   a, [$CF15]
	add  a, $06
	ld   [$CF0D], a
	call L00332F
	jr   nc, L026C21
	ldh  a, [$FFA2]
	and  a, $BF
	ldh  [$FFA2], a
	call L00220A
L026C21:;R
	ld   a, [$CF5E]
	sub  a, $20
	ld   [$CF5E], a
	call c, L003A0B
	ld   a, [$CFE0]
	or   a
	ret  nz
L026C31:;R
	ld   a, $06
	ld   [$CFF1], a
	ld   a, $00
	ldh  [$FFA1], a
	ret  
L026C3B:;I
	ldh  a, [$FFA1]
	rst  $00
L026C3E: db $D0
L026C3F: db $6C
L026C40: db $46
L026C41: db $6C
L026C42: db $85
L026C43: db $6C
L026C44: db $A1
L026C45: db $6C
L026C46:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	cp   $3C
	jr   nc, L026C64
	push af
	sla  a
	and  a, $08
	ld   [$CF38], a
	pop  af
	or   a
	jr   nz, L026C64
	ld   a, $06
	ld   [$CFF1], a
	jp   L001EB6
L026C64:;R
	ld   a, [$CF6A]
	ld   b, a
	ld   a, [$CF2F]
	cp   a, b
	ret  nz
	ld   a, $01
	call L001F34
	ld   hl, $4C00
	ld   de, $8500
	ld   bc, $0B10
	call L000646
	ld   a, $04
	ldh  [$FFAC], a
	jp   L001EB1
L026C85:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, [$CF15]
	ldh  [$FFA5], a
	ldh  a, [$FFA7]
	ld   [$CF16], a
	xor  a
	ld   [$CF1D], a
	inc  a
	ld   [$CF6C], a
	jp   L001EB1
L026CA1:;I
	ld   a, [$CF15]
	ldh  [$FFA5], a
	ld   a, [$CF16]
	ldh  [$FFA7], a
	cp   $90
	jr   nc, L026CBF
	ld   a, [$CF5E]
	sub  a, $40
	ld   [$CF5E], a
	call c, L003A0B
	ld   a, [$CFE0]
	or   a
	ret  nz
L026CBF:;R
	xor  a
	ld   [$CF1D], a
	ld   [$CF6C], a
	ld   a, $06
	ld   [$CFF1], a
	ld   a, $00
	ldh  [$FFA1], a
	ret  
L026CD0:;I
	ld   a, [$CFF1]
	dec  a
	rst  $00
L026CD5: db $E5
L026CD6: db $6C
L026CD7: db $05
L026CD8: db $6D
L026CD9: db $17
L026CDA: db $6D
L026CDB: db $78
L026CDC: db $6D
L026CDD: db $8B
L026CDE: db $6D
L026CDF: db $CF
L026CE0: db $6D
L026CE1: db $E2
L026CE2: db $6D
L026CE3: db $09
L026CE4: db $6E
L026CE5:;I
	ld   a, $02
	call L001F34
	xor  a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	ld   hl, $CFF1
	inc  [hl]
	ld   a, [$CFDF]
	cp   $0C
	ret  nz
	ld   hl, $4D00
	ld   de, $8500
	ld   bc, $0B08
	jp   L000646
L026D05:;I
	call L0022F7
	ldh  a, [$FFA7]
	ld   b, a
	ld   a, [$CF16]
	sub  a, $18
	cp   a, b
	ret  nc
	ld   hl, $CFF1
	inc  [hl]
	ret  
L026D17:;I
	ldh  a, [$FFA7]
	cp   $90
	jr   c, L026D23
	ld   a, $06
	ld   [$CFF1], a
	ret  
L026D23:;R
	ld   a, [$CFDF]
	cp   $01
	jr   nz, L026D37
	call L0023A8
	ret  c
	ld   a, $00
	ldh  [$FFAC], a
	ld   hl, $CFF1
	inc  [hl]
	ret  
L026D37:;R
	cp   $02
	jr   nz, L026D51
	call L0022F7
	ldh  a, [$FFA7]
	ld   b, a
	ld   a, [$CF16]
	cp   a, b
	ret  nc
	ldh  [$FFA7], a
	ld   a, $00
	ldh  [$FFAC], a
	ld   hl, $CFF1
	inc  [hl]
	ret  
L026D51:;R
	cp   $03
	jr   nz, L026D6B
	call L0022F7
	ldh  a, [$FFA7]
	ld   b, a
	ld   a, [$CF16]
	cp   a, b
	ret  nc
	ldh  [$FFA7], a
	ld   a, $00
	ldh  [$FFAC], a
	ld   hl, $CFF1
	inc  [hl]
	ret  
L026D6B:;R
	call L0023A8
	ret  c
	ld   a, $00
	ldh  [$FFAC], a
	ld   hl, $CFF1
	inc  [hl]
	ret  
L026D78:;I
	ldh  a, [$FFAC]
	add  a, $01
	ldh  [$FFAC], a
	srl  a
	ld   [$CF38], a
	cp   $05
	ret  nz
	ld   hl, $CFF1
	inc  [hl]
	ret  
L026D8B:;I
	ld   a, $05
	ld   [$CF38], a
	ldh  a, [$FFA7]
	sub  a, $04
	ld   [$CF0E], a
	ldh  a, [$FFA5]
	sub  a, $08
	ld   [$CF0D], a
	call L00332F
	jr   nc, L026DCA
	ldh  a, [$FFA5]
	add  a, $08
	ld   [$CF0D], a
	call L00332F
	jr   nc, L026DCA
	ld   a, $00
	call L001F34
	call L001ED7
	call L001E9C
	ld   a, $FF
	ld   [$CFF1], a
	ld   a, $0C
	ldh  [$FF99], a
	ld   a, $B4
	ldh  [$FFAC], a
	jp   L001EB1
L026DCA:;R
	ld   hl, $CFF1
	inc  [hl]
	ret  
L026DCF:;I
	ld   a, $02
	call L001F34
	ld   a, $0A
	ldh  [$FFAC], a
	ld   a, $05
	ld   [$CF38], a
	ld   hl, $CFF1
	inc  [hl]
	ret  
L026DE2:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	srl  a
	ld   [$CF38], a
	or   a
	ret  nz
	ld   a, $02
	call L001F34
	ldh  a, [$FFA2]
	and  a, $BF
	ldh  [$FFA2], a
	ld   bc, $0400
	call L001E95
	ld   a, $0D
	ldh  [$FF99], a
	ld   hl, $CFF1
	inc  [hl]
	ret  
L026E09:;I
	call L00220A
	ldh  a, [$FFA7]
	cp   $10
	ret  nc
	xor  a
	ldh  [$FFA0], a
	ld   [$CFF1], a
	ret  
L026E18:;I
	ldh  a, [$FFA1]
	rst  $00
L026E1B: db $21
L026E1C: db $6E
L026E1D: db $39
L026E1E: db $6E
L026E1F: db $6D
L026E20: db $6E
L026E21:;I
	ld   bc, $0080
	call L001E8E
	ld   bc, $0080
	call L001E95
	call L000755
	and  a, $F7
	add  a, $0F
	ldh  [$FFAC], a
	jp   L001EB1
L026E39:;I
	ldh  a, [$FFAC]
	add  a, $01
	ldh  [$FFAC], a
	and  a, $1F
	call z, L001E9C
	call L002180
	call nc, L001E9C
	call L00220A
	ldh  a, [$FFA5]
	ld   [$CF0D], a
	ldh  a, [$FFA7]
	ld   [$CF0E], a
	call L00332F
	ret  nc
	cp   $10
	ret  z
	cp   $18
	ret  z
	ld   a, $01
	call L001F34
	ld   a, $08
	ldh  [$FFAC], a
	jp   L001EB1
L026E6D:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	xor  a
	ldh  [$FFA0], a
	ret  
L026E78:;I
	ret  
L026E79:;I
	ldh  a, [$FFA1]
	rst  $00
L026E7C: db $80
L026E7D: db $6E
L026E7E: db $AB
L026E7F: db $6E
L026E80:;I
	ld   b, $00
	ld   a, [$CFDE]
	and  a, $40
	call z, L026F16
	ld   b, $01
	ld   a, [$CFDE]
	and  a, $01
	call z, L026F16
	ld   b, $02
	ld   a, [$CFDE]
	and  a, $80
	call z, L026F16
	ld   b, $03
	ld   a, [$CFDE]
	and  a, $20
	call z, L026F16
	jp   L001EB1
L026EAB:;I
	ld   a, [$CF7A]
	or   a
	ret  nz
	ld   a, [$CF15]
	ld   b, a
	ld   a, [$CF16]
	ld   c, a
	cp   $3F
	jr   nz, L026EE7
	ld   a, b
	cp   $20
	jr   nc, L026ED2
	ld   a, [$CFDE]
	and  a, $40
	ret  nz
	ld   a, $10
	ld   [$CF7A], a
	ld   a, $19
	ld   [$CF1D], a
	ret  
L026ED2:;R
	ld   a, b
	cp   $90
	ret  c
	ld   a, [$CFDE]
	and  a, $01
	ret  nz
	ld   a, $20
	ld   [$CF7A], a
	ld   a, $19
	ld   [$CF1D], a
	ret  
L026EE7:;R
	ld   a, c
	cp   $7F
	ret  nz
	ld   a, b
	cp   $20
	jr   nc, L026F01
	ld   a, [$CFDE]
	and  a, $80
	ret  nz
	ld   a, $30
	ld   [$CF7A], a
	ld   a, $19
	ld   [$CF1D], a
	ret  
L026F01:;R
	ld   a, b
	cp   $90
	ret  c
	ld   a, [$CFDE]
	and  a, $20
	ret  nz
	ld   a, $40
	ld   [$CF7A], a
	ld   a, $19
	ld   [$CF1D], a
	ret  
L026F16:;C
	ld   a, b
	add  a
	ld   hl, $6F33
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldi  a, [hl]
	ld   [$CF2B], a
	ld   a, [hl]
	ld   [$CF2C], a
	xor  a
	ld   [$CF2E], a
	ld   a, $67
	ld   [$CF2D], a
	jp   L001D48
L026F33: db $1C
L026F34: db $18
L026F35: db $8C
L026F36: db $18
L026F37: db $1C
L026F38: db $58
L026F39: db $8C
L026F3A: db $58
L026F3B:;I
	ld   c, $01
	call L001F43
	ret  
L026F41:;I
	ldh  a, [$FFA1]
	rst  $00
L026F44: db $84
L026F45: db $7D
L026F46: db $64
L026F47: db $6F
L026F48: db $76
L026F49: db $6F
L026F4A: db $81
L026F4B: db $6F
L026F4C: db $81
L026F4D: db $6F
L026F4E: db $D0
L026F4F: db $6F
L026F50: db $FA
L026F51: db $6F
L026F52: db $18
L026F53: db $70
L026F54: db $46
L026F55: db $70
L026F56: db $51
L026F57: db $70
L026F58: db $58
L026F59: db $70
L026F5A: db $73
L026F5B: db $70
L026F5C: db $8A
L026F5D: db $70
L026F5E: db $98
L026F5F: db $70
L026F60: db $A4
L026F61: db $70
L026F62: db $B8
L026F63: db $70
L026F64:;I
	ld   a, $00
	ldh  [$FFAC], a
	call L001ED7
	ld   de, $0003
	ld   c, $0C
	call L001F7D
	jp   L001EB1
L026F76:;I
	call L001F8B
	ret  z
	ld   a, $00
	ldh  [$FFAC], a
	jp   L001EB1
L026F81:;I
	call L001ED7
	ldh  a, [$FFAC]
	add  a, $01
	ldh  [$FFAC], a
	cp   $0C
	jr   nc, L026F94
	ld   a, $03
	ld   [$CF38], a
	ret  
L026F94:;R
	cp   $18
	jr   nz, L026FA6
	ld   a, $03
	ld   [$CF38], a
	ld   a, $70
	ld   bc, $00F7
	call L001D35
	ret  
L026FA6:;R
	cp   $18
	jr   nc, L026FB0
	ld   a, $03
	ld   [$CF38], a
	ret  
L026FB0:;R
	cp   $24
	jr   nc, L026FBA
	ld   a, $05
	ld   [$CF38], a
	ret  
L026FBA:;R
	cp   $30
	jr   nc, L026FC4
	ld   a, $04
	ld   [$CF38], a
	ret  
L026FC4:;R
	ld   a, $04
	ld   [$CF38], a
	ld   a, $00
	ldh  [$FFAC], a
	jp   L001EB1
L026FD0:;I
	ldh  a, [$FFAC]
	add  a, $01
	ldh  [$FFAC], a
	cp   $1E
	ret  nz
	call L001ED7
	call L001EBB
	swap a
	and  a, $0F
	add  a
	ld   hl, $70D7
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   c, [hl]
	inc  hl
	ld   b, [hl]
	call L001E8E
	ld   bc, $0440
	call L001E95
	jp   L001EB1
L026FFA:;I
	ld   a, $06
	ld   [$CF38], a
	call L001EBB
	cp   $04
	jr   nc, L02700B
	ld   a, $08
	ldh  [$FFA1], a
	ret  
L02700B:;R
	call L002180
	call nc, L001E9C
	call L002328
	ret  c
	jp   L001EB1
L027018:;I
	ld   a, $06
	ld   [$CF38], a
	call L001EBB
	cp   $04
	jr   nc, L027029
	ld   a, $08
	ldh  [$FFA1], a
	ret  
L027029:;R
	call L002180
	call nc, L001E9C
	call L0023A8
	ret  c
	ld   a, $3C
	ldh  [$FFAC], a
	ld   a, $0F
	ld   [$CF1D], a
	ldh  a, [$FF90]
	ld   [$CF46], a
	ld   a, $0B
	ldh  [$FFA1], a
	ret  
L027046:;I
	ld   de, $0709
	ld   c, $0C
	call L001F7D
	jp   L001EB1
L027051:;I
	call L001F8B
	ret  z
	jp   L001EB1
L027058:;I
	ld   a, $09
	ld   [$CF38], a
	call L0023A8
	ret  c
	ld   a, $3C
	ldh  [$FFAC], a
	ld   a, $0F
	ld   [$CF1D], a
	ldh  a, [$FF90]
	ld   [$CF46], a
	ld   a, $0B
	ldh  [$FFA1], a
L027073:;I
	ld   a, $0A
	ld   [$CF38], a
	call L0270C9
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, [$CF46]
	ldh  [$FF90], a
	jp   L001EB1
L02708A:;I
	ld   a, $09
	ld   [$CF38], a
	ld   bc, $0200
	call L001E95
	jp   L001EB1
L027098:;I
	ld   a, $09
	ld   [$CF38], a
	call L002328
	ret  c
	jp   L001EB1
L0270A4:;I
	ld   a, $08
	ld   [$CF38], a
	call L0023A8
	ret  c
	xor  a
	ld   [$CF1D], a
	ld   a, $06
	ldh  [$FFAC], a
	jp   L001EB1
L0270B8:;I
	ld   a, $07
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $00
	ldh  [$FFA1], a
	ret  
L0270C9:;C
	ldh  a, [$FF8F]
	and  a, $03
	add  a, $FF
	ld   b, a
	ld   a, [$CF46]
	add  a, b
	ldh  [$FF90], a
	ret  
L0270D7: db $40;X
L0270D8: db $00;X
L0270D9: db $40
L0270DA: db $00
L0270DB: db $80
L0270DC: db $00
L0270DD: db $C0
L0270DE: db $00
L0270DF: db $00;X
L0270E0: db $01;X
L0270E1: db $40
L0270E2: db $01
L0270E3: db $80;X
L0270E4: db $01;X
L0270E5: db $C0;X
L0270E6: db $01;X
L0270E7: db $00;X
L0270E8: db $02;X
L0270E9: db $40;X
L0270EA: db $02;X
L0270EB: db $80;X
L0270EC: db $02;X
L0270ED: db $C0;X
L0270EE: db $02;X
L0270EF: db $00;X
L0270F0: db $03;X
L0270F1: db $40;X
L0270F2: db $03;X
L0270F3: db $80;X
L0270F4: db $03;X
L0270F5: db $C0;X
L0270F6: db $03;X
L0270F7:;I
	ldh  a, [$FFA1]
	rst  $00
L0270FA: db $84
L0270FB: db $7D
L0270FC: db $0C
L0270FD: db $71
L0270FE: db $18
L0270FF: db $71
L027100: db $2B
L027101: db $71
L027102: db $3E
L027103: db $71
L027104: db $2B
L027105: db $71
L027106: db $54
L027107: db $71
L027108: db $67
L027109: db $71
L02710A: db $81
L02710B: db $71
L02710C:;I
	ld   a, $1E
	ldh  [$FFAC], a
	ld   a, $00
	call L001F34
	jp   L001EB1
L027118:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $1E
	ldh  [$FFAC], a
	ld   a, $02
	call L001F34
	jp   L001EB1
L02712B:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $0F
	ldh  [$FFAC], a
	ld   a, $01
	call L001F34
	jp   L001EB1
L02713E:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $78
	ldh  [$FFAC], a
	ld   a, $00
	call L001F34
	call L027D3C
	jp   L001EB1
L027154:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $78
	ldh  [$FFAC], a
	ld   b, $03
	call L001F16
	jp   L001EB1
L027167:;I
	ld   a, $03
	ld   [$CF38], a
	ld   c, $02
	call L001F51
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   bc, $0200
	call L001E8E
	jp   L001EB1
L027181:;I
	ld   a, $03
	ld   [$CF38], a
	ld   c, $02
	call L001F51
	call L002150
	ldh  a, [$FFA2]
	bit  7, a
	jr   nz, L02719B
	ldh  a, [$FFA5]
	cp   $28
	jr   c, L0271A0
	ret  
L02719B:;R
	ldh  a, [$FFA5]
	cp   $88
	ret  c
L0271A0:;R
	ld   b, $02
	call L001F16
	call L001E9C
	ld   a, $00
	ldh  [$FFA1], a
	ret  
L0271AD:;I
	ldh  a, [$FFA1]
	rst  $00
L0271B0: db $84
L0271B1: db $7D
L0271B2: db $D6
L0271B3: db $71
L0271B4: db $F2
L0271B5: db $71
L0271B6: db $FC
L0271B7: db $71
L0271B8: db $0F
L0271B9: db $72
L0271BA: db $F2
L0271BB: db $71
L0271BC: db $FC
L0271BD: db $71
L0271BE: db $24
L0271BF: db $72
L0271C0: db $F2
L0271C1: db $71
L0271C2: db $5C
L0271C3: db $72
L0271C4: db $63
L0271C5: db $72
L0271C6: db $5C
L0271C7: db $72
L0271C8: db $63
L0271C9: db $72
L0271CA: db $5C
L0271CB: db $72
L0271CC: db $63
L0271CD: db $72
L0271CE: db $FC
L0271CF: db $71
L0271D0: db $94
L0271D1: db $72
L0271D2: db $A0
L0271D3: db $72
L0271D4: db $AC
L0271D5: db $72
L0271D6:;I
	ld   bc, $0160
	call L001E8E
	ldh  a, [$FFA5]
	and  a, $80
	xor  $80
	ldh  [$FFA2], a
	ld   bc, $0200
	call L001E95
	ld   a, $05
	call L001F34
	jp   L001EB1
L0271F2:;I
	call L002180
	call L002328
	ret  c
	jp   L001EB1
L0271FC:;I
	call L002180
	call L0023A8
	ret  c
	ld   a, $06
	ldh  [$FFAC], a
	ld   a, $00
	call L001F34
	jp   L001EB1
L02720F:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   bc, $0300
	call L001E95
	ld   a, $05
	call L001F34
	jp   L001EB1
L027224:;I
	call L001ED7
	call L001EBB
	cp   $30
	jr   nc, L027242
L02722E:;R
	ld   bc, $0000
	call L001E8E
	ld   bc, $0440
	call L001E95
	ld   a, $05
	call L001F34
	jp   L001EB1
L027242:;R
	call L000755
	bit  7, a
	jr   nz, L02722E
	ld   b, $03
	call L001F16
	ld   a, $03
	call L001F34
	ld   a, $B4
	ldh  [$FFAC], a
	ld   a, $12
	ldh  [$FFA1], a
	ret  
L02725C:;I
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L027263:;I
	call L001ED7
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	push af
	ld   b, a
	srl  a
	srl  a
	srl  a
	and  a, $01
	ld   [$CF38], a
	ld   a, b
	cp   $08
	jr   nz, L02728F
	ld   a, $72
	ld   bc, $00F0
	call L001D35
	ldh  a, [$FFA2]
	and  a, $80
	or   a, $40
	inc  l
	inc  l
	ld   [hl], a
L02728F:;R
	pop  af
	ret  nz
	jp   L001EB1
L027294:;I
	ld   a, $06
	ldh  [$FFAC], a
	ld   a, $00
	call L001F34
	jp   L001EB1
L0272A0:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L0272AC:;I
	call L001ED7
	ldh  a, [$FFA2]
	and  a, $80
	xor  $80
	ld   bc, $0080
	call L0018B9
	ld   a, [$CF42]
	or   a
	jr   nz, L0272D3
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	push af
	srl  a
	srl  a
	and  a, $01
	ld   [$CF38], a
	pop  af
	ret  nz
L0272D3:;X
	ld   b, $02
	call L001F16
	ld   a, $10
	ldh  [$FFA1], a
	ret  
L0272DD:;I
	ldh  a, [$FFA1]
	rst  $00
L0272E0: db $84
L0272E1: db $7D
L0272E2: db $FE
L0272E3: db $72
L0272E4: db $0A
L0272E5: db $73
L0272E6: db $38
L0272E7: db $73
L0272E8: db $46
L0272E9: db $73
L0272EA: db $64
L0272EB: db $73
L0272EC: db $82
L0272ED: db $73
L0272EE: db $93
L0272EF: db $73
L0272F0: db $A2
L0272F1: db $73
L0272F2: db $B1
L0272F3: db $73
L0272F4: db $C2
L0272F5: db $73
L0272F6: db $CB
L0272F7: db $73
L0272F8: db $DB
L0272F9: db $73
L0272FA: db $FF
L0272FB: db $73
L0272FC: db $0E
L0272FD: db $74
L0272FE:;I
	ld   a, $00
	call L001F34
	ld   a, $06
	ldh  [$FFAC], a
	jp   L001EB1
L02730A:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	call L000755
	swap a
	and  a, $03
	jr   nz, L02731F
	ld   a, $06
	ldh  [$FFA1], a
	ret  
L02731F:;R
	dec  a
	jr   nz, L027327
	ld   a, $07
	ldh  [$FFA1], a
	ret  
L027327:;R
	call L001EBB
	cp   $40
	jr   nc, L027333
	ld   a, $03
	ldh  [$FFA1], a
	ret  
L027333:;R
	ld   a, $0A
	ldh  [$FFA1], a
	ret  
L027338:;I
	call L001ED7
	ld   de, $0205
	ld   c, $04
	call L001F7D
	jp   L001EB1
L027346:;I
	ldh  a, [$FFAD]
	ld   hl, $741A
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   b, [hl]
	ld   c, $0B
	call L001F0C
	call L001F8B
	ret  z
	ld   de, $0508
	ld   c, $04
	call L001F7D
	jp   L001EB1
L027364:;I
	ldh  a, [$FFAD]
	ld   hl, $741A
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   b, [hl]
	ld   c, $0B
	call L001F0C
	call L001F8B
	ret  z
	ld   bc, $0B0B
	call L001F0C
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L027382:;I
	ld   bc, $0000
	call L001E8E
	ld   bc, $0380
	call L001E95
	ld   a, $08
	ldh  [$FFA1], a
	ret  
L027393:;I
	ld   bc, $0100
	call L001E8E
	ld   bc, $0380
	call L001E95
	jp   L001EB1
L0273A2:;I
	ld   a, $09
	ld   [$CF38], a
	call L002180
	call L002328
	ret  c
	jp   L001EB1
L0273B1:;I
	ld   a, $09
	ld   [$CF38], a
	call L002180
	call L0023A8
	ret  c
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L0273C2:;I
	ld   bc, $0440
	call L001E95
	jp   L001EB1
L0273CB:;I
	ld   a, $09
	ld   [$CF38], a
	call L002328
	ret  c
	xor  a
	ld   [$CF5C], a
	jp   L001EB1
L0273DB:;I
	ld   a, $09
	ld   [$CF38], a
	call L001ED7
	ld   a, [$CF5C]
	cp   $20
	jr   nc, L0273F6
	inc  a
	ld   [$CF5C], a
	dec  a
	and  a, $07
	jr   nz, L0273F6
	jp   L001EB1
L0273F6:;R
	call L0023A8
	ret  c
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L0273FF:;I
	ld   a, $73
	ld   bc, $00F0
	call L001D35
	ld   a, $06
	ldh  [$FFAC], a
	jp   L001EB1
L02740E:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $0C
	ldh  [$FFA1], a
	ret  
L02741A: db $0B;X
L02741B: db $0B;X
L02741C: db $0B
L02741D: db $13;X
L02741E: db $1B;X
L02741F: db $23
L027420: db $1B;X
L027421: db $13;X
L027422: db $0B;X
L027423: db $0B;X
L027424:;I
	ldh  a, [$FFA1]
	rst  $00
L027427: db $84
L027428: db $7D
L027429: db $37
L02742A: db $74
L02742B: db $47
L02742C: db $74
L02742D: db $72
L02742E: db $74
L02742F: db $8C
L027430: db $74
L027431: db $9F
L027432: db $74
L027433: db $C9
L027434: db $74
L027435: db $E2
L027436: db $74
L027437:;I
	xor  a
	ldh  [$FFAD], a
	ld   bc, $00E0
	call L001E8E
	ld   a, $80
	ldh  [$FFAC], a
	jp   L001EB1
L027447:;I
	ld   hl, $FFAD
	ld   a, [hl]
	inc  [hl]
	rrca 
	rrca 
	rrca 
	and  a, $03
	add  a, $03
	ld   [$CF38], a
	ld   a, [$CC60]
	add  a
	jp   c, L001EB1
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	jp   z, L001EB1
	call L002180
	ret  c
	ld   hl, $FFA2
	ld   a, $80
	xor  a, [hl]
	ld   [hl], a
	ret  
L027472:;I
	call L001ED7
	call L001EBB
	ld   l, a
	ld   h, $00
	add  hl, hl
	add  hl, hl
	ld   a, l
	ldh  [$FFA8], a
	ld   a, h
	ldh  [$FFA9], a
	ld   bc, $0400
	call L001E95
	jp   L001EB1
L02748C:;I
	ld   a, $07
	ld   [$CF38], a
	call L002180
	call L002328
	ret  c
	ld   a, $08
	ldh  [$FFAC], a
	jp   L001EB1
L02749F:;I
	ld   a, $08
	ld   [$CF38], a
	call L002180
	call L0023A8
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $7A
	call L001E63
	ld   a, b
	and  a
	jr   nz, L0274C2
	ld   a, $74
	ld   bc, $0000
	call L001D35
L0274C2:;R
	ld   a, $08
	ldh  [$FFAC], a
	jp   L001EB1
L0274C9:;I
	ld   a, $09
	ld   [$CF38], a
	call L002180
	call L0023A8
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $08
	ldh  [$FFAC], a
	jp   L001EB1
L0274E2:;I
	ld   a, $07
	ld   [$CF38], a
	call L002180
	call L0023A8
	ret  c
	ld   a, $00
	ldh  [$FFA1], a
	ret  
L0274F3:;I
	ldh  a, [$FFA1]
	rst  $00
L0274F6: db $84
L0274F7: db $7D
L0274F8: db $0E
L0274F9: db $75
L0274FA: db $18
L0274FB: db $75
L0274FC: db $3D
L0274FD: db $75
L0274FE: db $4D
L0274FF: db $75
L027500: db $6E
L027501: db $75
L027502: db $89;X
L027503: db $75;X
L027504: db $9A;X
L027505: db $75;X
L027506: db $AA;X
L027507: db $75;X
L027508: db $AB
L027509: db $75
L02750A: db $BD
L02750B: db $75
L02750C: db $CC
L02750D: db $75
L02750E:;I
	xor  a
	ldh  [$FFAD], a
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L027518:;I
	ld   hl, $FFAD
	ld   a, [hl]
	inc  [hl]
	rrca 
	rrca 
	rrca 
	and  a, $03
	add  a, $03
	ld   [$CF38], a
	call L001EBB
	cp   $20
	jp   c, L0275E5
	ld   a, [$CC60]
	add  a
	ret  nc
	ld   bc, $0400
	call L001E95
	jp   L001EB1
L02753D:;I
	ld   a, $07
	ld   [$CF38], a
	call L002328
	ret  c
	ld   a, $04
	ldh  [$FFAC], a
	jp   L001EB1
L02754D:;I
	ld   a, $08
	ld   [$CF38], a
	call L0023A8
	jp   nc, L0275E0
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $75
	ld   bc, $0000
	call L001D35
	ld   a, $08
	ldh  [$FFAC], a
	jp   L001EB1
L02756E:;I
	ld   a, $09
	ld   [$CF38], a
	call L0023A8
	jp   nc, L0275E0
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $10
	ldh  [$FFAC], a
	ld   a, $04
	ldh  [$FFA1], a
	ret  
L027589: db $C9;X
L02758A: db $CD;X
L02758B: db $A8;X
L02758C: db $23;X
L02758D: db $D8;X
L02758E: db $3E;X
L02758F: db $02;X
L027590: db $E0;X
L027591: db $A1;X
L027592: db $C9;X
L027593: db $3E;X
L027594: db $10;X
L027595: db $E0;X
L027596: db $AC;X
L027597: db $C3;X
L027598: db $B1;X
L027599: db $1E;X
L02759A: db $C9;X
L02759B: db $3E;X
L02759C: db $07;X
L02759D: db $EA;X
L02759E: db $38;X
L02759F: db $CF;X
L0275A0: db $F0;X
L0275A1: db $AC;X
L0275A2: db $D6;X
L0275A3: db $01;X
L0275A4: db $E0;X
L0275A5: db $AC;X
L0275A6: db $C0;X
L0275A7: db $C3;X
L0275A8: db $B1;X
L0275A9: db $1E;X
L0275AA: db $C9;X
L0275AB:;I
	call L001ED7
	ld   bc, $0180
	call L001E8E
	ld   bc, $0380
	call L001E95
	jp   L001EB1
L0275BD:;I
	ld   a, $07
	ld   [$CF38], a
	call L002150
	call L002328
	ret  c
	jp   L001EB1
L0275CC:;I
	ld   a, $07
	ld   [$CF38], a
	call L002150
	call L0023A8
	ret  c
	call L001ED7
	ld   a, $02
	ldh  [$FFA1], a
	ret  
L0275E0:;J
	ld   a, $02
	ldh  [$FFA1], a
	ret  
L0275E5:;J
	ld   a, $09
	ldh  [$FFA1], a
	ret  
L0275EA:;I
	ldh  a, [$FFA1]
	rst  $00
L0275ED: db $84
L0275EE: db $7D
L0275EF: db $03
L0275F0: db $76
L0275F1: db $52
L0275F2: db $76
L0275F3: db $67
L0275F4: db $76
L0275F5: db $85
L0275F6: db $76
L0275F7: db $A6
L0275F8: db $76
L0275F9: db $EB
L0275FA: db $76
L0275FB: db $FA
L0275FC: db $76
L0275FD: db $09
L0275FE: db $77
L0275FF: db $14
L027600: db $77
L027601: db $21;X
L027602: db $77;X
L027603:;I
	xor  a
	ld   [$CCE0], a
	ld   a, $10
	ldh  [$FFAC], a
	ld   a, $77
	ld   bc, $0004
	call L001D35
	jp   c, L001EB1
	ld   de, $000C
	add  hl, de
	ld   [hl], $00
	ld   a, $77
	ld   bc, $0004
	call L001D35
	jp   c, L001EB1
	ld   de, $000C
	add  hl, de
	ld   [hl], $10
	ld   a, $77
	ld   bc, $0004
	call L001D35
	jp   c, L001EB1
	ld   de, $000C
	add  hl, de
	ld   [hl], $20
	ld   a, $77
	ld   bc, $0004
	call L001D35
	jp   c, L001EB1
	ld   de, $000C
	add  hl, de
	ld   [hl], $30
	jp   L001EB1
L027652:;I
	call L027722
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $03
	ldh  [$FFAD], a
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L027667:;I
	call L027722
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $78
	ld   bc, $0000
	call L001D35
	ld   a, $10
	ldh  [$FFAC], a
	ld   hl, $FFAD
	dec  [hl]
	ret  nz
	jp   L001EB1
L027685:;I
	call L027722
	ld   a, $78
	call L001E63
	ld   a, b
	and  a
	ret  nz
	call L001ED7
	call L001EBB
	ld   a, $00
	sbc  a
	and  a, $02
	dec  a
	ld   [$CCE0], a
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB1
L0276A6:;I
	ld   a, $07
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $79
	ld   bc, $00A0
	call L001D35
	ld   a, $18
	call nc, L02772F
	ld   a, $79
	ld   bc, $0000
	call L001D35
	ld   a, $49
	call nc, L02772F
	ld   a, $79
	ld   bc, $0000
	call L001D35
	ld   a, $78
	call nc, L02772F
	call L001ED7
	ld   bc, $0080
	call L001E8E
	ld   bc, $0200
	call L001E95
	jp   L001EB1
L0276EB:;I
	ld   a, $08
	ld   [$CF38], a
	call L002180
	call L002328
	ret  c
	jp   L001EB1
L0276FA:;I
	ld   a, $08
	ld   [$CF38], a
	call L002180
	call L0023A8
	ret  c
	jp   L001EB1
L027709:;I
	ld   a, $77
	call L001E63
	ld   a, b
	and  a
	ret  nz
	jp   L001EB1
L027714:;I
	ld   a, $79
	call L001E63
	ld   a, b
	and  a
	ret  nz
	ld   a, $00
	ldh  [$FFA1], a
	ret  
L027721: db $C9;X
L027722:;C
	ldh  a, [$FF8F]
	rrca 
	rrca 
	rrca 
	and  a, $01
	add  a, $03
	ld   [$CF38], a
	ret  
L02772F:;C
	ld   de, $0005
	add  hl, de
	ldi  [hl], a
	inc  hl
	ld   [hl], $30
	ret  
L027738:;I
	ldh  a, [$FFA1]
	rst  $00
L02773B: db $84
L02773C: db $7D
L02773D: db $51
L02773E: db $77
L02773F: db $62
L027740: db $77
L027741: db $84
L027742: db $77
L027743: db $B0
L027744: db $77
L027745: db $EF
L027746: db $77
L027747: db $F8
L027748: db $77
L027749: db $07
L02774A: db $78
L02774B: db $1C
L02774C: db $78
L02774D: db $2B
L02774E: db $78
L02774F: db $44
L027750: db $78
L027751:;I
	ld   a, $03
	ldh  [$FFAD], a
	ld   bc, $0100
	call L001E8E
	ld   a, $40
	ldh  [$FFAC], a
	jp   L001EB1
L027762:;I
	ldh  a, [$FF8F]
	rrca 
	rrca 
	and  a, $01
	add  a, $03
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	call L000755
	and  a, $03
	add  a
	add  a
	ldh  [$FFAE], a
	ld   a, $04
	ldh  [$FFAC], a
	jp   L001EB1
L027784:;I
	ld   a, $05
	ld   [$CF38], a
	ld   a, $76
	ld   bc, $0000
	call L001D35
	inc  hl
	inc  hl
	ldh  a, [$FFA2]
	ld   [hl], a
	ld   de, $000B
	add  hl, de
	ldh  a, [$FFAE]
	ld   b, a
	ldh  a, [$FFAC]
	dec  a
	add  a, b
	ld   [hl], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L0277B0:;I
	ldh  a, [$FFA2]
	ld   bc, $00C0
	call L0018B9
	ldh  a, [$FF8F]
	rrca 
	rrca 
	and  a, $01
	add  a, $03
	ld   [$CF38], a
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $10
	ldh  [$FFAC], a
	ld   a, $76
	call L001E63
	ld   a, b
	and  a
	ret  nz
	ld   hl, $FFAD
	dec  [hl]
	jp   z, L001EB1
	call L000755
	and  a, $03
	add  a
	add  a
	ldh  [$FFAE], a
	ld   a, $03
	ldh  [$FFA1], a
	ld   a, $04
	ldh  [$FFAC], a
	ret  
L0277EF:;I
	ld   bc, $0240
	call L001E95
	jp   L001EB1
L0277F8:;I
	ld   a, $07
	ld   [$CF38], a
	call L002180
	call L002328
	ret  c
	jp   L001EB1
L027807:;I
	ld   a, $07
	ld   [$CF38], a
	call L002180
	call L0023A8
	ret  c
	ld   bc, $0300
	call L001E95
	jp   L001EB1
L02781C:;I
	ld   a, $07
	ld   [$CF38], a
	call L002180
	call L002328
	ret  c
	jp   L001EB1
L02782B:;I
	ld   a, $07
	ld   [$CF38], a
	call L002180
	call L0023A8
	ret  c
	ldh  a, [$FFA2]
	xor  $80
	ldh  [$FFA2], a
	ld   a, $03
	ldh  [$FFAD], a
	jp   L001EB1
L027844:;I
	ld   a, $01
	ldh  [$FFA1], a
	ret  
L027849: db $CC
L02784A: db $00
L02784B: db $CC
L02784C: db $00
L02784D: db $88
L02784E: db $00
L02784F: db $88
L027850: db $00
L027851: db $CC
L027852: db $00
L027853: db $44
L027854: db $00
L027855: db $10
L027856: db $01
L027857: db $44
L027858: db $00
L027859: db $44
L02785A: db $00
L02785B: db $00
L02785C: db $00
L02785D: db $10
L02785E: db $01
L02785F: db $CC
L027860: db $00
L027861: db $CC
L027862: db $00
L027863: db $88
L027864: db $00
L027865: db $10
L027866: db $01
L027867: db $88
L027868: db $00
L027869: db $10
L02786A: db $01
L02786B: db $00
L02786C: db $00
L02786D: db $10
L02786E: db $01
L02786F: db $CC
L027870: db $00
L027871: db $44
L027872: db $00
L027873: db $88
L027874: db $00
L027875: db $88
L027876: db $00
L027877: db $CC
L027878: db $00
L027879: db $10
L02787A: db $01
L02787B: db $44
L02787C: db $00
L02787D: db $10
L02787E: db $01
L02787F: db $88
L027880: db $00
L027881: db $66
L027882: db $00
L027883: db $00
L027884: db $00
L027885: db $CC
L027886: db $00
L027887: db $CC
L027888: db $00
L027889:;I
	ldh  a, [$FFA1]
	rst  $00
L02788C: db $96
L02788D: db $78
L02788E: db $AB
L02788F: db $78
L027890: db $D8
L027891: db $78
L027892: db $F2
L027893: db $78
L027894: db $FC
L027895: db $78
L027896:;I
	ld   a, [$CF15]
	ld   [$CF47], a
	ld   a, [$CF16]
	ld   [$CF48], a
	call L001FB9
	call L0020D8
	jp   L001EB1
L0278AB:;I
	call L002150
	call L00220A
	ld   a, [$CF47]
	ld   b, a
	ldh  a, [$FFA5]
	sub  a, b
	jr   nc, L0278BE
	xor  $FF
	inc  a
	scf  
L0278BE:;R
	and  a, $F0
	ret  nz
	ld   a, [$CF48]
	ld   b, a
	ldh  a, [$FFA7]
	sub  a, b
	jr   nc, L0278CE
	xor  $FF
	inc  a
	scf  
L0278CE:;R
	and  a, $F0
	ret  nz
	ld   a, $18
	ldh  [$FFAC], a
	jp   L001EB1
L0278D8:;I
	call L002150
	call L00220A
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	call L001FB9
	call L0020D8
	ld   a, $06
	ldh  [$FFAC], a
	jp   L001EB1
L0278F2:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	jp   L001EB1
L0278FC:;I
	call L002150
	call L00220A
	ret  
L027903:;I
	ldh  a, [$FFA1]
	rst  $00
L027906: db $0E
L027907: db $79
L027908: db $1A
L027909: db $79
L02790A: db $33
L02790B: db $79
L02790C: db $48
L02790D: db $79
L02790E:;I
	ld   c, $03
	call L001F43
	ld   a, $30
	ldh  [$FFAC], a
	jp   L001EB1
L02791A:;I
	ld   c, $03
	call L001F43
	call L002150
	call L00220A
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $1E
	ldh  [$FFAC], a
	jp   L001EB1
L027933:;I
	ld   c, $03
	call L001F43
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	call L001FB9
	call L0020D8
	jp   L001EB1
L027948:;I
	ld   c, $03
	call L001F43
	call L002150
	call L00220A
	ret  
L027954:;I
	ldh  a, [$FFA1]
	rst  $00
L027957: db $5F
L027958: db $79
L027959: db $6C
L02795A: db $79
L02795B: db $7B
L02795C: db $79
L02795D: db $94
L02795E: db $79
L02795F:;I
	ld   bc, $0200
	call L001E8E
	ld   a, $0C
	ldh  [$FFAC], a
	jp   L001EB1
L02796C:;I
	call L002180
	jr   nc, L02799A
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	jp   L001EB1
L02797B:;I
	call L002180
	jr   nc, L02799A
	call L001EBB
	cp   $04
	ret  nc
	ld   bc, $0200
	call L001E95
	ld   a, $02
	call L001F34
	jp   L001EB1
L027994:;I
	call L00223A
	jr   nc, L02799A
	ret  
L02799A:;R
	jp   L001E11
L02799D:;I
	ldh  a, [$FFA1]
	rst  $00
L0279A0: db $A4
L0279A1: db $79
L0279A2: db $AD
L0279A3: db $79
L0279A4:;I
	call L001FB9
	call L0020D8
	jp   L001EB1
L0279AD:;I
	call L002150
	call L00220A
	ret  
L0279B4:;I
	ldh  a, [$FFA1]
	rst  $00
L0279B7: db $C1
L0279B8: db $79
L0279B9: db $CA
L0279BA: db $79
L0279BB: db $D7
L0279BC: db $79
L0279BD: db $DE
L0279BE: db $79
L0279BF: db $E8
L0279C0: db $79
L0279C1:;I
	call L001FB9
	call L0020D8
	jp   L001EB1
L0279CA:;I
	call L002180
	jp   nc, L001EB1
	call L00223A
	jp   nc, L001EB1
	ret  
L0279D7:;I
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB1
L0279DE:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	jp   L001EB1
L0279E8:;I
	ld   a, $7A
	ld   bc, $0000
	call L001D35
	jp   L001E11
L0279F3:;I
	ldh  a, [$FFA1]
	rst  $00
L0279F6: db $FA
L0279F7: db $79
L0279F8: db $05
L0279F9: db $7A
L0279FA:;I
	ld   b, $00
	call L001FBB
	call L0020D8
	jp   L001EB1
L027A05:;I
	ld   c, $01
	call L001F43
	call L002150
	call L00220A
	ret  
L027A11:;I
	ldh  a, [$FFA1]
	rst  $00
L027A14: db $1C
L027A15: db $7A
L027A16: db $3A
L027A17: db $7A
L027A18: db $54
L027A19: db $7A
L027A1A: db $70
L027A1B: db $7A
L027A1C:;I
	ldh  a, [$FFAD]
	ld   l, a
	ld   h, $00
	add  hl, hl
	add  hl, hl
	ld   de, $7849
	add  hl, de
	ldi  a, [hl]
	ldh  [$FFA8], a
	ldi  a, [hl]
	ldh  [$FFA9], a
	ldi  a, [hl]
	ldh  [$FFAA], a
	ld   a, [hl]
	ldh  [$FFAB], a
	ld   a, $40
	ldh  [$FFAC], a
	jp   L001EB1
L027A3A:;I
	ld   bc, $0301
	call L001F5F
	call L002150
	call L00220A
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $40
	ldh  [$FFAC], a
	jp   L001EB1
L027A54:;I
	ld   bc, $0301
	call L001F5F
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   bc, $0100
	call L001E8E
	ld   bc, $0000
	call L001E95
	jp   L001EB1
L027A70:;I
	call L002150
	ret  
L027A74:;I
	ldh  a, [$FFA1]
	rst  $00
L027A77: db $7D
L027A78: db $7A
L027A79: db $8A
L027A7A: db $7A
L027A7B: db $C1
L027A7C: db $7A
L027A7D:;I
	ldh  a, [$FFA5]
	ldh  [$FFAE], a
	ldh  a, [$FFA7]
	sub  a, $0B
	ldh  [$FFAF], a
	jp   L001EB1
L027A8A:;I
	ldh  a, [$FFAC]
	and  a, $3F
	ld   hl, $7B00
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldh  a, [$FFAE]
	add  a, [hl]
	ldh  [$FFA5], a
	ld   hl, $7AF0
	ldh  a, [$FFAC]
	and  a, $3F
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldh  a, [$FFAF]
	add  a, [hl]
	ldh  [$FFA7], a
	ldh  a, [$FFAC]
	add  a, $01
	ldh  [$FFAC], a
	ld   a, [$CCE0]
	and  a
	ret  z
	call L001ED7
	ld   bc, $0100
	call L001E8E
	jp   L001EB1
L027AC1:;I
	ld   hl, $FFAE
	ld   a, [$CCE0]
	add  a, [hl]
	ld   [hl], a
	ldh  a, [$FFAC]
	and  a, $3F
	ld   hl, $7B00
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldh  a, [$FFAE]
	add  a, [hl]
	ldh  [$FFA5], a
	ld   hl, $7AF0
	ldh  a, [$FFAC]
	and  a, $3F
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldh  a, [$FFAF]
	add  a, [hl]
	ldh  [$FFA7], a
	ldh  a, [$FFAC]
	add  a, $01
	ldh  [$FFAC], a
	ret  
L027AF0: db $F0
L027AF1: db $F0
L027AF2: db $F0
L027AF3: db $F1
L027AF4: db $F1
L027AF5: db $F2
L027AF6: db $F3
L027AF7: db $F4
L027AF8: db $F5
L027AF9: db $F6
L027AFA: db $F7
L027AFB: db $F8
L027AFC: db $FA
L027AFD: db $FB
L027AFE: db $FD
L027AFF: db $FE
L027B00: db $00
L027B01: db $02
L027B02: db $03
L027B03: db $05
L027B04: db $06
L027B05: db $08
L027B06: db $09
L027B07: db $0A
L027B08: db $0B
L027B09: db $0C
L027B0A: db $0D
L027B0B: db $0E
L027B0C: db $0F
L027B0D: db $0F
L027B0E: db $10
L027B0F: db $10
L027B10: db $10
L027B11: db $10
L027B12: db $10
L027B13: db $0F
L027B14: db $0F
L027B15: db $0E
L027B16: db $0D
L027B17: db $0C
L027B18: db $0B
L027B19: db $0A
L027B1A: db $09
L027B1B: db $08
L027B1C: db $06
L027B1D: db $05
L027B1E: db $03
L027B1F: db $02
L027B20: db $00
L027B21: db $FE
L027B22: db $FD
L027B23: db $FB
L027B24: db $FA
L027B25: db $F8
L027B26: db $F7
L027B27: db $F6
L027B28: db $F5
L027B29: db $F4
L027B2A: db $F3
L027B2B: db $F2
L027B2C: db $F1
L027B2D: db $F1
L027B2E: db $F0
L027B2F: db $F0
L027B30: db $F0
L027B31: db $F0
L027B32: db $F0
L027B33: db $F1
L027B34: db $F1
L027B35: db $F2
L027B36: db $F3
L027B37: db $F4
L027B38: db $F5
L027B39: db $F6
L027B3A: db $F7
L027B3B: db $F8
L027B3C: db $FA
L027B3D: db $FB
L027B3E: db $FD
L027B3F: db $FE
L027B40:;I
	ldh  a, [$FFA1]
	rst  $00
L027B43: db $47
L027B44: db $7B
L027B45: db $56
L027B46: db $7B
L027B47:;I
	ldh  a, [$FFA2]
	and  a, $BF
	ldh  [$FFA2], a
	ld   bc, $0200
	call L001E95
	jp   L001EB1
L027B56:;I
	call L00220A
	ret  
L027B5A:;I
	ldh  a, [$FFA1]
	rst  $00
L027B5D: db $61
L027B5E: db $7B
L027B5F: db $7A
L027B60: db $7B
L027B61:;I
	ldh  a, [$FFA2]
	or   a, $C0
	ldh  [$FFA2], a
	ld   bc, $0100
	call L001E8E
	ld   bc, $0060
	call L001E95
	ld   a, $10
	ldh  [$FFAC], a
	jp   L001EB1
L027B7A:;I
	call L002150
	call L00220A
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ldh  a, [$FFA2]
	xor  $80
	ldh  [$FFA2], a
	ld   a, $10
	ldh  [$FFAC], a
	ret  
L027B92:;I
	ldh  a, [$FFA1]
	rst  $00
L027B95: db $99
L027B96: db $7B
L027B97: db $A0
L027B98: db $7B
L027B99:;I
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB1
L027BA0:;I
	ld   c, $01
	call L001F51
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	jp   L001E11
L027BAF:;I
	ldh  a, [$FFA1]
	rst  $00
L027BB2: db $B6
L027BB3: db $7B
L027BB4: db $C5
L027BB5: db $7B
L027BB6:;I
	ld   a, $04
	ldh  [$FF99], a
	ld   de, $0002
	ld   c, $08
	call L001F7D
	jp   L001EB1
L027BC5:;I
	call L001F8B
	ret  z
	xor  a
	ldh  [$FFA1], a
	ret  
L027BCD:;I
	ld   c, $01
	call L001F51
	call L002150
	call L00220A
	ret  
L027BD9:;I
	ldh  a, [$FFA1]
	rst  $00
L027BDC: db $E0
L027BDD: db $7B
L027BDE: db $ED
L027BDF: db $7B
L027BE0:;I
	call L002180
	call nc, L001E9C
	call L002328
	ret  c
	jp   L001EB1
L027BED:;I
	call L002180
	call nc, L001E9C
	call L0023A8
	ret  c
	jp   L001E11
L027BFA:;I
	ldh  a, [$FFA1]
	or   a
	jr   nz, L027C08
	ld   bc, $0100
	call L001E8E
	jp   L001EB1
L027C08:;R
	ld   c, $01
	call L001F51
	call L002150
	ret  
L027C11:;I
	ldh  a, [$FFA1]
	rst  $00
L027C14: db $18
L027C15: db $7C
L027C16: db $22
L027C17: db $7C
L027C18:;I
	call L002150
	call L0022C6
	ret  c
	jp   L001EB1
L027C22:;I
	call L002150
	call L0022F7
	ret  
L027C29:;JC
	ld   [$CFE6], a
	ld   a, d
	ld   [$CFE7], a
	ld   a, e
	call L001D35
	ret  c
	push hl
	call L001EBB
	swap a
	and  a, $0E
	ld   hl, $7C54
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   c, [hl]
	inc  hl
	ld   b, [hl]
	ld   a, [$CFE7]
	ld   d, a
	ld   e, $00
	ld   a, [$CFE6]
	pop  hl
	jp   L027D75
L027C54: db $80
L027C55: db $00
L027C56: db $C0
L027C57: db $00
L027C58: db $00
L027C59: db $01
L027C5A: db $80;X
L027C5B: db $01;X
L027C5C: db $C0;X
L027C5D: db $01;X
L027C5E: db $00;X
L027C5F: db $02;X
L027C60: db $80;X
L027C61: db $02;X
L027C62: db $00;X
L027C63: db $03;X
L027C64:;C
	ld   a, $7C
	ld   bc, $00FC
	call L001D35
	ret  c
	ldh  a, [$FFA2]
	and  a, $80
	ld   [$CF52], a
	ld   bc, $00B4
	ld   de, $00B4
	call L027D75
	call L001D48
	ret  c
	ld   a, [$CF52]
	ld   bc, $00FF
	ld   de, $0000
	call L027D75
	call L001D48
	ret  c
	ld   a, [$CF52]
	or   a, $40
	ld   bc, $00B4
	ld   de, $00B4
	jp   L027D75
L027C9F:;J
	ld   a, $19
	ld   bc, $00EC
	call L001D35
	ret  c
	ldh  a, [$FFA2]
	and  a, $80
	ld   [$CF52], a
	ld   bc, $00C0
	ld   de, $0180
	call L027D75
	call L001D48
	ret  c
	ld   a, [$CF52]
	ld   bc, $0100
	ld   de, $0200
	call L027D75
	call L001D48
	ret  c
	ld   a, [$CF52]
	ld   bc, $0140
	ld   de, $0280
	jp   L027D75
L027CD8:;C
	ld   a, $28
	ld   bc, $F2FC
	call L001D35
	ret  c
	ld   a, $00
	ld   bc, $0180
	ld   de, $0000
	call L027D75
	ld   a, $28
	ld   bc, $F8F8
	call L001D35
	ret  c
	ld   a, $08
	ld   bc, $010E
	ld   de, $010E
	call L027D75
	ld   a, $28
	ld   bc, $00F0
	call L001D35
	ret  c
	ld   a, $10
	ld   bc, $0000
	ld   de, $0180
	call L027D75
	ld   a, $28
	ld   bc, $08F8
	call L001D35
	ret  c
	ld   a, $88
	ld   bc, $010E
	ld   de, $010E
	call L027D75
	ld   a, $28
	ld   bc, $0EFC
	call L001D35
	ret  c
	ld   a, $80
	ld   bc, $0180
	ld   de, $0000
	jp   L027D75
L027D3C:;C
	ld   a, $71
	ld   bc, $00FC
	call L001D35
	ret  c
	ldh  a, [$FFA2]
	and  a, $80
	ld   [$CF52], a
	ld   bc, $00C0
	ld   de, $00C0
	call L027D75
	call L001D48
	ret  c
	ld   a, [$CF52]
	ld   bc, $0120
	ld   de, $0120
	call L027D75
	call L001D48
	ret  c
	ld   a, [$CF52]
	ld   bc, $0180
	ld   de, $0180
	jp   L027D75
L027D75:;JC
	inc  l
	inc  l
	ld   [hl], a
	ld   a, l
	add  a, $06
	ld   l, a
	ld   [hl], c
	inc  hl
	ld   [hl], b
	inc  hl
	ld   [hl], e
	inc  hl
	ld   [hl], d
	ret  
L027D84:;I
	ld   a, [$CF3A]
	rst  $00
L027D88: db $A8;X
L027D89: db $7D;X
L027D8A: db $A8
L027D8B: db $7D
L027D8C: db $A9
L027D8D: db $7D
L027D8E: db $C7
L027D8F: db $7D
L027D90: db $EB
L027D91: db $7D
L027D92: db $05
L027D93: db $7E
L027D94: db $2A
L027D95: db $7E
L027D96:;I
	ld   a, [$CF3A]
	rst  $00
L027D9A: db $A8;X
L027D9B: db $7D;X
L027D9C: db $A8
L027D9D: db $7D
L027D9E: db $A9
L027D9F: db $7D
L027DA0: db $DB
L027DA1: db $7D
L027DA2: db $F9
L027DA3: db $7D
L027DA4: db $05
L027DA5: db $7E
L027DA6: db $3A
L027DA7: db $7E
L027DA8:;I
	ret  
L027DA9:;I
	ld   a, $0F
	ld   [$CF1D], a
	xor  a
	ld   [$CF44], a
	ld   [$CF73], a
	ld   hl, $CF70
	set  2, [hl]
	ld   a, $1E
	ldh  [$FFAC], a
	ld   hl, $CF3A
	inc  [hl]
	ld   a, $05
	ldh  [$FF98], a
	ret  
L027DC7:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   de, $0002
	ld   c, $1E
	call L001F7D
	ld   hl, $CF3A
	inc  [hl]
	ret  
L027DDB:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   a, $1E
	ldh  [$FFAC], a
	ld   hl, $CF3A
	inc  [hl]
	ret  
L027DEB:;I
	call L001F8B
	ret  z
	ld   a, $01
	call L001F34
	ld   hl, $CF3A
	inc  [hl]
	ret  
L027DF9:;I
	ldh  a, [$FFAC]
	sub  a, $01
	ldh  [$FFAC], a
	ret  nz
	ld   hl, $CF3A
	inc  [hl]
	ret  
L027E05:;I
	ld   a, [$CF44]
	inc  a
	ld   [$CF44], a
	ld   [$CF73], a
	ld   hl, $CF70
	set  2, [hl]
	ld   a, [$CF44]
	and  a, $07
	jr   nz, L027E1F
	ld   a, $0B
	ldh  [$FF99], a
L027E1F:;R
	ld   a, [$CF44]
	cp   $98
	ret  c
	ld   hl, $CF3A
	inc  [hl]
	ret  
L027E2A:;I
	ld   a, $00
	call L001F34
	xor  a
	ld   [$CF1D], a
	inc  a
	ld   [$CF45], a
	ldh  [$FFA1], a
	ret  
L027E3A:;I
	ld   a, $00
	call L001F34
	xor  a
	ld   [$CF1D], a
	inc  a
	ld   [$CF45], a
	ld   hl, $FFA1
	inc  [hl]
	ret  
L027E4C:;C
	call L027EC3
	ld   de, $7F51
	jp   L027EDC
L027E55:;C
	call L001E03
	ret  nc
	call L027EC3
	ld   de, $7F65
	jr   L027EDC
L027E61:;C
	call L001E03
	ret  nc
	call L027EC3
	ld   de, $7F79
	jr   L027EDC
L027E6D:;C
	ldh  a, [$FFA5]
	sub  a, $14
	ld   [$CF0D], a
	ldh  a, [$FFA7]
	sub  a, $14
	ld   [$CF0E], a
	ld   a, $06
	ld   [$CF51], a
	ld   a, $06
	ld   [$CF50], a
	ld   de, $7F8D
	call L027EDC
	ldh  a, [$FF92]
	ld   b, a
	ld   a, [$CF0D]
	sub  a, $08
	add  a, b
	swap a
	and  a, $0F
	ld   b, a
	ld   a, [$CF0C]
	add  a, b
	ld   c, a
	ld   a, [$CF0E]
	sub  a, $10
	swap a
	and  a, $0F
	ld   b, a
	ld   hl, $C000
	add  hl, bc
	ld   e, l
	ld   d, h
	ld   hl, $7FB1
	ld   b, $03
L027EB3:;R
	push de
	ldi  a, [hl]
	ld   [de], a
	inc  d
	ldi  a, [hl]
	ld   [de], a
	inc  d
	ldi  a, [hl]
	ld   [de], a
	inc  d
	pop  de
	inc  e
	dec  b
	jr   nz, L027EB3
	ret  
L027EC3:;C
	ldh  a, [$FFA5]
	sub  a, $12
	ld   [$CF0D], a
	ldh  a, [$FFA7]
	sub  a, $1C
	ld   [$CF0E], a
	ld   a, $05
	ld   [$CF51], a
	ld   a, $04
	ld   [$CF50], a
	ret  
L027EDC:;JCR
	ldh  a, [$FF90]
	ld   b, a
	ld   a, [$CF0E]
	sub  a, $10
	add  a, b
	swap a
	and  a, $0F
	sla  a
	ld   hl, $3C74
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldi  a, [hl]
	ld   [$CF4E], a
	ld   a, [hl]
	ld   [$CF4F], a
	ldh  a, [$FF91]
	ld   b, a
	ldh  a, [$FF92]
	add  a, b
	ld   b, a
	ld   a, [$CF0D]
	sub  a, $08
	add  a, b
	swap a
	and  a, $0F
	sla  a
	ld   b, a
	ld   a, [$CF4E]
	add  a, b
	ld   [$CF4E], a
	ld   hl, $DD00
	ld   a, [$CF51]
	ld   b, a
L027F1C:;R
	ld   a, [$CF4F]
	ldi  [hl], a
	ld   a, [$CF4E]
	ldi  [hl], a
	ld   a, [$CF50]
	or   a, $80
	ldi  [hl], a
	push bc
	ld   a, [$CF50]
	ld   b, a
L027F2F:;R
	ld   a, [de]
	ldi  [hl], a
	inc  de
	dec  b
	jr   nz, L027F2F
	pop  bc
	ld   a, [$CF4E]
	and  a, $E0
	ld   c, a
	ld   a, [$CF4E]
	inc  a
	and  a, $1F
	or   a, c
	ld   [$CF4E], a
	dec  b
	jr   nz, L027F1C
	xor  a
	ldi  [hl], a
	inc  a
	ld   [$CF01], a
	scf  
	ret  
L027F51: db $0B
L027F52: db $1B
L027F53: db $2B
L027F54: db $3B
L027F55: db $0C
L027F56: db $1C
L027F57: db $2C
L027F58: db $3C
L027F59: db $0D
L027F5A: db $1D
L027F5B: db $2D
L027F5C: db $3D
L027F5D: db $0E
L027F5E: db $1E
L027F5F: db $2E
L027F60: db $3E
L027F61: db $0F
L027F62: db $1F
L027F63: db $2F
L027F64: db $3F
L027F65: db $71
L027F66: db $71
L027F67: db $71
L027F68: db $71
L027F69: db $71
L027F6A: db $71
L027F6B: db $71
L027F6C: db $71
L027F6D: db $71
L027F6E: db $71
L027F6F: db $71
L027F70: db $71
L027F71: db $71
L027F72: db $71
L027F73: db $71
L027F74: db $71
L027F75: db $71
L027F76: db $71
L027F77: db $71
L027F78: db $71
L027F79: db $2A
L027F7A: db $3A
L027F7B: db $2A
L027F7C: db $3A
L027F7D: db $29
L027F7E: db $39
L027F7F: db $29
L027F80: db $39
L027F81: db $2A
L027F82: db $3A
L027F83: db $2A
L027F84: db $3A
L027F85: db $29
L027F86: db $39
L027F87: db $29
L027F88: db $39
L027F89: db $2A
L027F8A: db $3A
L027F8B: db $2A
L027F8C: db $3A
L027F8D: db $0A
L027F8E: db $1A
L027F8F: db $2A
L027F90: db $3A
L027F91: db $4A
L027F92: db $4F
L027F93: db $0B
L027F94: db $1B
L027F95: db $2B
L027F96: db $3B
L027F97: db $4B
L027F98: db $48
L027F99: db $0C
L027F9A: db $1C
L027F9B: db $2C
L027F9C: db $3C
L027F9D: db $4C
L027F9E: db $49
L027F9F: db $0D
L027FA0: db $1D
L027FA1: db $2D
L027FA2: db $3D
L027FA3: db $4D
L027FA4: db $49
L027FA5: db $0E
L027FA6: db $1E
L027FA7: db $2E
L027FA8: db $3E
L027FA9: db $4E
L027FAA: db $02
L027FAB: db $22
L027FAC: db $32
L027FAD: db $21
L027FAE: db $31
L027FAF: db $01
L027FB0: db $03
L027FB1: db $22
L027FB2: db $24
L027FB3: db $34
L027FB4: db $23
L027FB5: db $25
L027FB6: db $35
L027FB7: db $2D
L027FB8: db $2E
L027FB9: db $2F
mIncJunk "L027FBA"