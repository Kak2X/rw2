; =============== WpnCtrl_RushMarine ===============
; Rush Marine.
; Underwater version of Rush Jet.
WpnCtrl_RushMarine:
	xor  a
	ld   [wWpnUnlockMask], a
	ld   a, ACT_WPN_RM
	ld   [wActSpawnId], a
	call WpnCtrl_ChkSpawnHelper
	jp   WpnCtrl_Default
	
