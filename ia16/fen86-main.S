/*
 * Copyright (c) 2019 TK Chia
 *
 * This file is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; see the file COPYING3.LIB.  If not see
 * <http://www.gnu.org/licenses/>.
 */

	.arch	i386, jumps
	.code16

#ifdef __MSDOS__
	.section .text

	.global	__ia16_need_libfen86
__ia16_need_libfen86 = 1

	/* %dr6 bit fields. */
#define DR6_B0		(1<<0)
#define DR6_B1		(1<<1)
#define DR6_B2		(1<<2)
#define DR6_B3		(1<<3)
	/* %dr7 fields for the lower bits. */
#define DR7_L0		(1<<0)
#define DR7_G0		(1<<1)
#define DR7_L1		(1<<2)
#define DR7_G1		(1<<3)
#define DR7_L2		(1<<4)
#define DR7_G2		(1<<5)
#define DR7_L3		(1<<6)
#define DR7_G3		(1<<7)
#define DR7_LE		(1<<8)
#define DR7_GE		(1<<9)
	/* %dr7 field values for the R/W and LEN fields (bits 16--31) for the
	   respective breakpoints. */
#define DR7_BKPT_MASK	0x3
#define DR7_BKPT_EXEC	0x0
#define DR7_BKPT_W	0x1
#define DR7_BKPT_RW	0x3
#define DR7_LEN_MASK	0xc
#define DR7_LEN_1B	0x0
#define DR7_LEN_2B	0x4
#define DR7_LEN_4B	0xc

.Lctor_fen86:
	/* Check if we are running on a 286+.  */
	pushw	%sp
	popw	%bx
	subw	%sp,	%bx
	jnz	.Ldone_ctor
	/* Assume that we are not in protected mode.  Check if we are in
	   virtual 8086 mode --- if so, it is confirmed that we are running
	   on a 386+.  */
	movw	%bx,	%ds		/* %bx == 0 */
	smsw	%ax
	testb	$1,	%al
	jnz	.Ldo
	/* Nope, we are in real mode.  To test for a 386+, try to issue a
	   386 instruction; a 286 will respond with an exception 6.  */
	movb	$6*4,	%bl
	pushw	2(%bx)
	pushw	(%bx)
	movw	$.Lexcp6, (%bx)
	movw	%cs,	2(%bx)
	popl	(%bx)
.Ldo:
	/* Yes, we are on a 386+.  Save the original value of %dr7.  */
	cli
	movl	%dr7,	%eax
	movl	%eax,	%ss:.Lorig_dr7
	sti
	/* Try to place a hardware breakpoint on writes at offsets 0--3
	   within the data segment, i.e. at the near null address.  */
	movw	%ss,	%dx
	xorw	%ax,	%ax
	movb	$(DR7_BKPT_W|DR7_LEN_4B), %ch
	call	.Lalloc_hw_bkpt
	incw	%ax
	jz	.Ldone_ctor_restore_ds
	movb	%al,	%ss:.Lnull_drs
	/* If we are successful, install an exception 1 handler.  */
	movw	$1*4,	%bx
	pushl	(%bx)
	popl	.Lp_orig_excp1
	movw	$.Lexcp1, (%bx)
	movw	%cs,	2(%bx)
	/* Try to place another breakpoint for offsets 4--7.  */
	movw	%ss,	%dx
	movw	$4,	%ax
	movb	$(DR7_BKPT_W|DR7_LEN_4B), %ch
	call	.Lalloc_hw_bkpt
	movb	%al,	%ss:.Lnull_drs+1
.Ldone_ctor_restore_ds:
	pushw	%ss
	popw	%ds
.Ldone_ctor:
	ret
.Lexcp6:
	popw	%cx
	popw	%cx
	popfw
	popw	(%bx)
	popw	2(%bx)
	pushw	%ss
	popw	%ds
	jmp	.Ldone_ctor

