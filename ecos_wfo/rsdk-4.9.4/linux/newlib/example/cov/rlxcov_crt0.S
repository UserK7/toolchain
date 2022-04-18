/*
 * crt0.S -- startup file for MIPS.
 *
 * Copyright (c) 1995, 1996, 1997, 2001 Cygnus Support
 *
 * The authors hereby grant permission to use, copy, modify, distribute,
 * and license this software and its documentation for any purpose, provided
 * that existing copyright notices are retained in all copies and that this
 * notice is included verbatim in any distributions. No written agreement,
 * license, or royalty fee is required for any of the authorized uses.
 * Modifications to this software may be copyrighted by their authors
 * and need not follow the licensing terms described here, provided that
 * the new terms are clearly indicated on the first page of each file where
 * they apply.
 */

#ifdef __mips16r
	.set mips16
#else /* !__mips16r */
	.set nomips16
#endif /* !__mips16r */

#include "regs.S"

/*
 * Set up some room for a stack. We just grab a chunk of memory.
 */
#define STACK_SIZE  0x4000
#define GLOBAL_SIZE 0x2000

#define STARTUP_STACK_SIZE	0x0100

/* This is for referencing addresses that are not in the .sdata or
   .sbss section under embedded-pic, or before we've set up gp.  */
#ifdef __mips16r
#define LA(t,x) li t,x
#else /* !__mips16r */
#define LA(t,x) la t,x
#endif

	.comm	__memsize, 12
	.comm	__lstack, STARTUP_STACK_SIZE

	.text
	.align	2

/* Without the following nop, GDB thinks _start is a data variable.
 * This is probably a bug in GDB in handling a symbol that is at the
 * start of the .text section.
 */
	nop

	.globl	hardware_hazard_hook .text
	.globl	_start
	.ent	_start
_start:
	.set	noreorder
#undef STATUS_MASK
#if defined (__mips_soft_float)
#  define STATUS_MASK (SR_CU3)
#else
#  define STATUS_MASK (SR_CU1|SR_CU3)
#endif

#ifndef __mips16r
	li	v0, STATUS_MASK
	mtc0	v0, C0_SR
	mtc0	zero, C0_CAUSE
	nop

	LA (gp, _gp)				# set the global data pointer
#endif
	.end _start

/*
 * zero out the bss section.
 */
	.globl	__memsize
	.globl	get_mem_info .text
	.globl	__stack
	.globl	__global
	.ent	zerobss
zerobss:
	LA (v0, _fbss)
	LA (v1, _end)
#ifdef __mips16r
        xor	a0,a0
3:
	sw	a0,0(v0)
	addiu	v0,v0,4				# no delay slot
	bltu	v0,v1,3b

	/* setup the stack pointer */
	LA (v0, __stack)			# is __stack set ?
	move	sp,v0				# set stack pointer
#else /* !__mips16r */
3:
	sw	zero,0(v0)
	bltu	v0,v1,3b
	addiu	v0,v0,4				# executed in delay slot

	/* setup the stack pointer */
	LA (t0, __stack)
	move	sp,t0				# set stack pointer
#endif /* !__mips16r */
	.end	zerobss

/*
 * initialize target specific stuff. Only execute these
 * functions it they exist.
 */
	.globl	hardware_init_hook .text
	.globl	software_init_hook .text
	.type	_fini,@function
	.type	_init,@function
	.globl	atexit .text
	.globl	exit .text
	.ent	init
init:
	LA (a0, _fini)
	jal	atexit
	nop

#ifdef GCRT0
	.globl	_ftext
	.globl	_extext
	LA (a0, _ftext)
	LA (a1, _etext)
	jal	monstartup
	nop
#endif


	jal	_init				# run global constructors
	nop

	addiu	a1,sp,32			# argv = sp + 32
	addiu	a2,sp,40			# envp = sp + 40
#ifdef __mips16r
	xor	v0,v0
	sw	v0,(a1)
	sw	v0,(a2)
	xor	a0,a0				# set argc to 0
	jal	main				# call the program start function
	nop

	# fall through to the "exit" routine
	jal	exit				# call libc exit to run the G++
	nop
						# destructors
	move	a0,v0				# pass through the exit code
#else /* !__mips16r */
	sw	zero,(a1)
	sw	zero,(a2)
	jal	rlx_cov_init
	nop
	jal	main				# call the program start function
	nop
	jal	rlx_cov_exit
	nop
	move	a0,zero				# set argc to 0

	# fall through to the "exit" routine
	jal	exit				# call libc exit to run the G++
						# destructors
	move	a0,v0				# pass through the exit code
#endif /* !__mips16r */
	.end	init

 
/* Assume the PICBASE set up above is no longer valid below here.  */
#ifdef __mips_embedded_pic
#undef PICBASE
#endif
	
/*
 * _exit -- Exit from the application. Normally we cause a user trap
 *          to return to the ROM monitor for another run. NOTE: This is
 *	    the only other routine we provide in the crt0.o object, since
 *          it may be tied to the "_start" routine. It also allows
 *          executables that contain a complete world to be linked with
 *          just the crt0.o object.
 */
	.globl	hardware_exit_hook .text
	.globl	_exit
	.ent _exit
_exit:
7:
#ifdef __mips16r
#ifdef GCRT0
	LA (v0, _mcleanup)
	jal	v0
	nop
#endif
#else /* !__mips16r */
#ifdef GCRT0
	LA (t0, _mcleanup)
	jal	t0
	nop
#endif
#endif /* !__mips16r */
1:
	move v0, a0
	sdbbp 1
	.end _exit

/* RLX exception handler */
	.section .exception,"ax",@progbits
	.globl rlx_exception_handler
	.ent   rlx_exception_handler
	.type  rlx_exception_handler,@function
rlx_exception_handler:
	.set noreorder
/* Different exit code register for Taroko */
#if defined __m4281 || defined __m5281
	mfc0 v0, C0_CAUSE
	addiu v0, 128
#else
	mfc0 a0, C0_CAUSE
	addiu a0, 128
#endif
	sdbbp 1
	.end rlx_exception_handler

/* Assume the PICBASE set up above is no longer valid below here.  */
#ifdef __mips_embedded_pic
#undef PICBASE
#endif

/* EOF crt0.S */
