L014000:;C
	ld   hl, $4CA9
	ld   a, [$CFDF]
	add  a
	add  a
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldi  a, [hl]
	ld   [$CFEC], a
	ldi  a, [hl]
	ld   [$CFED], a
	ldi  a, [hl]
	ld   [$CFF0], a
	ld   a, [hl]
	ld   [$CFEF], a
	ld   a, [$CFDF]
	rst  $00
L014020: db $60
L014021: db $40
L014022: db $A8
L014023: db $40
L014024: db $B7
L014025: db $40
L014026: db $C6
L014027: db $40
L014028: db $45
L014029: db $41
L01402A: db $8F
L01402B: db $41
L01402C: db $E5
L01402D: db $41
L01402E: db $38
L01402F: db $42
L014030: db $C9
L014031: db $42
L014032: db $EA
L014033: db $42
L014034: db $61
L014035: db $43
L014036: db $8C
L014037: db $43
L014038: db $D5
L014039: db $40
L01403A:;J
	ld   a, [$CF22]
	or   a
	ret  z
	dec  a
	ld   [$CF22], a
	ret  nz
	ld   [$CF23], a
	ret  
L014048:;JR
	ld   a, $0C
	ld   [$CF22], a
	ld   hl, $4C9C
	ld   a, [$CFDF]
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ld   [$CF23], a
	ld   a, $02
	ldh  [$FF99], a
	ret  
L014060:;JI
	xor  a
	ld   [$CFEB], a
	ldh  a, [$FF8B]
	bit  1, a
	jp   z, L01403A
	ld   hl, $CC60
	ld   a, [hl]
	or   a
	jr   z, L014081
	ld   hl, $CC70
	ld   a, [hl]
	or   a
	jr   z, L014081
	ld   hl, $CC80
	ld   a, [hl]
	or   a
	jp   nz, L01403A
L014081:;R
	ld   a, $80
	ld   c, $00
L014085:;J
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ld   a, [$CF12]
	and  a, $01
	ldi  [hl], a
	ld   b, $F2
	or   a
	jr   z, L014095
	ld   b, $0F
L014095:;R
	xor  a
	ldi  [hl], a
	ldi  [hl], a
	ld   a, [$CF15]
	add  a, b
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ld   a, [$CF16]
	sub  a, $0C
	ldi  [hl], a
	ld   [hl], c
	jr   L014048
L0140A8:;I
	xor  a
	ld   [$CFEB], a
	ld   a, $60
	ld   [$CF2D], a
	call L014112
	jp   L014060
L0140B7:;I
	xor  a
	ld   [$CFEB], a
	ld   a, $61
	ld   [$CF2D], a
	call L014112
	jp   L014060
L0140C6:;I
	xor  a
	ld   [$CFEB], a
	ld   a, $62
	ld   [$CF2D], a
	call L014112
	jp   L014060
L0140D5:;I
	xor  a
	ld   [$CFEB], a
	ld   a, $63
	ld   [$CF2D], a
	call L014112
	ld   a, [$CF6C]
	or   a
	jp   z, L014060
	ld   hl, $CC90
	ld   a, [$CF1D]
	cp   $03
	jr   z, L0140F5
	xor  a
	ld   [hl], a
	ret  
L0140F5:;R
	ld   a, $8C
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ld   a, [$CF15]
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ld   a, [$CF16]
	add  a, $04
	ldi  [hl], a
	ld   a, $1C
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ld   [hl], a
	ret  
L014112:;C
	call L003A00
	ret  c
	ldh  a, [$FF8B]
	bit  1, a
	ret  z
	ld   a, [$CFF1]
	or   a
	ret  nz
	xor  a
	ld   [$CF2E], a
	ld   a, $0F
	ld   [$CF2C], a
	ld   b, $18
	ld   a, [$CF12]
	and  a, $01
	jr   nz, L014134
	ld   b, $E8
L014134:;R
	ld   a, [$CF15]
	add  a, b
	ld   [$CF2B], a
	call L001D48
	ret  c
	ld   a, $01
	ld   [$CFF1], a
	ret  
L014145:;I
	ld   a, $01
	ld   [$CFEB], a
	ldh  a, [$FF8B]
	bit  1, a
	jp   z, L01403A
	ld   a, [$CF1D]
	or   a
	jp   z, L01403A
	cp   $04
	jp   nc, L01403A
	ld   a, [$CFEA]
	or   a
	jp   nz, L01403A
	call L003A00
	jp   c, L01403A
	ld   hl, $CC60
	ld   a, $84
	ld   [$CFEA], a
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ld   a, [$CF12]
	and  a, $01
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	inc  hl
	ld   a, [$CF15]
	ldi  [hl], a
	inc  hl
	ld   a, [$CF16]
	sub  a, $08
	ldi  [hl], a
	ld   a, $18
	ld   [hl], a
	jp   L014048
L01418F:;I
	ld   a, $02
	ld   [$CFEB], a
	ldh  a, [$FF8B]
	bit  1, a
	jp   z, L01403A
	ld   hl, $CC60
	ld   a, [hl]
	ld   hl, $CC70
	or   a, [hl]
	ld   hl, $CC80
	or   a, [hl]
	jp   nz, L01403A
	call L003A0B
	jp   c, L01403A
	ld   c, $03
	ld   hl, $CC60
L0141B5:;R
	ld   a, $85
	ldi  [hl], a
	ld   a, c
	ldi  [hl], a
	ld   a, [$CF12]
	and  a, $01
	ldi  [hl], a
	ld   b, $F2
	or   a
	jr   z, L0141C7
	ld   b, $0F
L0141C7:;R
	xor  a
	ldi  [hl], a
	ldi  [hl], a
	ld   a, [$CF15]
	add  a, b
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ld   a, [$CF16]
	sub  a, $0B
	ldi  [hl], a
	ld   [hl], $01
	ld   a, l
	and  a, $F0
	add  a, $10
	ld   l, a
	dec  c
	jr   nz, L0141B5
	jp   L014048
L0141E5:;I
	ld   a, $04
	ld   [$CFEB], a
	ldh  a, [$FF8B]
	bit  1, a
	jp   z, L01403A
	ld   hl, $CC60
	ld   a, [hl]
	ld   hl, $CC70
	or   a, [hl]
	ld   hl, $CC80
	or   a, [hl]
	ld   hl, $CC90
	or   a, [hl]
	jp   nz, L01403A
	call L003A00
	jp   c, L01403A
	ld   a, $01
	ld   [$CFE5], a
	ld   c, $04
	ld   hl, $CC60
L014214:;R
	ld   a, $86
	ldi  [hl], a
	ld   a, c
	dec  a
	ldi  [hl], a
	inc  hl
	xor  a
	ldi  [hl], a
	ldi  [hl], a
	ld   a, [$CF15]
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ld   a, [$CF16]
	sub  a, $0B
	ldi  [hl], a
	ld   [hl], $04
	ld   a, l
	and  a, $F0
	add  a, $10
	ld   l, a
	dec  c
	jr   nz, L014214
	jp   L014048
L014238:;I
	ld   a, $08
	ld   [$CFEB], a
	ldh  a, [$FF8B]
	bit  1, a
	jp   z, L01403A
	ld   hl, $CC60
	ld   a, [hl]
	or   a
	jr   z, L01425A
	ld   hl, $CC70
	ld   a, [hl]
	or   a
	jr   z, L01425A
	ld   hl, $CC80
	ld   a, [hl]
	or   a
	jp   nz, L01403A
L01425A:;R
	call L003A0B
	jp   c, L01403A
	ld   a, $87
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ldh  a, [$FF8A]
	and  a, $F0
	jr   nz, L014273
	ld   a, [$CF12]
	and  a, $01
	ld   c, a
	jr   L014296
L014273:;R
	ld   c, $07
	cp   $90
	jr   z, L014295
	dec  c
	cp   $A0
	jr   z, L014295
	dec  c
	cp   $50
	jr   z, L014295
	dec  c
	cp   $60
	jr   z, L014295
	dec  c
	rla  
	jr   c, L014295
	dec  c
	rla  
	jr   c, L014295
	dec  c
	rla  
	jr   nc, L014295
	dec  c
L014295:;R
	ld   a, c
L014296:;R
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ldi  [hl], a
	ld   a, $EC
	add  a, c
	ld   e, a
	ld   a, $4B
	adc  a, $00
	ld   d, a
	ld   a, [de]
	ld   b, a
	ld   a, [$CF15]
	add  a, b
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ld   a, $F4
	add  a, c
	ld   e, a
	ld   a, $4B
	adc  a, $00
	ld   d, a
	ld   a, [de]
	ld   b, a
	ld   a, [$CF16]
	add  a, b
	ldi  [hl], a
	ld   [hl], $05
	ld   a, $0C
	ld   [$CF22], a
	ld   a, $10
	ld   [$CF23], a
	ret  
L0142C9:;I
	ld   a, $10
	ld   [$CFEB], a
	ldh  a, [$FF8B]
	bit  1, a
	jp   z, L01403A
	ld   hl, $CC60
	ld   a, [hl]
	or   a
	jp   nz, L01403A
	call L003A0B
	jp   c, L01403A
	ld   a, $88
	ld   c, $07
	jp   L014085
L0142EA:;I
	ld   a, $20
	ld   [$CFEB], a
	ldh  a, [$FF8A]
	bit  1, a
	jp   z, L01403A
	ld   hl, $CC60
	ld   a, [hl]
	or   a
	jr   z, L01430C
	ld   hl, $CC70
	ld   a, [hl]
	or   a
	jr   z, L01430C
	ld   hl, $CC80
	ld   a, [hl]
	or   a
	jp   nz, L01403A
L01430C:;R
	ld   de, $CC60
	ld   b, $03
L014311:;R
	ld   a, [de]
	or   a
	jr   z, L01431D
	inc  e
	ld   a, [de]
	cp   $0A
	jp   c, L01403A
	dec  e
L01431D:;R
	ld   a, e
	add  a, $10
	ld   e, a
	dec  b
	jr   nz, L014311
	call L003A0B
	jp   c, L01403A
	ld   a, $89
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ld   a, [$CF12]
	and  a, $01
	ldi  [hl], a
	ld   b, $F2
	or   a
	jr   z, L01433C
	ld   b, $0F
L01433C:;X
	xor  a
	ldi  [hl], a
	ldi  [hl], a
	ld   a, [$CF15]
	add  a, b
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ld   a, [$CFE4]
	xor  $01
	ld   [$CFE4], a
	rra  
	ld   a, [$CF16]
	jr   c, L014358
	sub  a, $0E
	jr   L01435A
L014358:;R
	sub  a, $09
L01435A:;R
	ldi  [hl], a
	ld   a, $13
	ld   [hl], a
	jp   L014048
L014361:;I
	ld   a, $40
	ld   [$CFEB], a
	ldh  a, [$FF8B]
	bit  1, a
	jp   z, L01403A
	ld   hl, $CC60
	ld   a, [hl]
	or   a
	jp   nz, L01403A
	call L003A0B
	jp   c, L01403A
	ld   a, $0F
	ld   [$CF1D], a
	ld   a, $10
	ld   [$CFE3], a
	ld   a, $8A
	ld   c, $14
	jp   L014085
L01438C:;I
	ld   a, $80
	ld   [$CFEB], a
	ldh  a, [$FF8B]
	bit  1, a
	jp   z, L01403A
	ld   hl, $CC60
	ld   a, [hl]
	or   a
	jr   z, L0143A7
L01439F: db $21;X
L0143A0: db $70;X
L0143A1: db $CC;X
L0143A2: db $7E;X
L0143A3: db $B7;X
L0143A4: db $C2;X
L0143A5: db $3A;X
L0143A6: db $40;X
L0143A7:;R
	call L003A0B
	jp   c, L01403A
	ld   a, $8B
	ld   c, $15
	jp   L014085
L0143B4:;C
	ld   a, [$CFE3]
	or   a
	jr   z, L0143C3
	dec  a
	ld   [$CFE3], a
	jr   nz, L0143C3
	ld   [$CF1D], a
L0143C3:;R
	ld   hl, $CC60
	ld   a, [hl]
	or   a
	call nz, L0143E4
	ld   hl, $CC70
	ld   a, [hl]
	or   a
	call nz, L0143E4
	ld   hl, $CC80
	ld   a, [hl]
	or   a
	call nz, L0143E4
	ld   hl, $CC90
	ld   a, [hl]
	or   a
	call nz, L0143E4
	ret  
L0143E4:;C
	push hl
	ld   de, $FFA0
	ld   b, $0C
L0143EA:;R
	ldi  a, [hl]
	ld   [de], a
	inc  de
	dec  b
	jr   nz, L0143EA
	call L014407
	ldh  a, [$FFA3]
	bit  7, a
	call z, L003384
	pop  de
	ld   hl, $FFA0
	ld   b, $0C
L014400:;R
	ldi  a, [hl]
	ld   [de], a
	inc  de
	dec  b
	jr   nz, L014400
	ret  
L014407:;C
	ldh  a, [$FFA3]
	bit  7, a
	jr   nz, L01442C
	ldh  a, [$FFA0]
	and  a, $7F
	rst  $00
L014412: db $65
L014413: db $44
L014414: db $65;X
L014415: db $44;X
L014416: db $65;X
L014417: db $44;X
L014418: db $65;X
L014419: db $44;X
L01441A: db $77
L01441B: db $44
L01441C: db $A7
L01441D: db $44
L01441E: db $DC
L01441F: db $44
L014420: db $E4
L014421: db $45
L014422: db $51
L014423: db $46
L014424: db $CD
L014425: db $46
L014426: db $E2
L014427: db $46
L014428: db $39
L014429: db $47
L01442A: db $65
L01442B: db $44
L01442C:;R
	ldh  a, [$FFA6]
	sub  a, $1C
	ldh  [$FFA6], a
	ldh  a, [$FFA7]
	sbc  a, $02
	ldh  [$FFA7], a
	and  a, $F0
	cp   $00
	jr   nz, L014442
	xor  a
	ldh  [$FFA0], a
	ret  
L014442:;R
	ldh  a, [$FFA2]
	or   a
	jr   z, L014456
	ldh  a, [$FFA4]
	sub  a, $1C
	ldh  [$FFA4], a
	ldh  a, [$FFA5]
	sbc  a, $02
	ldh  [$FFA5], a
	jp   L0147B2
L014456:;R
	ldh  a, [$FFA4]
	add  a, $1C
	ldh  [$FFA4], a
	ldh  a, [$FFA5]
	adc  a, $02
	ldh  [$FFA5], a
	jp   L0147B2
L014465:;I
	ld   hl, $FFA5
	ldh  a, [$FFA2]
	or   a
	jr   nz, L014472
	dec  [hl]
	dec  [hl]
	jp   L0147B2
L014472:;R
	inc  [hl]
	inc  [hl]
	jp   L0147B2
L014477:;I
	ld   a, [$CF42]
	or   a
	jr   z, L014484
	xor  a
	ldh  [$FFA0], a
	ld   [$CFEA], a
	ret  
L014484:;R
	ld   a, [$CF12]
	and  a, $01
	ldh  [$FFA2], a
	ld   a, [$CF15]
	ldh  [$FFA5], a
	ld   a, [$CF16]
	sub  a, $08
	ldh  [$FFA7], a
	ldh  a, [$FFA1]
	inc  a
	and  a, $07
	ldh  [$FFA1], a
	srl  a
	add  a, $18
	ldh  [$FFA8], a
	jp   L0147B2
L0144A7:;I
	ldh  a, [$FFA1]
	ld   bc, $0100
	dec  a
	jr   z, L0144B7
	ld   c, $80
	dec  a
	jr   z, L0144B7
	ld   bc, $0200
L0144B7:;R
	ld   hl, $FFA4
	ldh  a, [$FFA2]
	or   a
	ld   a, [hl]
	jr   nz, L0144C7
	sub  a, c
	ldi  [hl], a
	ld   a, [hl]
	sbc  a, b
	ldi  [hl], a
	jr   L0144CC
L0144C7:;R
	add  a, c
	ldi  [hl], a
	ld   a, [hl]
	adc  a, b
	ldi  [hl], a
L0144CC:;R
	inc  hl
	dec  [hl]
	dec  [hl]
	inc  hl
	ld   a, [hl]
	inc  a
	cp   $03
	jr   c, L0144D8
	ld   a, $01
L0144D8:;R
	ld   [hl], a
	jp   L0147B2
L0144DC:;I
	ldh  a, [$FFA1]
	bit  7, a
	jr   nz, L014551
	ld   c, a
	srl  a
	srl  a
	ld   b, a
	add  a
	add  a, b
	add  a, $03
	cp   $0C
	jr   c, L0144F1
	dec  a
L0144F1:;R
	ld   b, a
	ld   a, c
	and  a, $03
	rst  $00
L0144F6: db $FE
L0144F7: db $44
L0144F8: db $0E
L0144F9: db $45
L0144FA: db $1E
L0144FB: db $45
L0144FC: db $2E
L0144FD: db $45
L0144FE:;I
	ld   hl, $FFA5
	ld   a, [$CF15]
	add  a, b
	ldi  [hl], a
	inc  hl
	ld   a, [$CF16]
	sub  a, b
	ld   [hl], a
	jr   L01453C
L01450E:;I
	ld   hl, $FFA5
	ld   a, [$CF15]
	add  a, b
	ldi  [hl], a
	inc  hl
	ld   a, [$CF16]
	add  a, b
	ld   [hl], a
	jr   L01453C
L01451E:;I
	ld   hl, $FFA5
	ld   a, [$CF15]
	sub  a, b
	ldi  [hl], a
	inc  hl
	ld   a, [$CF16]
	add  a, b
	ld   [hl], a
	jr   L01453C
L01452E:;I
	ld   hl, $FFA5
	ld   a, [$CF15]
	sub  a, b
	ldi  [hl], a
	inc  hl
	ld   a, [$CF16]
	sub  a, b
	ld   [hl], a
L01453C:;R
	ldh  a, [$FFA1]
	add  a, $04
	cp   $10
	jr   c, L01454C
	and  a, $03
	swap a
	add  a, $08
	or   a, $80
L01454C:;R
	ldh  [$FFA1], a
	jp   L0147B2
L014551:;R
	ld   d, a
	and  a, $3F
	ld   b, $00
	ld   c, a
	bit  6, d
	jr   nz, L014573
	ld   hl, $4C0C
	add  hl, bc
	ld   a, [$CF15]
	add  a, [hl]
	ldh  [$FFA5], a
	ld   hl, $4BFC
	add  hl, bc
	ld   a, [$CF16]
	add  a, [hl]
	sub  a, $0C
	ldh  [$FFA7], a
	jr   L014585
L014573:;R
	ld   hl, $4C5C
	add  hl, bc
	ldh  a, [$FFA5]
	add  a, [hl]
	ldh  [$FFA5], a
	ld   hl, $4C4C
	add  hl, bc
	ldh  a, [$FFA7]
	add  a, [hl]
	ldh  [$FFA7], a
L014585:;R
	ld   a, c
	inc  a
	and  a, $3F
	ld   c, a
	ld   a, d
	and  a, $C0
	or   a, c
	ldh  [$FFA1], a
	bit  6, a
	jr   nz, L0145B9
	ldh  a, [$FF8A]
	and  a, $F0
	jp   z, L0147B2
	ld   b, $03
	rla  
	jr   c, L0145A9
	dec  b
	rla  
	jr   c, L0145A9
	dec  b
	rla  
	jr   nc, L0145A9
	dec  b
L0145A9:;R
	ld   a, b
	ldh  [$FFA2], a
	ldh  a, [$FFA1]
	or   a, $40
	ldh  [$FFA1], a
	ld   hl, $CFE5
	dec  [hl]
	call z, L003A0B
L0145B9:;R
	ldh  a, [$FFA2]
	rst  $00
L0145BC: db $C4
L0145BD: db $45
L0145BE: db $CC
L0145BF: db $45
L0145C0: db $D4
L0145C1: db $45
L0145C2: db $DC
L0145C3: db $45
L0145C4:;I
	ld   hl, $FFA5
	dec  [hl]
	dec  [hl]
	jp   L0147B2
L0145CC:;I
	ld   hl, $FFA5
	inc  [hl]
	inc  [hl]
	jp   L0147B2
L0145D4:;I
	ld   hl, $FFA7
	dec  [hl]
	dec  [hl]
	jp   L0147B2
L0145DC:;I
	ld   hl, $FFA7
	inc  [hl]
	inc  [hl]
	jp   L0147B2
L0145E4:;I
	ldh  a, [$FFA1]
	xor  $01
	ldh  [$FFA1], a
	add  a, $05
	ldh  [$FFA8], a
	ldh  a, [$FFA2]
	rst  $00
L0145F1: db $01
L0145F2: db $46
L0145F3: db $09
L0145F4: db $46
L0145F5: db $11
L0145F6: db $46
L0145F7: db $19
L0145F8: db $46
L0145F9: db $21
L0145FA: db $46
L0145FB: db $2D
L0145FC: db $46
L0145FD: db $39;X
L0145FE: db $46;X
L0145FF: db $45
L014600: db $46
L014601:;I
	ld   hl, $FFA5
	dec  [hl]
	dec  [hl]
	jp   L0147B2
L014609:;I
	ld   hl, $FFA5
	inc  [hl]
	inc  [hl]
	jp   L0147B2
L014611:;I
	ld   hl, $FFA7
	dec  [hl]
	dec  [hl]
	jp   L0147B2
L014619:;I
	ld   hl, $FFA7
	inc  [hl]
	inc  [hl]
	jp   L0147B2
L014621:;I
	ld   hl, $FFA5
	dec  [hl]
	dec  [hl]
	inc  hl
	inc  hl
	dec  [hl]
	dec  [hl]
	jp   L0147B2
L01462D:;I
	ld   hl, $FFA5
	inc  [hl]
	inc  [hl]
	inc  hl
	inc  hl
	dec  [hl]
	dec  [hl]
	jp   L0147B2
L014639: db $21;X
L01463A: db $A5;X
L01463B: db $FF;X
L01463C: db $35;X
L01463D: db $35;X
L01463E: db $23;X
L01463F: db $23;X
L014640: db $34;X
L014641: db $34;X
L014642: db $C3;X
L014643: db $B2;X
L014644: db $47;X
L014645:;I
	ld   hl, $FFA5
	inc  [hl]
	inc  [hl]
	inc  hl
	inc  hl
	inc  [hl]
	inc  [hl]
	jp   L0147B2
L014651:;I
	ldh  a, [$FFA1]
	or   a
	jr   nz, L014670
	ldh  a, [$FFA7]
	ld   [$CF0E], a
	ld   hl, $FFA5
	ldh  a, [$FFA2]
	or   a
	ld   b, $FF
	jr   z, L014667
	ld   b, $01
L014667:;R
	call L0146BF
	call c, L0146BF
	jp   c, L0147B2
L014670:;R
	ld   hl, $FFA1
	inc  [hl]
	ld   a, [hl]
	cp   $BC
	jr   c, L01467D
	xor  a
	ldh  [$FFA0], a
	ret  
L01467D:;R
	cp   $80
	jr   nc, L014690
	srl  a
	srl  a
	srl  a
	and  a, $01
	add  a, $08
	ldh  [$FFA8], a
	jp   L0147B2
L014690:;R
	and  a, $7F
	srl  a
	ld   hl, $46A1
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ldh  [$FFA8], a
	jp   L0147B2
L0146A1: db $0C
L0146A2: db $0B
L0146A3: db $0A
L0146A4: db $0B
L0146A5: db $0C
L0146A6: db $0F
L0146A7: db $0E
L0146A8: db $0D
L0146A9: db $0E
L0146AA: db $0F
L0146AB: db $12
L0146AC: db $11
L0146AD: db $10
L0146AE: db $11
L0146AF: db $12
L0146B0: db $0C
L0146B1: db $0B
L0146B2: db $0A
L0146B3: db $0B
L0146B4: db $0C
L0146B5: db $0F
L0146B6: db $0E
L0146B7: db $0D
L0146B8: db $0E
L0146B9: db $0F
L0146BA: db $12
L0146BB: db $11
L0146BC: db $10
L0146BD: db $11
L0146BE: db $12
L0146BF:;C
	ld   a, [hl]
	add  a, b
	ld   [hl], a
	ld   [$CF0D], a
	push bc
	push hl
	call L00332F
	pop  hl
	pop  bc
	ret  
L0146CD:;I
	ld   hl, $FFA1
	inc  [hl]
	ld   l, $A5
	ldh  a, [$FFA2]
	or   a
	jr   nz, L0146DD
L0146D8: db $35;X
L0146D9: db $35;X
L0146DA: db $C3;X
L0146DB: db $B2;X
L0146DC: db $47;X
L0146DD:;R
	inc  [hl]
	inc  [hl]
	jp   L0147B2
L0146E2:;I
	ldh  a, [$FF8A]
	rla  
	jr   c, L0146F7
	rla  
	jr   nc, L014702
	ld   hl, $FFA6
	ld   a, [hl]
	sub  a, $20
	ldi  [hl], a
	ld   a, [hl]
	sbc  a, $00
	ld   [hl], a
	jr   L014702
L0146F7:;R
	ld   hl, $FFA6
	ld   a, [hl]
	add  a, $20
	ldi  [hl], a
	ld   a, [hl]
	adc  a, $00
	ld   [hl], a
L014702:;R
	ld   hl, $FFA1
	ld   a, [hl]
	cp   $10
	jr   nc, L01471B
	inc  [hl]
	ld   hl, $FFA5
	ldh  a, [$FFA2]
	or   a
	jr   nz, L014717
	dec  [hl]
	jp   L0147B2
L014717:;R
	inc  [hl]
	jp   L0147B2
L01471B:;R
	ld   hl, $FFA4
	ldh  a, [$FFA2]
	or   a
	jr   nz, L01472E
	ld   a, [hl]
	sub  a, $80
	ldi  [hl], a
	ld   a, [hl]
	sbc  a, $01
	ld   [hl], a
	jp   L0147B2
L01472E:;R
	ld   a, [hl]
	add  a, $80
	ldi  [hl], a
	ld   a, [hl]
	adc  a, $01
	ld   [hl], a
	jp   L0147B2
L014739:;I
	ldh  a, [$FFA1]
	or   a
	jr   nz, L014798
	ldh  a, [$FFA5]
	ld   b, a
	ld   hl, $CD00
L014744:;R
	ldi  a, [hl]
	or   a
	jr   z, L014767
	ld   e, l
	ld   d, h
	inc  d
	inc  e
	ld   a, [de]
	bit  7, a
	jr   nz, L014759
	cp   $02
	jr   z, L014759
	cp   $03
	jr   nz, L014767
L014759:;R
	inc  l
	inc  l
	inc  l
	inc  l
	ldi  a, [hl]
	sub  a, b
	jr   nc, L014763
	cpl  
	inc  a
L014763:;R
	cp   $05
	jr   c, L014771
L014767:;R
	ld   a, l
	and  a, $F0
	add  a, $10
	ld   l, a
	jr   nz, L014744
	jr   L014782
L014771:;R
	ldh  a, [$FFA7]
	inc  l
	cp   a, [hl]
	ld   a, $02
	jr   nc, L01477A
	inc  a
L01477A:;R
	ldh  [$FFA2], a
	ld   hl, $FFA1
	inc  [hl]
	jr   L014798
L014782:;R
	ld   hl, $FFA5
	ldh  a, [$FFA2]
	or   a
	jr   nz, L014791
	ld   a, [hl]
	sub  a, $02
	ld   [hl], a
	jp   L0147B2
L014791:;R
	ld   a, [hl]
	add  a, $02
	ld   [hl], a
	jp   L0147B2
L014798:;R
	ld   hl, $FFA7
	ldh  a, [$FFA2]
	rra  
	jr   c, L0147A9
	dec  [hl]
	dec  [hl]
	ld   a, $16
	ldh  [$FFA8], a
	jp   L0147B2
L0147A9:;R
	inc  [hl]
	inc  [hl]
	ld   a, $17
	ldh  [$FFA8], a
	jp   L0147B2
L0147B2:;J
	ld   a, [$CF31]
	ld   b, a
	ldh  a, [$FFA5]
	add  a, b
	ldh  [$FFA5], a
	cp   $A8
	jr   c, L0147C3
	cp   $F8
	jr   c, L014812
L0147C3:;R
	ldh  a, [$FFA7]
	cp   $98
	jr   c, L0147CD
	cp   $F8
	jr   c, L014812
