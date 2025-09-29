; =============== mHomeCallRet ===============
; This macro generates code to perform a bankswitch, then jump to the code the label points to.
; After it's done, the previous bank is restored.
;
; IN
; - 1: A label from a BANK != $00.
MACRO mHomeCallRet
	; Save currently loaded bank
	ldh  a, [hROMBank]
	push af
		ld   a, BANK(\1) 		; Calculate the bank the label points to
		mBankswitch
		call \1
	; Restore the previous bank
	pop  af
	mBankswitch
	ret
ENDM

; =============== mHomeCallRet ===============
; Default bankswitch implementation.
; IN
; - A: Bank number
MACRO mBankswitch
	ldh  [hROMBank], a
	ld   [MBC1RomBank], a 
IF MODE_MBC5
	xor  a
	ld   [MBC5RomBank], a
ENDC 
ENDM

; =============== dp ===============
; Shorthand for far pointers in standard order.
MACRO dp
	db BANK(\1)
	dw \1
ENDM

; =============== mVbDef ===============
; Defines a vibrato table.
; IN
; - 1: Ptr to a vibrato table.
;      This is a list of frequency offsets applied every frame, one after the other.
; - 2: Loop point
MACRO mVbDef
	dw \1
	db \2
ENDM

; =============== dsong ===============
; Defines an entry in the song pointer table.
; IN
; - 1: Ptr to sound header
; - 2: Ptr to start action/init code
MACRO dsong
	dp \1
	dw \2
ENDM

; =============== mSOUNDBANK ===============
; Defines the necessary includes for a sound bank.
; IN
; - 1: Bank number (in DECIMAL format due to limitations)
; - 2: If 1, this is the main bank
MACRO mSOUNDBANK
IF _NARG > 1
	_mSOUNDBANK \1, \2
ELSE
	_mSOUNDBANK \1, 0
ENDC
ENDM

MACRO _mSOUNDBANK
SECTION "Sound Driver - Bank \1", ROMX[$4000], BANK[\1]
INCLUDE "driver/driver.asm"
INCLUDE "driver/data/frequencies.asm"
INCLUDE "driver/data/waves.asm"
INCLUDE "driver/data/vibrato.asm"
INCLUDE "driver/data/song_list.asm"
SECTION "Sound Data - Bank \1", ROMX, BANK[\1]
	; Sound data below
ENDM

; =============== mSndReadNextByte ===============
; Reads the current byte from the sound data, and advances the data pointer.
; OUT
; - A: Current sound data byte
; - BC: Ptr to current sound data byte (not incremented)
MACRO mSndReadNextByte
	; A = *hSndInfoCurDataPtr
	ld   hl, hSndInfoCurDataPtr_High	; Read out hSndInfoCurDataPtr to BC
	ldd  a, [hl]
	ld   c, [hl]
	ld   b, a
	ld   a, [bc]						; Read value off current data ptr
	
	; hSndInfoCurDataPtr++
	inc  [hl]
	jr   nz, .noHi_\@
	inc  l
	inc  [hl]
.noHi_\@:
ENDM

; =============== mSndSeek ===============
; Advances the sound data pointer by the specified amount.
; IN
; - 1: Number of bytes
; OUT
; - A: Current sound data byte
MACRO mSndSeek
	ld   hl, hSndInfoCurDataPtr_Low
	ld   a, [hl]
	add  \1								; LowByte += \1
	ldi  [hl], a
	jr   nc, .noHi_\@					; Overflowed? If not, jump
	inc  [hl]							; HighByte++
.noHi_\@:
ENDM

; =============== Sound driver macros ===============
; For command IDs, their code will be specified in a comment.

; =============== snd_err ===============
; Placeholder for invalid or dummy commands. Do not use.
; Code: Sound_DecDataPtr
; IN
; - 1: Full command byte
MACRO snd_err
	db \1
ENDM

; =============== chan_stop ===============
; Stops channel playback.
; Code: Sound_Cmd_ChanStop / Sound_Cmd_ChanStopHiSFXMulti / Sound_Cmd_ChanStopHiSFX4
; IN
; - 1: [Optional] For SFX, the priority flag to clear from wSnd_Unused_SfxPriority (SNP_*).
;                 It must match the flag that was set on the init action code.
MACRO chan_stop
	IF _NARG > 0
		IF \1 == SNP_SFXMULTI
			db SNDCMD_BASE + $14
		ELIF \1 == SNP_SFX4
			db SNDCMD_BASE + $16
		ELSE
			FAIL "Invalid parameter passed to chan_stop"
		ENDC
	ELSE
		db SNDCMD_BASE + $03
	ENDC
