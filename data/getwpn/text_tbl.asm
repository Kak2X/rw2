SETCHARMAP getwpn
Txt_GetWpn_YouGot:
	db " YOU GOT\0"
	
; =============== GetWpn_LvlTextPtrTbl ===============
; Maps levels to their weapon unlock string.
GetWpn_LvlTextPtrTbl:
	dw Txt_GetWpn_Hard   ; LVL_HARD     
	dw Txt_GetWpn_Top    ; LVL_TOP      
	dw Txt_GetWpn_Magnet ; LVL_MAGNET   
	dw Txt_GetWpn_Needle ; LVL_NEEDLE   
	dw Txt_GetWpn_Crash  ; LVL_CRASH    
	dw Txt_GetWpn_Metal  ; LVL_METAL    
	dw Txt_GetWpn_Wood   ; LVL_WOOD     
	dw Txt_GetWpn_Air    ; LVL_AIR      
	dw Txt_GetWpn_Quint  ; LVL_CASTLE   

Txt_GetWpn_Hard:
	db "  HARD\n"
	db "   KNUCKLE\0"
Txt_GetWpn_Top:
	db "  TOP\n" 
	db "   SPIN\0"
Txt_GetWpn_Magnet:
	db "  MAGNET\n"
	db "   MISSILE\0"
Txt_GetWpn_Needle:
	db "  NEEDLE\n"
	db "   CANNON\0"
Txt_GetWpn_Crash:
	db "  CLASH\n"
	db "   BOMB\n"
	db "\n"
	db "   AND\n"
	db " RUSH COIL\0"
Txt_GetWpn_Metal:
	db "  METAL\n"
	db "   BLADE\n"
	db "\n"
	db "   AND\n"
	db "RUSH MARINE\0"
Txt_GetWpn_Wood: 
	db "  LEAF\n"
	db "   SHIELD\0"
Txt_GetWpn_Air:
	db "  AIR\n"
	db "   SHOOTER\n"
	db "\n"
	db "   AND\n"
	db " RUSH JET\0"
Txt_GetWpn_Quint: 
	db "  QUINT\n"
	db "   ITEM\n"
	db "\n"
	db "\n"
	db "  SAKUGARNE\0"
