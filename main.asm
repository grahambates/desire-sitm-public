        include "includes/startup.i"

********************************************************************************

TEST_PATTERN = 0        ; Debug chunky display mode

CHUNKY_W = 73
CHUNKY_H = 41
CHUNKY_Y = DIW_YSTRT+LOGO_H

COPX = $44              ; color00 wait pos
SPRX = $56              ; first x pos of fixed sprites
CPUX = $7f+$36-20-20-16 ; cpu interrupt pos

TEX_W = 128
TEX_H = 128

COP_SIZE = CopE-Cop

LOGO_H = 40
LOGO_BPLS = 4
LOGO_W = 288
LOGO_BW = LOGO_W/8
LOGO_MOD = LOGO_BW*(LOGO_BPLS-1)
LOGO_MOD_SKIP = LOGO_BW*(LOGO_BPLS*2-1)
LOGO_MOD_REPT = -LOGO_BW

FONT_H = 16
FONT_W = 16

SCROLL_Y = 210-4
SCROLL_H = 24
SCROLL_DIW_W = 320
SCROLL_DIW_BW = SCROLL_DIW_W/8
SCROLL_BPLS = 1
SCROLL_W = SCROLL_DIW_W+FONT_W+16
SCROLL_BW = SCROLL_W/8
SCROLL_BUFFER_SIZE = FONT_H*SCROLL_BW*SCROLL_BPLS+(SCROLL_DIW_W*20) ; how many screens before wrap?
SCROLL_DIW_XSTRT = $81+(320-SCROLL_DIW_W)/2
SCROLL_DIW_XSTOP = SCROLL_DIW_XSTRT+SCROLL_DIW_W

CTRL_PAUSE = -2
CTRL_SPEED = -4
CTRL_BOLD = -6
CTRL_REG = -8
CTRL_WAIT_FRAME = -10
CTRL_END = -12

SIN_LEN = 1024
SIN_AMP = $4000
SIN_MASK = SIN_LEN-1
SIN_MASK2 = (SIN_LEN-1)*2

; Music measures to frames for sync
BPM = 125
T_BEAT = 3000/BPM       ;24 3000 frames per minute at 50hz
T_BAR = T_BEAT*4        ;96
T_PATTERN = T_BAR*4

; Dispaly setup:
DIW_W = 288             ; Display window width
DIW_H = 256             ; Display window height

DIW_BW = DIW_W/16*2     ; Display window bit width

; Display windows bounds for centered PAL display:
DIW_XSTRT = $81+(320-DIW_W)/2
DIW_YSTRT = $2c+(256-DIW_H)/2
DIW_XSTOP = DIW_XSTRT+DIW_W
DIW_YSTOP = DIW_YSTRT+DIW_H

; Initial DMA/Interrupt bits:
DMASET = DMAF_SETCLR!DMAF_MASTER!DMAF_COPPER!DMAF_RASTER!DMAF_BLITTER
INTSET = INTF_SETCLR!INTF_INTEN!INTF_COPER

C = bltsize             ; Custom offset to benefit from no offset (a6) on most common reg

CopOffs set     0

COP_BG  macro
        COP_WAIT CopOffs+\1,$10
        dc.w    color00,\2
        endm
COP_COL1 macro
        COP_WAIT CopOffs+\1,$10
        dc.w    color01,\2
        endm

********************************************************************************
Entrypoint:
********************************************************************************
        move.w  #$000,color00(a6)

        ; Precalc things...
        jsr     bkg_Start ; 1/4 PELLICUS: Initialize background bars, Precalc 16 secs
        jsr     HamInit

        move.l  a4,VbrAddr

        move.l  #CopInterrupt,$6c(a4)
        move.l  #.trapit,$80(a4) ; STOP on trap

        bsr     InitSprites
        bsr     InitLogo
        bsr     InitCopper

        ; Init bitplane pointers
        move.l  #Pattern,d0
        move.l  CopPtr,a1
        adda.w  #CopChunkyPatBpl-Cop+2,a1
        move.w  d0,4(a1)
        swap    d0
        move.w  d0,(a1)

        ; Init music
        lea     LSMusic,a0
        lea     LSBank,a1
        move.l  CopPtr,a2
        adda.w  #CopDma-Cop+3,a2
        jsr     LSP_MusicInitInsane

        ; Init blitter
        move.l  #$9f00000,bltcon0(a6)
        move.l  #-1,bltafwm(a6)
        move.l  #SCROLL_BW-2,bltamod(a6)

        SCRIPT_INIT Script

        bsr     WaitEOF
        move.l  CopPtr,cop1lc(a6)
        move.w  #DMASET,dmacon(a6)
        move.w  #INTSET,intena(a6)

        ;-------------------------------------------------------------------------------
.mainLoop:
        trap    #0
        btst    #CIAB_GAMEPORT0,ciaa ; Left mouse button not pressed?
        beq     .exit

        move.w  EndPart1(pc),d0
        beq     .mainLoop

        move.w  #DMAF_RASTER,dmacon+custom
        move.w  #$7fff,intena+custom
        jmp     HamEffect
.exit:
        move.w  #$7fff,intena+custom
        rts

.trapit:
        stop    #$2000
        rte

MUSIC_START = T_BEAT*2
PART2_START = MUSIC_START+T_PATTERN*7+T_BAR*2

