; =============== Sound_Do ===============
; Sound driver code, a linear function.
Sound_Do:

	;
	; Check if there's any new BGM we want to play
	;
	ldh  a, [hBGMSet]
	cp   SNDSET_NONE		; Requested playback of a new song?
	jp   z, .chkNewSfx		; If not, skip
	ld   b, a
	ldh  a, [hBGMCur]
	cp   b					; Trying to play the same song as the currently playing one?
	jp   z, .chkNewSfx		; If so, also skip
.newBGM:
	ld   a, b				; Otherwise...
	ldh  [hBGMCur], a
	
	; HL = Ptr to song header
	add  a								; DE = hBGMCur * 2 (ptr table)
	ld   e, a
	ld   d, $00
	ld   hl, Sound_BgmHeaderPtrTable	; HL = Ptr table base
	add  hl, de							; Index it
	ldi  a, [hl]						; Read out ptr to HL
	ld   h, [hl]
	ld   l, a
	
	xor  a								; Mute all channels
	ldh  [rNR52], a
	
	; Copy the initial data pointers from the song header.
	; That's all a header has, unused sound channels point to the same "null" track.
	ld   de, hBGMCh1DataPtr_Low	; DE = Starting write location
	ld   b, $08				; B = Header size
.bgmCopyLoop:
	ldi  a, [hl]
	ld   [de], a
	inc  de
	dec  b
	jr   nz, .bgmCopyLoop
	
	; Starting a new track stops any playing sound effects
	ld   a, LOW(SFX_None)
	ldh  [hSFXCh2DataPtr_Low], a
	ldh  [hSFXCh4DataPtr_Low], a
	ld   a, HIGH(SFX_None)
	ldh  [hSFXCh2DataPtr_High], a
	ldh  [hSFXCh4DataPtr_High], a
	
	; Set default song speed
	ld   a, $D0
	ldh  [rTIMA], a
	ldh  [rTMA], a
	
	; Default to the 4th octave...
	ld   a, LOW(Sound_OctaveFreqTbl4)	; ...set the pointer
	ldh  [hBGMCh1OctavePtr_Low], a
	ldh  [hBGMCh2OctavePtr_Low], a
	ldh  [hBGMCh3OctavePtr_Low], a
	ld   a, HIGH(Sound_OctaveFreqTbl4)
	ldh  [hBGMCh1OctavePtr_High], a
	ldh  [hBGMCh2OctavePtr_High], a
	ldh  [hBGMCh3OctavePtr_High], a
	ld   a, $04							; ...set the octave ID
	ldh  [hBGMCh1OctaveId], a
	ldh  [hBGMCh2OctaveId], a
	ldh  [hBGMCh3OctaveId], a
	ldh  [hBGMCh4OctaveId], a
	
	; Set initial register mirror state
	ld   a, SNDCHF_RESTART				; Retrigger Pulse 1 & 2
	ldh  [hBGMNR14], a
	ldh  [hBGMNR24], a
	ld   a, SNDCHF_RESTART|SNDCHF_LENSTOP	; Retrigger Noise
	ldh  [hBGMNR44], a
	xor  a								; Retrigger Wave
	ldh  [hBGMNR34], a
	ldh  [wBGMCh1LengthTimer], a		; Initialize all note lengths
	ldh  [wBGMCh2LengthTimer], a
	ldh  [wBGMCh3LengthTimer], a
	ldh  [wBGMCh4LengthTimer], a
	ldh  [hSFXCh4LengthTimer], a
	
	
	; Set initial register state
	ld   a, $80							; Re-enable all channels
	ldh  [rNR52], a
	
	; Copy the wavetable associated to the track.
	; Better chose it right since you can't swap it mid-song.
	; HL = Sound_BGMWavePtrTable[hBGMSet * 2]
	ldh  a, [hBGMSet]					; Get newly played track
	add  a								; For ptr table
	ld   c, a
	ld   b, $00
	ld   hl, Sound_BGMWavePtrTable		; Get base
	add  hl, bc							; Index it
	ldi  a, [hl]						; Read out ptr to HL
	ld   h, [hl]
	ld   l, a
	; B = Addesses to update ($10)
	; C = Starting address (rWave)
	ld   bc, ((rWave_End-rWave) << 8)|LOW(rWave)	
.waveCopyLoop:
	ldi  a, [hl]
	ldh  [c], a
	inc  c
	dec  b
	jr   nz, .waveCopyLoop
	
	ld   a, $FF			; Enable all sound channels
	ldh  [hBGMNR51], a
	ldh  [rNR51], a
	ld   a, $77			; Set max volume for both speakers
	ldh  [rNR50], a
	ld   a, $08			; Use standard downwards sweep
	ldh  [rNR10], a
	ld   a, SNDCH3_ON	; Enable wave channel
	ldh  [rNR30], a
	xor  a				; But make it silent
	ldh  [rNR32], a
	ld   a, SNDCHF_RESTART	; Retrigger wave
	ldh  [rNR34], a
	ld   a, SNDSET_NONE	; Request processed
	ldh  [hBGMSet], a
	
