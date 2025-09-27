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
   
; =============== ActS_SprMapPtrTbl ===============
; Sprite mapping tables for each actor.
ActS_SprMapPtrTbl:
	dw ExplSm_SprMapPtrTbl             ; ACT_EXPLSM
	dw ExtraLife_SprMapPtrTbl          ; ACT_1UP
	dw AmmoLg_SprMapPtrTbl             ; ACT_AMMOLG
	dw HealthLg_SprMapPtrTbl           ; ACT_HEALTHLG
	dw HealthSm_SprMapPtrTbl           ; ACT_HEALTHSM
	dw AmmoSm_SprMapPtrTbl             ; ACT_AMMOSM
	dw ETank_SprMapPtrTbl              ; ACT_ETANK
	dw ExplLgPart_SprMapPtrTbl         ; ACT_EXPLLGPART
	dw Bee_SprMapPtrTbl                ; ACT_BEE
	dw BeeHive_SprMapPtrTbl            ; ACT_BEEHIVE
	dw Chibee_SprMapPtrTbl             ; ACT_CHIBEE
	dw Wanaan_SprMapPtrTbl             ; ACT_WANAAN
	dw HammerJoe_SprMapPtrTbl          ; ACT_HAMMERJOE
	dw Hammer_SprMapPtrTbl             ; ACT_HAMMER
	dw NeoMonking_SprMapPtrTbl         ; ACT_NEOMONKING
	dw NeoMet_SprMapPtrTbl             ; ACT_NEOMET
	dw PickelmanBull_SprMapPtrTbl      ; ACT_PICKELBULL
	dw Bikky_SprMapPtrTbl              ; ACT_BIKKY
	dw Komasaburo_SprMapPtrTbl         ; ACT_KOMASABURO
	dw Koma_SprMapPtrTbl               ; ACT_KOMA
	dw Mechakkero_SprMapPtrTbl         ; ACT_MECHAKKERO
	dw SpinTopU_SprMapPtrTbl           ; ACT_SPINTOPU
	dw SpinTopD_SprMapPtrTbl           ; ACT_SPINTOPD
	dw Tama_SprMapPtrTbl               ; ACT_TAMA
	dw TamaBall_SprMapPtrTbl           ; ACT_TAMABALL
	dw TamaFlea_SprMapPtrTbl           ; ACT_TAMAFLEA
	dw MagFly_SprMapPtrTbl             ; ACT_MAGFLY
	dw GiantSpringer_SprMapPtrTbl      ; ACT_GSPRINGER
	dw GiantSpringerShot_SprMapPtrTbl  ; ACT_GSPRINGERSHOT
	dw Peterchy_SprMapPtrTbl           ; ACT_PETERCHY
	dw MagnetField_SprMapPtrTbl        ; ACT_MAGNETFIELD
	dw Respawner_SprMapPtrTbl          ; ACT_RESPAWNER       ;X
	dw Block_SprMapPtrTbl              ; ACT_BLOCK0
	dw Block_SprMapPtrTbl              ; ACT_BLOCK1
	dw Block_SprMapPtrTbl              ; ACT_BLOCK2
	dw Block_SprMapPtrTbl              ; ACT_BLOCK3
	dw NewShotman_SprMapPtrTbl         ; ACT_NEWSHOTMAN
	dw NeedlePress_SprMapPtrTbl        ; ACT_NEEDLEPRESS
	dw Yambow_SprMapPtrTbl             ; ACT_YAMBOW
	dw HariHarry_SprMapPtrTbl          ; ACT_HARI
	dw HariHarryShot_SprMapPtrTbl      ; ACT_HARISHOT
	dw Cannon_SprMapPtrTbl             ; ACT_CANNON
	dw CannonShot_SprMapPtrTbl         ; ACT_CANNONSHOT
	dw TellySpawner_SprMapPtrTbl       ; ACT_TELLYSPAWN
	dw Lift_SprMapPtrTbl               ; ACT_LIFT0
	dw Lift_SprMapPtrTbl               ; ACT_LIFT1
	dw Lift_SprMapPtrTbl               ; ACT_LIFT2
	dw BlockyHead_SprMapPtrTbl         ; ACT_BLOCKYHEAD
	dw BlockyBody_SprMapPtrTbl         ; ACT_BLOCKYBODY
	dw BlockyBody_SprMapPtrTbl         ; ACT_BLOCKYRISE
	dw Pipi_SprMapPtrTbl               ; ACT_PIPI
	dw Egg_SprMapPtrTbl                ; ACT_EGG
	dw Copipi_SprMapPtrTbl             ; ACT_COPIPI
	dw Shotman_SprMapPtrTbl            ; ACT_SHOTMAN
	dw FlyBoy_SprMapPtrTbl             ; ACT_FLYBOY
	dw FlyBoySpawner_SprMapPtrTbl      ; ACT_FLYBOYSPAWN
	dw Springer_SprMapPtrTbl           ; ACT_SPRINGER
	dw PieroBotGear_SprMapPtrTbl       ; ACT_PIEROGEAR
	dw PieroBot_SprMapPtrTbl           ; ACT_PIEROBOT
	dw Mole_SprMapPtrTbl               ; ACT_MOLE
	dw MoleSpawner_SprMapPtrTbl        ; ACT_MOLESPAWN
	dw Press_SprMapPtrTbl              ; ACT_PRESS
	dw Robbit_SprMapPtrTbl             ; ACT_ROBBIT
	dw RobbitCarrot_SprMapPtrTbl       ; ACT_CARROT
	dw Cook_SprMapPtrTbl               ; ACT_COOK
	dw CookSpawner_SprMapPtrTbl        ; ACT_COOKSPAWN
	dw Batton_SprMapPtrTbl             ; ACT_BATTON
	dw Friender_SprMapPtrTbl           ; ACT_FRIENDER
	dw FrienderFlame_SprMapPtrTbl      ; ACT_FLAME
	dw GoblinHorn_SprMapPtrTbl         ; ACT_GOBLINHORN
	dw Goblin_SprMapPtrTbl             ; ACT_GOBLIN
	dw PuchiGoblin_SprMapPtrTbl        ; ACT_PUCHIGOBLIN
	dw ScwormBase_SprMapPtrTbl         ; ACT_SCWORMBASE
	dw ScwormShot_SprMapPtrTbl         ; ACT_SCWORMSHOT
	dw Matasaburo_SprMapPtrTbl         ; ACT_MATASABURO
	dw KaminariGoro_SprMapPtrTbl       ; ACT_KAMINARIGORO
	dw KaminariCloud_SprMapPtrTbl      ; ACT_KAMINARICLOUD
	dw Kaminari_SprMapPtrTbl           ; ACT_KAMINARI
	dw Telly_SprMapPtrTbl              ; ACT_TELLY
	dw PipiSpawner_SprMapPtrTbl        ; ACT_PIPISPAWN
	dw Wily1_SprMapPtrTbl              ; ACT_WILY1
	dw Wily2_SprMapPtrTbl              ; ACT_WILY2
	dw Wily3_SprMapPtrTbl              ; ACT_WILY3
	dw Quint_SprMapPtrTbl              ; ACT_QUINT
	dw Wily3Part_SprMapPtrTbl          ; ACT_WILY3PART
	dw Wily2Intro_SprMapPtrTbl         ; ACT_WILY2INTRO
	dw QuintSakugarne_SprMapPtrTbl     ; ACT_QUINT_SG
	dw QuintDebris_SprMapPtrTbl        ; ACT_QUINT_DEBRIS
	dw Wily1Bomb_SprMapPtrTbl          ; ACT_WILY1BOMB
	dw Wily1Nail_SprMapPtrTbl          ; ACT_WILY1NAIL
	dw Wily2Bomb_SprMapPtrTbl          ; ACT_WILY2BOMB
	dw Wily2Shot_SprMapPtrTbl          ; ACT_WILY2SHOT
	dw Wily3Missile_SprMapPtrTbl       ; ACT_WILY3MISSILE
	dw Wily3Met_SprMapPtrTbl           ; ACT_WILY3MET
	dw WilyCtrl_SprMapPtrTbl           ; ACT_WILYCTRL
	dw Null_SprMapPtrTbl               ; ACT_5F              ;X
	dw RushCoil_SprMapPtrTbl           ; ACT_WPN_RC
	dw RushMarine_SprMapPtrTbl         ; ACT_WPN_RM
	dw RushJet_SprMapPtrTbl            ; ACT_WPN_RJ
	dw Sakugarne_SprMapPtrTbl          ; ACT_WPN_SG
	dw Bubble_SprMapPtrTbl             ; ACT_BUBBLE
	dw WilyCastleCutscene_SprMapPtrTbl ; ACT_WILYCASTLESC
	dw TeleporterRoom_SprMapPtrTbl     ; ACT_TELEPORTCTRL
	dw TeleporterLight_SprMapPtrTbl    ; ACT_TELEPORTLIGHT
	dw HardMan_SprMapPtrTbl            ; ACT_HARDMAN
	dw TopMan_SprMapPtrTbl             ; ACT_TOPMAN
	dw MagnetMan_SprMapPtrTbl          ; ACT_MAGNETMAN
	dw NeedleMan_SprMapPtrTbl          ; ACT_NEEDLEMAN
	dw CrashMan_SprMapPtrTbl           ; ACT_CRASHMAN
	dw MetalMan_SprMapPtrTbl           ; ACT_METALMAN
	dw WoodMan_SprMapPtrTbl            ; ACT_WOODMAN
	dw AirMan_SprMapPtrTbl             ; ACT_AIRMAN
	dw HardKnuckle_SprMapPtrTbl        ; ACT_HARDKNUCKLE
	dw TopManShot_SprMapPtrTbl         ; ACT_SPINTOPSHOT
	dw MagnetManShot_SprMapPtrTbl      ; ACT_MAGNETMISSILE
	dw NeedleManShot_SprMapPtrTbl      ; ACT_NEEDLECANNON
	dw CrashManShot_SprMapPtrTbl       ; ACT_CRASHBOMB
	dw MetalManShot_SprMapPtrTbl       ; ACT_METALBLADE
	dw AirManShot_SprMapPtrTbl         ; ACT_WHIRLWIND
	dw WoodManLeafShield_SprMapPtrTbl  ; ACT_LEAFSHIELD
	dw WoodManLeafRise_SprMapPtrTbl    ; ACT_LEAFRISE
	dw WoodManLeafFall_SprMapPtrTbl    ; ACT_LEAFFALL
	dw CrashManShotExpl_SprMapPtrTbl   ; ACT_CRASHBOMBEXPL
	dw GroundExpl_SprMapPtrTbl         ; ACT_GROUNDEXPL
	dw Shot_SprMapPtrTbl               ; ACT_NEOMETSHOT
	dw Shot_SprMapPtrTbl               ; ACT_NEWSHOTMANSHOTV
	dw Shot_SprMapPtrTbl               ; ACT_NEWSHOTMANSHOTH
	dw Shot_SprMapPtrTbl               ; ACT_SHOTMANSHOT
    
