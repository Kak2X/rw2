SECTION "Sound Driver - Interface", HRAM[$FF98]
hBGMSet:                  db      ; $FF98 ; Requested BGM Id
hSFXSet:                  db      ; $FF99 ; Requested SFX Id
hBGMCur:                  db      ; $FF9A ; Current BGM Id

SECTION "Sound Driver - Main", HRAM[$FFB8]
hBGMCh1DataPtr_Low:       db      ; $FFB8 ; Data pointers for every channel
hBGMCh1DataPtr_High:      db      ; $FFB9 ; ""
hBGMCh2DataPtr_Low:       db      ; $FFBA ; ""
hBGMCh2DataPtr_High:      db      ; $FFBB ; ""
hBGMCh3DataPtr_Low:       db      ; $FFBC ; ""
hBGMCh3DataPtr_High:      db      ; $FFBD ; ""
hBGMCh4DataPtr_Low:       db      ; $FFBE ; ""
hBGMCh4DataPtr_High:      db      ; $FFBF ; ""
hBGMCh1RetPtr_Low:        db      ; $FFC0 ; "Stack" return address for every channel
hBGMCh1RetPtr_High:       db      ; $FFC1 ; ""
hBGMCh2RetPtr_Low:        db      ; $FFC2 ; ""
hBGMCh2RetPtr_High:       db      ; $FFC3 ; ""
hBGMCh3RetPtr_Low:        db      ; $FFC4 ; ""
hBGMCh3RetPtr_High:       db      ; $FFC5 ; ""
hBGMCh4RetPtr_Low:        db      ; $FFC6 ; ""
hBGMCh4RetPtr_High:       db      ; $FFC7 ; ""
hBGMCh1OctavePtr_Low:     db      ; $FFC8 ; Pulse 1 octave table ptr
hBGMCh1OctavePtr_High:    db      ; $FFC9 ; ""
hBGMCh2OctavePtr_Low:     db      ; $FFCA ; Pulse 2 octave table ptr
hBGMCh2OctavePtr_High:    db      ; $FFCB ; ""
hBGMCh3OctavePtr_Low:     db      ; $FFCC ; Wave octave table ptr
hBGMCh3OctavePtr_High:    db      ; $FFCD ; ""
ds $02 ; No octaves for Noise channel
wBGMCh1LengthTimer:       db      ; $FFD0 ; Pulse 1 note length (ticks remaining)
wBGMCh2LengthTimer:       db      ; $FFD1 ; Pulse 2 "" 
wBGMCh3LengthTimer:       db      ; $FFD2 ; Wave    "" 
wBGMCh4LengthTimer:       db      ; $FFD3 ; Noise   "" 
hBGMCh1OctaveId:          db      ; $FFD4 ; Pulse 1 octave ID (affects hBGMCh1OctavePtr)
hBGMCh2OctaveId:          db      ; $FFD5 ; Pulse 2 ""
hBGMCh3OctaveId:          db      ; $FFD6 ; Wave    ""
hBGMCh4OctaveId:          db      ; $FFD7 ; Noise   ""
hInitBGMNR12:             db      ; $FFD8 ; Starting value for Pulse 1's envelope on a new note
hInitBGMNR22:             db      ; $FFD9 ; "" Pulse 2 ""
hInitBGMNR32:             db      ; $FFDA ; "" Wave ""
hInitBGMNR42:             db      ; $FFDB ; "" Noise ""
hBGMNR12:                 db      ; $FFDC ; Working copy of the sound registers for the music track (bypassed by SFX)
hBGMNR13:                 db      ; $FFDD ; ""
hBGMNR14:                 db      ; $FFDE ; ""
hBGMNR22:                 db      ; $FFDF ; ""
hBGMNR23:                 db      ; $FFE0 ; ""
hBGMNR24:                 db      ; $FFE1 ; ""
hBGMNR31:                 db      ; $FFE2 ; ""
hBGMNR32:                 db      ; $FFE3 ; ""
hBGMNR33:                 db      ; $FFE4 ; ""
hBGMNR34:                 db      ; $FFE5 ; ""
hBGMNR41:                 db      ; $FFE6 ; ""
hBGMNR42:                 db      ; $FFE7 ; ""
hBGMNR43:                 db      ; $FFE8 ; ""
hBGMNR44:                 db      ; $FFE9 ; ""
hBGMNR51:                 db      ; $FFEA ; ""
hSFXCh2DataPtr_Low:       db      ; $FFEB ; Pulse 2 data ptr
hSFXCh2DataPtr_High:      db      ; $FFEC ; ""
hSFXCh2LengthTimer:       db      ; $FFED ; SFX Pulse 2 note length (ticks remaining)
ds $01
hSFXCh2Used:              db      ; $FFEF ; Pulse 2 channel used by SFX
hSFXCh4DataPtr_Low:       db      ; $FFF0 ; Noise data ptr
hSFXCh4DataPtr_High:      db      ; $FFF1 ; ""
hSFXCh4LengthTimer:       db      ; $FFF2 ; SFX Noise note length (ticks remaining)
ds $01
hSFXCh4Used:              db      ; $FFF4 ; Noise channel used by SFX
SECTION "Sound Driver - 2", HRAM[$FFF8]
hSFXPriority:             db      ; $FFF8 ; Current sound effect priority