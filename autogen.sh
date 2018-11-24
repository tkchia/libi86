#!/bin/sh
# Copyright (c) 2018 TK Chia
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; see the file COPYING3.LIB.  If not see
# <http://www.gnu.org/licenses/>.

echo "PATH=$PATH"
find -name autom4te.cache -type d -print0 | xargs -0 rm -rf
find -name configure.ac -type f -print -execdir autoconf \;
find -name testsuite.at -type f -print \
  -execdir autom4te --language=autotest -o testsuite testsuite.at \;
