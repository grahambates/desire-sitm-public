        include "includes/hw.i"
        include "includes/macros.i"

********************************************************************************
        code
********************************************************************************

HAM_CHUNKY_W = 96
HAM_CHUNKY_H = 47
; 80*56=4480
; 88*51=4488
; 96*47=4512

HAM_CHUNKY_Y = HAM_DIW_YSTRT
HAM_CHUNKY_STOP = HAM_CHUNKY_Y+HAM_CHUNKY_H*PIXH

TEX_REPT = 1
PIXH = 4

HAM_DIW_W = HAM_CHUNKY_W*4
HAM_DIW_H = HAM_CHUNKY_H*PIXH+34
HAM_DIW_BW = HAM_DIW_W/16*2
HAM_BPLS = 4
; HAM_DIW_XSTRT = ($242-HAM_DIW_W)/2
HAM_DIW_YSTRT = ($158-HAM_DIW_H)/2
; HAM_DIW_XSTOP = HAM_DIW_XSTRT+HAM_DIW_W
HAM_DIW_YSTOP = HAM_DIW_YSTRT+HAM_DIW_H

HAM_SCREEN_SIZE = HAM_DIW_BW*HAM_CHUNKY_H*HAM_BPLS ; byte size of screen buffer
HAM_SCREEN_BPL = HAM_DIW_BW*HAM_CHUNKY_H ; bitplane offset (non-interleaved)

C2P_BLT_SIZE = (HAM_DIW_BW*HAM_CHUNKY_H*16)+1

********************************************************************************
HamInit:
        ; Precalc scrambled texture:
        lea     Tex,a0
        lea     ScrambledTex,a1
        move.w  #TEX_W*TEX_H,d0
        bra     ScrambleTexture


********************************************************************************
HamEffect:
        ; Install blitter interrupt
        move.l  VbrAddr,a4
        move.l  #HamInterrupt,$6c(a4)

        ; Install copper and enable DMA
        lea     custom,a6
        jsr     WaitEOF
        move.l  #HamCop,cop1lc(a6)
        move.l  CopPtr,a0
        adda.w  #CopScroller-Cop,a0 ; shared scroller section in cop2
        move.l  a0,cop2lc(a6)
        bsr     InitBpls

        move.w  #DMAF_SETCLR!DMAF_MASTER!DMAF_COPPER!DMAF_RASTER!DMAF_BLITTER,dmacon(a6)
        move.w  #INTF_SETCLR!INTF_INTEN!INTF_BLIT,intena(a6)
        lea     custom+C,a6

.mainLoop:
        ; Sync to DIW_YSTOP for max DMA
        ; move.w  #$f00,$dff180
.sync:  move.l  vposr-C(a6),d1
        and.l   #$1ff00,d1
        cmp.l   #(HAM_CHUNKY_STOP-20)<<8,d1
        bne.s   .sync
        ; move.w  #$000,$dff180

        jsr     UpdateScroller ; leave sufficient space between this and StartC2pBlit

        lea     $dff0a0,a6
        jsr     LSP_MusicPlayTickInsane

        ; swap buffers
        movem.l DblBuffers(pc),a0-a3
        exg     a0,a1
        exg     a2,a3
        movem.l a0-a3,DblBuffers

        ; poke bitplanes
        lea     HamCopBplPt+2,a2
        rept    HAM_BPLS
        move.l  a1,d0
        swap    d0
        move.w  d0,(a2) ; hi
        move.w  a1,4(a2) ; lo
        addq    #8,a2
        adda.w  #HAM_SCREEN_BPL,a1
        endr

        bsr     StartC2pBlit

        jsr     Script
        jsr     TransitionsTick
        jsr     UpdateVars
        bsr     DrawRotoHam

        btst    #CIAB_GAMEPORT0,ciaa ; Left mouse button not pressed?
        bne     .mainLoop
        rts


********************************************************************************
InitBpls:
        move.l  DrawScreen,a1
        lea     HamCopBplPt+2,a2
        rept    HAM_BPLS
        move.l  a1,d0
        swap    d0
        move.w  d0,(a2) ; hi
        move.w  a1,4(a2) ; lo
        addq    #8,a2
        endr
        rts


