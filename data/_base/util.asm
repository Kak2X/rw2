; =============== Unused_WaitSeconds ===============
; [TCRF] Unreferenced code.
; Delays execution for a number of seconds.
; IN
; - A: Number of seconds to wait
Unused_WaitSeconds: 
	push af
		ld   a, 60
		call WaitFrames
	pop  af
	dec  a
	jr  nz, Unused_WaitSeconds
	ret
	
; =============== WaitFrames ===============
; Delays execution for a number of frames.
; IN
; - A: Number of frames to wait
WaitFrames:
	rst  $08 ; Wait Frame
	dec  a
	jr   nz, WaitFrames
	ret
	
; =============== JoyKeys_Refresh ===============
; Updates the joypad input fieds from the updated polled value.
JoyKeys_Refresh:
	ldh  a, [hJoyKeysRaw]	; B = Polled keys the current frame
	ld   b, a
	
	ldh  a, [hJoyKeys]		; A = Previously held keys
	xor  b					; Delete keys held both frames...
	and  b					; ...and keep the new ones only
	ldh  [hJoyNewKeys], a	; Update new keys
	
	ld   a, b				
	ldh  [hJoyKeys], a		; Copy the polled value directly to hJoyKeys
	ret
	
; =============== Rand ===============
; Generates a random number.
;
; This uses a 32bit LFSR, with the output value being the topmost byte.
; Each time this subroutine is called, 8 bits are shifted in from the left, which
; produces an entirely new number.
;
; OUT
; - A: Random number
Rand:
	push hl
	push de
	push bc
	
		; If all four bytes are zeroed out, seed them
		ld   hl, hRandSt0
		ldi  a, [hl]		; hRandSt0 ...
		or   [hl]			; & hRandSt1 ...
		inc  hl
		or   [hl]			; & hRandSt2 ...
		inc  hl
		or   [hl]			; & hRandSt3 == 0?
		call z, .init		; If so, seed them
		
		;--
		; Shift the 32bit value left 8 times.
		;
		; Specifically, each iteration is done by rotating in sequence the individual bytes to the left,
		; with the shifted out MSB getting shifted back in the LSB of the next byte...
		ld   b, $08			; For each bit...
	.loop:
		
		; ... but there's still something missing. Which bit gets shifted in the lowest byte?
		; That's calculated based on the previous output (hRandSt0, the topmost byte):
		; A = MSB(((hRandSt0 << 3) ^ hRandSt0) << 1)
		ld   hl, hRandSt0
		ld   a, [hl]		
		sla  a
		sla  a
		sla  a
		xor  [hl]
		sla  a
		; One last << 1 to shift the MSB into the carry, ready to be rotated
		sla  a
		
		; Rotate the 32bit value left, from lowest to high bit.
		ld   hl, hRandSt3
		rl   [hl]
		dec  hl
		rl   [hl]
		dec  hl
		rl   [hl]
		dec  hl
		rl   [hl]
		
		dec  b				; Done for all 8 bits?
		jr   nz, .loop		; If not, loop
		;--
		
		; The output value is now fully shifted out, return it.
		ld   a, [hl]	; A = hRandSt0
	pop  bc
	pop  de
	pop  hl
	ret
.init:
	ld   a, $48
	ldh  [hRandSt0], a
	ld   a, $49
	ldh  [hRandSt1], a
	ld   a, $52
	ldh  [hRandSt2], a
	ld   a, $4F
	ldh  [hRandSt3], a
	ret
	
; =============== Unused_Mul8 ===============
; [TCRF] Unreferenced code.
; Performs multiplication with an 8-bit multiplicand.
; IN
; - E: Multiplicand 
; - D: Multiplier
; OUT
; - DE: Result
Unused_Mul8:
	push af
	push hl
	push bc
		; Multiplication performed through looped addition
		ld   hl, $0000	; Result = 0
		ld   c, d		; C = Loop count (Multiplier)
		ld   d, $00		; DE = Value added (Multiplicand, with high byte $00)
	.loop:
		ld   a, c
		or   a			; Are we done?
		jr   z, .done	; If so, jump
		add  hl, de		; Result += Multiplicand
		dec  c			; LoopCount--
		jr   .loop		; Check again
	.done:
		ld   e, l		; DE = Result
		ld   d, h
	pop  bc
	pop  hl
	pop  af
	ret
	
; =============== Unused_Mul16 ===============
; [TCRF] Unreferenced code.
; Performs multiplication with a 16-bit multiplicand.
; IN
; - DE: Multiplicand 
; - A: Multiplier
; OUT
; - DE: Result
Unused_Mul16:
	push hl
	push bc
		ld   hl, $0000	; Result = 0
		ld   c, a		; C = Loop count (Multiplier)
	.loop:
		ld   a, c
		or   a			; Are we done?
		jr   z, .done	; If so, jump
		add  hl, de		; Result += Multiplicand
		dec  c			; LoopCount--
		jr   .loop		; Check again
	.done:
		ld   e, l		; DE = Result
		ld   d, h
	pop  bc
	pop  hl
	ret  

