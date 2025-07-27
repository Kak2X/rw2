;
; ROCKMAN WORLD 2
;
; ロックマンワールド２
;

INCLUDE "src/font.asm"
INCLUDE "src/hardware.asm"
INCLUDE "src/constants.asm"
INCLUDE "src/macro.asm"
INCLUDE "src/memory.asm"

MACRO mFillBank
IF LABEL_JUNK
Padding_\@:
ENDC
IF !SKIP_JUNK
	REPT $4000
		db $FF
	ENDR
ENDC
ENDM

; 
; BANK $00 - ???
; 
SECTION "bank00", ROM0
INCLUDE "src/bank00.asm"

; 
; BANK $01 - ???
; 
SECTION "bank01", ROMX, BANK[$01]
INCLUDE "src/bank01.asm"

; 
; BANK $02 - ???
; 
SECTION "bank02", ROMX, BANK[$02]
INCLUDE "src/bank02.asm"

; 
; BANK $03 - ???
; 
SECTION "bank03", ROMX, BANK[$03]
INCLUDE "src/bank03.asm"

; 
; BANK $04 - ???
; 
SECTION "bank04", ROMX, BANK[$04]
INCLUDE "src/bank04.asm"

; 
; BANK $05 - ???
; 
SECTION "bank05", ROMX, BANK[$05]
INCLUDE "src/bank05.asm"

; 
; BANK $06 - N/A
; 
SECTION "bank06", ROMX, BANK[$06]
mFillBank

; 
; BANK $07 - ???
; 
SECTION "bank07", ROMX, BANK[$07]
INCLUDE "src/bank07.asm"

; 
; BANK $08 - ???
; 
SECTION "bank08", ROMX, BANK[$08]
INCLUDE "src/bank08.asm"

; 
; BANK $09 - ???
; 
SECTION "bank09", ROMX, BANK[$09]
INCLUDE "src/bank09.asm"

; 
; BANK $0A - ???
; 
SECTION "bank0A", ROMX, BANK[$0A]
INCLUDE "src/bank0A.asm"

; 
; BANK $0B - ???
; 
SECTION "bank0B", ROMX, BANK[$0B]
INCLUDE "src/bank0B.asm"

; 
; BANK $0C - ???
; 
SECTION "bank0C", ROMX, BANK[$0C]
INCLUDE "src/bank0C.asm"

; 
; BANK $0D - N/A
; 
SECTION "bank0D", ROMX, BANK[$0D]
mFillBank

; 
; BANK $0E - N/A
; 
SECTION "bank0E", ROMX, BANK[$0E]
mFillBank

; 
; BANK $0F - N/A
; 
SECTION "bank0F", ROMX, BANK[$0F]
mFillBank