; =============== Pl_SprMapPtrTbl ===============
; Sprite mapping table for the player.
Pl_SprMapPtrTbl:
	dw SprMap_Pl_Walk0                 ; PLSPR_WALK0   
	dw SprMap_Pl_Walk1                 ; PLSPR_WALK1   
	dw SprMap_Pl_Walk2                 ; PLSPR_WALK2   
	dw SprMap_Pl_Walk1                 ; PLSPR_WALK3   
	dw SprMap_Pl_Idle                  ; PLSPR_IDLE    
	dw SprMap_Pl_Blink                 ; PLSPR_BLINK   
	dw SprMap_Pl_SideStep              ; PLSPR_SIDESTEP
	dw SprMap_Pl_Jump                  ; PLSPR_JUMP    
	dw SprMap_Pl_ClimbTop              ; PLSPR_CLIMBTOP
	dw SprMap_Pl_Climb                 ; PLSPR_CLIMB   
	dw SprMap_Pl_ThrowSlide            ; PLSPR_SLIDE   
	dw SprMap_Pl_Null                  ; ;X
	dw SprMap_Pl_Null                  ; ;X
	dw SprMap_Pl_Null                  ; ;X
	dw SprMap_Pl_Null                  ; ;X
	dw SprMap_Pl_Null                  ; ;X
	dw SprMap_Pl_ShootWalk0            ; PLSPR_WALK0   
	dw SprMap_Pl_ShootWalk1            ; PLSPR_WALK1   
	dw SprMap_Pl_ShootWalk2            ; PLSPR_WALK2   
	dw SprMap_Pl_ShootWalk1            ; PLSPR_WALK3   
	dw SprMap_Pl_ShootIdle             ; PLSPR_IDLE    
	dw SprMap_Pl_ShootIdle             ; PLSPR_BLINK   
	dw SprMap_Pl_ShootIdle             ; PLSPR_SIDESTEP
	dw SprMap_Pl_ShootJump             ; PLSPR_JUMP    
	dw SprMap_Pl_ShootClimb            ; PLSPR_CLIMBTOP
	dw SprMap_Pl_ShootClimb            ; PLSPR_CLIMB   
	dw SprMap_Pl_ThrowSlide            ; PLSPR_SLIDE   
	dw SprMap_Pl_Null                  ; ;X
	dw SprMap_Pl_SgIdle                ; PLSPR_SG_IDLE
	dw SprMap_Pl_SgJump                ; PLSPR_SG_JUMP
	dw SprMap_Pl_Null                  ; ;X
	dw SprMap_Pl_Null                  ; ;X
	dw SprMap_Pl_ThrowWalk0            ; PLSPR_WALK0   
	dw SprMap_Pl_ThrowWalk1            ; PLSPR_WALK1   
	dw SprMap_Pl_ThrowWalk2            ; PLSPR_WALK2   
	dw SprMap_Pl_ThrowWalk1            ; PLSPR_WALK3   
	dw SprMap_Pl_ThrowIdle             ; PLSPR_IDLE    
	dw SprMap_Pl_ThrowIdle             ; PLSPR_BLINK   
	dw SprMap_Pl_ThrowIdle             ; PLSPR_SIDESTEP
	dw SprMap_Pl_ThrowJump             ; PLSPR_JUMP    
	dw SprMap_Pl_ThrowClimb            ; PLSPR_CLIMBTOP
	dw SprMap_Pl_ThrowClimb            ; PLSPR_CLIMB   
	dw SprMap_Pl_ThrowSlide            ; PLSPR_SLIDE   
	dw SprMap_Pl_Null                  ; ;X
	dw SprMap_Pl_SgIdle                ; ;X
	dw SprMap_Pl_SgJump                ; ;X
	dw SprMap_Pl_Null                  ; ;X
	dw SprMap_Pl_Null                  ; ;X
	dw SprMap_Pl_Hurt                  ; PLSPR_HURT
	dw SprMap_Warp                     ; PLSPR_WARP
	dw SprMap_WarpLand3                ; PLSPR_WARPLAND0
	dw SprMap_WarpLand2                ; PLSPR_WARPLAND1
	dw SprMap_WarpLand1                ; PLSPR_WARPLAND2
	dw SprMap_WarpLand0                ; PLSPR_WARPLAND3

