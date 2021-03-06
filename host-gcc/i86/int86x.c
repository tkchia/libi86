/*
 * Copyright (c) 2018 TK Chia
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *   * Neither the name of the developer(s) nor the names of its
 *     contributors may be used to endorse or promote products derived from
 *     this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 * IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * Out-of-line implementation of int86x (INTR_NO, ...) for cases where
 * INTR_NO is not a compile-time constant.
 */

#define _LIBI86_COMPILING_
#include <inttypes.h>
#include "i86.h"

extern const void * const __libi86_intr_dispatch[0x100];

int
__libi86_int86x (int intr_no, const union REGS *in_regs, union REGS *out_regs,
		 struct SREGS *seg_regs)
{
  return __libi86_int86x_do (__libi86_intr_dispatch[(uint8_t) intr_no],
			     in_regs, out_regs, seg_regs);
}

_LIBI86_ALIAS (__libi86_int86x) int
int86x (int intr_no, const union REGS *in_regs, union REGS *out_regs,
	struct SREGS *seg_regs);

_LIBI86_ALIAS (__libi86_int86x) int
_int86xf (int intr_no, const union REGS *in_regs, union REGS *out_regs,
	  struct SREGS *seg_regs);
