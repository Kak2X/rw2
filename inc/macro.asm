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
	ld   c, SND_MUTE			; And kill the level music
	call SoundInt_ReqPlayId
ENDM

; =============== mPlayBGM ===============
; Plays the specified music track.
; IN
; - C: BGM ID
MACRO mPlayBGM
	call SoundInt_ReqPlayId
ENDM

; =============== mPlaySFX ===============
; Plays the specified sound effect.
; IN
; - C: SFX ID
MACRO mPlaySFX
	call SoundInt_ReqPlayId
ENDM