********************************************************************************
Script:
        SCRIPT_START
        TRANSITION_U Height,CHUNKY_H,5,TRANSITION_EASE_IN_OUT_SIN
        SCRIPT_WAIT MUSIC_START+T_BAR*2
        TRANSITION_U LogoH,LOGO_H,5,TRANSITION_EASE_IN_OUT_SIN
        SCRIPT_WAIT MUSIC_START+T_PATTERN*2-T_BEAT*2
        TRANSITION_U PanSpeed,4,5
        SCRIPT_WAIT MUSIC_START+T_PATTERN*5
        move.w  #2,AngleSpeed
        TRANSITION_U AngleAmp,$800,5
        SCRIPT_WAIT MUSIC_START+T_PATTERN*6+T_BAR*2
        TRANSITION_U Height,0,5,TRANSITION_EASE_IN_OUT_SIN
        SCRIPT_WAIT MUSIC_START+T_PATTERN*7
        TRANSITION_U LogoH,0,5,TRANSITION_EASE_IN_OUT_SIN
        SCRIPT_WAIT PART2_START
        move.w  #1,EndPart1
        ; move.w  #0,AngleAmp
        SCRIPT_WAIT PART2_START+T_BEAT
        TRANSITION_U Height,HAM_CHUNKY_H,5
        ; SCRIPT_WAIT PART2_START+T_PATTERN*1+T_BAR*2
        ; TRANSITION_U AngleAmp,$800,5
        SCRIPT_WAIT PART2_START+T_PATTERN*4
        TRANSITION_U Distort,8,7
        SCRIPT_WAIT PART2_START+T_PATTERN*6+T_BAR*2
        TRANSITION_U Distort,0,5
        ; SCRIPT_WAIT T_PATTERN*6
        ; TRANSITION_U SkewAmp,$200,7
        SCRIPT_END
        rts


********************************************************************************
* Routines
********************************************************************************


********************************************************************************
InitCopper:
        ; Find position in BSS buffer where copperlist won't cross 64k boundary
        move.l  #CopBss,d0
        move.l  #CopBss+COP_SIZE,d1

        ; compare upper words
        swap    d0
        swap    d1
        cmp.w   d0,d1
        beq     .ok
        exg     d0,d1   ; use upper part of bss
.ok:
        ; store ptr
        swap    d0
        move.l  d0,CopPtr

        ; copy data
        move.l  d0,a0
        lea     Cop,a1
        move.w  #(CopE-Cop)/4-1,d7
.copy:
        move.l  (a1)+,(a0)+
        dbf     d7,.copy

        ; setup loop ptrs
        move.l  d0,a0
        adda.w  #CopLines-Cop+2,a0
        move.l  a0,cop2lc(a6)
        move.w  #CHUNKY_H-1,d7
.l:
        lea     2(a0),a1
        move.w  a1,(a0)
        adda.w  #CopLineE-CopLines,a0
        dbf     d7,.l
        rts


********************************************************************************
InitLogo:
        lea     Logo,a1
        lea     CopLogoBpl+2,a0
        moveq   #LOGO_BPLS-1,d7
.bpl:   move.l  a1,d0
        swap    d0
        move.w  d0,(a0) ; hi
        move.w  a1,4(a0) ; lo
        addq    #8,a0
        lea     LOGO_BW(a1),a1
        dbf     d7,.bpl
        rts


********************************************************************************
InitSprites:
        ; x1
        move.w  #SPRX,spr1pos(a6)
        move.w  #$f00,spr1datb(a6)

        move.w  #SPRX+$10,spr3pos(a6)
        move.w  #$f00,spr3datb(a6)

        move.w  #SPRX+$20,spr5pos(a6)
        move.w  #$f00,spr5datb(a6)

        move.w  #SPRX+$30,spr7pos(a6)
        move.w  #$f00,spr7datb(a6)

        ; x2
        move.w  #SPRX+$40,spr0pos(a6)
        move.w  #$000f,spr0datb(a6)

        move.w  #SPRX+$50,spr2pos(a6)
        move.w  #$000f,spr2datb(a6)

        move.w  #SPRX+$60,spr4pos(a6)
        move.w  #$000f,spr4datb(a6)

        move.w  #SPRX+$70,spr6pos(a6)
        move.w  #$000f,spr6datb(a6)
        rts


********************************************************************************
Update:
        bsr     UpdateLogo
        bsr     UpdateScroller
        bsr     Script
        bsr     TransitionsTick
        bsr     UpdateVars
        ifeq    TEST_PATTERN
        bra     DrawRoto
        endc
        ifne    TEST_PATTERN
        bra     WriteTestPixels
        endc


********************************************************************************
UpdateLogo:
        move.l  CopPtr(pc),a2

; set logo height
        move.w  LogoH(pc),d0
        cmp.w   LastLogoH(pc),d0
        beq     .skip
        move.w  d0,LastLogoH
        lea     LogoLines+2-Cop(a2),a0
        lea     LogoScales,a1
        add.w   d0,d0
        add.w   d0,d0
        move.l  (a1,d0.w),a1

        moveq   #16,d1
        rept    LOGO_H-2
        move.w  (a1)+,d0
        move.w  d0,(a0)
        move.w  d0,4(a0)
        adda.w  d1,a0
        endr
.skip:

        lea     Cos,a0
        move.w  Frame+2(pc),d0

; logo sin scroll
; TODO: can precalc table for this
        lsl.w   #2,d0   ; *12
        move.w  d0,d1
        add.w   d1,d0
        add.w   d1,d0
        and.w   #SIN_MASK2,d0
        move.w  (a0,d0),d0
        add.w   #SIN_AMP,d0
        mulu    #15*2,d0
        swap    d0
        move.w  d0,d1
        lsl.w   #4,d1
        add.w   d1,d0
        move.w  d0,CopLogoScroll-Cop(a2)
        rts


********************************************************************************
UpdateScroller:
        move.l  CopPtr(pc),a2
        lea     Cos,a0
        move.w  Frame+2(pc),d0
