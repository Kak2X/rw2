; =============== Sound_WaveSetPtrTable ===============
; Sets of Wave data for channel 3, copied directly to the rWave registers.
; [TCRF] More than half of the sets are unused!
Sound_WaveSetPtrTable_\1:
	dw Sound_WaveSet_Unused_0_\1
	dw Sound_WaveSet1_\1
	dw Sound_WaveSet2_\1
	dw Sound_WaveSet_Unused_3_\1
	dw Sound_WaveSet_Unused_4_\1
	dw Sound_WaveSet5_\1
	dw Sound_WaveSet_Unused_6_\1
	dw Sound_WaveSet_Unused_7_\1
	dw Sound_WaveSet_Unused_8_\1
	dw Sound_WaveSet_Unused_9_\1

Sound_WaveSet_Unused_0_\1: db $01,$23,$45,$67,$89,$AB,$CD,$EF,$ED,$CB,$A9,$87,$65,$43,$21,$00
Sound_WaveSet1_\1: db $FF,$EE,$DD,$CC,$BB,$AA,$99,$88,$77,$66,$55,$44,$33,$22,$11,$00
Sound_WaveSet2_\1: db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00
Sound_WaveSet_Unused_3_\1: db $FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
Sound_WaveSet_Unused_4_\1: db $02,$46,$89,$AB,$CC,$DD,$EE,$FF,$FE,$ED,$DD,$CC,$BA,$98,$64,$31
Sound_WaveSet5_\1: db $CF,$AF,$30,$12,$21,$01,$7F,$C2,$EA,$07,$FC,$62,$12,$5B,$FB,$12
Sound_WaveSet_Unused_6_\1: db $86,$33,$22,$11,$00,$0B,$EF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$EE
Sound_WaveSet_Unused_7_\1: db $87,$76,$65,$54,$43,$32,$21,$10,$0F,$FE,$ED,$DC,$CB,$BA,$A9,$98
Sound_WaveSet_Unused_8_\1: db $18,$F2,$68,$4E,$18,$76,$1A,$4C,$85,$43,$2E,$DC,$FF,$12,$84,$48
Sound_WaveSet_Unused_9_\1: db $CC,$6B,$93,$77,$28,$BA,$6E,$35,$51,$C3,$9C,$ED,$B8,$2B,$29,$E2