; =============== ACTOR SPRITE MAPPING TABLES ===============
Null_SprMapPtrTbl:
	dw SprMap_Null
ExplSm_SprMapPtrTbl:
	dw SprMap_Expl0
	dw SprMap_Expl1
	dw SprMap_Expl2
ExtraLife_SprMapPtrTbl:
	dw SprMap_ExtraLife
	dw SprMap_ExtraLife
	dw SprMap_Null
AmmoLg_SprMapPtrTbl:
	dw SprMap_AmmoLg0
	dw SprMap_AmmoLg1
	dw SprMap_Null
HealthLg_SprMapPtrTbl:
	dw SprMap_HealthLg0
	dw SprMap_HealthLg1
	dw SprMap_Null
HealthSm_SprMapPtrTbl:
	dw SprMap_HealthSm0
	dw SprMap_HealthSm1
	dw SprMap_Null
AmmoSm_SprMapPtrTbl:
	dw SprMap_AmmoSm0
	dw SprMap_AmmoSm1
	dw SprMap_Null
ETank_SprMapPtrTbl:
	dw SprMap_ETank
	dw SprMap_ETank
	dw SprMap_Null;X
ExplLgPart_SprMapPtrTbl:
	dw SprMap_Expl0
	dw SprMap_Expl1
	dw SprMap_Expl2
Bee_SprMapPtrTbl:
	dw SprMap_Bee0
	dw SprMap_Bee1
BeeHive_SprMapPtrTbl:
	dw SprMap_BeeHive
Chibee_SprMapPtrTbl:
	dw SprMap_Chibee_Expl0
	dw SprMap_Chibee_Expl1
	dw SprMap_Chibee_Expl2
	dw SprMap_Chibee_Fly0
	dw SprMap_Chibee_Fly1
Wanaan_SprMapPtrTbl:
	dw SprMap_Null
	dw SprMap_Wanaan_Open
	dw SprMap_Wanaan_Close
