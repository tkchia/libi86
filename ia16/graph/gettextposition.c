/*
 * Copyright (c) 2020 TK Chia
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

#define _LIBI86_COMPILING_
#include <inttypes.h>
#include "libi86/internal/graph.h"

struct rccoord
_gettextposition (void)
{
  unsigned char x1z, x2z, y1z, y2z;
  struct __libi86_vid_rccoord_t pxy;
  struct rccoord coord;

  pxy = __libi86_vid_get_rccoord (__libi86_vid_get_curr_pg ());

  x1z = __libi86_vid_state.x1z;
  y1z = __libi86_vid_state.y1z;
  x2z = __libi86_vid_state.x2z;
  y2z = __libi86_vid_state.y2z;

  if (pxy.x < x1z || pxy.x > x2z || pxy.y < y1z || pxy.y > y2z)
    {
      coord.row = coord.col = 1;
    }
  else
    {
      coord.row = (short) pxy.y - y1z + 1;
      coord.col = (short) pxy.x - x1z + 1;
    }

  return coord;
}
