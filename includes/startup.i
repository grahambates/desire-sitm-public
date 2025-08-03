********************************************************************************
; based on MiniWrapper by Photon

        incdir  "includes"
        include "macros.i"
        include "hw.i"

_LVOSupervisor = -30
_LVOLoadView = -222
eb_AttnFlags = 296
gb_ActiView = 34
gb_copinit = 38
gb_LOFlist = 50

********************************************************************************
        xdef    _start
_start:
        move.l  (execbase).w,a6
        sub.l   a4,a4   ; Default VBR for 68000 = 0
        btst    #0,eb_AttnFlags+1(a6) ; 68010+ CPU?
        beq.s   .no010
        lea     .GetVBR(pc),a5
        jsr     _LVOSupervisor(a6)
.no010:        

; Save view+coppers
        move.l  156(a6),a5 ; Graphics.library (ExecBase->IntVects[6].iv_Data)
        move.l  a5,a6
        move.l  gb_ActiView(a6),-(sp)
        sub.l   a1,a1   ; blank screen to trigger screen switch
        jsr     _LVOLoadView(a6) ; on Amigas with graphics cards
; Save int+dma
        lea     custom,a6
        bsr.s   WaitEOF
        move.l  intenar(a6),-(sp)
        move.w  dmaconr(a6),-(sp)
        move.l  $6c(a4),-(sp)
        bsr.s   AllOff

; Call demo
        movem.l a4-a6,-(sp)
        bsr.w   Entrypoint
        movem.l (sp)+,a4-a6

; Restore
        bsr.s   WaitEOF
        bsr.s   AllOff
        move.l  (sp)+,$6c(a4)
        move.l  gb_copinit(a5),cop1lch(a6)
        move.l  gb_LOFlist(a5),cop2lch(a6)
        addq.w  #1,d2   ; $7fff->$8000 = master enable bit
        or.w    d2,(sp)
        move.w  (sp)+,dmacon(a6)
        or.w    d2,(sp)
        move.w  (sp)+,intena(a6)
        or.w    (sp)+,d2
        bsr.s   IntReqD2 ; restore interrupt requests

        move.l  a5,a6
        move.l  (sp)+,a1
        jsr     _LVOLoadView(a6) ; restore OS screen

        moveq   #0,d0   ; clear error return code to OS
        rts             ; back to AmigaDOS/Workbench.

********************************************************************************
; Fetch vector base address to a4
.GetVBR:        
        dc.w    $4e7a,$c801 ; hex for "movec VBR,a4"
        rte             ; return from Supervisor mode

********************************************************************************
; Wait for end of frame
WaitEOF:
        bsr.s   WaitBlitter
        move.w  #$138,d0
; Wait for scanline d0. Trashes d1.
WaitRaster:                             
.l:     move.l  4(a6),d1
        lsr.l   #1,d1
        lsr.w   #7,d1
        cmp.w   d0,d1
        bne.s   .l
        rts

********************************************************************************
AllOff:         
        move.w  #$7fff,d2       
        move.w  d2,dmacon(a6)
        move.w  d2,intena(a6)
IntReqD2:
        move.w  d2,intreq(a6)
        move.w  d2,intreq(a6) ; twice for A4000 compatibility
        rts

********************************************************************************
; wait until blitter is finished
WaitBlitter:                            
        tst.w   (a6)    ;for compatibility with A1000
.loop:  btst    #6,2(a6)
        bne.s   .loop
        rts