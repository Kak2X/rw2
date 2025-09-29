; =============== WpnCtrl_RushJet ===============
; Rush Jet.
; The broken free-roaming RM3 variant.
WpnCtrl_RushJet:
	xor  a
	ld   [wWpnUnlockMask], a
	ld   a, ACT_WPN_RJ
	ld   [wActSpawnId], a
	call WpnCtrl_ChkSpawnHelper
	jp   WpnCtrl_Default
	
