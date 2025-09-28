; =============== Password_ETankTruthTbl ===============
; Truth table for E Tank bit combinations.
; Matches by value the accumulated password bits A4,B2,C1,D3 to the number of E Tanks.
; See: .etankLoop
Password_ETankTruthTbl:
	db %0000 ; 0 ;
	db %0010 ; 1 ; C1
	db %0101 ; 2 ; B2,D3
	db %1010 ; 3 ; A4,C1
	db %1011 ; 4 ; A4,C1,D3
.end:

; =============== Password_WpnDotTbl ===============
; Dot positions used to store unlocked weapons, for each group.
Password_WpnDotTbl:
	db iDotA1 ; Group $00
	db iDotA2
	db iDotB1
	db iDotA3 ; Group $01
	db iDotB3
	db iDotB4
	db iDotC2 ; Group $02
	db iDotD1
	db iDotD2
	db iDotC3 ; Group $03
	db iDotC4
	db iDotD4

; =============== Password_OrderPtrTbl ===============
; Truth & group order tables for unlocked weapon bits combinations.
; These are completely different depending on the amount of E-Tanks saved into the password.
Password_OrderPtrTbl:
	dw Password_OrderTbl0 ; 0 Tanks
	dw Password_OrderTbl1 ; 1 Tank
	dw Password_OrderTbl2 ; 2 Tanks
	dw Password_OrderTbl3 ; 3 Tanks
	dw Password_OrderTbl4 ; 4 Tanks

; --------------- Password_OrderTbl0 ---------------
; Order table used when zero E Tanks are recorded into the password.
; These four numbers right below are the group numbers -- they are multiplied by 3,
; and used to index Password_WpnDotTbl.
Password_OrderTbl0:
	db $00 ; A1,A2,B1 (bit0-1)
	db $01 ; A3,B3,B4 (bit2-3)
	db $02 ; C2,D1,D2 (bit4-5)
	db $03 ; C3,C4,D4 (bit6-7)
; Immediately following are the truth tables for each group.
.truth0: ; For the 1st group (here it's $00 | A1,A2,B1)
	db %100
	db %101
	db %011
	db %110
.truth1: ; For the 2nd group (here it's $01 | A3,B3,B4)
	db %011
	db %110
	db %100
	db %101
.truth2: ; ...
	db %001
	db %011
	db %100
	db %110
.truth3:	
	db %101
	db %011
	db %001
	db %110
	
; --------------- Password_OrderTbl1 ---------------
; Like above, but when 1 E Tank is recorded.
Password_OrderTbl1:
	db $01 ; A3,B3,B4
	db $02 ; C2,D1,D2
	db $03 ; C3,C4,D4
	db $00 ; A1,A2,B1
	
.truth0: ; For the 1st group (here it's $01 | A3,B3,B4)
	db %001
	db %110
	db %010
	db %101
.truth1: ; For the 2nd group (here it's $02 | C2,D1,D2)
	db %010
	db %011
	db %100
	db %110
.truth2: ; ...
	db %101
	db %001
	db %011
	db %100
.truth3:
	db %011
	db %100
	db %001
	db %010
	
; --------------- Password_OrderTbl2 ---------------
Password_OrderTbl2:
	db $02 ; C2,D1,D2
	db $03 ; C3,C4,D4
	db $00 ; A1,A2,B1
	db $01 ; A3,B3,B4
Password_OrderTbl2r0:
	db %001
	db %100
	db %011
	db %101
Password_OrderTbl2r1:
	db %011
	db %100
	db %010
	db %110
Password_OrderTbl2r2:
	db %001
	db %010
	db %101
	db %011
Password_OrderTbl2r3:
	db %000
	db %110
	db %100
	db %001
	
; --------------- Password_OrderTbl3 ---------------
Password_OrderTbl3:
	db $03 ; C3,C4,D4
	db $00 ; A1,A2,B1
	db $01 ; A3,B3,B4
	db $02 ; C2,D1,D2
Password_OrderTbl3r0:
	db %110
	db %010
	db %101
	db %011
Password_OrderTbl3r1:
	db %101
	db %001
	db %110
	db %100
Password_OrderTbl3r2:
	db %100
	db %011
	db %001
	db %110
Password_OrderTbl3r3:
	db %000
	db %010
	db %001
	db %011
	
; --------------- Password_OrderTbl4 ---------------
Password_OrderTbl4: 
	db $00 ; A1,A2,B1
	db $02 ; C2,D1,D2
	db $03 ; C3,C4,D4
	db $01 ; A3,B3,B4
Password_OrderTbl4r0: 
	db %010
	db %011
	db %001
	db %100
Password_OrderTbl4r1: 
	db %101
	db %010
	db %100
	db %110
Password_OrderTbl4r2: 
	db %000
	db %010
	db %011
	db %100
Password_OrderTbl4r3: 
	db %011
	db %010
	db %100
	db %110
	
