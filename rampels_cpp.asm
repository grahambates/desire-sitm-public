; Converted from GAS input file to VASM_MOT format
	; file	"Rampels.cpp"
;  GNU C++17 (GCC) version 14.2.0 (m68k-amiga-elf)
; 	compiled by GNU C version 10-posix 20220113, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

;  GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
;  options passed: -mcpu=68000 -Ofast -fno-tree-loop-distribution -fno-exceptions
	; text
	align	2
	xdef	memset
	; type	memset, @function
memset:
	movem.l #16160,-(sp)	; ,
	move.l 32(sp),d0	;  dest, dest
	move.l 36(sp),d3	;  val, val
	move.l 40(sp),a0	;  len, len
;  Rampels.cpp:30: 	while (len-- > 0)
	lea (-1,a0),a1	; , len, tmp.97
;  Rampels.cpp:30: 	while (len-- > 0)
	cmp.w #0,a0	; , len
	beq .L19		; 
;  Rampels.cpp:31: 		*ptr++ = val;
	move.b d3,d7	;  val, _4
	move.l d0,d2	;  dest, _1
	neg.l d2	;  _1
	moveq #3,d1	; , prolog_loop_niters.92
	and.l d2,d1	;  _1, prolog_loop_niters.92
	moveq #5,d4	; ,
	cmp.l a1,d4	;  tmp.97,
	bcc .L12		; 
	tst.l d1	;  prolog_loop_niters.92
	beq .L13		; 
	move.l d0,a1	;  dest,
	move.b d3,(a1)	;  val, MEM[(unsigned char *)dest_5(D)]
	btst #1,d2	; , _1
	beq .L33		; 
	move.b d3,1(a1)	;  val, MEM[(unsigned char *)dest_5(D) + 1B]
	moveq #3,d2	; ,
	cmp.l d1,d2	;  prolog_loop_niters.92,
	bne .L34		; 
;  Rampels.cpp:31: 		*ptr++ = val;
	lea (3,a1),a2	; , ptr, ptr
;  Rampels.cpp:31: 		*ptr++ = val;
	move.b d3,2(a1)	;  val, MEM[(unsigned char *)dest_5(D) + 2B]
;  Rampels.cpp:30: 	while (len-- > 0)
	lea (-4,a0),a1	; , len, tmp.97
	move.l a0,d5	;  len, niters.93
	sub.l d1,d5	;  prolog_loop_niters.92, niters.93
	moveq #0,d4	;  _4
	move.b d3,d4	;  val, _4
	move.l d4,d6	;  _4, tmp59
	swap d6	;  tmp59
	clr.w d6	;  tmp59
	move.l d3,d2	;  val, tmp60
	lsl.w #8,d2	; , tmp60
	swap d2	;  tmp60
	clr.w d2	;  tmp60
	lsl.l #8,d4	; , tmp63
	or.l d6,d2	;  tmp59, tmp64
	or.l d4,d2	;  tmp63, _4
	move.b d7,d2	;  _4, _4
	move.l d0,a0	;  dest, ivtmp.103
	add.l d1,a0	;  prolog_loop_niters.92, ivtmp.103
	moveq #-4,d4	; , _16
	and.l d5,d4	;  niters.93, _16
	move.l d4,d1	;  _16, _80
	add.l a0,d1	;  ivtmp.103, _80
.L8:
;  Rampels.cpp:31: 		*ptr++ = val;
	move.l d2,(a0)+	;  _4, MEM <vector(4) unsigned char> [(unsigned char *)vectp_dest.98_49]
	cmp.l a0,d1	;  ivtmp.103, _80
	bne .L8		; 
	cmp.l d4,d5	;  _16, niters.93
	beq .L19		; 
	sub.l d4,a1	;  _16, tmp.97
	lea (a2,d4.l),a0	;  ptr, _16, tmp.96
.L3:
	move.b d3,(a0)	;  val, *ptr_40
;  Rampels.cpp:30: 	while (len-- > 0)
	cmp.w #0,a1	; , tmp.97
	beq .L19		; 
;  Rampels.cpp:31: 		*ptr++ = val;
	move.b d3,1(a0)	;  val, MEM[(unsigned char *)ptr_40 + 1B]
;  Rampels.cpp:30: 	while (len-- > 0)
	moveq #1,d1	; ,
	cmp.l a1,d1	;  tmp.97,
	beq .L19		; 
;  Rampels.cpp:31: 		*ptr++ = val;
	move.b d3,2(a0)	;  val, MEM[(unsigned char *)ptr_40 + 2B]
;  Rampels.cpp:30: 	while (len-- > 0)
	moveq #2,d2	; ,
	cmp.l a1,d2	;  tmp.97,
	beq .L19		; 
;  Rampels.cpp:31: 		*ptr++ = val;
	move.b d3,3(a0)	;  val, MEM[(unsigned char *)ptr_40 + 3B]
;  Rampels.cpp:30: 	while (len-- > 0)
	moveq #3,d4	; ,
	cmp.l a1,d4	;  tmp.97,
	beq .L19		; 
;  Rampels.cpp:31: 		*ptr++ = val;
	move.b d3,4(a0)	;  val, MEM[(unsigned char *)ptr_40 + 4B]
;  Rampels.cpp:30: 	while (len-- > 0)
	moveq #4,d1	; ,
	cmp.l a1,d1	;  tmp.97,
	beq .L19		; 
;  Rampels.cpp:31: 		*ptr++ = val;
	move.b d3,5(a0)	;  val, MEM[(unsigned char *)ptr_40 + 5B]
.L19:
;  Rampels.cpp:33: }
	movem.l (sp)+,#1276	; ,
	rts	
.L33:
;  Rampels.cpp:31: 		*ptr++ = val;
	lea (1,a1),a2	; , ptr, ptr
;  Rampels.cpp:30: 	while (len-- > 0)
	lea (-2,a0),a1	; , len, tmp.97
	move.l a0,d5	;  len, niters.93
	sub.l d1,d5	;  prolog_loop_niters.92, niters.93
	moveq #0,d4	;  _4
	move.b d3,d4	;  val, _4
	move.l d4,d6	;  _4, tmp59
	swap d6	;  tmp59
	clr.w d6	;  tmp59
	move.l d3,d2	;  val, tmp60
	lsl.w #8,d2	; , tmp60
	swap d2	;  tmp60
	clr.w d2	;  tmp60
	lsl.l #8,d4	; , tmp63
	or.l d6,d2	;  tmp59, tmp64
	or.l d4,d2	;  tmp63, _4
	move.b d7,d2	;  _4, _4
	move.l d0,a0	;  dest, ivtmp.103
	add.l d1,a0	;  prolog_loop_niters.92, ivtmp.103
	moveq #-4,d4	; , _16
	and.l d5,d4	;  niters.93, _16
	move.l d4,d1	;  _16, _80
	add.l a0,d1	;  ivtmp.103, _80
	bra .L8		; 
.L13:
;  Rampels.cpp:29: 	unsigned char *ptr = (unsigned char *)dest;
	move.l d0,a2	;  dest, ptr
	move.l a0,d5	;  len, niters.93
	sub.l d1,d5	;  prolog_loop_niters.92, niters.93
	moveq #0,d4	;  _4
	move.b d3,d4	;  val, _4
	move.l d4,d6	;  _4, tmp59
	swap d6	;  tmp59
	clr.w d6	;  tmp59
	move.l d3,d2	;  val, tmp60
	lsl.w #8,d2	; , tmp60
	swap d2	;  tmp60
	clr.w d2	;  tmp60
	lsl.l #8,d4	; , tmp63
	or.l d6,d2	;  tmp59, tmp64
	or.l d4,d2	;  tmp63, _4
	move.b d7,d2	;  _4, _4
	move.l d0,a0	;  dest, ivtmp.103
	add.l d1,a0	;  prolog_loop_niters.92, ivtmp.103
	moveq #-4,d4	; , _16
	and.l d5,d4	;  niters.93, _16
	move.l d4,d1	;  _16, _80
	add.l a0,d1	;  ivtmp.103, _80
	bra .L8		; 
.L34:
;  Rampels.cpp:31: 		*ptr++ = val;
	lea (2,a1),a2	; , ptr, ptr
