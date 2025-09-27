; =============== mWaitHBlankEnd ===============
; Waits for the current HBlank to finish, if we're in one.
MACRO mWaitForHBlankEnd
.waitHBlankEnd_\@:
	ldh  a, [rSTAT]
	and  a, $03
	jp   z, .waitHBlankEnd_\@
ENDM
; =============== mWaitHBlank ===============
; Waits for the HBlank period.
MACRO mWaitForHBlank
.waitHBlank_\@:
	ldh  a, [rSTAT]
	and  a, $03
	jp   nz, .waitHBlank_\@
ENDM
; =============== mWaitForNewHBlank ===============
; Waits for the start of a new HBlank period.
MACRO mWaitForNewHBlank
	; If we're in HBlank already, wait for it to finish
	mWaitForHBlankEnd
	; Then wait for the HBlank proper
	mWaitForHBlank
ENDM

; =============== mWaitForVBlankOrHBlank ===============
; Waits for the VBlank or HBlank period.
MACRO mWaitForVBlankOrHBlank
.waitVBlankOrHBlank_\@:
	ldh  a, [rSTAT]
	bit  1, a
	jp   nz, .waitVBlankOrHBlank_\@
ENDM

; =============== mWaitForVBlankOrHBlankFast ===============
; Waits for the VBlank or HBlank period.
MACRO mWaitForVBlankOrHBlankFast
.waitVBlankOrHBlank_\@:
	ldh  a, [rSTAT]
	bit  1, a
	jr   nz, .waitVBlankOrHBlank_\@
ENDM

; =============== mBinDef ===============
; Generates an include for a binary *Def structure, where the data 
; is prepended with its length in bytes.
; IN
; - \1: Path to file to INCBIN
MACRO mBinDef
	db (.end-.bin)	; Size of data
.bin:
	INCBIN \1		; Data itself
.end:
ENDM

; =============== mGfxDef ===============
; Generates an include for a binary GfxDef structure.
; This is like mBinDef, except the size is expressed in tiles.
; IN
; - \1: Path to file to INCBIN
MACRO mGfxDef
	db (.end-.bin)/TILESIZE ; Number of tiles
.bin:
	INCBIN \1		; Data itself
.end:
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

; =============== mIncJunk ===============
; Generates an include for junk padding data.
; IN
; - \1: Filename without extension
MACRO mIncJunk

IF LABEL_JUNK
Padding_\@:
ENDC
	IF !SKIP_JUNK
		INCBIN STRCAT("padding/", \1, ".bin")
	ENDC
ENDM

; =============== wd ===============
; Reverse dw pointer
MACRO wd
	db HIGH(\1),LOW(\1)
ENDM

; =============== dp ===============
; Shorthand for far pointers in standard order.
MACRO dp
	db BANK(\1)
	dw \1
ENDM

; =============== dpr ===============
; Shorthand for far pointers in reverse order.
MACRO dpr
	dw \1
	db BANK(\1)
ENDM