.chkNewSfx:
	;
	; Check if there's any new SFX we want to play
	;
	ldh  a, [hSFXSet]
	cp   SNDSET_NONE		; Requested playback of a new SFX?
	jr   z, Sound_DoCh1			; If not, skip
	
	;
	; Perform a priority check on the sound effect.
	;
	; The lower the priority value, the higher the priority actually is.
	; The new sound effect will only be played if has a lower or equal priority value than the current one.
	;
	ld   c, a					; C = SFX ID
	
	; If a note is currently playing on any of the "SFX channels" is playing any data, skip the check entirely.
	ldh  a, [hSFXCh2LengthTimer]	; B = Pulse 2 note ticks left
	ld   b, a
	ldh  a, [hSFXCh4LengthTimer]	; A = Noise note ticks left
	or   b							; Anything playing on those SFX slots?
	jr   z, .trySFX2				; If not, jump (ok)
	
	; B = Sound_SFXPriorityTbl[hSFXSet]
	ld   hl, Sound_SFXPriorityTbl
	ld   b, $00
	add  hl, bc	
	ld   b, [hl]				; Read out priority to B
	
	; [BUG] The current priority is never reset when a SFX stops playing, so eventually it will become $00
	;       and every playing sound will be treated as the highest priority one.
	ldh  a, [hSFXPriority]		; A = Current priority
	cp   b						; Current < New?
	jr   c, .trySFXEnd			; If so, jump (fail)
	ld   a, b					; Otherwise, set the new priority
	ldh  [hSFXPriority], a
