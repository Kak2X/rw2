;
; SAMPLE PROGRAM that plays Sound IDs through the driver.
;

SECTION "Stub Program", HRAM[$FF80]
hVBlankDone:               db   ; EQU $FF80 ; Marks if the VBlank loop is done
hJoyKeys:                  db   ; EQU $FF81 ; Held keys
hJoyNewKeys:               db   ; EQU $FF82 ; Newly pressed keys
hCursorOpt:                db   ; EQU $FF83 ; Selected Sound ID
wFontLoadBit0Col:          db   ; EQU $FF84 ; Font Color 0
wFontLoadBit1Col:          db   ; EQU $FF85 ; Font Color 1
wFontLoadTmpGFX:           ds 2 ; EQU $FF86 ; Line drawing buffer

; Constants

; Keys (as bit numbers)
DEF KEYB_A           EQU 0
DEF KEYB_B           EQU 1
DEF KEYB_SELECT      EQU 2
DEF KEYB_START       EQU 3
DEF KEYB_RIGHT       EQU 4
DEF KEYB_LEFT        EQU 5
DEF KEYB_UP          EQU 6
DEF KEYB_DOWN        EQU 7
; Keys (values)
DEF KEY_NONE         EQU 0
DEF KEY_A            EQU 1 << KEYB_A
DEF KEY_B            EQU 1 << KEYB_B
DEF KEY_SELECT       EQU 1 << KEYB_SELECT
DEF KEY_START        EQU 1 << KEYB_START
DEF KEY_RIGHT        EQU 1 << KEYB_RIGHT
DEF KEY_LEFT         EQU 1 << KEYB_LEFT
DEF KEY_UP           EQU 1 << KEYB_UP
DEF KEY_DOWN         EQU 1 << KEYB_DOWN

CHARMAP "►", $02
CHARMAP "◄", $03

; Normal ASCII
CHARMAP " ", $20
CHARMAP "!", $21
CHARMAP "\"", $22
CHARMAP "(", $28
CHARMAP ")", $29
CHARMAP "+", $2B
CHARMAP ",", $2C
CHARMAP ".", $2E
CHARMAP "0", $30
CHARMAP "1", $31
CHARMAP "2", $32
CHARMAP "3", $33
CHARMAP "4", $34
CHARMAP "5", $35
CHARMAP "6", $36
CHARMAP "7", $37
CHARMAP "8", $38
CHARMAP "9", $39
CHARMAP ":", $3A
CHARMAP "?", $3F

CHARMAP "A", $41
CHARMAP "B", $42
CHARMAP "C", $43
CHARMAP "D", $44
CHARMAP "E", $45
CHARMAP "F", $46
CHARMAP "G", $47
CHARMAP "H", $48
CHARMAP "I", $49
CHARMAP "J", $4A
CHARMAP "K", $4B
CHARMAP "L", $4C
CHARMAP "M", $4D
CHARMAP "N", $4E
CHARMAP "O", $4F
CHARMAP "P", $50
CHARMAP "Q", $51
CHARMAP "R", $52
CHARMAP "S", $53
CHARMAP "T", $54
CHARMAP "U", $55
CHARMAP "V", $56
CHARMAP "W", $57
CHARMAP "X", $58
CHARMAP "Y", $59
CHARMAP "Z", $5A

CHARMAP "`", $60
CHARMAP "a", $61
CHARMAP "b", $62
CHARMAP "c", $63
CHARMAP "d", $64
CHARMAP "e", $65
CHARMAP "f", $66
CHARMAP "g", $67
CHARMAP "h", $68
CHARMAP "i", $69
CHARMAP "j", $6A
CHARMAP "k", $6B
CHARMAP "l", $6C
CHARMAP "m", $6D
CHARMAP "n", $6E
CHARMAP "o", $6F
CHARMAP "p", $70
CHARMAP "q", $71
CHARMAP "r", $72
CHARMAP "s", $73
CHARMAP "t", $74
CHARMAP "u", $75
CHARMAP "v", $76
CHARMAP "w", $77
CHARMAP "x", $78
CHARMAP "y", $79
CHARMAP "z", $7A

; =============== mWaitForVBlankOrHBlankFast ===============
; Waits for the VBlank or HBlank period.
MACRO mWaitForVBlankOrHBlank
.waitVBlankOrHBlank_\@:
	ldh  a, [rSTAT]
	bit  1, a
	jr   nz, .waitVBlankOrHBlank_\@
ENDM