********************************************************************************
HamInterrupt:
********************************************************************************
        move.l  a0,-(sp)
        move.w  #INTF_BLIT,intreq-C(a6) ; acknowledge the blitter irq
        move.l  BlitNext(pc),-(sp)
        rts


INT_EXIT macro
        move.l  (sp)+,a0
        rte
        endm

IntNop: INT_EXIT

********************************************************************************
; Scramble RGB bits:
;    [-- -- -- -- 11 10  9  8  7  6  5  4  3  2  1  0]
;    [-- -- -- -- r3 r2 r1 r0 g3 g2 g1 g0 b3 b2 b1 b0]
;    [11  7  3  3 10  6  2  2  9  5  1  1  8  4  0  0]
;    [r3 g3 b3 b3 r2 g2 b2 b2 r1 g1 b1 b1 r0 g0 b0 b0]
;-------------------------------------------------------------------------------
; a0 - src
; a1 - dest
; d0.w - TEX_W*TEX_H
;-------------------------------------------------------------------------------
ScrambleTexture:
        move.w  d0,d6
        subq    #1,d6

        ifne    TEX_REPT 
        move.l  a1,a2
        ext.l   d0
        add.l   d0,d0
        adda.l  d0,a2
        endc
        moveq   #0,d0
.l:
        move.b  (a0)+,d0
        add.b   d0,d0
        move.w  .red(pc,d0.w),d1

        move.b  (a0)+,d0
        moveq   #$f,d2
        and.w   d0,d2
        add.b   d2,d2
        or.w    .blue(pc,d2.w),d1

        lsr.b   #4,d0
        add.b   d0,d0
        or.w    .green(pc,d0.w),d1
        move.w  d1,(a1)+
        ifne    TEX_REPT 
        move.w  d1,(a2)+
        endc
        dbf     d6,.l
        rts

.red:   dc.w    $0000,$0008,$0080,$0088,$0800,$0808,$0880,$0888,$8000,$8008,$8080,$8088,$8800,$8808,$8880,$8888
.green: dc.w    $0000,$0004,$0040,$0044,$0400,$0404,$0440,$0444,$4000,$4004,$4040,$4044,$4400,$4404,$4440,$4444
.blue:  dc.w    $0000,$0003,$0030,$0033,$0300,$0303,$0330,$0333,$3000,$3003,$3030,$3033,$3300,$3303,$3330,$3333



********************************************************************************
StartC2pBlit:
        lea     custom+C,a6
        move.w  #INTF_SETCLR!INTF_INTEN!INTF_BLIT,intena-C(a6)
.blitWait: btst #DMAB_BLTDONE,dmaconr-C(a6)
        bne.s   .blitWait
; Input: Chunky buffer (consecutive words)
; [Ar3 Ag3 Ab3 Ab3 Ar2 Ag2 Ab2 Ab2 Ar1 Ag1 Ab1 Ab1 Ar0 Ag0 Ab0 Ab0]
; [Br3 Bg3 Bb3 Bb3 Br2 Bg2 Bb2 Bb2 Br1 Bg1 Bb1 Bb1 Br0 Bg0 Bb0 Bb0]
; [Cr3 Cg3 Cb3 Cb3 Cr2 Cg2 Cb2 Cb2 Cr1 Cg1 Cb1 Cb1 Cr0 Cg0 Cb0 Cb0]
; [Dr3 Dg3 Db3 Db3 Dr2 Dg2 Db2 Db2 Dr1 Dg1 Db1 Db1 Dr0 Dg0 Db0 Db0]
; ...
;
; Output: Bitplanes (not interleaved)
; [Ar0 Ag0 Ab0 Ab0 Br0 Bg0 Bb0 Bb0 Cr0 Cg0 Cb0 Cb0 Dr0 Dg0 Db0 Db0]... bpl0
; [Ar1 Ag1 Ab1 Ab1 Br1 Bg1 Bb1 Bb1 Cr1 Cg1 Cb1 Cb1 Dr1 Dg1 Db1 Db1]... bpl1
; [Ar2 Ag2 Ab2 Ab2 Br2 Bg2 Bb2 Bb2 Cr2 Cg2 Cb2 Cb2 Dr2 Dg2 Db2 Db2]... bpl2
; [Ar3 Ag3 Ab3 Ab3 Br3 Bg3 Bb3 Bb3 Cr3 Cg3 Cb3 Cb3 Dr3 Dg3 Db3 Db3]... bpl3
********************************************************************************
BlitSwap1:
; Chunky -> ChunkyTmp
; 8x2 swap to temporary buffer;
        move.w  #4,bltbmod-C(a6)
        move.l  #4<<16!4,bltamod-C(a6)
        move.w  #$00ff,bltcdat-C(a6)
        move.l  #-1,bltafwm-C(a6)
