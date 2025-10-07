; =============== Sound_BGMWavePtrTable ===============
; Waveform associated with the track.
Sound_BGMWavePtrTable:
	dw .set0 ; SND_MUTE
	dw .set0 ; BGM_TITLE        
	dw .set0 ; BGM_STAGESELECT  
	dw .set0 ; BGM_STAGESTART   
	dw .set0 ; BGM_PASSWORD     
	dw .set0 ; BGM_BOSS         
	dw .set0 ; BGM_STAGECLEAR   
	dw .set0 ; BGM_WEAPONGET    
	dw .set0 ; BGM_CRASHMAN     
	dw .set0 ; BGM_AIRMAN       
	dw .set0 ; BGM_METALMAN     
	dw .set0 ; BGM_HARDMAN      
	dw .set0 ; BGM_WOODMAN      
	dw .set0 ; BGM_TOPMAN       
	dw .set0 ; BGM_MAGNETMAN    
	dw .set0 ; BGM_NEEDLEMAN    
	dw .set0 ; BGM_WILYINTRO    
	dw .set0 ; BGM_WILYCASTLE   
	dw .set0 ; BGM_ENDING       
	dw .set0 ; BGM_UNUSEDENDING
	dw .set0 ; X
	dw .set0 ; X
	dw .set0 ; X
	dw .set0 ; X
	dw .set0 ; X
	dw .set0 ; X
	dw .set0 ; X
	dw .set0 ; X
	dw .set0 ; X
	dw .set0 ; X
	dw .set0 ; X
	dw .set0 ; X

.set0:	db $00,$55,$AA,$FF,$00,$55,$AA,$FF,$00,$55,$AA,$FF,$00,$55,$AA,$FF 
.set1:	db $00,$55,$AA,$FF,$AA,$55,$00,$55,$AA,$FF,$AA,$55,$00,$55,$AA,$FF ; X
.set2:	db $00,$22,$44,$66,$88,$AA,$CC,$EE,$FF,$DD,$BB,$99,$77,$55,$33,$11 ; X
.set3:	db $00,$ED,$FE,$C6,$00,$F5,$F3,$D5,$00,$F5,$FB,$D7,$00,$F5,$03,$C9 ; X