********************************************************************************
        code
********************************************************************************

BKG_IPOL_FRAMES = 32
BKG_FRAMES_NUM = BKG_IPOL_FRAMES*24
BKG_INPUT_GRADS_SIZE = 256

RAMPELS_GREENPURPLE_0 = 1
;RAMPELS_COLORFULL=1

;   xref BkgBars_Start
;   xref BkgBars_Update
bkg_Start:
        movem.l d0-d7/a0-a6,-(sp)
        move.l  #BKG_FRAMES_NUM,-(sp)
        move.l  #BKG_INPUT_GRADS_SIZE,-(sp)
        pea     bkg_Gradient_Input
        pea     bkg_frames_loop
        move.l  #CHUNKY_H,-(sp)
        jsr     BkgBars_Start
        lea     (20,sp),sp ; 

        lea     bkg_frames_loop,a0
        move.l  a0,bkg_frame_ptr
        adda.l  #(BKG_FRAMES_NUM-2)*CHUNKY_H*2,a0
        move.l  a0,bkg_frame_ptr_end
;     move.w  #1234,d0
; .loop:
;     move.w  d0,$dff180
;     add.w  #341,d0
;     btst    #CIAB_GAMEPORT1,ciaa            ; Left mouse button not pressed?
;     bne     .loop
        
        movem.l (sp)+,d0-d7/a0-a6
        rts
       
bkg_Update:
;    movem.l d0-d7/a0-a6,-(sp)
        move.l  bkg_frame_ptr,a4
        add.l   #CHUNKY_H*2,bkg_frame_ptr	
        cmp.l   bkg_frame_ptr_end,a4
        blt.s   .bkg_Update_continue
        lea     bkg_frames_loop,a4
        move.l  a4,bkg_frame_ptr
	 
.bkg_Update_continue:	 

;   movem.l (sp)+,d0-d7/a0-a6
        rts


        xdef    __mulsi3
__mulsi3:
;.cfi_startproc
        move.w  4(sp),d0 ;/* x0 -> d0 */
        mulu.w  10(sp),d0 ;/* x0*y1 */
        move.w  6(sp),d1 ;/* x1 -> d1 */
        mulu.w  8(sp),d1 ;/* x1*y0 */
        add.w   d1,d0
        swap    d0
        clr.w   d0
        move.w  6(sp),d1 ;/* x1 -> d1 */
        mulu.w  10(sp),d1 ;/* x1*y1 */
        add.l   d1,d0
        rts
;    xref BkgBars_Frame


bkg_frame_ptr: dc.l 0
bkg_frame_ptr_end: dc.l 0
bkg_Gradient_Input:
        ifd     RAMPELS_GREENPURPLE_0
; PELLICUS: Green/Purple gradient attempt
; https://gradient-blaster.grahambates.com/?points=537@0,33f@14,287@33,7df@49,7a0@60,80e@83,6b0@103,06b@120,00f@138,81a@149,0ef@167,143@181,639@197,06b@211,900@225,143@235,76f@246,537@255&steps=256&blendMode=linear&ditherMode=off&target=amigaOcs

        dc.w    $537,$538,$538,$439,$439,$43a,$43b,$43b
        dc.w    $43c,$33c,$33d,$33e,$33e,$33f,$33f,$33f
        dc.w    $33f,$34e,$34e,$24d,$24d,$25c,$25c,$25b
        dc.w    $26b,$26b,$26a,$26a,$279,$279,$278,$288
        dc.w    $287,$287,$288,$298,$399,$399,$3aa,$4aa
        dc.w    $4ab,$4bb,$5bc,$5bc,$5cd,$6cd,$6ce,$6de
        dc.w    $7df,$7df,$7de,$7dd,$7db,$7ca,$7c8,$7c7
        dc.w    $7b5,$7b4,$7b2,$7a1,$7a0,$7a0,$791,$791
        dc.w    $782,$783,$773,$774,$765,$765,$766,$857
        dc.w    $857,$848,$849,$839,$83a,$82b,$82b,$81c
        dc.w    $81d,$80d,$80e,$80e,$80e,$81d,$81c,$82b
        dc.w    $82b,$73a,$749,$748,$758,$757,$766,$776
        dc.w    $775,$784,$683,$693,$6a2,$6a1,$6b0,$6b0
        dc.w    $6b0,$5b1,$5a2,$4a2,$4a3,$494,$394,$395
        dc.w    $386,$286,$287,$178,$179,$179,$07a,$06b
        dc.w    $06b,$06b,$05c,$05c,$05c,$04c,$04d,$03d
        dc.w    $03d,$03d,$02e,$02e,$02e,$01e,$01f,$01f
        dc.w    $00f,$00f,$00f,$00f,$10f,$20e,$30e,$30d
        dc.w    $40d,$50c,$60c,$70b,$71b,$81a,$81a,$72b
        dc.w    $73b,$64b,$64c,$55c,$56c,$47d,$48d,$38d
        dc.w    $39d,$2ae,$2be,$1be,$1cf,$0df,$0ef,$0ef
        dc.w    $0ef,$0de,$0cd,$0bc,$0bb,$0aa,$099,$088
        dc.w    $087,$076,$065,$055,$154,$143,$143,$144
        dc.w    $244,$244,$235,$335,$336,$336,$436,$437
        dc.w    $437,$538,$538,$538,$639,$639,$539,$539
        dc.w    $53a,$44a,$44a,$34a,$34a,$25a,$25b,$15b
        dc.w    $15b,$05b,$06b,$06b,$05a,$15a,$259,$248
        dc.w    $347,$436,$435,$525,$624,$613,$712,$801
        dc.w    $800,$900,$800,$700,$710,$611,$521,$421
        dc.w    $332,$232,$132,$143,$144,$245,$246,$357
        dc.w    $459,$45a,$55b,$55c,$66d,$66e,$76f,$76f
        dc.w    $75e,$65d,$65c,$64b,$64a,$539,$538,$537
        endif

        ifd     RAMPELS_CCOLORFULL
