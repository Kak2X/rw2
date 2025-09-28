.def00:
	wd $9803
	db $00|$0D
	db "  THANK YOU  "
.def01:
	wd $9843
	db $00|$0D
	db " FOR PLAYING "
.def02:
	wd $98A3
	db $00|$0D
	db "  PRESENTED  "
.def03:
	wd $98E3
	db $00|$0D
	db "     BY      "
.def04:
	wd $9900
	db $00|$0D
	db "_____________"
.def05:
	wd $9920
	db $00|$0D
	db "_____________"
.def06:
	wd $9940
	db $00|$0D
	db "_____________"
.def07:
	wd $9960
	db $00|$0D
	db "_____________"
.def08:
	wd $9B03
	db $00|$0D
	db $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C ; CAPCOM logo
.def09:
	wd $9B23
	db $00|$0D
	db $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B,$3C ; CAPCOM logo
.def0A:
	wd $9803
	db $00|$0D
	db "_____________"
.eof: db $00