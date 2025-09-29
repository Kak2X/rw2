; =============== Act_BossIntro ===============
; Handles the boss intro sequence for all of the normal 8 bosses.
; It is imperative that this isn't called more after the intro is over,
; otherwise the player might behave oddly.
Act_BossIntro:
	; Execute code based on where we are in the intro sequence.
	; The wBossMode modes actually start all the way from being in the boss corridor,
	; however no code should be executed until the 2nd shutter closes, which sets us into mode $02.
	ld   a, [wBossMode]
	rst  $00 ; DynJump
	dw Act_SharedIntro_Wait ; BSMODE_NONE
	dw Act_SharedIntro_Wait ; BSMODE_CORRIDOR
	dw Act_SharedIntro_Init ; BSMODE_INIT
	dw Act_BossIntro_InitAnim ; BSMODE_INITANIM
	dw Act_BossIntro_PlayAnim ; BSMODE_PLAYANIM
	dw Act_SharedIntro_RefillBar ; BSMODE_REFILL
	dw Act_BossIntro_End ; BSMODE_END
	
; =============== Act_WilyIntro ===============
; Handles the boss intro sequence for all three phases of the Wily Machine.
; The main difference with Act_BossIntro is that routines that deal with animating
; the boss intro are replaced with generic delays, as the Wily bosses don't have them.
Act_WilyIntro:
	ld   a, [wBossMode]
	rst  $00 ; DynJump
	dw Act_SharedIntro_Wait ; BSMODE_NONE
	dw Act_SharedIntro_Wait ; BSMODE_CORRIDOR
	dw Act_SharedIntro_Init ; BSMODE_INIT
	dw Act_WilyIntro_Wait0 ; BSMODE_INITANIM
	dw Act_WilyIntro_Wait1 ; BSMODE_PLAYANIM
	dw Act_SharedIntro_RefillBar ; BSMODE_REFILL
	dw Act_WilyIntro_End ; BSMODE_END

; =============== Act_SharedIntro_Wait ===============
; SHARED | BSMODE_NONE-BSMODE_CORRIDOR
; Do nothing while waiting for the 2nd shutter to close.
Act_SharedIntro_Wait:
	ret
	
; =============== Act_SharedIntro_Init ===============
; SHARED | BSMODE_INIT
; Boss initialization code.
; When fighting multiple bosses in sequence (ie: the final boss), wBossMode
; needs to be manually reset to BSMODE_INIT to retrigger refilling the bar.
Act_SharedIntro_Init:
	; Prevent the player from moving as soon as the 2nd shutter closes,
	; leaving no wiggle room to control the player inbetween.
	; Controls will only be re-enabled once the entire intro ends.
	ld   a, PL_MODE_FROZEN
	ld   [wPlMode], a
	
	; Start with the health bar refill.
	; This is a purely visual effect that doesn't affect the boss' actual health.
	xor  a
	ld   [wBossIntroHealth], a	; Start from empty bar	
	ld   [wBossHealthBar], a	; ""
	ld   hl, wStatusBarRedraw	; Request drawing said empty bar
	set  BARID_BOSS, [hl]		
	
	; Wait half a second with the empty bar, while doing nothing.
	; Ideally, instead of doing nothing, it should have made the boss fall from the top of the screen.
	ld   a, 30
	ldh  [hActCur+iActTimer], a
	
	; Next mode
	ld   hl, wBossMode
	inc  [hl]
	
	; Play boss music.
	; For the purposes of this mod, boss music is level-specific.
	ld   hl, Lvl_BossBGMTbl
	ld   a, [wLvlId]
	ld   c, a
	ld   b, $00
	add  hl, bc
	ld   c, [hl]
	mPlayBGM
	ret
	
; =============== Act_BossIntro_InitAnim ===============
; BOSS-ONLY | BSMODE_INITANIM
; Delay, then set up intro anim.
Act_BossIntro_InitAnim:
	; Wait for that half a second with the empty life bar
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Set up the boss intro animation
	; Use sprites $00-$02 at 1/30 speed
	ld   de, ($00 << 8)|$02
	ld   c, 30
	call ActS_InitAnimRange
	
	ld   hl, wBossMode
	inc  [hl]
	ret
	