;  Rampels.cpp:30: 	while (len-- > 0)
	lea (-3,a0),a1	; , len, tmp.97
	move.l a0,d5	;  len, niters.93
	sub.l d1,d5	;  prolog_loop_niters.92, niters.93
	moveq #0,d4	;  _4
	move.b d3,d4	;  val, _4
	move.l d4,d6	;  _4, tmp59
	swap d6	;  tmp59
	clr.w d6	;  tmp59
	move.l d3,d2	;  val, tmp60
	lsl.w #8,d2	; , tmp60
	swap d2	;  tmp60
	clr.w d2	;  tmp60
	lsl.l #8,d4	; , tmp63
	or.l d6,d2	;  tmp59, tmp64
	or.l d4,d2	;  tmp63, _4
	move.b d7,d2	;  _4, _4
	move.l d0,a0	;  dest, ivtmp.103
	add.l d1,a0	;  prolog_loop_niters.92, ivtmp.103
	moveq #-4,d4	; , _16
	and.l d5,d4	;  niters.93, _16
	move.l d4,d1	;  _16, _80
	add.l a0,d1	;  ivtmp.103, _80
	bra .L8		; 
.L12:
;  Rampels.cpp:29: 	unsigned char *ptr = (unsigned char *)dest;
	move.l d0,a0	;  dest, tmp.96
	bra .L3		; 
	; size	memset, .-memset
	align	2
	xdef	memcpy
	; type	memcpy, @function
memcpy:
	movem.l #14368,-(sp)	; ,
	move.l 20(sp),d0	;  dest, dest
	move.l 28(sp),d1	;  len, len
;  Rampels.cpp:39: 	while (len--)
	move.l d1,d2	;  len, len
	subq.l #1,d2	; , len
	tst.l d1	;  len
	beq .L36		; 
	moveq #6,d3	; ,
	cmp.l d2,d3	;  len,
	bcc .L63		; 
	move.l 24(sp),d3	;  src, orptrs1_14
	or.l d0,d3	;  dest, orptrs1_14
	moveq #3,d4	; ,
	and.l d4,d3	; , andmask_15
	move.l 24(sp),a0	;  src, src
	addq.l #1,a0	; , src
	bne .L37		; 
	move.l d0,a1	;  dest, _26
	sub.l a0,a1	;  src, _26
	moveq #2,d3	; ,
	cmp.l a1,d3	;  _26,
	bcc .L37		; 
	move.l 24(sp),a0	;  src, ivtmp.139
	move.l d0,a1	;  dest, ivtmp.142
	moveq #-4,d3	; , _23
	and.l d1,d3	;  len, _23
	lea (a0,d3.l),a2	;  ivtmp.139, _23, tmp.118
.L38:
;  Rampels.cpp:40: 		*d++ = *s++;
	move.l (a0)+,(a1)+	;  MEM <const vector(4) char> [(const char *)vectp_src.120_58], MEM <vector(4) char> [(char *)vectp_dest.123_61]
	cmp.l a2,a0	;  tmp.118, ivtmp.139
	bne .L38		; 
	sub.l d3,d2	;  _23, tmp.119
	move.l d0,a0	;  dest, tmp.117
	add.l d3,a0	;  _23, tmp.117
	cmp.l d1,d3	;  len, _23
	beq .L36		; 
	move.b (a2),(a0)	;  *tmp.118_56, *tmp.117_55
;  Rampels.cpp:39: 	while (len--)
	tst.l d2	;  tmp.119
	beq .L36		; 
;  Rampels.cpp:40: 		*d++ = *s++;
	move.b 1(a2),1(a0)	;  MEM[(const char *)tmp.118_56 + 1B], MEM[(char *)tmp.117_55 + 1B]
;  Rampels.cpp:39: 	while (len--)
	subq.l #1,d2	; , tmp.119
	beq .L36		; 
;  Rampels.cpp:40: 		*d++ = *s++;
	move.b 2(a2),2(a0)	;  MEM[(const char *)tmp.118_56 + 2B], MEM[(char *)tmp.117_55 + 2B]
.L36:
;  Rampels.cpp:42: }
	movem.l (sp)+,#1052	; ,
	rts	
.L63:
	move.l 24(sp),a0	;  src, src
	addq.l #1,a0	; , src
.L37:
	add.l d0,d1	;  dest, _72
;  Rampels.cpp:37: 	char *d = (char *)dest;
	move.l d0,a1	;  dest, d
.L40:
;  Rampels.cpp:40: 		*d++ = *s++;
	move.b -1(a0),(a1)+	;  MEM[(const char *)s_34 + 4294967295B], MEM[(char *)d_36 + 4294967295B]
;  Rampels.cpp:39: 	while (len--)
	cmp.l a1,d1	;  d, _72
	beq .L36		; 
	addq.l #1,a0	; , src
	bra .L40		; 
	; size	memcpy, .-memcpy
	align	2
	xdef	_Z15InterpolateRampPsS_
	; type	_Z15InterpolateRampPsS_, @function
_Z15InterpolateRampPsS_:
	move.l 4(sp),a0	;  POS, ivtmp.155
	move.l 8(sp),a1	;  INC, ivtmp.157
	move.l a0,d0	;  ivtmp.155, _19
	add.l #246,d0	; , _19
.L65:
;  Rampels.cpp:237:             POS[i] += INC[i];
	move.w (a0),d1	;  MEM[(short int *)_25],
	add.w (a1)+,d1	;  MEM[(short int *)_23],
	move.w d1,(a0)+	; , MEM[(short int *)_24 + 4294967294B]
;  Rampels.cpp:235:        for (int i = 0; i < COP_SCR_H*3; i++)
	cmp.l d0,a0	;  _19, ivtmp.155
	bne .L65		; 
;  Rampels.cpp:239:     }
	rts	
	; size	_Z15InterpolateRampPsS_, .-_Z15InterpolateRampPsS_
	align	2
	xdef	_Z16SetInterpolationPsS_S_S_
	; type	_Z16SetInterpolationPsS_S_S_, @function
_Z16SetInterpolationPsS_S_S_:
	movem.l #60,-(sp)	; ,
	move.l 20(sp),a4	;  POS, POS
	move.l 24(sp),a3	;  INC, INC
	move.l 28(sp),a2	;  A, A
	move.l 32(sp),a1	;  B, B
;  Rampels.cpp:244:     {
	moveq #0,d0	;  ivtmp.176
.L70:
;  Rampels.cpp:247:             POS[i] = A[i];
	move.w (a2,d0.l),a0	;  MEM[(short int *)A_17(D) + ivtmp.176_28 * 1], _5
;  Rampels.cpp:247:             POS[i] = A[i];
	move.w a0,(a4,d0.l)	;  _5, MEM[(short int *)POS_18(D) + ivtmp.176_28 * 1]
;  Rampels.cpp:248:             INC[i] = (B[i] - A[i]) >>BKG_IPOL_FRAMES_BITS;
	move.w (a1,d0.l),a5	;  MEM[(short int *)B_20(D) + ivtmp.176_28 * 1], _8
;  Rampels.cpp:248:             INC[i] = (B[i] - A[i]) >>BKG_IPOL_FRAMES_BITS;
	sub.w a0,a5	;  _5, _8
	move.l a5,d1	;  _8, _10
;  Rampels.cpp:248:             INC[i] = (B[i] - A[i]) >>BKG_IPOL_FRAMES_BITS;
	asr.l #5,d1	; , _11
;  Rampels.cpp:248:             INC[i] = (B[i] - A[i]) >>BKG_IPOL_FRAMES_BITS;
	move.w d1,(a3,d0.l)	;  _11, MEM[(short int *)INC_21(D) + ivtmp.176_28 * 1]
;  Rampels.cpp:245:         for (int i = 0; i < COP_SCR_H*3; i++)
	addq.l #2,d0	; , ivtmp.176
	cmp.l #246,d0	; , ivtmp.176
	bne .L70		; 
;  Rampels.cpp:250:     }
	movem.l (sp)+,#15360	; ,
	rts	
	; size	_Z16SetInterpolationPsS_S_S_, .-_Z16SetInterpolationPsS_S_S_
	align	2
	xdef	BkgBars_444ToFix
	; type	BkgBars_444ToFix, @function
