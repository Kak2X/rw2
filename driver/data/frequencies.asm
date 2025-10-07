; =============== Sound_OctaveFreqPtrTbl ===============
; Frequency table, split between seven octaves.
Sound_OctaveFreqPtrTbl:
	dw Sound_OctaveFreqTbl1
	dw Sound_OctaveFreqTbl2
	dw Sound_OctaveFreqTbl3
	dw Sound_OctaveFreqTbl4
	dw Sound_OctaveFreqTbl5
	dw Sound_OctaveFreqTbl6
	dw Sound_OctaveFreqTbl7

Sound_OctaveFreqTbl1:
	dw $002C ; C-2
	dw $009D ; C#2
	dw $0107 ; D-2
	dw $016B ; D#2
	dw $01C9 ; E-2
	dw $0222 ; F-2
	dw $0277 ; F#2
	dw $02C7 ; G-2
	dw $0312 ; G#2
	dw $0358 ; A-2
	dw $039B ; A#2
	dw $03DA ; B-2
Sound_OctaveFreqTbl2:
	dw $0416 ; C-3
	dw $044E ; C#3
	dw $0483 ; D-3
	dw $04B5 ; D#3
	dw $04E5 ; E-3
	dw $0511 ; F-3
	dw $053B ; F#3
	dw $0563 ; G-3
	dw $0589 ; G#3
	dw $05AC ; A-3
	dw $05CE ; A#3
	dw $05ED ; B-3
Sound_OctaveFreqTbl3:
	dw $060B ; C-4
	dw $0627 ; C#4
	dw $0642 ; D-4
	dw $065B ; D#4
	dw $0672 ; E-4
	dw $0689 ; F-4
	dw $069E ; F#4
	dw $06B2 ; G-4
	dw $06C4 ; G#4
	dw $06D6 ; A-4
	dw $06E7 ; A#4
	dw $06F7 ; B-4
Sound_OctaveFreqTbl4:
	dw $0706 ; C-5
	dw $070F ; C#5
	dw $0721 ; D-5
	dw $072D ; D#5
	dw $0739 ; E-5
	dw $0744 ; F-5
	dw $074F ; F#5
	dw $0759 ; G-5
	dw $0762 ; G#5
	dw $076B ; A-5
	dw $0773 ; A#5
	dw $077B ; B-5
Sound_OctaveFreqTbl5:
	dw $0783 ; C-6
	dw $078A ; C#6
	dw $0790 ; D-6
	dw $0797 ; D#6
	dw $079D ; E-6
	dw $07A2 ; F-6
	dw $07A7 ; F#6
	dw $07AC ; G-6
	dw $07B1 ; G#6
	dw $07B6 ; A-6
	dw $07BA ; A#6
	dw $07BE ; B-6
Sound_OctaveFreqTbl6:
	dw $07C1 ; C-7
	dw $07C5 ; C#7
	dw $07C8 ; D-7
	dw $07CB ; D#7
	dw $07CE ; E-7
	dw $07D1 ; F-7
	dw $07D4 ; F#7
	dw $07D6 ; G-7
	dw $07D9 ; G#7
	dw $07DA ; A-7
	dw $07DD ; A#7
	dw $07DF ; B-7
Sound_OctaveFreqTbl7:
	dw $07E1 ; C-8
	dw $07E2 ; C#8 ;X
	dw $07E4 ; D-8 ;X
	dw $07E6 ; D#8 ;X
	dw $07E7 ; E-8 ;X
	dw $07E9 ; F-8 ;X
	dw $07EA ; F#8 ;X
	dw $07EB ; G-8 ;X
	dw $07EC ; G#8 ;X
	dw $07ED ; A-8 ;X
	dw $07EE ; A#8 ;X
	dw $07EF ; B-8 ;X