L0147CD:;R
	ld   d, $DF
	ldh  a, [$FF97]
	ld   e, a
	ldh  a, [$FFA8]
	add  a
	ld   hl, $4816
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldi  a, [hl]
	ld   h, [hl]
	ld   l, a
	ldi  a, [hl]
	or   a
	ret  z
	ld   b, a
L0147E3:;R
	ldh  a, [$FFA7]
	add  a, [hl]
	inc  hl
	ld   [de], a
	inc  de
	ldh  a, [$FFA2]
	dec  a
	ldi  a, [hl]
	jr   nz, L0147F3
	cpl  
	inc  a
	sub  a, $08
L0147F3:;R
	ld   c, a
	ldh  a, [$FFA5]
	add  a, c
	ld   [de], a
	inc  de
	ldi  a, [hl]
	ld   [de], a
	inc  de
	ldh  a, [$FFA2]
	dec  a
	ldi  a, [hl]
	jr   nz, L014804
	xor  $20
L014804:;R
	ld   c, a
	ld   a, [$CF67]
	or   a, c
	ld   [de], a
	inc  de
	dec  b
	jr   nz, L0147E3
	ld   a, e
	ldh  [$FF97], a
	ret  
L014812:;R
	xor  a
	ldh  [$FFA0], a
	ret  
L014816: db $50
L014817: db $48
L014818: db $C8
L014819: db $48
L01481A: db $D9
L01481B: db $48
L01481C: db $EA;X
L01481D: db $48;X
L01481E: db $FB
L01481F: db $48
L014820: db $00
L014821: db $49
L014822: db $11
L014823: db $49
L014824: db $22
L014825: db $49
L014826: db $33
L014827: db $49
L014828: db $44
L014829: db $49
L01482A: db $55
L01482B: db $49
L01482C: db $96
L01482D: db $49
L01482E: db $D7
L01482F: db $49
L014830: db $18
L014831: db $4A
L014832: db $59
L014833: db $4A
L014834: db $9A
L014835: db $4A
L014836: db $DB
L014837: db $4A
L014838: db $1C
L014839: db $4B
L01483A: db $5D
L01483B: db $4B
L01483C: db $9E
L01483D: db $4B
L01483E: db $A7
L01483F: db $4B
L014840: db $B8
L014841: db $4B
L014842: db $C9
L014843: db $4B
L014844: db $DA
L014845: db $4B
L014846: db $55
L014847: db $48
L014848: db $7A
L014849: db $48
L01484A: db $A3
L01484B: db $48
L01484C: db $7A
L01484D: db $48
L01484E: db $EB
L01484F: db $4B
L014850: db $01
L014851: db $FC
L014852: db $FC
L014853: db $66
L014854: db $00
L014855: db $09
L014856: db $F1
L014857: db $F8
L014858: db $57
L014859: db $00
L01485A: db $F1
L01485B: db $00
L01485C: db $58
L01485D: db $00
L01485E: db $F9
L01485F: db $F5
L014860: db $59
L014861: db $00
L014862: db $F9
L014863: db $FD
L014864: db $5A
L014865: db $00
L014866: db $F9
L014867: db $05
L014868: db $5B
L014869: db $00
L01486A: db $01
L01486B: db $F5
L01486C: db $5C
L01486D: db $00
L01486E: db $01
L01486F: db $FD
L014870: db $5D
L014871: db $00
L014872: db $01
L014873: db $05
L014874: db $5E
L014875: db $00
L014876: db $09
L014877: db $FD
L014878: db $5F
L014879: db $00
L01487A: db $0A
L01487B: db $F1
L01487C: db $F3
L01487D: db $50
L01487E: db $00
L01487F: db $F1
L014880: db $FB
L014881: db $51
L014882: db $00
L014883: db $F1
L014884: db $03
L014885: db $52
L014886: db $00
L014887: db $F1
L014888: db $0B
L014889: db $53
L01488A: db $00
L01488B: db $F9
L01488C: db $F4
L01488D: db $54
L01488E: db $00
L01488F: db $F9
L014890: db $FC
L014891: db $55
L014892: db $00
L014893: db $F9
L014894: db $04
L014895: db $56
L014896: db $00
L014897: db $01
L014898: db $FB
L014899: db $27
L01489A: db $20
L01489B: db $01
L01489C: db $03
L01489D: db $26
L01489E: db $20
L01489F: db $09
L0148A0: db $FA
L0148A1: db $28
L0148A2: db $00
L0148A3: db $09
L0148A4: db $F1
L0148A5: db $F8
L0148A6: db $58
L0148A7: db $20
L0148A8: db $F1
L0148A9: db $00
L0148AA: db $57
L0148AB: db $20
L0148AC: db $F9
L0148AD: db $F3
L0148AE: db $5B
L0148AF: db $20
L0148B0: db $F9
L0148B1: db $FB
L0148B2: db $5A
L0148B3: db $20
L0148B4: db $F9
L0148B5: db $03
L0148B6: db $59
L0148B7: db $20
L0148B8: db $01
L0148B9: db $F3
L0148BA: db $5E
L0148BB: db $20
L0148BC: db $01
L0148BD: db $FB
L0148BE: db $5D
L0148BF: db $20
L0148C0: db $01
L0148C1: db $03
L0148C2: db $5C
L0148C3: db $20
L0148C4: db $09
L0148C5: db $FB
L0148C6: db $5F
L0148C7: db $20
L0148C8: db $04
L0148C9: db $F8
L0148CA: db $F8
L0148CB: db $50
L0148CC: db $00
L0148CD: db $F8
L0148CE: db $00
L0148CF: db $51
L0148D0: db $00
L0148D1: db $00
L0148D2: db $F8
L0148D3: db $52
L0148D4: db $00
L0148D5: db $00
L0148D6: db $00
L0148D7: db $53
L0148D8: db $00
L0148D9: db $04
L0148DA: db $F8
L0148DB: db $F8
L0148DC: db $54
L0148DD: db $00
L0148DE: db $F8
L0148DF: db $00
L0148E0: db $55
L0148E1: db $00
L0148E2: db $00
L0148E3: db $F8
L0148E4: db $56
L0148E5: db $00
L0148E6: db $00
L0148E7: db $00
L0148E8: db $57
L0148E9: db $00
L0148EA: db $04;X
L0148EB: db $F8;X
L0148EC: db $F8;X
L0148ED: db $58;X
L0148EE: db $00;X
L0148EF: db $F8;X
L0148F0: db $00;X
L0148F1: db $59;X
L0148F2: db $00;X
L0148F3: db $00;X
L0148F4: db $F8;X
L0148F5: db $5A;X
L0148F6: db $00;X
L0148F7: db $00;X
L0148F8: db $00;X
L0148F9: db $5B;X
L0148FA: db $00;X
L0148FB: db $01
L0148FC: db $FC
L0148FD: db $FC
L0148FE: db $5F
L0148FF: db $00
L014900: db $04
L014901: db $F8
L014902: db $F8
L014903: db $5C
L014904: db $00
L014905: db $F8
L014906: db $00
L014907: db $5C
L014908: db $20
L014909: db $00
L01490A: db $F8
L01490B: db $5C
L01490C: db $40
L01490D: db $00
L01490E: db $00
L01490F: db $5C
L014910: db $60
L014911: db $04
L014912: db $F8
L014913: db $F8
L014914: db $5D
L014915: db $00
L014916: db $F8
L014917: db $00
L014918: db $5D
L014919: db $20
L01491A: db $00
L01491B: db $F8
L01491C: db $5D
L01491D: db $40
L01491E: db $00
L01491F: db $00
L014920: db $5D
L014921: db $60
L014922: db $04
L014923: db $F8
L014924: db $F8
L014925: db $58
L014926: db $00
L014927: db $F8
L014928: db $00
L014929: db $59
L01492A: db $00
L01492B: db $00
L01492C: db $F8
L01492D: db $5A
L01492E: db $00
L01492F: db $00
L014930: db $00
L014931: db $5B
L014932: db $00
L014933: db $04
L014934: db $F8
L014935: db $F8
L014936: db $5C
L014937: db $00
L014938: db $F8
L014939: db $00
L01493A: db $59
L01493B: db $00
L01493C: db $00
L01493D: db $F8
L01493E: db $5D
L01493F: db $00
L014940: db $00
L014941: db $00
L014942: db $5B
L014943: db $00
L014944: db $04
L014945: db $F8
L014946: db $F8
L014947: db $5C
L014948: db $00
L014949: db $F8
L01494A: db $00
L01494B: db $5E
L01494C: db $00
L01494D: db $00
L01494E: db $F8
L01494F: db $5D
L014950: db $00
L014951: db $00
L014952: db $00
L014953: db $5F
L014954: db $00
L014955: db $10
L014956: db $F2
L014957: db $EE
L014958: db $6D
L014959: db $00
L01495A: db $F2
L01495B: db $F6
L01495C: db $6D
L01495D: db $20
L01495E: db $FA
L01495F: db $EE
L014960: db $6D
L014961: db $40
L014962: db $FA
L014963: db $F6
L014964: db $6D
L014965: db $60
L014966: db $EE
L014967: db $02
L014968: db $6D
L014969: db $00
L01496A: db $EE
L01496B: db $0A
L01496C: db $6D
L01496D: db $20
L01496E: db $F6
L01496F: db $02
L014970: db $6D
L014971: db $40
L014972: db $F6
L014973: db $0A
L014974: db $6D
L014975: db $60
L014976: db $00
L014977: db $F2
L014978: db $6D
L014979: db $00
L01497A: db $00
L01497B: db $FA
L01497C: db $6D
L01497D: db $20
L01497E: db $08
L01497F: db $F2
L014980: db $6D
L014981: db $40
L014982: db $08
L014983: db $FA
L014984: db $6D
L014985: db $60
L014986: db $00
L014987: db $00
L014988: db $6D
L014989: db $00
L01498A: db $00
L01498B: db $08
L01498C: db $6D
L01498D: db $20
L01498E: db $08
L01498F: db $00
L014990: db $6D
L014991: db $40
L014992: db $08
L014993: db $08
L014994: db $6D
L014995: db $60
L014996: db $10
L014997: db $F2
L014998: db $EE
L014999: db $6E
L01499A: db $00
L01499B: db $F2
L01499C: db $F6
L01499D: db $6E
L01499E: db $20
L01499F: db $FA
L0149A0: db $EE
L0149A1: db $6E
L0149A2: db $40
L0149A3: db $FA
L0149A4: db $F6
L0149A5: db $6E
L0149A6: db $60
L0149A7: db $EE
L0149A8: db $02
L0149A9: db $6E
L0149AA: db $00
L0149AB: db $EE
L0149AC: db $0A
L0149AD: db $6E
L0149AE: db $20
L0149AF: db $F6
L0149B0: db $02
L0149B1: db $6E
L0149B2: db $40
L0149B3: db $F6
L0149B4: db $0A
L0149B5: db $6E
L0149B6: db $60
L0149B7: db $00
L0149B8: db $F2
L0149B9: db $6E
L0149BA: db $00
L0149BB: db $00
L0149BC: db $FA
L0149BD: db $6E
L0149BE: db $20
L0149BF: db $08
L0149C0: db $F2
L0149C1: db $6E
L0149C2: db $40
L0149C3: db $08
L0149C4: db $FA
L0149C5: db $6E
L0149C6: db $60
L0149C7: db $00
L0149C8: db $00
L0149C9: db $6E
L0149CA: db $00
L0149CB: db $00
L0149CC: db $08
L0149CD: db $6E
L0149CE: db $20
L0149CF: db $08
L0149D0: db $00
L0149D1: db $6E
L0149D2: db $40
L0149D3: db $08
L0149D4: db $08
L0149D5: db $6E
L0149D6: db $60
L0149D7: db $10
L0149D8: db $F2
L0149D9: db $EE
L0149DA: db $6F
L0149DB: db $00
L0149DC: db $F2
L0149DD: db $F6
L0149DE: db $6F
L0149DF: db $20
L0149E0: db $FA
L0149E1: db $EE
L0149E2: db $6F
L0149E3: db $40
L0149E4: db $FA
L0149E5: db $F6
L0149E6: db $6F
L0149E7: db $60
L0149E8: db $EE
L0149E9: db $02
L0149EA: db $6F
L0149EB: db $00
L0149EC: db $EE
L0149ED: db $0A
L0149EE: db $6F
L0149EF: db $20
L0149F0: db $F6
L0149F1: db $02
L0149F2: db $6F
L0149F3: db $40
L0149F4: db $F6
L0149F5: db $0A
L0149F6: db $6F
L0149F7: db $60
L0149F8: db $00
L0149F9: db $F2
L0149FA: db $6F
L0149FB: db $00
L0149FC: db $00
L0149FD: db $FA
L0149FE: db $6F
L0149FF: db $20
L014A00: db $08
L014A01: db $F2
L014A02: db $6F
L014A03: db $40
L014A04: db $08
L014A05: db $FA
L014A06: db $6F
L014A07: db $60
L014A08: db $00
L014A09: db $00
L014A0A: db $6F
L014A0B: db $00
L014A0C: db $00
L014A0D: db $08
L014A0E: db $6F
L014A0F: db $20
L014A10: db $08
L014A11: db $00
L014A12: db $6F
L014A13: db $40
L014A14: db $08
L014A15: db $08
L014A16: db $6F
L014A17: db $60
L014A18: db $10
L014A19: db $EC
L014A1A: db $F6
L014A1B: db $6D
L014A1C: db $00
L014A1D: db $EC
L014A1E: db $FE
L014A1F: db $6D
L014A20: db $20
L014A21: db $F4
L014A22: db $F6
L014A23: db $6D
L014A24: db $40
L014A25: db $F4
L014A26: db $FE
L014A27: db $6D
L014A28: db $60
L014A29: db $F6
L014A2A: db $F9
L014A2B: db $6D
L014A2C: db $00
L014A2D: db $F6
L014A2E: db $01
L014A2F: db $6D
L014A30: db $20
L014A31: db $FE
L014A32: db $F9
L014A33: db $6D
L014A34: db $40
L014A35: db $FE
L014A36: db $01
L014A37: db $6D
L014A38: db $60
L014A39: db $FE
L014A3A: db $F0
L014A3B: db $6D
L014A3C: db $00
L014A3D: db $FE
L014A3E: db $F8
L014A3F: db $6D
L014A40: db $20
L014A41: db $06
L014A42: db $F0
L014A43: db $6D
L014A44: db $40
L014A45: db $06
L014A46: db $F8
L014A47: db $6D
L014A48: db $60
L014A49: db $01
L014A4A: db $01
L014A4B: db $6D
L014A4C: db $00
L014A4D: db $01
L014A4E: db $09
L014A4F: db $6D
L014A50: db $20
L014A51: db $09
L014A52: db $01
L014A53: db $6D
L014A54: db $40
L014A55: db $09
L014A56: db $09
L014A57: db $6D
L014A58: db $60
L014A59: db $10
L014A5A: db $EC
L014A5B: db $F6
L014A5C: db $6E
L014A5D: db $00
L014A5E: db $EC
L014A5F: db $FE
L014A60: db $6E
L014A61: db $20
L014A62: db $F4
L014A63: db $F6
L014A64: db $6E
L014A65: db $40
L014A66: db $F4
L014A67: db $FE
L014A68: db $6E
L014A69: db $60
L014A6A: db $F6
L014A6B: db $F9
L014A6C: db $6E
L014A6D: db $00
L014A6E: db $F6
L014A6F: db $01
L014A70: db $6E
L014A71: db $20
L014A72: db $FE
L014A73: db $F9
L014A74: db $6E
L014A75: db $40
L014A76: db $FE
L014A77: db $01
L014A78: db $6E
L014A79: db $60
L014A7A: db $FE
L014A7B: db $F0
L014A7C: db $6E
L014A7D: db $00
L014A7E: db $FE
L014A7F: db $F8
L014A80: db $6E
L014A81: db $20
L014A82: db $06
L014A83: db $F0
L014A84: db $6E
L014A85: db $40
L014A86: db $06
L014A87: db $F8
L014A88: db $6E
L014A89: db $60
L014A8A: db $01
L014A8B: db $01
L014A8C: db $6E
L014A8D: db $00
L014A8E: db $01
L014A8F: db $09
L014A90: db $6E
L014A91: db $20
L014A92: db $09
L014A93: db $01
L014A94: db $6E
L014A95: db $40
L014A96: db $09
L014A97: db $09
L014A98: db $6E
L014A99: db $60
L014A9A: db $10
L014A9B: db $EC
L014A9C: db $F6
L014A9D: db $6F
L014A9E: db $00
L014A9F: db $EC
L014AA0: db $FE
L014AA1: db $6F
L014AA2: db $20
L014AA3: db $F4
L014AA4: db $F6
L014AA5: db $6F
L014AA6: db $40
L014AA7: db $F4
L014AA8: db $FE
L014AA9: db $6F
L014AAA: db $60
L014AAB: db $F6
L014AAC: db $F9
L014AAD: db $6F
L014AAE: db $00
L014AAF: db $F6
L014AB0: db $01
L014AB1: db $6F
L014AB2: db $20
L014AB3: db $FE
L014AB4: db $F9
L014AB5: db $6F
L014AB6: db $40
L014AB7: db $FE
L014AB8: db $01
L014AB9: db $6F
L014ABA: db $60
L014ABB: db $FE
L014ABC: db $F0
L014ABD: db $6F
L014ABE: db $00
L014ABF: db $FE
L014AC0: db $F8
L014AC1: db $6F
L014AC2: db $20
L014AC3: db $06
L014AC4: db $F0
L014AC5: db $6F
L014AC6: db $40
L014AC7: db $06
L014AC8: db $F8
L014AC9: db $6F
L014ACA: db $60
L014ACB: db $01
L014ACC: db $01
L014ACD: db $6F
L014ACE: db $00
L014ACF: db $01
L014AD0: db $09
L014AD1: db $6F
L014AD2: db $20
L014AD3: db $09
L014AD4: db $01
L014AD5: db $6F
L014AD6: db $40
L014AD7: db $09
L014AD8: db $09
L014AD9: db $6F
L014ADA: db $60
L014ADB: db $10
L014ADC: db $EE
L014ADD: db $FA
L014ADE: db $6D
L014ADF: db $00
L014AE0: db $EE
L014AE1: db $02
L014AE2: db $6D
L014AE3: db $20
L014AE4: db $F6
L014AE5: db $FA
L014AE6: db $6D
L014AE7: db $40
L014AE8: db $F6
L014AE9: db $02
L014AEA: db $6D
L014AEB: db $60
L014AEC: db $F6
L014AED: db $F0
L014AEE: db $6D
L014AEF: db $00
L014AF0: db $F6
L014AF1: db $F8
L014AF2: db $6D
L014AF3: db $20
L014AF4: db $FE
L014AF5: db $F0
L014AF6: db $6D
L014AF7: db $40
L014AF8: db $FE
L014AF9: db $F8
L014AFA: db $6D
L014AFB: db $60
L014AFC: db $F8
L014AFD: db $00
L014AFE: db $6D
L014AFF: db $00
L014B00: db $F8
L014B01: db $08
L014B02: db $6D
L014B03: db $20
L014B04: db $00
L014B05: db $00
L014B06: db $6D
L014B07: db $40
L014B08: db $00
L014B09: db $08
L014B0A: db $6D
L014B0B: db $60
L014B0C: db $00
L014B0D: db $F6
L014B0E: db $6D
L014B0F: db $00
L014B10: db $00
L014B11: db $FE
L014B12: db $6D
L014B13: db $20
L014B14: db $08
L014B15: db $F6
L014B16: db $6D
L014B17: db $40
L014B18: db $08
L014B19: db $FE
L014B1A: db $6D
L014B1B: db $60
L014B1C: db $10
L014B1D: db $EE
L014B1E: db $FA
L014B1F: db $6E
L014B20: db $00
L014B21: db $EE
L014B22: db $02
L014B23: db $6E
L014B24: db $20
L014B25: db $F6
L014B26: db $FA
L014B27: db $6E
L014B28: db $40
L014B29: db $F6
L014B2A: db $02
L014B2B: db $6E
L014B2C: db $60
L014B2D: db $F6
L014B2E: db $F0
L014B2F: db $6E
L014B30: db $00
L014B31: db $F6
L014B32: db $F8
L014B33: db $6E
L014B34: db $20
L014B35: db $FE
L014B36: db $F0
L014B37: db $6E
L014B38: db $40
L014B39: db $FE
L014B3A: db $F8
L014B3B: db $6E
L014B3C: db $60
L014B3D: db $F8
L014B3E: db $00
L014B3F: db $6E
L014B40: db $00
L014B41: db $F8
L014B42: db $08
L014B43: db $6E
L014B44: db $20
L014B45: db $00
L014B46: db $00
L014B47: db $6E
L014B48: db $40
L014B49: db $00
L014B4A: db $08
L014B4B: db $6E
L014B4C: db $60
L014B4D: db $00
L014B4E: db $F6
L014B4F: db $6E
L014B50: db $00
L014B51: db $00
L014B52: db $FE
L014B53: db $6E
L014B54: db $20
L014B55: db $08
L014B56: db $F6
L014B57: db $6E
L014B58: db $40
L014B59: db $08
L014B5A: db $FE
L014B5B: db $6E
L014B5C: db $60
L014B5D: db $10
L014B5E: db $EE
L014B5F: db $FA
L014B60: db $6F
L014B61: db $00
L014B62: db $EE
L014B63: db $02
L014B64: db $6F
L014B65: db $20
L014B66: db $F6
L014B67: db $FA
L014B68: db $6F
L014B69: db $40
L014B6A: db $F6
L014B6B: db $02
L014B6C: db $6F
L014B6D: db $60
L014B6E: db $F6
L014B6F: db $F0
L014B70: db $6F
L014B71: db $00
L014B72: db $F6
L014B73: db $F8
L014B74: db $6F
L014B75: db $20
L014B76: db $FE
L014B77: db $F0
L014B78: db $6F
L014B79: db $40
L014B7A: db $FE
L014B7B: db $F8
L014B7C: db $6F
L014B7D: db $60
L014B7E: db $F8
L014B7F: db $00
L014B80: db $6F
L014B81: db $00
L014B82: db $F8
L014B83: db $08
L014B84: db $6F
L014B85: db $20
L014B86: db $00
L014B87: db $00
L014B88: db $6F
L014B89: db $40
L014B8A: db $00
L014B8B: db $08
L014B8C: db $6F
L014B8D: db $60
L014B8E: db $00
L014B8F: db $F6
L014B90: db $6F
L014B91: db $00
L014B92: db $00
L014B93: db $FE
L014B94: db $6F
L014B95: db $20
L014B96: db $08
L014B97: db $F6
L014B98: db $6F
L014B99: db $40
L014B9A: db $08
L014B9B: db $FE
L014B9C: db $6F
L014B9D: db $60
L014B9E: db $02
L014B9F: db $FC
L014BA0: db $F8
L014BA1: db $5E
L014BA2: db $00
L014BA3: db $FC
L014BA4: db $00
L014BA5: db $5F
L014BA6: db $00
L014BA7: db $04
L014BA8: db $F8
L014BA9: db $F8
L014BAA: db $5B
L014BAB: db $00
L014BAC: db $F8
L014BAD: db $00
L014BAE: db $5C
L014BAF: db $00
L014BB0: db $00
L014BB1: db $F8
L014BB2: db $5D
L014BB3: db $00
L014BB4: db $00
L014BB5: db $00
L014BB6: db $5E
L014BB7: db $00
L014BB8: db $04
L014BB9: db $F8
L014BBA: db $F8
L014BBB: db $5C
L014BBC: db $00
L014BBD: db $F8
L014BBE: db $00
L014BBF: db $5D
L014BC0: db $00
L014BC1: db $00
L014BC2: db $F8
L014BC3: db $5C
L014BC4: db $40
L014BC5: db $00
L014BC6: db $00
L014BC7: db $5D
L014BC8: db $40
L014BC9: db $04
L014BCA: db $F8
L014BCB: db $F8
L014BCC: db $5E
L014BCD: db $00
L014BCE: db $F8
L014BCF: db $00
L014BD0: db $5E
L014BD1: db $20
L014BD2: db $00
L014BD3: db $F8
L014BD4: db $5F
L014BD5: db $00
L014BD6: db $00
L014BD7: db $00
L014BD8: db $5F
L014BD9: db $20
L014BDA: db $04
L014BDB: db $F8
L014BDC: db $F8
L014BDD: db $5F
L014BDE: db $40
L014BDF: db $F8
L014BE0: db $00
L014BE1: db $5F
L014BE2: db $60
L014BE3: db $00
L014BE4: db $F8
L014BE5: db $5E
L014BE6: db $40
L014BE7: db $00
L014BE8: db $00
L014BE9: db $5E
L014BEA: db $60
L014BEB: db $00
L014BEC: db $F8
L014BED: db $07
L014BEE: db $00
L014BEF: db $00
L014BF0: db $F8
L014BF1: db $07
L014BF2: db $F8;X
L014BF3: db $07
L014BF4: db $F5
L014BF5: db $F5
L014BF6: db $F0
L014BF7: db $00
L014BF8: db $F5
L014BF9: db $F5
L014BFA: db $F5;X
L014BFB: db $F5
L014BFC: db $F0
L014BFD: db $F0
L014BFE: db $F0
L014BFF: db $F1
L014C00: db $F1
L014C01: db $F2
L014C02: db $F3
L014C03: db $F4
L014C04: db $F5
L014C05: db $F6
L014C06: db $F7
L014C07: db $F8
L014C08: db $FA
L014C09: db $FB
L014C0A: db $FD
L014C0B: db $FE
L014C0C: db $00
L014C0D: db $02
L014C0E: db $03
L014C0F: db $05
L014C10: db $06
L014C11: db $08
L014C12: db $09
L014C13: db $0A
L014C14: db $0B
L014C15: db $0C
L014C16: db $0D
L014C17: db $0E
L014C18: db $0F
L014C19: db $0F
L014C1A: db $10
L014C1B: db $10
L014C1C: db $10
L014C1D: db $10
L014C1E: db $10
L014C1F: db $0F
L014C20: db $0F
L014C21: db $0E
L014C22: db $0D
L014C23: db $0C
L014C24: db $0B
L014C25: db $0A
L014C26: db $09
L014C27: db $08
L014C28: db $06
L014C29: db $05
L014C2A: db $03
L014C2B: db $02
L014C2C: db $00
L014C2D: db $FE
L014C2E: db $FD
L014C2F: db $FB
L014C30: db $FA
L014C31: db $F8
L014C32: db $F7
L014C33: db $F6
L014C34: db $F5
L014C35: db $F4
L014C36: db $F3
L014C37: db $F2
L014C38: db $F1
L014C39: db $F1
L014C3A: db $F0
L014C3B: db $F0
L014C3C: db $F0
L014C3D: db $F0
L014C3E: db $F0
L014C3F: db $F1
L014C40: db $F1
L014C41: db $F2
L014C42: db $F3
L014C43: db $F4
L014C44: db $F5
L014C45: db $F6
L014C46: db $F7
L014C47: db $F8
L014C48: db $FA
L014C49: db $FB
L014C4A: db $FD
L014C4B: db $FE
L014C4C: db $00
L014C4D: db $00
L014C4E: db $01
L014C4F: db $00
L014C50: db $01
L014C51: db $01
L014C52: db $01
L014C53: db $01
L014C54: db $01
L014C55: db $01
L014C56: db $01
L014C57: db $02
L014C58: db $01
L014C59: db $02
L014C5A: db $01
L014C5B: db $02
L014C5C: db $02
L014C5D: db $01
L014C5E: db $02
L014C5F: db $01
L014C60: db $02
L014C61: db $01
L014C62: db $01
L014C63: db $01
L014C64: db $01
L014C65: db $01
L014C66: db $01
L014C67: db $01
L014C68: db $00
L014C69: db $01
L014C6A: db $00
L014C6B: db $00
L014C6C: db $00
L014C6D: db $00
L014C6E: db $FF
L014C6F: db $00
L014C70: db $FF
L014C71: db $FF
L014C72: db $FF
L014C73: db $FF
L014C74: db $FF
L014C75: db $FF
L014C76: db $FF
L014C77: db $FE
L014C78: db $FF
L014C79: db $FE
L014C7A: db $FF
L014C7B: db $FE
L014C7C: db $FE
L014C7D: db $FF
L014C7E: db $FE
L014C7F: db $FF
L014C80: db $FE
L014C81: db $FF
L014C82: db $FF
L014C83: db $FF
L014C84: db $FF
L014C85: db $FF
L014C86: db $FF
L014C87: db $FF
L014C88: db $00
L014C89: db $FF
L014C8A: db $00
L014C8B: db $00
L014C8C: db $00
L014C8D: db $00
L014C8E: db $01
L014C8F: db $00
L014C90: db $01
L014C91: db $01
L014C92: db $01
L014C93: db $01
L014C94: db $01
L014C95: db $01
L014C96: db $01
L014C97: db $02
L014C98: db $01
L014C99: db $02
L014C9A: db $01
L014C9B: db $02
L014C9C: db $10
L014C9D: db $10
L014C9E: db $10
L014C9F: db $10
L014CA0: db $00
L014CA1: db $20
L014CA2: db $00
L014CA3: db $20;X
L014CA4: db $20
L014CA5: db $10
L014CA6: db $10
L014CA7: db $10
L014CA8: db $10
L014CA9: db $02
L014CAA: db $02
L014CAB: db $00
L014CAC: db $00
L014CAD: db $02
L014CAE: db $02
L014CAF: db $18
L014CB0: db $00
L014CB1: db $02
L014CB2: db $02
L014CB3: db $01
L014CB4: db $00
L014CB5: db $02
L014CB6: db $02
L014CB7: db $01
L014CB8: db $00
L014CB9: db $08
L014CBA: db $0C
L014CBB: db $08
L014CBC: db $02
L014CBD: db $06
L014CBE: db $06
L014CBF: db $10
L014CC0: db $00
L014CC1: db $06
L014CC2: db $06
L014CC3: db $18
L014CC4: db $02
L014CC5: db $06
L014CC6: db $06
L014CC7: db $02
L014CC8: db $01
L014CC9: db $06
L014CCA: db $06
L014CCB: db $20
L014CCC: db $00
L014CCD: db $06
L014CCE: db $03
L014CCF: db $02
L014CD0: db $00
L014CD1: db $06
L014CD2: db $03
L014CD3: db $10
L014CD4: db $01
L014CD5: db $06
L014CD6: db $06
L014CD7: db $10
L014CD8: db $00
L014CD9: db $03
L014CDA: db $03
L014CDB: db $01
L014CDC: db $00
L014CDD:;C
	ld   a, $02
	call L0003CC
	ld   de, $4F55
	call L0006F2
	ld   de, $5086
	call L0006F2
	call L0006D2
	ld   a, $04
	ldh  [$FF98], a
	xor  a
	ld   [$CFF4], a
	ld   [$CFF5], a
	ld   hl, $CFC0
	ld   b, $10
