; =============== WpnCtrl_RushCoil ===============
; Rush Coil.
; This and other items have execution fall back to WpnCtrl_Default,
; which is what allows to fire normal shots while using items.
WpnCtrl_RushCoil:
	; Uses normal shot
	xor  a
	ld   [wWpnUnlockMask], a
	
	; When an item "weapon" is selected, firing a shot will try to spawn its respective helper actor if one is not active already.
	; In this case, it spawns, well, the Rush Coil.
	; All helper actors are spawned the same way, as they teleport in from the top of the screen in front of the player.
	ld   a, ACT_WPN_RC
	ld   [wActSpawnId], a
	call WpnCtrl_ChkSpawnHelper
	
	; Additionally, they also all allow firing normal shots.
	; This behaviour is separate from the helper actor spawning one, so pressing the B button to spawn one also fires a normal
	; shot at the same time.
	jp   WpnCtrl_Default
	