HammerJoe_SprMapPtrTbl:
	dw SprMap_HammerJoe_SwClose0
	dw SprMap_HammerJoe_SwClose1
	dw SprMap_HammerJoe_SwOpen0
	dw SprMap_HammerJoe_SwOpen1
	dw SprMap_HammerJoe_Throw
Hammer_SprMapPtrTbl:
	dw SprMap_Hammer_Sw0
	dw SprMap_Hammer_Sw1
	dw SprMap_Hammer_Sw2
	dw SprMap_Hammer_Sw3
	dw SprMap_Hammer_Throw0
	dw SprMap_Hammer_Throw1
NeoMonking_SprMapPtrTbl:
	dw SprMap_NeoMonking_Ground0
	dw SprMap_NeoMonking_Ground1
	dw SprMap_NeoMonking_Ceil0
	dw SprMap_NeoMonking_Ceil1
	dw SprMap_NeoMonking_Ceil2
	dw SprMap_NeoMonking_Ceil1
	dw SprMap_NeoMonking_Jump
NeoMet_SprMapPtrTbl:
	dw SprMap_NeoMet_Hide
	dw SprMap_NeoMet_Trs0
	dw SprMap_NeoMet_Trs1
	dw SprMap_NeoMet_Walk0
	dw SprMap_NeoMet_Walk1
PickelmanBull_SprMapPtrTbl:
	dw SprMap_PickelmanBull0
	dw SprMap_PickelmanBull1
Bikky_SprMapPtrTbl:
	dw SprMap_Bikky_GroundClose0
	dw SprMap_Bikky_GroundClose1
	dw SprMap_Bikky_GroundOpen
	dw SprMap_Bikky_Jump
Komasaburo_SprMapPtrTbl:
	dw SprMap_Komasaburo_Idle0
	dw SprMap_Komasaburo_Idle1
	dw SprMap_Komasaburo_Shoot
Koma_SprMapPtrTbl:
	dw SprMap_Koma0
	dw SprMap_Koma1
Mechakkero_SprMapPtrTbl:
	dw SprMap_Mechakkero_Ground
	dw SprMap_Mechakkero_GroundEye
	dw SprMap_Mechakkero_Jump
SpinTopU_SprMapPtrTbl:
	dw SprMap_SpinTop0
	dw SprMap_SpinTop1
	dw SprMap_SpinTop2
	dw SprMap_SpinTop3
SpinTopD_SprMapPtrTbl:
	dw SprMap_SpinTop0
	dw SprMap_SpinTop1
	dw SprMap_SpinTop2
	dw SprMap_SpinTop3
Tama_SprMapPtrTbl:
	dw SprMap_Tama_Idle0
	dw SprMap_Tama_Idle1
	dw SprMap_Tama_Throw0
	dw SprMap_Tama_Throw1
TamaBall_SprMapPtrTbl:
	dw SprMap_TamaBall
TamaFlea_SprMapPtrTbl:
	dw SprMap_TamaFlea_Stand
	dw SprMap_TamaFlea_Jump
MagFly_SprMapPtrTbl:
	dw SprMap_MagFly0
	dw SprMap_MagFly1
GiantSpringer_SprMapPtrTbl:
	dw SprMap_GiantSpringer_Move
	dw SprMap_GiantSpringer_Shoot
	dw SprMap_GiantSpringer_Out0
	dw SprMap_GiantSpringer_Out1
	dw SprMap_GiantSpringer_Out2
	dw SprMap_GiantSpringer_Out1
GiantSpringerShot_SprMapPtrTbl:
	dw SprMap_GiantSpringerShotU
	dw SprMap_GiantSpringerShot_Unused_UL;X
	dw SprMap_GiantSpringerShotL
	dw SprMap_GiantSpringerShot_Unused_UR;X
	dw SprMap_GiantSpringerShot_Unused_R;X
	dw SprMap_GiantSpringerShot_Unused_DR;X
	dw SprMap_GiantSpringerShot_Unused_D;X
	dw SprMap_GiantSpringerShot_Unused_DL;X
Peterchy_SprMapPtrTbl:
	dw SprMap_Peterchy0
	dw SprMap_Peterchy1
	dw SprMap_Peterchy2
	dw SprMap_Peterchy3
	dw SprMap_Peterchy4
	dw SprMap_Peterchy5
MagnetField_SprMapPtrTbl:
	dw SprMap_MagnetWave0
	dw SprMap_MagnetWave1
	dw SprMap_MagnetWave2
Respawner_SprMapPtrTbl:
	dw SprMap_Null;X
Block_SprMapPtrTbl:
	dw SprMap_Null
	dw SprMap_Block0
	dw SprMap_Block1
	dw SprMap_Block2
	dw SprMap_Block3
NewShotman_SprMapPtrTbl:
	dw SprMap_NewShotman_Idle0
	dw SprMap_NewShotman_Idle1
	dw SprMap_NewShotman_Shoot
NeedlePress_SprMapPtrTbl:
	dw SprMap_Null
	dw SprMap_NeedlePress0
	dw SprMap_NeedlePress1
	dw SprMap_NeedlePress2
Yambow_SprMapPtrTbl:
	dw SprMap_Yambow0
	dw SprMap_Yambow1
HariHarry_SprMapPtrTbl:
	dw SprMap_HariHarry_Idle
	dw SprMap_HariHarry_Shoot
	dw SprMap_HariHarry_Roll0
	dw SprMap_HariHarry_Roll1
HariHarryShot_SprMapPtrTbl:
	dw SprMap_HariHarryShotH
	dw SprMap_HariHarryShotHV
	dw SprMap_HariHarryShotV
