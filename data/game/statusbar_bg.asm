.def00:
	wd $9C00
	db $00|$14
	db $5D,$5D,$5D,$5D,$5D,$5E,$5F,$68,$68,$68,$68,$68,$6D,$6F,$53,$5D,$5D,$5D,$5D,$5D
.def01:
	wd $9C20
	db $00|$14
	db $5D,$5D,$5D,$5D,$5D,$60,$61,$6C,$6C,$6C,$6C,$6C,$6E,$50,$54,$5D,$5D,$5D,$5D,$5D
.def02:
	wd $9C40
	db BG_REPEAT|BG_MVDOWN|$0F
	db $5D
.def03:
	wd $9C53
	db BG_REPEAT|BG_MVDOWN|$0F
	db $5D
.def04:
	wd $9E20
	db BG_REPEAT|$14
	db $5D
.eof: db $00