;-------------------------------------------------------------------------------
; ((a > 8) & 0x00FF) | (b & 0xFF00)
; Chunky -> ChunkyTmp:
; [Ar3 Ag3 Ab3 Ab3 Ar2 Ag2 Ab2 Ab2 Cr3 Cg3 Cb3 Cb3 Cr2 Cg2 Cb2 Cb2]
; [Br3 Bg3 Bb3 Bb3 Br2 Bg2 Bb2 Bb2 Dr3 Dg3 Db3 Db3 Dr2 Dg2 Db2 Db2]
; [                                                               ]
; [                                                               ]
        move.l  #(BLTEN_ABD!(BLT_A&BLT_C)!(BLT_B&~BLT_C)!(8<<12))<<16,bltcon0-C(a6)
        move.l  C2pChunky(pc),a0
        move.l  a0,bltbpt-C(a6)
        addq.w  #4,a0
        move.l  a0,bltapt-C(a6)
        move.l  #ChunkyTmp,bltdpt-C(a6)
        move.w  #C2P_BLT_SIZE+1,bltsize-C(a6) ; Height > max for OCS - split into two ops
        move.l  #BlitSwap1Cont,BlitNext
        rts

BlitSwap1Cont:
        move.w  #C2P_BLT_SIZE+1,bltsize-C(a6)
        move.l  #BlitSwap2,BlitNext
        INT_EXIT
********************************************************************************
BlitSwap2:
; Chunky -> ChunkyTmp
;-------------------------------------------------------------------------------
; ((a << 8) & 0xFF00) | (b & 0x00FF)
; ChunkyTmp:
; [Ar3 Ag3 Ab3 Ab3 Ar2 Ag2 Ab2 Ab2 Cr3 Cg3 Cb3 Cb3 Cr2 Cg2 Cb2 Cb2]
; [Br3 Bg3 Bb3 Bb3 Br2 Bg2 Bb2 Bb2 Dr3 Dg3 Db3 Db3 Dr2 Dg2 Db2 Db2]
; [Ar1 Ag1 Ab1 Ab1 Ar0 Ag0 Ab0 Ab0 Cr1 Cg1 Cb1 Cb1 Cr0 Cg0 Cb0 Cb0]
; [Br1 Bg1 Bb1 Bb1 Br0 Bg0 Bb0 Bb0 Dr1 Dg1 Db1 Db1 Dr0 Dg0 Db0 Db0]
        move.l  #(BLTEN_ABD!(BLT_A&~BLT_C)!(BLT_B&BLT_C)!(8<<12))<<16!BC1F_DESC,bltcon0-C(a6)
        move.l  C2pChunky(pc),a0
        adda.w  #HAM_SCREEN_SIZE-6,a0
        move.l  a0,bltapt-C(a6)
        addq.w  #4,a0
        move.l  a0,bltbpt-C(a6)
        lea     ChunkyTmp,a0
        adda.w  #HAM_SCREEN_SIZE-2,a0
        move.l  a0,bltdpt-C(a6)
        move.w  #C2P_BLT_SIZE+1,bltsize-C(a6)
        move.l  #BlitSwap2Cont,BlitNext
        INT_EXIT
BlitSwap2Cont:
        move.w  #C2P_BLT_SIZE+1,bltsize-C(a6)
        move.l  #BlitBpl3,BlitNext
        INT_EXIT