.trySFX2:						; And try play it

	;
	; Sound effects may play either on Pulse 2, Noise, or both.
	; When a sound effect uses a specific channel, its initial data pointer is non-zero.
	;
	; For some reason, there are two tables involved here, one for each channel.
	;
	
	; PULSE 2
	ldh  a, [hSFXSet]			; DE = hSFXSet * 2 (ptr table index)
	add  a
	ld   e, a
	ld   d, $00
	ld   hl, Sound_SFXCh2PtrTbl	; Get base
	add  hl, de					; Index it
	ldi  a, [hl]				; Read low byte
	or   a						; Is it 0?
	jr   z, .trySFX4			; If so, skip (all of the called sound effects don't jump)
								; Otherwise, copy the data ptr over
	ldh  [hSFXCh2DataPtr_Low], a	
	ld   a, [hl]
	ldh  [hSFXCh2DataPtr_High], a
	xor  a						; No SFX note here
	ldh  [hSFXCh2LengthTimer], a
	inc  a						; Mark channel as used by a sound effect
	ldh  [hSFXCh2Used], a
	
.trySFX4:
	; NOISE
	; Same as above, but for another channel
	ld   hl, Sound_SFXCh4PtrTbl
	add  hl, de
	ldi  a, [hl]
	or   a
	jr   z, .trySFXEnd
	ldh  [hSFXCh4DataPtr_Low], a
	ld   a, [hl]
	ldh  [hSFXCh4DataPtr_High], a
	xor  a
	ldh  [hSFXCh4LengthTimer], a
	inc  a
	ldh  [hSFXCh4Used], a
	
.trySFXEnd:
	ld   a, SNDSET_NONE		; Requests processed
	ldh  [hSFXSet], a
	; Fall-through
	
;================ Sound_DoCh1 ================
; Pulse 1 handler.
; Due to the way this is programmed, every sound channel has its own specific handler code.
; Even the commands are handled separately.
Sound_DoCh1:

	; Keep playing the current note until its timer elapses.
	ldh  a, [wBGMCh1LengthTimer]
	or   a							; Is it elapsed?
	jp   nz, .decTimer				; If not, jump (continue processing current)
									; Otherwise...
.newNote:									
	ldh  a, [hBGMCh1DataPtr_Low]	; HL = Channel data ptr
	ld   l, a
	ldh  a, [hBGMCh1DataPtr_High]
	ld   h, a
	
.cmdLoop:
	;
	; Commands are processed in a loop until arriving at either a new note, or at a command that pauses/stops processing.
	;
	ldi  a, [hl]			; Read raw command, seek to next
	ld   c, a				; Save for later the raw command
	
	; Command IDs >= $Cx are used for special commands.
	swap a					; >> 4 the upper nybble as that makes for easier range checks
	and  $0F				; ""
	cp   $0C				; CmdId >= $Cx?
	jr   nc, .chkCmdCx		; If so, jump
							; Otherwise...
.cmdNote:
	;
	; New Note (Command IDs $00-$BF)
	; The command ID is a bitmask, using this format:
	; NNNNHSSS
	;
	; - N   -> Node ID, relative to the channel's current octave table
	; - H/S -> Encoded note length, see Sound_DecodeNoteLen
	;
	
	; Currently, the note ID is in the lower nybble, so...
	add  a				; *2 for ptr table
	; Use that as index to the octave table hBGMCh1OctavePtr is pointing to.
	ld   e, a
	ldh  a, [hBGMCh1OctavePtr_Low]
	add  e
	ld   e, a
	ldh  a, [hBGMCh1OctavePtr_High]
	adc  $00
	ld   d, a
	; Read out its frequency value to the sound register mirror, specific to BGM channels.
	; This mirror gives us some leeway in with the order of writes -- and plays an even more important role
	; for sound channels where a sound effect can also play.
	ld   a, [de]			; Read byte0
	ldh  [hBGMNR13], a		; To low frequency byte
	inc  de
	ld   a, [de]			; Read byte1
	or   SNDCHF_RESTART		; Trigger new note
	ldh  [hBGMNR14], a		; To high frequency byte
	; Set initial volume/envelope
	ldh  a, [hInitBGMNR12]
	ldh  [hBGMNR12], a
	; Set note length
	call Sound_DecodeNoteLen
	ldh  [wBGMCh1LengthTimer], a
	jp   .syncBgmRegs
	
.chkCmdCx:
	;
	; Determine which special command we're handling.
	; 
	jr   nz, .chkCmdWait		; CmdId == $Cx? If not, jump
	; Commands in range $C0-$CF use the low nybble as part of the command ID.
	ld   a, c					; Get raw command ID
	and  $0F					; Filter out high nybble
	
.chkCmdTimer:
	;
	; Song Tempo
	;
	; Command format:
	; - 0: Command ID $C0
	; - 1: Timer speed
	;      This relies on the sound driver getting called by the timer,
	;      it won't work at all if ran during VBlank.
	;
	jr   nz, .chkCmdDutyCycle	; CmdId == $C0? If not, jump
	ldi  a, [hl]				; Read byte1, seek to next command for later
	ldh  [rTIMA], a				; Set new timer speed
	ldh  [rTMA], a				; ""
	jr   .cmdLoop				; Process next command
	
.chkCmdDutyCycle:
	;
	; Set length / duty cycle
	;
	; Command format:
	; - 0: Command ID $C1
	; - 1: NR11 value, applied instantly
	;
	dec  a						; CmdId == $C1?
	jr   nz, .chkCmdEnvelope	; If not, jump
	ldi  a, [hl]				; Read byte1
	ldh  [rNR11], a				; Set new duty cycle
	jr   .cmdLoop
	
.chkCmdEnvelope:
	;
	; Set starting volume/envelope
	;
	; Command format:
	; - 0: Command ID $C2
	; - 1: Initial NR12 value
	;
	dec  a						; CmdId == $C2?
	jr   nz, .chkCmdJp			; If not, jump
	ldi  a, [hl]
	ldh  [hInitBGMNR12], a
	jr   .cmdLoop
	
.chkCmdJp:
	;
	; Jump data ptr to location.
	;
	; Command format:
	; - 0: Command ID $C3
	;      This is made to match the opcode for the "jp" instruction.
	; - 1-2: Data pointer
	;
	dec  a						; CmdId == $C3?
	jr   nz, .chkCmdPanning
	ldi  a, [hl]				; Read out ptr to HL
	ld   h, [hl]
	ld   l, a
	jr   .cmdLoop				; Read new command from this location
	
.chkCmdPanning:
	;
	; Set sound channel panning (enabled channels)
	;
	; Command format:
	; - 0: Command ID $C4
	; - 1: NR51 value, applied instantly
	;
	dec  a						; CmdId == $C4?
	jr   nz, .chkCmdRet
	ldi  a, [hl]
	ldh  [hBGMNR51], a
	ldh  [rNR51], a
	jr   .cmdLoop
	
.chkCmdRet:
	;
	; Return from subroutine.
	;
	; Command format:
	; - 0: Command ID $C9
	;      This is made to match the opcode for the "ret" instruction,
	;      which is why the "dec a" chain is interrupted.
	;

	; -4 to account for the previous decs we made.
	cp   $09-4					; CmdId == $C9?
	jr   nz, .chkCmdCall
	; Nested subroutines are not supported, so grab the return address from a fixed location.
	; Like actual stack pointers, they are already incremented and can be used as-is (see .chkCmdCall)
	ldh  a, [hBGMCh1RetPtr_Low]	; HL = hBGMCh1RetPtr
	ld   l, a
	ldh  a, [hBGMCh1RetPtr_High]
	ld   h, a
	jp   .cmdLoop
	
.chkCmdCall:
	;
	; Call subroutine, can't be nested.
	;
	; Command format:
	; - 0: Command ID $CD
	;      This is made to match the opcode for the "call" instruction.
	; - 1-2: Data pointer for the subroutine
	;

	; -4 to account for the previous decs we made.
	cp   $0D-4					; CmdId == $CD?
	jr   nz, .cmdChanStop
	
	; Read subroutine ptr to DE
	ldi  a, [hl]				; Read byte1, seek to byte2
	ld   e, a					; as low byte
	ldi  a, [hl]				; Read byte2, seek to next cmd
	ld   d, a					; as high byte
	
	; HL is now pointing to the command after the call.
	; This will be our return address, save it in the "stack".
	ld   a, l					; hBGMCh1RetPtr = HL
	ldh  [hBGMCh1RetPtr_Low], a
	ld   a, h
	ldh  [hBGMCh1RetPtr_High], a
	
	; Overwrite data ptr with subroutine's
	ld   l, e					; HL = DE
	ld   h, d
	jp   .cmdLoop
	
.cmdChanStop:
	;
	; Stops channel playback.
	; This marks the end of the BGM sequence, so it won't return to the command loop.
	;
	; Command format:
	; - 0: Command ID <anything else $Cx>
	;
	
	; Safely mute channel
	ld   a, $08				
	ldh  [hBGMNR12], a
	; Stay on this stop command indefinitely, for next time.
	; This is because it's not truly possible to tell the BGM handler to stop processing music for any channel,
	; so as a workaround we stop on a command that mutes the BGM channel without doing anything else.
	dec  hl					; Seek back to byte0
	jr   .syncBgmRegs			; Apply changes
	
.chkCmdWait:
	;
	; Extends the current note by the specified amount of ticks.
	; Multiple waits can be adjacent to each other to wait for ticks unrepresentable by the peculiar format they are encoded with.
	;
	; Command format:
	; - 0: Bitmask CCCCHSSS
	;      C   -> Command ID $Dx
	;      H/S -> Encoded delay
	;
	cp   $0D						; Cmd == $Dx?
	jr   nz, .chkCmdSilence			; If not, jump
	call Sound_DecodeNoteLen		; A = Decoded length
	ldh  [wBGMCh1LengthTimer], a	; Set it over
	jr   .saveDataPtr
	
.chkCmdSilence:
	;
	; Mutes the channel for the specified amount of frames.
	; Identical to .chkCmdWait except it also mutes the channel.
	; Multiple waits can be adjacent to each other to wait for ticks unrepresentable by the peculiar format they are encoded with.
	;
	; Command format:
	; - 0: Bitmask CCCCHSSS
	;      C   -> Command ID $Ex
	;      H/S -> Encoded delay
	;
	cp   $0E						; Cmd == $Ex?
	jr   nz, .cmdOctave				; If not, jump
	ld   a, $08						; Safely mute channel
	ldh  [hBGMNR12], a
	call Sound_DecodeNoteLen		; A = Decoded length
	ldh  [wBGMCh1LengthTimer], a	; Set it over
	jr   .syncBgmRegs
	
.cmdOctave:		
	;
	; Octave change
	;
	; Command format:
	; - 0: Bitmask CCCCRVVV
	;      C -> Command ID $Fx
	;      R -> If set, the octave value is relative to the current one.
	;      V -> Octave value, 1-based.
	;           A value of 0 here is not valid.
	;
	
	;
	; Generate the absolute octave value, which will be used to index the octave ptr table.
	;
	
	; Start by naively extracting its bits
	ld   a, c				; A = OctaveId
	and  $07
	; If relative mode is disabled, that's all we need
	bit  3, c				; Relative flag set?
	jr   z, .setOctave		; If not, skip (always jumps)
	;--
	; [POI] We never get here. In fact, relative mode is not used by any channel in this game.
	
	; When the octave value is relative, it's a 3-bit signed number that gets added to the current octave.
	; Doing so requires sign-extending it to 8 bits first.
	cp   %100				; Is bit 2 set? (RelOctave < $04)
	jr   c, .setOctaveRel	; If so, no need to change it
	
	; Otherwise, convert it to negative.
	; This would require doing A |= $F8 to set all other bits, but we can take advantage of the command's format as:
	; - The command ID is $Fx ($F0)
	; - The relative flag is set ($08)
	; - The octave value didn't get changed
	ld   a, c				; A = Command ID
.setOctaveRel:
	ld   b, a					; B = Relative octave
	ldh  a, [hBGMCh1OctaveId]	; A = Current octave
	adc  b						; Add the relative value over
	;--
.setOctave:
	ldh  [hBGMCh1OctaveId], a	; Save result
	
	;
	; Refresh the octave pointer.
	; hBGMCh1OctavePtr = Sound_OctaveFreqPtrTbl[(OctaveId - 1) * 2]
	;
	dec  a						; Account for 1-based index
	add  a						; Account for pointer table
	; Add the offset to Sound_OctaveFreqPtrTbl
	add  LOW(Sound_OctaveFreqPtrTbl)	
	ld   e, a
	ld   a, $00
	adc  HIGH(Sound_OctaveFreqPtrTbl)
	ld   d, a
	; Read out the octave pointer to hBGMCh1OctavePtr
	ld   a, [de]
	ldh  [hBGMCh1OctavePtr_Low], a
	inc  de
	ld   a, [de]
	ldh  [hBGMCh1OctavePtr_High], a
	jp   .cmdLoop
	
.syncBgmRegs:
	; Sync the actual registers over.
	; Sound effects can't play on this channel, so it's a straightforward copy that always happens.
	ldh  a, [hBGMNR12]
	ldh  [rNR12], a
	ldh  a, [hBGMNR13]
	ldh  [rNR13], a
	ldh  a, [hBGMNR14]
	ldh  [rNR14], a
.saveDataPtr:
	; Save back updated data pointer
	ld   a, l
	ldh  [hBGMCh1DataPtr_Low], a
	ld   a, h
	ldh  [hBGMCh1DataPtr_High], a
.decTimer:
	; After all it's done (or we skipped to here for being in the middle of a note), tick down the note timer.
	ld   hl, wBGMCh1LengthTimer		; NoteLength--
	dec  [hl]
	; Fall-through
	
;================ Sound_DoCh2 ================
; Pulse 2 handler.
; Nearly identical to Pulse 1's except for different addresses and handling sound effect.
Sound_DoCh2:
	ldh  a, [wBGMCh2LengthTimer]
	or   a
	jp   nz, .decTimer
	
.newNote:
	ldh  a, [hBGMCh2DataPtr_Low]	; HL = Channel data ptr
	ld   l, a
	ldh  a, [hBGMCh2DataPtr_High]
	ld   h, a
	
.cmdLoop:
	ldi  a, [hl]					; C = Command ID
	ld   c, a
	
	; Check group >= $Cx
	swap a
	and  $0F
	cp   $0C
	jr   nc, .chkCmdCx
	
.cmdNote:
	;
	; New Note (Command IDs $00-$BF)
	;
	add  a
	ld   e, a
	ldh  a, [hBGMCh2OctavePtr_Low]
	add  e
	ld   e, a
	ldh  a, [hBGMCh2OctavePtr_High]
	adc  $00
	ld   d, a
	
	ld   a, [de]
	ldh  [hBGMNR23], a
	inc  de
	ld   a, [de]
	or   SNDCHF_RESTART
	ldh  [hBGMNR24], a
	
	ldh  a, [hInitBGMNR22]
	ldh  [hBGMNR22], a
	
	call Sound_DecodeNoteLen
	ldh  [wBGMCh2LengthTimer], a
	
	jp   .syncBgmRegs
	
.chkCmdCx:
	; Unless otherwise specified, the commands are identical to those for Pulse 1.

	jr   nz, .chkCmdWait		; CmdId == $Cx? If not, jump
	; Commands in range $C0-$CF use the low nybble as part of the command ID
	ld   a, c
	and  $0F
	
.chkCmdTimer:
	; Song Tempo ($C0) (not used for this channel)
	jr   nz, .chkCmdDutyCycle
	ldi  a, [hl]
	ldh  [rTIMA], a	
	ldh  [rTMA], a
	jr   .cmdLoop
	
.chkCmdDutyCycle:
	; Set length / duty cycle ($C1)
	dec  a
	jr   nz, .chkCmdEnvelope
	ldi  a, [hl]
	ldh  [rNR21], a
	jr   .cmdLoop
	
.chkCmdEnvelope:
	; Set starting volume/envelope ($C2)
	dec  a
	jr   nz, .chkCmdJp
	ldi  a, [hl]
	ldh  [hInitBGMNR22], a
	jr   .cmdLoop
	
.chkCmdJp:
	; Jump data ptr to location ($C3)
	dec  a
	jr   nz, .chkCmdRet
	ldi  a, [hl]
	ld   h, [hl]
	ld   l, a
	jr   .cmdLoop
	
.chkCmdRet:
	; Return from subroutine ($C9)
	; There's no sound panning command for Pulse 2, so the offset is -3 rather than -4.
	cp   $09-3
	jr   nz, .chkCmdCall
	ldh  a, [hBGMCh2RetPtr_Low]
	ld   l, a
	ldh  a, [hBGMCh2RetPtr_High]
	ld   h, a
	jp   .cmdLoop
	
.chkCmdCall:
	; Call subroutine, can't be nested ($CD)
	cp   $0D-3
	jr   nz, .cmdChanStop
	
	ldi  a, [hl]
	ld   e, a
	ldi  a, [hl]
	ld   d, a
	
	ld   a, l
	ldh  [hBGMCh2RetPtr_Low], a
	ld   a, h
	ldh  [hBGMCh2RetPtr_High], a
	
	ld   l, e
	ld   h, d
	jp   .cmdLoop
	
.cmdChanStop:
	; Stops channel playback (anything else $Cx)
	ld   a, $08
	ldh  [hBGMNR22], a
	dec  hl
	jr   .syncBgmRegs
	
.chkCmdWait:
	; Extend note ($Dx)
	cp   $0D
	jr   nz, .chkCmdSilence
	call Sound_DecodeNoteLen
	ldh  [wBGMCh2LengthTimer], a
	jr   .saveDataPtr
	
.chkCmdSilence:
	; Silence note ($Ex)
	cp   $0E
	jr   nz, .cmdOctave
	ld   a, $08
	ldh  [hBGMNR22], a
	call Sound_DecodeNoteLen
	ldh  [wBGMCh2LengthTimer], a
	jr   .syncBgmRegs
	
.cmdOctave:
	;
	; Octave change ($Fx)
	;
	ld   a, c
	and  $07
	bit  3, c
	jr   z, .setOctave
	;--
	; [POI] We never get here.
	cp   %100
	jr   c, .setOctaveRel
	
	ld   a, c
.setOctaveRel:
	ld   b, a
	ldh  a, [hBGMCh2OctaveId]
	adc  b
	;--
.setOctave:
	ldh  [hBGMCh2OctaveId], a
	;--
	; Refresh the octave pointer.
	dec  a
	add  a
	
	add  LOW(Sound_OctaveFreqPtrTbl)
	ld   e, a
	ld   a, $00
	adc  HIGH(Sound_OctaveFreqPtrTbl)
	ld   d, a
	
	ld   a, [de]
	ldh  [hBGMCh2OctavePtr_Low], a
	inc  de
	ld   a, [de]
	ldh  [hBGMCh2OctavePtr_High], a
	;--
	jp   .cmdLoop
	
.syncBgmRegs:
	;
	; First real change from Pulse 1.
	; Sound effects can play on this channel, so if it's currently used by one,
	; skip synching BGM registers and process the sound effect.
	;
	ldh  a, [hSFXCh2Used]
	or   a					; Is a SFX currently playing here?
	jr   nz, .saveDataPtr	; If so, skip
	ldh  a, [hBGMNR22]		; Otherwise, sync the BGM registers over
	ldh  [rNR22], a
	ldh  a, [hBGMNR23]
	ldh  [rNR23], a
	ldh  a, [hBGMNR24]
	ldh  [rNR24], a
.saveDataPtr:
	; Save back updated data pointer
	ld   a, l
	ldh  [hBGMCh2DataPtr_Low], a
	ld   a, h
	ldh  [hBGMCh2DataPtr_High], a
.decTimer:
	ld   hl, wBGMCh2LengthTimer	; NoteLength--
	dec  [hl]
	
	;
	; Finally, handle sound effects if one is enabled.
	; These don't use the same complex command format as BGMs -- they instead are REGISTER DUMPS.
	;
	; There's quite nothing to them, they are tables of 4-byte entries (for NR21-NR24) terminated by a null byte.
	;
.chkSfx:
	ldh  a, [hSFXCh2Used]
	or   a						; Is a SFX currently playing here?
	jr   z, Sound_DoCh3			; If not, skip
	
	; Keep playing the current note until its timer elapses.
	ldh  a, [hSFXCh2LengthTimer]
	or   a							; Is it elapsed?
	jr   nz, .decSfxTimer			; If not, jump (continue processing current)
.newSfxNote:						; Otherwise...
	ldh  a, [hSFXCh2DataPtr_Low]	; HL = Channel data ptr
	ld   l, a
	ldh  a, [hSFXCh2DataPtr_High]
	ld   h, a
	
	;
	; A null byte ends the sound effect.
	;
	ldi  a, [hl]				; Read byte, seek to next
	or   a						; Is it a null byte?
	jr   nz, .setSfxNote		; If not, jump
.sfxStop:
	ld   a, $08					; Safely mute channel
	ldh  [rNR22], a
	swap a ; SNDCHF_RESTART		; Trigger new (silent) note
	ldh  [rNR24], a
	xor  a						; Mark SFX slot as free
	ldh  [hSFXCh2Used], a
	jr   Sound_DoCh3
.setSfxNote:
	; Otherwise, extract the remaining three bytes out, directly to the registers.
	; Worth nothing there's absolutely nothing here that preserves the original state of the sound registers,
	; so playing SFX *WILL* influence the currently playing BGM.
	ldh  [rNR21], a		; Write byte0		
	
	; The note's length here directly maps to the length we wrote to NR21.
	and  $3F						; Filter length bits
	ldh  [hSFXCh2LengthTimer], a	; Set as note length
	
	ldi  a, [hl]		; Write byte1 to NR22
	ldh  [rNR22], a
	ldi  a, [hl]		; Write byte2 to NR23
	ldh  [rNR23], a
	ldi  a, [hl]		; Write byte3 to NR24
	or   SNDCHF_RESTART	; And trigger the new note
	ldh  [rNR24], a
	
	; Save back updated data pointer
	ld   a, l
	ldh  [hSFXCh2DataPtr_Low], a
	ld   a, h
	ldh  [hSFXCh2DataPtr_High], a
.decSfxTimer:
	; Tick down on the SFX note timer
	ld   hl, hSFXCh2LengthTimer		; NoteLength--
	dec  [hl]
	; Fall-through
	
;================ Sound_DoCh3 ================
; Wave handler.
; Nearly identical to Pulse 1's except for different addresses.
Sound_DoCh3:
	ldh  a, [wBGMCh3LengthTimer]
	or   a
	jp   nz, .decTimer
	
.newNote:
	ldh  a, [hBGMCh3DataPtr_Low]	; HL = Channel data ptr
	ld   l, a
	ldh  a, [hBGMCh3DataPtr_High]
	ld   h, a
	
.cmdLoop:
	ldi  a, [hl]					; C = Command ID
	ld   c, a
	
	; Check group >= $Cx
	swap a
	and  $0F
	cp   $0C
	jr   nc, .chkCmdCx
	
.cmdNote:
	;
	; New Note (Command IDs $00-$BF)
	;
	add  a
	ld   e, a
	ldh  a, [hBGMCh3OctavePtr_Low]
	add  e
	ld   e, a
	ldh  a, [hBGMCh3OctavePtr_High]
	adc  $00
	ld   d, a
	
	ld   a, [de]
	ldh  [hBGMNR33], a
	inc  de
	ld   a, [de]
	or   SNDCHF_RESTART|SNDCHF_LENSTOP	; Retrigger and kill the channel when the length ends
	ldh  [hBGMNR34], a
	
	ldh  a, [hInitBGMNR32]
	ldh  [hBGMNR32], a
	
	call Sound_DecodeNoteLen
	ldh  [wBGMCh3LengthTimer], a
	
	jp   .syncBgmRegs
	
.chkCmdCx:
	; Unless otherwise specified, the commands are identical to those for Pulse 1.

	jr   nz, .chkCmdWait		; CmdId == $Cx? If not, jump
	; Commands in range $C0-$CF use the low nybble as part of the command ID
	ld   a, c
	and  $0F
	
.chkCmdTimer:
	; Song Tempo ($C0) (not used for this channel)
	jr   nz, .chkCmdWaveVol
	ldi  a, [hl]
	ldh  [rTIMA], a	
	ldh  [rTMA], a
	jr   .cmdLoop
	
.chkCmdWaveVol:
	; Set wave volume ($C1)
	; Name aside, code-wise it's the same command as cmdDutyCycle, except it's not instantaneous.
	dec  a
	jr   nz, .chkCmdEnvelope
	ldi  a, [hl]
	ldh  [hBGMNR31], a			; Saved to the register mirror
	jr   .cmdLoop
	
.chkCmdEnvelope:
	; Set starting volume/envelope ($C2)
	dec  a
	jr   nz, .chkCmdJp
	ldi  a, [hl]
	ldh  [hInitBGMNR32], a
	jr   .cmdLoop
	
.chkCmdJp:
	; Jump data ptr to location ($C3)
	dec  a
	jr   nz, .chkCmdRet
	ldi  a, [hl]
	ld   h, [hl]
	ld   l, a
	jr   .cmdLoop
	
.chkCmdRet:
	; Return from subroutine ($C9)
	; There's no sound panning command for Wave, so the offset is -3 rather than -4.
	cp   $09-3
	jr   nz, .chkCmdCall
	ldh  a, [hBGMCh3RetPtr_Low]
	ld   l, a
	ldh  a, [hBGMCh3RetPtr_High]
	ld   h, a
	jp   .cmdLoop
	
.chkCmdCall:
	; Call subroutine, can't be nested ($CD)
	cp   $0D-3
	jr   nz, .cmdChanStop
	
	ldi  a, [hl]
	ld   e, a
	ldi  a, [hl]
	ld   d, a
	
	ld   a, l
	ldh  [hBGMCh3RetPtr_Low], a
	ld   a, h
	ldh  [hBGMCh3RetPtr_High], a
	
	ld   l, e
	ld   h, d
	jp   .cmdLoop
	
.cmdChanStop:
	; Stops channel playback (anything else $Cx)
	xor  a
	ldh  [hBGMNR32], a
	dec  hl
	jr   .syncBgmRegs
	
.chkCmdWait:
	; Extend note ($Dx)
	cp   $0D
	jr   nz, .chkCmdSilence
	call Sound_DecodeNoteLen
	ldh  [wBGMCh3LengthTimer], a
	jr   .saveDataPtr
	
.chkCmdSilence:
	; Silence note ($Ex)
	cp   $0E
	jr   nz, .cmdOctave
	xor  a
	ldh  [hBGMNR32], a
	call Sound_DecodeNoteLen
	ldh  [wBGMCh3LengthTimer], a
	jr   .syncBgmRegs
	
.cmdOctave:
	;
	; Octave change ($Fx)
	;
	ld   a, c
	and  $07
	bit  3, c
	jr   z, .setOctave
	;--
	; [POI] We never get here.
	cp   %100
	jr   c, .setOctaveRel
	
	ld   a, c
.setOctaveRel:
	ld   b, a
	ldh  a, [hBGMCh3OctaveId]
	adc  b
	;--
.setOctave:
	ldh  [hBGMCh3OctaveId], a
	;--
	; Refresh the octave pointer.
	dec  a
	add  a
	
	add  LOW(Sound_OctaveFreqPtrTbl)
	ld   e, a
	ld   a, $00
	adc  HIGH(Sound_OctaveFreqPtrTbl)
	ld   d, a
	
	ld   a, [de]
	ldh  [hBGMCh3OctavePtr_Low], a
	inc  de
	ld   a, [de]
	ldh  [hBGMCh3OctavePtr_High], a
	;--
	jp   .cmdLoop
	
.syncBgmRegs:
	; Sync registers
	ldh  a, [hBGMNR31]
	ldh  [rNR31], a
	ldh  a, [hBGMNR32]
	ldh  [rNR32], a
	ldh  a, [hBGMNR33]
	ldh  [rNR33], a
	ldh  a, [hBGMNR34]
	ldh  [rNR34], a
.saveDataPtr:
	; Save back updated data pointer
	ld   a, l
	ldh  [hBGMCh3DataPtr_Low], a
	ld   a, h
	ldh  [hBGMCh3DataPtr_High], a
.decTimer:
	ld   hl, wBGMCh3LengthTimer	; NoteLength--
	dec  [hl]
	; Fall-through
;================ Sound_DoCh4 ================
; Noise handler.
; This is similar to Pulse 2, except for having a wildly different note format for BGMs.
Sound_DoCh4:
	ldh  a, [wBGMCh4LengthTimer]
	or   a
	jp   nz, .decTimer
	
.newNote:
	ldh  a, [hBGMCh4DataPtr_Low]	; HL = Channel data ptr
	ld   l, a
	ldh  a, [hBGMCh4DataPtr_High]
	ld   h, a
	
.cmdLoop:
	ldi  a, [hl]					; C = Command ID
	ld   c, a
	
	; Check group >= $Cx
	swap a
	and  $0F
	cp   $0C
	jr   nc, .chkCmdCx
	
.cmdNote:
	;
	; New Note (Command IDs $00-$BF)
	;
	; This is different, as the noise channel's registers work a bit differently.
	; Typically you'd dedicate a byte to raw NR43 data, but this driver's commitment to saving 
	; space means that's one byte too many, so...
	;
	; Command format:
	; NNNNHSSS
	; - N   -> Node ID for the noise frequency table.
	; - H/S -> Encoded note length, see Sound_DecodeNoteLen
	;
	
	ldh  a, [hInitBGMNR42]	; Copy NR42 as normal
	ldh  [hBGMNR42], a
	
	ld   de, Sound_NoiseFreqTable	; DE = Table base
	;--
	; This could have been avoided by doing the NR42 write after NR43.
	; We already had this before hInitBGMNR42 overwrote it.
	ld   a, c				; A = RawCmdId / $10
	and  $F0
	swap a
	;--
	; Use that as index to the noise frequency table, which uses 1-byte entries.
	add  e					; DE += A
	ld   e, a
	ld   a, d
	adc  $00
	ld   d, a
	; Read out its NR43 value to the sound register mirror, specific to BGM channels.
	ld   a, [de]
	ldh  [hBGMNR43], a
	
	ld   a, SNDCHF_RESTART|SNDCHF_LENSTOP	; Retrigger and kill the channel when the length ends
	ldh  [hBGMNR44], a	
	
	call Sound_DecodeNoteLen
	ldh  [wBGMCh4LengthTimer], a
	
	jp   .syncBgmRegs
	
.chkCmdCx:
	; Unless otherwise specified, the commands are identical to those for Pulse 1.

	jr   nz, .chkCmdWait		; CmdId == $Cx? If not, jump
	; Commands in range $C0-$CF use the low nybble as part of the command ID
	ld   a, c
	and  $0F
	
.chkCmdTimer:
	; Song Tempo ($C0) (not used for this channel)
	jr   nz, .chkCmdLength
	ldi  a, [hl]
	ldh  [rTIMA], a	
	ldh  [rTMA], a
	jr   .cmdLoop
	
.chkCmdLength:
	; Set length ($C1)
	; Like .chkCmdDutyCycle except the change isn't applied instantly.
	dec  a
	jr   nz, .chkCmdEnvelope
	ldi  a, [hl]
	ldh  [hBGMNR41], a			; Non-instantaneous here
	jr   .cmdLoop
	
.chkCmdEnvelope:
	; Set starting volume/envelope ($C2)
	dec  a
	jr   nz, .chkCmdJp
	ldi  a, [hl]
	ldh  [hInitBGMNR42], a
	jr   .cmdLoop
	
.chkCmdJp:
	; Jump data ptr to location ($C3)
	dec  a
	jr   nz, .chkCmdRet
	ldi  a, [hl]
	ld   h, [hl]
	ld   l, a
	jr   .cmdLoop
	
.chkCmdRet:
	; Return from subroutine ($C9)
	; There's no sound panning command for Noise, so the offset is -3 rather than -4.
	cp   $09-3
	jr   nz, .chkCmdCall
	ldh  a, [hBGMCh4RetPtr_Low]
	ld   l, a
	ldh  a, [hBGMCh4RetPtr_High]
	ld   h, a
	jp   .cmdLoop
	
.chkCmdCall:
	; Call subroutine, can't be nested ($CD)
	cp   $0D-3
	jr   nz, .cmdChanStop
	
	ldi  a, [hl]
	ld   e, a
	ldi  a, [hl]
	ld   d, a
	
	ld   a, l
	ldh  [hBGMCh4RetPtr_Low], a
	ld   a, h
	ldh  [hBGMCh4RetPtr_High], a
	
	ld   l, e
	ld   h, d
	jp   .cmdLoop
	
.cmdChanStop:
	; Stops channel playback (anything else $Cx)
	ld   a, $08
	ldh  [hBGMNR42], a
	dec  hl
	jr   .syncBgmRegs
	
.chkCmdWait:
	; Extend note ($Dx)
	cp   $0D
	jr   nz, .chkCmdSilence
	call Sound_DecodeNoteLen
	ldh  [wBGMCh4LengthTimer], a
	jr   .saveDataPtr
	
.chkCmdSilence:
	; Silence note ($Ex)
	cp   $0E				; CmdId == $Ex?
	jr   nz, .syncBgmRegs	; If not, skip this completely to .syncBgmRegs
	ld   a, $08
	ldh  [hBGMNR42], a
	call Sound_DecodeNoteLen
	ldh  [wBGMCh4LengthTimer], a
	jr   .syncBgmRegs
	
.unused_cmdOctave:
	; Unreachable leftover of the octave change command.
	; This channel does not use octaves.
	jp   .cmdLoop
	
.syncBgmRegs:
	;
	; Sound effects can play on this channel, so if it's currently used by one,
	; skip synching BGM registers and process the sound effect.
	;
	ldh  a, [hSFXCh4Used]
	or   a					; Is a SFX currently playing here?
	jr   nz, .saveDataPtr	; If so, skip
	ldh  a, [hBGMNR41]		; Otherwise, sync the BGM registers over
	ldh  [rNR41], a
	ldh  a, [hBGMNR42]
	ldh  [rNR42], a
	ldh  a, [hBGMNR43]
	ldh  [rNR43], a
	ldh  a, [hBGMNR44]
	ldh  [rNR44], a
.saveDataPtr:
	; Save back updated data pointer
	ld   a, l
	ldh  [hBGMCh4DataPtr_Low], a
	ld   a, h
	ldh  [hBGMCh4DataPtr_High], a
.decTimer:
	ld   hl, wBGMCh4LengthTimer	; NoteLength--
	dec  [hl]
	
	;
	; Finally, handle sound effects if one is enabled.
	; As with Pulse 2, these are straight register dumps ending with a null terminator.
	;
.chkSfx:
	ldh  a, [hSFXCh4Used]
	or   a							; Is a SFX currently playing here?
	ret  z							; If not, return (this is the last channel)
	
	; Keep playing the current note until its timer elapses.
	ldh  a, [hSFXCh4LengthTimer]
	or   a							; Is it elapsed?
	jr   nz, .decSfxTimer			; If not, jump (continue processing current)
.newSfxNote:						; Otherwise...
	ldh  a, [hSFXCh4DataPtr_Low]	; HL = Channel data ptr
	ld   l, a
	ldh  a, [hSFXCh4DataPtr_High]
	ld   h, a
	
	;
	; A null byte ends the sound effect.
	;
	ldi  a, [hl]				; Read byte, seek to next
	or   a						; Is it a null byte?
	jr   nz, .setSfxNote		; If not, jump
.sfxStop:
	ld   a, $08					; Safely mute channel
	ldh  [rNR42], a
	swap a ; SNDCHF_RESTART		; Trigger new (silent) note
	ldh  [rNR44], a
	xor  a						; Mark SFX slot as free
	ldh  [hSFXCh4Used], a
	ret
.setSfxNote:
	; Otherwise, extract the remaining three bytes out, directly to the registers.
	ldh  [rNR41], a		; Write byte0		
	
	; The note's length here directly maps to the length we wrote to NR41.
	and  $3F						; Filter length bits
	ldh  [hSFXCh4LengthTimer], a	; Set as note length
	
	ldi  a, [hl]		; Write byte1 to NR42
	ldh  [rNR42], a
	ldi  a, [hl]		; Write byte2 to NR43
	ldh  [rNR43], a
	ldi  a, [hl]		; Write byte3 to NR44
	or   SNDCHF_RESTART	; And trigger the new note
	ldh  [rNR44], a
	
	; Save back updated data pointer
	ld   a, l
	ldh  [hSFXCh4DataPtr_Low], a
	ld   a, h
	ldh  [hSFXCh4DataPtr_High], a
.decSfxTimer:
	; Tick down on the SFX note timer
	ld   hl, hSFXCh4LengthTimer		; NoteLength--
	dec  [hl]
	ret
	
; =============== Sound_DecodeNoteLen ===============
; Decodes the note length packed inside the low nybble of the command byte.
; IN
; - C: Raw command byte, from the sound channel data
; OUT
; - A: Unpacked length
Sound_DecodeNoteLen:

	;
	; Low nybble format:
	; ----HSSS
	;
	; - S -> Shift count.
	;      The base wait (128 ticks) will be shifted right by this much.
	; - H -> If set, the final result will be multiplied by 1.5.
	;
	; The formula used produces these waits:
	; $x0 -> 128 ticks
	; $x1 ->  64 ticks
	; $x2 ->  32 ticks
	; $x3 ->  16 ticks
	; $x4 ->   8 ticks
	; $x5 ->   4 ticks
	; $x6 ->   2 ticks
	; $x7 ->   1 ticks
	; $x8 -> 192 ticks
	; $x9 ->  96 ticks
	; $xA ->  48 ticks
	; $xB ->  24 ticks
	; $xC ->  12 ticks
	; $xD ->   6 ticks
	; $xE ->   3 ticks
	; $xF ->   1 ticks
	;
	
	; A = $80 >> (RawCmdId & 7)
	; Get shift count
	ld   a, c			; B = C & 7
	and  $07
	ld   b, a
	; Repeatedly shift left that amount of times
	ld   a, $80			; A = 128 ticks
	jr   z, .chkMul		; Count == 0? If so, use those as-is
.shLoop:
	srl  a				; A >>= 1
	dec  b				; Shifted all times?
	jr   nz, .shLoop	; If not, loop
	
.chkMul:
	; If bit3 is set, multiply the result by 1.5.
	; Which means adding half of the result.
	ld   b, a			; B = Result / 2
	srl  b
	bit  3, c			; Is the half flag set?
	jr   z, .end		; If not, skip
	add  b				; Otherwise, add that Result/2 over
.end:
	ret