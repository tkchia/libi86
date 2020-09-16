/*
 * Copyright (c) 2018--2020 TK Chia
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

#include "libi86/internal/call-cvt.h"

	.arch	i8086, jumps
	.code16
	.att_syntax prefix

	TEXT_ (outp.S.LIBI86)
	.text
	.global	__libi86_outp
	.weak	outp
	.weak	_outp
	.weak	outportb
__libi86_outp:
outp:
_outp:
outportb:
	ENTER_BX_(4)
#ifndef __IA16_CALLCVT_REGPARMCALL
	MOV_ARG0W_BX_(%dx)
	MOV_ARG2W_BX_(%ax)
#else
	xchgw	%ax,	%dx
#endif
	outb	%al,	%dx
	RET_(4)