********************************************************************************
BlitBpl3:
; ChunkyTmp -> DrawScreen
; Copy from tmp buffer to bitplanes
        move.w  #6,bltbmod-C(a6)
        move.l  #(6<<16),bltamod-C(a6)
        move.w  #$0f0f,bltcdat-C(a6)
;-------------------------------------------------------------------------------
; ((a >> 4) & 0x0F0F) | (b & 0xF0F0)
; [Ar3 Ag3 Ab3 Ab3 Br3 Bg3 Bb3 Bb3 Cr3 Cg3 Cb3 Cb3 Dr3 Dg3 Db3 Db3]
        move.l  #(BLTEN_ABD!(BLT_A&BLT_C)!(BLT_B&~BLT_C)!(4<<12))<<16,bltcon0-C(a6)
        lea     ChunkyTmp,a0
        move.l  a0,bltbpt-C(a6)
        addq.w  #2,a0
        move.l  a0,bltapt-C(a6)
        move.l  DrawScreen(pc),a0
        adda.w  #HAM_SCREEN_BPL*3,a0 ; bpl 3
        move.l  a0,bltdpt-C(a6)
        move.w  #C2P_BLT_SIZE,bltsize-C(a6)
        move.l  #BlitBpl3Cont,BlitNext
        INT_EXIT
BlitBpl3Cont:
        move.w  #C2P_BLT_SIZE,bltsize-C(a6)
        move.l  #BlitBpl1,BlitNext
        INT_EXIT
********************************************************************************
BlitBpl1:
;-------------------------------------------------------------------------------
; ((a >> 4) & 0x0F0F) | (b & 0xF0F0)
; [Ar1 Ag1 Ab1 Ab1 Br1 Bg1 Bb1 Bb1 Cr1 Cg1 Cb1 Cb1 Dr1 Dg1 Db1 Db1]
        lea     ChunkyTmp+4,a0
        move.l  a0,bltbpt-C(a6)
        addq.w  #2,a0
        move.l  a0,bltapt-C(a6)
        move.l  DrawScreen(pc),a0
        adda.w  #HAM_SCREEN_BPL,a0 ; bpl 1
        move.l  a0,bltdpt-C(a6)
        move.w  #C2P_BLT_SIZE,bltsize-C(a6)
        move.l  #BlitBpl1Cont,BlitNext
        INT_EXIT
BlitBpl1Cont:
        move.w  #C2P_BLT_SIZE,bltsize-C(a6)
        move.l  #BlitBpl2,BlitNext
        INT_EXIT
********************************************************************************
BlitBpl2:
;-------------------------------------------------------------------------------
; ((a << 8) & ~0x0F0F) | (b & 0x0F0F)
; [Ar2 Ag2 Ab2 Ab2 Br2 Bg2 Bb2 Bb2 Cr2 Cg2 Cb2 Cb2 Dr2 Dg2 Db2 Db2]
        move.l  #(BLTEN_ABD!(BLT_A&~BLT_C)!(BLT_B&BLT_C)!(4<<12))<<16!BC1F_DESC,bltcon0-C(a6)
        lea     ChunkyTmp+HAM_SCREEN_SIZE-8,a0
        move.l  a0,bltapt-C(a6)
        addq.w  #2,a0
        move.l  a0,bltbpt-C(a6)
        move.l  DrawScreen(pc),a0
        adda.w  #HAM_SCREEN_BPL*3-2,a0 ; bpl2 (rev)
        move.l  a0,bltdpt-C(a6)
        move.w  #C2P_BLT_SIZE,bltsize-C(a6)
        move.l  #BlitBpl2Cont,BlitNext
        INT_EXIT
BlitBpl2Cont:
        move.w  #C2P_BLT_SIZE,bltsize-C(a6)
        move.l  #BlitBpl0,BlitNext
        INT_EXIT

