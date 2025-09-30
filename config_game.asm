; Constants
DEF SKIP_JUNK     EQU 1 ; Removes padding areas
DEF LABEL_JUNK    EQU 0 ; If SKIP_JUNK isn't set, labels the padding areas.
DEF CHEAT_ON      EQU 0 ; Enables cheats (invulnerability, freeze frame)
; Sound driver config
DEF MODE_MBC5     EQU 0 ; Use MBC5-style bankswitching. The driver still must be located within MBC1 range.
DEF VIBRATO_NOTE  EQU 0 ; Reset the vibrato timer only on new notes
DEF LOOP1_CHECK   EQU 0 ; Compatibility with bad conditional loop counts

INCLUDE "main.asm"