; text scroller
        lea     ScrollBuffer,a1
        move.w  ScrollPos(pc),d0

        ; bplcon1 scroll
        move.w  d0,d1
        not.w   d1
        and.w   #$f,d1
        move.w  d1,CopScroll-Cop(a2)
        ; bpl offset
        adda.w  #CopBplScroller-Cop+2,a2
        move.w  d0,d1
        lsr.w   #4,d1
        add.w   d1,d1
        lea     (a1,d1.w),a1
        move.l  a1,d1
        swap    d1
        move.w  d1,(a2) ; hi
        move.w  a1,4(a2) ; lo

        tst.w   ScrollPause
        beq     .noPause
        subq.w  #1,ScrollPause
        rts
.noPause:

        ; Increment scroll position
        move.w  ScrollSpeed(pc),d1
        add.w   d1,ScrollPos

        ; Fetch the next byte every 16px
        moveq   #$f,d1
        and.w   d0,d1
        bne     .done

        move.l  ScrollTextPtr(pc),a2
.readChar:
        move.b  (a2)+,d1 ; read next byte
        blt     .ctrlCode ; negative values are control codes:

        ; Blit character:
        move.l  FontPtr(pc),a0
        sub.w   #$20,d1
        lsl.w   #5,d1
        adda.w  d1,a0
        adda.w  #SCROLL_BW-2,a1
        lea     custom+C,a6
        move.l  #$9f00000,bltcon0-C(a6)
        move.l  #-1,bltafwm-C(a6)
        move.l  #SCROLL_BW-2,bltamod-C(a6)
        movem.l a0-a1,bltapt-C(a6)
        move.w  #16*64+1,bltsize-C(a6)

        move.l  a2,ScrollTextPtr
.done:
        rts

.ctrlCode:
        neg.b   d1
        lea     .jmp-2,a0
        jmp     (a0,d1)
.jmp:
        bra.s   .ctrlPause
        bra.s   .ctrlSpeed
        bra.s   .ctrlBold
        bra.s   .ctrlReg
        bra.s   .ctrlWaitFrame
        bra.s   .ctrlEnd

.ctrlPause:
        move.b  (a2)+,d1
        move.w  d1,ScrollPause
        bra     .readChar
.ctrlSpeed:
        move.b  (a2)+,d1
        move.w  d1,ScrollSpeed
        bra     .readChar
.ctrlBold:
        move.l  #FontBold,FontPtr
        bra     .readChar
.ctrlReg:
        move.l  #Font,FontPtr
        bra     .readChar
.ctrlWaitFrame:
        move.w  (a2)+,d2
        sub.w   Frame+2(pc),d2 ; - current frame
        move.w  d2,ScrollPause
        bra     .readChar
.ctrlEnd:
        move.w  #0,ScrollSpeed
        rts


        ifne    TEST_PATTERN
********************************************************************************
; write a test pattern for debugging
;-------------------------------------------------------------------------------
WriteTestPixels:
        lea     CpuCols,a1
        move.l  CopPtr(pc),a2 ; copper list pointer
        adda.w  #CopLines+6-Cop,a2 ; start of sprite color copper moves
        lea     14*2(a1),a3
        move.w  #10*2,d0
        move.w  #CopLineE-CopLines,d1
        move.w  #14*2,d2
        move.w  #CHUNKY_H-1,d7
.l:
        move.w  #0,13*4(a2) ; col0
        move.w  #$f00,(a3)+
        move.w  #0,14*4(a2) ; col0
        move.w  #$0f0,(a3)+
        move.w  #0,15*4(a2) ; col0
        move.w  #$00f,(a1)+
        move.w  #0,16*4(a2) ; col0
        move.w  #$f00,(a1)+
        move.w  #0,17*4(a2) ; col0
        move.w  #$0ff,(a2) ; spr
        move.w  #0,18*4(a2) ; col0
        move.w  #$0f0,(a1)+
        move.w  #0,19*4(a2) ; col0
        move.w  #$00f,(a1)+
        move.w  #0,20*4(a2) ; col0
        move.w  #$f00,(a1)+
        move.w  #0,21*4(a2) ; col0
        move.w  #$0ff,1*4(a2) ; spr
        move.w  #0,22*4(a2) ; col0
        move.w  #$0f0,(a1)+
        move.w  #0,23*4(a2) ; col0
        move.w  #$00f,(a1)+
        move.w  #0,24*4(a2) ; col0
        move.w  #$f00,(a1)+
        move.w  #0,25*4(a2) ; col0
        move.w  #$0ff,2*4(a2) ; spr
        move.w  #0,26*4(a2) ; col0
        move.w  #$0f0,(a1)+
        move.w  #0,27*4(a2) ; col0
        move.w  #$00f,(a1)+
        move.w  #0,28*4(a2) ; col0
        move.w  #$f00,(a1)+
        move.w  #0,29*4(a2) ; col0
        move.w  #$0ff,3*4(a2) ; spr
        move.w  #0,30*4(a2) ; col0
        move.w  #$0f0,(a1)+
        move.w  #0,31*4(a2) ; col0
        move.w  #$00f,(a1)+
        move.w  #0,32*4(a2) ; col0
        move.w  #$f00,(a1)+
        move.w  #0,33*4(a2) ; col0
        move.w  #$0ff,4*4(a2) ; spr
        move.w  #0,34*4(a2) ; col0
        move.w  #$0ff,5*4(a2) ; spr
        move.w  #0,35*4(a2) ; col0
        move.w  #$0f0,(a3)+ ; offs
        move.w  #0,36*4(a2) ; col0
        move.w  #$00f,(a3)+
        move.w  #0,37*4(a2) ; col0
        move.w  #$0ff,6*4(a2) ; spr
        move.w  #0,38*4(a2) ; col0
        move.w  #$0ff,7*4(a2) ; spr
        move.w  #0,39*4(a2) ; col0
        move.w  #$f00,(a3)+
        move.w  #0,40*4(a2) ; col0
        move.w  #$0f0,(a3)+
        move.w  #0,41*4(a2) ; col0
        move.w  #$0ff,8*4(a2) ; spr
        move.w  #0,42*4(a2) ; col0
        move.w  #$0ff,9*4(a2) ; spr
        move.w  #0,43*4(a2) ; col0
        move.w  #$00f,(a3)+
        move.w  #0,44*4(a2) ; col0
        move.w  #$f00,(a3)+
        move.w  #0,45*4(a2) ; col0
        move.w  #$0ff,10*4(a2) ; spr
        move.w  #0,46*4(a2) ; col0
        move.w  #$0ff,11*4(a2) ; spr
        move.w  #0,47*4(a2) ; col0
        move.w  #$0f0,(a3)+
        move.w  #0,48*4(a2) ; col0
        move.w  #$00f,(a3)+
        move.w  #0,49*4(a2) ; col0

        adda.w  d0,a1
        adda.w  d1,a2
        adda.w  d2,a3

        dbf     d7,.l
        rts
        endc