BlitBpl0:
;-------------------------------------------------------------------------------
; [Ar0 Ag0 Ab0 Ab0 Br0 Bg0 Bb0 Bb0 Cr0 Cg0 Cb0 Cb0 Dr0 Dg0 Db0 Db0]
        lea     ChunkyTmp+HAM_SCREEN_SIZE-4,a0
        move.l  a0,bltapt-C(a6)
        addq.w  #2,a0
        move.l  a0,bltbpt-C(a6)
        move.l  DrawScreen(pc),a0
        adda.w  #HAM_SCREEN_BPL-2,a0 ; bpl0 (rev)
        move.l  a0,bltdpt-C(a6)
        move.w  #C2P_BLT_SIZE,bltsize-C(a6)
        move.l  #BlitBpl0Cont,BlitNext
        INT_EXIT
BlitBpl0Cont:
        move.w  #INTF_BLIT,intena-C(a6) ; scroll blit shouldn't trigger interrupt
        move.w  #C2P_BLT_SIZE,bltsize-C(a6)
        move.l  #IntNop,BlitNext
        INT_EXIT


********************************************************************************
DrawRotoHam:
;-------------------------------------------------------------------------------
; Calculate uv gradient deltas:
; duDy = sin(a) * scale
; dvDy = cos(a) * scale
; duDx = cos(a) * scale
; dvDx = -sin(a) * scale
        ; movem.w RotVars,d2-d4 ; angle, scale, skew
        movem.w RotVars(pc),d2-d3 ; angle, scale, skew

        ; angle
        and.w   #SIN_MASK,d2
        add.w   d2,d2
        lea     Sin,a0
        move.w  (a0,d2.w),d0 ; d0 = sin(a) PF 1:14
        add.w   #SIN_LEN/2,d2 ; cos(a) = sin(a + 90)
        move.w  (a0,d2.w),d1 ; d1 = cos(a) FP 1:14

        ; scale
        FPMULS15 d3,d0
        FPMULS15 d3,d1

        ; skew
        move.w  d1,d5   ; d5 = duDx = cos(a) * scale + SkewX
        ; add.w   d4,d5
        ; sub.w   d0,d4   ; d4 = dvDx = -sin(a) * scale + SkewX
        move.w  d0,d4   ; d4 = dvDx = -sin(a) * scale + SkewX
        neg.w   d4

;-------------------------------------------------------------------------------
; Center offset:
; u = TEX_W/2 - (CHUNKY_W/2 * dvDy + CHUNKY_H/2 * duDy);
; v = TEX_H/2 - (CHUNKY_W/2 * dvDx + CHUNKY_H/2 * duDx);

        move.w  #HAM_CHUNKY_W/2,d2
        muls    d1,d2   ; CHUNKY_W/2 * dvDy
        move.w  #HAM_CHUNKY_H/2,d3
        muls    d0,d3   ; CHUNKY_H/2 * duDy
        add.w   d3,d2
        neg.w   d2      ; -(CHUNKY_W/2 * dvDy + CHUNKY_H/2 * duDy)
        add.w   #(TEX_W/2)<<8,d2 ; u = TEX_W/2 - (CHUNKY_W/2 * dvDy + CHUNKY_H/2 * duDy);
        move.w  d2,CenterOfsU

        move.w  #HAM_CHUNKY_W/2,d2
        muls    d4,d2   ; CHUNKY_W/2 * dvDx
        move.w  #HAM_CHUNKY_H/2,d3
        muls    d5,d3   ; CHUNKY_H/2 * duDx
        add.w   d3,d2
        neg.w   d2
        add.w   #(TEX_H/2)<<8,d2 ; v = TEX_H/2 - (CHUNKY_W/2 * dvDx + CHUNKY_H/2 * duDx);
        move.w  d2,CenterOfsV

;-------------------------------------------------------------------------------
; Write SMC offsets

        PRE_ADDX d4,d5

        lea     .SmcLoop+2(pc),a0
        moveq   #0,d2   ; v accumulator
        moveq   #0,d3   ; u accumulator
        move.w  #$7ffe,d6 ; mask


        rept    HAM_CHUNKY_W
        add.l   d4,d2
        addx.w  d5,d3
        move.w  d2,d7
        move.b  d3,d7
        and.w   d6,d7   ; mask
        move.w  d7,REPTN*4(a0)
        endr

