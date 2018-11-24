#!/bin/sh
# Copyright (c) 2018 TK Chia
#
# This file is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; ; see the file COPYING.  If not see
# <http://www.gnu.org/licenses/>.

# Script to do automated testing under Travis CI (https://travis-ci.org/),
# invoked by .travis.yml .

set -e -v
mkdir build-$$ install-$$
inst_prefix="`pwd`"/install-$$
cd build-$$
# Travis CI sets $CC to `gcc'.  This interferes with the `configure' script's
# detection of the C compiler, which should really be `ia16-elf-gcc'.  (!)
unset CC
../configure --host=ia16-elf --prefix="$inst_prefix" ${1+"$@"}
make
make check || \
  (cat tests/testsuite.log && exit 1)
exec make install