L014D01:;R
	ldi  [hl], a
	dec  b
	jr   nz, L014D01
	ld   a, $00
	ld   [$DF02], a
	ld   [$DF06], a
	ld   [$DF0A], a
	ld   [$DF0E], a
	xor  a
	ld   [$DF03], a
	xor  $20
	ld   [$DF07], a
	xor  $60
	ld   [$DF0B], a
	xor  $20
	ld   [$DF0F], a
L014D26:;R
	ld   a, [$CFF5]
	swap a
	add  a, $2C
	ld   [$DF00], a
	ld   [$DF04], a
	add  a, $08
	ld   [$DF08], a
	ld   [$DF0C], a
	ld   a, [$CFF4]
	swap a
	add  a, $3C
	ld   [$DF01], a
	ld   [$DF09], a
	add  a, $08
	ld   [$DF05], a
	ld   [$DF0D], a
L014D50:;JR
	rst  $08
	call L000748
	ldh  a, [$FF8B]
	and  a, $F9
	jr   z, L014D50
	ldh  a, [$FF8B]
	bit  0, a
	jr   nz, L014D9F
	bit  3, a
	jr   nz, L014DDA
	push af
	ld   a, $0B
	ldh  [$FF99], a
	pop  af
	rla  
	jr   c, L014D89
	rla  
	jr   c, L014D94
	rla  
	jr   c, L014D7E
	ld   a, [$CFF4]
	inc  a
	and  a, $03
	ld   [$CFF4], a
	jr   L014D26
L014D7E:;R
	ld   a, [$CFF4]
	dec  a
	and  a, $03
	ld   [$CFF4], a
	jr   L014D26
L014D89:;R
	ld   a, [$CFF5]
	inc  a
	and  a, $03
	ld   [$CFF5], a
	jr   L014D26
L014D94:;R
	ld   a, [$CFF5]
	dec  a
	and  a, $03
	ld   [$CFF5], a
	jr   L014D26
L014D9F:;R
	ld   a, $02
	ldh  [$FF99], a
	ld   hl, $CFF5
	ldd  a, [hl]
	add  a
	add  a
	or   a, [hl]
	ld   e, a
	ld   hl, $CFC0
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	xor  $FF
	ld   [hl], a
	ld   b, $1D
	jr   z, L014DBC
	ld   b, $02
L014DBC:;R
	ld   hl, $4EA2
	ld   d, $00
	sla  e
	add  hl, de
	ld   de, $DD00
	call L003B9B
	ld   a, $01
	ld   [de], a
	inc  de
	ld   a, b
	ld   [de], a
	inc  de
	xor  a
	ld   [de], a
	dec  a
	ld   [$CF01], a
	jp   L014D50
L014DDA:;R
	ld   b, $00
	ld   a, [$CFC3]
	rra  
	rl   b
	ld   a, [$CFC5]
	rra  
	rl   b
	ld   a, [$CFC8]
	rra  
	rl   b
	ld   a, [$CFCE]
	rra  
	rl   b
	ld   hl, $4EC6
	ld   c, $05
L014DF9:;R
	ldd  a, [hl]
	cp   a, b
	jr   z, L014E03
	dec  c
	jr   nz, L014DF9
	jp   L014E79
L014E03:;R
	ld   a, c
	dec  a
	ld   [$CFE9], a
	add  a
	ld   hl, $4ED3
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldi  a, [hl]
	ld   h, [hl]
	ld   l, a
	xor  a
	ld   [$CFE2], a
	ld   b, a
	ld   c, a
L014E19:;R
	push bc
	push hl
	push bc
	push hl
	add  hl, bc
	ld   a, [hl]
	add  a
	add  a, [hl]
	ld   c, a
	ld   hl, $4EC7
	add  hl, bc
	ld   d, $00
	call L014E8F
	call L014E8F
	call L014E8F
	pop  hl
	pop  bc
	ld   a, c
	add  a
	add  a
	add  a, $04
	ld   c, a
	add  hl, bc
	ld   b, $04
L014E3C:;R
	ldi  a, [hl]
	cp   a, d
	jr   z, L014E4A
	dec  b
	jr   nz, L014E3C
	ld   a, $FF
	ld   [$CFE2], a
	jr   L014E56
L014E4A:;R
	ld   a, $04
	sub  a, b
	ld   hl, $CFDE
	rra  
	rr   [hl]
	rra  
	rr   [hl]
L014E56:;R
	pop  hl
	pop  bc
	ld   a, [$CFE2]
	and  a
	jr   nz, L014E79
	inc  c
	ld   a, c
	cp   $04
	jr   c, L014E19
	ld   a, [$CFDE]
	and  a, $E1
	jr   z, L014E74
	ld   a, [$CFDE]
	and  a, $1E
	cp   $1E
	jr   nz, L014E79
L014E74:;R
	call L000612
	xor  a
	ret  
L014E79:;JR
	ld   hl, $4F41
	ld   de, $DD00
	ld   bc, $0014
	call L0006B9
	ld   a, $FF
	ld   [$CF01], a
	call L000743
	scf  
	ret  
L014E8F:;C
	push af
	push hl
	ld   a, $C0
	add  a, [hl]
	ld   l, a
	ld   a, $CF
	adc  a, $00
	ld   h, a
	ld   a, [hl]
	rra  
	rl   d
	pop  hl
	pop  af
	inc  hl
	ret  
L014EA2: db $98
L014EA3: db $87
L014EA4: db $98
L014EA5: db $89
L014EA6: db $98
L014EA7: db $8B
L014EA8: db $98
L014EA9: db $8D
L014EAA: db $98
L014EAB: db $C7
L014EAC: db $98
L014EAD: db $C9
L014EAE: db $98
L014EAF: db $CB
L014EB0: db $98
L014EB1: db $CD
L014EB2: db $99
L014EB3: db $07
L014EB4: db $99
L014EB5: db $09
L014EB6: db $99
L014EB7: db $0B
L014EB8: db $99
L014EB9: db $0D
L014EBA: db $99
L014EBB: db $47
L014EBC: db $99
L014EBD: db $49
L014EBE: db $99
L014EBF: db $4B
L014EC0: db $99
L014EC1: db $4D
L014EC2: db $00
L014EC3: db $02
L014EC4: db $05
L014EC5: db $0A
L014EC6: db $0B
L014EC7: db $00
L014EC8: db $01
L014EC9: db $04
L014ECA: db $02
L014ECB: db $06
L014ECC: db $07
L014ECD: db $09
L014ECE: db $0C
L014ECF: db $0D
L014ED0: db $0A
L014ED1: db $0B
L014ED2: db $0F
L014ED3: db $DD
L014ED4: db $4E
L014ED5: db $F1
L014ED6: db $4E
L014ED7: db $05
L014ED8: db $4F
L014ED9: db $19;X
L014EDA: db $4F;X
L014EDB: db $2D
L014EDC: db $4F
L014EDD: db $00
L014EDE: db $01
L014EDF: db $02
L014EE0: db $03
L014EE1: db $04
L014EE2: db $05
L014EE3: db $03
L014EE4: db $06
L014EE5: db $03
L014EE6: db $06
L014EE7: db $04
L014EE8: db $05
L014EE9: db $01
L014EEA: db $03;X
L014EEB: db $04;X
L014EEC: db $06;X
L014EED: db $05
L014EEE: db $03;X
L014EEF: db $01;X
L014EF0: db $06;X
L014EF1: db $01
L014EF2: db $02
L014EF3: db $03
L014EF4: db $00
L014EF5: db $01
L014EF6: db $06
L014EF7: db $02
L014EF8: db $05;X
L014EF9: db $02
L014EFA: db $03
L014EFB: db $04
L014EFC: db $06
L014EFD: db $05
L014EFE: db $01;X
L014EFF: db $03;X
L014F00: db $04;X
L014F01: db $03
L014F02: db $04;X
L014F03: db $01;X
L014F04: db $02;X
L014F05: db $02
L014F06: db $03
L014F07: db $00
L014F08: db $01
L014F09: db $01;X
L014F0A: db $04;X
L014F0B: db $03
L014F0C: db $05;X
L014F0D: db $03;X
L014F0E: db $04;X
L014F0F: db $02;X
L014F10: db $06
L014F11: db $01;X
L014F12: db $02
L014F13: db $05;X
L014F14: db $03;X
L014F15: db $00
L014F16: db $06;X
L014F17: db $04;X
L014F18: db $01;X
L014F19: db $03;X
L014F1A: db $00;X
L014F1B: db $01;X
L014F1C: db $02;X
L014F1D: db $06;X
L014F1E: db $02;X
L014F1F: db $05;X
L014F20: db $03;X
L014F21: db $05;X
L014F22: db $01;X
L014F23: db $06;X
L014F24: db $04;X
L014F25: db $04;X
L014F26: db $03;X
L014F27: db $01;X
L014F28: db $06;X
L014F29: db $00;X
L014F2A: db $02;X
L014F2B: db $01;X
L014F2C: db $03;X
L014F2D: db $00
L014F2E: db $02
L014F2F: db $03
L014F30: db $01
L014F31: db $02
L014F32: db $03
L014F33: db $01
L014F34: db $04
L014F35: db $05
L014F36: db $02
L014F37: db $04
L014F38: db $06
L014F39: db $00
L014F3A: db $02
L014F3B: db $03;X
L014F3C: db $04
L014F3D: db $03
L014F3E: db $02
L014F3F: db $04;X
L014F40: db $06
L014F41: db $99
L014F42: db $E2
L014F43: db $10
L014F44: db $50
L014F45: db $41
L014F46: db $53
L014F47: db $53
L014F48: db $40
L014F49: db $57
L014F4A: db $4F
L014F4B: db $52
L014F4C: db $44
L014F4D: db $40
L014F4E: db $45
L014F4F: db $52
L014F50: db $52
L014F51: db $4F
L014F52: db $52
L014F53: db $5B
L014F54: db $00
L014F55: db $80
L014F56: db $00
L014F57: db $10
L014F58: db $00
L014F59: db $00
L014F5A: db $00
L014F5B: db $00
L014F5C: db $1E
L014F5D: db $1E
L014F5E: db $30
L014F5F: db $30
L014F60: db $20
L014F61: db $20
L014F62: db $20
L014F63: db $20
L014F64: db $20
L014F65: db $20
L014F66: db $00
L014F67: db $00
L014F68: db $00
L014F69:;C
	ld   a, $02
	call L0003CC
	ld   de, $4F55
	call L0006F2
	ld   de, $5086
	call L0006F2
	ld   de, $5049
	call L0006F2
	call L0006D2
	xor  a
	ld   hl, $CFC0
	ld   b, $10
L014F89:;R
	ldi  [hl], a
	dec  b
	jr   nz, L014F89
	ld   a, [$CFE9]
	ld   hl, $4EC2
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   b, [hl]
	ld   a, $FF
	rr   b
	jr   nc, L014FA1
	ld   [$CFCE], a
L014FA1:;R
	rr   b
	jr   nc, L014FA8
	ld   [$CFC8], a
L014FA8:;R
	rr   b
	jr   nc, L014FAF
	ld   [$CFC5], a
L014FAF:;R
	rr   b
	jr   nc, L014FB6
	ld   [$CFC3], a
L014FB6:;R
	ld   a, [$CFE9]
	add  a
	ld   hl, $4ED3
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldi  a, [hl]
	ld   h, [hl]
	ld   l, a
	ld   a, [$CFDE]
	ld   e, a
	xor  a
	ld   b, a
	ld   c, a
L014FCB:;R
	push bc
	push hl
	push bc
	push hl
	ld   a, e
	and  a, $03
	add  a, $04
	ld   d, a
	ld   a, c
	add  a
	add  a
	add  a, d
	ld   c, a
	add  hl, bc
	ld   d, [hl]
	swap d
	rl   d
	pop  hl
	pop  bc
	add  hl, bc
	ld   a, [hl]
	add  a
	add  a, [hl]
	ld   c, a
	ld   hl, $4EC7
	add  hl, bc
	call L015036
	call L015036
	call L015036
	rr   e
	rr   e
	pop  hl
	pop  bc
	inc  c
	ld   a, c
	cp   $04
	jr   c, L014FCB
	ld   hl, $505D
	ld   de, $DD00
	ld   bc, $0029
	call L0006B9
	ld   de, $CFC0
	ld   hl, $DD03
	ld   c, $04
L015014:;R
	ld   b, $04
L015016:;R
	ld   a, [de]
	inc  de
	and  a
	jr   z, L01501D
	ld   [hl], $02
L01501D:;R
	inc  hl
	inc  hl
	dec  b
	jr   nz, L015016
	inc  hl
	inc  hl
	dec  c
	jr   nz, L015014
	ld   a, $FF
	ld   [$CF01], a
L01502C:;R
	rst  $08
	call L000748
	ldh  a, [$FF8B]
	rra  
	jr   nc, L01502C
	ret  
L015036:;C
	push hl
	rl   d
	jr   nc, L015046
	ld   a, $C0
	add  a, [hl]
	ld   l, a
	ld   a, $CF
	adc  a, $00
	ld   h, a
	ld   [hl], $FF
L015046:;R
	pop  hl
	inc  hl
	ret  
L015049: db $99
L01504A: db $E2
L01504B: db $10
L01504C: db $40
L01504D: db $50
L01504E: db $52
L01504F: db $45
L015050: db $53
L015051: db $53
L015052: db $40
L015053: db $41
L015054: db $40
L015055: db $42
L015056: db $55
L015057: db $54
L015058: db $54
L015059: db $4F
L01505A: db $4E
L01505B: db $40
L01505C: db $00
L01505D: db $98
L01505E: db $87
L01505F: db $07
L015060: db $1D
L015061: db $12
L015062: db $1D
L015063: db $12
L015064: db $1D
L015065: db $12
L015066: db $1D
L015067: db $98
L015068: db $C7
L015069: db $07
L01506A: db $1D
L01506B: db $12
L01506C: db $1D
L01506D: db $12
L01506E: db $1D
L01506F: db $12
L015070: db $1D
L015071: db $99
L015072: db $07
L015073: db $07
L015074: db $1D
L015075: db $12
L015076: db $1D
L015077: db $12
L015078: db $1D
L015079: db $12
L01507A: db $1D
L01507B: db $99
L01507C: db $47
L01507D: db $07
L01507E: db $1D
L01507F: db $12
L015080: db $1D
L015081: db $12
L015082: db $1D
L015083: db $12
L015084: db $1D
L015085: db $00
L015086: db $98
L015087: db $00
L015088: db $54
L015089: db $01
L01508A: db $98
L01508B: db $20
L01508C: db $14
L01508D: db $01
L01508E: db $01
L01508F: db $01
L015090: db $01
L015091: db $1E
L015092: db $03
L015093: db $04
L015094: db $05
L015095: db $03
L015096: db $04
L015097: db $05
L015098: db $03
L015099: db $04
L01509A: db $05
L01509B: db $03
L01509C: db $1E
L01509D: db $01
L01509E: db $01
L01509F: db $01
L0150A0: db $01
L0150A1: db $98
L0150A2: db $40
L0150A3: db $14
L0150A4: db $01
L0150A5: db $01
L0150A6: db $01
L0150A7: db $01
L0150A8: db $06
L0150A9: db $1D
L0150AA: db $1D
L0150AB: db $19
L0150AC: db $1D
L0150AD: db $1A
L0150AE: db $1D
L0150AF: db $1B
L0150B0: db $1D
L0150B1: db $1C
L0150B2: db $1D
L0150B3: db $06
L0150B4: db $01
L0150B5: db $01
L0150B6: db $01
L0150B7: db $01
L0150B8: db $98
L0150B9: db $60
L0150BA: db $14
L0150BB: db $01
L0150BC: db $01
L0150BD: db $01
L0150BE: db $01
L0150BF: db $07
L0150C0: db $1D
L0150C1: db $09
L0150C2: db $13
L0150C3: db $0A
L0150C4: db $13
L0150C5: db $0A
L0150C6: db $13
L0150C7: db $0A
L0150C8: db $13
L0150C9: db $0B
L0150CA: db $07
L0150CB: db $01
L0150CC: db $01
L0150CD: db $01
L0150CE: db $01
L0150CF: db $98
L0150D0: db $80
L0150D1: db $14
L0150D2: db $01
L0150D3: db $01
L0150D4: db $01
L0150D5: db $01
L0150D6: db $08
L0150D7: db $15
L0150D8: db $12
L0150D9: db $1D
L0150DA: db $12
L0150DB: db $1D
L0150DC: db $12
L0150DD: db $1D
L0150DE: db $12
L0150DF: db $1D
L0150E0: db $12
L0150E1: db $08
L0150E2: db $01
L0150E3: db $01
L0150E4: db $01
L0150E5: db $01
L0150E6: db $98
L0150E7: db $A0
L0150E8: db $14
L0150E9: db $01
L0150EA: db $01
L0150EB: db $01
L0150EC: db $01
L0150ED: db $06
L0150EE: db $1D
L0150EF: db $0C
L0150F0: db $13
L0150F1: db $0D
L0150F2: db $13
L0150F3: db $0D
L0150F4: db $13
L0150F5: db $0D
L0150F6: db $13
L0150F7: db $0E
L0150F8: db $06
L0150F9: db $01
L0150FA: db $01
L0150FB: db $01
L0150FC: db $01
L0150FD: db $98
L0150FE: db $C0
L0150FF: db $14
L015100: db $01
L015101: db $01
L015102: db $01
L015103: db $01
L015104: db $07
L015105: db $16
L015106: db $12
L015107: db $1D
L015108: db $12
L015109: db $1D
L01510A: db $12
L01510B: db $1D
L01510C: db $12
L01510D: db $1D
L01510E: db $12
L01510F: db $07
L015110: db $01
L015111: db $01
L015112: db $01
L015113: db $01
L015114: db $98
L015115: db $E0
L015116: db $14
L015117: db $01
L015118: db $01
L015119: db $01
L01511A: db $01
L01511B: db $08
L01511C: db $1D
L01511D: db $0C
L01511E: db $13
L01511F: db $0D
L015120: db $13
L015121: db $0D
L015122: db $13
L015123: db $0D
L015124: db $13
L015125: db $0E
L015126: db $08
L015127: db $01
L015128: db $01
L015129: db $01
L01512A: db $01
L01512B: db $99
L01512C: db $00
L01512D: db $14
L01512E: db $01
L01512F: db $01
L015130: db $01
L015131: db $01
L015132: db $06
L015133: db $17
L015134: db $12
L015135: db $1D
L015136: db $12
L015137: db $1D
L015138: db $12
L015139: db $1D
L01513A: db $12
L01513B: db $1D
L01513C: db $12
L01513D: db $06
L01513E: db $01
L01513F: db $01
L015140: db $01
L015141: db $01
L015142: db $99
L015143: db $20
L015144: db $14
L015145: db $01
L015146: db $01
L015147: db $01
L015148: db $01
L015149: db $07
L01514A: db $1D
L01514B: db $0C
L01514C: db $13
L01514D: db $0D
L01514E: db $13
L01514F: db $0D
L015150: db $13
L015151: db $0D
L015152: db $13
L015153: db $0E
L015154: db $07
L015155: db $01
L015156: db $01
L015157: db $01
L015158: db $01
L015159: db $99
L01515A: db $40
L01515B: db $14
L01515C: db $01
L01515D: db $01
L01515E: db $01
L01515F: db $01
L015160: db $08
L015161: db $18
L015162: db $12
L015163: db $1D
L015164: db $12
L015165: db $1D
L015166: db $12
L015167: db $1D
L015168: db $12
L015169: db $1D
L01516A: db $12
L01516B: db $08
L01516C: db $01
L01516D: db $01
L01516E: db $01
L01516F: db $01
L015170: db $99
L015171: db $60
L015172: db $14
L015173: db $01
L015174: db $01
L015175: db $01
L015176: db $01
L015177: db $06
L015178: db $1D
L015179: db $0F
L01517A: db $13
L01517B: db $10
L01517C: db $13
L01517D: db $10
L01517E: db $13
L01517F: db $10
L015180: db $13
L015181: db $11
L015182: db $06
L015183: db $01
L015184: db $01
L015185: db $01
L015186: db $01
L015187: db $99
L015188: db $80
L015189: db $14
L01518A: db $01
L01518B: db $01
L01518C: db $01
L01518D: db $01
L01518E: db $1E
L01518F: db $03
L015190: db $04
L015191: db $05
L015192: db $03
L015193: db $04
L015194: db $05
L015195: db $03
L015196: db $04
L015197: db $05
L015198: db $03
L015199: db $1E
L01519A: db $01
L01519B: db $01
L01519C: db $01
L01519D: db $01
L01519E: db $99
L01519F: db $A0
L0151A0: db $54
L0151A1: db $01
L0151A2: db $99
L0151A3: db $C0
L0151A4: db $14
L0151A5: db $01
L0151A6: db $1E
L0151A7: db $03
L0151A8: db $04
L0151A9: db $05
L0151AA: db $03
L0151AB: db $04
L0151AC: db $05
L0151AD: db $03
L0151AE: db $04
L0151AF: db $05
L0151B0: db $03
L0151B1: db $04
L0151B2: db $05
L0151B3: db $03
L0151B4: db $04
L0151B5: db $05
L0151B6: db $03
L0151B7: db $1E
L0151B8: db $01
L0151B9: db $99
L0151BA: db $E0
L0151BB: db $14
L0151BC: db $01
L0151BD: db $06
L0151BE: db $1D
L0151BF: db $1D
L0151C0: db $1D
L0151C1: db $1D
L0151C2: db $1D
L0151C3: db $1D
L0151C4: db $1D
L0151C5: db $1D
L0151C6: db $1D
L0151C7: db $1D
L0151C8: db $1D
L0151C9: db $1D
L0151CA: db $1D
L0151CB: db $1D
L0151CC: db $1D
L0151CD: db $1D
L0151CE: db $06
L0151CF: db $01
L0151D0: db $9A
L0151D1: db $00
L0151D2: db $14
L0151D3: db $01
L0151D4: db $1E
L0151D5: db $03
L0151D6: db $04
L0151D7: db $05
L0151D8: db $03
L0151D9: db $04
L0151DA: db $05
L0151DB: db $03
L0151DC: db $04
L0151DD: db $05
L0151DE: db $03
L0151DF: db $04
L0151E0: db $05
L0151E1: db $03
L0151E2: db $04
L0151E3: db $05
L0151E4: db $03
L0151E5: db $1E
L0151E6: db $01
L0151E7: db $9A
L0151E8: db $20
L0151E9: db $54
L0151EA: db $01
L0151EB: db $00
L0151EC: db $3E;X
L0151ED: db $0E;X
L0151EE: db $E0;X
L0151EF: db $99;X
L0151F0: db $CF;X
L0151F1: db $CD;X
L0151F2: db $48;X
L0151F3: db $07;X
L0151F4: db $F0;X
L0151F5: db $8B;X
L0151F6: db $CB;X
L0151F7: db $57;X
L0151F8: db $28;X
L0151F9: db $F6;X
L0151FA: db $3E;X
L0151FB: db $0E;X
L0151FC: db $E0;X
L0151FD: db $99;X
L0151FE: db $C9;X
L0151FF: db $3E;X
L015200: db $98;X
L015201: db $EA;X
L015202: db $D0;X
L015203: db $CF;X
L015204: db $EA;X
L015205: db $E0;X
L015206: db $CF;X
L015207: db $FA;X
L015208: db $D0;X
L015209: db $CF;X
L01520A: db $0E;X
L01520B: db $00;X
L01520C: db $CD;X
L01520D: db $25;X
L01520E: db $3A;X
L01520F: db $FA;X
L015210: db $DF;X
L015211: db $CF;X
L015212: db $B7;X
L015213: db $28;X
L015214: db $08;X
L015215: db $FA;X
L015216: db $E0;X
L015217: db $CF;X
L015218: db $0E;X
L015219: db $01;X
L01521A: db $CD;X
L01521B: db $25;X
L01521C: db $3A;X
L01521D: db $DF;X
L01521E: db $C9;X
L01521F:;C
	call L003156
	call L0006D2
	ld   a, $11
	ldh  [$FF98], a
	ld   a, $78
	call L000743
	xor  a
	ld   [$CD0D], a
	ld   hl, $CCEE
	xor  a
	ldi  [hl], a
	ld   a, $70
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ld   a, $40
	ldi  [hl], a
	ld   bc, $FFC0
	ld   [hl], c
	inc  hl
	ld   [hl], b
	inc  hl
	xor  a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ld   [$CCF8], a
L01524D:;R
	ld   a, [$CCF8]
	dec  a
	rrca 
	and  a, $01
	dec  a
	ld   [$CCF5], a
	ld   a, $2D
	ld   [$CCF7], a
L01525D:;R
	xor  a
	ldh  [$FF97], a
	ld   a, [$CCEF]
	ld   [$CF0E], a
	ld   a, [$CCF1]
	ld   [$CF0D], a
	ld   hl, $6275
	ld   a, $02
	call L015A39
	call L000667
	rst  $08
	ld   a, [$CCF8]
	inc  a
	and  a, $01
	dec  a
	add  a
	ld   hl, $CCF6
	add  a, [hl]
	ld   [hl], a
	ld   hl, $2612
	ld   a, [$CCF6]
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [$CCF5]
	xor  a, [hl]
	ld   [$CCF4], a
	ld   hl, $CCEE
	call L015ACF
	ld   a, [$CCEF]
	cp   $18
	jr   z, L0152BB
	ld   a, [$CCF8]
	inc  a
	and  a, $01
	add  a
	ld   hl, $CCF6
	add  a, [hl]
	ld   [hl], a
	ld   hl, $CCF7
	dec  [hl]
	jr   nz, L01525D
	ld   hl, $CCF8
	inc  [hl]
	jr   L01524D
L0152BB:;R
	call L0031A0
	call L0006D2
	ld   a, $78
	call L000743
	ld   hl, $CCEE
	xor  a
	ldi  [hl], a
	ld   a, $98
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ld   a, $40
	ldi  [hl], a
	ld   bc, $FFC0
	ld   [hl], c
	inc  hl
	ld   [hl], b
	inc  hl
	xor  a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ld   a, $FF
	ld   [$CCF5], a
	ld   a, $2D
	ld   [$CCF7], a