; =============== Act_WilyIntro_Wait0 ===============
; WILY-ONLY | BSMODE_INITANIM
; Generic delay, as the Wily bosses don't have intros like the men.
Act_WilyIntro_Wait0:
	; Wait that half a second
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Wait another half a second
	ld   a, 30
	ldh  [hActCur+iActTimer], a
	
	ld   hl, wBossMode
	inc  [hl]
	ret
	
; =============== Act_BossIntro_PlayAnim ===============
; BOSS-ONLY | BSMODE_PLAYANIM
Act_BossIntro_PlayAnim:
	; Wait until the boss intro animation finishes
	call ActS_PlayAnimRange
	ret  z
	; Then reset to sprite $01, by convention the intro pose
	ld   a, $01
	call ActS_SetSprMapId
	
	ld   hl, wBossMode
	inc  [hl]
	ret
	
; =============== Act_WilyIntro_Wait1 ===============
; WILY-ONLY | BSMODE_PLAYANIM
; Generic delay, as the Wily bosses don't have intros like the men.
Act_WilyIntro_Wait1:
	; Wait that half a second...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	ld   hl, wBossMode
	inc  [hl]
	ret
	
; =============== Act_SharedIntro_RefillBar ===============
; SHARED | BSMODE_REFILL
; Handle the boss health gauge refill.
Act_SharedIntro_RefillBar:
	; Increment health
	ld   a, [wBossIntroHealth]	; Health++
	inc  a
	ld   [wBossIntroHealth], a
	ld   [wBossHealthBar], a	; Set as drawn value
	
	; Trigger redraw, pointless unless a new bar is drawn though.
	; It could have been done alongside setting hSFXSet.
	ld   hl, wStatusBarRedraw
	set  BARID_BOSS, [hl]
	
	; Play the health refill sound for every new bar (every 8 units of health)
	ld   a, [wBossIntroHealth]
	and  $07					; Health % 8 != 0?
	jr   nz, .chkEnd			; If so, skip
	ld   c, SFX_CURSORMOVE
	mPlaySFX
.chkEnd:
	; Wait for the gauge to fully refill
	ld   a, [wBossIntroHealth]
	cp   BAR_MAX				; Fully refilled the gauge?
	ret  c						; If not, return
	
	ld   hl, wBossMode		; Otherwise, next mode
	inc  [hl]
	ret
	
; =============== Act_BossIntro_End ===============
; BOSS-ONLY | BSMODE_END
; End of the normal boss intro.
; [POI] When bosses mistakenly return to the intro routine, they execute just this part
;       as wBossMode is kept to the last value.
Act_BossIntro_End:
	; Set to sprite $00, by convention the normal standing pose.
	ld   a, $00
	call ActS_SetSprMapId
	
	; Unlock the player controls
	; This is the source of numerous issues when this is re-executed mid-fight.
	xor  a ; PL_MODE_GROUND		
	ld   [wPlMode], a			
	
	; Enable the boss damage mode, which allows the generic damage handler to update
	; the boss' health bar and its level ending explosion.
	inc  a						
	ld   [wBossDmgEna], a
	
	; Advance routine to the actor-specific code.
	; By convention, the intro routine is always $00, which will get incremented to $01 now.
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_WilyIntro_End ===============
; WILY-ONLY | BSMODE_END
; End of the Wily boss intro, almost identical to Act_BossIntro_End.
Act_WilyIntro_End:
	; Probably not necessary given Wily bosses don't animate in their intros
	ld   a, $00
	call ActS_SetSprMapId
	
	xor  a ; PL_MODE_GROUND		; Unlock the player controls
	ld   [wPlMode], a
	
	inc  a						; Enable the boss damage mode
	ld   [wBossDmgEna], a
	
	; The intro routine for Wily Bosses isn't necessarily executed in routine $00.
	; Why did this matter enough to split Act_BossIntro_End and Act_WilyIntro_End?
	ld   hl, hActCur+iActRtnId
	inc  [hl]
	ret
	
