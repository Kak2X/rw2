; =============== ActS_ColiTbl ===============
; Collision table for each actor, indexed by ID.
; Each entry is $10 bytes long.
;
; These mostly follow the order they are stored in RAM, but not exactly:
; FORMAT (iRomActColi*)
; - 0: Collision box, horizontal radius
; - 1: Collision box, vertical radius
; - 2: Type
; - 3: Subtype (if type is ACTCOLI_PLATFORM) or Damage dealt (if ACTCOLI_ENEMYPASS, ACTCOLI_ENEMYHIT, ACTCOLI_ENEMYREFLECT)
; - 4: Health
; - 5: If set, override the default death sequence
; - 6: Damage received by the default weapon
; - 7: Damage received by Top Spin
; - 8: Damage received by Air Shooter
; - 9: Damage received by Leaf Shield
; - A: Damage received by Metal Blade
; - B: Damage received by Crash Bomb
; - C: Damage received by Needle Cannon
; - D: Damage received by Hard Knuckle
; - E: Damage received by Magnet Missile 
; - F: Damage received by Sakugarne
ActS_ColiTbl:
	;  H   V    TYPE                   DAMAGE/SUBTYPE        LIFE SPEC   P  TP  AR  WD  ME  CR  NE  HA  MG  SG
	db $00,$00, ACTCOLI_PASS         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_EXPLSM           ;X
	db $06,$06, ACTCOLI_ITEM         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_1UP             
	db $06,$06, ACTCOLI_ITEM         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_AMMOLG          
	db $06,$06, ACTCOLI_ITEM         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_HEALTHLG        
	db $03,$03, ACTCOLI_ITEM         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_HEALTHSM        
	db $03,$03, ACTCOLI_ITEM         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_AMMOSM          
	db $06,$06, ACTCOLI_ITEM         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_ETANK           
	db $00,$00, ACTCOLI_PASS         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_EXPLLGPART      
	db $0B,$07, ACTCOLI_ENEMYHIT     , $1E                 , $03, $01, $01,$00,$00,$01,$01,$03,$01,$03,$01,$03 ; ACT_BEE             
	db $0B,$08, ACTCOLI_ENEMYREFLECT , $0A                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_BEEHIVE         
	db $07,$03, ACTCOLI_ENEMYHIT     , $0F                 , $01, $00, $01,$00,$00,$01,$01,$01,$01,$01,$01,$01 ; ACT_CHIBEE          
	db $07,$0B, ACTCOLI_ENEMYREFLECT , $14                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_WANAAN          
	db $0B,$0F, ACTCOLI_ENEMYREFLECT , $14                 , $08, $01, $01,$00,$00,$01,$02,$04,$01,$08,$04,$08 ; ACT_HAMMERJOE       
	db $03,$03, ACTCOLI_ENEMYREFLECT , $0A                 , $01, $00, $00,$01,$00,$00,$00,$00,$00,$01,$01,$01 ; ACT_HAMMER          
	db $0B,$0B, ACTCOLI_ENEMYHIT     , $0F                 , $08, $00, $01,$08,$00,$01,$01,$04,$01,$08,$02,$08 ; ACT_NEOMONKING      
	db $07,$07, ACTCOLI_ENEMYREFLECT , $14                 , $01, $00, $01,$01,$01,$01,$01,$01,$01,$01,$01,$00 ; ACT_NEOMET          
	db $0F,$17, ACTCOLI_PARTIAL|-$08 , $1E                 , $03, $00, $01,$00,$00,$01,$01,$03,$01,$03,$02,$00 ; ACT_PICKELBULL      
	db $0F,$13, ACTCOLI_ENEMYREFLECT , $28                 , $06, $00, $01,$00,$02,$01,$02,$03,$01,$06,$00,$06 ; ACT_BIKKY           
	db $0B,$0B, ACTCOLI_ENEMYHIT     , $1E                 , $06, $00, $01,$06,$03,$03,$02,$06,$01,$02,$02,$06 ; ACT_KOMASABURO      
	db $06,$06, ACTCOLI_ENEMYHIT     , $0F                 , $01, $00, $01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; ACT_KOMA            
	db $07,$03, ACTCOLI_ENEMYHIT     , $0F                 , $01, $00, $01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; ACT_MECHAKKERO      
	db $0B,$09, ACTCOLI_PLATFORM     , ACTCOLISUB_SPINTOP  , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_SPINTOPU        
	db $0B,$09, ACTCOLI_PLATFORM     , ACTCOLISUB_SPINTOP  , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_SPINTOPD        
	db $17,$0F, ACTCOLI_ENEMYHIT     , $28                 , $10, $01, $01,$00,$00,$01,$02,$05,$01,$03,$02,$03 ; ACT_TAMA            
	db $04,$04, ACTCOLI_ENEMYHIT     , $14                 , $04, $00, $01,$00,$00,$01,$02,$02,$01,$02,$02,$02 ; ACT_TAMABALL        
	db $03,$05, ACTCOLI_ENEMYHIT     , $0A                 , $01, $00, $01,$00,$00,$01,$01,$01,$01,$01,$01,$01 ; ACT_TAMAFLEA        
	db $08,$08, ACTCOLI_ENEMYHIT     , $14                 , $01, $00, $01,$01,$00,$01,$01,$01,$01,$01,$00,$01 ; ACT_MAGFLY          
	db $0B,$0B, ACTCOLI_ENEMYHIT     , $28                 , $08, $00, $01,$00,$00,$00,$02,$04,$01,$02,$02,$02 ; ACT_GSPRINGER       
	db $03,$03, ACTCOLI_ENEMYHIT     , $14                 , $01, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_GSPRINGERSHOT   
	db $0B,$07, ACTCOLI_ENEMYHIT     , $14                 , $03, $00, $01,$03,$01,$03,$01,$02,$01,$03,$02,$03 ; ACT_PETERCHY        
	db $37,$0E, ACTCOLI_MAGNET       , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_MAGNETFIELD     
	db $00,$00, ACTCOLI_PASS         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_RESPAWNER        ;X
	db $07,$04, ACTCOLI_PLATFORM     , ACTCOLISUB_TOPSOLID , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_BLOCK0          
	db $07,$04, ACTCOLI_PLATFORM     , ACTCOLISUB_TOPSOLID , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_BLOCK1          
	db $07,$04, ACTCOLI_PLATFORM     , ACTCOLISUB_TOPSOLID , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_BLOCK2          
	db $07,$04, ACTCOLI_PLATFORM     , ACTCOLISUB_TOPSOLID , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_BLOCK3          
	db $07,$07, ACTCOLI_ENEMYHIT     , $14                 , $03, $00, $01,$03,$03,$01,$01,$02,$01,$03,$02,$03 ; ACT_NEWSHOTMAN      
	db $03,$03, ACTCOLI_ENEMYREFLECT , $1E                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_NEEDLEPRESS     
	db $0B,$03, ACTCOLI_ENEMYHIT     , $0F                 , $03, $00, $01,$03,$02,$02,$01,$03,$01,$03,$03,$03 ; ACT_YAMBOW          
	db $0B,$07, ACTCOLI_ENEMYREFLECT , $1E                 , $06, $00, $01,$06,$00,$02,$02,$03,$01,$02,$02,$03 ; ACT_HARI            
	db $03,$03, ACTCOLI_ENEMYHIT     , $0A                 , $01, $00, $01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; ACT_HARISHOT        
	db $0B,$07, ACTCOLI_ENEMYREFLECT , $1E                 , $03, $00, $01,$00,$00,$02,$02,$03,$01,$03,$03,$03 ; ACT_CANNON          
	db $03,$03, ACTCOLI_ENEMYHIT     , $14                 , $01, $00, $00,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; ACT_CANNONSHOT      
	db $00,$00, ACTCOLI_PASS         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_TELLYSPAWN      
	db $07,$05, ACTCOLI_PLATFORM     , ACTCOLISUB_TOPSOLID , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_LIFT0           
	db $07,$05, ACTCOLI_PLATFORM     , ACTCOLISUB_TOPSOLID , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_LIFT1           
	db $07,$05, ACTCOLI_PLATFORM     , ACTCOLISUB_TOPSOLID , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_LIFT2           
	db $07,$07, ACTCOLI_ENEMYREFLECT , $28                 , $01, $01, $01,$00,$00,$00,$01,$01,$01,$01,$01,$00 ; ACT_BLOCKYHEAD      
	db $07,$07, ACTCOLI_ENEMYREFLECT , $14                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_BLOCKYBODY      
	db $07,$07, ACTCOLI_ENEMYREFLECT , $14                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_BLOCKYRISE      
	db $07,$07, ACTCOLI_ENEMYHIT     , $14                 , $01, $01, $01,$00,$01,$01,$01,$01,$01,$01,$01,$01 ; ACT_PIPI            
	db $03,$03, ACTCOLI_ENEMYHIT     , $14                 , $01, $00, $01,$00,$01,$01,$01,$01,$01,$01,$01,$01 ; ACT_EGG             
	db $03,$03, ACTCOLI_ENEMYHIT     , $0A                 , $01, $00, $01,$00,$01,$01,$01,$01,$01,$01,$01,$01 ; ACT_COPIPI          
	db $0B,$0B, ACTCOLI_ENEMYHIT     , $14                 , $05, $00, $01,$05,$02,$05,$01,$05,$01,$05,$02,$05 ; ACT_SHOTMAN         
	db $0B,$0F, ACTCOLI_ENEMYHIT     , $14                 , $05, $00, $01,$05,$05,$02,$01,$05,$01,$05,$02,$05 ; ACT_FLYBOY          
	db $00,$00, ACTCOLI_PASS         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_FLYBOYSPAWN     
	db $07,$03, ACTCOLI_ENEMYHIT     , $14                 , $01, $00, $00,$00,$00,$01,$00,$01,$00,$01,$00,$01 ; ACT_SPRINGER        
	db $0B,$0B, ACTCOLI_ENEMYHIT     , $14                 , $06, $01, $01,$00,$00,$02,$00,$06,$01,$06,$02,$06 ; ACT_PIEROGEAR       
	db $0B,$0B, ACTCOLI_ENEMYHIT     , $1E                 , $05, $01, $05,$00,$05,$05,$01,$05,$01,$05,$03,$05 ; ACT_PIEROBOT        
	db $03,$0B, ACTCOLI_ENEMYHIT     , $14                 , $05, $00, $01,$05,$02,$05,$02,$05,$01,$05,$02,$00 ; ACT_MOLE            
	db $00,$00, ACTCOLI_PASS         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_MOLESPAWN       
	db $0A,$07, ACTCOLI_ENEMYREFLECT , $28                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_PRESS           
	db $0B,$0B, ACTCOLI_ENEMYHIT     , $1E                 , $06, $00, $01,$00,$00,$06,$02,$06,$01,$06,$02,$06 ; ACT_ROBBIT          
	db $03,$03, ACTCOLI_ENEMYPASS    , $0A                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_CARROT          
	db $07,$0F, ACTCOLI_ENEMYHIT     , $14                 , $04, $00, $01,$04,$00,$00,$04,$04,$01,$04,$04,$04 ; ACT_COOK            
	db $00,$00, ACTCOLI_PASS         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_COOKSPAWN       
	db $07,$07, ACTCOLI_ENEMYREFLECT , $14                 , $02, $00, $01,$02,$02,$02,$02,$02,$01,$02,$02,$02 ; ACT_BATTON          
	db $0F,$0F, ACTCOLI_ENEMYHIT     , $28                 , $10, $01, $01,$00,$00,$0A,$01,$00,$01,$05,$03,$0A ; ACT_FRIENDER        
	db $07,$07, ACTCOLI_ENEMYPASS    , $1E                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_FLAME           
	db $03,$03, ACTCOLI_ENEMYREFLECT , $0A                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_GOBLINHORN      
	db $00,$00, ACTCOLI_PASS         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_GOBLIN          
	db $06,$06, ACTCOLI_ENEMYHIT     , $0A                 , $01, $00, $01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; ACT_PUCHIGOBLIN     
	db $07,$03, ACTCOLI_ENEMYHIT     , $14                 , $05, $00, $01,$05,$05,$02,$02,$05,$01,$05,$02,$05 ; ACT_SCWORMBASE      
	db $03,$07, ACTCOLI_ENEMYHIT     , $0A                 , $02, $00, $01,$02,$00,$02,$02,$02,$01,$02,$01,$02 ; ACT_SCWORMSHOT      
	db $0B,$0B, ACTCOLI_ENEMYHIT     , $1E                 , $05, $00, $01,$00,$00,$05,$01,$02,$01,$05,$02,$05 ; ACT_MATASABURO      
	db $0B,$07, ACTCOLI_ENEMYHIT     , $14                 , $03, $00, $01,$00,$03,$03,$01,$03,$01,$03,$02,$03 ; ACT_KAMINARIGORO    
	db $0B,$09, ACTCOLI_PLATFORM     , ACTCOLISUB_TOPSOLID , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_KAMINARICLOUD   
	db $07,$07, ACTCOLI_ENEMYPASS    , $14                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_KAMINARI        
	db $07,$07, ACTCOLI_ENEMYHIT     , $14                 , $01, $00, $01,$00,$01,$01,$01,$01,$01,$01,$01,$01 ; ACT_TELLY           
	db $00,$00, ACTCOLI_PASS         , $FF                 , $FF, $00, $01,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_PIPISPAWN       
	db $0F,$17, ACTCOLI_PARTIAL|-$10 , $20                 , $13, $00, $01,$00,$00,$00,$00,$00,$00,$00,$00,$02 ; ACT_WILY1           
	db $0F,$13, ACTCOLI_ENEMYREFLECT , $20                 , $13, $00, $01,$00,$00,$00,$00,$00,$00,$00,$00,$02 ; ACT_WILY2           
	db $0F,$17, ACTCOLI_ENEMYREFLECT , $20                 , $13, $00, $01,$00,$00,$00,$00,$00,$00,$00,$00,$02 ; ACT_WILY3           
	db $07,$15, ACTCOLI_PARTIAL|-$0C , $20                 , $20, $01, $01,$01,$02,$02,$02,$04,$02,$06,$02,$00 ; ACT_QUINT           
	db $00,$00, ACTCOLI_PASS         , $20                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_WILY3PART       
	db $0F,$0F, ACTCOLI_ENEMYREFLECT , $20                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_WILY2INTRO      
	db $07,$07, ACTCOLI_ENEMYHIT     , $20                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_QUINT_SG        
	db $03,$03, ACTCOLI_ENEMYPASS    , $10                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_QUINT_DEBRIS    
	db $07,$07, ACTCOLI_ENEMYPASS    , $10                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_WILY1BOMB       
	db $07,$07, ACTCOLI_ENEMYPASS    , $10                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_WILY1NAIL       
	db $07,$07, ACTCOLI_ENEMYPASS    , $10                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_WILY2BOMB       
	db $07,$07, ACTCOLI_ENEMYPASS    , $18                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_WILY2SHOT       
	db $07,$07, ACTCOLI_ENEMYPASS    , $10                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_WILY3MISSILE    
	db $07,$07, ACTCOLI_ENEMYPASS    , $10                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_WILY3MET        
	db $0F,$0B, ACTCOLI_ENEMYREFLECT , $20                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_WILYCTRL        
	db $00,$00, ACTCOLI_PASS         , $00                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_5F               ;X
	db $07,$07, ACTCOLI_PLATFORM     , ACTCOLISUB_RC       , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_WPN_RC          
	db $07,$04, ACTCOLI_PLATFORM     , ACTCOLISUB_RM       , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_WPN_RM          
	db $07,$04, ACTCOLI_PLATFORM     , ACTCOLISUB_RJ       , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_WPN_RJ          
	db $07,$04, ACTCOLI_PLATFORM     , ACTCOLISUB_SG       , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_WPN_SG          
	db $00,$00, ACTCOLI_PASS         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_BUBBLE          
	db $00,$00, ACTCOLI_PASS         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_WILYCASTLESC    
	db $00,$00, ACTCOLI_PASS         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_TELEPORTCTRL    
	db $00,$00, ACTCOLI_PASS         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_TELEPORTLIGHT   
	db $0B,$0B, ACTCOLI_ENEMYHIT     , $20                 , $13, $00, $01,$00,$00,$00,$01,$01,$00,$03,$04,$02 ; ACT_HARDMAN         
	db $0B,$0B, ACTCOLI_ENEMYHIT     , $20                 , $13, $00, $01,$00,$01,$00,$00,$00,$02,$04,$01,$02 ; ACT_TOPMAN          
	db $0B,$0B, ACTCOLI_ENEMYHIT     , $20                 , $13, $00, $01,$01,$00,$00,$02,$01,$03,$02,$03,$02 ; ACT_MAGNETMAN       
	db $0B,$0B, ACTCOLI_ENEMYHIT     , $20                 , $13, $00, $01,$05,$03,$00,$00,$01,$00,$00,$01,$02 ; ACT_NEEDLEMAN       
	db $0B,$0B, ACTCOLI_ENEMYHIT     , $20                 , $13, $00, $01,$00,$02,$00,$00,$00,$00,$00,$00,$00 ; ACT_CRASHMAN        
	db $0B,$0B, ACTCOLI_ENEMYHIT     , $20                 , $13, $00, $01,$00,$00,$00,$0A,$05,$00,$00,$00,$00 ; ACT_METALMAN        
	db $0B,$0B, ACTCOLI_ENEMYHIT     , $20                 , $13, $00, $01,$00,$01,$00,$05,$02,$00,$00,$00,$00 ; ACT_WOODMAN         
	db $0B,$0B, ACTCOLI_ENEMYHIT     , $20                 , $13, $00, $01,$00,$00,$07,$00,$00,$00,$00,$00,$00 ; ACT_AIRMAN          
	db $06,$03, ACTCOLI_ENEMYHIT     , $08                 , $01, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_HARDKNUCKLE     
	db $06,$06, ACTCOLI_ENEMYHIT     , $10                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_SPINTOPSHOT     
	db $04,$04, ACTCOLI_ENEMYHIT     , $10                 , $01, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_MAGNETMISSILE   
	db $06,$03, ACTCOLI_ENEMYHIT     , $08                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_NEEDLECANNON    
	db $03,$03, ACTCOLI_ENEMYREFLECT , $10                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_CRASHBOMB       
	db $03,$03, ACTCOLI_ENEMYPASS    , $08                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_METALBLADE      
	db $04,$06, ACTCOLI_ENEMYREFLECT , $10                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_WHIRLWIND       
	db $04,$03, ACTCOLI_ENEMYREFLECT , $08                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_LEAFSHIELD      
	db $03,$04, ACTCOLI_ENEMYREFLECT , $08                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_LEAFRISE        
	db $03,$03, ACTCOLI_ENEMYREFLECT , $08                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_LEAFFALL        
	db $0F,$0F, ACTCOLI_ENEMYPASS    , $10                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_CRASHBOMBEXPL   
	db $00,$00, ACTCOLI_PASS         , $FF                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_GROUNDEXPL      
	db $03,$03, ACTCOLI_ENEMYPASS    , $08                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_NEOMETSHOT      
	db $03,$03, ACTCOLI_ENEMYPASS    , $08                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_NEWSHOTMANSHOTV 
	db $03,$03, ACTCOLI_ENEMYPASS    , $08                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_NEWSHOTMANSHOTH 
	db $03,$03, ACTCOLI_ENEMYPASS    , $08                 , $FF, $00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACT_SHOTMANSHOT     