BkgBars_444ToFix:
	move.l d2,-(sp)	; ,
	move.l 16(sp),d0	;  n_src, n_src
;  Rampels.cpp:258:     for(int i=0;i<n_src;i++)
	ble .L74		; 
	move.l 12(sp),a1	;  src, ivtmp.186
	move.l 8(sp),a0	;  dest, ivtmp.187
	add.l d0,d0	;  n_src, _54
	move.l a1,d2	;  ivtmp.186, _52
	add.l d0,d2	;  _54, _52
.L76:
;  Rampels.cpp:260:         short s= src[i];
	move.w (a1)+,d0	;  MEM[(short int *)_59], s
;  Rampels.cpp:261:         dest[di++] = ((s>>8)&0xf)<<BKG_FIX_P;
	move.w d0,d1	;  s,
	and.w #3840,d1	; ,
	move.w d1,(a0)	; , MEM[(short int *)_58]
;  Rampels.cpp:262:         dest[di++] = ((s>>4)&0xf)<<BKG_FIX_P;
	move.w d0,d1	;  s, _9
	lsl.w #4,d1	; , _9
	and.w #3840,d1	; , _9
	move.w d1,2(a0)	;  _9, MEM[(short int *)_58 + 2B]
;  Rampels.cpp:263:         dest[di++] = ((s>>0)&0xf)<<BKG_FIX_P;
	lsl.w #8,d0	; , _14
	and.w #3840,d0	; , _14
	move.w d0,4(a0)	;  _14, MEM[(short int *)_58 + 4B]
;  Rampels.cpp:258:     for(int i=0;i<n_src;i++)
	addq.l #6,a0	; , ivtmp.187
	cmp.l d2,a1	;  _52, ivtmp.186
	bne .L76		; 
.L74:
;  Rampels.cpp:265: }
	move.l (sp)+,d2	; ,
	rts	
	; size	BkgBars_444ToFix, .-BkgBars_444ToFix
	align	2
	xdef	BkgBars_FixTo444
	; type	BkgBars_FixTo444, @function
BkgBars_FixTo444:
	move.l a2,-(sp)	; ,
	move.l d2,-(sp)	; ,
	move.l 20(sp),d2	;  n_src, n_src
;  Rampels.cpp:271:     for(int i=0;i<n_src;i+=3)
	ble .L80		; 
	move.l 16(sp),a0	;  POS, ivtmp.196
	move.l 12(sp),a2	;  dest, ivtmp.198
;  Rampels.cpp:271:     for(int i=0;i<n_src;i+=3)
	sub.l a1,a1	;  i
.L82:
;  Rampels.cpp:273:         byte ir = (POS[i+0] >> BKG_FIX_P) & 15;
	move.b (a0),d0	;  MEM[(short int *)_95], ir_35
	and.b #15,d0	; , ir_35
;  Rampels.cpp:276:         dest[di] = ir << 8 | ig << 4 | ib;
	lsl.w #8,d0	; , _20
;  Rampels.cpp:274:         byte ig = (POS[i+1] >> BKG_FIX_P) & 15;
	move.b 2(a0),d1	;  MEM[(short int *)_95 + 2B], ig_36
	and.b #15,d1	; , ig_36
;  Rampels.cpp:276:         dest[di] = ir << 8 | ig << 4 | ib;
	and.w #255,d1	; , _21
	lsl.w #4,d1	; , _22
;  Rampels.cpp:276:         dest[di] = ir << 8 | ig << 4 | ib;
	or.w d1,d0	;  _22, _48
;  Rampels.cpp:275:         byte ib = (POS[i+2] >> BKG_FIX_P) & 15;
	move.b 4(a0),d1	;  MEM[(short int *)_95 + 4B], ib_37
	and.b #15,d1	; , ib_37
;  Rampels.cpp:276:         dest[di] = ir << 8 | ig << 4 | ib;
	and.w #255,d1	; , _24
	or.w d1,d0	;  _24, _48
	move.w d0,(a2)+	;  _48, MEM[(short int *)_92]
;  Rampels.cpp:271:     for(int i=0;i<n_src;i+=3)
	addq.l #3,a1	; , i
;  Rampels.cpp:271:     for(int i=0;i<n_src;i+=3)
	addq.l #6,a0	; , ivtmp.196
	cmp.l d2,a1	;  n_src, i
	blt .L82		; 
.L80:
;  Rampels.cpp:279: }
	move.l (sp)+,d2	; ,
	move.l (sp)+,a2	; ,
	rts	
	; size	BkgBars_FixTo444, .-BkgBars_FixTo444
	align	2
	xdef	BkgBars_Start
	; type	BkgBars_Start, @function
BkgBars_Start:
	lea (-16,sp),sp	; ,
	movem.l #16190,-(sp)	; ,
;  Rampels.cpp:291:     unsigned int limit= (n_src-48); // limit for a_index3 and b_index3
	moveq #-48,d4	; ,
	add.l 76(sp),d4	;  n_src,
	move.l d4,52(sp)	; , %sfp
;  Rampels.cpp:110:             c[i] = val;
	lea ADDER,a2	; , ivtmp.252
	pea 246.w		; 
	clr.l -(sp)	; 
	move.l a2,-(sp)	;  ivtmp.252,
	jsr memset		; 
;  Rampels.cpp:297:     for(unsigned int i=0;i<frames;i+=BKG_IPOL_FRAMES)
	lea (12,sp),sp	; ,
	tst.l 80(sp)	;  frames
	beq .L86		; 
	move.l 64(sp),d4	;  size_h,
	lsl.l #5,d4	; ,
	move.l d4,56(sp)	; , %sfp
	clr.l 48(sp)	;  %sfp
;  Rampels.cpp:294:     int sin_inx=0;
	moveq #0,d7	;  sin_inx
;  Rampels.cpp:290:     unsigned int a_index= 32,b_index = 0;
	clr.l 44(sp)	;  %sfp
;  Rampels.cpp:290:     unsigned int a_index= 32,b_index = 0;
	moveq #32,d0	; , a_index
	move.l #BUF_B+246,d6	; , _101
	move.l #BUF_A,d1	; , ivtmp.241
	move.l #BUF_A+246,d3	; , _761
	move.l #BASE+246,d2	; , _93
	lea BASE,a6	; , ivtmp.311
	move.l #BASE_INC,d5	; , ivtmp.290
	add.l d0,d0	;  a_index, _105
	move.l 72(sp),a1	;  src, ivtmp.310
	add.l d0,a1	;  _105, ivtmp.310
