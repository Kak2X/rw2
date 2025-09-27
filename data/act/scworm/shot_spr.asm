SprMap_ScwormShot_Exiting0:
	db (.end-.start)/4 ; $01 OBJ
.start:
	db $F9,$FC,$88,$00 ; $00
.end:

SprMap_ScwormShot_Exiting1:
	db (.end-.start)/4 ; $01 OBJ
.start:
	db $F9,$FB,$89,$00 ; $00
.end:

SprMap_ScwormShot_Idle0:
	db (.end-.start)/4 ; $03 OBJ
.start:
	db $F1,$F8,$8A,$00 ; $00
	db $F9,$F8,$9A,$00 ; $01
	db $F9,$00,$8C,$00 ; $02
.end:

SprMap_ScwormShot_Idle1:
	db (.end-.start)/4 ; $03 OBJ
.start:
	db $F1,$00,$8A,$20 ; $00
	db $F9,$F8,$8C,$20 ; $01
	db $F9,$00,$9A,$20 ; $02
.end:

