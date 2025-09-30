; =============== mPadStr ===============
; Zero-pads a string to a fixed length.
;
; IN
; - 1: Text string
; - 2: String length
MACRO mPadStr
PadStr_\@:
ASSERT \2 >= (.end_\@ - .start_\@), "String too long"
.start_\@:
	db \1
.end_\@:
REPT \2 - (.end_\@ - .start_\@) 
	db $00
ENDR
ENDM

SECTION "GBS Header", ROM0[$0000]
	db "GBS"			; Identifier string
	db $01				; Version
	db (Sound_SndListTable_Main.end-Sound_SndListTable_Main)/5		; Number of songs
	db $01				; First song 
	dw GBS_StartCode	; Load address
	dw GBS_Init			; Init address
	dw SoundInt_Do		; Play address
	dw $DF00			; Stack pointer
	db $00				; Timer modulo
	db $00				; Timer control
	mPadStr "{s:GBS_TITLE}", $20 ; Title
	mPadStr "{s:GBS_AUTHOR}", $20 ; Author
	mPadStr "{s:GBS_COPYRIGHT}", $20 ; Copyright
	;--
	; Changing this padding requires updating build_gbs.cmd, as it will get stripped out by dd
	ds $3F00
	;--
GBS_StartCode:
GBS_Init:
	push af
		call SoundInt_Init
	pop  af
	add  a, SND_BASE
	ld   c, a
	jp   SoundInt_ReqPlayId