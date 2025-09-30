; ================ Configuration ================
DEF MODE_MBC5     EQU 0 ; Use MBC5-style bankswitching. The driver still must be located within MBC1 range.
DEF VIBRATO_NOTE  EQU 0 ; Reset the vibrato timer only on new notes
DEF LOOP1_CHECK   EQU 0 ; Compatibility with bad conditional loop counts
DEF GBS_TITLE     EQUS "GBS TITLE"
DEF GBS_AUTHOR    EQUS "GBS AUTHOR"
DEF GBS_COPYRIGHT EQUS "NONE"

INCLUDE "inc/hardware.asm"
INCLUDE "player/gbs.asm"
INCLUDE "driver/main.asm"