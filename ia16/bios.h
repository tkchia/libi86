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

#ifndef _LIBI86_BIOS_H_
#define _LIBI86_BIOS_H_

#ifdef __cplusplus
extern "C"
{
#endif

__attribute__ ((__gnu_inline__)) extern inline unsigned short
_bios_equiplist (void)
{
  unsigned a;
  __asm volatile ("int $0x11" : "=a" (a));
  return a;
}

__attribute__ ((__gnu_inline__)) extern inline unsigned short
_bios_memsize (void)
{
  unsigned a;
  __asm volatile ("int $0x12" : "=a" (a));
  return a;
}

extern unsigned short _bios_keybrd (unsigned __service);

#define _KEYBRD_READ		0x00u
#define _KEYBRD_READY		0x01u
#define _KEYBRD_SHIFTSTATUS	0x02u
#define _NKEYBRD_READ		0x10u
#define _NKEYBRD_READY		0x11u
#define _NKEYBRD_SHIFTSTATUS	0x12u

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif
