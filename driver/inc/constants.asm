DEF SNDIDREQ_SIZE      EQU $08
DEF SNDINFO_SIZE       EQU $20 ; Size of iSndInfo struct
DEF SND_CH1_PTR        EQU LOW(rNR13)
DEF SND_CH2_PTR        EQU LOW(rNR23)
DEF SND_CH3_PTR        EQU LOW(rNR33)
DEF SND_CH4_PTR        EQU LOW(rNR43)
DEF SNDLEN_INFINITE    EQU $FF

; wSnd_Unused_SfxPriority
DEF SNPB_SFXMULTI         EQU 7 ; An high-priority multi-channel SFX is playing
DEF SNPB_SFX4             EQU 6 ; An high-priority SFX4 is playing
DEF SNP_SFXMULTI          EQU 1 << SNPB_SFXMULTI
DEF SNP_SFX4              EQU 1 << SNPB_SFX4

; iSndInfo_Status
DEF SISB_PAUSE            EQU 0 ; If set, iSndInfo processing is paused for that channel
DEF SISB_LOCKNRx2         EQU 1 ; If set, rNR*2 won't be updated
DEF SISB_USEDBYSFX        EQU 2 ; wBGMCh*Info only. If set, it marks that a sound effect is currently using the channel.
DEF SISB_SFX              EQU 3 ; If set, the SndInfo is handled as a sound effect. If clear, it's a BGM.
DEF SISB_SLIDE            EQU 5 ; If set, a pitch slide is in progress.
DEF SISB_VIBRATO          EQU 6 ; If set, vibrato is enabled for that channel.
DEF SISB_ENABLED          EQU 7 ; If set, iSndInfo processing is enabled for that channel

DEF SIS_PAUSE             EQU 1 << SISB_PAUSE
DEF SIS_LOCKNRx2          EQU 1 << SISB_LOCKNRx2    
DEF SIS_USEDBYSFX         EQU 1 << SISB_USEDBYSFX   
DEF SIS_SFX               EQU 1 << SISB_SFX         
DEF SIS_SLIDE             EQU 1 << SISB_SLIDE
DEF SIS_VIBRATO           EQU 1 << SISB_VIBRATO
DEF SIS_ENABLED           EQU 1 << SISB_ENABLED

; wSndFadeStatus
DEF SFDB_FADEIN           EQU 7 ; If set, the song fades in
DEF SFD_FADEIN            EQU 1 << SFDB_FADEIN ; If set, the song fades in

DEF SNDCMD_FADEIN         EQU $10
DEF SNDCMD_FADEOUT        EQU $20
DEF SNDCMD_CH1VOL         EQU $30
DEF SNDCMD_CH2VOL         EQU $40
DEF SNDCMD_CH3VOL         EQU $50
DEF SNDCMD_CH4VOL         EQU $60
DEF SNDCMD_BASE           EQU $E0
DEF SNDNOTE_BASE          EQU $80

; Sound Channel Info IDs, passed from the outside world
DEF SCI_BGMCH1            EQU $00
DEF SCI_BGMCH2            EQU $01
DEF SCI_BGMCH3            EQU $02
DEF SCI_BGMCH4            EQU $03
DEF SCI_SFXCH1            EQU $04
DEF SCI_SFXCH2            EQU $05
DEF SCI_SFXCH3            EQU $06
DEF SCI_SFXCH4            EQU $07

; Vibrato data commands
DEF VIBCMD_LOOP           EQU $80

; Notes (note)
DEF C_                    EQU 0
DEF C#                    EQU 1
DEF D_                    EQU 2
DEF D#                    EQU 3
DEF E_                    EQU 4
DEF F_                    EQU 5
DEF F#                    EQU 6
DEF G_                    EQU 7
DEF G#                    EQU 8
DEF A_                    EQU 9
DEF A#                    EQU 10
DEF B_                    EQU 11

;--------------

DEF SND_MUTE              EQU $7F
DEF SND_BASE              EQU $80
DEF SND_NONE              EQU SND_BASE+$00