; =============== mTxtDef ===============
; Generates a counted string.
; IN
; - \1: A string
MACRO mTxtDef
	db (.end-.bin) ; Number of letters
.bin:
	db \1		   ; Text string
.end:
ENDM

SECTION "VBlankInt", ROM0[$0040]
; Basic VBlank loop performing a lag check.
VBlankInt:
	push af
	ldh  a, [hVBlankDone]
	and  a					; Did we get to the VBlank wait code yet? (which reset this)
	jr   nz, .end			; If not, return (lag frame)
	inc  a					; Otherwise, mark the frame as done
	ldh  [hVBlankDone], a
.end:
	pop  af
	reti
	
SECTION "EntryPoint", ROM0[$0100]
	nop
	jp   EntryPoint

; =============== GAME HEADER ===============
	; logo
	db   $CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
	db   $00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
	db   $BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E

	db   "SOUND DRV OP",$00,$00,$00	; title
	db   $00      		; DMG - classic gameboy
	db   $41,$37		; new license
	db   $00      		; SGB flag: not capable
	db   $01      		; cart type: MBC1
	db   $02      		; ROM size: 128KiB
	db   $00      		; RAM size: 0KiB
	db   $00      		; destination code: Japanese
	db   $33      		; old license: not SGB capable
	db   $00      		; mask ROM version number
	db   $FF      		; header check
	dw   $FFFF    		; global check
	
SECTION "Main", ROM0	
EntryPoint:
	; Hide screen
	call StopLCDOperation
	
	; Clear VRAM
	ld   hl, VRAM_Begin
	ld   bc, VRAM_End-VRAM_Begin
	call InitMemory
	
	; Clear WRAM
	ld   hl, WRAM_Begin
	ld   bc, WRAM_End-WRAM_Begin
	call InitMemory
	
	; Set the real stack ptr now that WRAM is wiped
	ld   sp, $DF00
	
	; Clear HRAM
	ld   hl, HRAM_Begin
	ld   bc, HRAM_End-HRAM_Begin
	call InitMemory
	
	; Load Font
	call LoadGFX_1bppFont
	
	ld   hl, TxtDef_Title
	call TextPrinter_Instant
	ld   hl, TxtDef_InstLR
	call TextPrinter_Instant
	ld   hl, TxtDef_InstA
	call TextPrinter_Instant
	ld   hl, TxtDef_InstB
	call TextPrinter_Instant
	ld   hl, TxtDef_InstIn
	call TextPrinter_Instant
	ld   hl, TxtDef_InstOut
	call TextPrinter_Instant
	ld   hl, TxtDef_SoundId
	call TextPrinter_Instant
	
	; Show screen
	ld   a, LCDC_PRIORITY|LCDC_ENABLE
	call StartLCDOperation
	
	;--
	; Init driver
	call SoundInt_Init
	;--
	
	; Set initial cursors
	ld   a, $81
	ldh  [hCursorOpt], a
	call SetSelInTilemap

MainLoop:
	; Wait for the VBlank code to set hVBlankDone
	xor  a					
	ldh  [hVBlankDone], a
.wait:
	ldh  a, [hVBlankDone]
	and  a					; Set yet?
	jr   nz, .newFrame		; If so, exit out
	halt					; Otherwise, wait till the next interrupt
	jr   .wait
.newFrame:

	; Ever so slightly more involved song switch.
	call JoyKeys_Get
	ldh  a, [hJoyNewKeys]
	bit  KEYB_LEFT, a
	jr   nz, .decSel
	bit  KEYB_RIGHT, a
	jr   nz, .incSel
	bit  KEYB_A, a
	jr   nz, .play
	bit  KEYB_B, a
	jr   nz, .stop
	bit  KEYB_START, a
	jr   nz, .fadeIn
	bit  KEYB_SELECT, a
	jr   nz, .fadeOut
	jr   .callDrv
		
.decSel:
	ldh  a, [hCursorOpt]
	;and  a
	;jr   z, .callDrv
	dec  a
	jr   .setSel
.incSel:
	ldh  a, [hCursorOpt]
	;cp   a, ((Sound_SndHeaderPtrTable.end-Sound_SndHeaderPtrTable)/3)-1
	;jr   nc, .callDrv
	inc  a
.setSel:
	ldh  [hCursorOpt], a
	call SetSelInTilemap
	jr   .callDrv
	
.play:
	ldh  a, [hCursorOpt]
	ld   c, a
	call SoundInt_ReqPlayId
	jr   .callDrv
