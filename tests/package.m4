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

m4_define([AT_PACKAGE_NAME],[libi86])
m4_define([AT_PACKAGE_TARNAME],[libi86])
m4_define([AT_PACKAGE_VERSION],m4_esyscmd_s([git log -n1 --oneline \
  --date=short-local --format='%ad' | sed 's/-//g']))
m4_define([AT_PACKAGE_STRING],AT_PACKAGE_NAME AT_PACKAGE_VERSION)
m4_define([AT_PACKAGE_BUGREPORT],[https://github.com/tkchia/libi86/issues])
