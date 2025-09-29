SndHeader_SFX_3D:
	db $01 ; Number of channels
.ch4:
	db SIS_SFX|SIS_ENABLED ; Initial playback status
	db SND_CH4_PTR ; Sound channel ptr
	dw SndData_SFX_3D_Ch4_0 ; Data ptr
	db 0 ; Initial fine tune
	db $81 ; Initial vibrato ID
SndData_SFX_3D_Ch4_0:
	envelope $A7
	panning $88
	note4x $49, 1 ; Nearest: A#,5,1
	lock_envelope
	note4x $48, 1 ; Nearest: B_,5,1
	note4x $42, 1 ; Nearest: A_,5,0
	unlock_envelope
	note4 B_,6,0, 1
	snd_loop SndData_SFX_3D_Ch4_0