Cannon_SprMapPtrTbl:
	dw SprMap_Cannon_Closed
	dw SprMap_Cannon_Opening0
	dw SprMap_Cannon_Opening1
	dw SprMap_Cannon_Open
	dw SprMap_Cannon_Opening1
	dw SprMap_Cannon_Opening0
	dw SprMap_Cannon_Closed
CannonShot_SprMapPtrTbl:
	dw SprMap_CannonShot
TellySpawner_SprMapPtrTbl:
	dw SprMap_Null
Lift_SprMapPtrTbl:
	dw SprMap_Lift
BlockyHead_SprMapPtrTbl:
	dw SprMap_BlockyHead_Idle
	dw SprMap_BlockyHead_Hit
BlockyBody_SprMapPtrTbl:
	dw SprMap_BlockyBody
Pipi_SprMapPtrTbl:
	dw SprMap_Pipi0
	dw SprMap_Pipi1
Egg_SprMapPtrTbl:
	dw SprMap_Egg
Copipi_SprMapPtrTbl:
	dw SprMap_Copipi0
	dw SprMap_Copipi1
Shotman_SprMapPtrTbl:
	dw SprMap_Shotman_Low
	dw SprMap_Shotman_Adjust
	dw SprMap_Shotman_High
FlyBoy_SprMapPtrTbl:
	dw SprMap_FlyBoy0
	dw SprMap_FlyBoy1
FlyBoySpawner_SprMapPtrTbl:
	dw SprMap_Null
Springer_SprMapPtrTbl:
	dw SprMap_Springer_Idle
	dw SprMap_Springer_Out2
	dw SprMap_Springer_Out1
	dw SprMap_Springer_Out2
	dw SprMap_Springer_Out3
PieroBotGear_SprMapPtrTbl:
	dw SprMap_PieroBotGear0
	dw SprMap_PieroBotGear1
PieroBot_SprMapPtrTbl:
	dw SprMap_PieroBot0
	dw SprMap_PieroBot1
Mole_SprMapPtrTbl:
	dw SprMap_Mole0
	dw SprMap_Mole1
	dw SprMap_Mole2
	dw SprMap_Mole3
MoleSpawner_SprMapPtrTbl:
	dw SprMap_Null
Press_SprMapPtrTbl:
	dw SprMap_Press
Robbit_SprMapPtrTbl:
	dw SprMap_Robbit_Idle
	dw SprMap_Robbit_Jump
RobbitCarrot_SprMapPtrTbl:
	dw SprMap_RobbitCarrot
Cook_SprMapPtrTbl:
	dw SprMap_Cook2
	dw SprMap_Cook1
	dw SprMap_Cook2
	dw SprMap_Cook3
CookSpawner_SprMapPtrTbl:
	dw SprMap_Null
Batton_SprMapPtrTbl:
	dw SprMap_Batton_Hide
	dw SprMap_Batton_Unhide0
	dw SprMap_Batton_Unhide1
	dw SprMap_Batton_Unhide2
	dw SprMap_Batton_Unhide3
	dw SprMap_Batton_Fly0
	dw SprMap_Batton_Fly1
	dw SprMap_Batton_Fly2
Friender_SprMapPtrTbl:
	dw SprMap_Friender_Idle
	dw SprMap_Friender_Warn
	dw SprMap_Friender_Shoot
FrienderFlame_SprMapPtrTbl:
	dw SprMap_FrienderFlame
GoblinHorn_SprMapPtrTbl:
	dw SprMap_GoblinHorn
Goblin_SprMapPtrTbl:
	dw SprMap_Null
PuchiGoblin_SprMapPtrTbl:
	dw SprMap_PuchiGoblin0
	dw SprMap_PuchiGoblin1
ScwormBase_SprMapPtrTbl:
	dw SprMap_ScwormBase
ScwormShot_SprMapPtrTbl:
	dw SprMap_ScwormShot_Exiting0
	dw SprMap_ScwormShot_Exiting1
	dw SprMap_ScwormShot_Idle0
	dw SprMap_ScwormShot_Idle1
Matasaburo_SprMapPtrTbl:
	dw SprMap_Matasaburo_ArmD0
	dw SprMap_Matasaburo_ArmD1
	dw SprMap_Matasaburo_ArmU0
	dw SprMap_Matasaburo_ArmU1
KaminariGoro_SprMapPtrTbl:
	dw SprMap_KaminariGoro_Idle0
	dw SprMap_KaminariGoro_Idle1
	dw SprMap_KaminariGoro_Throw0
	dw SprMap_KaminariGoro_Throw1
KaminariCloud_SprMapPtrTbl:
	dw SprMap_KaminariCloud0
	dw SprMap_KaminariCloud1
Kaminari_SprMapPtrTbl:
	dw SprMap_Kaminari0
	dw SprMap_Kaminari1
Telly_SprMapPtrTbl:
	dw SprMap_Telly0
	dw SprMap_Telly1
	dw SprMap_Telly2
	dw SprMap_Telly3
	dw SprMap_Telly4
	dw SprMap_Telly5
PipiSpawner_SprMapPtrTbl:
	dw SprMap_Null
Wily1_SprMapPtrTbl:
	dw SprMap_Wily1p_Idle
	dw SprMap_Wily1p_Jump
	dw SprMap_Wily1p_Turn0
	dw SprMap_Wily1p_Turn1
Wily2_SprMapPtrTbl:
	dw SprMap_Wily2p_Idle0
	dw SprMap_Wily2p_Idle1
	dw SprMap_Wily2p_Fire
	dw SprMap_Wily2p_Turn;X
Wily3_SprMapPtrTbl:
	dw SprMap_Wily3p_SkullUp
	dw SprMap_Wily3p_SkullDown
	dw SprMap_Wily3p_Arm0;X
	dw SprMap_Wily3p_Arm1;X
	dw SprMap_Wily3p_Tail0;X
	dw SprMap_Wily3p_Tail1;X
