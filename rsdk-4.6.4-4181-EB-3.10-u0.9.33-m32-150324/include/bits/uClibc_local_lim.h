/*
 * Copyright (C) 2000-2006 Erik Andersen <andersen@uclibc.org>
 *
 * Licensed under the LGPL v2.1, see the file COPYING.LIB in this tarball.
 */
/*
 * Never include this file directly; use <unistd.h> instead.
 */

#ifndef	_BITS_UCLIBC_LOCAL_LIM_H
#define	_BITS_UCLIBC_LOCAL_LIM_H	1

/* This file works correctly only if local_lim.h is the NPTL version */
#if !defined PTHREAD_KEYS_MAX || defined TIMER_MAX || !defined SEM_VALUE_MAX
# error local_lim.h was incorrectly updated, use the NPTL version from glibc
#endif

/* This should really be moved to thread specific directories */
/* glibc uses 16384 */
# define PTHREAD_THREADS_MAX	1024
# define TIMER_MAX		256
#  undef SEM_VALUE_MAX
#  define SEM_VALUE_MAX	((int) ((~0u) >> 1))
# undef PTHREAD_STACK_MIN
/* glibc uses at least 16364 */
# define PTHREAD_STACK_MIN	1024

#endif /* bits/uClibc_local_lim.h */
