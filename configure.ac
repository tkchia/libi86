dnl Copyright (c) 2018 TK Chia
dnl
dnl This file is free software; you can redistribute it and/or modify it
dnl under the terms of the GNU Lesser General Public License as published by
dnl the Free Software Foundation; either version 3 of the License, or
dnl (at your option) any later version.
dnl
dnl This program is distributed in the hope that it will be useful, but
dnl WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
dnl Lesser General Public License for more details.
dnl
dnl You should have received a copy of the GNU Lesser General Public License
dnl along with this program; see the file COPYING3.LIB.  If not see
dnl <http://www.gnu.org/licenses/>.

dnl For the actual build, this script mostly just hands over to ia16/configure,
dnl which sets things up for an automated multilib build.  It seems that
dnl setting up a project top-level directory for a multilib build is not
dnl supported.
dnl
dnl For tests, however, this script _does_ do the actual work of setting up
dnl the test suite runs, using the GNU Autotools' experimental Autotest
dnl feature.	-- tkchia 20181118

AC_PREREQ(2.69)
AC_INIT([libi86],m4_esyscmd_s([TZ=UTC0 git log -n1 --oneline \
  --date=short-local --format='%ad' | sed 's/-//g']),,[libi86])
AC_CANONICAL_BUILD
AC_CANONICAL_HOST
AC_PROG_CC
AC_PATH_PROG(DOSEMU, dosemu, /bin/false)
AC_CONFIG_SUBDIRS([ia16])
AC_CONFIG_TESTDIR([tests])
AC_CONFIG_FILES([Makefile tests/atlocal])
AC_OUTPUT