********************************************************************************
UpdateVars:
        lea     Vars(pc),a5
        addq.l  #1,Frame-Vars(a5)
        move.w  Frame+2(pc),d7

        lea     Sin(pc),a0

        ; Angle:
        ; angle sin
        move.w  d7,d0   ; d0 = a
        lsl.w   #2,d0
        and.w   #SIN_MASK*2,d0
        move.w  (a0,d0.w),d0
        muls    AngleAmp(pc),d0 ; apply amplitude
        swap    d0
        ; angle base
        add.w   BaseAngle(pc),d0
        move.w  d0,Angle-Vars(a5)

        move.w  AngleSpeed(pc),d1 ; increment base angle
        add.w   d1,BaseAngle-Vars(a5)

        ; Scale:
        ; scale sin 1
        move.w  d7,d0
        lsl.w   #3,d0
        add.w   #SIN_LEN/2,d0
        and.w   #SIN_MASK*2,d0
        move.w  (a0,d0.w),d0
        ; scale sin 2
        move.w  d7,d1
        mulu    #12,d1
        and.w   #SIN_MASK*2,d1
        move.w  (a0,d1.w),d1
        add.w   d1,d0
        muls    ScaleAmp(pc),d0 ; apply amplitude
        swap    d0
        ; Scale base
        add.w   BaseScale(pc),d0
        move.w  d0,Scale-Vars(a5)

        ; Tex Offset
        move.w  PanSpeed,d0
        add.w   d0,Pan-Vars(a5) ; increment pan
        ;
        ; ; Skew
        ; mulu    #10,d7
        ; and.w   #SIN_MASK*2,d7
        ; move.w  (a0,d7.w),d7
        ; muls    SkewAmp(pc),d7 ; apply amplitude
        ; swap    d7
        ; move.w  d7,SkewX-Vars(a5)

        rts


********************************************************************************
DrawRoto:
;-------------------------------------------------------------------------------
; Calculate uv gradient deltas:
; duDy = sin(a) * scale
; dvDy = cos(a) * scale
; duDx = cos(a) * scale
; dvDx = -sin(a) * scale
        movem.w RotVars(pc),d2-d4 ; angle, scale, skew

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
        add.w   d4,d5
        sub.w   d0,d4   ; d4 = dvDx = -sin(a) * scale + SkewX

;-------------------------------------------------------------------------------
; Center offset:
; u = TEX_W/2 - (CHUNKY_W/2 * dvDy + CHUNKY_H/2 * duDy);
; v = TEX_H/2 - (CHUNKY_W/2 * dvDx + CHUNKY_H/2 * duDx);

        move.w  #CHUNKY_W/2,d2
        muls    d1,d2   ; CHUNKY_W/2 * dvDy
        move.w  #CHUNKY_H/2,d3
        muls    d0,d3   ; CHUNKY_H/2 * duDy
        add.w   d3,d2
        neg.w   d2      ; -(CHUNKY_W/2 * dvDy + CHUNKY_H/2 * duDy)
        add.w   #(TEX_W/2)<<8,d2 ; u = TEX_W/2 - (CHUNKY_W/2 * dvDy + CHUNKY_H/2 * duDy);
        move.w  d2,CenterOfsU

        move.w  #CHUNKY_W/2,d2
        muls    d4,d2   ; CHUNKY_W/2 * dvDx
        move.w  #CHUNKY_H/2,d3
        muls    d5,d3   ; CHUNKY_H/2 * duDx
        add.w   d3,d2
        neg.w   d2
        add.w   #(TEX_H/2)<<8,d2 ; v = TEX_H/2 - (CHUNKY_W/2 * dvDx + CHUNKY_H/2 * duDx);
        move.w  d2,CenterOfsV

;-------------------------------------------------------------------------------
; Write SMC offsets
        lea     SmcLoop+2(pc),a0

        move.w  #$7ffe,d6

; get UV deltas in combined format for addx trick
; \1 - V
; \2 - U
PRE_ADDX macro
        lsl.l   #8,\2   ; --UUuuuu (15:17) so U is *2 after mask
        add.l   \2,\2
        swap    \1      ; VVvv----
        move.w  \2,\1   ; VVvvuuuu
        swap    \1      ; uuuuVVvv
        swap    \2      ; uuuu--UU (ignore upper word)
        endm

        PRE_ADDX d4,d5

        moveq   #0,d2   ; v accumulator
        moveq   #0,d3   ; u accumulator