;  Rampels.cpp:287: {
	lea BASE,a0	; , ivtmp.311
.L89:
;  Rampels.cpp:188:             short s= src[i];
	move.w (a1)+,d0	;  MEM[(short int *)_52], s
;  Rampels.cpp:189:             dest[di++] = ((s>>8)&0xf)<<BKG_FIX_P;
	move.w d0,d4	;  s,
	and.w #3840,d4	; ,
	move.w d4,(a0)	; , MEM[(short int *)_850]
;  Rampels.cpp:190:             dest[di++] = ((s>>4)&0xf)<<BKG_FIX_P;
	move.w d0,d4	;  s, _164
	lsl.w #4,d4	; , _164
	and.w #3840,d4	; , _164
	move.w d4,2(a0)	;  _164, MEM[(short int *)_850 + 2B]
;  Rampels.cpp:191:             dest[di++] = ((s>>0)&0xf)<<BKG_FIX_P;
	lsl.w #8,d0	; , _170
	and.w #3840,d0	; , _170
	move.w d0,4(a0)	;  _170, MEM[(short int *)_850 + 4B]
;  Rampels.cpp:186:         for(int i=0;i<COP_SCR_H;i++)
	addq.l #6,a0	; , ivtmp.311
	cmp.l d2,a0	;  _93, ivtmp.311
	bne .L89		; 
	move.l 44(sp),a3	;  %sfp, _848
	add.l a3,a3	; , _848
	add.l 72(sp),a3	;  src, ivtmp.300
	lea BUF_B,a0	; , ivtmp.286
	move.l a0,a1	;  ivtmp.286, ivtmp.301
.L90:
;  Rampels.cpp:188:             short s= src[i];
	move.w (a3)+,d0	;  MEM[(short int *)_15], s
;  Rampels.cpp:189:             dest[di++] = ((s>>8)&0xf)<<BKG_FIX_P;
	move.w d0,d4	;  s,
	and.w #3840,d4	; ,
	move.w d4,(a1)	; , MEM[(short int *)_821]
;  Rampels.cpp:190:             dest[di++] = ((s>>4)&0xf)<<BKG_FIX_P;
	move.w d0,d4	;  s, _138
	lsl.w #4,d4	; , _138
	and.w #3840,d4	; , _138
	move.w d4,2(a1)	;  _138, MEM[(short int *)_821 + 2B]
;  Rampels.cpp:191:             dest[di++] = ((s>>0)&0xf)<<BKG_FIX_P;
	lsl.w #8,d0	; , _144
	and.w #3840,d0	; , _144
	move.w d0,4(a1)	;  _144, MEM[(short int *)_821 + 4B]
;  Rampels.cpp:186:         for(int i=0;i<COP_SCR_H;i++)
	addq.l #6,a1	; , ivtmp.301
	cmp.l d6,a1	;  _101, ivtmp.301
	bne .L90		; 
	lea BASE_INC,a3	; , ivtmp.290
	lea BASE,a1	; , ivtmp.288
.L91:
;  Rampels.cpp:217:             inc[i] = (b[i] - a[i]) >>BKG_IPOL_FRAMES_BITS;
	move.w (a0)+,a4	;  MEM[(short int *)_185], _64
;  Rampels.cpp:217:             inc[i] = (b[i] - a[i]) >>BKG_IPOL_FRAMES_BITS;
	sub.w (a1)+,a4	;  MEM[(short int *)_184], _64
	move.l a4,d0	;  _64, _68
;  Rampels.cpp:217:             inc[i] = (b[i] - a[i]) >>BKG_IPOL_FRAMES_BITS;
	asr.l #5,d0	; , _69
;  Rampels.cpp:217:             inc[i] = (b[i] - a[i]) >>BKG_IPOL_FRAMES_BITS;
	move.w d0,(a3)+	;  _69, MEM[(short int *)_183]
;  Rampels.cpp:214:         for (int i = 0; i < COP_SCR_H*3; i++)
	cmp.l d6,a0	;  _101, ivtmp.286
	bne .L91		; 
	move.l 48(sp),a4	;  %sfp, di
	move.w #32,a3	; , _424
	add.l d7,a3	;  sin_inx, _424
.L92:
;  Rampels.cpp:186:         for(int i=0;i<COP_SCR_H;i++)
	move.l d5,a1	;  ivtmp.290, ivtmp.268
	move.l a6,a0	;  ivtmp.311, ivtmp.266
.L93:
;  Rampels.cpp:147:             c[i] += inc[i];
	move.w (a0),d0	;  MEM[(short int *)_757],
	add.w (a1)+,d0	;  MEM[(short int *)_263],
	move.w d0,(a0)+	; , MEM[(short int *)_751 + 4294967294B]
;  Rampels.cpp:145:         for (int i = 0; i < COP_SCR_H*3; i++)
	cmp.l d2,a0	;  _93, ivtmp.266
	bne .L93		; 
;  Rampels.cpp:126:                 dst[i] = src[i];
	pea 246.w		; 
	move.l a6,-(sp)	;  ivtmp.311,
	move.l d1,-(sp)	;  ivtmp.241,
	jsr memcpy		; 
;  Rampels.cpp:311:                 y=(int)bkg_sin_table[(sin_inx)&255];
	moveq #0,d0	; , _40
	not.b d0	;  _40
	and.l d7,d0	;  sin_inx, _40
;  Rampels.cpp:311:                 y=(int)bkg_sin_table[(sin_inx)&255];
	lea bkg_sin_table,a0	; ,
	move.b (a0,d0.l),d0	;  bkg_sin_table[_40],
	ext.w d0	;  bkg_sin_table[_40]
	move.w d0,a0	;  bkg_sin_table[_40], y_267
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	move.l a0,d0	;  y_267, tmp220
	bpl .L178		; 
	addq.l #1,d0	;  tmp220
.L178:
	asr.l #1,d0	; , tmp220
	move.l d0,a0	;  tmp220, _270
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (15,a0),a1	; , _270, _271
	lea (16,a0),a5	; , _270, _863
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	lea (12,sp),sp	; ,
	moveq #40,d0	; ,
	cmp.l a1,d0	;  _271,
	bcs .L94		; 
;  Rampels.cpp:116:         C[y] = c;
	move.l a1,d0	;  _271, tmp224
	add.l a1,d0	;  _271, tmp224
	add.l d0,a1	;  tmp224, tmp225
	add.l a1,a1	;  tmp225, tmp226
	move.w #1280,(a1,a2.l)	; , ADDER.C[_271].R
	lea (a2,a1.l),a1	;  ivtmp.252, tmp226, tmp232
	move.w #1280,2(a1)	; , ADDER.C[_271].G
	move.w #1280,4(a1)	; , ADDER.C[_271].B
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #25,d4	; ,
	cmp.l a0,d4	;  _270,
	beq .L105		; 
;  Rampels.cpp:116:         C[y] = c;
	move.l a5,d0	;  _863, tmp286
	add.l a5,d0	;  _863, tmp286
	lea (a5,d0.l),a1	;  _863, tmp286, tmp287
	add.l a1,a1	;  tmp287, tmp288
	move.w #1792,(a1,a2.l)	; , ADDER.C[_863].R
	lea (a2,a1.l),a1	;  ivtmp.252, tmp288, tmp294
	move.w #1792,2(a1)	; , ADDER.C[_863].G
	move.w #1792,4(a1)	; , ADDER.C[_863].B
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (17,a0),a1	; , _270, _303
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #24,d4	; ,
	cmp.l a0,d4	;  _270,
	beq .L105		; 
;  Rampels.cpp:116:         C[y] = c;
	move.l a1,d0	;  _303, tmp312
	add.l a1,d0	;  _303, tmp312
	add.l d0,a1	;  tmp312, tmp313
	add.l a1,a1	;  tmp313, tmp314
	move.w #2304,(a1,a2.l)	; , ADDER.C[_303].R
	lea (a2,a1.l),a1	;  ivtmp.252, tmp314, tmp320
	move.w #2304,2(a1)	; , ADDER.C[_303].G
	move.w #2304,4(a1)	; , ADDER.C[_303].B
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (18,a0),a1	; , _270, _287
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #23,d4	; ,
	cmp.l a0,d4	;  _270,
	bne .L170		; 
.L105:
;  Rampels.cpp:314:             sin_inx++;
	addq.l #1,d7	; , sin_inx
	lea ADDER,a5	; , ivtmp.252
	move.l a5,a2	;  ivtmp.252, ivtmp.252
	move.l a5,a0	;  ivtmp.252, ivtmp.259
.L122:
;  Rampels.cpp:67:         R += k.R;
	move.w (a0),d4	;  MEM[(short int *)_256], _803
	add.w #-35,d4	; , _803
	move.w d4,(a0)	;  _803, MEM[(short int *)_256]
;  Rampels.cpp:68:         G += k.G;
	move.w 2(a0),d1	;  MEM[(short int *)_256 + 2B], _798
	add.w #-28,d1	; , _798
	move.w d1,2(a0)	;  _798, MEM[(short int *)_256 + 2B]
;  Rampels.cpp:69:         B += k.B;
	move.w 4(a0),d0	;  MEM[(short int *)_256 + 4B], _793
	add.w #-29,d0	; , _793
	move.w d0,4(a0)	;  _793, MEM[(short int *)_256 + 4B]
;  Rampels.cpp:58:         if (R > 0xf00) R = 0xf00;
	cmp.w #3840,d4	; , _803
	ble .L116		; 
;  Rampels.cpp:58:         if (R > 0xf00) R = 0xf00;
	move.w #3840,(a0)	; , MEM[(short int *)_256]
.L116:
;  Rampels.cpp:59:         if (G > 0xf00) G = 0xf00;
	cmp.w #3840,d1	; , _798
	ble .L117		; 
;  Rampels.cpp:59:         if (G > 0xf00) G = 0xf00;
	move.w #3840,2(a0)	; , MEM[(short int *)_256 + 2B]
.L117:
;  Rampels.cpp:60:         if (B > 0xf00) B = 0xf00;
	cmp.w #3840,d0	; , _793
	ble .L118		; 
;  Rampels.cpp:60:         if (B > 0xf00) B = 0xf00;
	move.w #3840,4(a0)	; , MEM[(short int *)_256 + 4B]
.L118:
;  Rampels.cpp:61:         if (R < 0) R = 0;
	tst.w (a0)	;  MEM[(short int *)_256]
	blt .L171		; 
;  Rampels.cpp:62:         if (G < 0) G = 0;
	tst.w 2(a0)	;  MEM[(short int *)_256 + 2B]
	blt .L172		; 
.L120:
;  Rampels.cpp:63:         if (B < 0) B = 0;
	tst.w 4(a0)	;  MEM[(short int *)_256 + 4B]
	blt .L173		; 
.L121:
;  Rampels.cpp:134:         for (int i = 0; i < COP_SCR_H; i++)
	addq.l #6,a0	; , ivtmp.259
	cmp.l #ADDER+246,a0	; , ivtmp.259
	bne .L122		; 
.L174:
	lea BUF_A,a1	; , ivtmp.241
	move.l a1,d1	;  ivtmp.241, ivtmp.241
	move.l a1,a0	;  ivtmp.241, ivtmp.250
.L126:
;  Rampels.cpp:166:             c[i] += inc[i];
	move.w (a0)+,d0	;  MEM[(short int *)_246], _830
	add.w (a5)+,d0	;  MEM[(short int *)_759], _830
;  Rampels.cpp:167:             if(c[i] > 0xf00) c[i] = 0xf00; // saturate
	cmp.w #3840,d0	; , _830
	ble .L123		; 
;  Rampels.cpp:167:             if(c[i] > 0xf00) c[i] = 0xf00; // saturate
	move.w #3840,-2(a0)	; , MEM[(short int *)_247 + 4294967294B]
;  Rampels.cpp:164:         for (int i = 0; i < COP_SCR_H*3; i++)
	cmp.l d3,a0	;  _761, ivtmp.250
	bne .L126		; 
.L176:
	lea (a4,a4.l),a0	;  di, di, _754
	add.l 68(sp),a0	;  dest, ivtmp.243
.L127:
;  Rampels.cpp:201:             byte ir = (POS[i+0] >> BKG_FIX_P) & 15;
	move.b (a1),d0	;  MEM[(short int *)_39], ir_212
	and.b #15,d0	; , ir_212
;  Rampels.cpp:204:             dest[di] = ir << 8 | ig << 4 | ib;
	lsl.w #8,d0	; , _228
;  Rampels.cpp:202:             byte ig = (POS[i+1] >> BKG_FIX_P) & 15;
	move.b 2(a1),d4	;  MEM[(short int *)_39 + 2B], ig_219
	and.b #15,d4	; , ig_219
;  Rampels.cpp:204:             dest[di] = ir << 8 | ig << 4 | ib;
	and.w #255,d4	; , _229
	lsl.w #4,d4	; , _230
;  Rampels.cpp:204:             dest[di] = ir << 8 | ig << 4 | ib;
	or.w d4,d0	;  _230, _857
;  Rampels.cpp:203:             byte ib = (POS[i+2] >> BKG_FIX_P) & 15;
	move.b 4(a1),d4	;  MEM[(short int *)_39 + 4B], ib_226
	and.b #15,d4	; , ib_226
;  Rampels.cpp:204:             dest[di] = ir << 8 | ig << 4 | ib;
	and.w #255,d4	; , _232
	or.w d4,d0	;  _232, _857
	move.w d0,(a0)+	;  _857, MEM[(short int *)_78]
;  Rampels.cpp:199:         for(int i=0;i<COP_SCR_H*3;i+=3)
	addq.l #6,a1	; , ivtmp.241
	cmp.l #BUF_A+246,a1	; , ivtmp.241
	bne .L127		; 
;  Rampels.cpp:319:             di += size_h;
	add.l 64(sp),a4	;  size_h, di
;  Rampels.cpp:304:         for(int f=0;f<BKG_IPOL_FRAMES;f++)
	cmp.l d7,a3	;  sin_inx, _424
	bne .L92		; 
	move.l a3,d7	;  _424, sin_inx
;  Rampels.cpp:323:         b_index+=18;
	move.w #18,a0	; , b_index
	add.l 44(sp),a0	;  %sfp, b_index
;  Rampels.cpp:324:         if(b_index>=limit) b_index-=limit; // wrap around
	cmp.l 52(sp),a0	;  %sfp, b_index
	bcs .L129		; 
;  Rampels.cpp:324:         if(b_index>=limit) b_index-=limit; // wrap around
	sub.l 52(sp),a0	;  %sfp, b_index
.L129:
;  Rampels.cpp:297:     for(unsigned int i=0;i<frames;i+=BKG_IPOL_FRAMES)
	move.l 56(sp),d4	;  %sfp,
	add.l d4,48(sp)	; , %sfp
	move.l 44(sp),d0	;  %sfp, a_index
	cmp.l 80(sp),a3	;  frames, _424
	bcc .L86		; 
	move.l a0,44(sp)	;  b_index, %sfp
	add.l d0,d0	;  a_index, _105
	move.l 72(sp),a1	;  src, ivtmp.310
	add.l d0,a1	;  _105, ivtmp.310
;  Rampels.cpp:287: {
	lea BASE,a0	; , ivtmp.311
	bra .L89		; 
.L173:
;  Rampels.cpp:63:         if (B < 0) B = 0;
	clr.w 4(a0)	;  MEM[(short int *)_256 + 4B]
;  Rampels.cpp:134:         for (int i = 0; i < COP_SCR_H; i++)
	addq.l #6,a0	; , ivtmp.259
	cmp.l #ADDER+246,a0	; , ivtmp.259
	bne .L122		; 
	bra .L174		; 
.L172:
;  Rampels.cpp:62:         if (G < 0) G = 0;
	clr.w 2(a0)	;  MEM[(short int *)_256 + 2B]
;  Rampels.cpp:63:         if (B < 0) B = 0;
	tst.w 4(a0)	;  MEM[(short int *)_256 + 4B]
	bge .L121		; 
	bra .L173		; 
.L171:
;  Rampels.cpp:61:         if (R < 0) R = 0;
	clr.w (a0)	;  MEM[(short int *)_256]
;  Rampels.cpp:62:         if (G < 0) G = 0;
	tst.w 2(a0)	;  MEM[(short int *)_256 + 2B]
	bge .L120		; 
	bra .L172		; 
.L170:
;  Rampels.cpp:116:         C[y] = c;
	move.l a1,d0	;  _287, tmp338
	add.l a1,d0	;  _287, tmp338
	add.l d0,a1	;  tmp338, tmp339
	add.l a1,a1	;  tmp339, tmp340
	move.w #2816,(a1,a2.l)	; , ADDER.C[_287].R
	lea (a2,a1.l),a1	;  ivtmp.252, tmp340, tmp346
	move.w #2816,2(a1)	; , ADDER.C[_287].G
	move.w #2816,4(a1)	; , ADDER.C[_287].B
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (19,a0),a1	; , _270, _277
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #22,d4	; ,
	cmp.l a0,d4	;  _270,
	beq .L105		; 
;  Rampels.cpp:116:         C[y] = c;
	move.l a1,d0	;  _277, tmp364
	add.l a1,d0	;  _277, tmp364
	add.l d0,a1	;  tmp364, tmp365
	add.l a1,a1	;  tmp365, tmp366
	move.w #3328,(a1,a2.l)	; , ADDER.C[_277].R
	lea (a2,a1.l),a1	;  ivtmp.252, tmp366, tmp372
	move.w #3328,2(a1)	; , ADDER.C[_277].G
	move.w #3328,4(a1)	; , ADDER.C[_277].B
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (20,a0),a1	; , _270, _12
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #21,d4	; ,
	cmp.l a0,d4	;  _270,
	beq .L105		; 
;  Rampels.cpp:116:         C[y] = c;
	move.l a1,d0	;  _12, tmp390
	add.l a1,d0	;  _12, tmp390
	add.l d0,a1	;  tmp390, tmp391
	add.l a1,a1	;  tmp391, tmp392
	move.w #3840,(a1,a2.l)	; , ADDER.C[_12].R
	lea (a2,a1.l),a1	;  ivtmp.252, tmp392, tmp398
	move.w #3840,2(a1)	; , ADDER.C[_12].G
	move.w #3840,4(a1)	; , ADDER.C[_12].B
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (21,a0),a1	; , _270, _6
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #20,d4	; ,
	cmp.l a0,d4	;  _270,
	beq .L105		; 
;  Rampels.cpp:116:         C[y] = c;
	move.l a1,d0	;  _6, tmp416
	add.l a1,d0	;  _6, tmp416
	add.l d0,a1	;  tmp416, tmp417
	add.l a1,a1	;  tmp417, tmp418
	move.w #3328,(a1,a2.l)	; , ADDER.C[_345].R
	lea (a2,a1.l),a1	;  ivtmp.252, tmp418, tmp424
	move.w #3328,2(a1)	; , ADDER.C[_345].G
	move.w #3328,4(a1)	; , ADDER.C[_345].B
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (22,a0),a1	; , _270, _281
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #19,d4	; ,
	cmp.l a0,d4	;  _270,
	beq .L105		; 
.L103:
;  Rampels.cpp:116:         C[y] = c;
	move.l a1,d0	;  _281, tmp441
	add.l a1,d0	;  _281, tmp441
	add.l d0,a1	;  tmp441, tmp442
	add.l a1,a1	;  tmp442, tmp443
	move.w #2816,(a1,a2.l)	; , ADDER.C[_347].R
	lea (a2,a1.l),a1	;  ivtmp.252, tmp443, tmp449
	move.w #2816,2(a1)	; , ADDER.C[_347].G
	move.w #2816,4(a1)	; , ADDER.C[_347].B
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (23,a0),a1	; , _270, _3
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #18,d4	; ,
	cmp.l a0,d4	;  _270,
	beq .L105		; 
.L107:
;  Rampels.cpp:116:         C[y] = c;
	move.l a1,d0	;  _3, tmp464
	add.l a1,d0	;  _3, tmp464
	add.l d0,a1	;  tmp464, tmp465
	add.l a1,a1	;  tmp465, tmp466
	move.w #2304,(a1,a2.l)	; , ADDER.C[_349].R
	lea (a2,a1.l),a1	;  ivtmp.252, tmp466, tmp472
	move.w #2304,2(a1)	; , ADDER.C[_349].G
	move.w #2304,4(a1)	; , ADDER.C[_349].B
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (24,a0),a1	; , _270, _199
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #17,d4	; ,
	cmp.l a0,d4	;  _270,
	beq .L105		; 
.L110:
;  Rampels.cpp:116:         C[y] = c;
	move.l a1,d0	;  _199, tmp486
	add.l a1,d0	;  _199, tmp486
	add.l d0,a1	;  tmp486, tmp487
	add.l a1,a1	;  tmp487, tmp488
	move.w #1792,(a1,a2.l)	; , ADDER.C[_393].R
	lea (a2,a1.l),a1	;  ivtmp.252, tmp488, tmp494
	move.w #1792,2(a1)	; , ADDER.C[_393].G
	move.w #1792,4(a1)	; , ADDER.C[_393].B
.L115:
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (25,a0),a0	; , _353
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #40,d4	; ,
	cmp.l a0,d4	;  _353,
	bcs .L105		; 
;  Rampels.cpp:116:         C[y] = c;
	move.l a0,d0	;  _353, tmp505
	add.l a0,d0	;  _353, tmp505
	add.l d0,a0	;  tmp505, tmp506
	add.l a0,a0	;  tmp506, tmp507
	move.w #1280,(a0,a2.l)	; , ADDER.C[_353].R
	lea (a2,a0.l),a0	;  ivtmp.252, tmp507, tmp513
	move.w #1280,2(a0)	; , ADDER.C[_353].G
	move.w #1280,4(a0)	; , ADDER.C[_353].B
.L177:
;  Rampels.cpp:314:             sin_inx++;
	addq.l #1,d7	; , sin_inx
	lea ADDER,a5	; , ivtmp.252
	move.l a5,a2	;  ivtmp.252, ivtmp.252
	move.l a5,a0	;  ivtmp.252, ivtmp.259
	bra .L122		; 
.L123:
;  Rampels.cpp:168:             if(c[i] < 0) c[i] = 0x0; // saturate
	tst.w d0	;  _830
	bge .L175		; 
;  Rampels.cpp:168:             if(c[i] < 0) c[i] = 0x0; // saturate
	clr.w -2(a0)	;  MEM[(short int *)_247 + 4294967294B]
;  Rampels.cpp:164:         for (int i = 0; i < COP_SCR_H*3; i++)
	cmp.l d3,a0	;  _761, ivtmp.250
	bne .L126		; 
	bra .L176		; 
.L175:
;  Rampels.cpp:166:             c[i] += inc[i];
	move.w d0,-2(a0)	;  _830, MEM[(short int *)_247 + 4294967294B]
;  Rampels.cpp:164:         for (int i = 0; i < COP_SCR_H*3; i++)
	cmp.l d3,a0	;  _761, ivtmp.250
	bne .L126		; 
	bra .L176		; 
.L94:
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #40,d0	; ,
	cmp.l a5,d0	;  _863,
	bcs .L97		; 
;  Rampels.cpp:116:         C[y] = c;
	move.l #117442304,ADDER	; , MEM <vector(2) short int> [(short int *)&ADDER]
	move.l #117442816,ADDER+4	; , MEM <vector(2) short int> [(short int *)&ADDER + 4B]
	move.l #150997248,ADDER+8	; , MEM <vector(2) short int> [(short int *)&ADDER + 8B]
	move.l #184552192,ADDER+12	; , MEM <unsigned int> [(short int *)&ADDER + 12B]
	move.w #2816,ADDER+16	; , ADDER.C[2].B
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (19,a0),a1	; , _270, _262
;  Rampels.cpp:116:         C[y] = c;
	move.l a1,d0	;  _262, tmp248
	add.l a1,d0	;  _262, tmp248
	add.l d0,a1	;  tmp248, tmp249
	add.l a1,a1	;  tmp249, tmp250
	move.w #3328,(a1,a2.l)	; , ADDER.C[_262].R
	lea (a2,a1.l),a1	;  ivtmp.252, tmp250, tmp256
	move.w #3328,2(a1)	; , ADDER.C[_262].G
	move.w #3328,4(a1)	; , ADDER.C[_262].B
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (20,a0),a1	; , _270, _234
;  Rampels.cpp:116:         C[y] = c;
	move.l a1,d0	;  _234, tmp267
	add.l a1,d0	;  _234, tmp267
	add.l d0,a1	;  tmp267, tmp268
	add.l a1,a1	;  tmp268, tmp269
	move.w #3840,(a1,a2.l)	; , ADDER.C[_234].R
	lea (a2,a1.l),a1	;  ivtmp.252, tmp269, tmp275
	move.w #3840,2(a1)	; , ADDER.C[_234].G
	move.w #3840,4(a1)	; , ADDER.C[_234].B
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (21,a0),a1	; , _270, _6
;  Rampels.cpp:116:         C[y] = c;
	move.l a1,d0	;  _6, tmp416
	add.l a1,d0	;  _6, tmp416
	add.l d0,a1	;  tmp416, tmp417
	add.l a1,a1	;  tmp417, tmp418
	move.w #3328,(a1,a2.l)	; , ADDER.C[_345].R
	lea (a2,a1.l),a1	;  ivtmp.252, tmp418, tmp424
	move.w #3328,2(a1)	; , ADDER.C[_345].G
	move.w #3328,4(a1)	; , ADDER.C[_345].B
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (22,a0),a1	; , _270, _281
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #19,d4	; ,
	cmp.l a0,d4	;  _270,
	bne .L103		; 
	bra .L105		; 
.L97:
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (17,a0),a1	; , _270, _313
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #40,d0	; ,
	cmp.l a1,d0	;  _313,
	bcs .L100		; 
;  Rampels.cpp:116:         C[y] = c;
	move.l #150997248,ADDER	; , MEM <vector(2) short int> [(short int *)&ADDER]
	move.l #150997760,ADDER+4	; , MEM <vector(2) short int> [(short int *)&ADDER + 4B]
	move.l #184552192,ADDER+8	; , MEM <vector(2) short int> [(short int *)&ADDER + 8B]
	move.l #218107136,ADDER+12	; , MEM <unsigned int> [(short int *)&ADDER + 12B]
	move.l #218107648,ADDER+16	; , MEM <unsigned int> [(short int *)&ADDER + 16B]
	move.l #251662080,ADDER+20	; , MEM <unsigned int> [(short int *)&ADDER + 20B]
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	move.w #4,a1	; , _6
;  Rampels.cpp:116:         C[y] = c;
	move.l a1,d0	;  _6, tmp416
	add.l a1,d0	;  _6, tmp416
	add.l d0,a1	;  tmp416, tmp417
	add.l a1,a1	;  tmp417, tmp418
	move.w #3328,(a1,a2.l)	; , ADDER.C[_345].R
	lea (a2,a1.l),a1	;  ivtmp.252, tmp418, tmp424
	move.w #3328,2(a1)	; , ADDER.C[_345].G
	move.w #3328,4(a1)	; , ADDER.C[_345].B
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (22,a0),a1	; , _270, _281
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #19,d4	; ,
	cmp.l a0,d4	;  _270,
	bne .L103		; 
	bra .L105		; 
.L100:
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (18,a0),a1	; , _270, _334
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #40,d0	; ,
	cmp.l a1,d0	;  _334,
	bcs .L102		; 
;  Rampels.cpp:116:         C[y] = c;
	move.l #184552192,ADDER	; , MEM <vector(2) short int> [(short int *)&ADDER]
	move.l #184552704,ADDER+4	; , MEM <vector(2) short int> [(short int *)&ADDER + 4B]
	move.l #218107136,ADDER+8	; , MEM <vector(2) short int> [(short int *)&ADDER + 8B]
	move.l #251662080,ADDER+12	; , MEM <unsigned int> [(short int *)&ADDER + 12B]
	move.l #251661568,ADDER+16	; , MEM <unsigned int> [(short int *)&ADDER + 16B]
	move.l #218107136,ADDER+20	; , MEM <unsigned int> [(short int *)&ADDER + 20B]
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	move.w #4,a1	; , _281
;  Rampels.cpp:116:         C[y] = c;
	move.l a1,d0	;  _281, tmp441
	add.l a1,d0	;  _281, tmp441
	add.l d0,a1	;  tmp441, tmp442
	add.l a1,a1	;  tmp442, tmp443
	move.w #2816,(a1,a2.l)	; , ADDER.C[_347].R
	lea (a2,a1.l),a1	;  ivtmp.252, tmp443, tmp449
	move.w #2816,2(a1)	; , ADDER.C[_347].G
	move.w #2816,4(a1)	; , ADDER.C[_347].B
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (23,a0),a1	; , _270, _3
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #18,d4	; ,
	cmp.l a0,d4	;  _270,
	bne .L107		; 
	bra .L105		; 
.L102:
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (19,a0),a1	; , _270, _355
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #40,d0	; ,
	cmp.l a1,d0	;  _355,
	bcs .L106		; 
;  Rampels.cpp:116:         C[y] = c;
	move.l #218107136,ADDER	; , MEM <vector(2) short int> [(short int *)&ADDER]
	move.l #218107648,ADDER+4	; , MEM <vector(2) short int> [(short int *)&ADDER + 4B]
	move.l #251662080,ADDER+8	; , MEM <vector(2) short int> [(short int *)&ADDER + 8B]
	move.l #218107136,ADDER+12	; , MEM <unsigned int> [(short int *)&ADDER + 12B]
	move.l #218106624,ADDER+16	; , MEM <unsigned int> [(short int *)&ADDER + 16B]
	move.l #184552192,ADDER+20	; , MEM <unsigned int> [(short int *)&ADDER + 20B]
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	move.w #4,a1	; , _3
;  Rampels.cpp:116:         C[y] = c;
	move.l a1,d0	;  _3, tmp464
	add.l a1,d0	;  _3, tmp464
	add.l d0,a1	;  tmp464, tmp465
	add.l a1,a1	;  tmp465, tmp466
	move.w #2304,(a1,a2.l)	; , ADDER.C[_349].R
	lea (a2,a1.l),a1	;  ivtmp.252, tmp466, tmp472
	move.w #2304,2(a1)	; , ADDER.C[_349].G
	move.w #2304,4(a1)	; , ADDER.C[_349].B
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (24,a0),a1	; , _270, _199
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #17,d4	; ,
	cmp.l a0,d4	;  _270,
	bne .L110		; 
	bra .L105		; 
.L86:
;  Rampels.cpp:368: }
	movem.l (sp)+,#31996	; ,
	lea (16,sp),sp	; ,
	rts	
.L106:
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (20,a0),a1	; , _270, _376
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #40,d0	; ,
	cmp.l a1,d0	;  _376,
	bcs .L109		; 
;  Rampels.cpp:116:         C[y] = c;
	move.l #251662080,ADDER	; , MEM <vector(2) short int> [(short int *)&ADDER]
	move.l #251661568,ADDER+4	; , MEM <vector(2) short int> [(short int *)&ADDER + 4B]
	move.l #218107136,ADDER+8	; , MEM <vector(2) short int> [(short int *)&ADDER + 8B]
	move.l #184552192,ADDER+12	; , MEM <unsigned int> [(short int *)&ADDER + 12B]
	move.l #184551680,ADDER+16	; , MEM <unsigned int> [(short int *)&ADDER + 16B]
	move.l #150997248,ADDER+20	; , MEM <unsigned int> [(short int *)&ADDER + 20B]
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	move.w #4,a1	; , _199
;  Rampels.cpp:116:         C[y] = c;
	move.l a1,d0	;  _199, tmp486
	add.l a1,d0	;  _199, tmp486
	add.l d0,a1	;  tmp486, tmp487
	add.l a1,a1	;  tmp487, tmp488
	move.w #1792,(a1,a2.l)	; , ADDER.C[_393].R
	lea (a2,a1.l),a1	;  ivtmp.252, tmp488, tmp494
	move.w #1792,2(a1)	; , ADDER.C[_393].G
	move.w #1792,4(a1)	; , ADDER.C[_393].B
	bra .L115		; 
.L109:
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (21,a0),a1	; , _270, _397
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #40,d0	; ,
	cmp.l a1,d0	;  _397,
	bcs .L111		; 
;  Rampels.cpp:116:         C[y] = c;
	move.l #218107136,ADDER	; , MEM <vector(2) short int> [(short int *)&ADDER]
	move.l #218106624,ADDER+4	; , MEM <vector(2) short int> [(short int *)&ADDER + 4B]
	move.l #184552192,ADDER+8	; , MEM <vector(2) short int> [(short int *)&ADDER + 8B]
	move.l #150997248,ADDER+12	; , MEM <unsigned int> [(short int *)&ADDER + 12B]
	move.l #150996736,ADDER+16	; , MEM <unsigned int> [(short int *)&ADDER + 16B]
	move.l #117442304,ADDER+20	; , MEM <unsigned int> [(short int *)&ADDER + 20B]
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	move.w #4,a0	; , _353
;  Rampels.cpp:116:         C[y] = c;
	move.l a0,d0	;  _353, tmp505
	add.l a0,d0	;  _353, tmp505
	add.l d0,a0	;  tmp505, tmp506
	add.l a0,a0	;  tmp506, tmp507
	move.w #1280,(a0,a2.l)	; , ADDER.C[_353].R
	lea (a2,a0.l),a0	;  ivtmp.252, tmp507, tmp513
	move.w #1280,2(a0)	; , ADDER.C[_353].G
	move.w #1280,4(a0)	; , ADDER.C[_353].B
	bra .L177		; 
.L111:
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (22,a0),a1	; , _270, _418
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #40,d0	; ,
	cmp.l a1,d0	;  _418,
	bcs .L113		; 
;  Rampels.cpp:116:         C[y] = c;
	move.l #184552192,ADDER	; , MEM <vector(2) short int> [(short int *)&ADDER]
	move.l #184551680,ADDER+4	; , MEM <vector(2) short int> [(short int *)&ADDER + 4B]
	move.l #150997248,ADDER+8	; , MEM <vector(2) short int> [(short int *)&ADDER + 8B]
	move.l #117442304,ADDER+12	; , MEM <unsigned int> [(short int *)&ADDER + 12B]
	move.w #1792,ADDER+16	; , ADDER.C[2].B
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	move.w #3,a0	; , _353
;  Rampels.cpp:116:         C[y] = c;
	move.l a0,d0	;  _353, tmp505
	add.l a0,d0	;  _353, tmp505
	add.l d0,a0	;  tmp505, tmp506
	add.l a0,a0	;  tmp506, tmp507
	move.w #1280,(a0,a2.l)	; , ADDER.C[_353].R
	lea (a2,a0.l),a0	;  ivtmp.252, tmp507, tmp513
	move.w #1280,2(a0)	; , ADDER.C[_353].G
	move.w #1280,4(a0)	; , ADDER.C[_353].B
	bra .L177		; 
.L113:
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (23,a0),a1	; , _270, _439
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #40,d0	; ,
	cmp.l a1,d0	;  _439,
	bcs .L114		; 
;  Rampels.cpp:116:         C[y] = c;
	move.l #150997248,ADDER	; , MEM <vector(2) short int> [(short int *)&ADDER]
	move.l #150996736,ADDER+4	; , MEM <unsigned int> [(short int *)&ADDER + 4B]
	move.l #117442304,ADDER+8	; , MEM <unsigned int> [(short int *)&ADDER + 8B]
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	move.w #2,a0	; , _353
;  Rampels.cpp:116:         C[y] = c;
	move.l a0,d0	;  _353, tmp505
	add.l a0,d0	;  _353, tmp505
	add.l d0,a0	;  tmp505, tmp506
	add.l a0,a0	;  tmp506, tmp507
	move.w #1280,(a0,a2.l)	; , ADDER.C[_353].R
	lea (a2,a0.l),a0	;  ivtmp.252, tmp507, tmp513
	move.w #1280,2(a0)	; , ADDER.C[_353].G
	move.w #1280,4(a0)	; , ADDER.C[_353].B
	bra .L177		; 
.L114:
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	lea (24,a0),a1	; , _270, _312
;  Rampels.cpp:115:         if(y < 0 || y >= COP_SCR_H) return;
	moveq #40,d0	; ,
	cmp.l a1,d0	;  _312,
	bcs .L115		; 
;  Rampels.cpp:116:         C[y] = c;
	move.l #117442304,ADDER	; , MEM <vector(2) short int> [(short int *)&ADDER]
	move.w #1792,ADDER+4	; , ADDER.C[0].B
;  Rampels.cpp:312:                 ADDER.Dot(j+20+y/2,spot_color); // apply sin table
	move.w #1,a0	; , _353
;  Rampels.cpp:116:         C[y] = c;
	move.l a0,d0	;  _353, tmp505
	add.l a0,d0	;  _353, tmp505
	add.l d0,a0	;  tmp505, tmp506
	add.l a0,a0	;  tmp506, tmp507
	move.w #1280,(a0,a2.l)	; , ADDER.C[_353].R
	lea (a2,a0.l),a0	;  ivtmp.252, tmp507, tmp513
	move.w #1280,2(a0)	; , ADDER.C[_353].G
	move.w #1280,4(a0)	; , ADDER.C[_353].B
	bra .L177		; 
	; size	BkgBars_Start, .-BkgBars_Start
	align	2
	xdef	BkgBars_Update
	; type	BkgBars_Update, @function
BkgBars_Update:
;  Rampels.cpp:399:     }
	rts	
	; size	BkgBars_Update, .-BkgBars_Update
	xdef	bkg_B
		bss
	align	2
	; type	bkg_B, @object
	; size	bkg_B, 384
