SECTION "Sound Driver Interface for the player", ROM0
SoundInt_Init: mHomeCallRet Sound_StopAll_Main
SoundInt_Do: mHomeCallRet Sound_Do_Main
SoundInt_ReqPlayId:	
	push hl
	push de
		ldh  a, [hROMBank]
		push af
			ld   a, BANK(Sound_ReqPlayId_Main)
			mBankswitch
			call Sound_ReqPlayId_Main
		pop  af
		mBankswitch
	pop  de
	pop  hl
	ret
	
SoundInt_SetVolume: mHomeCallRet Sound_SetVolume_Main
SoundInt_StartSlide: mHomeCallRet Sound_StartSlide_Main
Bankswitch:
	mBankswitch
	ret  