X_OFFSET macro
        add.l   d4,d2
        addx.w  d5,d3
        move.w  d2,d7
        move.b  d3,d7
        and.w   d6,d7   ; mask
        move.w  d7,\1-2(a0)
        endm

        ; these write to the exact instruction offsets in SmcLoop
        X_OFFSET $002
        X_OFFSET $008
        X_OFFSET $00c
        X_OFFSET $012
        X_OFFSET $016
        X_OFFSET $01c
        X_OFFSET $020
        X_OFFSET $026
        X_OFFSET $02a
        X_OFFSET $030
        X_OFFSET $034
        X_OFFSET $03a
        X_OFFSET $03e
        X_OFFSET $044
        X_OFFSET $048
        X_OFFSET $04e
        X_OFFSET $052
        X_OFFSET $058
        X_OFFSET $05e
        X_OFFSET $064
        X_OFFSET $068
        X_OFFSET $06e
        X_OFFSET $072
        X_OFFSET $078
        X_OFFSET $07c
        X_OFFSET $082
        X_OFFSET $088
        X_OFFSET $08e
        X_OFFSET $092
        X_OFFSET $098
        X_OFFSET $09c
        X_OFFSET $0a2
        X_OFFSET $0a6
        X_OFFSET $0ac
        X_OFFSET $0b2
        X_OFFSET $0b8
        X_OFFSET $0bc
        X_OFFSET $0c2
        X_OFFSET $0c6
        X_OFFSET $0cc
        X_OFFSET $0d0
        X_OFFSET $0d6
        X_OFFSET $0dc
        X_OFFSET $0e2
        X_OFFSET $0e8
        X_OFFSET $0f2
        X_OFFSET $0f6
        X_OFFSET $0fc
        X_OFFSET $100
        X_OFFSET $106
        X_OFFSET $10c
        X_OFFSET $112
        X_OFFSET $118
        X_OFFSET $11e
        X_OFFSET $122
        X_OFFSET $128
        X_OFFSET $12c
        X_OFFSET $132
        X_OFFSET $138
        X_OFFSET $13e
        X_OFFSET $144
        X_OFFSET $14a
        X_OFFSET $14e
        X_OFFSET $154
        X_OFFSET $158
        X_OFFSET $15e
        X_OFFSET $164
        X_OFFSET $16a
        X_OFFSET $170
        X_OFFSET $176
        X_OFFSET $17a
        X_OFFSET $180
        X_OFFSET $184

;-------------------------------------------------------------------------------
; Write pixels
        lea     CpuCols,a1 ; cpu color table
        move.l  CopPtr(pc),a2 ; copper list pointer
        adda.w  #CopLines+6-Cop,a2 ; start of sprite color copper moves
        lea     Tex,a3  ; source texture

        move.w  Pan(pc),d2 ; scroll texture for panning effect
        and.w   #(TEX_W-1)*2,d2
        adda.w  d2,a3

        ; start at center offset
        ; moveq   #0,d2
        move.w  CenterOfsV(pc),d2
        move.w  CenterOfsU(pc),d3
        PRE_ADDX d2,d3

        move.w  #CopLineE-CopLines,a6
        move.w  Distort(pc),d4

        PRE_ADDX d1,d0

        jsr     bkg_Update ; 2/4 PELLICUS: Update background bars frame pointer.

        move.w  #CHUNKY_H,d7
        sub.w   Height(pc),d7
        bra     ClrLoopE
ClrLoopL:
        ; move.w (a4)+,d5
        moveq   #0,d5
        move.w  d5,13*4(a2) ; col0
        move.w  d5,a5
        move.w  d5,14*4(a2) ; col0
        move.w  d5,d5
        move.w  d5,15*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,16*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,17*4(a2) ; col0
        move.w  d5,(a2) ; spr
        move.w  d5,18*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,19*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,20*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,21*4(a2) ; col0
        move.w  d5,1*4(a2) ; spr
        move.w  d5,22*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,23*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,24*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,25*4(a2) ; col0
        move.w  d5,2*4(a2) ; spr
        move.w  d5,26*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,27*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,28*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,29*4(a2) ; col0
        move.w  d5,3*4(a2) ; spr
        move.w  d5,30*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,31*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,32*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,33*4(a2) ; col0
        move.w  d5,4*4(a2) ; spr
        move.w  d5,34*4(a2) ; col0
        move.w  d5,5*4(a2) ; spr
        move.w  d5,35*4(a2) ; col0
        move.w  a5,(a1)+
        move.w  d5,(a1)+
        move.w  d5,(a1)+ ; offs
        move.w  d5,36*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,37*4(a2) ; col0
        move.w  d5,6*4(a2) ; spr
        move.w  d5,38*4(a2) ; col0
        move.w  d5,7*4(a2) ; spr
        move.w  d5,39*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,40*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,41*4(a2) ; col0
        move.w  d5,8*4(a2) ; spr
        move.w  d5,42*4(a2) ; col0
        move.w  d5,9*4(a2) ; spr
        move.w  d5,43*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,44*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,45*4(a2) ; col0
        move.w  d5,10*4(a2) ; spr
        move.w  d5,46*4(a2) ; col0
        move.w  d5,11*4(a2) ; spr
        move.w  d5,47*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,48*4(a2) ; col0
        move.w  d5,(a1)+
        move.w  d5,49*4(a2) ; col0
        move.w  d5,50*4(a2) ; 3/4 PELLICUS: background

        adda.w  a6,a2
ClrLoopE:
        dbf     d7,ClrLoopL

        move.w  Height(pc),d7
        bra     SmcLoopE