bkg_B:
	ds.b	384
	xdef	bkg_A
	align	2
	; type	bkg_A, @object
	; size	bkg_A, 384
bkg_A:
	ds.b	384
	xdef	bkg_INC
	align	2
	; type	bkg_INC, @object
	; size	bkg_INC, 384
bkg_INC:
	ds.b	384
	xdef	bkg_POS
	align	2
	; type	bkg_POS, @object
	; size	bkg_POS, 384
bkg_POS:
	ds.b	384
	xdef	BUF_B
	align	4
	; type	BUF_B, @object
	; size	BUF_B, 246
BUF_B:
	ds.b	246
	xdef	BUF_A
	align	4
	; type	BUF_A, @object
	; size	BUF_A, 246
BUF_A:
	ds.b	246
	xdef	BASE_INC
	align	4
	; type	BASE_INC, @object
	; size	BASE_INC, 246
BASE_INC:
	ds.b	246
	xdef	ADDER
	align	4
	; type	ADDER, @object
	; size	ADDER, 246
ADDER:
	ds.b	246
	xdef	BASE
	align	4
	; type	BASE, @object
	; size	BASE, 246
BASE:
	ds.b	246
	xdef	bkg_sin_table
	data
	; type	bkg_sin_table, @object
	; size	bkg_sin_table, 256