;-------------------------------------------------------------------------------
; Write pixels
        lea     ScrambledTex,a3 ; source texture

        move.w  Pan(pc),d2 ; scroll texture for panning effect
        and.w   #(TEX_W-1)*2,d2 
        adda.w  d2,a3

        ; start at center offset
        ; moveq   #0,d2
        move.w  CenterOfsV(pc),d2
        move.w  CenterOfsU(pc),d3
        PRE_ADDX d2,d3

        move.w  Distort(pc),d4

        PRE_ADDX d1,d0

        move.l  DrawChunky(pc),a1

        move.w  Height(pc),d7
        bra     .SmcLoopE
.SmcLoopL:
        add.l   d1,d2
        addx.w  d0,d3
        move.w  d2,d5
        move.b  d3,d5

        add.w   d4,d1   ; distort

        and.w   d6,d5   ; mod to tex size
        lea     (a3,d5.w),a0 ; offset Tex
.SmcLoop:
        rept    HAM_CHUNKY_W
        move.w  $1234(a0),(a1)+
        endr
.SmcLoopE:
        dbf     d7,.SmcLoopL
        rts

********************************************************************************

DblBuffers:
DrawScreen: dc.l Screen1
ViewScreen: dc.l Screen2
DrawChunky: dc.l Screen3
C2pChunky: dc.l Screen4

BlitNext: dc.l  IntNop

*******************************************************************************
        data_c
*******************************************************************************

*******************************************************************************
HamCop:
        dc.w    diwstrt,HAM_DIW_YSTRT<<8!$51
        dc.w    diwstop,(HAM_DIW_YSTOP-256)<<8!$d1
        dc.w    ddfstrt,$20 ; http://coppershade.org/articles/AMIGA/Denise/Maximum_Overscan/
        dc.w    ddfstop,$d8
        dc.w    bplcon0,(7<<12)!(1<<11)!$200
        dc.w    bplcon1,0

        ; sprite to mask left fringing
        dc.w    color17,$000
        dc.w    spr0pos,$2f-8
        dc.w    spr0datb,0

        dc.w    color00,$112
CopOffs set     DIW_YSTRT

        COP_BG  4,$224
        COP_BG  9,$234
        COP_BG  14,$67c
        COP_BG  15,$000

; 1   r0 g0 b0 b0
; 2   r1 g1 b1 b1
; 3   r2 g2 b2 b2
; 4   r3 g3 b3 b3
; 5 - 0  1  1  1  rgbb
; 6 - 1  1  0  0  rbbb
HamCopBplPt: rept HAM_BPLS*2
        dc.w    bplpt+REPTN*2,0
        endr
        dc.w    bpldat+4*2,$7777 ; fixed data for bpl 5 - rgbb: 0111
        dc.w    bpldat+5*2,$cccc ; fixed data for bpl 6 - rgbb: 1100

        ; Trigger sprite
        dc.w    spr0data,$e000

CopY    set     HAM_CHUNKY_Y-1
        COP_WAIT CopY,$10
        dc.w    color00,0

; Repeat lines:
        rept    HAM_CHUNKY_H
        COP_WAIT CopY,$df
        dc.w    bpl1mod,-HAM_DIW_BW ; repeat line
        dc.w    bpl2mod,-HAM_DIW_BW
        ; PAL fix
        ; ifge    (CopY&$ff)-$fd
        ; COP_WAIT $ff,$df
        ; endc
        COP_WAIT CopY+PIXH-1,$df
        dc.w    bpl1mod,0 ; move to next line
        dc.w    bpl2mod,0
CopY    set     CopY+PIXH
        endr

        ; Stop sprite
        dc.w    spr0ctl,$0000

        ; jump to scroller
        dc.w    copjmp2,0 

*******************************************************************************
        bss_c
*******************************************************************************

Screen1: ds.b   HAM_SCREEN_SIZE
Screen2: ds.b   HAM_SCREEN_SIZE
Screen3: ds.b   HAM_SCREEN_SIZE
Screen4: ds.b   HAM_SCREEN_SIZE
ChunkyTmp: ds.b HAM_SCREEN_SIZE


*******************************************************************************
        bss
*******************************************************************************

ScrambledTex: ds.b TEX_W*TEX_H*4