SmcLoopL:
        add.l   d1,d2
        addx.w  d0,d3
        move.w  d2,d5
        move.b  d3,d5

        add.w   d4,d1   ; distort

        and.w   d6,d5   ; mod to tex size
        lea     (a3,d5.w),a0 ; offset Tex
SmcLoop:
        move.w  $1234(a0),13*4(a2) ; col0
        move.w  $1234(a0),a5
        move.w  $1234(a0),14*4(a2) ; col0
        move.w  $1234(a0),d5
        move.w  $1234(a0),15*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),16*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),17*4(a2) ; col0
        move.w  $1234(a0),(a2) ; spr
        move.w  $1234(a0),18*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),19*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),20*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),21*4(a2) ; col0
        move.w  $1234(a0),1*4(a2) ; spr
        move.w  $1234(a0),22*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),23*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),24*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),25*4(a2) ; col0
        move.w  $1234(a0),2*4(a2) ; spr
        move.w  $1234(a0),26*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),27*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),28*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),29*4(a2) ; col0
        move.w  $1234(a0),3*4(a2) ; spr
        move.w  $1234(a0),30*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),31*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),32*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),33*4(a2) ; col0
        move.w  $1234(a0),4*4(a2) ; spr
        move.w  $1234(a0),34*4(a2) ; col0
        move.w  $1234(a0),5*4(a2) ; spr
        move.w  $1234(a0),35*4(a2) ; col0
        move.w  a5,(a1)+
        move.w  d5,(a1)+
        move.w  $1234(a0),(a1)+ ; offs
        move.w  $1234(a0),36*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),37*4(a2) ; col0
        move.w  $1234(a0),6*4(a2) ; spr
        move.w  $1234(a0),38*4(a2) ; col0
        move.w  $1234(a0),7*4(a2) ; spr
        move.w  $1234(a0),39*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),40*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),41*4(a2) ; col0
        move.w  $1234(a0),8*4(a2) ; spr
        move.w  $1234(a0),42*4(a2) ; col0
        move.w  $1234(a0),9*4(a2) ; spr
        move.w  $1234(a0),43*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),44*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),45*4(a2) ; col0
        move.w  $1234(a0),10*4(a2) ; spr
        move.w  $1234(a0),46*4(a2) ; col0
        move.w  $1234(a0),11*4(a2) ; spr
        move.w  $1234(a0),47*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),48*4(a2) ; col0
        move.w  $1234(a0),(a1)+
        move.w  $1234(a0),49*4(a2) ; col0
        ; move.b  d5,50*4+1(a2) ; background
        move.w  (a4)+,50*4(a2) ; 3/4 PELLICUS: background

        adda.w  a6,a2
SmcLoopE:
        dbf     d7,SmcLoopL

        rts



        include "includes/transitions.asm"

********************************************************************************
Vars:
********************************************************************************

VbrAddr: dc.l   0       ; VBR address
Frame:  dc.l    0
ScriptPtr: dc.l 0

CopPtr: dc.l    0       ; Pointer to 64k aligned copperlist

RotVars:
Angle:  dc.w    0
Scale:  dc.w    0
SkewX:  dc.w    0
Pan:    dc.w    0
AngleAmp: dc.w  0
ScaleAmp: dc.w  $300
SkewAmp: dc.w   0
PanSpeed: dc.w  0
BaseScale: dc.w 800
BaseAngle: dc.w 0
AngleSpeed: dc.w 4
Distort: dc.w   0

CenterOfsU: dc.w 0      ; offset to keep rotation around screen center
CenterOfsV: dc.w 0

ScrollPos: dc.w 0
ScrollPause: dc.w 0
ScrollSpeed: dc.w 2
ScrollTextPtr: dc.l TextData

FontPtr: dc.l   Font

Height: dc.w    0
EndPart1: dc.w  0
LogoH:  dc.w    0
LastLogoH: dc.w 0


********************************************************************************
        ; data
********************************************************************************

        include "includes/sin.i"

        dc.b    0
TextData:
        dc.b    CTRL_SPEED,2
        dc.b    CTRL_WAIT_FRAME
        dc.w    MUSIC_START+T_PATTERN ; danger! make sure this is word aligned
        dc.b    "HEY ROTO FANS, "
        dc.b    "GIGABATES HERE. "
        dc.b    "LIFE COMES AT YOU FAST... "
        dc.b    "WHAT WAS ONCE A RECORD IS NOW A DROP IN THE OCEAN. "
        dc.b    "FOR THE COLUMN RECORD ALL YOU GET FOR NOW IS THE TEARS OF A CLOWN. "
        dc.b    "                    "
        dc.b    "BUT WITH NO LOW HANGING FRUIT TO SNACK ON, HOW ABOUT SOME DELICIOUS ",CTRL_BOLD,"HAM",CTRL_REG,"?"
        dc.b    "                      "

        dc.b    CTRL_WAIT_FRAME
        dc.w    PART2_START
        dc.b    "WHY THE WIDE FACE? "
        ; dc.b    "OK, SO WHAT DO WE HAVE HERE? "
        dc.b    "96X47=4512 HAM CHUNKY PIXELS, "
        dc.b    "BEATING OUR OWN ACCIDENTAL RECORD IN INSIDE THE MACHINE, AND EVIL'S ATARI EFFORT. "
        dc.b    "FULL OCS OVERSCAN, JUST FOR FUN. "
        dc.b    "                    "
        dc.b    CTRL_BOLD,"BIG",CTRL_REG," LOVE GOES OUT TO: " 
        dc.b    "RHINO @ HANNIBAL @ BLUEBERRY @ PHOTON @ EVIL @ DJANGO THE BASTARD @ LEONARD @ PLATON @ AND EVERYONE ELSE PUSHING THOSE LIMITS "
        dc.b    "                    "
        dc.b    CTRL_BOLD,"CODE:",CTRL_REG," GIGABATES ; "
        dc.b    "PELLICUS (BACKGROUND EFFECT) ; "
        dc.b    CTRL_BOLD,"GFX:",CTRL_REG," STEFFEST ; "
        dc.b    CTRL_BOLD,"MUSIC:",CTRL_REG," MA2E (ORIGINAL BY STEALER'S WHEEL) "
        dc.b    "                    "
        dc.b    "SCROLLER ENDS. TILL NEXT TIME @"
        dc.b    "                     "
        dc.b    CTRL_END
        even

********************************************************************************
; Doesn't need to be in chip RAM, as it's relocated
;-------------------------------------------------------------------------------
Cop:
        dc.w    diwstrt,DIW_YSTRT<<8!DIW_XSTRT
        dc.w    diwstop,(DIW_YSTOP&$ff)<<8!(DIW_XSTOP&$ff)
        dc.w    ddfstrt,(DIW_XSTRT-17)>>1&$fc
        dc.w    ddfstop,(DIW_XSTRT-17+(DIW_W>>4-1)<<4)>>1&$fc

        dc.w    bplcon0,(LOGO_BPLS<<12)!$100
        dc.w    bplcon1
CopLogoScroll:
        dc.w    0
        dc.w    bpl1mod,LOGO_MOD
        dc.w    bpl2mod,LOGO_MOD
        dc.w    bplcon2,-1
CopLogoBpl:
        rept    LOGO_BPLS*2
        dc.w    bplpt+REPTN*2,0
        endr

        incbin  "data/logo.COP",4
        dc.w    color00,$112

LogoBgCol set   $112
LogoLn  set     0

LOGO_LINE macro
LogoBgCol set   \1
        rept    \2
        dc.w    bpl1mod,LOGO_MOD_REPT
        dc.w    bpl2mod,LOGO_MOD_REPT
        COP_BG  LogoLn,LogoBgCol
LogoLn  set     LogoLn+1
        endr
        endm

CopOffs set     DIW_YSTRT

LogoLines:
        LOGO_LINE $112,4
        LOGO_LINE $224,5
        LOGO_LINE $234,7
        LOGO_LINE $135,3
        LOGO_LINE $95d,1
        LOGO_LINE $223,1
        LOGO_LINE $135,5
        LOGO_LINE $112,3
        LOGO_LINE $135,3
        LOGO_LINE $158,5
        LOGO_LINE $67c,1
        LOGO_LINE $000,1
LogoLinesE:


        COP_WAIT CHUNKY_Y-2,$e2
        dc.w    bpl1mod,-DIW_BW
        dc.w    bpl2mod,-DIW_BW
        dc.w    bplcon0,$1200
        dc.w    bplcon1,1
        dc.w    color00,$000
        dc.w    color01,$000

CopChunkyPatBpl:
        dc.w    bplpt,0
        dc.w    bplpt+2,0

        ; sync start of cpu moves with interrupt
        COP_WAIT CHUNKY_Y-1,CPUX
        dc.w    intreq,INTF_SETCLR!INTF_COPER

        ; clear sprite cols, and use as padding
        dc.w    color19,0
        dc.w    color23,0
        dc.w    color27,0
        dc.w    color31,0
        dc.w    color17,0
        dc.w    color18,0
        dc.w    color21,0
        dc.w    color22,0
        dc.w    color25,0
        dc.w    color26,0
        dc.w    color29,0
        dc.w    color30,0

        ; trigger the sprites
        dc.w    spr1data,$0f00
        dc.w    spr3data,$0f00
        dc.w    spr5data,$0f00
        dc.w    spr7data,$0f00
        dc.w    spr0data,$0f00
        dc.w    spr2data,$0f00
        dc.w    spr4data,$0f00
        dc.w    spr6data,$0f00

;-------------------------------------------------------------------------------
; Loop for single chunky line
COP_LINE macro
        ; set loop start ptr
        dc.w    cop2lc+2,0

        dc.w    color19,0
        dc.w    color23,0
        dc.w    color27,0
        dc.w    color31,0
        dc.w    color17,0
        dc.w    color18,0
        dc.w    color21,0
        dc.w    color22,0
        dc.w    color25,0
        dc.w    color26,0
        dc.w    color29,0
        dc.w    color30,0

        COP_WAITH \1,COPX ; start of pixel row

        ; color00 values
        rept    DIW_W/8+1
        dc.w    color00,0
        endr
        dc.w    color00,0 ; restore bg col

        COP_SKIP \1+3,$fe ; loop
        dc.w    copjmp2,0
        endm
;-------------------------------------------------------------------------------

CopLines:
        COP_LINE CHUNKY_Y
CopLineE:
        rept    CHUNKY_H-1
        COP_LINE CHUNKY_Y+(REPTN+1)*4
        endr

        ; stop the sprites
        dc.w    spr0ctl,$000f
        dc.w    spr1ctl,$000f
        dc.w    spr2ctl,$000f
        dc.w    spr3ctl,$000f
        dc.w    spr4ctl,$000f
        dc.w    spr5ctl,$000f
        dc.w    spr6ctl,$000f
        dc.w    spr7ctl,$000f

CopScroller:

CopDma:
        dc.l    $00968000

        dc.w    color00,0
        dc.w    color01,$feb

        ; disable bitplanes
        dc.w    bplcon0,0