bkg_sin_table:
	;; ""
	dc.b	0
	;; "\001\002\003\004\005\006\007\b\t\n\013\f\r\r\016\017\020\021\022\023\024\025\025\026\027\030\031\031\032\033\034\034\035\036\036\037  !!\"\"##$$%%%&&&'''''((((((((((((('''''&&&%%%$$##\"\"!!  \037\036\036\035\034\034\033\032\031\031\030\027\026\025\025\024\023\022\021\020\017\016\r\r\f\013\n\t\b\007\006\005\004\003\002\001"
	dc.b	1,2,3,4,5,6,7,8,9,10,11,12,13,13,14,15,16,17,18,19,20,21,21,22,23,24,25,25,26,27,28,28,29,30,30,31,32,32,33,33,34,34,35,35,36,36,37,37,37,38,38,38,39,39,39,39,39,40,40,40,40,40,40,40,40,40,40,40,40,40,39,39,39,39,39,38,38,38,37,37,37,36,36,35,35,34,34,33,33,32,32,31,30,30,29,28,28,27,26,25,25,24,23,22,21,21,20,19,18,17,16,15,14,13,13,12,11,10,9,8,7,6,5,4,3,2,1
	;; "\377\376\375\374\373\372\371\370\367\366\365\364\363\363\362"
	dc.b	255,254,253,252,251,250,249,248,247,246,245,244,243,243,242
	;; "\361\360\357\356\355\354\353\353\352\351\350\347\347\346\345"
	dc.b	241,240,239,238,237,236,235,235,234,233,232,231,231,230,229
	;; "\344\344\343\342\342\341\340\340\337\337\336\336\335\335\334"
	dc.b	228,228,227,226,226,225,224,224,223,223,222,222,221,221,220
	;; "\334\333\333\333\332\332\332\331\331\331\331\331\330\330\330"
	dc.b	220,219,219,219,218,218,218,217,217,217,217,217,216,216,216
	;; "\330\330\330\330\330\330\330\330\330\330\331\331\331\331\331"
	dc.b	216,216,216,216,216,216,216,216,216,216,217,217,217,217,217
	;; "\332\332\332\333\333\333\334\334\335\335\336\336\337\337\340"
	dc.b	218,218,218,219,219,219,220,220,221,221,222,222,223,223,224
	;; "\340\341\342\342\343\344\344\345\346\347\347\350\351\352\353"
	dc.b	224,225,226,226,227,228,228,229,230,231,231,232,233,234,235
	;; "\353\354\355\356\357\360\361\362\363\363\364\365\366\367\370"
	dc.b	235,236,237,238,239,240,241,242,243,243,244,245,246,247,248
	;; "\371\372\373\374\375\376\377"
	dc.b	249,250,251,252,253,254,255
	; ident	"GCC: (GNU) 14.2.0"