.stop:
	ld   c, SND_MUTE
	call SoundInt_ReqPlayId
	jr   .callDrv
	
.fadeIn:
	ld   c, SNDCMD_FADEIN|$0F
	call SoundInt_ReqPlayId
	jr   .callDrv
.fadeOut:
	ld   c, SNDCMD_FADEOUT|$0F
	call SoundInt_ReqPlayId
	jr   .callDrv
	
.callDrv:
	; Call driver
	call SoundInt_Do
	jr   MainLoop

; =============== SetSelInTilemap ===============
; Updates the Sound ID in the tilemap.
; IN
; - A: Sound ID
SetSelInTilemap:
	ld   de, $992B
	jp   NumberPrinter_Instant
	
SECTION "Helpers", ROM0

; =============== InitMemory ===============
; Zeroes out a memory range.
; IN
; - HL: Initial address
; - BC: Bytes to clear
InitMemory:
.loop:
	xor  a
	ldi  [hl], a
	dec  bc
	ld   a, b
	or   c
	jr   nz, .loop
	ret
	
; =============== StopLCDOperation ===============
; Disables the screen output in a safe way.
;
; This will wait for VBlank before stopping the LCD.
StopLCDOperation:
	di						; Disable global interrupts
	
	ldh  a, [rIE]			; Disable VBlank interrupt to prevent it from firing
	and  a, $FF^I_VBLANK
	ldh  [rIE], a

	; If the LCD is already disabled, we're done.
	ldh  a, [rLCDC]
	bit  LCDCB_ENABLE, a	; Is the display enabled?
	jr   z, .end			; If not, skip

	; Otherwise, wait in a loop until the scanline counter reaches what would be VBlank.
.wait:
	ldh  a, [rLY]			; Read scanline number
	cp   LY_VBLANK+1		; Is it 1 after the VBlank trigger?
	jr   nz, .wait			; If not, loop

	; Now we can safely disable the LCD
	ldh  a, [rLCDC]
	and  a, $FF^LCDC_ENABLE
	ldh  [rLCDC], a
.end:
	ret

; =============== StartLCDOperation ===============
; Enables the screen output with the specified options.
; IN
; - A: LCDC options.
StartLCDOperation:
	or   a, LCDC_ENABLE				; Set new LCDC status
	ldh  [rLCDC], a
	ldh  a, [rIE]					; Enable VBLANK and Serial interrupts
	or   a, I_VBLANK|I_SERIAL
	ldh  [rIE], a
	
	ei 								; Enable global interrupts
	ret
	
; =============== JoyKeys_Get ===============
; Performs input polling.
; Updates the values of hJoyKeys and hJoyNewKeys in the standard way.
JoyKeys_Get:

	; Start off by creating the bitmask.
	
	; Get the directional key status
	ld   a, HKEY_SEL_DPAD 
	ldh  [rJOYP], a
	ldh  a, [rJOYP] ; Stabilize the inputs.
	ldh  a, [rJOYP]
	ldh  a, [rJOYP]
	ldh  a, [rJOYP]
	cpl				; Reverse the bits as the hardware marks pressed keys as '0'. We need the opposite.
	and  a, %1111	; ----DULR | Only use the actual keypress values (stored in the lower nybble)
	swap a			; DULR---- | And put them in the upper nybble for hJoyKeys
	ld   b, a		; Save to B the pressed D-Pad keys
	
	; Get the button status
	ld   a, HKEY_SEL_BTN
	ldh  [rJOYP], a
	ldh  a, [rJOYP] ; Stabilize the inputs.
	ldh  a, [rJOYP]
	ldh  a, [rJOYP]
	ldh  a, [rJOYP]
	ldh  a, [rJOYP]
	ldh  a, [rJOYP]
	ldh  a, [rJOYP]
	ldh  a, [rJOYP]
	ldh  a, [rJOYP]
	ldh  a, [rJOYP]
	cpl
	and  a, %1111	; ----SCBA
	or   a, b		; DULRSCBA
	ld   c, a
	
	; Before setting updating the button status, calculate the newly pressed keys
	; C = hJoyKeys[new];
	ldh  a, [hJoyKeys]  ; A = hJoyKeys[old]
	; hJoyNewKeys = (hJoyKeys[old] ^ hJoyKeys[new]) & hJoyKeys[new]
	xor  a, c			
	and  a, c
	ldh  [hJoyNewKeys], a ; Save the new key status
	ld   a, c
	ldh  [hJoyKeys], a ; Save the key status
	
	ld   a, HKEY_SEL_BTN|HKEY_SEL_DPAD ; ?
	ldh  [rJOYP], a
	
	ret
	
