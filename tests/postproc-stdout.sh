#!/bin/sh
# Copyright (c) 2018--2020 TK Chia
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; see the file COPYING2.LIB.  If not see
# <http://www.gnu.org/licenses/>.

# Script to postprocess the output of a DOS program presented on stdin (by
# way of dosemu), and write the postprocessed output to stdout.  This is for
# comparing against an expected test output.

if test yes = "$li86_cv_dosemu_is_1"; then \
  dos2unix
else
  # As of writing, dosemu2 either blithely ignores the -quiet flag or only
  # partially honours it.  -- tkchia 20200916
  dos2unix | awk 'BEGIN	{ p = 0 }
			{ if (p) print }
		  /^About to Execute : / { p = 1 }'
fi