.Ldtor_fen86:
	/* Free up any hardware breakpoints we have allocated.  Note that
	   this destructor may be run even if we are not on a 386+.  */
	movb	.Lnull_drs, %al
	testb	%al,	%al
	js	.Ldone_dtor
	call	.Lfree_hw_bkpt
	movb	.Lnull_drs+1, %al
	call	.Lfree_hw_bkpt
	cli
	movl	$.Lp_orig_excp1, %eax
	pushw	$0
	popw	%ds
	movl	%eax,	1*4
	pushw	%ss
	popw	%ds
	movl	.Lorig_dr7, %eax
	testw	$(DR7_LE|DR7_GE), %ax
	jnz	.Ldone_dtor_sti
	movl	%eax,	%dr7
.Ldone_dtor_sti:
	sti
.Ldone_dtor:
	ret

	/* Allocate a hardware breakpoint for the address %dx:%ax.  %ch
	   should specify the type of access to break on, and the length of
	   the breakpoint.

	   Return the breakpoint number in %ax (0 to 3) if successful, or -1
	   otherwise.  Destroy %ecx, %edx, and the rest of %eax.  */
.Lalloc_hw_bkpt:
	pushfw
	cli
	movzwl	%ax,	%eax
	movzwl	%dx,	%edx
	shll	$4,	%edx
	addl	%eax,	%edx
	movl	%dr7,	%eax
	testw	$(DR7_LE|DR7_GE), %ax
	jz	.Lenable
	testb	$(DR7_L0|DR7_G0), %al
	jz	.Lalloc0
	testb	$(DR7_L1|DR7_G1), %al
	jz	.Lalloc1
	testb	$(DR7_L2|DR7_G2), %al
	jz	.Lalloc2
	testb	$(DR7_L3|DR7_G3), %al
	jz	.Lalloc3
	movb	$-1,	%al
	jmp	.Ldone_alloc
.Lenable:
	orw	$(DR7_LE|DR7_GE), %ax
	movb	$0,	%al
.Lalloc0:
	orb	$(DR7_L0|DR7_G0), %al
	movl	%edx,	%dr0
	movb	$0,	%cl
	jmp	.Lset_rw_len
.Lalloc1:
	orb	$(DR7_L1|DR7_G1), %al
	movl	%edx,	%dr1
	movb	$1,	%cl
	jmp	.Lset_rw_len
.Lalloc2:
	orb	$(DR7_L2|DR7_G2), %al
	movl	%edx,	%dr2
	movb	$2,	%cl
	jmp	.Lset_rw_len
.Lalloc3:
	orb	$(DR7_L3|DR7_G3), %al
	movl	%edx,	%dr3
	movb	$3,	%cl
.Lset_rw_len:
	pushw	%cx
	shlb	%cl
	shlb	%cl
	rorl	%cl,	%eax
	andb	$~(DR7_BKPT_MASK|DR7_LEN_MASK), %al
	orb	%ch,	%al
	roll	%cl,	%eax
	movl	%eax,	%dr7
	popw	%ax
.Ldone_alloc:
	cbtw
	popfw
	ret

	/* Free the hardware breakpoint numbered %al, if 0 <= %al <= 3.
	   Destroy %eax and %ecx. */
.Lfree_hw_bkpt:
	cmpb	$3,	%al
	ja	0f
	xchgw	%ax,	%cx
	pushfw
	cli
	movl	%dr6,	%eax
	rorl	%cl,	%eax
	andb	$~1,	%al
	roll	%cl,	%eax
	movl	%eax,	%dr6
	movl	%dr7,	%eax
	shlb	%cl
	rorl	%cl,	%eax
	andb	$~(DR7_L0|DR7_G0), %al
	roll	%cl,	%eax
	movl	%eax,	%dr7
	popfw
0:
	ret

.Lexcp1:
	jmp	abort

	.balign	2

	.section .ctors.65535

	.balign	2
	.hword	.Lctor_fen86

	.section .dtors.65535

	.balign	2
	.hword	.Ldtor_fen86

	.section .data

	/* Debug registers used for detecting null pointer dereferences.  */
.Lnull_drs:
	.byte	-1, -1

	.lcomm	.Lorig_dr7, 4
	.lcomm	.Lp_orig_excp1, 4
#else
# warning "unknown target OS; libfen86 not implemented"
#endif