Quint_SprMapPtrTbl:
	dw SprMap_Quint_Idle
	dw SprMap_Quint_Unused_PrepJump0;X
	dw SprMap_Quint_Unused_PrepJump1;X
	dw SprMap_Quint_PrepJump2
	dw SprMap_Quint_Jump
	dw SprMap_Quint_SgJump
	dw SprMap_Quint_SgGround
	dw SprMap_WarpLand0
	dw SprMap_WarpLand1
	dw SprMap_WarpLand2
	dw SprMap_WarpLand3
	dw SprMap_Warp
Wily3Part_SprMapPtrTbl:
	dw SprMap_WilyShip0;X
	dw SprMap_WilyShip1;X
	dw SprMap_Wily3p_SkullUp;X
	dw SprMap_Wily3p_SkullDown;X
	dw SprMap_Wily3p_Arm0
	dw SprMap_Wily3p_Arm1
	dw SprMap_Wily3p_Tail0
	dw SprMap_Wily3p_Tail1
Wily2Intro_SprMapPtrTbl:
	dw SprMap_Wily2Intro
QuintSakugarne_SprMapPtrTbl:
	dw SprMap_QuintSakugarne_Jump
	dw SprMap_QuintSakugarne_Ground
QuintDebris_SprMapPtrTbl:
	dw SprMap_QuintDebris
Wily1Bomb_SprMapPtrTbl:
	dw SprMap_WilyBomb
Wily1Nail_SprMapPtrTbl:
	dw SprMap_Wily1Nail
Wily2Bomb_SprMapPtrTbl:
	dw SprMap_WilyBomb
	dw SprMap_WilyBomb_Proj
Wily2Shot_SprMapPtrTbl:
	dw SprMap_Wily2Shot
Wily3Missile_SprMapPtrTbl:
	dw SprMap_Wily3Missile
Wily3Met_SprMapPtrTbl:
	dw SprMap_Wily3MetU
	dw SprMap_Wily3MetD
WilyCtrl_SprMapPtrTbl:
	dw SprMap_WilyShip0
	dw SprMap_WilyShip1
	dw SprMap_Null
	dw SprMap_Null;X
RushCoil_SprMapPtrTbl:
	dw SprMap_RushCoil_Idle
	dw SprMap_RushCoil_Spring
	dw SprMap_Warp
	dw SprMap_WarpLand3
	dw SprMap_WarpLand2
	dw SprMap_WarpLand1
	dw SprMap_WarpLand0
	dw SprMap_WarpLand0
	dw SprMap_Null;X
	dw SprMap_Null
RushMarine_SprMapPtrTbl:
	dw SprMap_RushMarine_Idle
	dw SprMap_RushMarine_Idle;X
	dw SprMap_Warp
	dw SprMap_WarpLand3
	dw SprMap_WarpLand2
	dw SprMap_WarpLand1
	dw SprMap_WarpLand0
	dw SprMap_WarpLand0
	dw SprMap_Null
	dw SprMap_Null
	dw SprMap_RushMarine_Ride0
	dw SprMap_RushMarine_Ride1
	dw SprMap_RushMarine_RideHit0
	dw SprMap_RushMarine_RideHit1
RushJet_SprMapPtrTbl:
	dw SprMap_RushJet
	dw SprMap_RushJet;X
	dw SprMap_Warp
	dw SprMap_WarpLand3
	dw SprMap_WarpLand2
	dw SprMap_WarpLand1
	dw SprMap_WarpLand0
	dw SprMap_WarpLand0
	dw SprMap_Null;X
	dw SprMap_Null;X
Sakugarne_SprMapPtrTbl:
	dw SprMap_Sakugarne
	dw SprMap_Null
	dw SprMap_Warp
	dw SprMap_WarpLand3
	dw SprMap_WarpLand2
	dw SprMap_WarpLand1
	dw SprMap_WarpLand0
	dw SprMap_WarpLand0
	dw SprMap_Null
	dw SprMap_Null;X
Bubble_SprMapPtrTbl:
	dw SprMap_Bubble
	dw SprMap_Bubble_Pop
WilyCastleCutscene_SprMapPtrTbl:
	dw SprMap_Wily_Stand
	dw SprMap_Wily_Walk
	dw SprMap_Wily_Unused_Eyebrows;X
TeleporterRoom_SprMapPtrTbl:
	dw SprMap_Null
TeleporterLight_SprMapPtrTbl:
	dw SprMap_TeleporterLight0
	dw SprMap_TeleporterLight1
HardMan_SprMapPtrTbl:
	dw SprMap_HardMan_Idle0
	dw SprMap_HardMan_Idle1
	dw SprMap_HardMan_Idle2
	dw SprMap_HardMan_PunchW
	dw SprMap_HardMan_PunchN
	dw SprMap_HardMan_Recoil
	dw SprMap_HardMan_Jump
	dw SprMap_HardMan_Drop0
	dw SprMap_HardMan_Drop1
	dw SprMap_HardMan_Drop2
	dw SprMap_HardMan_Ground
TopMan_SprMapPtrTbl:
	dw SprMap_TopMan_Idle
	dw SprMap_TopMan_Throw0
	dw SprMap_TopMan_Throw1
	dw SprMap_TopMan_Spin0
	dw SprMap_TopMan_Spin1
	dw SprMap_TopMan_Spin2
	dw SprMap_TopMan_Spin3
MagnetMan_SprMapPtrTbl:
	dw SprMap_MagnetMan_Idle
	dw SprMap_MagnetMan_Intro1
	dw SprMap_MagnetMan_Intro2
	dw SprMap_MagnetMan_Attract0
	dw SprMap_MagnetMan_Attract1
	dw SprMap_MagnetMan_Jump
	dw SprMap_MagnetMan_JumpThrow
	dw SprMap_MagnetMan_Unused_Intro3;X