SECTION "Font Writer from 95", ROM0
	
; =============== LoadGFX_1bppFont ===============
; Loads the font graphics depending on the specified settings.
LoadGFX_1bppFont:

	;
	; Before the font data there's a header with a few settings.
	;
	
	; Read the header out
	ld   hl, FontDef_Default

	; DE = Destination ptr in VRAM
	; In practice always $9000
	ld   e, [hl]
	inc  hl
	ld   d, [hl]
	inc  hl

	; B = Number of tiles to copy
	; In practice always $30, which fills the $9000-$9300 area
	ld   b, [hl]
	inc  hl
	
.fromColDef:
	; wFontLoadBit0Col = bit0 color map
	ldi  a, [hl]		
	ld   [wFontLoadBit0Col], a
	; wFontLoadBit1Col = bit1 color map
	ldi  a, [hl]
	ld   [wFontLoadBit1Col], a
	
.tileLoop:
	;
	; The font graphics are stored in 1bbp inside the ROM.
	; Convert them to 2bpp with the specified color values.
	;
	
	push bc
		ld   b, TILE_V		; B = Number of lines in a tile
	.lineLoop:
		; Clear 2 byte buffer for a line of pixels, which is the smallest size
		; we can work with due to bit interleaving.
		xor  a
		ld   [wFontLoadTmpGFX], a
		ld   [wFontLoadTmpGFX+1], a
		push bc
			ldi  a, [hl]		; Read 1bpp color entry
			
			; For each bit, apply a 2bpp color.
			; Start from bit0 and move up by rotating the 1bpp entry right.
			; The rotation guarantees that the current processed bit is always at bit0 of A.
			;
			; There also a mask at C which gets shifted left, and is used to apply bits to the 2bpp entries.
			
			ld   b, $08			; B = Bits left
			ld   c, $01			; C = Mask to apply current bit
		.bitLoop:
		
			; Map the 1bpp color to a 2bpp color.
			; Depending on the lowest bit in the GFX byte, pick a different color value
			rrca							; Get lowest bit + rotate others right
			jr   c, .useCol1				; Was that bit set (C flag set)? If so, jump
			;--
		.useCol0:		
			push af							
				ld   a, [wFontLoadBit0Col]	; Map to wFontLoadBit0Col color
				call .mapCol
				jp   .colDone
				
		.useCol1:
			push af
				ld   a, [wFontLoadBit1Col]	; Map to wFontLoadBit1Col color
				call .mapCol
		.colDone:
			pop  af							
			;--
			
			rlc  c							; C << 1
			dec  b							; All bits processed?
			jr   nz, .bitLoop				; If not, loop
			
			; Write over the two temporary tiles
			mWaitForVBlankOrHBlank
			ld   a, [wFontLoadTmpGFX]
			ld   [de], a
			inc  de
			mWaitForVBlankOrHBlank
			ld   a, [wFontLoadTmpGFX+1]
			ld   [de], a
			inc  de
			
		pop  bc			
		dec  b				; Processed all lines in the tile?
		jr   nz, .lineLoop	; If not, loop
	pop  bc				
	dec  b					; Processed all tiles?
	jr   nz, .tileLoop		; If not, loop
	ret
	
; =============== .mapCol ===============
; Converts a 1bpp color value to a 2bpp color.
; IN
; - A: 2bpp COL_* value (0-3)
; - C: Bitmask with current bit to process in both bytes, never $00
.mapCol:
	; The 2 bits of the color index are split across two bytes.
	; Split them into those two bytes at the same bit number.
	
	; 0 | %00 | wFontLoadTmpGFX = 0, wFontLoadTmpGFX+1 = 0
	; 1 | %01 | wFontLoadTmpGFX = 1, wFontLoadTmpGFX+1 = 0
	; 2 | %10 | wFontLoadTmpGFX = 0, wFontLoadTmpGFX+1 = 1
	; 3 | %11 | wFontLoadTmpGFX = 1, wFontLoadTmpGFX+1 = 1

	; Put the low bit into the first byte.
	bit  0, a					; Is the low bit set?
	jr   z, .other				; If not, skip
	push af
	ld   a, [wFontLoadTmpGFX]	; Otherwise, apply bit
	or   a, c
	ld   [wFontLoadTmpGFX], a
	pop  af