L0152E8:;R
	xor  a
	ldh  [$FF97], a
	ld   a, [$CCEF]
	ld   [$CF0E], a
	ld   a, [$CCF1]
	ld   [$CF0D], a
	ld   hl, $6275
	ld   a, $02
	call L015A39
	call L000667
	rst  $08
	ld   hl, $2612
	ld   a, [$CCF6]
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	xor  $FF
	ld   [$CCF4], a
	ld   hl, $CCEE
	call L015ACF
	ld   hl, $CCF6
	inc  [hl]
	inc  [hl]
	ld   hl, $CCF7
	dec  [hl]
	jr   nz, L0152E8
	ld   a, $2D
	ld   [$CCF7], a
L015329:;R
	xor  a
	ldh  [$FF97], a
	ld   a, [$CCEF]
	ld   [$CF0E], a
	ld   a, [$CCF1]
	ld   [$CF0D], a
	ld   hl, $6275
	ld   a, $02
	call L015A39
	call L000667
	rst  $08
	ld   hl, $CCF6
	dec  [hl]
	dec  [hl]
	ld   a, [hl]
	ld   hl, $2612
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   l, [hl]
	ld   h, $00
	add  hl, hl
	ld   a, l
	ld   [$CCF4], a
	ld   a, h
	ld   [$CCF5], a
	ld   hl, $CCEE
	call L015ACF
	ld   hl, $CCF7
	dec  [hl]
	jr   nz, L015329
	ld   a, $2D
	ld   [$CCF7], a
L01536E:;R
	xor  a
	ldh  [$FF97], a
	ld   a, [$CCEF]
	ld   [$CF0E], a
	ld   a, [$CCF1]
	ld   [$CF0D], a
	ld   hl, $6275
	ld   a, $02
	call L015A39
	call L000667
	rst  $08
	ld   hl, $2612
	ld   a, [$CCF6]
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   l, [hl]
	ld   h, $00
	add  hl, hl
	ld   a, l
	ld   [$CCF4], a
	ld   a, h
	ld   [$CCF5], a
	ld   hl, $CCEE
	call L015ACF
	ld   hl, $CCF6
	inc  [hl]
	inc  [hl]
	ld   hl, $CCF7
	dec  [hl]
	jr   nz, L01536E
	ld   a, $FF
	ld   [$CCF5], a
	ld   a, $2D
	ld   [$CCF7], a
L0153BA:;R
	ld   hl, $CCF6
	dec  [hl]
	dec  [hl]
	xor  a
	ldh  [$FF97], a
	ld   a, [$CCEF]
	ld   [$CF0E], a
	ld   a, [$CCF1]
	ld   [$CF0D], a
	ld   hl, $6275
	ld   a, $02
	call L015A39
	call L000667
	rst  $08
	ld   hl, $2612
	ld   a, [$CCF6]
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	xor  $FF
	ld   [$CCF4], a
	ld   hl, $CCEE
	call L015ACF
	ld   hl, $CCF7
	dec  [hl]
	jr   nz, L0153BA
	xor  a
	ldh  [$FF97], a
	call L000667
	rst  $08
	ld   a, $78
	call L000743
	ld   a, $08
	call L0003CC
	ld   de, $5AEA
	call L0006F2
	ld   a, $F0
	ldh  [$FF91], a
	call L0006D2
	ld   a, $80
	ld   [$CF0E], a
	ld   a, $00
	ld   [$CF0D], a
L01541E:;R
	xor  a
	ldh  [$FF97], a
	ld   hl, $627D
	xor  a
	call L015A39
	call L000667
	rst  $08
	ld   a, [$CF0D]
	inc  a
	ld   [$CF0D], a
	cp   $40
	jr   nz, L01541E
	ld   hl, $CCEE
	ld   a, [$CF0E]
	ldi  [hl], a
	ld   a, [$CF0D]
	ldi  [hl], a
	ld   a, $88
	ldi  [hl], a
	ld   a, $D0
	ld   [hl], a
L015448:;R
	xor  a
	ldh  [$FF97], a
	ld   a, [$CCEE]
	ld   [$CF0E], a
	ld   a, [$CCEF]
	ld   [$CF0D], a
	ld   hl, $627D
	xor  a
	call L015A39
	ld   a, [$CCF0]
	ld   [$CF0E], a
	ld   a, [$CCF1]
	ld   [$CF0D], a
	ld   hl, $6289
	xor  a
	call L015A39
	call L000667
	rst  $08
	ld   hl, $CCF1
	dec  [hl]
	ld   hl, $FF91
	inc  [hl]
	ldh  a, [$FF91]
	cp   $21
	jr   nz, L015448
L015483:;R
	xor  a
	ldh  [$FF97], a
	ld   a, [$CCEE]
	ld   [$CF0E], a
	ld   a, [$CCEF]
	ld   [$CF0D], a
	ld   hl, $627D
	xor  a
	call L015A39
	ld   a, [$CCF0]
	ld   [$CF0E], a
	ld   a, [$CCF1]
	ld   [$CF0D], a
	ld   hl, $6289
	xor  a
	call L015A39
	call L000667
	rst  $08
	ld   a, [$CCF0]
	cp   $A0
	adc  a, $00
	ld   [$CCF0], a
	ld   a, [$CCEF]
	inc  a
	ld   [$CCEF], a
	cp   $C0
	jr   nz, L015483
L0154C5:;R
	xor  a
	ldh  [$FF97], a
	ld   a, [$CCEE]
	ld   [$CF0E], a
	ld   a, [$CCEF]
	ld   [$CF0D], a
	ld   hl, $627D
	xor  a
	call L015A39
	ld   a, [$CCF0]
	ld   [$CF0E], a
	ld   a, [$CCF1]
	ld   [$CF0D], a
	ld   hl, $6289
	xor  a
	call L015A39
	call L000667
	rst  $08
	ld   a, [$CCF0]
	dec  a
	ld   [$CCF0], a
	cp   $88
	jr   nz, L0154C5
	ld   a, $B4
	call L000743
	ret  
L015503: db $AF;X
L015504: db $E0;X
L015505: db $97;X
L015506: db $FA;X
L015507: db $EF;X
L015508: db $CC;X
L015509: db $EA;X
L01550A: db $0E;X
L01550B: db $CF;X
L01550C: db $FA;X
L01550D: db $F1;X
L01550E: db $CC;X
L01550F: db $EA;X
L015510: db $0D;X
L015511: db $CF;X
L015512: db $21;X
L015513: db $75;X
L015514: db $62;X
L015515: db $3E;X
L015516: db $02;X
L015517: db $CD;X
L015518: db $39;X
L015519: db $5A;X
L01551A: db $C3;X
L01551B: db $67;X
L01551C: db $06;X
L01551D:;C
	ld   a, $08
	call L0003CC
	ld   de, $5AEA
	call L0006F2
	ld   a, $20
	ldh  [$FF91], a
	call L0006D2
	ld   hl, $4F00
	ld   de, $8500
	ld   bc, $0B08
	call L000646
	ld   a, $01
	ldh  [$FF98], a
	ld   hl, $CCEE
	xor  a
	ld   de, $80C0
	ldi  [hl], a
	ld   [hl], d
	inc  hl
	ldi  [hl], a
	ld   [hl], e
	inc  hl
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ld   de, $88A0
	ldi  [hl], a
	ld   [hl], d
	inc  hl
	ldi  [hl], a
	ld   [hl], e
	inc  hl
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ld   a, $01
	ld   [$CCFB], a
	ld   a, $18
	ld   [$CCFF], a
	call L01576E
	ld   a, $FE
	ld   [$CCF5], a
	ld   a, $00
	ld   [$CCFB], a
	ld   a, $02
	ld   [$CD00], a
	ld   a, $70
	ld   [$CCFF], a
	call L01576E
	ld   a, $B0
	ld   [$CCF1], a
	ld   a, $80
	ld   [$CCF4], a
	ld   a, $FF
	ld   [$CCF5], a
	ld   a, $02
	ld   [$CCFD], a
	ld   a, $FE
	ld   [$CCFE], a
	ld   a, $04
	ld   [$CD00], a
	ld   a, $10
	ld   [$CCFF], a
	call L01576E
	xor  a
	ld   [$CCFD], a
	ld   hl, $5E0C
	ld   a, l
	ld   [$CD02], a
	ld   a, h
	ld   [$CD03], a
	ld   a, $FF
	ld   [$CD04], a
	ld   a, $50
	ld   [$CCFF], a
	call L01576E
	ld   a, $C0
	ld   [$CCF2], a
	ld   a, $FF
	ld   [$CCF3], a
	ld   a, $40
	ld   [$CCFF], a
	call L01576E
	xor  a
	ld   [$CCF2], a
	ld   [$CCF3], a
	ld   [$CCF4], a
	ld   [$CCF5], a
	ld   a, $40
	ld   [$CCFF], a
	call L01576E
	xor  a
	ld   [$CCF2], a
	ld   [$CCF3], a
	ld   a, $80
	ld   [$CCFF], a
	call L01576E
	ld   a, [$CCEF]
	add  a, $08
	ld   [$CCF7], a
	ld   a, [$CCF1]
	ld   [$CCF9], a
	ld   a, $02
	ld   [$CD01], a
	ld   a, $80
	ld   [$CCFF], a
	call L01576E
	ld   a, $01
	ld   [$CCF5], a
	ld   a, $80
	ld   [$CCFF], a
	call L01576E
	ld   a, [$CCEF]
	add  a, $10
	ld   [$CCEF], a
	ld   a, $01
	ld   [$CCF5], a
	ld   a, $02
	ld   [$CD00], a
	ld   a, $80
	ld   [$CCFF], a
	call L01576E
	xor  a
	ld   [$CCF5], a
	ld   a, $10
	ld   [$CCFF], a
	call L01576E
	ld   a, [$CCEF]
	ld   [$CD06], a
	ld   a, [$CCF1]
	ld   [$CD07], a
	ld   hl, $CCEE
	xor  a
	ldi  [hl], a
	ldi  [hl], a
	ld   [hl], $04
	inc  hl
	ld   [hl], $28
	inc  hl
	ldi  [hl], a
	ldi  [hl], a
	ld   [hl], $04
	inc  hl
	ld   [hl], $20
	inc  hl
	ldi  [hl], a
	ldi  [hl], a
	ld   [hl], $04
	inc  hl
	ld   [hl], $18
	inc  hl
	ldi  [hl], a
	ldi  [hl], a
	ld   [hl], $04
	inc  hl
	ld   [hl], $10
	inc  hl
	ld   a, $FF
	ld   [$CCFE], a
L015684:;R
	xor  a
	ldh  [$FF97], a
	ld   a, [$CD06]
	ld   [$CF0E], a
	ld   a, [$CD07]
	ld   [$CF0D], a
	ld   a, [$CCFE]
	add  a
	add  a
	and  a, $10
	ld   [$CD0D], a
	ld   hl, $627D
	ld   a, $02
	call L015A39
	xor  a
	ld   [$CD0D], a
	ld   hl, $CCEE
	ld   b, $04
L0156AE:;R
	push bc
	ldi  a, [hl]
	ld   [$CF0E], a
	ldi  a, [hl]
	ld   [$CF0D], a
	ldi  a, [hl]
	inc  hl
	push hl
	ld   hl, $62A5
	call L015A39
	pop  hl
	pop  bc
	dec  b
	jr   nz, L0156AE
	call L000667
	rst  $08
	ld   hl, $CCEE
	ld   b, $04
L0156CE:;R
	inc  hl
	inc  hl
	inc  hl
	push hl
	dec  [hl]
	call z, L0157FB
	pop  hl
	inc  hl
	dec  b
	jr   nz, L0156CE
	ld   hl, $FF91
	dec  [hl]
	dec  [hl]
	ld   a, [$CCFE]
	dec  a
	ld   [$CCFE], a
	jr   nz, L015684
	ld   a, $08
	call L0003CC
	ld   de, $5C9B
	call L0006F2
	call L0006D2
	ld   a, $02
	ldh  [$FF98], a
	ld   hl, $CCEE
	xor  a
	ld   de, $8040
	ldi  [hl], a
	ld   [hl], d
	inc  hl
	ldi  [hl], a
	ld   [hl], e
	inc  hl
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ld   a, $40
	ld   [$CF0E], a
	ld   a, $A0
	ld   [$CF0D], a
	xor  a
	ld   [$CCFE], a
L01571A:;R
	xor  a
	ldh  [$FF97], a
	ld   hl, $6291
	ld   a, [$CF0E]
	rrca 
	rrca 
	and  a, $01
	call L015A39
	call L000667
	rst  $08
	rst  $08
	ld   hl, $CF0E
	inc  [hl]
	ld   hl, $CF0D
	dec  [hl]
	ld   a, [$CF0E]
	cp   $90
	jr   nz, L01571A
	xor  a
	ld   [$CCFE], a
	ld   a, $00
	ldh  [$FF98], a
	ld   a, $11
	ldh  [$FF99], a
L01574A:;R
	xor  a
	ldh  [$FF97], a
	ld   hl, $6295
	ld   a, [$CCFE]
	rrca 
	rrca 
	rrca 
	rrca 
	and  a, $07
	call L015A39
	call L000667
	rst  $08
	ld   hl, $CCFE
	inc  [hl]
	ld   a, [hl]
	add  a
	jr   nc, L01574A
	ld   a, $78
	call L000743
	ret  
L01576E:;CR
	call L01578D
	ld   hl, $CCEE
	call L015ACF
	ld   hl, $CCF6
	call L015ACF
	ld   hl, $CCFE
	ldh  a, [$FF91]
	add  a, [hl]
	ldh  [$FF91], a
	inc  hl
	ld   hl, $CCFF
	dec  [hl]
	jr   nz, L01576E
	ret  
L01578D:;C
	xor  a
	ldh  [$FF97], a
	ld   a, [$CCEF]
	ld   [$CF0E], a
	ld   a, [$CCF1]
	ld   [$CF0D], a
	ld   hl, $627D
	ld   a, [$CCFF]
	rrca 
	rrca 
	and  a, $01
	ld   b, a
	ld   a, [$CD00]
	add  a, b
	call L015A39
	ld   a, [$CCF7]
	ld   [$CF0E], a
	ld   a, [$CCF9]
	ld   [$CF0D], a
	ld   hl, $6289
	ld   a, [$CCFF]
	rrca 
	rrca 
	and  a, $01
	ld   b, a
	ld   a, [$CD01]
	add  a, b
	call L015A39
	call L000667
	rst  $08
	ld   a, [$CD04]
	and  a
	ret  z
	ld   a, [$CD02]
	ld   l, a
	ld   a, [$CD03]
	ld   h, a
	ld   de, $DD00
	ld   bc, $0015
	call L0006B9
	xor  a
	ld   [de], a
	inc  a
	ld   [$CF01], a
	ld   a, l
	ld   [$CD02], a
	ld   a, h
	ld   [$CD03], a
	ld   a, [hl]
	and  a
	ret  nz
	ld   [$CD04], a
	ret  
L0157FB:;C
	ld   [hl], $08
	dec  hl
	ld   a, [hl]
	inc  a
	ld   [hl], a
	cp   $03
	ret  c
	ld   [hl], $00
	dec  hl
	call L000755
	and  a, $38
	sub  a, $20
	ld   c, a
	ld   a, [$CD07]
	add  a, c
	ld   [hl], a
	dec  hl
	call L000755
	and  a, $38
	sub  a, $20
	ld   c, a
	ld   a, [$CD06]
	add  a, c
	ld   [hl], a
	ld   a, $06
	ldh  [$FF99], a
	ret  
L015827:;C
	ld   a, $12
	ldh  [$FF98], a
	ld   hl, $5F5D
	ld   a, l
	ld   [$CD02], a
	ld   a, h
	ld   [$CD03], a
L015836:;JR
	rst  $08
	rst  $08
	rst  $08
	rst  $08
	ld   hl, $CF0E
	inc  [hl]
	xor  a
	ldh  [$FF97], a
	ld   hl, $6295
	ld   a, $07
	call L015A39
	call L000667
	ld   hl, $FF90
	dec  [hl]
	ld   a, [hl]
	and  a, $01
	jp   z, L015836
	ld   a, [$CD02]
	ld   l, a
	ld   a, [$CD03]
	ld   h, a
	ld   de, $DD00
	ld   bc, $000D
	call L0006B9
	xor  a
	ld   [de], a
	inc  a
	ld   [$CF01], a
	ld   a, l
	ld   [$CD02], a
	ld   a, h
	ld   [$CD03], a
	ld   a, [hl]
	and  a
	jr   nz, L015836
	ld   hl, $7400
	ld   de, $8000
	ld   bc, $0B80
	call L000646
	ld   b, $10
L015887:;R
	ld   a, $04
	call L000743
	ld   hl, $FF90
	dec  [hl]
	dec  b
	jr   nz, L015887
	xor  a
	ld   [$CCEE], a
	ld   a, $40
	ld   [$CCF6], a
	ld   a, $B0
	ld   [$CCF7], a
L0158A1:;R
	ld   hl, $659F
	ld   a, [$CCEE]
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	call L001DC0
	ld   b, $20
	call L0159B9
L0158B4:;R
	xor  a
	ldh  [$FF97], a
	ld   a, $50
	ld   [$CF0E], a
	ld   a, $88
	ld   [$CF0D], a
	ld   hl, $62B1
	xor  a
	call L015A39
	ld   a, [$CCF6]
	ld   [$CF0E], a
	ld   a, [$CCF7]
	ld   [$CF0D], a
	ld   hl, $65CC
	ld   a, [$CCEE]
	call L015A39
	call L000667
	rst  $08
	ld   hl, $CCF7
	dec  [hl]
	ld   a, [hl]
	cp   $58
	call z, L0159C3
	ld   b, $78
	call z, L0159B9
	call L0159A7
	ld   a, [hl]
	cp   $C0
	jr   nz, L0158B4
	ld   hl, $CCEE
	inc  [hl]
	ld   a, [hl]
	cp   $26
	jr   nz, L0158A1
	ld   a, $80
	ld   [$CD02], a
	ld   b, $10
	call L0159C9
L01590B:;R
	ld   b, $20
L01590D:;R
	push bc
	call L0159A7
	call L0159EB
	rst  $08
	pop  bc
	dec  b
	jr   nz, L01590D
	ld   a, [$CD02]
	sub  a, $04
	ld   [$CD02], a
	ld   l, a
	ld   h, $13
	add  hl, hl
	add  hl, hl
	add  hl, hl
	ld   de, $DD00
	ld   a, h
	ld   [de], a
	inc  de
	ld   a, l
	ld   [de], a
	inc  de
	ld   a, $54
	ld   [de], a
	inc  de
	ld   a, $70
	ld   [de], a
	inc  de
	xor  a
	ld   [de], a
	inc  a
	ld   [$CF01], a
	ld   a, [$CD02]
	and  a
	jr   nz, L01590B
	ld   hl, $7400
	ld   de, $9200
	ld   bc, $0B60
	call L000646
	ld   a, $60
	ldh  [$FF90], a
	ld   hl, $6167
	ld   a, l
	ld   [$CD02], a
	ld   a, h
	ld   [$CD03], a
L01595F:;R
	ld   b, $40
L015961:;R
	push bc
	call L0159D5
	call L0159EB
	rst  $08
	pop  bc
	dec  b
	jr   nz, L015961
	ld   a, [$CD02]
	ld   l, a
	ld   a, [$CD03]
	ld   h, a
	ld   de, $DD00
	ld   bc, $0010
	call L0006B9
	xor  a
	ld   [de], a
	inc  a
	ld   [$CF01], a
	ld   a, l
	ld   [$CD02], a
	ld   a, h
	ld   [$CD03], a
	ld   a, [hl]
	and  a
	jr   nz, L01595F
L015990:;R
	call L0159D5
	call L0159EB
	rst  $08
	ldh  a, [$FF90]
	cp   $80
	jr   nz, L015990
L01599D:;R
	call L015A2B
	call L0159EB
	rst  $08
	jr   L01599D
L0159A6: db $C9;X
L0159A7:;C
	ld   a, [$CCFE]
	add  a, $40
	ld   [$CCFE], a
	ret  nc
	ldh  a, [$FF90]
	dec  a
	ldh  [$FF90], a
	ld   [$CCFF], a
	ret  
L0159B9:;CR
	call L0159A7
	push bc
	rst  $08
	pop  bc
	dec  b
	jr   nz, L0159B9
	ret  
L0159C3:;C
	push af
	call L015A6F
	pop  af
	ret  
L0159C9:;CR
	push bc
	call L0159A7
	rst  $08
	pop  bc
	ldh  a, [$FF90]
	cp   a, b
	jr   nz, L0159C9
	ret  
L0159D5:;C
	ld   a, [$CCFE]
	add  a, $40
	ld   [$CCFE], a
	ret  nc
	ldh  a, [$FF90]
	inc  a
	ldh  [$FF90], a
	ld   a, [$CCFF]
	dec  a
	ld   [$CCFF], a
	ret  
L0159EB:;C
	xor  a
	ldh  [$FF97], a
	ld   a, $50
	ld   [$CF0E], a
	ld   a, $88
	ld   [$CF0D], a
	ld   hl, $62B1
	xor  a
	call L015A39
	ld   hl, $DF00
	ldh  a, [$FF97]
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   e, l
	ld   d, h
	ld   hl, $6218
	ld   b, $1A
L015A0F:;R
	ld   a, [$CCFF]
	xor  $FF
	add  a, [hl]
	ld   [de], a
	inc  hl
	inc  de
	ldi  a, [hl]
	ld   [de], a
	inc  de
	ldi  a, [hl]
	ld   [de], a
	inc  de
	xor  a
	ld   [de], a
	inc  de
	dec  b
	jr   nz, L015A0F
	ld   a, e
	ldh  [$FF97], a
	call L000667
	ret  
L015A2B:;C
	ld   a, [$CCFE]
	add  a, $40
	ld   [$CCFE], a
	ret  nc
	ld   hl, $CCFF
	dec  [hl]
	ret  
L015A39:;C
	add  a
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   e, [hl]
	inc  hl
	ld   d, [hl]
	ld   l, e
	ld   h, d
	ld   de, $DF00
	ldh  a, [$FF97]
	add  a, e
	ld   e, a
	ld   a, d
	adc  a, $00
	ld   d, a
	ld   b, [hl]
	inc  hl
L015A50:;R
	ld   a, [$CF0E]
	add  a, [hl]
	ld   [de], a
	inc  hl
	inc  de
	ld   a, [$CF0D]
	add  a, [hl]
	ld   [de], a
	inc  hl
	inc  de
	ldi  a, [hl]
	ld   [de], a
	inc  de
	ld   a, [$CD0D]
	xor  a, [hl]
	ld   [de], a
	inc  hl
	inc  de
	dec  b
	jr   nz, L015A50
	ld   a, e
	ldh  [$FF97], a
	ret  
L015A6F:;C
	ld   a, [$CCEE]
	add  a
	ld   hl, $661A
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   e, [hl]
	inc  hl
	ld   d, [hl]
	ld   l, e
	ld   h, d
	ld   a, $48
	ld   [$CD06], a
	ld   a, [hl]
	inc  hl
	and  a, $1F
	add  a
	add  a
	add  a
	ld   [$CD07], a
	ld   [$CD08], a
	ld   de, $DF00
	ldh  a, [$FF97]
	add  a, e
	ld   e, a
	ld   a, d
	adc  a, $00
	ld   d, a
L015A9C:;R
	ld   a, [$CD06]
	ld   [de], a
	inc  de
	ld   a, [$CD07]
	ld   [de], a
	add  a, $08
	ld   [$CD07], a
	inc  de
	ldi  a, [hl]
	sub  a, $20
	ld   [de], a
	inc  de
	xor  a
	ld   [de], a
	inc  de
	ld   a, [hl]
	cp   $2F
	call z, L015AC1
	cp   $2E
	jr   nz, L015A9C
	ld   a, e
	ldh  [$FF97], a
	ret  
L015AC1:;C
	ld   a, $50
	ld   [$CD06], a
	ld   a, [$CD08]
	ld   [$CD07], a
	inc  hl
	ld   a, [hl]
	ret  
L015ACF:;C
	ld   e, l
	ld   d, h
	inc  hl
	inc  hl
	inc  hl
	inc  hl
	ld   a, [de]
	add  a, [hl]
	ld   [de], a
	inc  hl
	inc  de
	ld   a, [de]
	adc  a, [hl]
	ld   [de], a
	inc  hl
	inc  de
	ld   a, [de]
	add  a, [hl]
	ld   [de], a
	inc  hl
	inc  de
	ld   a, [de]
	adc  a, [hl]
	ld   [de], a
	inc  hl
	inc  de
	ret  