NeedleMan_SprMapPtrTbl:
	dw SprMap_NeedleMan_Idle
	dw SprMap_NeedleMan_Intro
	dw SprMap_NeedleMan_Extend0
	dw SprMap_NeedleMan_Extend1
	dw SprMap_NeedleMan_Extend2
	dw SprMap_NeedleMan_Extend4
	dw SprMap_NeedleMan_Extend2
	dw SprMap_NeedleMan_Extend1
	dw SprMap_NeedleMan_Extend0
	dw SprMap_NeedleMan_Jump
CrashMan_SprMapPtrTbl:
	dw SprMap_CrashMan_Idle
	dw SprMap_CrashMan_Intro1
	dw SprMap_CrashMan_Intro2
	dw SprMap_CrashMan_Walk0
	dw SprMap_CrashMan_Walk1
	dw SprMap_CrashMan_Walk2
	dw SprMap_CrashMan_Walk1
	dw SprMap_CrashMan_Jump
	dw SprMap_CrashMan_Jump
	dw SprMap_CrashMan_JumpShoot
MetalMan_SprMapPtrTbl:
	dw SprMap_MetalMan_Idle
	dw SprMap_MetalMan_Intro1
	dw SprMap_MetalMan_Intro2
	dw SprMap_MetalMan_Walk0
	dw SprMap_MetalMan_Walk1
	dw SprMap_MetalMan_Walk2
	dw SprMap_MetalMan_Walk1
	dw SprMap_MetalMan_JumpU
	dw SprMap_MetalMan_JumpD
	dw SprMap_MetalMan_JumpShoot
WoodMan_SprMapPtrTbl:
	dw SprMap_WoodMan_Idle
	dw SprMap_WoodMan_Intro1
	dw SprMap_WoodMan_ArmsUp
	dw SprMap_WoodMan_Ground0
	dw SprMap_WoodMan_Ground1
	dw SprMap_WoodMan_Idle;X
	dw SprMap_WoodMan_Intro1;X
	dw SprMap_WoodMan_ArmsUp
	dw SprMap_WoodMan_Jump
AirMan_SprMapPtrTbl:
	dw SprMap_AirMan_Blow0
	dw SprMap_AirMan_Idle
	dw SprMap_AirMan_Blow0
	dw SprMap_AirMan_Blow0
	dw SprMap_AirMan_Blow1
	dw SprMap_AirMan_Shoot
	dw SprMap_AirMan_Idle;X
	dw SprMap_AirMan_Jump
HardKnuckle_SprMapPtrTbl:
	dw SprMap_HardKnuckle
TopManShot_SprMapPtrTbl:
	dw SprMap_TopManShot0
	dw SprMap_TopManShot1
	dw SprMap_TopManShot_Unused_2;X
MagnetManShot_SprMapPtrTbl:
	dw SprMap_MagnetManShotH
	dw SprMap_MagnetManShot_Unused_HV;X
	dw SprMap_MagnetManShotV
NeedleManShot_SprMapPtrTbl:
	dw SprMap_NeedleManShot
CrashManShot_SprMapPtrTbl:
	dw SprMap_CrashManShot
MetalManShot_SprMapPtrTbl:
	dw SprMap_MetalManShot0
	dw SprMap_MetalManShot1
AirManShot_SprMapPtrTbl:
	dw SprMap_AirManShot0
	dw SprMap_AirManShot1
	dw SprMap_AirManShot2
WoodManLeafShield_SprMapPtrTbl:
	dw SprMap_WoodManLeafRise
WoodManLeafRise_SprMapPtrTbl:
	dw SprMap_WoodManLeafRise
WoodManLeafFall_SprMapPtrTbl:
	dw SprMap_WoodManLeafFall
CrashManShotExpl_SprMapPtrTbl:
	dw SprMap_CrashManShotExpl0
	dw SprMap_CrashManShotExpl1
	dw SprMap_CrashManShotExpl2
	dw SprMap_CrashManShotExpl3
GroundExpl_SprMapPtrTbl:
	dw SprMap_GroundExpl0
	dw SprMap_GroundExpl1
	dw SprMap_GroundExpl2
Shot_SprMapPtrTbl:
	dw SprMap_Shot0
	dw SprMap_Shot1
	dw SprMap_Shot2
	dw SprMap_Shot3