; PELLICUS: Color Full grandient input
; https://gradient-blaster.grahambates.com/?points=ff0@0,33f@14,f43@30,fd0@45,7df@56,ad0@68,f2f@91,fd0@115,06b@129,faf@142,f43@154,fd0@167,7df@184,ad0@197,06b@211,a19@225,f90@235,ad0@246,ff0@255&steps=256&blendMode=linear&ditherMode=off&target=amigaOcs
        dc.w    $ff0,$ff1,$ee2,$dd3,$cc4,$bb5,$aa6,$998
        dc.w    $889,$77a,$66b,$55c,$55d,$44e,$33f,$43f
        dc.w    $43e,$53d,$63c,$73b,$83b,$83a,$939,$a38
        dc.w    $b38,$b37,$c46,$d45,$e44,$f44,$f43,$f43
        dc.w    $f52,$f62,$f62,$f72,$f81,$f81,$f91,$fa1
        dc.w    $fa1,$fb0,$fb0,$fc0,$fd0,$fd0,$fd1,$ed2
        dc.w    $dd4,$cd5,$cd7,$bd8,$ada,$9db,$9dd,$8de
        dc.w    $7df,$7de,$8dd,$8db,$8da,$8d9,$9d8,$9d6
        dc.w    $9d5,$9d4,$ad2,$ad1,$ad0,$ad0,$bc1,$bc2
        dc.w    $bb2,$bb3,$ca4,$ca4,$c95,$c96,$c86,$d87
        dc.w    $d78,$d79,$d69,$e6a,$e5b,$e5b,$e4c,$f4d
        dc.w    $f3d,$f3e,$f2f,$f2f,$f2f,$f3e,$f3d,$f4d
        dc.w    $f4c,$f5b,$f5b,$f6a,$f69,$f79,$f78,$f88
        dc.w    $f87,$f96,$f96,$f95,$fa4,$fa4,$fb3,$fb2
        dc.w    $fc2,$fc1,$fd0,$fd0,$ed0,$dc1,$cc2,$bb3
        dc.w    $ab4,$9a5,$8a5,$696,$597,$488,$389,$27a
        dc.w    $16a,$06b,$16c,$27c,$37c,$47d,$68d,$78d
        dc.w    $88e,$99e,$b9e,$c9e,$daf,$eaf,$faf,$fae
        dc.w    $f9d,$f9c,$f8b,$f8a,$f79,$f68,$f67,$f56
        dc.w    $f55,$f44,$f43,$f52,$f52,$f62,$f72,$f72
        dc.w    $f81,$f91,$fa1,$fa1,$fb0,$fc0,$fd0,$fd0
        dc.w    $fd0,$ed1,$ed2,$dd3,$dd4,$cd5,$cd6,$bd7
        dc.w    $bd8,$ad9,$ada,$9db,$9dc,$8dd,$8de,$7df
        dc.w    $7df,$7de,$7dd,$8dc,$8db,$8d9,$8d8,$9d7
        dc.w    $9d6,$9d4,$9d3,$ad2,$ad1,$ad0,$9d0,$9c1
        dc.w    $8c2,$7b3,$6b4,$6a5,$5a5,$496,$397,$388
        dc.w    $289,$17a,$06a,$06b,$06b,$15b,$25b,$34b
        dc.w    $34b,$44a,$53a,$63a,$63a,$72a,$82a,$919
        dc.w    $919,$a19,$b18,$b27,$c36,$c45,$d54,$d63
        dc.w    $e72,$e71,$f80,$f90,$fa0,$fa0,$ea0,$eb0
        dc.w    $db0,$db0,$cc0,$cc0,$bd0,$bd0,$ad0,$be0
        dc.w    $be0,$ce0,$de0,$df0,$ef0,$ef0,$ff0,$ff0
        endif

        include "rampels_cpp.asm"

********************************************************************************
        bss
********************************************************************************

bkg_frames_loop: ds.w BKG_FRAMES_NUM*CHUNKY_H