L015AEA: db $98
L015AEB: db $00
L015AEC: db $18
L015AED: db $70
L015AEE: db $70
L015AEF: db $70
L015AF0: db $70
L015AF1: db $70
L015AF2: db $70
L015AF3: db $70
L015AF4: db $70
L015AF5: db $70
L015AF6: db $70
L015AF7: db $70
L015AF8: db $70
L015AF9: db $70
L015AFA: db $70
L015AFB: db $70
L015AFC: db $0A
L015AFD: db $70
L015AFE: db $70
L015AFF: db $70
L015B00: db $70
L015B01: db $70
L015B02: db $70
L015B03: db $70
L015B04: db $70
L015B05: db $98
L015B06: db $20
L015B07: db $18
L015B08: db $70
L015B09: db $70
L015B0A: db $70
L015B0B: db $70
L015B0C: db $70
L015B0D: db $70
L015B0E: db $70
L015B0F: db $70
L015B10: db $70
L015B11: db $70
L015B12: db $70
L015B13: db $70
L015B14: db $70
L015B15: db $70
L015B16: db $0B
L015B17: db $70
L015B18: db $70
L015B19: db $70
L015B1A: db $70
L015B1B: db $70
L015B1C: db $70
L015B1D: db $70
L015B1E: db $70
L015B1F: db $70
L015B20: db $98
L015B21: db $40
L015B22: db $18
L015B23: db $70
L015B24: db $70
L015B25: db $0B
L015B26: db $70
L015B27: db $70
L015B28: db $70
L015B29: db $70
L015B2A: db $09
L015B2B: db $70
L015B2C: db $70
L015B2D: db $70
L015B2E: db $70
L015B2F: db $70
L015B30: db $70
L015B31: db $70
L015B32: db $70
L015B33: db $70
L015B34: db $70
L015B35: db $70
L015B36: db $70
L015B37: db $70
L015B38: db $0D
L015B39: db $0E
L015B3A: db $0F
L015B3B: db $98
L015B3C: db $60
L015B3D: db $18
L015B3E: db $70
L015B3F: db $70
L015B40: db $70
L015B41: db $70
L015B42: db $70
L015B43: db $70
L015B44: db $70
L015B45: db $70
L015B46: db $70
L015B47: db $70
L015B48: db $70
L015B49: db $70
L015B4A: db $70
L015B4B: db $70
L015B4C: db $70
L015B4D: db $70
L015B4E: db $70
L015B4F: db $70
L015B50: db $70
L015B51: db $70
L015B52: db $1C
L015B53: db $1D
L015B54: db $1E
L015B55: db $1F
L015B56: db $98
L015B57: db $80
L015B58: db $18
L015B59: db $0B
L015B5A: db $70
L015B5B: db $70
L015B5C: db $70
L015B5D: db $70
L015B5E: db $70
L015B5F: db $70
L015B60: db $70
L015B61: db $0B
L015B62: db $70
L015B63: db $70
L015B64: db $70
L015B65: db $70
L015B66: db $70
L015B67: db $70
L015B68: db $70
L015B69: db $70
L015B6A: db $70
L015B6B: db $70
L015B6C: db $70
L015B6D: db $2C
L015B6E: db $2D
L015B6F: db $2E
L015B70: db $2F
L015B71: db $98
L015B72: db $A0
L015B73: db $18
L015B74: db $70
L015B75: db $70
L015B76: db $70
L015B77: db $70
L015B78: db $70
L015B79: db $70
L015B7A: db $70
L015B7B: db $70
L015B7C: db $70
L015B7D: db $70
L015B7E: db $70
L015B7F: db $70
L015B80: db $70
L015B81: db $70
L015B82: db $70
L015B83: db $70
L015B84: db $70
L015B85: db $70
L015B86: db $70
L015B87: db $3B
L015B88: db $3C
L015B89: db $3D
L015B8A: db $3E
L015B8B: db $3F
L015B8C: db $98
L015B8D: db $C0
L015B8E: db $18
L015B8F: db $70
L015B90: db $70
L015B91: db $0B
L015B92: db $70
L015B93: db $70
L015B94: db $70
L015B95: db $70
L015B96: db $09
L015B97: db $0B
L015B98: db $70
L015B99: db $70
L015B9A: db $70
L015B9B: db $70
L015B9C: db $70
L015B9D: db $70
L015B9E: db $09
L015B9F: db $70
L015BA0: db $70
L015BA1: db $70
L015BA2: db $4B
L015BA3: db $4C
L015BA4: db $4D
L015BA5: db $4E
L015BA6: db $4F
L015BA7: db $98
L015BA8: db $E0
L015BA9: db $18
L015BAA: db $70
L015BAB: db $70
L015BAC: db $70
L015BAD: db $70
L015BAE: db $70
L015BAF: db $70
L015BB0: db $70
L015BB1: db $70
L015BB2: db $70
L015BB3: db $70
L015BB4: db $70
L015BB5: db $70
L015BB6: db $70
L015BB7: db $70
L015BB8: db $70
L015BB9: db $70
L015BBA: db $70
L015BBB: db $70
L015BBC: db $5A
L015BBD: db $5B
L015BBE: db $5C
L015BBF: db $5D
L015BC0: db $5E
L015BC1: db $5F
L015BC2: db $99
L015BC3: db $00
L015BC4: db $18
L015BC5: db $0B
L015BC6: db $70
L015BC7: db $70
L015BC8: db $70
L015BC9: db $70
L015BCA: db $70
L015BCB: db $70
L015BCC: db $70
L015BCD: db $70
L015BCE: db $70
L015BCF: db $70
L015BD0: db $70
L015BD1: db $70
L015BD2: db $70
L015BD3: db $0B
L015BD4: db $70
L015BD5: db $70
L015BD6: db $70
L015BD7: db $6A
L015BD8: db $6B
L015BD9: db $6C
L015BDA: db $6D
L015BDB: db $6E
L015BDC: db $6F
L015BDD: db $99
L015BDE: db $20
L015BDF: db $18
L015BE0: db $70
L015BE1: db $70
L015BE2: db $70
L015BE3: db $70
L015BE4: db $70
L015BE5: db $70
L015BE6: db $70
L015BE7: db $70
L015BE8: db $70
L015BE9: db $70
L015BEA: db $70
L015BEB: db $70
L015BEC: db $70
L015BED: db $70
L015BEE: db $70
L015BEF: db $70
L015BF0: db $70
L015BF1: db $70
L015BF2: db $70
L015BF3: db $70
L015BF4: db $7C
L015BF5: db $7D
L015BF6: db $7E
L015BF7: db $70
L015BF8: db $99
L015BF9: db $40
L015BFA: db $18
L015BFB: db $0B
L015BFC: db $70
L015BFD: db $70
L015BFE: db $70
L015BFF: db $70
L015C00: db $70
L015C01: db $70
L015C02: db $70
L015C03: db $70
L015C04: db $70
L015C05: db $70
L015C06: db $70
L015C07: db $70
L015C08: db $70
L015C09: db $70
L015C0A: db $70
L015C0B: db $70
L015C0C: db $70
L015C0D: db $70
L015C0E: db $70
L015C0F: db $58
L015C10: db $59
L015C11: db $70
L015C12: db $70
L015C13: db $99
L015C14: db $60
L015C15: db $18
L015C16: db $70
L015C17: db $70
L015C18: db $70
L015C19: db $70
L015C1A: db $70
L015C1B: db $70
L015C1C: db $70
L015C1D: db $70
L015C1E: db $70
L015C1F: db $70
L015C20: db $70
L015C21: db $70
L015C22: db $70
L015C23: db $70
L015C24: db $70
L015C25: db $70
L015C26: db $70
L015C27: db $70
L015C28: db $70
L015C29: db $70
L015C2A: db $68
L015C2B: db $69
L015C2C: db $70
L015C2D: db $70
L015C2E: db $99
L015C2F: db $80
L015C30: db $18
L015C31: db $70
L015C32: db $70
L015C33: db $70
L015C34: db $70
L015C35: db $70
L015C36: db $70
L015C37: db $70
L015C38: db $70
L015C39: db $70
L015C3A: db $70
L015C3B: db $70
L015C3C: db $70
L015C3D: db $70
L015C3E: db $70
L015C3F: db $70
L015C40: db $70
L015C41: db $70
L015C42: db $09
L015C43: db $0B
L015C44: db $70
L015C45: db $78
L015C46: db $79
L015C47: db $70
L015C48: db $70
L015C49: db $99
L015C4A: db $A0
L015C4B: db $18
L015C4C: db $70
L015C4D: db $70
L015C4E: db $70
L015C4F: db $70
L015C50: db $70
L015C51: db $70
L015C52: db $70
L015C53: db $70
L015C54: db $70
L015C55: db $70
L015C56: db $70
L015C57: db $70
L015C58: db $70
L015C59: db $70
L015C5A: db $70
L015C5B: db $70
L015C5C: db $70
L015C5D: db $70
L015C5E: db $70
L015C5F: db $70
L015C60: db $70
L015C61: db $70
L015C62: db $70
L015C63: db $70
L015C64: db $99
L015C65: db $C0
L015C66: db $18
L015C67: db $70
L015C68: db $70
L015C69: db $70
L015C6A: db $70
L015C6B: db $0B
L015C6C: db $70
L015C6D: db $70
L015C6E: db $70
L015C6F: db $70
L015C70: db $70
L015C71: db $70
L015C72: db $0A
L015C73: db $70
L015C74: db $70
L015C75: db $0B
L015C76: db $70
L015C77: db $70
L015C78: db $70
L015C79: db $70
L015C7A: db $70
L015C7B: db $70
L015C7C: db $70
L015C7D: db $0B
L015C7E: db $70
L015C7F: db $99
L015C80: db $E0
L015C81: db $18
L015C82: db $70
L015C83: db $70
L015C84: db $70
L015C85: db $70
L015C86: db $70
L015C87: db $70
L015C88: db $70
L015C89: db $70
L015C8A: db $70
L015C8B: db $70
L015C8C: db $0B
L015C8D: db $70
L015C8E: db $70
L015C8F: db $70
L015C90: db $70
L015C91: db $70
L015C92: db $70
L015C93: db $70
L015C94: db $70
L015C95: db $70
L015C96: db $70
L015C97: db $70
L015C98: db $70
L015C99: db $70
L015C9A: db $00
L015C9B: db $98
L015C9C: db $40
L015C9D: db $14
L015C9E: db $70
L015C9F: db $70
L015CA0: db $0B
L015CA1: db $70
L015CA2: db $70
L015CA3: db $09
L015CA4: db $70
L015CA5: db $70
L015CA6: db $70
L015CA7: db $70
L015CA8: db $70
L015CA9: db $70
L015CAA: db $70
L015CAB: db $70
L015CAC: db $70
L015CAD: db $70
L015CAE: db $70
L015CAF: db $0A
L015CB0: db $70
L015CB1: db $70
L015CB2: db $98
L015CB3: db $60
L015CB4: db $14
L015CB5: db $70
L015CB6: db $70
L015CB7: db $70
L015CB8: db $70
L015CB9: db $70
L015CBA: db $70
L015CBB: db $70
L015CBC: db $70
L015CBD: db $70
L015CBE: db $70
L015CBF: db $70
L015CC0: db $70
L015CC1: db $70
L015CC2: db $70
L015CC3: db $70
L015CC4: db $70
L015CC5: db $0B
L015CC6: db $70
L015CC7: db $70
L015CC8: db $70
L015CC9: db $98
L015CCA: db $80
L015CCB: db $14
L015CCC: db $0B
L015CCD: db $70
L015CCE: db $70
L015CCF: db $70
L015CD0: db $70
L015CD1: db $70
L015CD2: db $0B
L015CD3: db $70
L015CD4: db $70
L015CD5: db $70
L015CD6: db $70
L015CD7: db $0A
L015CD8: db $70
L015CD9: db $70
L015CDA: db $0B
L015CDB: db $70
L015CDC: db $70
L015CDD: db $70
L015CDE: db $0B
L015CDF: db $70
L015CE0: db $98
L015CE1: db $A0
L015CE2: db $14
L015CE3: db $70
L015CE4: db $70
L015CE5: db $70
L015CE6: db $70
L015CE7: db $70
L015CE8: db $70
L015CE9: db $70
L015CEA: db $70
L015CEB: db $70
L015CEC: db $70
L015CED: db $0B
L015CEE: db $70
L015CEF: db $70
L015CF0: db $70
L015CF1: db $70
L015CF2: db $70
L015CF3: db $70
L015CF4: db $70
L015CF5: db $70
L015CF6: db $70
L015CF7: db $98
L015CF8: db $C0
L015CF9: db $14
L015CFA: db $70
L015CFB: db $70
L015CFC: db $70
L015CFD: db $70
L015CFE: db $0B
L015CFF: db $70
L015D00: db $70
L015D01: db $70
L015D02: db $70
L015D03: db $70
L015D04: db $0B
L015D05: db $70
L015D06: db $70
L015D07: db $70
L015D08: db $0B
L015D09: db $70
L015D0A: db $0B
L015D0B: db $70
L015D0C: db $70
L015D0D: db $70
L015D0E: db $98
L015D0F: db $E0
L015D10: db $14
L015D11: db $70
L015D12: db $70
L015D13: db $70
L015D14: db $70
L015D15: db $70
L015D16: db $70
L015D17: db $70
L015D18: db $70
L015D19: db $70
L015D1A: db $70
L015D1B: db $70
L015D1C: db $70
L015D1D: db $70
L015D1E: db $70
L015D1F: db $70
L015D20: db $70
L015D21: db $70
L015D22: db $70
L015D23: db $70
L015D24: db $70
L015D25: db $99
L015D26: db $00
L015D27: db $14
L015D28: db $70
L015D29: db $70
L015D2A: db $0B
L015D2B: db $70
L015D2C: db $70
L015D2D: db $70
L015D2E: db $70
L015D2F: db $70
L015D30: db $70
L015D31: db $0A
L015D32: db $70
L015D33: db $70
L015D34: db $70
L015D35: db $70
L015D36: db $70
L015D37: db $09
L015D38: db $70
L015D39: db $0A
L015D3A: db $0B
L015D3B: db $70
L015D3C: db $99
L015D3D: db $20
L015D3E: db $14
L015D3F: db $70
L015D40: db $70
L015D41: db $70
L015D42: db $70
L015D43: db $70
L015D44: db $70
L015D45: db $70
L015D46: db $70
L015D47: db $0B
L015D48: db $70
L015D49: db $70
L015D4A: db $70
L015D4B: db $70
L015D4C: db $70
L015D4D: db $70
L015D4E: db $70
L015D4F: db $0B
L015D50: db $70
L015D51: db $70
L015D52: db $70
L015D53: db $99
L015D54: db $40
L015D55: db $14
L015D56: db $70
L015D57: db $70
L015D58: db $70
L015D59: db $70
L015D5A: db $70
L015D5B: db $70
L015D5C: db $70
L015D5D: db $70
L015D5E: db $70
L015D5F: db $70
L015D60: db $70
L015D61: db $70
L015D62: db $70
L015D63: db $70
L015D64: db $70
L015D65: db $70
L015D66: db $0B
L015D67: db $70
L015D68: db $70
L015D69: db $70
L015D6A: db $99
L015D6B: db $60
L015D6C: db $14
L015D6D: db $70
L015D6E: db $70
L015D6F: db $70
L015D70: db $70
L015D71: db $70
L015D72: db $70
L015D73: db $70
L015D74: db $70
L015D75: db $70
L015D76: db $70
L015D77: db $70
L015D78: db $70
L015D79: db $70
L015D7A: db $70
L015D7B: db $70
L015D7C: db $70
L015D7D: db $70
L015D7E: db $70
L015D7F: db $70
L015D80: db $70
L015D81: db $99
L015D82: db $80
L015D83: db $14
L015D84: db $00
L015D85: db $01
L015D86: db $02
L015D87: db $03
L015D88: db $04
L015D89: db $05
L015D8A: db $06
L015D8B: db $60
L015D8C: db $70
L015D8D: db $60
L015D8E: db $70
L015D8F: db $70
L015D90: db $70
L015D91: db $70
L015D92: db $70
L015D93: db $70
L015D94: db $70
L015D95: db $70
L015D96: db $70
L015D97: db $70
L015D98: db $99
L015D99: db $A0
L015D9A: db $14
L015D9B: db $10
L015D9C: db $11
L015D9D: db $12
L015D9E: db $13
L015D9F: db $14
L015DA0: db $15
L015DA1: db $16
L015DA2: db $17
L015DA3: db $18
L015DA4: db $19
L015DA5: db $70
L015DA6: db $70
L015DA7: db $70
L015DA8: db $70
L015DA9: db $70
L015DAA: db $70
L015DAB: db $70
L015DAC: db $70
L015DAD: db $70
L015DAE: db $70
L015DAF: db $99
L015DB0: db $C0
L015DB1: db $14
L015DB2: db $70
L015DB3: db $70
L015DB4: db $70
L015DB5: db $23
L015DB6: db $24
L015DB7: db $25
L015DB8: db $26
L015DB9: db $27
L015DBA: db $28
L015DBB: db $29
L015DBC: db $20
L015DBD: db $21
L015DBE: db $70
L015DBF: db $70
L015DC0: db $70
L015DC1: db $70
L015DC2: db $70
L015DC3: db $70
L015DC4: db $70
L015DC5: db $09
L015DC6: db $99
L015DC7: db $E0
L015DC8: db $14
L015DC9: db $70
L015DCA: db $70
L015DCB: db $70
L015DCC: db $70
L015DCD: db $70
L015DCE: db $35
L015DCF: db $36
L015DD0: db $37
L015DD1: db $38
L015DD2: db $39
L015DD3: db $30
L015DD4: db $31
L015DD5: db $32
L015DD6: db $33
L015DD7: db $70
L015DD8: db $70
L015DD9: db $70
L015DDA: db $70
L015DDB: db $70
L015DDC: db $70
L015DDD: db $9A
L015DDE: db $00
L015DDF: db $14
L015DE0: db $70
L015DE1: db $70
L015DE2: db $70
L015DE3: db $70
L015DE4: db $70
L015DE5: db $70
L015DE6: db $70
L015DE7: db $70
L015DE8: db $70
L015DE9: db $49
L015DEA: db $40
L015DEB: db $41
L015DEC: db $42
L015DED: db $43
L015DEE: db $44
L015DEF: db $70
L015DF0: db $70
L015DF1: db $70
L015DF2: db $70
L015DF3: db $70
L015DF4: db $9A
L015DF5: db $20
L015DF6: db $14
L015DF7: db $70
L015DF8: db $70
L015DF9: db $70
L015DFA: db $70
L015DFB: db $70
L015DFC: db $70
L015DFD: db $70
L015DFE: db $70
L015DFF: db $70
L015E00: db $70
L015E01: db $50
L015E02: db $51
L015E03: db $52
L015E04: db $53
L015E05: db $54
L015E06: db $55
L015E07: db $70
L015E08: db $70
L015E09: db $70
L015E0A: db $70
L015E0B: db $00
L015E0C: db $98
L015E0D: db $1F
L015E0E: db $92
L015E0F: db $70
L015E10: db $70
L015E11: db $70
L015E12: db $70
L015E13: db $0B
L015E14: db $70
L015E15: db $70
L015E16: db $70
L015E17: db $70
L015E18: db $70
L015E19: db $70
L015E1A: db $70
L015E1B: db $70
L015E1C: db $0A
L015E1D: db $70
L015E1E: db $70
L015E1F: db $70
L015E20: db $70
L015E21: db $98
L015E22: db $1E
L015E23: db $92
L015E24: db $70
L015E25: db $70
L015E26: db $70
L015E27: db $70
L015E28: db $70
L015E29: db $70
L015E2A: db $70
L015E2B: db $70
L015E2C: db $70
L015E2D: db $70
L015E2E: db $70
L015E2F: db $70
L015E30: db $0B
L015E31: db $70
L015E32: db $70
L015E33: db $70
L015E34: db $70
L015E35: db $70
L015E36: db $98
L015E37: db $1D
L015E38: db $92
L015E39: db $0B
L015E3A: db $70
L015E3B: db $70
L015E3C: db $70
L015E3D: db $70
L015E3E: db $09
L015E3F: db $70
L015E40: db $70
L015E41: db $70
L015E42: db $70
L015E43: db $70
L015E44: db $70
L015E45: db $70
L015E46: db $70
L015E47: db $70
L015E48: db $70
L015E49: db $70
L015E4A: db $70
L015E4B: db $98
L015E4C: db $1C
L015E4D: db $92
L015E4E: db $70
L015E4F: db $70
L015E50: db $70
L015E51: db $70
L015E52: db $70
L015E53: db $70
L015E54: db $70
L015E55: db $70
L015E56: db $70
L015E57: db $70
L015E58: db $70
L015E59: db $70
L015E5A: db $70
L015E5B: db $70
L015E5C: db $70
L015E5D: db $70
L015E5E: db $70
L015E5F: db $70
L015E60: db $98
L015E61: db $1B
L015E62: db $92
L015E63: db $70
L015E64: db $70
L015E65: db $70
L015E66: db $70
L015E67: db $70
L015E68: db $70
L015E69: db $0B
L015E6A: db $70
L015E6B: db $70
L015E6C: db $70
L015E6D: db $70
L015E6E: db $70
L015E6F: db $70
L015E70: db $70
L015E71: db $70
L015E72: db $70
L015E73: db $0B
L015E74: db $70
L015E75: db $98
L015E76: db $1A
L015E77: db $92
L015E78: db $70
L015E79: db $70
L015E7A: db $70
L015E7B: db $70
L015E7C: db $70
L015E7D: db $70
L015E7E: db $70
L015E7F: db $70
L015E80: db $70
L015E81: db $70
L015E82: db $70
L015E83: db $70
L015E84: db $70
L015E85: db $70
L015E86: db $70
L015E87: db $70
L015E88: db $70
L015E89: db $70
L015E8A: db $98
L015E8B: db $19
L015E8C: db $92
L015E8D: db $0B
L015E8E: db $70
L015E8F: db $0B
L015E90: db $70
L015E91: db $70
L015E92: db $70
L015E93: db $70
L015E94: db $70
L015E95: db $70
L015E96: db $70
L015E97: db $0B
L015E98: db $70
L015E99: db $70
L015E9A: db $70
L015E9B: db $70
L015E9C: db $70
L015E9D: db $70
L015E9E: db $70
L015E9F: db $98
L015EA0: db $18
L015EA1: db $92
L015EA2: db $70
L015EA3: db $70
L015EA4: db $70
L015EA5: db $70
L015EA6: db $70
L015EA7: db $70
L015EA8: db $70
L015EA9: db $70
L015EAA: db $70
L015EAB: db $70
L015EAC: db $70
L015EAD: db $70
L015EAE: db $70
L015EAF: db $70
L015EB0: db $70
L015EB1: db $70
L015EB2: db $70
L015EB3: db $70
L015EB4: db $98
L015EB5: db $17
L015EB6: db $92
L015EB7: db $70
L015EB8: db $70
L015EB9: db $70
L015EBA: db $70
L015EBB: db $70
L015EBC: db $70
L015EBD: db $0B
L015EBE: db $70
L015EBF: db $70
L015EC0: db $70
L015EC1: db $70
L015EC2: db $70
L015EC3: db $70
L015EC4: db $09
L015EC5: db $70
L015EC6: db $70
L015EC7: db $70
L015EC8: db $70
L015EC9: db $98
L015ECA: db $16
L015ECB: db $92
L015ECC: db $70
L015ECD: db $70
L015ECE: db $70
L015ECF: db $70
L015ED0: db $70
L015ED1: db $70
L015ED2: db $70
L015ED3: db $70
L015ED4: db $70
L015ED5: db $70
L015ED6: db $70
L015ED7: db $70
L015ED8: db $70
L015ED9: db $70
L015EDA: db $70
L015EDB: db $70
L015EDC: db $70
L015EDD: db $70
L015EDE: db $98
L015EDF: db $15
L015EE0: db $92
L015EE1: db $70
L015EE2: db $70
L015EE3: db $70
L015EE4: db $70
L015EE5: db $70
L015EE6: db $70
L015EE7: db $70
L015EE8: db $70
L015EE9: db $70
L015EEA: db $09
L015EEB: db $70
L015EEC: db $70
L015EED: db $0B
L015EEE: db $70
L015EEF: db $70
L015EF0: db $70
L015EF1: db $70
L015EF2: db $70
L015EF3: db $98
L015EF4: db $14
L015EF5: db $92
L015EF6: db $70
L015EF7: db $70
L015EF8: db $70
L015EF9: db $70
L015EFA: db $70
L015EFB: db $70
L015EFC: db $70
L015EFD: db $70
L015EFE: db $70
L015EFF: db $70
L015F00: db $70
L015F01: db $70
L015F02: db $70
L015F03: db $70
L015F04: db $70
L015F05: db $70
L015F06: db $70
L015F07: db $70
L015F08: db $98
L015F09: db $13
L015F0A: db $92
L015F0B: db $70
L015F0C: db $09
L015F0D: db $70
L015F0E: db $70
L015F0F: db $70
L015F10: db $70
L015F11: db $70
L015F12: db $70
L015F13: db $70
L015F14: db $70
L015F15: db $70
L015F16: db $70
L015F17: db $70
L015F18: db $70
L015F19: db $70
L015F1A: db $70
L015F1B: db $70
L015F1C: db $70
L015F1D: db $98
L015F1E: db $12
L015F1F: db $92
L015F20: db $70
L015F21: db $70
L015F22: db $70
L015F23: db $70
L015F24: db $70
L015F25: db $70
L015F26: db $70
L015F27: db $70
L015F28: db $70
L015F29: db $70
L015F2A: db $70
L015F2B: db $70
L015F2C: db $70
L015F2D: db $70
L015F2E: db $70
L015F2F: db $70
L015F30: db $70
L015F31: db $70
L015F32: db $98
L015F33: db $11
L015F34: db $92
L015F35: db $70
L015F36: db $70
L015F37: db $70
L015F38: db $70
L015F39: db $70
L015F3A: db $70
L015F3B: db $0B
L015F3C: db $70
L015F3D: db $70
L015F3E: db $70
L015F3F: db $70
L015F40: db $70
L015F41: db $70
L015F42: db $0A
L015F43: db $0B
L015F44: db $70
L015F45: db $70
L015F46: db $70
L015F47: db $98
L015F48: db $10
L015F49: db $92
L015F4A: db $70
L015F4B: db $70
L015F4C: db $70
L015F4D: db $70
L015F4E: db $70
L015F4F: db $70
L015F50: db $70
L015F51: db $70
L015F52: db $70
L015F53: db $70
L015F54: db $70
L015F55: db $70
L015F56: db $0B
L015F57: db $70
L015F58: db $70
L015F59: db $70
L015F5A: db $70
L015F5B: db $70
L015F5C: db $00
L015F5D: db $9B
L015F5E: db $EA
L015F5F: db $0A
L015F60: db $70
L015F61: db $70
L015F62: db $70
L015F63: db $70
L015F64: db $70
L015F65: db $70
L015F66: db $0B
L015F67: db $70
L015F68: db $70
L015F69: db $70
L015F6A: db $9B
L015F6B: db $E0
L015F6C: db $0A
L015F6D: db $70
L015F6E: db $70
L015F6F: db $70
L015F70: db $70
L015F71: db $70
L015F72: db $0A
L015F73: db $70
L015F74: db $70
L015F75: db $70
L015F76: db $70
L015F77: db $9B
L015F78: db $CA
L015F79: db $0A
L015F7A: db $70
L015F7B: db $70
L015F7C: db $70
L015F7D: db $70
L015F7E: db $70
L015F7F: db $70
L015F80: db $70
L015F81: db $70
L015F82: db $70
L015F83: db $70
L015F84: db $9B
L015F85: db $C0
L015F86: db $0A
L015F87: db $70
L015F88: db $70
L015F89: db $70
L015F8A: db $70
L015F8B: db $0B
L015F8C: db $70
L015F8D: db $70
L015F8E: db $70
L015F8F: db $70
L015F90: db $70
L015F91: db $9B
L015F92: db $AA
L015F93: db $0A
L015F94: db $0B
L015F95: db $70
L015F96: db $70
L015F97: db $70
L015F98: db $70
L015F99: db $70
L015F9A: db $70
L015F9B: db $09
L015F9C: db $70
L015F9D: db $70
L015F9E: db $9B
L015F9F: db $A0
L015FA0: db $0A
L015FA1: db $70
L015FA2: db $70
L015FA3: db $70
L015FA4: db $70
L015FA5: db $70
L015FA6: db $70
L015FA7: db $70
L015FA8: db $70
L015FA9: db $70
L015FAA: db $70
L015FAB: db $9B
L015FAC: db $8A
L015FAD: db $0A
L015FAE: db $70
L015FAF: db $70
L015FB0: db $70
L015FB1: db $70
L015FB2: db $70
L015FB3: db $70
L015FB4: db $70
L015FB5: db $70
L015FB6: db $70
L015FB7: db $70
L015FB8: db $9B
L015FB9: db $80
L015FBA: db $0A
L015FBB: db $70
L015FBC: db $70
L015FBD: db $70
L015FBE: db $70
L015FBF: db $70
L015FC0: db $70
L015FC1: db $70
L015FC2: db $70
L015FC3: db $70
L015FC4: db $70
L015FC5: db $9B
L015FC6: db $6A
L015FC7: db $0A
L015FC8: db $70
L015FC9: db $70
L015FCA: db $70
L015FCB: db $70
L015FCC: db $70
L015FCD: db $70
L015FCE: db $70
L015FCF: db $70
L015FD0: db $0B
L015FD1: db $70
L015FD2: db $9B
L015FD3: db $60
L015FD4: db $0A
L015FD5: db $70
L015FD6: db $70
L015FD7: db $70
L015FD8: db $70
L015FD9: db $70
L015FDA: db $70
L015FDB: db $70
L015FDC: db $70
L015FDD: db $0B
L015FDE: db $70
L015FDF: db $9B
L015FE0: db $4A
L015FE1: db $0A
L015FE2: db $70
L015FE3: db $70
L015FE4: db $70
L015FE5: db $70
L015FE6: db $70
L015FE7: db $70
L015FE8: db $70
L015FE9: db $70
L015FEA: db $70
L015FEB: db $70
L015FEC: db $9B
L015FED: db $40
L015FEE: db $0A
L015FEF: db $70
L015FF0: db $70
L015FF1: db $70
L015FF2: db $70
L015FF3: db $70
L015FF4: db $70
L015FF5: db $70
L015FF6: db $70
L015FF7: db $70
L015FF8: db $70
L015FF9: db $9B
L015FFA: db $2A
L015FFB: db $0A
L015FFC: db $0B
L015FFD: db $70
L015FFE: db $0B
L015FFF: db $70
L016000: db $70
L016001: db $70
L016002: db $70
L016003: db $70
L016004: db $70
L016005: db $70
L016006: db $9B
L016007: db $20
L016008: db $0A
L016009: db $70
L01600A: db $70
L01600B: db $0B
L01600C: db $70
L01600D: db $70
L01600E: db $70
L01600F: db $70
L016010: db $70
L016011: db $70
L016012: db $70
L016013: db $9B
L016014: db $0A
L016015: db $0A
L016016: db $70
L016017: db $70
L016018: db $70
L016019: db $70
L01601A: db $70
L01601B: db $70
L01601C: db $70
L01601D: db $70
L01601E: db $70
L01601F: db $70
L016020: db $9B
L016021: db $00
L016022: db $0A
L016023: db $70
L016024: db $70
L016025: db $70
L016026: db $70
L016027: db $70
L016028: db $70
L016029: db $70
L01602A: db $70
L01602B: db $70
L01602C: db $70
L01602D: db $9A
L01602E: db $EA
L01602F: db $0A
L016030: db $70
L016031: db $70
L016032: db $70
L016033: db $70
L016034: db $70
L016035: db $70
L016036: db $0B
L016037: db $70
L016038: db $70
L016039: db $70
L01603A: db $9A
L01603B: db $E0
L01603C: db $0A
L01603D: db $70
L01603E: db $70
L01603F: db $70
L016040: db $70
L016041: db $70
L016042: db $09
L016043: db $70
L016044: db $70
L016045: db $70
L016046: db $70
L016047: db $9A
L016048: db $CA
L016049: db $0A
L01604A: db $70
L01604B: db $70
L01604C: db $70
L01604D: db $70
L01604E: db $70
L01604F: db $70
L016050: db $70
L016051: db $70
L016052: db $70
L016053: db $70
L016054: db $9A
L016055: db $C0
L016056: db $0A
L016057: db $70
L016058: db $70
L016059: db $70
L01605A: db $70
L01605B: db $70
L01605C: db $70
L01605D: db $70
L01605E: db $70
L01605F: db $70
L016060: db $70
L016061: db $9A
L016062: db $AA
L016063: db $0A
L016064: db $70
L016065: db $70
L016066: db $70
L016067: db $70
L016068: db $70
L016069: db $70
L01606A: db $70
L01606B: db $70
L01606C: db $70
L01606D: db $09
L01606E: db $9A
L01606F: db $A0
L016070: db $0A
L016071: db $70
L016072: db $70
L016073: db $70
L016074: db $70
L016075: db $0B
L016076: db $70
L016077: db $70
L016078: db $70
L016079: db $70
L01607A: db $70
L01607B: db $9A
L01607C: db $8A
L01607D: db $0A
L01607E: db $70
L01607F: db $70
L016080: db $70
L016081: db $70
L016082: db $70
L016083: db $70
L016084: db $70
L016085: db $70
L016086: db $70
L016087: db $70
L016088: db $9A
L016089: db $80
L01608A: db $0A
L01608B: db $70
L01608C: db $70
L01608D: db $70
L01608E: db $70
L01608F: db $70
L016090: db $70
L016091: db $70
L016092: db $70
L016093: db $70
L016094: db $70
L016095: db $9A
L016096: db $6A
L016097: db $0A
L016098: db $70
L016099: db $09
L01609A: db $70
L01609B: db $70
L01609C: db $70
L01609D: db $70
L01609E: db $70
L01609F: db $70
L0160A0: db $70
L0160A1: db $70
L0160A2: db $9A
L0160A3: db $60
L0160A4: db $0A
L0160A5: db $70
L0160A6: db $70
L0160A7: db $70
L0160A8: db $70
L0160A9: db $70
L0160AA: db $70
L0160AB: db $70
L0160AC: db $70
L0160AD: db $70
L0160AE: db $70
L0160AF: db $9A
L0160B0: db $4A
L0160B1: db $0A
L0160B2: db $70
L0160B3: db $70
L0160B4: db $70
L0160B5: db $70
L0160B6: db $70
L0160B7: db $70
L0160B8: db $70
L0160B9: db $70
L0160BA: db $70
L0160BB: db $70
L0160BC: db $9A
L0160BD: db $40
L0160BE: db $0A
L0160BF: db $70
L0160C0: db $70
L0160C1: db $70
L0160C2: db $70
L0160C3: db $70
L0160C4: db $70
L0160C5: db $70
L0160C6: db $70
L0160C7: db $70
L0160C8: db $70
L0160C9: db $9A
L0160CA: db $2A
L0160CB: db $0A
L0160CC: db $70
L0160CD: db $70
L0160CE: db $70
L0160CF: db $70
L0160D0: db $70
L0160D1: db $70
L0160D2: db $0B
L0160D3: db $70
L0160D4: db $70
L0160D5: db $70
L0160D6: db $9A
L0160D7: db $20
L0160D8: db $0A
L0160D9: db $70
L0160DA: db $70
L0160DB: db $70
L0160DC: db $70
L0160DD: db $70
L0160DE: db $0A
L0160DF: db $0B
L0160E0: db $70
L0160E1: db $70
L0160E2: db $70
L0160E3: db $9A
L0160E4: db $0A
L0160E5: db $0A
L0160E6: db $70
L0160E7: db $70
L0160E8: db $70
L0160E9: db $70
L0160EA: db $70
L0160EB: db $70
L0160EC: db $70
L0160ED: db $70
L0160EE: db $70
L0160EF: db $70
L0160F0: db $9A
L0160F1: db $00
L0160F2: db $0A
L0160F3: db $70
L0160F4: db $70
L0160F5: db $70
L0160F6: db $70
L0160F7: db $0B
L0160F8: db $70
L0160F9: db $70
L0160FA: db $70
L0160FB: db $70
L0160FC: db $70
L0160FD: db $99
L0160FE: db $EA
L0160FF: db $0A
L016100: db $70
L016101: db $70
L016102: db $70
L016103: db $70
L016104: db $70
L016105: db $70
L016106: db $0B
L016107: db $70
L016108: db $70
L016109: db $70
L01610A: db $99
L01610B: db $E0
L01610C: db $0A
L01610D: db $70
L01610E: db $70
L01610F: db $70
L016110: db $70
L016111: db $70
L016112: db $09
L016113: db $70
L016114: db $70
L016115: db $70
L016116: db $70
L016117: db $99
L016118: db $CA
L016119: db $0A
L01611A: db $70
L01611B: db $70
L01611C: db $70
L01611D: db $70
L01611E: db $70
L01611F: db $70
L016120: db $70
L016121: db $70
L016122: db $70
L016123: db $70
L016124: db $99
L016125: db $C0
L016126: db $0A
L016127: db $70
L016128: db $70
L016129: db $70
L01612A: db $70
L01612B: db $70
L01612C: db $70
L01612D: db $70
L01612E: db $70
L01612F: db $70
L016130: db $70
L016131: db $99
L016132: db $AA
L016133: db $0A
L016134: db $70
L016135: db $70
L016136: db $70
L016137: db $70
L016138: db $70
L016139: db $70
L01613A: db $70
L01613B: db $70
L01613C: db $70
L01613D: db $09
L01613E: db $99
L01613F: db $A0
L016140: db $0A
L016141: db $70
L016142: db $70
L016143: db $70
L016144: db $70
L016145: db $0B
L016146: db $70
L016147: db $70
L016148: db $70
L016149: db $70
L01614A: db $70
L01614B: db $99
L01614C: db $8A
L01614D: db $0A
L01614E: db $70
L01614F: db $70
L016150: db $70
L016151: db $70
L016152: db $70
L016153: db $70
L016154: db $70
L016155: db $70
L016156: db $70
L016157: db $70
L016158: db $99
L016159: db $80
L01615A: db $0A
L01615B: db $70
L01615C: db $70
L01615D: db $70
L01615E: db $70
L01615F: db $70
L016160: db $70
L016161: db $70
L016162: db $70
L016163: db $70
L016164: db $70
L016165: db $00
L016166: db $00;X
L016167: db $98
L016168: db $03
L016169: db $0D
L01616A: db $40
L01616B: db $40
L01616C: db $54
L01616D: db $48
L01616E: db $41
L01616F: db $4E
L016170: db $4B
L016171: db $40
L016172: db $59
L016173: db $4F
L016174: db $55
L016175: db $40
L016176: db $40
L016177: db $98
L016178: db $43
L016179: db $0D
L01617A: db $40
L01617B: db $46
L01617C: db $4F
L01617D: db $52
L01617E: db $40
L01617F: db $50
L016180: db $4C
L016181: db $41
L016182: db $59
L016183: db $49
L016184: db $4E
L016185: db $47
L016186: db $40
L016187: db $98
L016188: db $A3
L016189: db $0D
L01618A: db $40
L01618B: db $40
L01618C: db $50
L01618D: db $52
L01618E: db $45
L01618F: db $53
L016190: db $45
L016191: db $4E
L016192: db $54
L016193: db $45
L016194: db $44
L016195: db $40
L016196: db $40
L016197: db $98
L016198: db $E3
L016199: db $0D
L01619A: db $40
L01619B: db $40
L01619C: db $40
L01619D: db $40
L01619E: db $40
L01619F: db $42
L0161A0: db $59
L0161A1: db $40
L0161A2: db $40
L0161A3: db $40
L0161A4: db $40
L0161A5: db $40
L0161A6: db $40
L0161A7: db $99
L0161A8: db $00
L0161A9: db $0D
L0161AA: db $70
L0161AB: db $70
L0161AC: db $70
L0161AD: db $70
L0161AE: db $70
L0161AF: db $70
L0161B0: db $70
L0161B1: db $70
L0161B2: db $70
L0161B3: db $70
L0161B4: db $70
L0161B5: db $70
L0161B6: db $70
L0161B7: db $99
L0161B8: db $20
L0161B9: db $0D
L0161BA: db $70
L0161BB: db $70
L0161BC: db $70
L0161BD: db $70
L0161BE: db $70
L0161BF: db $70
L0161C0: db $70
L0161C1: db $70
L0161C2: db $70
L0161C3: db $70
L0161C4: db $70
L0161C5: db $70
L0161C6: db $70
L0161C7: db $99
L0161C8: db $40
L0161C9: db $0D
L0161CA: db $70
L0161CB: db $70
L0161CC: db $70
L0161CD: db $70
L0161CE: db $70
L0161CF: db $70
L0161D0: db $70
L0161D1: db $70
L0161D2: db $70
L0161D3: db $70
L0161D4: db $70
L0161D5: db $70
L0161D6: db $70
L0161D7: db $99
L0161D8: db $60
L0161D9: db $0D
L0161DA: db $70
L0161DB: db $70
L0161DC: db $70
L0161DD: db $70
L0161DE: db $70
L0161DF: db $70
L0161E0: db $70
L0161E1: db $70
L0161E2: db $70
L0161E3: db $70
L0161E4: db $70
L0161E5: db $70
L0161E6: db $70
L0161E7: db $9B
L0161E8: db $03
L0161E9: db $0D
L0161EA: db $20
L0161EB: db $21
L0161EC: db $22
L0161ED: db $23
L0161EE: db $24
L0161EF: db $25
L0161F0: db $26
L0161F1: db $27
L0161F2: db $28
L0161F3: db $29
L0161F4: db $2A
L0161F5: db $2B
L0161F6: db $2C
L0161F7: db $9B
L0161F8: db $23
L0161F9: db $0D
L0161FA: db $30
L0161FB: db $31
L0161FC: db $32
L0161FD: db $33
L0161FE: db $34
L0161FF: db $35
L016200: db $36
L016201: db $37
L016202: db $38
L016203: db $39
L016204: db $3A
L016205: db $3B
L016206: db $3C
L016207: db $98
L016208: db $03
L016209: db $0D
L01620A: db $70
L01620B: db $70
L01620C: db $70
L01620D: db $70
L01620E: db $70
L01620F: db $70
L016210: db $70
L016211: db $70
L016212: db $70
L016213: db $70
L016214: db $70
L016215: db $70
L016216: db $70
L016217: db $00
L016218: db $09
L016219: db $30
L01621A: db $3E
L01621B: db $09
L01621C: db $88
L01621D: db $3F
L01621E: db $F9
L01621F: db $58
L016220: db $3F
L016221: db $F9
L016222: db $90
L016223: db $3D
L016224: db $E9
L016225: db $48
L016226: db $3F
L016227: db $E9
L016228: db $98
L016229: db $3F
L01622A: db $D9
L01622B: db $18
L01622C: db $3F
L01622D: db $D9
L01622E: db $68
L01622F: db $3F
L016230: db $C9
L016231: db $30
L016232: db $3D
L016233: db $C9
L016234: db $88
L016235: db $3F
L016236: db $B9
L016237: db $28
L016238: db $3F
L016239: db $B9
L01623A: db $A0
L01623B: db $3D
L01623C: db $A9
L01623D: db $60
L01623E: db $3D
L01623F: db $99
L016240: db $30
L016241: db $3E
L016242: db $99
L016243: db $88
L016244: db $3F
L016245: db $91
L016246: db $28
L016247: db $3F
L016248: db $89
L016249: db $30
L01624A: db $3D
L01624B: db $79
L01624C: db $28
L01624D: db $3F
L01624E: db $79
L01624F: db $A0
L016250: db $3D
L016251: db $61
L016252: db $88
L016253: db $3F
L016254: db $51
L016255: db $50
L016256: db $3E
L016257: db $51
L016258: db $80
L016259: db $3D
L01625A: db $51
L01625B: db $90
L01625C: db $3E
L01625D: db $41
L01625E: db $28
L01625F: db $3F
L016260: db $31
L016261: db $60
L016262: db $3D
L016263: db $21
L016264: db $30
L016265: db $3E
L016266: db $21;X
L016267: db $90;X
L016268: db $3E;X
L016269: db $11;X
L01626A: db $08;X
L01626B: db $3D;X
L01626C: db $11;X
L01626D: db $08;X
L01626E: db $3D;X
L01626F: db $11;X
L016270: db $08;X
L016271: db $3D;X
L016272: db $11;X
L016273: db $08;X
L016274: db $3D;X
L016275: db $B4;X
L016276: db $62;X
L016277: db $B9;X
L016278: db $62;X
L016279: db $BE
L01627A: db $62
L01627B: db $C7;X
L01627C: db $62;X
L01627D: db $E0
L01627E: db $62
L01627F: db $09
L016280: db $63
L016281: db $84
L016282: db $63
L016283: db $B5
L016284: db $63
L016285: db $32
L016286: db $63
L016287: db $5B
L016288: db $63
L016289: db $00
L01628A: db $64
L01628B: db $00
L01628C: db $64
L01628D: db $E6
L01628E: db $63
L01628F: db $F3
L016290: db $63
L016291: db $25
L016292: db $64
L016293: db $2E
L016294: db $64
L016295: db $37
L016296: db $64
L016297: db $3C
L016298: db $64
L016299: db $49
L01629A: db $64
L01629B: db $56
L01629C: db $64
L01629D: db $67
L01629E: db $64
L01629F: db $88
L0162A0: db $64
L0162A1: db $AD
L0162A2: db $64
L0162A3: db $DE
L0162A4: db $64
L0162A5: db $33
L0162A6: db $65
L0162A7: db $38
L0162A8: db $65
L0162A9: db $49
L0162AA: db $65
L0162AB: db $33;X
L0162AC: db $65;X
L0162AD: db $38
L0162AE: db $65
L0162AF: db $49;X
L0162B0: db $65;X
L0162B1: db $66
L0162B2: db $65
L0162B3: db $00;X
L0162B4: db $01;X
L0162B5: db $F9;X
L0162B6: db $FD;X
L0162B7: db $48;X
L0162B8: db $00;X
L0162B9: db $01;X
L0162BA: db $F9;X
L0162BB: db $FC;X
L0162BC: db $49;X
L0162BD: db $00;X
L0162BE: db $02
L0162BF: db $F9
L0162C0: db $F9
L0162C1: db $4A
L0162C2: db $00
L0162C3: db $F9
L0162C4: db $01
L0162C5: db $4B
L0162C6: db $00
L0162C7: db $06;X
L0162C8: db $F1;X
L0162C9: db $F9;X
L0162CA: db $4C;X
L0162CB: db $00;X
L0162CC: db $F1;X
L0162CD: db $00;X
L0162CE: db $4D;X
L0162CF: db $00;X
L0162D0: db $F9;X
L0162D1: db $F0;X
L0162D2: db $58;X
L0162D3: db $00;X
L0162D4: db $F9;X
L0162D5: db $F8;X
L0162D6: db $59;X
L0162D7: db $00;X
L0162D8: db $F9;X
L0162D9: db $00;X
L0162DA: db $5A;X
L0162DB: db $00;X
L0162DC: db $F9;X
L0162DD: db $08;X
L0162DE: db $5B;X
L0162DF: db $00;X
L0162E0: db $0A
L0162E1: db $E9
L0162E2: db $F7
L0162E3: db $A7
L0162E4: db $20
L0162E5: db $E9
L0162E6: db $FF
L0162E7: db $A6
L0162E8: db $20
L0162E9: db $F1
L0162EA: db $F0
L0162EB: db $AB
L0162EC: db $20
L0162ED: db $F1
L0162EE: db $F8
L0162EF: db $AA
L0162F0: db $20
L0162F1: db $F1
L0162F2: db $00
L0162F3: db $A9
L0162F4: db $20
L0162F5: db $F1
L0162F6: db $08
L0162F7: db $A8
L0162F8: db $20
L0162F9: db $F9
L0162FA: db $F0
L0162FB: db $AF
L0162FC: db $20
L0162FD: db $F9
L0162FE: db $F8
L0162FF: db $AE
L016300: db $20
L016301: db $F9
L016302: db $00
L016303: db $AD
L016304: db $20
L016305: db $F9
L016306: db $08
L016307: db $AC
L016308: db $20
L016309: db $0A
L01630A: db $E9
L01630B: db $F7
L01630C: db $A7
L01630D: db $20
L01630E: db $E9
L01630F: db $FF
L016310: db $A6
L016311: db $20
L016312: db $F1
L016313: db $F0
L016314: db $AB
L016315: db $20
L016316: db $F1
L016317: db $F8
L016318: db $AA
L016319: db $20
L01631A: db $F1
L01631B: db $00
L01631C: db $A9
L01631D: db $20
L01631E: db $F1
L01631F: db $08
L016320: db $A8
L016321: db $20
L016322: db $F9
L016323: db $F0
L016324: db $AF
L016325: db $20
L016326: db $F9
L016327: db $F8
L016328: db $AE
L016329: db $20
L01632A: db $F9
L01632B: db $00
L01632C: db $AD
L01632D: db $20
L01632E: db $F9
L01632F: db $08
L016330: db $AC
L016331: db $20
L016332: db $0A
L016333: db $E9
L016334: db $F9
L016335: db $A6
L016336: db $00
L016337: db $E9
L016338: db $01
L016339: db $A7
L01633A: db $00
L01633B: db $F1
L01633C: db $F0
L01633D: db $A8
L01633E: db $00
L01633F: db $F1
L016340: db $F8
L016341: db $A9
L016342: db $00
L016343: db $F1
L016344: db $00
L016345: db $AA
L016346: db $00
L016347: db $F1
L016348: db $08
L016349: db $AB
L01634A: db $00
L01634B: db $F9
L01634C: db $F0
L01634D: db $AC
L01634E: db $00
L01634F: db $F9
L016350: db $F8
L016351: db $AD
L016352: db $00
L016353: db $F9
L016354: db $00
L016355: db $AE
L016356: db $00
L016357: db $F9
L016358: db $08
L016359: db $AF
L01635A: db $00
L01635B: db $0A
L01635C: db $E9
L01635D: db $F9
L01635E: db $A6
L01635F: db $00
L016360: db $E9
L016361: db $01
L016362: db $A7
L016363: db $00
L016364: db $F1
L016365: db $F0
L016366: db $A8
L016367: db $00
L016368: db $F1
L016369: db $F8
L01636A: db $A9
L01636B: db $00
L01636C: db $F1
L01636D: db $00
L01636E: db $AA
L01636F: db $00
L016370: db $F1
L016371: db $08
L016372: db $AB
L016373: db $00
L016374: db $F9
L016375: db $F0
L016376: db $AC
L016377: db $00
L016378: db $F9
L016379: db $F8
L01637A: db $AD
L01637B: db $00
L01637C: db $F9
L01637D: db $00
L01637E: db $AE
L01637F: db $00
L016380: db $F9
L016381: db $08
L016382: db $AF
L016383: db $00
L016384: db $0C
L016385: db $E9
L016386: db $F4
L016387: db $01
L016388: db $00
L016389: db $E9
L01638A: db $FC
L01638B: db $02
L01638C: db $00
L01638D: db $E9
L01638E: db $04
L01638F: db $03
L016390: db $00
L016391: db $F1
L016392: db $EC
L016393: db $10
L016394: db $00
L016395: db $F1
L016396: db $F4
L016397: db $11
L016398: db $00
L016399: db $F1
L01639A: db $FC
L01639B: db $12
L01639C: db $00
L01639D: db $F1
L01639E: db $04
L01639F: db $13
L0163A0: db $00
L0163A1: db $F9
L0163A2: db $EC
L0163A3: db $20
L0163A4: db $00
L0163A5: db $F9
L0163A6: db $F4
L0163A7: db $21
L0163A8: db $00
L0163A9: db $F9
L0163AA: db $FC
L0163AB: db $22
L0163AC: db $00
L0163AD: db $F9
L0163AE: db $04
L0163AF: db $23
L0163B0: db $00
L0163B1: db $F9
L0163B2: db $0C
L0163B3: db $24
L0163B4: db $00
L0163B5: db $0C
L0163B6: db $E9
L0163B7: db $F4
L0163B8: db $01
L0163B9: db $00
L0163BA: db $E9
L0163BB: db $FC
L0163BC: db $02
L0163BD: db $00
L0163BE: db $E9
L0163BF: db $04
L0163C0: db $03
L0163C1: db $00
L0163C2: db $F1
L0163C3: db $EC
L0163C4: db $10
L0163C5: db $00
L0163C6: db $F1
L0163C7: db $F4
L0163C8: db $11
L0163C9: db $00
L0163CA: db $F1
L0163CB: db $FC
L0163CC: db $12
L0163CD: db $00
L0163CE: db $F1
L0163CF: db $04
L0163D0: db $13
L0163D1: db $00
L0163D2: db $F9
L0163D3: db $EC
L0163D4: db $20
L0163D5: db $00
L0163D6: db $F9
L0163D7: db $F4
L0163D8: db $21
L0163D9: db $00
L0163DA: db $F9
L0163DB: db $FC
L0163DC: db $32
L0163DD: db $00
L0163DE: db $F9
L0163DF: db $04
L0163E0: db $33
L0163E1: db $00
L0163E2: db $F9
L0163E3: db $0C
L0163E4: db $24
L0163E5: db $00
L0163E6: db $03
L0163E7: db $F9
L0163E8: db $F4
L0163E9: db $78
L0163EA: db $00
L0163EB: db $F9
L0163EC: db $FC
L0163ED: db $79
L0163EE: db $00
L0163EF: db $F9
L0163F0: db $04
L0163F1: db $7A
L0163F2: db $00
L0163F3: db $03
L0163F4: db $F9
L0163F5: db $F4
L0163F6: db $78
L0163F7: db $00
L0163F8: db $F9
L0163F9: db $FC
L0163FA: db $79
L0163FB: db $00
L0163FC: db $F9
L0163FD: db $04
L0163FE: db $6A
L0163FF: db $00
L016400: db $09
L016401: db $E1
L016402: db $F8
L016403: db $4E
L016404: db $00
L016405: db $E9
L016406: db $F8
L016407: db $5E
L016408: db $00
L016409: db $E9
L01640A: db $00
L01640B: db $5F
L01640C: db $00
L01640D: db $F1
L01640E: db $F0
L01640F: db $6D
L016410: db $00
L016411: db $F1
L016412: db $F8
L016413: db $6E
L016414: db $00
L016415: db $F1
L016416: db $00
L016417: db $6F
L016418: db $00
L016419: db $F9
L01641A: db $F0
L01641B: db $7D
L01641C: db $00
L01641D: db $F9
L01641E: db $F8
L01641F: db $7E
L016420: db $00
L016421: db $F9
L016422: db $00
L016423: db $7F
L016424: db $00
L016425: db $02
L016426: db $F9
L016427: db $00
L016428: db $56
L016429: db $00
L01642A: db $F9
L01642B: db $08
L01642C: db $57
L01642D: db $00
L01642E: db $02
L01642F: db $F9
L016430: db $00
L016431: db $66
L016432: db $00
L016433: db $F9
L016434: db $08
L016435: db $67
L016436: db $00
L016437: db $01
L016438: db $F9
L016439: db $00
L01643A: db $55
L01643B: db $00
L01643C: db $03
L01643D: db $F1
L01643E: db $00
L01643F: db $65
L016440: db $00
L016441: db $F9
L016442: db $00
L016443: db $75
L016444: db $00
L016445: db $F9
L016446: db $08
L016447: db $76
L016448: db $00
L016449: db $03
L01644A: db $F1
L01644B: db $00
L01644C: db $43
L01644D: db $00
L01644E: db $F9
L01644F: db $00
L016450: db $53
L016451: db $00
L016452: db $F9
L016453: db $08
L016454: db $54
L016455: db $00
L016456: db $04
L016457: db $F1
L016458: db $00
L016459: db $63
L01645A: db $00
L01645B: db $F1
L01645C: db $08
L01645D: db $64
L01645E: db $00
L01645F: db $F9
L016460: db $00
L016461: db $73
L016462: db $00
L016463: db $F9
L016464: db $08
L016465: db $74
L016466: db $00
L016467: db $08
L016468: db $E9
L016469: db $00
L01646A: db $50
L01646B: db $00
L01646C: db $E9
L01646D: db $08
L01646E: db $51
L01646F: db $00
L016470: db $F1
L016471: db $00
L016472: db $60
L016473: db $00
L016474: db $F1
L016475: db $08
L016476: db $61
L016477: db $00
L016478: db $F1
L016479: db $10
L01647A: db $62
L01647B: db $00
L01647C: db $F9
L01647D: db $00
L01647E: db $70
L01647F: db $00
L016480: db $F9
L016481: db $08
L016482: db $71
L016483: db $00
L016484: db $F9
L016485: db $10
L016486: db $72
L016487: db $00
L016488: db $09
L016489: db $E9
L01648A: db $00
L01648B: db $0D
L01648C: db $00
L01648D: db $E9
L01648E: db $08
L01648F: db $0E
L016490: db $00
L016491: db $E9
L016492: db $10
L016493: db $0F
L016494: db $00
L016495: db $F1
L016496: db $00
L016497: db $1D
L016498: db $00
L016499: db $F1
L01649A: db $08
L01649B: db $1E
L01649C: db $00
L01649D: db $F1
L01649E: db $10
L01649F: db $1F
L0164A0: db $00
L0164A1: db $F9
L0164A2: db $00
L0164A3: db $2D
L0164A4: db $00
L0164A5: db $F9
L0164A6: db $08
L0164A7: db $2E
L0164A8: db $00
L0164A9: db $F9
L0164AA: db $10
L0164AB: db $2F
L0164AC: db $00
L0164AD: db $0C
L0164AE: db $E1
L0164AF: db $08
L0164B0: db $0A
L0164B1: db $00
L0164B2: db $E1
L0164B3: db $10
L0164B4: db $0B
L0164B5: db $00
L0164B6: db $E1
L0164B7: db $18
L0164B8: db $0C
L0164B9: db $00
L0164BA: db $E9
L0164BB: db $08
L0164BC: db $1A
L0164BD: db $00
L0164BE: db $E9
L0164BF: db $10
L0164C0: db $1B
L0164C1: db $00
L0164C2: db $E9
L0164C3: db $18
L0164C4: db $1C
L0164C5: db $00
L0164C6: db $F1
L0164C7: db $00
L0164C8: db $29
L0164C9: db $00
L0164CA: db $F1
L0164CB: db $08
L0164CC: db $2A
L0164CD: db $00
L0164CE: db $F1
L0164CF: db $10
L0164D0: db $2B
L0164D1: db $00
L0164D2: db $F1
L0164D3: db $18
L0164D4: db $2C
L0164D5: db $00
L0164D6: db $F9
L0164D7: db $08
L0164D8: db $3A
L0164D9: db $00
L0164DA: db $F9
L0164DB: db $10
L0164DC: db $3B
L0164DD: db $00
L0164DE: db $15
L0164DF: db $D9
L0164E0: db $08
L0164E1: db $05
L0164E2: db $00
L0164E3: db $D9
L0164E4: db $10
L0164E5: db $06
L0164E6: db $00
L0164E7: db $D9
L0164E8: db $18
L0164E9: db $07
L0164EA: db $00
L0164EB: db $D9
L0164EC: db $20
L0164ED: db $08
L0164EE: db $00
L0164EF: db $E1
L0164F0: db $08
L0164F1: db $15
L0164F2: db $00
L0164F3: db $E1
L0164F4: db $10
L0164F5: db $16
L0164F6: db $00
L0164F7: db $E1
L0164F8: db $18
L0164F9: db $17
L0164FA: db $00
L0164FB: db $E1
L0164FC: db $20
L0164FD: db $18
L0164FE: db $00
L0164FF: db $E1
L016500: db $28
L016501: db $19
L016502: db $00
L016503: db $E9
L016504: db $08
L016505: db $25
L016506: db $00
L016507: db $E9
L016508: db $10
L016509: db $26
L01650A: db $00
L01650B: db $E9
L01650C: db $18
L01650D: db $27
L01650E: db $00
L01650F: db $E9
L016510: db $20
L016511: db $28
L016512: db $00
L016513: db $E9
L016514: db $28
L016515: db $09
L016516: db $00
L016517: db $F1
L016518: db $00
L016519: db $34
L01651A: db $00
L01651B: db $F1
L01651C: db $08
L01651D: db $35
L01651E: db $00
L01651F: db $F1
L016520: db $10
L016521: db $36
L016522: db $00
L016523: db $F1
L016524: db $18
L016525: db $37
L016526: db $00
L016527: db $F1
L016528: db $20
L016529: db $38
L01652A: db $00
L01652B: db $F9
L01652C: db $08
L01652D: db $45
L01652E: db $00
L01652F: db $F9
L016530: db $10
L016531: db $46
L016532: db $00
L016533: db $01
L016534: db $FC
L016535: db $FC
L016536: db $50
L016537: db $00
L016538: db $04
L016539: db $F8
L01653A: db $F8
L01653B: db $51
L01653C: db $00
L01653D: db $F8
L01653E: db $00
L01653F: db $52
L016540: db $00
L016541: db $00
L016542: db $F8
L016543: db $52
L016544: db $60
L016545: db $00
L016546: db $00
L016547: db $51
L016548: db $60
L016549: db $07
L01654A: db $F4
L01654B: db $F8
L01654C: db $53
L01654D: db $00
L01654E: db $F4
L01654F: db $00
L016550: db $54
L016551: db $00
L016552: db $FC
L016553: db $F4
L016554: db $55
L016555: db $00
L016556: db $FC
L016557: db $FC
L016558: db $56
L016559: db $00
L01655A: db $FC
L01655B: db $04
L01655C: db $55
L01655D: db $60
L01655E: db $04
L01655F: db $F8
L016560: db $54
L016561: db $60
L016562: db $04
L016563: db $00
L016564: db $53
L016565: db $60
L016566: db $0E
L016567: db $00
L016568: db $00
L016569: db $70
L01656A: db $00
L01656B: db $00
L01656C: db $08
L01656D: db $71
L01656E: db $00
L01656F: db $08
L016570: db $00
L016571: db $72
L016572: db $00
L016573: db $08
L016574: db $08
L016575: db $73
L016576: db $00
L016577: db $10
L016578: db $00
L016579: db $74
L01657A: db $00
L01657B: db $10
L01657C: db $08
L01657D: db $75
L01657E: db $00
L01657F: db $18
L016580: db $00
L016581: db $76
L016582: db $00
L016583: db $18
L016584: db $08
L016585: db $77
L016586: db $00
L016587: db $20
L016588: db $00
L016589: db $78
L01658A: db $00
L01658B: db $20
L01658C: db $08
L01658D: db $79
L01658E: db $00
L01658F: db $28
L016590: db $02
L016591: db $7A
L016592: db $00
L016593: db $28
L016594: db $0A
L016595: db $7B
L016596: db $00
L016597: db $30
L016598: db $02
L016599: db $7C
L01659A: db $00
L01659B: db $30
L01659C: db $0A
L01659D: db $7D
L01659E: db $00
L01659F: db $02
L0165A0: db $02
L0165A1: db $02
L0165A2: db $02
L0165A3: db $02
L0165A4: db $07
L0165A5: db $04
L0165A6: db $04
L0165A7: db $05
L0165A8: db $05
L0165A9: db $05
L0165AA: db $05
L0165AB: db $07
L0165AC: db $07
L0165AD: db $07
L0165AE: db $09
L0165AF: db $09
L0165B0: db $09
L0165B1: db $09
L0165B2: db $0B
L0165B3: db $0B
L0165B4: db $0B
L0165B5: db $0D
L0165B6: db $0D
L0165B7: db $0D
L0165B8: db $0F
L0165B9: db $0F
L0165BA: db $0F
L0165BB: db $0F
L0165BC: db $0A
L0165BD: db $0C
L0165BE: db $0E
L0165BF: db $10
L0165C0: db $14
L0165C1: db $15
L0165C2: db $06
L0165C3: db $08
L0165C4: db $13
L0165C5: db $02;X
L0165C6: db $02;X
L0165C7: db $02;X
L0165C8: db $02;X
L0165C9: db $02;X
L0165CA: db $02;X
L0165CB: db $02;X
L0165CC: db $DD
L0165CD: db $67
L0165CE: db $0E
L0165CF: db $68
L0165D0: db $1B
L0165D1: db $68
L0165D2: db $3C
L0165D3: db $68
L0165D4: db $6D
L0165D5: db $68
L0165D6: db $92
L0165D7: db $68
L0165D8: db $69
L0165D9: db $69
L0165DA: db $8E
L0165DB: db $69
L0165DC: db $A3
L0165DD: db $69
L0165DE: db $C4
L0165DF: db $69
L0165E0: db $FD
L0165E1: db $69
L0165E2: db $0E
L0165E3: db $6A
L0165E4: db $27
L0165E5: db $6A
L0165E6: db $3C
L0165E7: db $6A
L0165E8: db $61
L0165E9: db $6A
L0165EA: db $7A
L0165EB: db $6A
L0165EC: db $CC
L0165ED: db $6A
L0165EE: db $ED
L0165EF: db $6A
L0165F0: db $12
L0165F1: db $6B
L0165F2: db $3F
L0165F3: db $6B
L0165F4: db $64
L0165F5: db $6B
L0165F6: db $AD
L0165F7: db $6B
L0165F8: db $BA
L0165F9: db $6B
L0165FA: db $DF
L0165FB: db $6B
L0165FC: db $14
L0165FD: db $6C
L0165FE: db $2D
L0165FF: db $6C
L016600: db $3E
L016601: db $6C
L016602: db $53
L016603: db $6C
L016604: db $8C
L016605: db $6C
L016606: db $C1
L016607: db $6C
L016608: db $E6
L016609: db $6C
L01660A: db $0B
L01660B: db $6D
L01660C: db $3C
L01660D: db $6D
L01660E: db $6D
L01660F: db $6D
L016610: db $A6
L016611: db $6D
L016612: db $CB
L016613: db $6D
L016614: db $F0
L016615: db $6D
L016616: db $21
L016617: db $6E
L016618: db $00;X
L016619: db $00;X
L01661A: db $66
L01661B: db $66
L01661C: db $73
L01661D: db $66
L01661E: db $7B
L01661F: db $66
L016620: db $84
L016621: db $66
L016622: db $90
L016623: db $66
L016624: db $A4
L016625: db $66
L016626: db $AC
L016627: db $66
L016628: db $B8
L016629: db $66
L01662A: db $C4
L01662B: db $66
L01662C: db $CD
L01662D: db $66
L01662E: db $D9
L01662F: db $66
L016630: db $E3
L016631: db $66
L016632: db $F0
L016633: db $66
L016634: db $F7
L016635: db $66
L016636: db $03
L016637: db $67
L016638: db $0B
L016639: db $67
L01663A: db $12
L01663B: db $67
L01663C: db $18
L01663D: db $67
L01663E: db $21
L01663F: db $67
L016640: db $2A
L016641: db $67
L016642: db $34
L016643: db $67
L016644: db $3E
L016645: db $67
L016646: db $44
L016647: db $67
L016648: db $4C
L016649: db $67
L01664A: db $52
L01664B: db $67
L01664C: db $5A
L01664D: db $67
L01664E: db $67
L01664F: db $67
L016650: db $6F
L016651: db $67
L016652: db $7B
L016653: db $67
L016654: db $8A
L016655: db $67
L016656: db $94
L016657: db $67
L016658: db $9E
L016659: db $67
L01665A: db $A7
L01665B: db $67
L01665C: db $AF
L01665D: db $67
L01665E: db $B8
L01665F: db $67
L016660: db $C0
L016661: db $67
L016662: db $CB
L016663: db $67
L016664: db $D6
L016665: db $67
L016666: db $67
L016667: db $48
L016668: db $41
L016669: db $56
L01666A: db $45
L01666B: db $5C
L01666C: db $53
L01666D: db $55
L01666E: db $5C
L01666F: db $42
L016670: db $45
L016671: db $45
L016672: db $2E
L016673: db $68
L016674: db $43
L016675: db $48
L016676: db $49
L016677: db $42
L016678: db $45
L016679: db $45
L01667A: db $2E
L01667B: db $68
L01667C: db $57
L01667D: db $41
L01667E: db $4E
L01667F: db $41
L016680: db $41
L016681: db $41
L016682: db $4E
L016683: db $2E
L016684: db $68
L016685: db $48
L016686: db $41
L016687: db $4D
L016688: db $4D
L016689: db $45
L01668A: db $52
L01668B: db $2F
L01668C: db $4A
L01668D: db $4F
L01668E: db $45
L01668F: db $2E
L016690: db $66
L016691: db $4B
L016692: db $41
L016693: db $45
L016694: db $54
L016695: db $54
L016696: db $45
L016697: db $4B
L016698: db $49
L016699: db $54
L01669A: db $41
L01669B: db $2F
L01669C: db $4D
L01669D: db $4F
L01669E: db $4E
L01669F: db $4B
L0166A0: db $49
L0166A1: db $4E
L0166A2: db $47
L0166A3: db $2E
L0166A4: db $68
L0166A5: db $4D
L0166A6: db $45
L0166A7: db $54
L0166A8: db $41
L0166A9: db $4C
L0166AA: db $4C
L0166AB: db $2E
L0166AC: db $67
L0166AD: db $4B
L0166AE: db $4F
L0166AF: db $4D
L0166B0: db $41
L0166B1: db $53
L0166B2: db $41
L0166B3: db $42
L0166B4: db $55
L0166B5: db $52
L0166B6: db $4F
L0166B7: db $2E
L0166B8: db $69
L0166B9: db $4D
L0166BA: db $45
L0166BB: db $43
L0166BC: db $48
L0166BD: db $41
L0166BE: db $2F
L0166BF: db $4B
L0166C0: db $45
L0166C1: db $52
L0166C2: db $4F
L0166C3: db $2E
L0166C4: db $68
L0166C5: db $4D
L0166C6: db $41
L0166C7: db $47
L0166C8: db $40
L0166C9: db $46
L0166CA: db $4C
L0166CB: db $59
L0166CC: db $2E
L0166CD: db $67
L0166CE: db $47
L0166CF: db $5B
L0166D0: db $53
L0166D1: db $50
L0166D2: db $52
L0166D3: db $49
L0166D4: db $4E
L0166D5: db $47
L0166D6: db $45
L0166D7: db $52
L0166D8: db $2E
L0166D9: db $67
L0166DA: db $50
L0166DB: db $45
L0166DC: db $54
L0166DD: db $45
L0166DE: db $52
L0166DF: db $43
L0166E0: db $48
L0166E1: db $59
L0166E2: db $2E
L0166E3: db $68
L0166E4: db $4E
L0166E5: db $45
L0166E6: db $57
L0166E7: db $2F
L0166E8: db $53
L0166E9: db $48
L0166EA: db $4F
L0166EB: db $54
L0166EC: db $4D
L0166ED: db $41
L0166EE: db $4E
L0166EF: db $2E
L0166F0: db $69
L0166F1: db $59
L0166F2: db $41
L0166F3: db $4D
L0166F4: db $42
L0166F5: db $4F
L0166F6: db $2E
L0166F7: db $66
L0166F8: db $48
L0166F9: db $41
L0166FA: db $52
L0166FB: db $49
L0166FC: db $40
L0166FD: db $48
L0166FE: db $41
L0166FF: db $52
L016700: db $52
L016701: db $59
L016702: db $2E
L016703: db $68
L016704: db $48
L016705: db $4F
L016706: db $55
L016707: db $44
L016708: db $41
L016709: db $49
L01670A: db $2E
L01670B: db $69
L01670C: db $54
L01670D: db $45
L01670E: db $4C
L01670F: db $4C
L016710: db $59
L016711: db $2E
L016712: db $69
L016713: db $50
L016714: db $49
L016715: db $50
L016716: db $49
L016717: db $2E
L016718: db $68
L016719: db $53
L01671A: db $48
L01671B: db $4F
L01671C: db $54
L01671D: db $4D
L01671E: db $41
L01671F: db $4E
L016720: db $2E
L016721: db $68
L016722: db $46
L016723: db $4C
L016724: db $59
L016725: db $40
L016726: db $42
L016727: db $4F
L016728: db $59
L016729: db $2E
L01672A: db $68
L01672B: db $53
L01672C: db $50
L01672D: db $52
L01672E: db $49
L01672F: db $4E
L016730: db $47
L016731: db $45
L016732: db $52
L016733: db $2E
L016734: db $67
L016735: db $50
L016736: db $49
L016737: db $45
L016738: db $52
L016739: db $4F
L01673A: db $42
L01673B: db $4F
L01673C: db $54
L01673D: db $2E
L01673E: db $69
L01673F: db $4D
L016740: db $4F
L016741: db $4C
L016742: db $45
L016743: db $2E
L016744: db $68
L016745: db $52
L016746: db $4F
L016747: db $42
L016748: db $42
L016749: db $49
L01674A: db $54
L01674B: db $2E
L01674C: db $69
L01674D: db $43
L01674E: db $4F
L01674F: db $4F
L016750: db $4B
L016751: db $2E
L016752: db $68
L016753: db $42
L016754: db $41
L016755: db $54
L016756: db $54
L016757: db $4F
L016758: db $4E
L016759: db $2E
L01675A: db $69
L01675B: db $50
L01675C: db $55
L01675D: db $54
L01675E: db $49
L01675F: db $2F
L016760: db $47
L016761: db $4F
L016762: db $42
L016763: db $4C
L016764: db $49
L016765: db $4E
L016766: db $2E
L016767: db $68
L016768: db $53
L016769: db $43
L01676A: db $57
L01676B: db $4F
L01676C: db $52
L01676D: db $4D
L01676E: db $2E
L01676F: db $66
L016770: db $4D
L016771: db $41
L016772: db $54
L016773: db $41
L016774: db $53
L016775: db $41
L016776: db $42
L016777: db $55
L016778: db $52
L016779: db $4F
L01677A: db $2E
L01677B: db $68
L01677C: db $4B
L01677D: db $41
L01677E: db $4D
L01677F: db $49
L016780: db $4E
L016781: db $41
L016782: db $52
L016783: db $49
L016784: db $2F
L016785: db $47
L016786: db $4F
L016787: db $52
L016788: db $4F
L016789: db $2E
L01678A: db $67
L01678B: db $43
L01678C: db $4C
L01678D: db $41
L01678E: db $53
L01678F: db $48
L016790: db $4D
L016791: db $41
L016792: db $4E
L016793: db $2E
L016794: db $67
L016795: db $4D
L016796: db $45
L016797: db $54
L016798: db $41
L016799: db $4C
L01679A: db $4D
L01679B: db $41
L01679C: db $4E
L01679D: db $2E
L01679E: db $68
L01679F: db $57
L0167A0: db $4F
L0167A1: db $4F
L0167A2: db $44
L0167A3: db $4D
L0167A4: db $41
L0167A5: db $4E
L0167A6: db $2E
L0167A7: db $68
L0167A8: db $41
L0167A9: db $49
L0167AA: db $52
L0167AB: db $4D
L0167AC: db $41
L0167AD: db $4E
L0167AE: db $2E
L0167AF: db $68
L0167B0: db $48
L0167B1: db $41
L0167B2: db $52
L0167B3: db $44
L0167B4: db $4D
L0167B5: db $41
L0167B6: db $4E
L0167B7: db $2E
L0167B8: db $68
L0167B9: db $54
L0167BA: db $4F
L0167BB: db $50
L0167BC: db $4D
L0167BD: db $41
L0167BE: db $4E
L0167BF: db $2E
L0167C0: db $67
L0167C1: db $4D
L0167C2: db $41
L0167C3: db $47
L0167C4: db $4E
L0167C5: db $45
L0167C6: db $54
L0167C7: db $4D
L0167C8: db $41
L0167C9: db $4E
L0167CA: db $2E
L0167CB: db $67
L0167CC: db $4E
L0167CD: db $45
L0167CE: db $45
L0167CF: db $44
L0167D0: db $4C
L0167D1: db $45
L0167D2: db $4D
L0167D3: db $41
L0167D4: db $4E
L0167D5: db $2E
L0167D6: db $69
L0167D7: db $51
L0167D8: db $55
L0167D9: db $49
L0167DA: db $4E
L0167DB: db $54
L0167DC: db $2E
L0167DD: db $0C
L0167DE: db $E1
L0167DF: db $F4
L0167E0: db $80
L0167E1: db $00
L0167E2: db $E1
L0167E3: db $FC
L0167E4: db $81
L0167E5: db $00
L0167E6: db $E1
L0167E7: db $04
L0167E8: db $82
L0167E9: db $00
L0167EA: db $E9
L0167EB: db $F4
L0167EC: db $90
L0167ED: db $00
L0167EE: db $E9
L0167EF: db $FC
L0167F0: db $91
L0167F1: db $00
L0167F2: db $E9
L0167F3: db $04
L0167F4: db $92
L0167F5: db $00
L0167F6: db $F1
L0167F7: db $F4
L0167F8: db $94
L0167F9: db $00
L0167FA: db $F1
L0167FB: db $FC
L0167FC: db $95
L0167FD: db $00
L0167FE: db $F1
L0167FF: db $04
L016800: db $94
L016801: db $20
L016802: db $F9
L016803: db $F4
L016804: db $A4
L016805: db $00
L016806: db $F9
L016807: db $FC
L016808: db $A5
L016809: db $00
L01680A: db $F9
L01680B: db $04
L01680C: db $A4
L01680D: db $20
L01680E: db $03
L01680F: db $F3
L016810: db $FF
L016811: db $99
L016812: db $00
L016813: db $F9
L016814: db $F8
L016815: db $96
L016816: db $00
L016817: db $F9
L016818: db $00
L016819: db $97
L01681A: db $00
L01681B: db $08
L01681C: db $E1
L01681D: db $F8
L01681E: db $CB
L01681F: db $80
L016820: db $E1
L016821: db $00
L016822: db $CC
L016823: db $80
L016824: db $E9
L016825: db $F8
L016826: db $DB
L016827: db $80
L016828: db $E9
L016829: db $00
L01682A: db $DC
L01682B: db $80
L01682C: db $F1
L01682D: db $F8
L01682E: db $EB
L01682F: db $80
L016830: db $F1
L016831: db $00
L016832: db $EC
L016833: db $80
L016834: db $F9
L016835: db $F8
L016836: db $FB
L016837: db $80
L016838: db $F9
L016839: db $00
L01683A: db $FC
L01683B: db $80
L01683C: db $0C
L01683D: db $E1
L01683E: db $F3
L01683F: db $8A
L016840: db $00
L016841: db $E1
L016842: db $FB
L016843: db $8B
L016844: db $00
L016845: db $E1
L016846: db $03
L016847: db $8C
L016848: db $00
L016849: db $E9
L01684A: db $F3
L01684B: db $8D
L01684C: db $00
L01684D: db $E9
L01684E: db $FB
L01684F: db $8E
L016850: db $00
L016851: db $E9
L016852: db $03
L016853: db $9C
L016854: db $00
L016855: db $F1
L016856: db $F3
L016857: db $AA
L016858: db $00
L016859: db $F1
L01685A: db $FB
L01685B: db $AB
L01685C: db $00
L01685D: db $F1
L01685E: db $03
L01685F: db $AC
L016860: db $00
L016861: db $F9
L016862: db $F4
L016863: db $BA
L016864: db $00
L016865: db $F9
L016866: db $FC
L016867: db $BB
L016868: db $00
L016869: db $F9
L01686A: db $04
L01686B: db $BC
L01686C: db $00
L01686D: db $09
L01686E: db $E9
L01686F: db $FC
L016870: db $B1
L016871: db $00
L016872: db $EB
L016873: db $F4
L016874: db $B0
L016875: db $00
L016876: db $EB
L016877: db $04
L016878: db $B2
L016879: db $00
L01687A: db $F1
L01687B: db $FC
L01687C: db $C1
L01687D: db $00
L01687E: db $F3
L01687F: db $F4
L016880: db $C0
L016881: db $00
L016882: db $F3
L016883: db $04
L016884: db $C2
L016885: db $00
L016886: db $F9
L016887: db $F4
L016888: db $D0
L016889: db $00
L01688A: db $F9
L01688B: db $FC
L01688C: db $D1
L01688D: db $00
L01688E: db $F9
L01688F: db $04
L016890: db $D2
L016891: db $00
L016892: db $08
L016893: db $EE
L016894: db $F8
L016895: db $B8
L016896: db $00
L016897: db $EE
L016898: db $00
L016899: db $B9
L01689A: db $00
L01689B: db $F6
L01689C: db $F5
L01689D: db $ED
L01689E: db $00
L01689F: db $F6
L0168A0: db $FD
L0168A1: db $EE
L0168A2: db $00
L0168A3: db $F6
L0168A4: db $05
L0168A5: db $EF
L0168A6: db $00
L0168A7: db $FE
L0168A8: db $F0
L0168A9: db $FD
L0168AA: db $00
L0168AB: db $FE
L0168AC: db $F8
L0168AD: db $FE
L0168AE: db $00
L0168AF: db $FE
L0168B0: db $00
L0168B1: db $DB
L0168B2: db $00
L0168B3: db $17;X
L0168B4: db $C9;X
L0168B5: db $F8;X
L0168B6: db $A0;X
L0168B7: db $00;X
L0168B8: db $C9;X
L0168B9: db $00;X
L0168BA: db $A1;X
L0168BB: db $00;X
L0168BC: db $D1;X
L0168BD: db $F8;X
L0168BE: db $B7;X
L0168BF: db $00;X
L0168C0: db $D1;X
L0168C1: db $00;X
L0168C2: db $B8;X
L0168C3: db $00;X
L0168C4: db $D9;X
L0168C5: db $F0;X
L0168C6: db $C6;X
L0168C7: db $00;X
L0168C8: db $D9;X
L0168C9: db $F8;X
L0168CA: db $C7;X
L0168CB: db $00;X
L0168CC: db $D9;X
L0168CD: db $00;X
L0168CE: db $C8;X
L0168CF: db $00;X
L0168D0: db $E1;X
L0168D1: db $F0;X
L0168D2: db $D6;X
L0168D3: db $00;X
L0168D4: db $E1;X
L0168D5: db $F8;X
L0168D6: db $D7;X
L0168D7: db $00;X
L0168D8: db $E1;X
L0168D9: db $00;X
L0168DA: db $D8;X
L0168DB: db $00;X
L0168DC: db $E9;X
L0168DD: db $E8;X
L0168DE: db $B6;X
L0168DF: db $00;X
L0168E0: db $E9;X
L0168E1: db $F0;X
L0168E2: db $E6;X
L0168E3: db $00;X
L0168E4: db $E9;X
L0168E5: db $F8;X
L0168E6: db $E7;X
L0168E7: db $00;X
L0168E8: db $E9;X
L0168E9: db $00;X
L0168EA: db $E8;X
L0168EB: db $00;X
L0168EC: db $F1;X
L0168ED: db $ED;X
L0168EE: db $F6;X
L0168EF: db $00;X
L0168F0: db $F1;X
L0168F1: db $F5;X
L0168F2: db $F7;X
L0168F3: db $00;X
L0168F4: db $F1;X
L0168F5: db $FD;X
L0168F6: db $83;X
L0168F7: db $00;X
L0168F8: db $F1;X
L0168F9: db $05;X
L0168FA: db $87;X
L0168FB: db $00;X
L0168FC: db $F9;X
L0168FD: db $E8;X
L0168FE: db $C9;X
L0168FF: db $00;X
L016900: db $F9;X
L016901: db $F0;X
L016902: db $CA;X
L016903: db $00;X
L016904: db $F9;X
L016905: db $F8;X
L016906: db $88;X
L016907: db $00;X
L016908: db $F9;X
L016909: db $00;X
L01690A: db $89;X
L01690B: db $00;X
L01690C: db $F9;X
L01690D: db $08;X
L01690E: db $98;X
L01690F: db $00;X
L016910: db $16;X
L016911: db $D9;X
L016912: db $F4;X
L016913: db $B0;X
L016914: db $00;X
L016915: db $D9;X
L016916: db $FC;X
L016917: db $B1;X
L016918: db $00;X
L016919: db $D9;X
L01691A: db $04;X
L01691B: db $B2;X
L01691C: db $00;X
L01691D: db $E1;X
L01691E: db $F1;X
L01691F: db $90;X
L016920: db $00;X
L016921: db $E1;X
L016922: db $F9;X
L016923: db $91;X
L016924: db $00;X
L016925: db $E1;X
L016926: db $01;X
L016927: db $92;X
L016928: db $00;X
L016929: db $E1;X
L01692A: db $09;X
L01692B: db $C3;X
L01692C: db $00;X
L01692D: db $E9;X
L01692E: db $EC;X
L01692F: db $A0;X
L016930: db $00;X
L016931: db $E9;X
L016932: db $F4;X
L016933: db $A1;X
L016934: db $00;X
L016935: db $E9;X
L016936: db $FC;X
L016937: db $A2;X
L016938: db $00;X
L016939: db $E9;X
L01693A: db $04;X
L01693B: db $D3;X
L01693C: db $00;X
L01693D: db $E9;X
L01693E: db $0C;X
L01693F: db $D4;X
L016940: db $00;X
L016941: db $F1;X
L016942: db $EC;X
L016943: db $E0;X
L016944: db $00;X
L016945: db $F1;X
L016946: db $F4;X
L016947: db $E1;X
L016948: db $00;X
L016949: db $F1;X
L01694A: db $FC;X
L01694B: db $E2;X
L01694C: db $00;X
L01694D: db $F1;X
L01694E: db $04;X
L01694F: db $E3;X
L016950: db $00;X
L016951: db $F1;X
L016952: db $0C;X
L016953: db $E4;X
L016954: db $00;X
L016955: db $F9;X
L016956: db $EC;X
L016957: db $F0;X
L016958: db $00;X
L016959: db $F9;X
L01695A: db $F4;X
L01695B: db $F1;X
L01695C: db $00;X
L01695D: db $F9;X
L01695E: db $FC;X
L01695F: db $F2;X
L016960: db $00;X
L016961: db $F9;X
L016962: db $04;X
L016963: db $F3;X
L016964: db $00;X
L016965: db $F9;X
L016966: db $0C;X
L016967: db $F4;X
L016968: db $00;X
L016969: db $09
L01696A: db $E9
L01696B: db $F4
L01696C: db $80
L01696D: db $00
L01696E: db $E9
L01696F: db $FC
L016970: db $81
L016971: db $00
L016972: db $E9
L016973: db $04
L016974: db $82
L016975: db $00
L016976: db $F1
L016977: db $F4
L016978: db $90
L016979: db $00
L01697A: db $F1
L01697B: db $FC
L01697C: db $91
L01697D: db $00
L01697E: db $F1
L01697F: db $04
L016980: db $92
L016981: db $00
L016982: db $F9
L016983: db $F4
L016984: db $A0
L016985: db $00
L016986: db $F9
L016987: db $FC
L016988: db $A1
L016989: db $00
L01698A: db $F9
L01698B: db $04
L01698C: db $A2
L01698D: db $00
L01698E: db $05
L01698F: db $F1
L016990: db $F8
L016991: db $8D
L016992: db $00
L016993: db $F1
L016994: db $00
L016995: db $8E
L016996: db $00
L016997: db $F1
L016998: db $08
L016999: db $8F
L01699A: db $00
L01699B: db $F9
L01699C: db $F8
L01699D: db $9D
L01699E: db $00
L01699F: db $F9
L0169A0: db $00
L0169A1: db $9E
L0169A2: db $00
L0169A3: db $08
L0169A4: db $F1
L0169A5: db $F4
L0169A6: db $80
L0169A7: db $00
L0169A8: db $F1
L0169A9: db $FC
L0169AA: db $81
L0169AB: db $00
L0169AC: db $F1
L0169AD: db $04
L0169AE: db $82
L0169AF: db $00
L0169B0: db $F9
L0169B1: db $F4
L0169B2: db $90
L0169B3: db $00
L0169B4: db $F9
L0169B5: db $FC
L0169B6: db $91
L0169B7: db $00
L0169B8: db $F9
L0169B9: db $04
L0169BA: db $92
L0169BB: db $00
L0169BC: db $01
L0169BD: db $F8
L0169BE: db $A0
L0169BF: db $00
L0169C0: db $01
L0169C1: db $00
L0169C2: db $A1
L0169C3: db $00
L0169C4: db $0E
L0169C5: db $D9
L0169C6: db $E7
L0169C7: db $B3
L0169C8: db $00
L0169C9: db $D9
L0169CA: db $EF
L0169CB: db $B4
L0169CC: db $00
L0169CD: db $D9
L0169CE: db $F7
L0169CF: db $B5
L0169D0: db $00
L0169D1: db $E1
L0169D2: db $E7
L0169D3: db $C3
L0169D4: db $00
L0169D5: db $E1
L0169D6: db $EF
L0169D7: db $C4
L0169D8: db $00
L0169D9: db $E1
L0169DA: db $F7
L0169DB: db $C5
L0169DC: db $00
L0169DD: db $E9
L0169DE: db $EA
L0169DF: db $D3
L0169E0: db $00
L0169E1: db $E9
L0169E2: db $F2
L0169E3: db $D4
L0169E4: db $00
L0169E5: db $E9
L0169E6: db $FA
L0169E7: db $D5
L0169E8: db $00
L0169E9: db $F1
L0169EA: db $F3
L0169EB: db $D6
L0169EC: db $00
L0169ED: db $F1
L0169EE: db $FB
L0169EF: db $E3
L0169F0: db $00
L0169F1: db $F9
L0169F2: db $F4
L0169F3: db $F0
L0169F4: db $00
L0169F5: db $F9
L0169F6: db $FC
L0169F7: db $F1
L0169F8: db $00
L0169F9: db $F9
L0169FA: db $04
L0169FB: db $F2
L0169FC: db $00
L0169FD: db $04
L0169FE: db $F1
L0169FF: db $FC
L016A00: db $96
L016A01: db $00
L016A02: db $F9
L016A03: db $F4
L016A04: db $A5
L016A05: db $00
L016A06: db $F9
L016A07: db $FC
L016A08: db $A6
L016A09: db $00
L016A0A: db $F9
L016A0B: db $04
L016A0C: db $A5
L016A0D: db $20
L016A0E: db $06
L016A0F: db $E9
L016A10: db $F9
L016A11: db $D7
L016A12: db $00
L016A13: db $E9
L016A14: db $01
L016A15: db $D8
L016A16: db $00
L016A17: db $F1
L016A18: db $F9
L016A19: db $E7
L016A1A: db $00
L016A1B: db $F1
L016A1C: db $01
L016A1D: db $E8
L016A1E: db $00
L016A1F: db $F9
L016A20: db $F9
L016A21: db $F7
L016A22: db $00
L016A23: db $F9
L016A24: db $01
L016A25: db $F8
L016A26: db $00
L016A27: db $05
L016A28: db $F1
L016A29: db $FC
L016A2A: db $C0
L016A2B: db $00
L016A2C: db $F1
L016A2D: db $04
L016A2E: db $C1
L016A2F: db $00
L016A30: db $F9
L016A31: db $F4
L016A32: db $C2
L016A33: db $00
L016A34: db $F9
L016A35: db $FC
L016A36: db $C3
L016A37: db $00
L016A38: db $F9
L016A39: db $04
L016A3A: db $C4
L016A3B: db $00
L016A3C: db $09
L016A3D: db $E9
L016A3E: db $F4
L016A3F: db $D0
L016A40: db $00
L016A41: db $E9
L016A42: db $FC
L016A43: db $D1
L016A44: db $00
L016A45: db $E9
L016A46: db $04
L016A47: db $D2
L016A48: db $00
L016A49: db $F1
L016A4A: db $F4
L016A4B: db $E0
L016A4C: db $00
L016A4D: db $F1
L016A4E: db $FC
L016A4F: db $E1
L016A50: db $00
L016A51: db $F1
L016A52: db $04
L016A53: db $E2
L016A54: db $00
L016A55: db $F9
L016A56: db $F4
L016A57: db $F0
L016A58: db $00
L016A59: db $F9
L016A5A: db $FC
L016A5B: db $F1
L016A5C: db $00
L016A5D: db $F9
L016A5E: db $04
L016A5F: db $F2
L016A60: db $00
L016A61: db $06
L016A62: db $F1
L016A63: db $F4
L016A64: db $82
L016A65: db $00
L016A66: db $F1
L016A67: db $FC
L016A68: db $83
L016A69: db $00
L016A6A: db $F1
L016A6B: db $04
L016A6C: db $84
L016A6D: db $00
L016A6E: db $F9
L016A6F: db $F4
L016A70: db $92
L016A71: db $00
L016A72: db $F9
L016A73: db $FC
L016A74: db $93
L016A75: db $00
L016A76: db $F9
L016A77: db $04
L016A78: db $94
L016A79: db $00
L016A7A: db $04
L016A7B: db $F1
L016A7C: db $F8
L016A7D: db $C1
L016A7E: db $00
L016A7F: db $F1
L016A80: db $00
L016A81: db $C1
L016A82: db $20
L016A83: db $F9
L016A84: db $F8
L016A85: db $C1
L016A86: db $40
L016A87: db $F9
L016A88: db $00
L016A89: db $C1
L016A8A: db $60
L016A8B: db $0C;X
L016A8C: db $C1;X
L016A8D: db $F8;X
L016A8E: db $C6;X
L016A8F: db $00;X
L016A90: db $C1;X
L016A91: db $00;X
L016A92: db $C7;X
L016A93: db $00;X
L016A94: db $C9;X
L016A95: db $F8;X
L016A96: db $D6;X
L016A97: db $00;X
L016A98: db $C9;X
L016A99: db $00;X
L016A9A: db $D7;X
L016A9B: db $00;X
L016A9C: db $D1;X
L016A9D: db $F8;X
L016A9E: db $C6;X
L016A9F: db $00;X
L016AA0: db $D1;X
L016AA1: db $00;X
L016AA2: db $C7;X
L016AA3: db $00;X
L016AA4: db $D9;X
L016AA5: db $F8;X
L016AA6: db $D6;X
L016AA7: db $00;X
L016AA8: db $D9;X
L016AA9: db $00;X
L016AAA: db $D7;X
L016AAB: db $00;X
L016AAC: db $E1;X
L016AAD: db $F8;X
L016AAE: db $C4;X
L016AAF: db $00;X
L016AB0: db $E1;X
L016AB1: db $00;X
L016AB2: db $C5;X
L016AB3: db $00;X
L016AB4: db $E9;X
L016AB5: db $F8;X
L016AB6: db $D4;X
L016AB7: db $00;X
L016AB8: db $E9;X
L016AB9: db $00;X
L016ABA: db $D5;X
L016ABB: db $00;X
L016ABC: db $F1;X
L016ABD: db $F8;X
L016ABE: db $C6;X
L016ABF: db $00;X
L016AC0: db $F1;X
L016AC1: db $00;X
L016AC2: db $C7;X
L016AC3: db $00;X
L016AC4: db $F9;X
L016AC5: db $F8;X
L016AC6: db $D6;X
L016AC7: db $00;X
L016AC8: db $F9;X
L016AC9: db $00;X
L016ACA: db $D7;X
L016ACB: db $00;X
L016ACC: db $08
L016ACD: db $E1
L016ACE: db $F8
L016ACF: db $C2
L016AD0: db $00
L016AD1: db $E1
L016AD2: db $00
L016AD3: db $C3
L016AD4: db $00
L016AD5: db $E9
L016AD6: db $F8
L016AD7: db $D2
L016AD8: db $00
L016AD9: db $E9
L016ADA: db $00
L016ADB: db $D3
L016ADC: db $00
L016ADD: db $F1
L016ADE: db $F8
L016ADF: db $8E
L016AE0: db $00
L016AE1: db $F1
L016AE2: db $00
L016AE3: db $8F
L016AE4: db $00
L016AE5: db $F9
L016AE6: db $F8
L016AE7: db $9E
L016AE8: db $00
L016AE9: db $F9
L016AEA: db $00
L016AEB: db $9F
L016AEC: db $00
L016AED: db $09
L016AEE: db $E9
L016AEF: db $F4
L016AF0: db $D8
L016AF1: db $00
L016AF2: db $E9
L016AF3: db $FC
L016AF4: db $C9
L016AF5: db $00
L016AF6: db $E9
L016AF7: db $04
L016AF8: db $CA
L016AF9: db $00
L016AFA: db $F1
L016AFB: db $F4
L016AFC: db $E8
L016AFD: db $00
L016AFE: db $F1
L016AFF: db $FC
L016B00: db $E9
L016B01: db $00
L016B02: db $F1
L016B03: db $04
L016B04: db $EA
L016B05: db $00
L016B06: db $F9
L016B07: db $F4
L016B08: db $F8
L016B09: db $00
L016B0A: db $F9
L016B0B: db $FC
L016B0C: db $F9
L016B0D: db $00
L016B0E: db $F9
L016B0F: db $04
L016B10: db $FA
L016B11: db $00
L016B12: db $0B
L016B13: db $E1
L016B14: db $F4
L016B15: db $80
L016B16: db $00
L016B17: db $E1
L016B18: db $FC
L016B19: db $81
L016B1A: db $00
L016B1B: db $E1
L016B1C: db $04
L016B1D: db $82
L016B1E: db $00
L016B1F: db $E9
L016B20: db $FC
L016B21: db $93
L016B22: db $00
L016B23: db $E9
L016B24: db $04
L016B25: db $94
L016B26: db $00
L016B27: db $E9
L016B28: db $0C
L016B29: db $95
L016B2A: db $00
L016B2B: db $F1
L016B2C: db $FC
L016B2D: db $A3
L016B2E: db $00
L016B2F: db $F1
L016B30: db $04
L016B31: db $A4
L016B32: db $00
L016B33: db $F9
L016B34: db $F4
L016B35: db $B0
L016B36: db $00
L016B37: db $F9
L016B38: db $FC
L016B39: db $B3
L016B3A: db $00
L016B3B: db $F9
L016B3C: db $04
L016B3D: db $B2
L016B3E: db $00
L016B3F: db $09
L016B40: db $E1
L016B41: db $F0
L016B42: db $85
L016B43: db $00
L016B44: db $E1
L016B45: db $F8
L016B46: db $86
L016B47: db $00
L016B48: db $E9
L016B49: db $F0
L016B4A: db $95
L016B4B: db $00
L016B4C: db $E9
L016B4D: db $F8
L016B4E: db $96
L016B4F: db $00
L016B50: db $E9
L016B51: db $00
L016B52: db $97
L016B53: db $00
L016B54: db $F1
L016B55: db $F8
L016B56: db $A6
L016B57: db $00
L016B58: db $F1
L016B59: db $00
L016B5A: db $A7
L016B5B: db $00
L016B5C: db $F9
L016B5D: db $F8
L016B5E: db $B6
L016B5F: db $00
L016B60: db $F9
L016B61: db $00
L016B62: db $B7
L016B63: db $00
L016B64: db $12
L016B65: db $D1
L016B66: db $F4
L016B67: db $8C
L016B68: db $00
L016B69: db $D1
L016B6A: db $FC
L016B6B: db $8D
L016B6C: db $00
L016B6D: db $D1
L016B6E: db $04
L016B6F: db $8E
L016B70: db $00
L016B71: db $D9
L016B72: db $F4
L016B73: db $9C
L016B74: db $00
L016B75: db $D9
L016B76: db $FC
L016B77: db $9D
L016B78: db $00
L016B79: db $D9
L016B7A: db $04
L016B7B: db $9E
L016B7C: db $00
L016B7D: db $E1
L016B7E: db $F4
L016B7F: db $AC
L016B80: db $00
L016B81: db $E1
L016B82: db $FC
L016B83: db $AD
L016B84: db $00
L016B85: db $E1
L016B86: db $04
L016B87: db $AE
L016B88: db $00
L016B89: db $E9
L016B8A: db $F4
L016B8B: db $C0
L016B8C: db $00
L016B8D: db $E9
L016B8E: db $FC
L016B8F: db $C1
L016B90: db $00
L016B91: db $E9
L016B92: db $04
L016B93: db $C0
L016B94: db $20
L016B95: db $F1
L016B96: db $F4
L016B97: db $D0
L016B98: db $00
L016B99: db $F1
L016B9A: db $FC
L016B9B: db $D1
L016B9C: db $00
L016B9D: db $F1
L016B9E: db $04
L016B9F: db $D0
L016BA0: db $20
L016BA1: db $F9
L016BA2: db $F4
L016BA3: db $C0
L016BA4: db $40
L016BA5: db $F9
L016BA6: db $FC
L016BA7: db $C1
L016BA8: db $40
L016BA9: db $F9
L016BAA: db $04
L016BAB: db $C0
L016BAC: db $60
L016BAD: db $03
L016BAE: db $E9
L016BAF: db $FC
L016BB0: db $89
L016BB1: db $80
L016BB2: db $F1
L016BB3: db $FC
L016BB4: db $99
L016BB5: db $80
L016BB6: db $F9
L016BB7: db $FC
L016BB8: db $A9
L016BB9: db $80
L016BBA: db $09
L016BBB: db $E1
L016BBC: db $FC
L016BBD: db $CB
L016BBE: db $00
L016BBF: db $E9
L016BC0: db $F4
L016BC1: db $DA
L016BC2: db $00
L016BC3: db $E9
L016BC4: db $FC
L016BC5: db $DB
L016BC6: db $00
L016BC7: db $F1
L016BC8: db $F4
L016BC9: db $EA
L016BCA: db $00
L016BCB: db $F1
L016BCC: db $FC
L016BCD: db $EB
L016BCE: db $00
L016BCF: db $F1
L016BD0: db $04
L016BD1: db $EC
L016BD2: db $00
L016BD3: db $F9
L016BD4: db $F4
L016BD5: db $FA
L016BD6: db $00
L016BD7: db $F9
L016BD8: db $FC
L016BD9: db $FB
L016BDA: db $00
L016BDB: db $F9
L016BDC: db $04
L016BDD: db $FC
L016BDE: db $00
L016BDF: db $0D
L016BE0: db $E1
L016BE1: db $F4
L016BE2: db $C7
L016BE3: db $00
L016BE4: db $E1
L016BE5: db $FC
L016BE6: db $C8
L016BE7: db $00
L016BE8: db $E1
L016BE9: db $04
L016BEA: db $C9
L016BEB: db $00
L016BEC: db $E9
L016BED: db $F4
L016BEE: db $D7
L016BEF: db $00
L016BF0: db $E9
L016BF1: db $FC
L016BF2: db $D8
L016BF3: db $00
L016BF4: db $E9
L016BF5: db $04
L016BF6: db $D9
L016BF7: db $00
L016BF8: db $F1
L016BF9: db $F4
L016BFA: db $E7
L016BFB: db $00
L016BFC: db $F1
L016BFD: db $FC
L016BFE: db $E8
L016BFF: db $00
L016C00: db $F1
L016C01: db $04
L016C02: db $E9
L016C03: db $00
L016C04: db $F9
L016C05: db $EC
L016C06: db $F6
L016C07: db $00
L016C08: db $F9
L016C09: db $F4
L016C0A: db $F7
L016C0B: db $00
L016C0C: db $F9
L016C0D: db $FC
L016C0E: db $F8
L016C0F: db $00
L016C10: db $F9
L016C11: db $04
L016C12: db $F9
L016C13: db $00
L016C14: db $06
L016C15: db $F1
L016C16: db $F5
L016C17: db $83
L016C18: db $00
L016C19: db $F1
L016C1A: db $FD
L016C1B: db $84
L016C1C: db $00
L016C1D: db $F1
L016C1E: db $05
L016C1F: db $85
L016C20: db $00
L016C21: db $F9
L016C22: db $F5
L016C23: db $93
L016C24: db $00
L016C25: db $F9
L016C26: db $FD
L016C27: db $94
L016C28: db $00
L016C29: db $F9
L016C2A: db $05
L016C2B: db $95
L016C2C: db $00
L016C2D: db $04
L016C2E: db $F1
L016C2F: db $F8
L016C30: db $8B
L016C31: db $00
L016C32: db $F1
L016C33: db $00
L016C34: db $8B
L016C35: db $20
L016C36: db $F9
L016C37: db $F8
L016C38: db $9B
L016C39: db $00
L016C3A: db $F9
L016C3B: db $00
L016C3C: db $9B
L016C3D: db $20
L016C3E: db $05
L016C3F: db $E9
L016C40: db $F8
L016C41: db $8A
L016C42: db $00
L016C43: db $F1
L016C44: db $F8
L016C45: db $9A
L016C46: db $00
L016C47: db $F1
L016C48: db $00
L016C49: db $8C
L016C4A: db $00
L016C4B: db $F9
L016C4C: db $F8
L016C4D: db $98
L016C4E: db $00
L016C4F: db $F9
L016C50: db $00
L016C51: db $99
L016C52: db $00
L016C53: db $0E
L016C54: db $E1
L016C55: db $F8
L016C56: db $C8
L016C57: db $00
L016C58: db $E1
L016C59: db $00
L016C5A: db $C9
L016C5B: db $00
L016C5C: db $E9
L016C5D: db $F0
L016C5E: db $D7
L016C5F: db $00
L016C60: db $E9
L016C61: db $F8
L016C62: db $D8
L016C63: db $00
L016C64: db $E9
L016C65: db $00
L016C66: db $D9
L016C67: db $00
L016C68: db $E9
L016C69: db $08
L016C6A: db $DA
L016C6B: db $00
L016C6C: db $F1
L016C6D: db $F0
L016C6E: db $E7
L016C6F: db $00
L016C70: db $F1
L016C71: db $F8
L016C72: db $E8
L016C73: db $00
L016C74: db $F1
L016C75: db $00
L016C76: db $E9
L016C77: db $00
L016C78: db $F1
L016C79: db $08
L016C7A: db $EA
L016C7B: db $00
L016C7C: db $F9
L016C7D: db $F0
L016C7E: db $F7
L016C7F: db $00
L016C80: db $F9
L016C81: db $F8
L016C82: db $F8
L016C83: db $00
L016C84: db $F9
L016C85: db $00
L016C86: db $F9
L016C87: db $00
L016C88: db $F9
L016C89: db $08
L016C8A: db $FA
L016C8B: db $00
L016C8C: db $0D
L016C8D: db $E3
L016C8E: db $F4
L016C8F: db $87
L016C90: db $00
L016C91: db $E3
L016C92: db $FC
L016C93: db $A2
L016C94: db $00
L016C95: db $E3
L016C96: db $04
L016C97: db $A3
L016C98: db $00
L016C99: db $EB
L016C9A: db $EC
L016C9B: db $96
L016C9C: db $00
L016C9D: db $EB
L016C9E: db $F4
L016C9F: db $97
L016CA0: db $00
L016CA1: db $EB
L016CA2: db $FC
L016CA3: db $B2
L016CA4: db $00
L016CA5: db $EB
L016CA6: db $04
L016CA7: db $B3
L016CA8: db $00
L016CA9: db $F1
L016CAA: db $F4
L016CAB: db $C4
L016CAC: db $00
L016CAD: db $F1
L016CAE: db $FC
L016CAF: db $C5
L016CB0: db $00
L016CB1: db $F1
L016CB2: db $04
L016CB3: db $C6
L016CB4: db $00
L016CB5: db $F9
L016CB6: db $F4
L016CB7: db $D4
L016CB8: db $00
L016CB9: db $F9
L016CBA: db $FC
L016CBB: db $D5
L016CBC: db $00
L016CBD: db $F9
L016CBE: db $04
L016CBF: db $D6
L016CC0: db $00
L016CC1: db $09
L016CC2: db $E9
L016CC3: db $F4
L016CC4: db $D4
L016CC5: db $00
L016CC6: db $E9
L016CC7: db $FC
L016CC8: db $D5
L016CC9: db $00
L016CCA: db $E9
L016CCB: db $04
L016CCC: db $D6
L016CCD: db $00
L016CCE: db $F1
L016CCF: db $F4
L016CD0: db $E4
L016CD1: db $00
L016CD2: db $F1
L016CD3: db $FC
L016CD4: db $E5
L016CD5: db $00
L016CD6: db $F1
L016CD7: db $04
L016CD8: db $E6
L016CD9: db $00
L016CDA: db $F9
L016CDB: db $F4
L016CDC: db $F4
L016CDD: db $00
L016CDE: db $F9
L016CDF: db $FC
L016CE0: db $F5
L016CE1: db $00
L016CE2: db $F9
L016CE3: db $04
L016CE4: db $F6
L016CE5: db $00
L016CE6: db $09
L016CE7: db $E9
L016CE8: db $F4
L016CE9: db $D7
L016CEA: db $00
L016CEB: db $E9
L016CEC: db $FC
L016CED: db $D8
L016CEE: db $00
L016CEF: db $E9
L016CF0: db $04
L016CF1: db $D9
L016CF2: db $00
L016CF3: db $F1
L016CF4: db $F4
L016CF5: db $E7
L016CF6: db $00
L016CF7: db $F1
L016CF8: db $FC
L016CF9: db $E8
L016CFA: db $00
L016CFB: db $F1
L016CFC: db $04
L016CFD: db $E9
L016CFE: db $00
L016CFF: db $F9
L016D00: db $F4
L016D01: db $F7
L016D02: db $00
L016D03: db $F9
L016D04: db $FC
L016D05: db $F8
L016D06: db $00
L016D07: db $F9
L016D08: db $04
L016D09: db $F9
L016D0A: db $00
L016D0B: db $0C
L016D0C: db $E9
L016D0D: db $F0
L016D0E: db $D0
L016D0F: db $00
L016D10: db $E9
L016D11: db $F8
L016D12: db $D1
L016D13: db $00
L016D14: db $E9
L016D15: db $00
L016D16: db $D2
L016D17: db $00
L016D18: db $E9
L016D19: db $08
L016D1A: db $D3
L016D1B: db $00
L016D1C: db $F1
L016D1D: db $F0
L016D1E: db $E0
L016D1F: db $00
L016D20: db $F1
L016D21: db $F8
L016D22: db $E1
L016D23: db $00
L016D24: db $F1
L016D25: db $00
L016D26: db $E2
L016D27: db $00
L016D28: db $F1
L016D29: db $08
L016D2A: db $E3
L016D2B: db $00
L016D2C: db $F9
L016D2D: db $F0
L016D2E: db $F0
L016D2F: db $00
L016D30: db $F9
L016D31: db $F8
L016D32: db $F1
L016D33: db $00
L016D34: db $F9
L016D35: db $00
L016D36: db $F2
L016D37: db $00
L016D38: db $F9
L016D39: db $08
L016D3A: db $F3
L016D3B: db $00
L016D3C: db $0C
L016D3D: db $E9
L016D3E: db $F0
L016D3F: db $90
L016D40: db $00
L016D41: db $E9
L016D42: db $F8
L016D43: db $91
L016D44: db $00
L016D45: db $E9
L016D46: db $00
L016D47: db $92
L016D48: db $00
L016D49: db $E9
L016D4A: db $08
L016D4B: db $93
L016D4C: db $00
L016D4D: db $F1
L016D4E: db $F0
L016D4F: db $A0
L016D50: db $00
L016D51: db $F1
L016D52: db $F8
L016D53: db $A1
L016D54: db $00
L016D55: db $F1
L016D56: db $00
L016D57: db $A2
L016D58: db $00
L016D59: db $F1
L016D5A: db $08
L016D5B: db $A3
L016D5C: db $00
L016D5D: db $F9
L016D5E: db $F0
L016D5F: db $B0
L016D60: db $00
L016D61: db $F9
L016D62: db $F8
L016D63: db $B1
L016D64: db $00
L016D65: db $F9
L016D66: db $00
L016D67: db $B2
L016D68: db $00
L016D69: db $F9
L016D6A: db $08
L016D6B: db $B3
L016D6C: db $00
L016D6D: db $0E
L016D6E: db $E2
L016D6F: db $F8
L016D70: db $C1
L016D71: db $00
L016D72: db $E2
L016D73: db $00
L016D74: db $C2
L016D75: db $00
L016D76: db $EA
L016D77: db $F0
L016D78: db $D0
L016D79: db $00
L016D7A: db $EA
L016D7B: db $F8
L016D7C: db $D1
L016D7D: db $00
L016D7E: db $EA
L016D7F: db $00
L016D80: db $D2
L016D81: db $00
L016D82: db $EA
L016D83: db $08
L016D84: db $D3
L016D85: db $00
L016D86: db $F2
L016D87: db $F0
L016D88: db $E0
L016D89: db $00
L016D8A: db $F2
L016D8B: db $F8
L016D8C: db $E1
L016D8D: db $00
L016D8E: db $F2
L016D8F: db $00
L016D90: db $E2
L016D91: db $00
L016D92: db $F2
L016D93: db $08
L016D94: db $E3
L016D95: db $00
L016D96: db $FA
L016D97: db $F0
L016D98: db $F0
L016D99: db $00
L016D9A: db $FA
L016D9B: db $F8
L016D9C: db $F1
L016D9D: db $00
L016D9E: db $FA
L016D9F: db $00
L016DA0: db $F2
L016DA1: db $00
L016DA2: db $FA
L016DA3: db $08
L016DA4: db $F3
L016DA5: db $00
L016DA6: db $09
L016DA7: db $E9
L016DA8: db $F4
L016DA9: db $A0
L016DAA: db $00
L016DAB: db $E9
L016DAC: db $FC
L016DAD: db $A1
L016DAE: db $00
L016DAF: db $E9
L016DB0: db $04
L016DB1: db $A2
L016DB2: db $00
L016DB3: db $F1
L016DB4: db $F4
L016DB5: db $B0
L016DB6: db $00
L016DB7: db $F1
L016DB8: db $FC
L016DB9: db $B1
L016DBA: db $00
L016DBB: db $F1
L016DBC: db $04
L016DBD: db $B2
L016DBE: db $00
L016DBF: db $F9
L016DC0: db $F4
L016DC1: db $C0
L016DC2: db $00
L016DC3: db $F9
L016DC4: db $FC
L016DC5: db $C1
L016DC6: db $00
L016DC7: db $F9
L016DC8: db $04
L016DC9: db $C2
L016DCA: db $00
L016DCB: db $09
L016DCC: db $E9
L016DCD: db $F4
L016DCE: db $80
L016DCF: db $00
L016DD0: db $E9
L016DD1: db $FC
L016DD2: db $81
L016DD3: db $00
L016DD4: db $E9
L016DD5: db $04
L016DD6: db $82
L016DD7: db $00
L016DD8: db $F1
L016DD9: db $F4
L016DDA: db $90
L016DDB: db $00
L016DDC: db $F1
L016DDD: db $FC
L016DDE: db $91
L016DDF: db $00
L016DE0: db $F1
L016DE1: db $04
L016DE2: db $92
L016DE3: db $00
L016DE4: db $F9
L016DE5: db $F4
L016DE6: db $A0
L016DE7: db $00
L016DE8: db $F9
L016DE9: db $FC
L016DEA: db $A1
L016DEB: db $00
L016DEC: db $F9
L016DED: db $04
L016DEE: db $A2
L016DEF: db $00
L016DF0: db $0C
L016DF1: db $E1
L016DF2: db $FC
L016DF3: db $81
L016DF4: db $00
L016DF5: db $E9
L016DF6: db $F4
L016DF7: db $90
L016DF8: db $00
L016DF9: db $E9
L016DFA: db $FC
L016DFB: db $91
L016DFC: db $00
L016DFD: db $E9
L016DFE: db $04
L016DFF: db $92
L016E00: db $00
L016E01: db $F1
L016E02: db $F4
L016E03: db $A0
L016E04: db $00
L016E05: db $F1
L016E06: db $FC
L016E07: db $A1
L016E08: db $00
L016E09: db $F1
L016E0A: db $04
L016E0B: db $A2
L016E0C: db $00
L016E0D: db $F1
L016E0E: db $0C
L016E0F: db $A3
L016E10: db $00
L016E11: db $F9
L016E12: db $F4
L016E13: db $B0
L016E14: db $00
L016E15: db $F9
L016E16: db $FC
L016E17: db $B1
L016E18: db $00
L016E19: db $F9
L016E1A: db $04
L016E1B: db $B2
L016E1C: db $00
L016E1D: db $F9
L016E1E: db $0C
L016E1F: db $B3
L016E20: db $00
L016E21: db $09
L016E22: db $E9
L016E23: db $F5
L016E24: db $80
L016E25: db $00
L016E26: db $E9
L016E27: db $FD
L016E28: db $81
L016E29: db $00
L016E2A: db $E9
L016E2B: db $05
L016E2C: db $82
L016E2D: db $00
L016E2E: db $F1
L016E2F: db $F5
L016E30: db $90
L016E31: db $00
L016E32: db $F1
L016E33: db $FD
L016E34: db $91
L016E35: db $00
L016E36: db $F1
L016E37: db $05
L016E38: db $92
L016E39: db $00
L016E3A: db $F9
L016E3B: db $F5
L016E3C: db $A0
L016E3D: db $00
L016E3E: db $F9
L016E3F: db $FD
L016E40: db $A1
L016E41: db $00
L016E42: db $F9
L016E43: db $05
L016E44: db $A2
L016E45: db $00
mIncJunk "L016E46"