ENDM

; =============== envelope ===============
; Sets volume & envelope data to NRx2.
; Use for all channels except Wave, which lacks envelope functionality.
; Code: Sound_Cmd_WriteToNRx2
; IN:
; - 1: Raw NRx2 data
MACRO envelope
	db SNDCMD_BASE + $04, \1
ENDM

; =============== wave_vol ===============
; Sets the wave channel's volume to NR32.
; Code: Sound_Cmd_WriteToNRx2
; IN:
; - 1: Raw NR32 data, shifted left once.
;      This is to make the volume representation consistent with envelope command.
MACRO wave_vol
	db SNDCMD_BASE + $04, (((((\1 >> 6) ^ 3) + 1) & 3) << 5)
ENDM

; =============== snd_loop ===============
; Jumps to the specified target in the song data.
; It can loop for a specified amount of times, after which the loop is ignored and the song continues. 
; Code: Sound_Cmd_JpFromLoop / Sound_Cmd_JpFromLoopByTimer
; IN:
; - 1: Ptr to song data
; - 2: [Optional] Timer ID (should be unique as to not overwrite other loops)
; - 3: [Optional] Times to loop (Initial timer value)
;                 This is pre-decremented, so ie: a loop counter of 2 will loop once.
MACRO snd_loop
	IF _NARG > 1
		IF !LOOP1_CHECK
			ASSERT \3 > 1, "Improper loop count"
		ENDC
		; Conditional
		db SNDCMD_BASE + $07
		db \2, \3
		dw \1
	ELSE
		; Always
		db SNDCMD_BASE + $05
		dw \1
	ENDC
ENDM

; =============== fine_tune ===============
; Adjusts the note ID offset for the track.
; Note IDs will be shifted by this amount relative to the current offset.
; Code: Sound_Cmd_AddToBaseFreqId
; IN:
; - 1: Tune offsets
MACRO fine_tune
	db SNDCMD_BASE + $06, \1
ENDM

; =============== sweep ===============
; Sets Pulse 1 sweep settings.
; Code: Sound_Cmd_WriteToNR10
; IN:
; - 1: Raw NR10 data
MACRO sweep
	db SNDCMD_BASE + $08, \1
ENDM

; =============== panning ===============
; Sets the channel's stereo panning.
; Code: Sound_Cmd_SetPanning
; IN:
; - 1: NR51 bits. 
;      Only the bits for the current channel should be set.
MACRO panning
	db SNDCMD_BASE + $09, \1
ENDM

; =============== fine_tune_value ===============
; Sets the pitch offset for the track.
; The frequency value will be shifted by this amount relative to the current offset.
; Code: Sound_Cmd_SetBaseFreqOff
; IN:
; - 1: Tune offsets
MACRO fine_tune_value
	db SNDCMD_BASE + $0A, \1
ENDM

; =============== snd_call ===============
; Like calling a subroutine, but for the sound data ptr.
; Code: Sound_Cmd_Call
; IN:
; - 1: Ptr to song data
MACRO snd_call
	db SNDCMD_BASE + $0C
	dw \1
ENDM

; =============== snd_ret ===============
; Like returning from a subroutine, but for the sound data ptr.
; Code: Sound_Cmd_Ret
MACRO snd_ret
	db SNDCMD_BASE + $0D
ENDM

; =============== duty_cycle ===============
; Writes data to NRx1. Pulse channels only.
; Code: Sound_Cmd_WriteToNRx1
; IN:
; - 1: Wave pattern duty
; - 2: [Optional] Sound length
MACRO duty_cycle
	ASSERT \1 <= %11, "Pat duty too high"
	IF _NARG > 1
		ASSERT \2 <= %111111, "Sound length too high"
		DEF CLEN = \2
	ELSE
		DEF CLEN = 0
	ENDC
	db SNDCMD_BASE + $0E
	db (\1 << 6)|CLEN
ENDM

; =============== lock_envelope ===============
; Prevents the channel's envelope from being updated.
; Code: Sound_Cmd_LockNRx2
MACRO lock_envelope
	db SNDCMD_BASE + $0F
ENDM

; =============== unlock_envelope ===============
; Enables writes to the channel's envelope.
; Code: Sound_Cmd_UnlockNRx2
MACRO unlock_envelope
	db SNDCMD_BASE + $10
