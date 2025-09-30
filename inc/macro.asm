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
	ld   c, SND_MUTE		; And kill the level music
	call SoundInt_ReqPlayId
ENDM

; =============== mPlayBGM ===============
; Plays the specified music track.
; IN
; - 1: BGM ID
MACRO mPlayBGM
	ld   c, \1
	call SoundInt_ReqPlayId
ENDM

; =============== mPlaySFX ===============
; Plays the specified sound effect.
; IN
; - 1: SFX ID
MACRO mPlaySFX
	ld   c, \1
	call SoundInt_ReqPlayId
ENDM