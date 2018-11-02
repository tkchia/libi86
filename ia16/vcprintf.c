/*
 * Copyright (c) 2018 TK Chia
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

#define _LIBI86_COMPILING_
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "conio.h"
#include "libi86/internal/conio.h"

#ifdef __MSDOS__
static FILE *__libi86_con_out_fp = NULL;

int
vcprintf (const char *fmt, va_list ap)
{
  int n;

  if (! __libi86_con_out_fp)
    {
      __libi86_con_out_fp = fdopen (__libi86_con_out_fd, "a");
      if (! __libi86_con_out_fp)
	return -1;

      setbuf (__libi86_con_out_fp, NULL);
    }

  return vfprintf (__libi86_con_out_fp, fmt, ap);
}
#else
# warning "unknown host OS"
#endif