ENDM

; =============== vibrato_on ===============
; Enables vibrato.
; Code: Sound_Cmd_SetVibrato
; IN
; - 1: Vibrato set ID
MACRO vibrato_on
	db SNDCMD_BASE + $11, (\1 * 3) ; 3 bytes - length of each vibrato table entry
ENDM

; =============== vibrato_off ===============
; Disables vibrato.
; Code: Sound_Cmd_ClrVibrato
MACRO vibrato_off
	db SNDCMD_BASE + $12
ENDM

; =============== wave_id ===============
; Writes a new set of wave data.
; Code: Sound_Cmd_SetWaveData
; IN:
; - 1: Wave set ID
MACRO wave_id
	db SNDCMD_BASE + $13, \1
ENDM

; =============== wave_cutoff ===============
; Writes data to NR31 and immediately applies it to the register.
; Code: Sound_Cmd_WriteToNR31
; IN:
; - 1: Channel length timer
MACRO wave_cutoff
	db SNDCMD_BASE + $15, \1
ENDM

; =============== continue ===============
; Extends the current note without restarting it.
; Useful at the start of a subroutine.
; Code: Sound_Cmd_ExtendNote
; IN:
; - 1: Length value
MACRO continue
	db SNDCMD_BASE + $1A
	db \1
ENDM

; =============== pitch_slide ===============
; Starts a pitch slide.
; Code: Sound_Cmd_Unused_StartSlide
; IN:
; - 1: Note (C_ to B)
; - 2: Octave (2-8)
; - 3: Length value
MACRO pitch_slide
	_mknote \#
	db SNDCMD_BASE + $1C
	db \3, DNOTE
ENDM

; =============== wait ===============
; Extends the current note's length.
; Usually bundled together with note & note4 to set the new note's length.
; Code: N/A
; IN:
; - 1: Length ($00-$7F)
MACRO wait
	db \1
ENDM

; =============== note4 ===============
; Sets a note in SPN format. Channel 4 only.
; Code: N/A
; IN:
; - 1: Note (C_ to B)
; - 2: Octave (2-6)
; - 3: Step width (0: 15-bit LFSR, 1: 7-bit LFSR)
; - 4: New Length [Optional]
MACRO note4
	; Convert the SPN to respective values in the tbm noise frequency table
	DEF HI_P1 = (6 - \2) * 3
	DEF NOTE_INV = 11 - \1
	IF (\2 == 6 && NOTE_INV < 4)
		DEF DNOTE = (NOTE_INV & 3)
	ELSE
		DEF LOW_SUB = (NOTE_INV % 4) + 4
		DEF LOW_BASE = NOTE_INV / 4
		DEF DNOTE = ((HI_P1 + 1) << 4) + LOW_SUB - ($20 - (LOW_BASE * $10))
	ENDC
	
	db DNOTE|(\3 << 3)
	IF _NARG > 3
		db \4
	ENDC
ENDM

; =============== note4x ===============
; Sets a custom note unrepresentable with tbm.
; Code: N/A
; IN:
; - 1: NR43 data
; - 2: New Length [Optional]
MACRO note4x
	db \1
	IF _NARG > 1
		db \2
	ENDC
ENDM

; =============== note ===============
; Sets a note in SPN format. Channels 1-2-3 only.
; Code: N/A
; IN:
; - 1: Note (C_ to B)
; - 2: Octave (2-8)
; - 3: New Length [Optional]
MACRO note
	_mknote \#
	db SNDNOTE_BASE + DNOTE
	IF _NARG > 2
		db \3
	ENDC
ENDM

; =============== silence ===============
; Sets a no-frequency note.
; Code: N/A
; IN:
; - 1: New Length [Optional]
MACRO silence
	db SNDNOTE_BASE
	IF _NARG > 0
		db \1
	ENDC
ENDM

; =============== _mknote ===============
; Formats a raw note ID.
; IN:
; - 1: Note (C_ to B)
; - 2: Octave (2-8)
; OUT
; - DNOTE: Result
MACRO _mknote
	ASSERT \1 >= C_, "Note too low"
	ASSERT \1 <= B_, "Note too high"

	ASSERT \2 >= 0, "Octave too low"
	ASSERT \2 <= 8, "Octave too high"
	DEF DNOTE = (12*(\2-2)) + \1
	; Offset by 1 for positive ones, as $00 is no frequency.
	IF DNOTE >= 0
		DEF DNOTE = DNOTE + 1
	ENDC
ENDM