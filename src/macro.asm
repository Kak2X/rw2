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

; =============== mStopSound ===============
; Stops all music and sound effects.
MACRO mStopSnd
	ld   a, SND_MUTE		; And kill the level music
	ldh  [hBGMSet], a
ENDM

; =============== mPlayBGM ===============
; Plays the specified music track.
; IN
; - A: BGM ID
MACRO mPlayBGM
	ldh  [hBGMSet], a
ENDM

; =============== mPlaySFX ===============
; Plays the specified sound effect.
; IN
; - A: SFX ID
MACRO mPlaySFX
	ldh  [hSFXSet], a
ENDM