INCLUDE "data/act/null_spr.asm"
INCLUDE "data/act/expl/expl_spr.asm"
INCLUDE "data/act/item/extralife_spr.asm"
INCLUDE "data/act/item/ammolg_spr.asm"
INCLUDE "data/act/item/healthlg_spr.asm"
INCLUDE "data/act/item/healthsm_spr.asm"
INCLUDE "data/act/item/ammosm_spr.asm"
INCLUDE "data/act/item/etank_spr.asm"
INCLUDE "data/act/bee/bee_spr.asm"
INCLUDE "data/act/bee/beehive_spr.asm"
INCLUDE "data/act/bee/chibee_spr.asm"
INCLUDE "data/act/wanaan/wanaan_spr.asm"
INCLUDE "data/act/hammerjoe/hammerjoe_spr.asm"
INCLUDE "data/act/hammerjoe/hammer_spr.asm"
INCLUDE "data/act/neomonking/neomonking_spr.asm"
INCLUDE "data/act/neomet/neomet_spr.asm"
INCLUDE "data/act/pickelmanbull/pickelmanbull_spr.asm"
INCLUDE "data/act/bikky/bikky_spr.asm"
INCLUDE "data/act/komasaburo/komasaburo_spr.asm"
INCLUDE "data/act/komasaburo/koma_spr.asm"
INCLUDE "data/act/mechakkero/mechakkero_spr.asm"
INCLUDE "data/act/spintop/spintop_spr.asm"
INCLUDE "data/act/tama/tama_spr.asm"
INCLUDE "data/act/tama/ball_spr.asm"
INCLUDE "data/act/tama/flea_spr.asm"
INCLUDE "data/act/magfly/magfly_spr.asm"
INCLUDE "data/act/giantspringer/giantspringer_spr.asm"
INCLUDE "data/act/giantspringer/shot_spr.asm"
INCLUDE "data/act/peterchy/peterchy_spr.asm"
INCLUDE "data/act/magnetfield/magnetwave_spr.asm"
INCLUDE "data/act/block/block_spr.asm"
INCLUDE "data/act/newshotman/newshotman_spr.asm"
INCLUDE "data/act/needlepress/needlepress_spr.asm"
INCLUDE "data/act/yambow/yambow_spr.asm"
INCLUDE "data/act/hariharry/hariharry_spr.asm"
INCLUDE "data/act/hariharry/shot_spr.asm"
INCLUDE "data/act/cannon/cannon_spr.asm"
INCLUDE "data/act/cannon/shot_spr.asm"
INCLUDE "data/act/telly/telly_spr.asm"
INCLUDE "data/act/lift/lift_spr.asm"
INCLUDE "data/act/blocky/blocky_spr.asm"
INCLUDE "data/act/pipi/pipi_spr.asm"
INCLUDE "data/act/pipi/copipi_spr.asm"
INCLUDE "data/act/pipi/egg_spr.asm"
INCLUDE "data/act/shotman/shotman_spr.asm"
INCLUDE "data/act/flyboy/flyboy_spr.asm"
INCLUDE "data/act/springer/springer_spr.asm"
INCLUDE "data/act/pierobot/gear_spr.asm"
INCLUDE "data/act/pierobot/pierobot_spr.asm"
INCLUDE "data/act/mole/mole_spr.asm"
INCLUDE "data/act/press/press_spr.asm"
INCLUDE "data/act/robbit/robbit_spr.asm"
INCLUDE "data/act/robbit/carrot_spr.asm"
INCLUDE "data/act/cook/cook_spr.asm"
INCLUDE "data/act/batton/batton_spr.asm"
INCLUDE "data/act/friender/friender_spr.asm"
INCLUDE "data/act/friender/flame_spr.asm"
INCLUDE "data/act/goblin/goblinhorn_spr.asm"
INCLUDE "data/act/goblin/puchigoblin_spr.asm"
INCLUDE "data/act/scworm/base_spr.asm"
INCLUDE "data/act/scworm/shot_spr.asm"
INCLUDE "data/act/matasaburo/matasaburo_spr.asm"
INCLUDE "data/act/kaminarigoro/kaminarigoro_spr.asm"
INCLUDE "data/act/kaminarigoro/cloud_spr.asm"
INCLUDE "data/act/kaminarigoro/kaminari_spr.asm"
INCLUDE "data/act/wilyboss/wilyship_spr.asm"
INCLUDE "data/act/wilyboss/wily1/wily1_spr.asm"
INCLUDE "data/act/wilyboss/wily2/wily2_spr.asm"
INCLUDE "data/act/wilyboss/wily3/wily3_spr.asm"
INCLUDE "data/act/wilyboss/bomb_spr.asm"
INCLUDE "data/act/wilyboss/wily1/nail_spr.asm"
INCLUDE "data/act/wilyboss/wily2/bombproj_spr.asm"
INCLUDE "data/act/wilyboss/wily2/shot_spr.asm"
INCLUDE "data/act/wilyboss/wily3/missile_spr.asm"
INCLUDE "data/act/wilyboss/wily3/met_spr.asm"
INCLUDE "data/act/quint/quint_spr.asm"
INCLUDE "data/act/quint/sakugarne_spr.asm"
INCLUDE "data/act/quint/debris_spr.asm"
INCLUDE "data/act/rushcoil/rushcoil_spr.asm"
INCLUDE "data/act/rushmarine/rushmarine_spr.asm"
INCLUDE "data/act/rushjet/rushjet_spr.asm"
INCLUDE "data/act/sakugarne/sakugarne_spr.asm"
INCLUDE "data/act/bubble/bubble_spr.asm"
INCLUDE "data/act/_warp/warp_spr.asm"
INCLUDE "data/act/wilycastle/wily_spr.asm"
INCLUDE "data/act/teleporter/light_spr.asm"
INCLUDE "data/act/hardman/hardman_spr.asm"
INCLUDE "data/act/topman/topman_spr.asm"
INCLUDE "data/act/magnetman/magnetman_spr.asm"
INCLUDE "data/act/needleman/needleman_spr.asm"
INCLUDE "data/act/crashman/crashman_spr.asm"
INCLUDE "data/act/metalman/metalman_spr.asm"
INCLUDE "data/act/woodman/woodman_spr.asm"
INCLUDE "data/act/airman/airman_spr.asm"
INCLUDE "data/act/hardman/shot_spr.asm"
INCLUDE "data/act/topman/shot_spr.asm"
INCLUDE "data/act/magnetman/shot_spr.asm"
INCLUDE "data/act/needleman/shot_spr.asm"
INCLUDE "data/act/crashman/shot_spr.asm"
INCLUDE "data/act/metalman/shot_spr.asm"
INCLUDE "data/act/woodman/leafrise_spr.asm"
INCLUDE "data/act/woodman/leaffall_spr.asm"
INCLUDE "data/act/airman/shot_spr.asm"
INCLUDE "data/act/_shot/shot_spr.asm"
INCLUDE "data/act/crashman/shotexpl_spr.asm"
INCLUDE "data/act/wilycastle/groundexpl_spr.asm"
INCLUDE "data/pl/pl_spr.asm"
	mIncJunk "L037908"