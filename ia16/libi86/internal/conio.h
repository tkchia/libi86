/*
 * Copyright (c) 2020 TK Chia
 *
 * This file is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; see the file COPYING2.LIB.  If not see
 * <http://www.gnu.org/licenses/>.
 */

#ifndef _LIBI86_LIBI86_INTERNAL_CONIO_H_
#define _LIBI86_LIBI86_INTERNAL_CONIO_H_

#ifndef _LIBI86_COMPILING_
# error "<libi86/internal/conio.h> should only be used when compiling libi86!"
#endif

#include <stdint.h>
#include <libi86/internal/cdefs.h>
#include <i86.h>
#include <conio.h>

_LIBI86_BEGIN_EXTERN_C

/* Various internal variables used by <conio.h> routines. */

#ifdef __MSDOS__
extern int __libi86_con_in_fd, __libi86_con_out_fd;
#endif
extern unsigned __libi86_ungetch_buf;

_LIBI86_END_EXTERN_C

#endif
