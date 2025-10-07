BGM_Silence:
	dw BGM_Silence_Ch1
	dw BGM_Silence_Ch2
	dw BGM_Silence_Ch3
	dw BGM_Silence_Ch4

BGM_Silence_Ch1:
	panning $FF
	timer_speed $D0

BGM_Silence_Ch2:
BGM_Silence_Ch3:
BGM_Silence_Ch4:
	chan_stop

