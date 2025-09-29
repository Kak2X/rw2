; =============== Act_KaminariGoro ===============
; ID: ACT_KAMINARIGORO
; Enemy throwing lightning bolts on a rotating cloud platform.
; Spawned by the aforemented cloud platform (Act_KaminariCloud).
Act_KaminariGoro:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_KaminariGoro_Init
	dw Act_KaminariGoro_Move
	dw Act_KaminariGoro_Throw
	DEF ACTRTN_KAMINARIGORO_MOVE = $01

; =============== Act_KaminariGoro_Init ===============
Act_KaminariGoro_Init:
	;--
	; [POI] This doesn't matter because this actor's position is relative to the cloud
	ld   a, ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	;--
	
	; Wait ~2 seconds before throwing a lightning bolt.
	ld   a, $80
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_KaminariGoro_Move ===============
; Movement - holding lightning bolt.
Act_KaminariGoro_Move:
	; Use frames $00-$01 at 1/8 speed.
	; In this animation, the lightning bolt is being held and is baked in the sprites.
	; Note that $80 frames at 1/8 speed means it will end at frame ($80 / 8) % 2 = 0
	ld   c, $01
	call ActS_Anim2
	
	; Always track the player position
	call Act_KaminariGoro_SyncPos
	call ActS_FacePl
	
	; Wait for those ~2 seconds before throwing
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	;
	; Set up throw animation, which is handled in the next routine.
	;
	
	; Display the throw sprite ($02) for 16 frames
	; [BUG] This forgets to reset the relative sprite ID, which could have offset the sprite ID by $01.
	;       Thankfully, due to the animation length and speed used (($80 * 1/8) % 2 => 0) that offset 
	;       will always be $00,  but altering the throw timing will make the bug show up.
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	
	; Spawn the lightning bolt.
	; As it is being thrown from the hand, it should be spawned around there.
	; The spawn position is set to be 8px above and 8px in front of the actor's origin,
	; but for convenience the latter is set in the newly spawned actor's init code, so it's $00 for now.
	ld   a, ACT_KAMINARI
	ld   bc, ($00 << 8)|LOW(-$08) ; 8px up
	call ActS_SpawnRel
	
	jp   ActS_IncRtnId
	
; =============== Act_KaminariGoro_Throw ===============
; Movement - throw pose.
Act_KaminariGoro_Throw:
	; Display the throw sprite $03 for 16 frames.
	; [POI] This is identical to $02! Its data is separate copy of $02.
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	
	; Always track the player position
	call Act_KaminariGoro_SyncPos
	
	; Wait those 16 frames
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Done, materialize a new lightning bolt
	ld   a, $80							; Throw it after ~2 seconds
	ldh  [hActCur+iActTimer], a
	ld   a, ACTRTN_KAMINARIGORO_MOVE	; Back to the main routine
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_KaminariGoro_SyncPos ===============
; Syncronizes the actor's position with the cloud's.
; This is useful since the cloud moves in a complex circular path.
Act_KaminariGoro_SyncPos:
	ldh  a, [hActCur+iActGoroCloudXPtr]	; Seek HL to the cloud's iActX
	ld   l, a
	ld   h, HIGH(wAct)
	
	ldi  a, [hl] ; iActX		; X Position: CloudX (center)
	ldh  [hActCur+iActX], a
	
	inc  hl ; iActYSub
	ld   a, [hl] ; iActY		; Y Position: CloudY - $10 (on top of the cloud)
	sub  $10					; Consistent with the offset set in Act_KaminariCloud_Init
	ldh  [hActCur+iActY], a
	ret
	
