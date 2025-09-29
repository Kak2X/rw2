SprMapPtrTbl_ScWilyShipSm:
	dw SprMap_ScWilyShipSm0;X
	dw SprMap_ScWilyShipSm1;X
	dw SprMap_ScWilyShipSm2
	dw SprMap_ScWilyShipSm3;X
SprMapPtrTbl_ScPl:
	dw SprMap_ScPlR0
	dw SprMap_ScPlR1
	dw SprMap_ScWily0
	dw SprMap_ScWily1
	dw SprMap_ScPlL0
	dw SprMap_ScPlL1
SprMapPtrTbl_ScSkullJaw:
	dw SprMap_ScSkullJaw
	dw SprMap_ScSkullJaw ; Duplicate entry since the missile animation code always gets executed
	dw SprMap_ScMissile0
	dw SprMap_ScMissile1
SprMapPtrTbl_ScWilyCrash:
	dw SprMap_ScWilyCrash0
	dw SprMap_ScWilyCrash1
SprMapPtrTbl_ScWilyNuke:
	dw SprMap_ScWilyNuke0
	dw SprMap_ScWilyNuke1
	dw SprMap_ScWilyNuke2
	dw SprMap_ScWilyNuke3
	dw SprMap_ScWilyNuke4
	dw SprMap_ScWilyNuke5
	dw SprMap_ScWilyNuke6
	dw SprMap_ScWilyNuke7
SprMapPtrTbl_ScExpl:
	dw SprMap_ScExpl0
	dw SprMap_ScExpl1
	dw SprMap_ScExpl2
	dw SprMap_ScExpl0;X	; Repeat entries for some reason
	dw SprMap_ScExpl1	; Explosions are initialized with sprite $04 (out of range value that forces a loop to $00) but aren't actually drawn with it.
	dw SprMap_ScExpl2;X
SprMapPtrTbl_Credits_Pl:
	dw SprMap_Credits_Pl