CopOffs set     DIW_YSTRT+SCROLL_Y

        COP_BG  0,$5a5
        COP_BG  1,$244
        COP_WAIT $ff,$de ; PAL fix
        COP_BG  7,$658
        COP_BG  8,$326
        COP_BG  9,$224

        COP_WAIT DIW_YSTRT+SCROLL_Y+9,$10
        ; scroller screen setup
        dc.w    diwstrt,DIW_YSTRT<<8!SCROLL_DIW_XSTRT
        dc.w    diwstop,(DIW_YSTOP&$ff)<<8!(SCROLL_DIW_XSTOP&$ff)
        dc.w    ddfstrt,(SCROLL_DIW_XSTRT-17)>>1&$fc-8 ; start fetching extra word for scroll
        dc.w    ddfstop,(SCROLL_DIW_XSTRT-17+(SCROLL_DIW_W>>4-1)<<4)>>1&$fc
        dc.w    bpl1mod,SCROLL_BW-SCROLL_DIW_BW-2
        dc.w    bpl2mod,SCROLL_BW-SCROLL_DIW_BW-2
CopBplScroller:
        dc.w    bplpt,0
        dc.w    bplpt+2,0
        dc.w    bplcon1
CopScroll:
        dc.w    0
        COP_WAIT DIW_YSTRT+SCROLL_Y+10,$10
        dc.w    bplcon0,$1100

        COP_COL1 11,$bd3
        COP_COL1 12,$efe
        COP_COL1 14,$df8

        COP_BG  15,$315
        dc.w    color01,$bd3
        COP_COL1 16,$dc4
        COP_COL1 17,$fff
        COP_COL1 18,$fc9
        COP_COL1 19,$cec
        COP_BG  21,$000
        dc.w    color01,$4ba
        COP_COL1 22,$8b0
        COP_BG  23,$113
        dc.w    color01,$4ba
        COP_COL1 24,$8de
        COP_BG  25,$112
        dc.w    color01,$b60
        COP_BG  28,$365
        COP_BG  29,$112
        COP_BG  30,$234
        COP_BG  35,$224
        COP_BG  41,$112

        dc.l    -2
CopE:

        include "assets/stuck-in-the-middle_insane.asm"


*******************************************************************************
        data
*******************************************************************************

        include "data/logo-skips.i"

; Source texture
Tex:
        incbin  "data/tex.bin"
        incbin  "data/tex.bin" ; repeated for scrolling

LSMusic:
        incbin  "assets/stuck-in-the-middle.lsmusic"
        even

*******************************************************************************
        data_c
*******************************************************************************

Pattern:
        dcb.b   DIW_BW,$f0

Font:
        incbin  "data/font-reg.BPL"
FontBold:
        incbin  "data/font-bold.BPL"

Logo:
        ds.b    LOGO_BW*LOGO_BPLS
        incbin  "data/logo.BPL"
        ds.b    LOGO_BW*LOGO_BPLS

LSBank:
        incbin  "assets/stuck-in-the-middle.lsbank"


*******************************************************************************
        bss_c
*******************************************************************************

; Copperlist in BSS RAM for 64k boundary alignment
CopBss:
        ds.b    COP_SIZE*2 ; Reserve 2x copperlist size for boundary alignment

ScrollBuffer:
        ds.b    SCROLL_BUFFER_SIZE


*******************************************************************************
        code_c
*******************************************************************************

********************************************************************************
CopInterrupt:
        ; align first instruction to eliminate jitter
        btst.b  #1,vhposr+custom+1
        beq     .a
        nop
        nop
.a:     nop

        move.w  #INTF_COPER,intreq+custom ; ack interrupt
        move.l  sp,SpTmp ; backup stack pointer
        lea     color01+custom,a7

        rept    CHUNKY_H
ROW     set     REPTN
        rept    4
        nop
        nop
        mulu    #$ff00,d0 ; padding that won't collide with audio dma
        nop
        nop
        lea     CpuCols+ROW*48,a6
        movem.w (a6)+,d0-a5

        move.w  (a6)+,(a7) ; 1
        move.w  (a6)+,(a7) ; 3
        move.w  d0,(a7) ; 5
        move.w  d1,(a7) ; 7
        ; spr             9
        move.w  d2,(a7) ; 11
        move.w  d3,(a7) ; 13
        move.w  d4,(a7) ; 15
        ; spr             17
        move.w  d5,(a7) ; 19
        move.w  d6,(a7) ; 21
        move.w  d7,(a7) ; 23
        ; spr             25
        move.w  a0,(a7) ; 27
        move.w  a1,(a7) ; 29
        move.w  a2,(a7) ; 31
        move.w  a3,(a7) ; 33
        ; spr             35
        move.w  a4,(a7) ; 37
        move.w  a5,(a7) ; 39
        ; spr x2        ; 41,43
        move.w  (a6)+,(a7) ; 45
        move.w  (a6)+,(a7) ; 47
        ; spr x2          49,51
        move.w  (a6)+,(a7) ; 53
        move.w  (a6)+,(a7) ; 55
        ; spr x2          57,59
        move.w  (a6)+,(a7) ; 61
        move.w  (a6)+,(a7) ; 63
        ; spr x2          65,67
        move.w  (a6)+,(a7) ; 69
        move.w  (a6)+,(a7) ; 71

        endr
        endr

        move.l  SpTmp,a7 ; restore stack pointer

        jsr     Update

        lea     $dff0a0,a6
        jsr     LSP_MusicPlayTickInsane

        rte

SpTmp:  dc.l    0

; Color table to be written by CPU
CpuCols:
        ds.w    CHUNKY_H*24


*******************************************************************************
        include "rampels.i" // 4/4  PELLICUS: Rampels for background bars
*******************************************************************************

*******************************************************************************
        include "ham.asm"
*******************************************************************************