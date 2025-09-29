; =============== EntryPoint ===============
EntryPoint:
	; Disable interrupts to prevent VBlank from triggering
	di   
	xor  a
	ldh  [rIE], a
	
	; Turn off the LCD after waiting for VBlank
	ldh  a, [rLCDC]
	set  LCDCB_ENABLE, a
	ldh  [rLCDC], a
.waitVBlank:
	ldh  a, [rLY]
	cp   LY_VBLANK+1
	jr   nz, .waitVBlank
	xor  a
	ldh  [rLCDC], a
	
	; Set stack pointer at the very bottom of WRAM (lower half of wWorkOAM)
	ld   sp, WRAM_End
	
	;
	; Clear all of WRAM ($C000-$DFFF)
	;
	xor  a
	ld   hl, WRAM_Begin
	ld   bc, WRAM_End-WRAM_Begin
.wclrLoop:;R
	ldi  [hl], a
	dec  c
	jr   nz, .wclrLoop
	dec  b
	jr   nz, .wclrLoop
	
	;
	; Clear most of HRAM ($FF80-$FFF7)
	;	
	ld   bc, ($78 << 8) | LOW(HRAM_Begin)
.hclrLoop:
	ldh  [c], a
	inc  c
	dec  b
	jr   nz, .hclrLoop
	
	;
	; Initialize the RNG state on cold boot only.
	; [POI] This accounts for warm boot, but this game doesn't have a soft-reset key combination.
	;
	
	; If hWarmBootFlag already contains $55, assume warm boot
	ld   a, $55
	ld   hl, hWarmBootFlag	; Seek to hWarmBootFlag
	cp   [hl]			; hWarmBootFlag == $55?
	jr   z, .warmBoot		; If so, jump (we never do)
	ld   [hl], a			; Otherwise, write $55 there...
	; ...and reset the RNG state.
	; This sequence being fully blank tells the Rand subroutine to properly seed the LFSR with real values.
	xor  a
	ldh  [hRandSt0], a
	ldh  [hRandSt1], a
	ldh  [hRandSt2], a
	ldh  [hRandSt3], a
.warmBoot:

	; BANK $01 is the default switchable bank, so it gets put into hROMBankLast.
	; Outside of actor processing, which temporarily repoints it to BANK $02,
	; this will not be changed to anything else, so when subroutines restore
	; the last ROM bank loaded, they assume it will point there.
	push af
		ld   a, $01
		ldh  [hROMBankLast], a
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	; Copy OAMDMA routine
	ld   c, LOW(hOAMDMA)
	ld   b, OAMDMA_Code.end-OAMDMA_Code
	ld   hl, OAMDMA_Code
.oamCpLoop:
	ldi  a, [hl]
	ldh  [c], a
	inc  c
	dec  b
	jr   nz, .oamCpLoop
	
	call Scroll_Reset	; Reset screen to top-left
	
	xor  a
	ldh  [rSC], a		; Disable serial
	ldh  [rIF], a		; Discard any pending interrupts
	
	; Enable VBlank (obvious) and the Timer (sound driver)
	ld   a, I_VBLANK|I_TIMER
	ldh  [rIE], a
	
	; Enable the screen
	ld   a, LCDC_PRIORITY|LCDC_OBJENABLE|LCDC_WTILEMAP|LCDC_ENABLE
	ldh  [rLCDC], a
	
	; Set up the STAT interrupt to only trigger on LYC.
	; Therefore, toggling I_STAT from rIE will be enough to toggle LYC.
	ld   a, STAT_LYC
	ldh  [rSTAT], a
	
	; Set the lowest possible sound driver speed
	xor  a
	ldh  [rTIMA], a
	ldh  [rTMA], a
	ld   a, rTAC_ON|rTAC_4096_HZ
	ldh  [rTAC], a
	
	; Done setting up
	ei
	jp   Game_Main
	
; =============== OAMDMA_Code ===============
; OAMDMA routine, copied to HRAM at boot.
OAMDMA_Code:
	ld   a, HIGH(wWorkOAM)	; wWorkOAM-$DF9F
	ldh  [rDMA], a			; Send over to OAM
	ld   a, $28				; and wait
.wait:
	dec  a
	jr   nz, .wait
	ret
.end:

