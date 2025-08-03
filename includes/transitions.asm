MAX_TRANSITIONS = 2

; Transition types:
TRANSITION_LINEAR = 0
TRANSITION_EASE_IN_SIN = 2
TRANSITION_EASE_OUT_SIN = 4
TRANSITION_EASE_IN_OUT_SIN = 6
TRANSITION_EASE_IN_QUAD = 8
TRANSITION_EASE_OUT_QUAD = 10
TRANSITION_EASE_IN_OUT_QUAD = 12
TRANSITION_EASE_IN_QUART = 14
TRANSITION_EASE_OUT_QUART = 16
TRANSITION_EASE_IN_OUT_QUART = 18

; Enable transition types
SIN_EN = 1
QUAD_EN = 0
QUART_EN = 0

        rsreset
Tr_Lifetime rs.w 1      ; Frames remaining of transition
Tr_Type rs.w    1       ; Transtion type
Tr_DurationPow rs.w 1   ; Transition duration as pow of 2
Tr_TargretPtr rs.l 1    ; Variable to update
Tr_Start rs.w   1       ; Start value
Tr_Delta rs.l   1       ; Total delta
Tr_LerpCurrent rs.l 1   ; Fixed point running total
Tr_SIZEOF rs.w  0


********************************************************************************
; Start a new transition (signed)
;-------------------------------------------------------------------------------
; a0 - ptr
; d0.w - target value
; d1.w - duration (pow 2)
; d2.w - type
;-------------------------------------------------------------------------------
TransitionWord:
        lea     TransitionsState,a1
        moveq   #MAX_TRANSITIONS-1,d3
.l:     tst.w   (a1)    ; Slot is free if lifetime=0
        beq     .free
        adda.w  #Tr_SIZEOF,a1
        dbf     d3,.l
        rts             ; no free slots
.free:
        moveq   #1,d3   ; lifetime = 1<<duration
        lsl.w   d1,d3
        move.w  d3,(a1)+
        move.w  d2,(a1)+ ; type
        move.w  d1,(a1)+ ; duration
        move.w  (a0),d4 ; get start value from variable
        move.w  d4,(a1)+
        move.l  a0,(a1)+ ; variable target ptr
        sub.w   d4,d0   ; delta = target-start
        ext.l   d0
        move.l  d0,(a1)+
                ; lerp specific
        ext.l   d4      ; fp current = start<<duration
        lsl.l   d1,d4
        move.l  d4,(a1)+
        rts


********************************************************************************
; Start a new transition (unsigned)
;-------------------------------------------------------------------------------
; a0 - ptr
; d0.w - target value
; d1.w - duration (pow 2)
; d2.w - type
;-------------------------------------------------------------------------------
TransitionWordU:
        lea     TransitionsState,a1
        moveq   #MAX_TRANSITIONS-1,d3
.l:     tst.w   (a1)    ; Slot is free if lifetime=0
        beq     .free
        adda.w  #Tr_SIZEOF,a1
        dbf     d3,.l
        rts             ; no free slots
.free:
        moveq   #1,d3   ; lifetime = 1<<duration
        lsl.w   d1,d3
        move.w  d3,(a1)+
        move.w  d2,(a1)+ ; type
        move.w  d1,(a1)+ ; duration
        moveq   #0,d4
        move.w  (a0),d4 ; get start value from variable
        move.w  d4,(a1)+
        move.l  a0,(a1)+ ; variable target ptr
        sub.w   d4,d0   ; delta = target-start
        ext.l   d0
        move.l  d0,(a1)+
                ; lerp specific
        lsl.l   d1,d4   ; fp current = start<<duration
        move.l  d4,(a1)+
        rts


********************************************************************************
; Continue any active transitions
;-------------------------------------------------------------------------------
TransitionsTick:
        lea     TransitionsState,a0
        moveq   #MAX_TRANSITIONS-1,d7
.l:     move.w  (a0),d0
        beq     .next   ; Skip if not enabled / finished
        move.l  a0,a2
        subq.w  #1,(a2)+ ; decrement lifetime
        move.w  (a2)+,d1 ; type
        move.w  (a2)+,d2 ; duration
        move.w  (a2)+,d3 ; start
        move.l  (a2)+,a1 ; ptr
        move.l  (a2)+,d4 ; delta
        jmp     .type(pc,d1.w)
.next:  adda.w  #Tr_SIZEOF,a0
        dbf     d7,.l
        rts

.type:           
        bra.s   .linear
        bra.s   .easeInSin
        bra.s   .easeOutSin
        bra.s   .easeInOutSin
        ifne    QUAD_EN
        bra.s   .easeInQuad
        bra.s   .easeOutQuad
        bra.s   .easeInOutQuad
        endc
        ifne    QUART_EN
        bra.s   .easeInQuart
        bra.s   .easeOutQuart
        bra.s   .easeInOutQuart
        endc

;-------------------------------------------------------------------------------
; d0.w = lifetime
; d2.w = duration pow
; d3.w = start
; d4.l delta
; a1 = ptr
; a2 = *lerpValue
; DON'T TOUCH a0,d7
;-------------------------------------------------------------------------------

.linear:
        add.l   (a2),d4 ; current + delta
        move.l  d4,(a2) ; update current
        asr.l   d2,d4   ; shift to convert fp
        move.w  d4,(a1) ; update variable
        bra     .next

        ifne    SIN_EN
; Sin
.easeInSin:
        lea     Sin,a2
        bra     .easeIn
.easeOutSin:
        lea     Sin,a2
        bra     .easeOut
.easeInOutSin:
        lea     Sin,a2
        bra     .easeInOut
        endc

        ifne    QUAD_EN
; Quad
.easeInQuad:
        lea     Quadratic,a2
        bra     .easeIn
.easeOutQuad:
        lea     Quadratic,a2
        bra     .easeOut
.easeInOutQuad:
        lea     Quadratic,a2
        bra     .easeInOut
        endc
        ifne    QUART_EN
; Quart
.easeInQuart:
        lea     Quartic,a2
        bra     .easeIn
.easeOutQuart:
        lea     Quartic,a2
        bra     .easeOut
.easeInOutQuart:
        lea     Quartic,a2
        bra     .easeInOut
        endc

; Common easing types
.easeIn:
        ; second quarter of table: SIN_AMP to 0, need to invert
        adda.w  #SIN_LEN/2,a2
        ; offset = (512-(life<<(9-duration)))*2
        moveq   #8,d5   ; 9-duration: 1<<9 = 512, x2 for offset
        sub.w   d2,d5
        lsl.w   d5,d0
        neg.w   d0
        add.w   #SIN_LEN/2,d0
        move.w  (a2,d0.w),d0
        neg.w   d0
        add.w   #SIN_AMP,d0
        ; sin(i) * delta + start
        muls    d4,d0 
        FP2I14R d0
        add.w   d3,d0
        move.w  d0,(a1) ; update var
        bra     .next
.easeOut:
        ; use first quarter of table: 0 to SIN_AMP
        ; offset = (512-(life<<(9-duration)))*2
        moveq   #8,d5   ; 10-duration: 1<<9 = 512, x2 for offset
        sub.w   d2,d5
        lsl.w   d5,d0
        neg.w   d0
        add.w   #SIN_LEN/2,d0
        move.w  (a2,d0.w),d0
        ; sin(i) * delta + start
        muls    d4,d0 
        FP2I14R d0
        add.w   d3,d0
        move.w  d0,(a1) ; update var
        bra     .next
.easeInOut:
        ; second/third quarter of table: -SIN_AMP to SIN_AMP
        ; invert, double step size and half amplitude
        adda.w  #SIN_LEN/2,a2
        ; offset = (1024-(life<<(10-duration)))*2
        moveq   #10,d5  ; 10-duration: 1<<10 = 1024, x2 for offset
        sub.w   d2,d5
        lsl.w   d5,d0
        neg.w   d0
        add.w   #SIN_LEN,d0
        move.w  (a2,d0.w),d0
        asr.w   d0      ; half amp - unsigned value needs to fit in word
        neg.w   d0
        add.w   #SIN_AMP/2,d0
        ; sin(i) * delta + start
        muls    d4,d0 
        FP2I14R d0
        add.w   d3,d0
        move.w  d0,(a1) ; update var
        bra     .next


TransitionsState: ds.b Tr_SIZEOF*MAX_TRANSITIONS