.other:
	; Put the high bit into the second byte
	bit  1, a					; Is the high bit set?
	jr   z, .end				; If not, skip
	ld   a, [wFontLoadTmpGFX+1]	; Otherwise, apply bit
	or   a, c
	ld   [wFontLoadTmpGFX+1], a
.end:
	ret

; =============== TextPrinter_Instant ===============
; Instantly prints a string to the screen.
; Note that newlines aren't supported for string printed this way.
; IN
; - HL: Ptr to TextDef structure
TextPrinter_Instant:
	; DE = Tilemap ptr
	ld   e, [hl]
	inc  hl
	ld   d, [hl]
	inc  hl
; =============== TextPrinter_Instant_CustomPos ===============
; IN
; - HL: Ptr to string length field of TextDef structure
; - DE: Tilemap ptr (Destination)
TextPrinter_Instant_CustomPos:
	; B = String length
	ld   b, [hl]
	inc  hl
.loop:
	push bc
		ldi  a, [hl]			; A = Letter
		push hl
	
			;--
			; Convert the character text to the correct tile ID.
			ld   hl, TextPrinter_CharsetToTileTbl	; HL = Ptr to conversion table
			ld   b, $00			; BC = Letter value
			ld   c, a
			add  hl, bc			; Index out to tile ID
			;--
			
			; Write it out to the tilemap
			mWaitForVBlankOrHBlank
			ld   a, [hl]	; Read Tile ID
			ld   [de], a	; Write it over
			inc  de			; Move right in tilemap
		pop  hl
	pop  bc
	dec  b				; All letters printed?
	jr   nz, .loop		; If not, loop
	ret

; =============== NumberPrinter_Instant ===============	
; Instantly prints an hex number to the screen.
; IN
; - A: Number in hex format
; - DE: Tilemap ptr
NumberPrinter_Instant:
	; Digit in the upper nybble first
	push af
		swap a
		and  a, $0F
		call .writeDigit
	pop  af
	; Then the lower one
	and  a, $0F
	call .writeDigit
	ret
	
; =============== .writeDigit ===============
; *DE = TextPrinter_DigitToTileTbl[A] + C
; IN
; - A: Digit (0-F)
; - DE: Tilemap ptr
.writeDigit:
	; Convert letter to tile ID using an alternate charmap
	ld   hl, TextPrinter_DigitToTileTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	
	; Write it to the tilemap
	mWaitForVBlankOrHBlank
	ld   a, [hl]
	ld   [de], a
	inc  de
	ret

; =============== TextPrinter_CharsetToTileTbl ===============
; Maps the 7-bit character set used for ASCII strings in the ROM to tile IDs.
; The tile IDs correspond to the standard 1bpp font (FontDef_Default).
;
; The first 128 ASCII characters are accounted for, though most point to $00, the blank space.
; Unlike 96, the standard font only contains English characters -- there's no JIS X-like format.
; The screens that display Japanese text handle it separately and load their own copy of the font.
TextPrinter_CharsetToTileTbl:
;          ; $ID ;JP 
	db $25 ; $00 ; █
	db $26 ; $01 ; ©
	db $27 ; $02 ; ►
	db $28 ; $03 ; ◄
	db $29 ; $04 ; .
	db $2A ; $05 ; ,
	db $2B ; $06 ; ?
	db $2C ; $07 ; :
	db $2D ; $08 ; -
	db $2E ; $09 ; '
	db $2F ; $0A ; !
	db $00 ; $0B ; 
	db $00 ; $0C ; 
	db $00 ; $0D ; 
	db $00 ; $0E ; 
	db $00 ; $0F ; 
	db $00 ; $10 ; 
	db $00 ; $11 ; 
	db $00 ; $12 ; 
	db $00 ; $13 ; 
	db $00 ; $14 ; 
	db $00 ; $15 ; 
	db $00 ; $16 ; 
	db $00 ; $17 ; 
	db $00 ; $18 ; 
	db $00 ; $19 ; 
	db $00 ; $1A ; 
	db $00 ; $1B ; 
	db $00 ; $1C ; 
	db $00 ; $1D ; 
	db $00 ; $1E ; 
	db $00 ; $1F ; 
	db $00 ; $20 ; (space)
	db $2F ; $21 ; ! 
	db $00 ; $22 ; 
	db $00 ; $23 ; 
	db $00 ; $24 ; 
	db $00 ; $25 ; 
	db $00 ; $26 ; 
	db $2E ; $27 ; '
	db $00 ; $28 ; 
	db $00 ; $29 ; 
	db $00 ; $2A ; 
	db $00 ; $2B ; 
	db $2A ; $2C ; ,
	db $2D ; $2D ; -
	db $29 ; $2E ; .
	db $00 ; $2F ; 
	db $01 ; $30 ; 0
	db $02 ; $31 ; 1
	db $03 ; $32 ; 2
	db $04 ; $33 ; 3
	db $05 ; $34 ; 4
	db $06 ; $35 ; 5
	db $07 ; $36 ; 6
	db $08 ; $37 ; 7
	db $09 ; $38 ; 8
	db $0A ; $39 ; 9
	db $2C ; $3A ; :
	db $00 ; $3B ; 
	db $00 ; $3C ; 
	db $00 ; $3D ; 
	db $00 ; $3E ; 
	db $2B ; $3F ; ?
	db $00 ; $40 ; 
	db $0B ; $41 ; A
	db $0C ; $42 ; B
	db $0D ; $43 ; C
	db $0E ; $44 ; D
	db $0F ; $45 ; E
	db $10 ; $46 ; F
	db $11 ; $47 ; G
	db $12 ; $48 ; H
	db $13 ; $49 ; I
	db $14 ; $4A ; J
	db $15 ; $4B ; K
	db $16 ; $4C ; L
	db $17 ; $4D ; M
	db $18 ; $4E ; N
	db $19 ; $4F ; O
	db $1A ; $50 ; P
	db $1B ; $51 ; Q
	db $1C ; $52 ; R
	db $1D ; $53 ; S
	db $1E ; $54 ; T
	db $1F ; $55 ; U
	db $20 ; $56 ; V
	db $21 ; $57 ; W
	db $22 ; $58 ; X
	db $23 ; $59 ; Y
	db $24 ; $5A ; Z
	db $00 ; $5B ; 
	db $00 ; $5C ; 
	db $00 ; $5D ; 
	db $00 ; $5E ; 
	db $00 ; $5F ; 
	db $00 ; $60 ; 
	db $00 ; $61 ; 
	db $00 ; $62 ; 
	db $00 ; $63 ; 
	db $00 ; $64 ; 
	db $00 ; $65 ; 
	db $00 ; $66 ; 
	db $00 ; $67 ; 
	db $00 ; $68 ; 
	db $00 ; $69 ; 
	db $00 ; $6A ; 
	db $00 ; $6B ; 
	db $00 ; $6C ; 
	db $00 ; $6D ; 
	db $00 ; $6E ; 
	db $00 ; $6F ; 
	db $00 ; $70 ; 
	db $00 ; $71 ; 
	db $00 ; $72 ; 
	db $00 ; $73 ; 
	db $00 ; $74 ; 
	db $00 ; $75 ; 
	db $00 ; $76 ; 
	db $00 ; $77 ; 
	db $00 ; $78 ; 
	db $00 ; $79 ; 
	db $00 ; $7A ; 
	db $00 ; $7B ; 
	db $00 ; $7C ; 
	db $00 ; $7D ; 
	db $00 ; $7E ; 
	db $00 ; $7F ; 

; =============== TextPrinter_DigitToTileTbl ===============
; Maps the number digits to tile IDs.
; The tile IDs correspond to the standard 1bpp font (FontDef_Default).
TextPrinter_DigitToTileTbl:
	db $01
	db $02
	db $03
	db $04
	db $05
	db $06
	db $07
	db $08
	db $09
	db $0A
	db $0B
	db $0C
	db $0D
	db $0E
	db $0F
	db $10
	
FontDef_Default: 
	dw $9000 	; Destination ptr
	db $30 		; Tiles to copy
.col:
	db COL_WHITE ; Bit0 color map (background)
	db COL_BLACK ; Bit1 color map (foreground)
	; 1bpp font gfx
.gfx:
	INCBIN "player/font.bin"
	
SECTION "Strings", ROM0
	
TxtDef_Title:
	dw $9821
	mTxtDef "OP DRIVER"
	
TxtDef_InstLR:
	dw $9861
	mTxtDef "◄► TO CHOOSE TRACK"
TxtDef_InstA:
	dw $9881
	mTxtDef "A TO PLAY"
TxtDef_InstB:
	dw $98A1
	mTxtDef "B TO STOP"
TxtDef_InstIn:
	dw $98C1
	mTxtDef "SELECT TO FADE OUT"
TxtDef_InstOut:
	dw $98E1
	mTxtDef "START  TO FADE IN"
	
TxtDef_SoundId:
	dw $9921
	mTxtDef "SOUND ID:"