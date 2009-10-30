# generated automatically by aclocal 1.7.5 -*- Autoconf -*-

# Copyright (C) 1996, 1997, 1998, 1999, 2000, 2001, 2002
# Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, to the extent permitted by law; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.

# **************************************************************************
# SIM_AC_SETUP_MSVC_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# This macro invokes IF-FOUND if the wrapmsvc wrapper can be run, and
# IF-NOT-FOUND if not.
#
# Authors:
#   Morten Eriksen <mortene@coin3d.org>
#   Lars J. Aas <larsa@coin3d.org>

# **************************************************************************

AC_DEFUN([SIM_AC_MSVC_DISABLE_OPTION], [
AC_ARG_ENABLE([msvc],
  [AC_HELP_STRING([--disable-msvc], [don't require MS Visual C++ on Cygwin])],
  [case $enableval in
  no | false) sim_ac_try_msvc=false ;;
  *)          sim_ac_try_msvc=true ;;
  esac],
  [sim_ac_try_msvc=true])
])

# **************************************************************************
# Usage:
#  SIM_AC_MSC_VERSION
#
# Find version number of the Visual C++ compiler. sim_ac_msc_version will
# contain the full version number string, and sim_ac_msc_major_version
# will contain only the Visual C++ major version number and
# sim_ac_msc_minor_version will contain the minor version number.

AC_DEFUN([SIM_AC_MSC_VERSION], [

AC_MSG_CHECKING([version of Visual C++ compiler])

cat > conftest.c << EOF
int VerMSC = _MSC_VER;
EOF

# The " *"-parts of the last sed-expression on the next line are necessary
# because at least the Solaris/CC preprocessor adds extra spaces before and
# after the trailing semicolon.
sim_ac_msc_version=`$CXXCPP $CPPFLAGS conftest.c 2>/dev/null | grep '^int VerMSC' | sed 's%^int VerMSC = %%' | sed 's% *;.*$%%'`

sim_ac_msc_minor_version=0
if test $sim_ac_msc_version -ge 1500; then
  sim_ac_msc_major_version=9
elif test $sim_ac_msc_version -ge 1400; then
  sim_ac_msc_major_version=8
elif test $sim_ac_msc_version -ge 1300; then
  sim_ac_msc_major_version=7
  if test $sim_ac_msc_version -ge 1310; then
    sim_ac_msc_minor_version=1
  fi
elif test $sim_ac_msc_version -ge 1200; then
  sim_ac_msc_major_version=6
elif test $sim_ac_msc_version -ge 1100; then
  sim_ac_msc_major_version=5
else
  sim_ac_msc_major_version=0
fi

# compatibility with old version of macro
sim_ac_msvc_version=$sim_ac_msc_major_version

rm -f conftest.c
AC_MSG_RESULT($sim_ac_msc_major_version.$sim_ac_msc_minor_version)
]) # SIM_AC_MSC_VERSION

# **************************************************************************
# Note: the SIM_AC_SETUP_MSVC_IFELSE macro has been OBSOLETED and
# replaced by the one below.
#
# If the Microsoft Visual C++ cl.exe compiler is available, set us up for
# compiling with it and to generate an MSWindows .dll file.

AC_DEFUN([SIM_AC_SETUP_MSVCPP_IFELSE],
[
AC_REQUIRE([SIM_AC_MSVC_DISABLE_OPTION])
AC_REQUIRE([SIM_AC_SPACE_IN_PATHS])

: ${BUILD_WITH_MSVC=false}
if $sim_ac_try_msvc; then
  if test -z "$CC" -a -z "$CXX"; then
    sim_ac_wrapmsvc=`cd $ac_aux_dir; pwd`/wrapmsvc.exe
    echo "$as_me:$LINENO: sim_ac_wrapmsvc=$sim_ac_wrapmsvc" >&AS_MESSAGE_LOG_FD
    AC_MSG_CHECKING([setup for wrapmsvc.exe])
    if $sim_ac_wrapmsvc >&AS_MESSAGE_LOG_FD 2>&AS_MESSAGE_LOG_FD; then
      m4_ifdef([$0_VISITED],
        [AC_FATAL([Macro $0 invoked multiple times])])
      m4_define([$0_VISITED], 1)
      CC=$sim_ac_wrapmsvc
      CXX=$sim_ac_wrapmsvc
      export CC CXX
      BUILD_WITH_MSVC=true
      AC_MSG_RESULT([working])

      # Robustness: we had multiple reports of Cygwin ''link'' getting in
      # the way of MSVC link.exe, so do a little sanity check for that.
      #
      # FIXME: a better fix would be to call link.exe with full path from
      # the wrapmsvc wrapper, to avoid any trouble with this -- I believe
      # that should be possible, using the dirname of the full cl.exe path.
      # 20050714 mortene.
      sim_ac_check_link=`type link`
      AC_MSG_CHECKING([whether Cygwin's /usr/bin/link shadows MSVC link.exe])
      case x"$sim_ac_check_link" in
      x"link is /usr/bin/link"* )
        AC_MSG_RESULT(yes)
        SIM_AC_ERROR([cygwin-link])
        ;;
      * )
        AC_MSG_RESULT(no)
        ;;
      esac

    else
      case $host in
      *-cygwin)
        AC_MSG_RESULT([not working])
        SIM_AC_ERROR([no-msvc++]) ;;
      *)
        AC_MSG_RESULT([not working (as expected)])
        ;;
      esac
    fi
  fi
fi
export BUILD_WITH_MSVC
AC_SUBST(BUILD_WITH_MSVC)

if $BUILD_WITH_MSVC; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_SETUP_MSVC_IFELSE

# **************************************************************************
# SIM_AC_SETUP_MSVCRT
#
# This macro sets up compiler flags for the MS Visual C++ C library of
# choice.

AC_DEFUN([SIM_AC_SETUP_MSVCRT],
[sim_ac_msvcrt_LDFLAGS=""
sim_ac_msvcrt_LIBS=""

AC_ARG_WITH([msvcrt],
  [AC_HELP_STRING([--with-msvcrt=<crt>],
                  [set which C run-time library to build against])],
  [case `echo "$withval" | tr "[A-Z]" "[a-z]"` in
  default | singlethread-static | ml | /ml | libc | libc\.lib )
    sim_ac_msvcrt=singlethread-static
    sim_ac_msvcrt_CFLAGS="/ML"
    sim_ac_msvcrt_CXXFLAGS="/ML"
    ;;
  default-debug | singlethread-static-debug | mld | /mld | libcd | libcd\.lib )
    sim_ac_msvcrt=singlethread-static-debug
    sim_ac_msvcrt_CFLAGS="/MLd"
    sim_ac_msvcrt_CXXFLAGS="/MLd"
    ;;
  multithread-static | mt | /mt | libcmt | libcmt\.lib )
    sim_ac_msvcrt=multithread-static
    sim_ac_msvcrt_CFLAGS="/MT"
    sim_ac_msvcrt_CXXFLAGS="/MT"
    ;;
  multithread-static-debug | mtd | /mtd | libcmtd | libcmtd\.lib )
    sim_ac_msvcrt=multithread-static-debug
    sim_ac_msvcrt_CFLAGS="/MTd"
    sim_ac_msvcrt_CXXFLAGS="/MTd"
    ;;
  multithread-dynamic | md | /md | msvcrt | msvcrt\.lib )
    sim_ac_msvcrt=multithread-dynamic
    sim_ac_msvcrt_CFLAGS="/MD"
    sim_ac_msvcrt_CXXFLAGS="/MD"
    ;;
  multithread-dynamic-debug | mdd | /mdd | msvcrtd | msvcrtd\.lib )
    sim_ac_msvcrt=multithread-dynamic-debug
    sim_ac_msvcrt_CFLAGS="/MDd"
    sim_ac_msvcrt_CXXFLAGS="/MDd"
    ;;
  *)
    SIM_AC_ERROR([invalid-msvcrt])
    ;;
  esac],
  [sim_ac_msvcrt=singlethread-static])

AC_MSG_CHECKING([MSVC++ C library choice])
AC_MSG_RESULT([$sim_ac_msvcrt])

$1
]) # SIM_AC_SETUP_MSVCRT

# **************************************************************************
# SIM_AC_SPACE_IN_PATHS

AC_DEFUN([SIM_AC_SPACE_IN_PATHS], [
sim_ac_full_builddir=`pwd`
sim_ac_full_srcdir=`cd $srcdir; pwd`
if test -z "`echo $sim_ac_full_srcdir | tr -cd ' '`"; then :; else
  AC_MSG_WARN([Detected space character in the path leading up to the Coin source directory - this will probably cause random problems later. You are advised to move the Coin source directory to another location.])
  SIM_AC_CONFIGURATION_WARNING([Detected space character in the path leading up to the Coin source directory - this will probably cause random problems later. You are advised to move the Coin source directory to another location.])
fi
if test -z "`echo $sim_ac_full_builddir | tr -cd ' '`"; then :; else
  AC_MSG_WARN([Detected space character in the path leading up to the Coin build directory - this will probably cause random problems later. You are advised to move the Coin build directory to another location.])
  SIM_AC_CONFIGURATION_WARNING([Detected space character in the path leading up to the Coin build directory - this will probably cause random problems later. You are advised to move the Coin build directory to another location.])
fi
]) # SIM_AC_SPACE_IN_PATHS

# EOF **********************************************************************

# **************************************************************************
# SIM_AC_ERROR_MESSAGE_FILE( FILENAME )
#   Sets the error message file.  Default is $ac_aux_dir/m4/errors.txt.
#
# SIM_AC_ERROR( ERROR [, ERROR ...] )
#   Fetches the error messages from the error message file and displays
#   them on stderr. The configure process will subsequently exit.
#
# SIM_AC_WARN( ERROR [, ERROR ...] )
#   As SIM_AC_ERROR, but will not exit after displaying the message(s).
#
# SIM_AC_WITH_ERROR( WITHARG )
#   Invokes AC_MSG_ERROR in a consistent way for problems with the --with-*
#   $withval argument.
#
# SIM_AC_ENABLE_ERROR( ENABLEARG )
#   Invokes AC_MSG_ERROR in a consistent way for problems with the --enable-*
#   $enableval argument.
#
# Authors:
#   Lars J. Aas <larsa@sim.no>

AC_DEFUN([SIM_AC_ERROR_MESSAGE_FILE], [
sim_ac_message_file=$1
]) # SIM_AC_ERROR_MESSAGE_FILE

AC_DEFUN([SIM_AC_ONE_MESSAGE], [
: ${sim_ac_message_file=$ac_aux_dir/errors.txt}
if test -f $sim_ac_message_file; then
  sim_ac_message="`sed -n -e '/^!$1$/,/^!/ { /^!/ d; p; }' <$sim_ac_message_file`"
  if test x"$sim_ac_message" = x""; then
    AC_MSG_ERROR([no message named '$1' in '$sim_ac_message_file' - notify the $PACKAGE_NAME maintainer(s)])
  else
    eval "echo >&2 \"$sim_ac_message\""
  fi
else
  AC_MSG_ERROR([file '$sim_ac_message_file' not found - notify the $PACKAGE_NAME maintainer(s)])
fi
]) # SIM_AC_ONE_MESSAGE

AC_DEFUN([_SIM_AC_ERROR], [
SIM_AC_ONE_MESSAGE([$1])
ifelse([$2], , , [
echo >&2 ""
_SIM_AC_ERROR(m4_shift($@))])
]) # _SIM_AC_ERROR

AC_DEFUN([SIM_AC_ERROR], [
echo >&2 ""
_SIM_AC_ERROR($@)
echo >&2 ""
AC_MSG_ERROR([aborting])
]) # SIM_AC_ERROR

AC_DEFUN([SIM_AC_WARN], [
echo >&2 ""
_SIM_AC_ERROR($@)
echo >&2 ""
]) # SIM_AC_WARN

AC_DEFUN([SIM_AC_WITH_ERROR], [
AC_MSG_ERROR([invalid value "${withval}" for "$1" configure argument])
]) # SIM_AC_WITH_ERROR

AC_DEFUN([SIM_AC_ENABLE_ERROR], [
AC_MSG_ERROR([invalid value "${enableval}" for "$1" configure argument])
]) # SIM_AC_ENABLE_ERROR


# **************************************************************************
# configuration_summary.m4
#
# This file contains some utility macros for making it easy to have a short
# summary of the important configuration settings printed at the end of the
# configure run.
#
# Authors:
#   Lars J. Aas <larsa@sim.no>
#

# **************************************************************************
# SIM_AC_CONFIGURATION_SETTING( DESCRIPTION, SETTING )
#
# This macro registers a configuration setting to be dumped by the
# SIM_AC_CONFIGURATION_SUMMARY macro.

AC_DEFUN([SIM_AC_CONFIGURATION_SETTING],
[ifelse($#, 2, [], [m4_fatal([SIM_AC_CONFIGURATION_SETTING: takes two arguments])])
if test x"${sim_ac_configuration_settings+set}" = x"set"; then
  sim_ac_configuration_settings="$sim_ac_configuration_settings|$1:$2"
else
  sim_ac_configuration_settings="$1:$2"
fi
]) # SIM_AC_CONFIGURATION_SETTING

# **************************************************************************
# SIM_AC_CONFIGURATION_WARNING( WARNING )
#
# This macro registers a configuration warning to be dumped by the
# SIM_AC_CONFIGURATION_SUMMARY macro.

AC_DEFUN([SIM_AC_CONFIGURATION_WARNING],
[ifelse($#, 1, [], [m4_fatal([SIM_AC_CONFIGURATION_WARNING: takes one argument])])
if test x"${sim_ac_configuration_warnings+set}" = x"set"; then
  sim_ac_configuration_warnings="$sim_ac_configuration_warnings|$1"
else
  sim_ac_configuration_warnings="$1"
fi
]) # SIM_AC_CONFIGURATION_WARNING

# **************************************************************************
# SIM_AC_CONFIGURATION_SUMMARY
#
# This macro dumps the settings and warnings summary.

AC_DEFUN([SIM_AC_CONFIGURATION_SUMMARY],
[ifelse($#, 0, [], [m4_fatal([SIM_AC_CONFIGURATION_SUMMARY: takes no arguments])])
sim_ac_settings="$sim_ac_configuration_settings"
sim_ac_num_settings=`echo "$sim_ac_settings" | tr -d -c "|" | wc -c`
sim_ac_maxlength=0
while test $sim_ac_num_settings -ge 0; do
  sim_ac_description=`echo "$sim_ac_settings" | cut -d: -f1`
  sim_ac_length=`echo "$sim_ac_description" | wc -c`
  if test $sim_ac_length -gt $sim_ac_maxlength; then
    sim_ac_maxlength=`expr $sim_ac_length + 0`
  fi
  sim_ac_settings=`echo $sim_ac_settings | cut -d"|" -f2-`
  sim_ac_num_settings=`expr $sim_ac_num_settings - 1`
done

sim_ac_maxlength=`expr $sim_ac_maxlength + 3`
sim_ac_padding=`echo "                                             " |
  cut -c1-$sim_ac_maxlength`

sim_ac_num_settings=`echo "$sim_ac_configuration_settings" | tr -d -c "|" | wc -c`
echo ""
echo "$PACKAGE configuration settings:"
while test $sim_ac_num_settings -ge 0; do
  sim_ac_setting=`echo $sim_ac_configuration_settings | cut -d"|" -f1`
  sim_ac_description=`echo "$sim_ac_setting" | cut -d: -f1`
  sim_ac_status=`echo "$sim_ac_setting" | cut -d: -f2-`
  # hopefully not too many terminals are too dumb for this
  printf "$sim_ac_padding $sim_ac_status\r  $sim_ac_description:\n"
  sim_ac_configuration_settings=`echo $sim_ac_configuration_settings | cut -d"|" -f2-`
  sim_ac_num_settings=`expr $sim_ac_num_settings - 1`
done

if test x${sim_ac_configuration_warnings+set} = xset; then
sim_ac_num_warnings=`echo "$sim_ac_configuration_warnings" | tr -d -c "|" | wc -c`
echo ""
echo "$PACKAGE configuration warnings:"
while test $sim_ac_num_warnings -ge 0; do
  sim_ac_warning=`echo "$sim_ac_configuration_warnings" | cut -d"|" -f1`
  echo "  * $sim_ac_warning"
  sim_ac_configuration_warnings=`echo $sim_ac_configuration_warnings | cut -d"|" -f2-`
  sim_ac_num_warnings=`expr $sim_ac_num_warnings - 1`
done
fi
]) # SIM_AC_CONFIGURATION_SUMMARY


# Do all the work for Automake.                            -*- Autoconf -*-

# This macro actually does too much some checks are only needed if
# your package does certain things.  But this isn't really a big deal.

# Copyright (C) 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003
# Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# serial 10

AC_PREREQ([2.54])

# Autoconf 2.50 wants to disallow AM_ names.  We explicitly allow
# the ones we care about.
m4_pattern_allow([^AM_[A-Z]+FLAGS$])dnl

# AM_INIT_AUTOMAKE(PACKAGE, VERSION, [NO-DEFINE])
# AM_INIT_AUTOMAKE([OPTIONS])
# -----------------------------------------------
# The call with PACKAGE and VERSION arguments is the old style
# call (pre autoconf-2.50), which is being phased out.  PACKAGE
# and VERSION should now be passed to AC_INIT and removed from
# the call to AM_INIT_AUTOMAKE.
# We support both call styles for the transition.  After
# the next Automake release, Autoconf can make the AC_INIT
# arguments mandatory, and then we can depend on a new Autoconf
# release and drop the old call support.
AC_DEFUN([AM_INIT_AUTOMAKE],
[AC_REQUIRE([AM_SET_CURRENT_AUTOMAKE_VERSION])dnl
 AC_REQUIRE([AC_PROG_INSTALL])dnl
# test to see if srcdir already configured
if test "`cd $srcdir && pwd`" != "`pwd`" &&
   test -f $srcdir/config.status; then
  AC_MSG_ERROR([source directory already configured; run "make distclean" there first])
fi

# test whether we have cygpath
if test -z "$CYGPATH_W"; then
  if (cygpath --version) >/dev/null 2>/dev/null; then
    CYGPATH_W='cygpath -w'
  else
    CYGPATH_W=echo
  fi
fi
AC_SUBST([CYGPATH_W])

# Define the identity of the package.
dnl Distinguish between old-style and new-style calls.
m4_ifval([$2],
[m4_ifval([$3], [_AM_SET_OPTION([no-define])])dnl
 AC_SUBST([PACKAGE], [$1])dnl
 AC_SUBST([VERSION], [$2])],
[_AM_SET_OPTIONS([$1])dnl
 AC_SUBST([PACKAGE], ['AC_PACKAGE_TARNAME'])dnl
 AC_SUBST([VERSION], ['AC_PACKAGE_VERSION'])])dnl

_AM_IF_OPTION([no-define],,
[AC_DEFINE_UNQUOTED(PACKAGE, "$PACKAGE", [Name of package])
 AC_DEFINE_UNQUOTED(VERSION, "$VERSION", [Version number of package])])dnl

# Some tools Automake needs.
AC_REQUIRE([AM_SANITY_CHECK])dnl
AC_REQUIRE([AC_ARG_PROGRAM])dnl
AM_MISSING_PROG(ACLOCAL, aclocal-${am__api_version})
AM_MISSING_PROG(AUTOCONF, autoconf)
AM_MISSING_PROG(AUTOMAKE, automake-${am__api_version})
AM_MISSING_PROG(AUTOHEADER, autoheader)
AM_MISSING_PROG(MAKEINFO, makeinfo)
AM_MISSING_PROG(AMTAR, tar)
AM_PROG_INSTALL_SH
AM_PROG_INSTALL_STRIP
# We need awk for the "check" target.  The system "awk" is bad on
# some platforms.
AC_REQUIRE([AC_PROG_AWK])dnl
AC_REQUIRE([AC_PROG_MAKE_SET])dnl
AC_REQUIRE([AM_SET_LEADING_DOT])dnl

_AM_IF_OPTION([no-dependencies],,
[AC_PROVIDE_IFELSE([AC_PROG_CC],
                  [_AM_DEPENDENCIES(CC)],
                  [define([AC_PROG_CC],
                          defn([AC_PROG_CC])[_AM_DEPENDENCIES(CC)])])dnl
AC_PROVIDE_IFELSE([AC_PROG_CXX],
                  [_AM_DEPENDENCIES(CXX)],
                  [define([AC_PROG_CXX],
                          defn([AC_PROG_CXX])[_AM_DEPENDENCIES(CXX)])])dnl
])
])


# When config.status generates a header, we must update the stamp-h file.
# This file resides in the same directory as the config header
# that is generated.  The stamp files are numbered to have different names.

# Autoconf calls _AC_AM_CONFIG_HEADER_HOOK (when defined) in the
# loop where config.status creates the headers, so we can generate
# our stamp files there.
AC_DEFUN([_AC_AM_CONFIG_HEADER_HOOK],
[# Compute $1's index in $config_headers.
_am_stamp_count=1
for _am_header in $config_headers :; do
  case $_am_header in
    $1 | $1:* )
      break ;;
    * )
      _am_stamp_count=`expr $_am_stamp_count + 1` ;;
  esac
done
echo "timestamp for $1" >`AS_DIRNAME([$1])`/stamp-h[]$_am_stamp_count])

# Copyright 2002  Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA

# AM_AUTOMAKE_VERSION(VERSION)
# ----------------------------
# Automake X.Y traces this macro to ensure aclocal.m4 has been
# generated from the m4 files accompanying Automake X.Y.
AC_DEFUN([AM_AUTOMAKE_VERSION],[am__api_version="1.7"])

# AM_SET_CURRENT_AUTOMAKE_VERSION
# -------------------------------
# Call AM_AUTOMAKE_VERSION so it can be traced.
# This function is AC_REQUIREd by AC_INIT_AUTOMAKE.
AC_DEFUN([AM_SET_CURRENT_AUTOMAKE_VERSION],
	 [AM_AUTOMAKE_VERSION([1.7.5])])

# Helper functions for option handling.                    -*- Autoconf -*-

# Copyright 2001, 2002  Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# serial 2

# _AM_MANGLE_OPTION(NAME)
# -----------------------
AC_DEFUN([_AM_MANGLE_OPTION],
[[_AM_OPTION_]m4_bpatsubst($1, [[^a-zA-Z0-9_]], [_])])

# _AM_SET_OPTION(NAME)
# ------------------------------
# Set option NAME.  Presently that only means defining a flag for this option.
AC_DEFUN([_AM_SET_OPTION],
[m4_define(_AM_MANGLE_OPTION([$1]), 1)])

# _AM_SET_OPTIONS(OPTIONS)
# ----------------------------------
# OPTIONS is a space-separated list of Automake options.
AC_DEFUN([_AM_SET_OPTIONS],
[AC_FOREACH([_AM_Option], [$1], [_AM_SET_OPTION(_AM_Option)])])

# _AM_IF_OPTION(OPTION, IF-SET, [IF-NOT-SET])
# -------------------------------------------
# Execute IF-SET if OPTION is set, IF-NOT-SET otherwise.
AC_DEFUN([_AM_IF_OPTION],
[m4_ifset(_AM_MANGLE_OPTION([$1]), [$2], [$3])])

#
# Check to make sure that the build environment is sane.
#

# Copyright 1996, 1997, 2000, 2001 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# serial 3

# AM_SANITY_CHECK
# ---------------
AC_DEFUN([AM_SANITY_CHECK],
[AC_MSG_CHECKING([whether build environment is sane])
# Just in case
sleep 1
echo timestamp > conftest.file
# Do `set' in a subshell so we don't clobber the current shell's
# arguments.  Must try -L first in case configure is actually a
# symlink; some systems play weird games with the mod time of symlinks
# (eg FreeBSD returns the mod time of the symlink's containing
# directory).
if (
   set X `ls -Lt $srcdir/configure conftest.file 2> /dev/null`
   if test "$[*]" = "X"; then
      # -L didn't work.
      set X `ls -t $srcdir/configure conftest.file`
   fi
   rm -f conftest.file
   if test "$[*]" != "X $srcdir/configure conftest.file" \
      && test "$[*]" != "X conftest.file $srcdir/configure"; then

      # If neither matched, then we have a broken ls.  This can happen
      # if, for instance, CONFIG_SHELL is bash and it inherits a
      # broken ls alias from the environment.  This has actually
      # happened.  Such a system could not be considered "sane".
      AC_MSG_ERROR([ls -t appears to fail.  Make sure there is not a broken
alias in your environment])
   fi

   test "$[2]" = conftest.file
   )
then
   # Ok.
   :
else
   AC_MSG_ERROR([newly created file is older than distributed files!
Check your system clock])
fi
AC_MSG_RESULT(yes)])

#  -*- Autoconf -*-


# Copyright 1997, 1999, 2000, 2001 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# serial 3

# AM_MISSING_PROG(NAME, PROGRAM)
# ------------------------------
AC_DEFUN([AM_MISSING_PROG],
[AC_REQUIRE([AM_MISSING_HAS_RUN])
$1=${$1-"${am_missing_run}$2"}
AC_SUBST($1)])


# AM_MISSING_HAS_RUN
# ------------------
# Define MISSING if not defined so far and test if it supports --run.
# If it does, set am_missing_run to use it, otherwise, to nothing.
AC_DEFUN([AM_MISSING_HAS_RUN],
[AC_REQUIRE([AM_AUX_DIR_EXPAND])dnl
test x"${MISSING+set}" = xset || MISSING="\${SHELL} $am_aux_dir/missing"
# Use eval to expand $SHELL
if eval "$MISSING --run true"; then
  am_missing_run="$MISSING --run "
else
  am_missing_run=
  AC_MSG_WARN([`missing' script is too old or missing])
fi
])

# AM_AUX_DIR_EXPAND

# Copyright 2001 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# For projects using AC_CONFIG_AUX_DIR([foo]), Autoconf sets
# $ac_aux_dir to `$srcdir/foo'.  In other projects, it is set to
# `$srcdir', `$srcdir/..', or `$srcdir/../..'.
#
# Of course, Automake must honor this variable whenever it calls a
# tool from the auxiliary directory.  The problem is that $srcdir (and
# therefore $ac_aux_dir as well) can be either absolute or relative,
# depending on how configure is run.  This is pretty annoying, since
# it makes $ac_aux_dir quite unusable in subdirectories: in the top
# source directory, any form will work fine, but in subdirectories a
# relative path needs to be adjusted first.
#
# $ac_aux_dir/missing
#    fails when called from a subdirectory if $ac_aux_dir is relative
# $top_srcdir/$ac_aux_dir/missing
#    fails if $ac_aux_dir is absolute,
#    fails when called from a subdirectory in a VPATH build with
#          a relative $ac_aux_dir
#
# The reason of the latter failure is that $top_srcdir and $ac_aux_dir
# are both prefixed by $srcdir.  In an in-source build this is usually
# harmless because $srcdir is `.', but things will broke when you
# start a VPATH build or use an absolute $srcdir.
#
# So we could use something similar to $top_srcdir/$ac_aux_dir/missing,
# iff we strip the leading $srcdir from $ac_aux_dir.  That would be:
#   am_aux_dir='\$(top_srcdir)/'`expr "$ac_aux_dir" : "$srcdir//*\(.*\)"`
# and then we would define $MISSING as
#   MISSING="\${SHELL} $am_aux_dir/missing"
# This will work as long as MISSING is not called from configure, because
# unfortunately $(top_srcdir) has no meaning in configure.
# However there are other variables, like CC, which are often used in
# configure, and could therefore not use this "fixed" $ac_aux_dir.
#
# Another solution, used here, is to always expand $ac_aux_dir to an
# absolute PATH.  The drawback is that using absolute paths prevent a
# configured tree to be moved without reconfiguration.

# Rely on autoconf to set up CDPATH properly.
AC_PREREQ([2.50])

AC_DEFUN([AM_AUX_DIR_EXPAND], [
# expand $ac_aux_dir to an absolute path
am_aux_dir=`cd $ac_aux_dir && pwd`
])

# AM_PROG_INSTALL_SH
# ------------------
# Define $install_sh.

# Copyright 2001 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

AC_DEFUN([AM_PROG_INSTALL_SH],
[AC_REQUIRE([AM_AUX_DIR_EXPAND])dnl
install_sh=${install_sh-"$am_aux_dir/install-sh"}
AC_SUBST(install_sh)])

# AM_PROG_INSTALL_STRIP

# Copyright 2001 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# One issue with vendor `install' (even GNU) is that you can't
# specify the program used to strip binaries.  This is especially
# annoying in cross-compiling environments, where the build's strip
# is unlikely to handle the host's binaries.
# Fortunately install-sh will honor a STRIPPROG variable, so we
# always use install-sh in `make install-strip', and initialize
# STRIPPROG with the value of the STRIP variable (set by the user).
AC_DEFUN([AM_PROG_INSTALL_STRIP],
[AC_REQUIRE([AM_PROG_INSTALL_SH])dnl
# Installed binaries are usually stripped using `strip' when the user
# run `make install-strip'.  However `strip' might not be the right
# tool to use in cross-compilation environments, therefore Automake
# will honor the `STRIP' environment variable to overrule this program.
dnl Don't test for $cross_compiling = yes, because it might be `maybe'.
if test "$cross_compiling" != no; then
  AC_CHECK_TOOL([STRIP], [strip], :)
fi
INSTALL_STRIP_PROGRAM="\${SHELL} \$(install_sh) -c -s"
AC_SUBST([INSTALL_STRIP_PROGRAM])])

#                                                          -*- Autoconf -*-
# Copyright (C) 2003  Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# serial 1

# Check whether the underlying file-system supports filenames
# with a leading dot.  For instance MS-DOS doesn't.
AC_DEFUN([AM_SET_LEADING_DOT],
[rm -rf .tst 2>/dev/null
mkdir .tst 2>/dev/null
if test -d .tst; then
  am__leading_dot=.
else
  am__leading_dot=_
fi
rmdir .tst 2>/dev/null
AC_SUBST([am__leading_dot])])

# serial 5						-*- Autoconf -*-

# Copyright (C) 1999, 2000, 2001, 2002, 2003  Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.


# There are a few dirty hacks below to avoid letting `AC_PROG_CC' be
# written in clear, in which case automake, when reading aclocal.m4,
# will think it sees a *use*, and therefore will trigger all it's
# C support machinery.  Also note that it means that autoscan, seeing
# CC etc. in the Makefile, will ask for an AC_PROG_CC use...



# _AM_DEPENDENCIES(NAME)
# ----------------------
# See how the compiler implements dependency checking.
# NAME is "CC", "CXX", "GCJ", or "OBJC".
# We try a few techniques and use that to set a single cache variable.
#
# We don't AC_REQUIRE the corresponding AC_PROG_CC since the latter was
# modified to invoke _AM_DEPENDENCIES(CC); we would have a circular
# dependency, and given that the user is not expected to run this macro,
# just rely on AC_PROG_CC.
AC_DEFUN([_AM_DEPENDENCIES],
[AC_REQUIRE([AM_SET_DEPDIR])dnl
AC_REQUIRE([AM_OUTPUT_DEPENDENCY_COMMANDS])dnl
AC_REQUIRE([AM_MAKE_INCLUDE])dnl
AC_REQUIRE([AM_DEP_TRACK])dnl

ifelse([$1], CC,   [depcc="$CC"   am_compiler_list=],
       [$1], CXX,  [depcc="$CXX"  am_compiler_list=],
       [$1], OBJC, [depcc="$OBJC" am_compiler_list='gcc3 gcc'],
       [$1], GCJ,  [depcc="$GCJ"  am_compiler_list='gcc3 gcc'],
                   [depcc="$$1"   am_compiler_list=])

AC_CACHE_CHECK([dependency style of $depcc],
               [am_cv_$1_dependencies_compiler_type],
[if test -z "$AMDEP_TRUE" && test -f "$am_depcomp"; then
  # We make a subdir and do the tests there.  Otherwise we can end up
  # making bogus files that we don't know about and never remove.  For
  # instance it was reported that on HP-UX the gcc test will end up
  # making a dummy file named `D' -- because `-MD' means `put the output
  # in D'.
  mkdir conftest.dir
  # Copy depcomp to subdir because otherwise we won't find it if we're
  # using a relative directory.
  cp "$am_depcomp" conftest.dir
  cd conftest.dir

  am_cv_$1_dependencies_compiler_type=none
  if test "$am_compiler_list" = ""; then
     am_compiler_list=`sed -n ['s/^#*\([a-zA-Z0-9]*\))$/\1/p'] < ./depcomp`
  fi
  for depmode in $am_compiler_list; do
    # We need to recreate these files for each test, as the compiler may
    # overwrite some of them when testing with obscure command lines.
    # This happens at least with the AIX C compiler.
    echo '#include "conftest.h"' > conftest.c
    echo 'int i;' > conftest.h
    echo "${am__include} ${am__quote}conftest.Po${am__quote}" > confmf

    case $depmode in
    nosideeffect)
      # after this tag, mechanisms are not by side-effect, so they'll
      # only be used when explicitly requested
      if test "x$enable_dependency_tracking" = xyes; then
	continue
      else
	break
      fi
      ;;
    none) break ;;
    esac
    # We check with `-c' and `-o' for the sake of the "dashmstdout"
    # mode.  It turns out that the SunPro C++ compiler does not properly
    # handle `-M -o', and we need to detect this.
    if depmode=$depmode \
       source=conftest.c object=conftest.o \
       depfile=conftest.Po tmpdepfile=conftest.TPo \
       $SHELL ./depcomp $depcc -c -o conftest.o conftest.c \
         >/dev/null 2>conftest.err &&
       grep conftest.h conftest.Po > /dev/null 2>&1 &&
       ${MAKE-make} -s -f confmf > /dev/null 2>&1; then
      # icc doesn't choke on unknown options, it will just issue warnings
      # (even with -Werror).  So we grep stderr for any message
      # that says an option was ignored.
      if grep 'ignoring option' conftest.err >/dev/null 2>&1; then :; else
        am_cv_$1_dependencies_compiler_type=$depmode
        break
      fi
    fi
  done

  cd ..
  rm -rf conftest.dir
else
  am_cv_$1_dependencies_compiler_type=none
fi
])
AC_SUBST([$1DEPMODE], [depmode=$am_cv_$1_dependencies_compiler_type])
AM_CONDITIONAL([am__fastdep$1], [
  test "x$enable_dependency_tracking" != xno \
  && test "$am_cv_$1_dependencies_compiler_type" = gcc3])
])


# AM_SET_DEPDIR
# -------------
# Choose a directory name for dependency files.
# This macro is AC_REQUIREd in _AM_DEPENDENCIES
AC_DEFUN([AM_SET_DEPDIR],
[AC_REQUIRE([AM_SET_LEADING_DOT])dnl
AC_SUBST([DEPDIR], ["${am__leading_dot}deps"])dnl
])


# AM_DEP_TRACK
# ------------
AC_DEFUN([AM_DEP_TRACK],
[AC_ARG_ENABLE(dependency-tracking,
[  --disable-dependency-tracking Speeds up one-time builds
  --enable-dependency-tracking  Do not reject slow dependency extractors])
if test "x$enable_dependency_tracking" != xno; then
  am_depcomp="$ac_aux_dir/depcomp"
  AMDEPBACKSLASH='\'
fi
AM_CONDITIONAL([AMDEP], [test "x$enable_dependency_tracking" != xno])
AC_SUBST([AMDEPBACKSLASH])
])

# Generate code to set up dependency tracking.   -*- Autoconf -*-

# Copyright 1999, 2000, 2001, 2002 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

#serial 2

# _AM_OUTPUT_DEPENDENCY_COMMANDS
# ------------------------------
AC_DEFUN([_AM_OUTPUT_DEPENDENCY_COMMANDS],
[for mf in $CONFIG_FILES; do
  # Strip MF so we end up with the name of the file.
  mf=`echo "$mf" | sed -e 's/:.*$//'`
  # Check whether this is an Automake generated Makefile or not.
  # We used to match only the files named `Makefile.in', but
  # some people rename them; so instead we look at the file content.
  # Grep'ing the first line is not enough: some people post-process
  # each Makefile.in and add a new line on top of each file to say so.
  # So let's grep whole file.
  if grep '^#.*generated by automake' $mf > /dev/null 2>&1; then
    dirpart=`AS_DIRNAME("$mf")`
  else
    continue
  fi
  grep '^DEP_FILES *= *[[^ @%:@]]' < "$mf" > /dev/null || continue
  # Extract the definition of DEP_FILES from the Makefile without
  # running `make'.
  DEPDIR=`sed -n -e '/^DEPDIR = / s///p' < "$mf"`
  test -z "$DEPDIR" && continue
  # When using ansi2knr, U may be empty or an underscore; expand it
  U=`sed -n -e '/^U = / s///p' < "$mf"`
  test -d "$dirpart/$DEPDIR" || mkdir "$dirpart/$DEPDIR"
  # We invoke sed twice because it is the simplest approach to
  # changing $(DEPDIR) to its actual value in the expansion.
  for file in `sed -n -e '
    /^DEP_FILES = .*\\\\$/ {
      s/^DEP_FILES = //
      :loop
	s/\\\\$//
	p
	n
	/\\\\$/ b loop
      p
    }
    /^DEP_FILES = / s/^DEP_FILES = //p' < "$mf" | \
       sed -e 's/\$(DEPDIR)/'"$DEPDIR"'/g' -e 's/\$U/'"$U"'/g'`; do
    # Make sure the directory exists.
    test -f "$dirpart/$file" && continue
    fdir=`AS_DIRNAME(["$file"])`
    AS_MKDIR_P([$dirpart/$fdir])
    # echo "creating $dirpart/$file"
    echo '# dummy' > "$dirpart/$file"
  done
done
])# _AM_OUTPUT_DEPENDENCY_COMMANDS


# AM_OUTPUT_DEPENDENCY_COMMANDS
# -----------------------------
# This macro should only be invoked once -- use via AC_REQUIRE.
#
# This code is only required when automatic dependency tracking
# is enabled.  FIXME.  This creates each `.P' file that we will
# need in order to bootstrap the dependency handling code.
AC_DEFUN([AM_OUTPUT_DEPENDENCY_COMMANDS],
[AC_CONFIG_COMMANDS([depfiles],
     [test x"$AMDEP_TRUE" != x"" || _AM_OUTPUT_DEPENDENCY_COMMANDS],
     [AMDEP_TRUE="$AMDEP_TRUE" ac_aux_dir="$ac_aux_dir"])
])

# Check to see how 'make' treats includes.	-*- Autoconf -*-

# Copyright (C) 2001, 2002, 2003 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# serial 2

# AM_MAKE_INCLUDE()
# -----------------
# Check to see how make treats includes.
AC_DEFUN([AM_MAKE_INCLUDE],
[am_make=${MAKE-make}
cat > confinc << 'END'
am__doit:
	@echo done
.PHONY: am__doit
END
# If we don't find an include directive, just comment out the code.
AC_MSG_CHECKING([for style of include used by $am_make])
am__include="#"
am__quote=
_am_result=none
# First try GNU make style include.
echo "include confinc" > confmf
# We grep out `Entering directory' and `Leaving directory'
# messages which can occur if `w' ends up in MAKEFLAGS.
# In particular we don't look at `^make:' because GNU make might
# be invoked under some other name (usually "gmake"), in which
# case it prints its new name instead of `make'.
if test "`$am_make -s -f confmf 2> /dev/null | grep -v 'ing directory'`" = "done"; then
   am__include=include
   am__quote=
   _am_result=GNU
fi
# Now try BSD make style include.
if test "$am__include" = "#"; then
   echo '.include "confinc"' > confmf
   if test "`$am_make -s -f confmf 2> /dev/null`" = "done"; then
      am__include=.include
      am__quote="\""
      _am_result=BSD
   fi
fi
AC_SUBST([am__include])
AC_SUBST([am__quote])
AC_MSG_RESULT([$_am_result])
rm -f confinc confmf
])

# AM_CONDITIONAL                                              -*- Autoconf -*-

# Copyright 1997, 2000, 2001 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# serial 5

AC_PREREQ(2.52)

# AM_CONDITIONAL(NAME, SHELL-CONDITION)
# -------------------------------------
# Define a conditional.
AC_DEFUN([AM_CONDITIONAL],
[ifelse([$1], [TRUE],  [AC_FATAL([$0: invalid condition: $1])],
        [$1], [FALSE], [AC_FATAL([$0: invalid condition: $1])])dnl
AC_SUBST([$1_TRUE])
AC_SUBST([$1_FALSE])
if $2; then
  $1_TRUE=
  $1_FALSE='#'
else
  $1_TRUE='#'
  $1_FALSE=
fi
AC_CONFIG_COMMANDS_PRE(
[if test -z "${$1_TRUE}" && test -z "${$1_FALSE}"; then
  AC_MSG_ERROR([conditional "$1" was never defined.
Usually this means the macro was only invoked conditionally.])
fi])])

# Like AC_CONFIG_HEADER, but automatically create stamp file. -*- Autoconf -*-

# Copyright 1996, 1997, 2000, 2001 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

AC_PREREQ([2.52])

# serial 6

# AM_CONFIG_HEADER is obsolete.  It has been replaced by AC_CONFIG_HEADERS.
AU_DEFUN([AM_CONFIG_HEADER], [AC_CONFIG_HEADERS($@)])

# Add --enable-maintainer-mode option to configure.
# From Jim Meyering

# Copyright 1996, 1998, 2000, 2001, 2002  Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# serial 2

AC_DEFUN([AM_MAINTAINER_MODE],
[AC_MSG_CHECKING([whether to enable maintainer-specific portions of Makefiles])
  dnl maintainer-mode is disabled by default
  AC_ARG_ENABLE(maintainer-mode,
[  --enable-maintainer-mode enable make rules and dependencies not useful
                          (and sometimes confusing) to the casual installer],
      USE_MAINTAINER_MODE=$enableval,
      USE_MAINTAINER_MODE=no)
  AC_MSG_RESULT([$USE_MAINTAINER_MODE])
  AM_CONDITIONAL(MAINTAINER_MODE, [test $USE_MAINTAINER_MODE = yes])
  MAINT=$MAINTAINER_MODE_TRUE
  AC_SUBST(MAINT)dnl
]
)

AU_DEFUN([jm_MAINTAINER_MODE], [AM_MAINTAINER_MODE])

# Usage:
#   SIM_AC_DEBUGSYMBOLS
#
# Description:
#   Let the user decide if debug symbol information should be compiled
#   in. The compiled libraries/executables will use a lot less space
#   if stripped for their symbol information.
#
#   Note: this macro must be placed after either AC_PROG_CC or AC_PROG_CXX
#   in the configure.in script.
#
# Author: Morten Eriksen, <mortene@sim.no>.
#

AC_DEFUN([SIM_AC_DEBUGSYMBOLS], [
AC_ARG_ENABLE(
  [symbols],
  AC_HELP_STRING([--enable-symbols],
                 [include symbol debug information [[default=yes]]]),
  [case "${enableval}" in
    yes) enable_symbols=yes ;;
    no)  enable_symbols=no ;;
    *) AC_MSG_ERROR(bad value "${enableval}" for --enable-symbols) ;;
  esac],
  [enable_symbols=yes])

# weird seds to don't mangle options like -fno-gnu-linker and -fvolatile-global
if test x"$enable_symbols" = x"no"; then
  CFLAGS="`echo $CFLAGS | sed 's/ -g / /g' | sed 's/^-g / /g' | sed 's/ -g$/ /g' | sed 's/^-g$/ /'`"
  CXXFLAGS="`echo $CXXFLAGS | sed 's/ -g / /g' | sed 's/^-g / /g' | sed 's/ -g$/ /g' | sed 's/^-g$/ /'`"
fi
]) # SIM_AC_DEBUGSYMBOLS


# Usage:
#   SIM_AC_RTTI_SUPPORT
#
# Description:
#   Let the user decide if RTTI should be compiled in. The compiled
#   libraries/executables will use a lot less space if they don't
#   contain RTTI.
#
#   Note: this macro must be placed after AC_PROG_CXX in the
#   configure.in script.
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_RTTI_SUPPORT], [
AC_PREREQ([2.13])
AC_ARG_ENABLE(
  [rtti],
  AC_HELP_STRING([--enable-rtti], [(g++ only) compile with RTTI [[default=yes]]]),
  [case "${enableval}" in
    yes) enable_rtti=yes ;;
    no)  enable_rtti=no ;;
    *) AC_MSG_ERROR(bad value "${enableval}" for --enable-rtti) ;;
  esac],
  [enable_rtti=yes])

if test x"$enable_rtti" = x"no"; then
  if test x"$GXX" = x"yes"; then
    CXXFLAGS="$CXXFLAGS -fno-rtti"
  else
    AC_MSG_WARN([--enable-rtti only has effect when using GNU g++])
  fi
fi
])

# Usage:
#   SIM_AC_EXCEPTION_HANDLING
#
# Description:
#   Let the user decide if C++ exception handling should be compiled
#   in. With older compilers the libraries/executables will use a lot
#   less space if they have exception handling support disabled, on
#   modern compilers the difference is negligible.
#
#   Note: this macro must be placed after AC_PROG_CXX in the
#   configure.in script.
#
#   Author: Morten Eriksen, <mortene@sim.no>.
#
# TODO:
#   * [mortene:19991114] make this work with compilers other than gcc/g++
#

AC_DEFUN([SIM_AC_EXCEPTION_HANDLING], [
AC_PREREQ([2.13])
AC_ARG_ENABLE(
  [exceptions],
  AC_HELP_STRING([--enable-exceptions],
                 [(g++ only) compile with exceptions [[default=yes]]]),
  [case "${enableval}" in
    yes) enable_exceptions=yes ;;
    no)  enable_exceptions=no ;;
    *) AC_MSG_ERROR(bad value "${enableval}" for --enable-exceptions) ;;
  esac],
  [enable_exceptions=yes])

if test x"$enable_exceptions" = x"no"; then
  if test "x$GXX" = "xyes"; then
    unset _exception_flag
    dnl This is for GCC >= 2.8
    SIM_AC_CXX_COMPILER_OPTION([-fno-exceptions], [_exception_flag=-fno-exceptions])
    if test x"${_exception_flag+set}" != x"set"; then
      dnl For GCC versions < 2.8
      SIM_AC_CXX_COMPILER_OPTION([-fno-handle-exceptions],
                                 [_exception_flag=-fno-handle-exceptions])
    fi
    if test x"${_exception_flag+set}" != x"set"; then
      AC_MSG_WARN([couldn't find a valid option for avoiding exception handling])
    else
      CXXFLAGS="$CXXFLAGS $_exception_flag"
    fi
  fi
else
  if $BUILD_WITH_MSVC; then
    SIM_AC_CXX_COMPILER_OPTION([/EHsc], [CXXFLAGS="$CXXFLAGS /EHsc"])
  else
    if test x"$GXX" != x"yes"; then
      AC_MSG_WARN([--enable-exceptions only has effect when using GNU g++])
    fi
  fi
fi
])


#   Use this file to store miscellaneous macros related to checking
#   compiler features.

# Usage:
#   SIM_AC_CC_COMPILER_OPTION(OPTION-TO-TEST, ACTION-IF-TRUE [, ACTION-IF-FALSE])
#   SIM_AC_CXX_COMPILER_OPTION(OPTION-TO-TEST, ACTION-IF-TRUE [, ACTION-IF-FALSE])
#
# Description:
#
#   Check whether the current C or C++ compiler can handle a
#   particular command-line option.
#
#
# Author: Morten Eriksen, <mortene@sim.no>.
#
#   * [mortene:19991218] improve macros by catching and analyzing
#     stderr (at least to see if there was any output there)?
#

AC_DEFUN([SIM_AC_COMPILER_OPTION], [
sim_ac_save_cppflags=$CPPFLAGS
CPPFLAGS="$CPPFLAGS $1"
AC_TRY_COMPILE([], [], [sim_ac_accept_result=yes], [sim_ac_accept_result=no])
AC_MSG_RESULT([$sim_ac_accept_result])
CPPFLAGS=$sim_ac_save_cppflags
# This need to go last, in case CPPFLAGS is modified in arg 2 or arg 3.
if test $sim_ac_accept_result = yes; then
  ifelse([$2], , :, [$2])
else
  ifelse([$3], , :, [$3])
fi
])

AC_DEFUN([SIM_AC_COMPILER_BEHAVIOR_OPTION_QUIET], [
sim_ac_save_cppflags=$CPPFLAGS
CPPFLAGS="$CPPFLAGS $1"
AC_TRY_COMPILE([], [$2], [sim_ac_accept_result=yes], [sim_ac_accept_result=no])
CPPFLAGS=$sim_ac_save_cppflags
# This need to go last, in case CPPFLAGS is modified in arg 3 or arg 4.
if test $sim_ac_accept_result = yes; then
  ifelse([$3], , :, [$3])
else
  ifelse([$4], , :, [$4])
fi
])


AC_DEFUN([SIM_AC_CC_COMPILER_OPTION], [
AC_LANG_SAVE
AC_LANG(C)
AC_MSG_CHECKING([whether $CC accepts $1])
SIM_AC_COMPILER_OPTION([$1], [$2], [$3])
AC_LANG_RESTORE
])

AC_DEFUN([SIM_AC_CC_COMPILER_BEHAVIOR_OPTION_QUIET], [
AC_LANG_SAVE
AC_LANG(C)
SIM_AC_COMPILER_BEHAVIOR_OPTION_QUIET([$1], [$2], [$3], [$4])
AC_LANG_RESTORE
])

AC_DEFUN([SIM_AC_CXX_COMPILER_OPTION], [
AC_LANG_SAVE
AC_LANG(C++)
AC_MSG_CHECKING([whether $CXX accepts $1])
SIM_AC_COMPILER_OPTION([$1], [$2], [$3])
AC_LANG_RESTORE
])

AC_DEFUN([SIM_AC_CXX_COMPILER_BEHAVIOR_OPTION_QUIET], [
AC_LANG_SAVE
AC_LANG(C++)
SIM_AC_COMPILER_BEHAVIOR_OPTION_QUIET([$1], [$2], [$3], [$4])
AC_LANG_RESTORE
])

# Usage:
#   SIM_AC_PROFILING_SUPPORT
#
# Description:
#   Let the user decide if profiling code should be compiled
#   in. The compiled libraries/executables will use a lot less space
#   if they don't contain profiling code information, and they will also
#   execute faster.
#
#   Note: this macro must be placed after either AC_PROG_CC or AC_PROG_CXX
#   in the configure.in script.
#
# Author: Morten Eriksen, <mortene@sim.no>.
#
# TODO:
#   * [mortene:19991114] make this work with compilers other than gcc/g++
#

AC_DEFUN([SIM_AC_PROFILING_SUPPORT], [
AC_PREREQ([2.13])
AC_ARG_ENABLE(
  [profile],
  AC_HELP_STRING([--enable-profile],
                 [(GCC only) turn on inclusion of profiling code [[default=no]]]),
  [case "${enableval}" in
    yes) enable_profile=yes ;;
    no)  enable_profile=no ;;
    *) AC_MSG_ERROR(bad value "${enableval}" for --enable-profile) ;;
  esac],
  [enable_profile=no])

if test x"$enable_profile" = x"yes"; then
  if test x"$GXX" = x"yes" || test x"$GCC" = x"yes"; then
    CFLAGS="$CFLAGS -pg"
    CXXFLAGS="$CXXFLAGS -pg"
    LDFLAGS="$LDFLAGS -pg"
  else
    AC_MSG_WARN([--enable-profile only has effect when using GNU gcc or g++])
  fi
fi
])


# Usage:
#   SIM_AC_COMPILER_WARNINGS
#
# Description:
#   Take care of making a sensible selection of warning messages
#   to turn on or off.
#
#   Note: this macro must be placed after either AC_PROG_CC or AC_PROG_CXX
#   in the configure.in script.
#
# Author: Morten Eriksen, <mortene@sim.no>.
#
# TODO:
#   * [mortene:19991114] find out how to get GCC's
#     -Werror-implicit-function-declaration option to work as expected
#
#   * [larsa:20010504] rename to SIM_AC_COMPILER_WARNINGS and clean up
#     the macro

AC_DEFUN([SIM_AC_COMPILER_WARNINGS], [
AC_ARG_ENABLE(
  [warnings],
  AC_HELP_STRING([--enable-warnings],
                 [turn on warnings when compiling [[default=yes]]]),
  [case "${enableval}" in
    yes) enable_warnings=yes ;;
    no)  enable_warnings=no ;;
    *) AC_MSG_ERROR([bad value "$enableval" for --enable-warnings]) ;;
  esac],
  [enable_warnings=yes])

if test x"$enable_warnings" = x"yes"; then

  for sim_ac_try_cc_warning_option in \
    "-W" "-Wall" "-Wno-unused" "-Wno-multichar"; do

    if test x"$GCC" = x"yes"; then
      SIM_AC_CC_COMPILER_OPTION([$sim_ac_try_cc_warning_option],
                                [CFLAGS="$CFLAGS $sim_ac_try_cc_warning_option"])
    fi
  done

  for sim_ac_try_cxx_warning_option in \
    "-W" "-Wall" "-Wno-unused" "-Wno-multichar" "-Woverloaded-virtual"; do
    if test x"$GXX" = x"yes"; then
      SIM_AC_CXX_COMPILER_OPTION([$sim_ac_try_cxx_warning_option],
                                 [CXXFLAGS="$CXXFLAGS $sim_ac_try_cxx_warning_option"])
    fi

  done

  case $host in
  *-*-irix*)
    ### Turn on all warnings ######################################
    # we try to catch settings like CC="CC -n32" too, even though the
    # -n32 option belongs to C[XX]FLAGS
    case $CC in
    cc | "cc "* | CC | "CC "* )
      SIM_AC_CC_COMPILER_OPTION([-fullwarn], [CFLAGS="$CFLAGS -fullwarn"])
      ;;
    esac
    case $CXX in
    CC | "CC "* )
      SIM_AC_CXX_COMPILER_OPTION([-fullwarn], [CXXFLAGS="$CXXFLAGS -fullwarn"])
      ;;
    esac

    ### Turn off specific (bogus) warnings ########################

    ### SGI MipsPro v?.?? (our compiler on IRIX 6.2) ##############
    ##
    ## 3115: ``type qualifiers are meaningless in this declaration''.
    ## 3262: unused variables.
    ##
    ### SGI MipsPro v7.30 #########################################
    ##
    ## 1174: "The function was declared but never referenced."
    ## 1209: "The controlling expression is constant." (kill warning on
    ##       if (0), assert(FALSE), etc).
    ## 1375: Non-virtual destructors in base classes.
    ## 3201: Unused argument to a function.
    ## 1110: "Statement is not reachable" (the Lex/Flex generated code in
    ##       Coin/src/engines has lots of shitty code which needs this).
    ## 1506: Implicit conversion from "unsigned long" to "long".
    ##       SbTime.h in SGI/TGS Inventor does this, so we need to kill
    ##       this warning to avoid all the output clutter when compiling
    ##       the SoQt, SoGtk or SoXt libraries on IRIX with SGI MIPSPro CC.
    ## 1169: External/internal linkage conflicts with a previous declaration.
    ##       We get this for the "friend operators" in SbString.h

    sim_ac_bogus_warnings="-woff 3115,3262,1174,1209,1375,3201,1110,1506,1169,1210"

    case $CC in
    cc | "cc "* | CC | "CC "* )
      SIM_AC_CC_COMPILER_OPTION([$sim_ac_bogus_warnings],
                                [CFLAGS="$CFLAGS $sim_ac_bogus_warnings"])
    esac
    case $CXX in
    CC | "CC "* )
      SIM_AC_CXX_COMPILER_OPTION([$sim_ac_bogus_warnings],
                                 [CXXFLAGS="$CXXFLAGS $sim_ac_bogus_warnings"])
      ;;
    esac
  ;;
  esac
fi
])

# **************************************************************************
#
# SIM_AC_DETECT_COMMON_COMPILER_FLAGS
#
# Sets sim_ac_compiler_CFLAGS and sim_ac_compiler_CXXFLAGS
#

AC_DEFUN([SIM_AC_DETECT_COMMON_COMPILER_FLAGS], [

AC_REQUIRE([SIM_AC_CHECK_PROJECT_BETA_STATUS_IFELSE])
AC_REQUIRE([SIM_AC_CHECK_SIMIAN_IFELSE])

sim_ac_simian=false

SIM_AC_COMPILE_DEBUG([
  if test x"$GCC" = x"yes"; then
    # no auto string.h-functions
    SIM_AC_CC_COMPILER_OPTION([-fno-builtin], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS -fno-builtin"])
    SIM_AC_CXX_COMPILER_OPTION([-fno-builtin], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS -fno-builtin"])

    # disallow non-standard scoping of for()-variables
    SIM_AC_CXX_COMPILER_OPTION([-fno-for-scoping], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS -fno-for-scope"])

    SIM_AC_CC_COMPILER_OPTION([-finline-functions], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS -finline-functions"])
    SIM_AC_CXX_COMPILER_OPTION([-finline-functions], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS -finline-functions"])

    if $sim_ac_simian; then
      if $sim_ac_source_release; then :; else
      # break build on warnings, except for in official source code releases
        if test x"$enable_werror" = x"no"; then :; else
          SIM_AC_CC_COMPILER_OPTION([-Werror], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS -Werror"])
          SIM_AC_CXX_COMPILER_OPTION([-Werror], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS -Werror"])
        fi
      fi
    fi

    # warn on missing return-value
    SIM_AC_CC_COMPILER_OPTION([-Wreturn-type], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS -Wreturn-type"])
    SIM_AC_CXX_COMPILER_OPTION([-Wreturn-type], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS -Wreturn-type"])

    SIM_AC_CC_COMPILER_OPTION([-Wchar-subscripts], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS -Wchar-subscripts"])
    SIM_AC_CXX_COMPILER_OPTION([-Wchar-subscripts], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS -Wchar-subscripts"])

    SIM_AC_CC_COMPILER_OPTION([-Wparentheses], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS -Wparentheses"])
    SIM_AC_CXX_COMPILER_OPTION([-Wparentheses], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS -Wparentheses"])

  else
    case $CXX in
    *wrapmsvc* )
      if $sim_ac_simian; then
        if $sim_ac_source_release; then :; else
          # break build on warnings, except for in official source code releases
          SIM_AC_CC_COMPILER_OPTION([/WX], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS /WX"])
          SIM_AC_CXX_COMPILER_OPTION([/WX], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS /WX"])
        fi
      fi

      # warning level 3
      SIM_AC_CC_COMPILER_OPTION([/W3], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS /W3"])
      SIM_AC_CXX_COMPILER_OPTION([/W3], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS /W3"])
      
      ;;
    esac
  fi
])

ifelse($1, [], :, $1)

])

AC_DEFUN([SIM_AC_COMPILER_NOBOOL], [
sim_ac_nobool_CXXFLAGS=
sim_ac_have_nobool=false
AC_MSG_CHECKING([whether $CXX accepts /noBool])
if $BUILD_WITH_MSVC && test x$sim_ac_msvc_version = x6; then
  SIM_AC_CXX_COMPILER_BEHAVIOR_OPTION_QUIET(
    [/noBool],
    [int temp],
    [SIM_AC_CXX_COMPILER_BEHAVIOR_OPTION_QUIET(
      [/noBool],
      [bool res = true],
      [],
      [sim_ac_have_nobool=true])])
fi

if $sim_ac_have_nobool; then
  sim_ac_nobool_CXXFLAGS="/noBool"
  AC_MSG_RESULT([yes])
  ifelse([$1], , :, [$1])
else
  AC_MSG_RESULT([no])
  ifelse([$2], , :, [$2])
fi
])


#
# SIM_AC_CHECK_PROJECT_BETA_STATUS_IFELSE( IF-BETA, IF-BONA-FIDE )
#
# Sets sim_ac_source_release to true or false
#

AC_DEFUN([SIM_AC_CHECK_PROJECT_BETA_STATUS_IFELSE], [
AC_MSG_CHECKING([for project release status])
case $VERSION in
*[[a-z]]* )
  AC_MSG_RESULT([beta / inbetween releases])
  sim_ac_source_release=false
  ifelse($1, [], :, $1)
  ;;
* )
  AC_MSG_RESULT([release version])
  sim_ac_source_release=true
  ifelse($2, [], :, $2)
  ;;
esac
])


#
# SIM_AC_CHECK_SIMIAN_IFELSE( IF-SIMIAN, IF-NOT-SIMIAN )
#
# Sets $sim_ac_simian to true or false
#

AC_DEFUN([SIM_AC_CHECK_SIMIAN_IFELSE], [
AC_MSG_CHECKING([if user is simian])
case `hostname -d 2>/dev/null || domainname 2>/dev/null || hostname` in
*.sim.no | sim.no )
  sim_ac_simian=true
  ;;
* )
  if grep -ls "domain.*sim\\.no" /etc/resolv.conf >/dev/null; then
    sim_ac_simian=true
    :
  else
    sim_ac_simian=false
    :
  fi
  ;;
esac

if $sim_ac_simian; then
  AC_MSG_RESULT([probably])
  ifelse($1, [], :, $1)
else
  AC_MSG_RESULT([probably not])
  ifelse($2, [], :, $2)
fi])


# Usage:
#   SIM_AC_COMPILE_DEBUG([ACTION-IF-DEBUG[, ACTION-IF-NOT-DEBUG]])
#
# Description:
#   Let the user decide if compilation should be done in "debug mode".
#   If compilation is not done in debug mode, all assert()'s in the code
#   will be disabled.
#
#   Also sets enable_debug variable to either "yes" or "no", so the
#   configure.in writer can add package-specific actions. Default is "yes".
#   This was also extended to enable the developer to set up the two first
#   macro arguments following the well-known ACTION-IF / ACTION-IF-NOT
#   concept.
#
# Authors:
#   Morten Eriksen, <mortene@sim.no>
#   Lars J. Aas, <larsa@sim.no>
#

AC_DEFUN([SIM_AC_COMPILE_DEBUG], [
AC_REQUIRE([SIM_AC_CHECK_SIMIAN_IFELSE])

AC_ARG_ENABLE(
  [debug],
  AC_HELP_STRING([--enable-debug], [compile in debug mode [[default=yes]]]),
  [case "${enableval}" in
    yes) enable_debug=true ;;
    no)  enable_debug=false ;;
    true | false) enable_debug=${enableval} ;;
    *) AC_MSG_ERROR(bad value "${enableval}" for --enable-debug) ;;
  esac],
  [enable_debug=true])

if $enable_debug; then
  DSUFFIX=d
  if $sim_ac_simian; then
    case $CXX in
    *wrapmsvc* )
      # uninitialized checks
      if test ${sim_ac_msc_major_version-0} -gt 6; then
        SIM_AC_CC_COMPILER_OPTION([/RTCu], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS /RTCu"])
        SIM_AC_CXX_COMPILER_OPTION([/RTCu], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS /RTCu"])
        # stack frame checks
        SIM_AC_CC_COMPILER_OPTION([/RTCs], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS /RTCs"])
        SIM_AC_CXX_COMPILER_OPTION([/RTCs], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS /RTCs"])
      fi
      ;;
    esac
  fi

  ifelse([$1], , :, [$1])
else
  DSUFFIX=
  CPPFLAGS="$CPPFLAGS -DNDEBUG"
  ifelse([$2], , :, [$2])
fi
AC_SUBST(DSUFFIX)
])

# Usage:
#   SIM_AC_COMPILER_OPTIMIZATION
#
# Description:
#   Let the user decide if optimization should be attempted turned off
#   by stripping off an "-O[0-9]" option.
#
#   Note: this macro must be placed after either AC_PROG_CC or AC_PROG_CXX
#   in the configure.in script.
#
# FIXME: this is pretty much just a dirty hack. Unfortunately, this
# seems to be the best we can do without fixing Autoconf to behave
# properly wrt setting optimization options. 20011021 mortene.
#
# Author: Morten Eriksen, <mortene@sim.no>.
#

AC_DEFUN([SIM_AC_COMPILER_OPTIMIZATION], [
AC_ARG_ENABLE(
  [optimization],
  AC_HELP_STRING([--enable-optimization],
                 [allow compilers to make optimized code [[default=yes]]]),
  [case "${enableval}" in
    yes) sim_ac_enable_optimization=true ;;
    no)  sim_ac_enable_optimization=false ;;
    *) AC_MSG_ERROR(bad value "${enableval}" for --enable-optimization) ;;
  esac],
  [sim_ac_enable_optimization=true])

if $sim_ac_enable_optimization; then
  case $CXX in
  *wrapmsvc* )
    CFLAGS="/Ox $CFLAGS"
    CXXFLAGS="/Ox $CXXFLAGS"
    ;;
  esac
  :
else
  CFLAGS="`echo $CFLAGS | sed 's/-O[[0-9]]*[[ ]]*//'`"
  CXXFLAGS="`echo $CXXFLAGS | sed 's/-O[[0-9]]*[[ ]]*//'`"
fi
])

# Usage:
#   SIM_AC_CHECK_MATHLIB([ACTION-IF-OK[, ACTION-IF-NOT-OK]])
#
# Description:
#   Check if linker needs to explicitly link with the library with
#   math functions. Sets environment variable $sim_ac_libm to the
#   necessary linklibrary, plus includes this library in the LIBS
#   env variable.
#
# Notes:
#   There is a macro AC_CHECK_LIBM in the libtool distribution, but it
#   does at least not work with SGI MIPSpro CC v7.30.
#
# Authors:
#   Lars Jørgen Aas, <larsa@sim.no>
#   Morten Eriksen, <mortene@sim.no>
#   Rupert Kittinger, <kittinger@mechanik.tu-graz.ac.at>
#

AC_DEFUN([SIM_AC_CHECK_MATHLIB],
[sim_ac_libm=

# It is on purpose that we avoid caching, as this macro could be
# run twice from the same configure-script: once for the C compiler,
# once for the C++ compiler.

AC_MSG_CHECKING(for math functions library)

sim_ac_mathlib_test=UNDEFINED
# BeOS and MSWin platforms has implicit math library linking,
# and ncr-sysv4.3 might use -lmw (according to AC_CHECK_LIBM in
# libtool.m4).
for sim_ac_math_chk in "" -lm -lmw; do
  if test x"$sim_ac_mathlib_test" = xUNDEFINED; then
    sim_ac_store_libs=$LIBS
    LIBS="$sim_ac_store_libs $sim_ac_math_chk"
    SIM_AC_MATHLIB_READY_IFELSE([sim_ac_mathlib_test=$sim_ac_math_chk])
    LIBS=$sim_ac_store_libs
  fi
done

if test x"$sim_ac_mathlib_test" != xUNDEFINED; then
  if test x"$sim_ac_mathlib_test" != x""; then
    sim_ac_libm=$sim_ac_mathlib_test
    LIBS="$sim_ac_libm $LIBS"
    AC_MSG_RESULT($sim_ac_mathlib_test)
  else
    AC_MSG_RESULT([no explicit linkage necessary])
  fi
  $1
else
  AC_MSG_RESULT([failed!])
  $2
fi
])# SIM_AC_CHECK_MATHLIB

# **************************************************************************
# SIM_AC_MATHLIB_READY_IFELSE( [ACTION-IF-TRUE], [ACTION-IF-FALSE] )

AC_DEFUN([SIM_AC_MATHLIB_READY_IFELSE],
[
# It is on purpose that we avoid caching, as this macro could be
# run twice from the same configure-script: once for the C compiler,
# once for the C++ compiler.

AC_TRY_LINK(
    [#include <math.h>
    #include <stdlib.h>
    #include <stdio.h>],
    [char s[16];
    /*
    SGI IRIX MIPSpro compilers may "fold" math
    functions with constant arguments already
    at compile time.

    It is also theoretically possible to do this
    for atof(), so to be _absolutely_ sure the
    math functions aren't replaced by constants at
    compile time, we get the arguments from a guaranteed
    non-constant source (stdin).
    */
    printf("> %g\n",fmod(atof(fgets(s,15,stdin)), atof(fgets(s,15,stdin))));
    printf("> %g\n",pow(atof(fgets(s,15,stdin)), atof(fgets(s,15,stdin))));
    printf("> %g\n",exp(atof(fgets(s,15,stdin))));
    printf("> %g\n",sin(atof(fgets(s,15,stdin))))],
    [sim_ac_mathlib_ready=true],
    [sim_ac_mathlib_ready=false])

if ${sim_ac_mathlib_ready}; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_MATHLIB_READY_IFELSE()


# SIM_AC_CHECK_DL([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
# ----------------------------------------------------------
#
#  Try to find the dynamic link loader library. If it is found, these
#  shell variables are set:
#
#    $sim_ac_dl_cppflags (extra flags the compiler needs for dl lib)
#    $sim_ac_dl_ldflags  (extra flags the linker needs for dl lib)
#    $sim_ac_dl_libs     (link libraries the linker needs for dl lib)
#
#  The CPPFLAGS, LDFLAGS and LIBS flags will also be modified accordingly.
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_CHECK_DL], [
AC_ARG_WITH(
  [dl],
  [AC_HELP_STRING(
    [--with-dl=DIR],
    [include support for the dynamic link loader library [default=yes]])],
  [],
  [with_dl=yes])

if test x"$with_dl" != xno; then
  if test x"$with_dl" != xyes; then
    sim_ac_dl_cppflags="-I${with_dl}/include"
    sim_ac_dl_ldflags="-L${with_dl}/lib"
  fi

  sim_ac_save_cppflags=$CPPFLAGS
  sim_ac_save_ldflags=$LDFLAGS
  sim_ac_save_libs=$LIBS

  CPPFLAGS="$CPPFLAGS $sim_ac_dl_cppflags"
  LDFLAGS="$LDFLAGS $sim_ac_dl_ldflags"

  # Use SIM_AC_CHECK_HEADERS instead of .._HEADER to get the
  # HAVE_DLFCN_H symbol set up in config.h automatically.
  AC_CHECK_HEADERS([dlfcn.h])

  sim_ac_dl_avail=false

  AC_MSG_CHECKING([for the dl library])
  # At least under FreeBSD, dlopen() et al is part of the C library.
  # On HP-UX, dlopen() might reside in a library "svld" instead of "dl".
  for sim_ac_dl_libcheck in "" "-ldl" "-lsvld"; do
    if $sim_ac_dl_avail; then :; else
      LIBS="$sim_ac_dl_libcheck $sim_ac_save_libs"
      AC_TRY_LINK([
#ifdef HAVE_DLFCN_H
#include <dlfcn.h>
#endif /* HAVE_DLFCN_H */
],
                  [(void)dlopen(0L, 0); (void)dlsym(0L, "Gunners!"); (void)dlclose(0L);],
                  [sim_ac_dl_avail=true
                   sim_ac_dl_libs="$sim_ac_dl_libcheck"
                  ])
    fi
  done

  if $sim_ac_dl_avail; then
    if test x"$sim_ac_dl_libs" = x""; then
      AC_MSG_RESULT(yes)
    else
      AC_MSG_RESULT($sim_ac_dl_cppflags $sim_ac_dl_ldflags $sim_ac_dl_libs)
    fi
  else
    AC_MSG_RESULT(not available)
  fi

  if $sim_ac_dl_avail; then
    ifelse([$1], , :, [$1])
  else
    CPPFLAGS=$sim_ac_save_cppflags
    LDFLAGS=$sim_ac_save_ldflags
    LIBS=$sim_ac_save_libs
    ifelse([$2], , :, [$2])
  fi
fi
])

# SIM_AC_CHECK_LOADLIBRARY([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
# -------------------------------------------------------------------
#
#  Try to use the Win32 dynamic link loader methods LoadLibrary(),
#  GetProcAddress() and FreeLibrary().
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_CHECK_LOADLIBRARY], [
AC_ARG_ENABLE(
  [loadlibrary],
  [AC_HELP_STRING([--disable-loadlibrary], [don't use run-time link bindings under Win32])],
  [case $enableval in
  yes | true ) sim_ac_win32_loadlibrary=true ;;
  *) sim_ac_win32_loadlibrary=false ;;
  esac],
  [sim_ac_win32_loadlibrary=true])

if $sim_ac_win32_loadlibrary; then
  # Use SIM_AC_CHECK_HEADERS instead of .._HEADER to get the
  # HAVE_DLFCN_H symbol set up in config.h automatically.
  AC_CHECK_HEADERS([windows.h])

  AC_CACHE_CHECK([whether the Win32 LoadLibrary() method is available],
    sim_cv_lib_loadlibrary_avail,
    [AC_TRY_LINK([
#ifdef HAVE_WINDOWS_H
#include <windows.h>
#endif /* HAVE_WINDOWS_H */
],
                 [(void)LoadLibrary(0L); (void)GetProcAddress(0L, 0L); (void)FreeLibrary(0L); ],
                 [sim_cv_lib_loadlibrary_avail=yes],
                 [sim_cv_lib_loadlibrary_avail=no])])

  if test x"$sim_cv_lib_loadlibrary_avail" = xyes; then
    ifelse([$1], , :, [$1])
  else
    ifelse([$2], , :, [$2])
  fi
fi
])

# SIM_AC_CHECK_DLD([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
# ----------------------------------------------------------
#
#  Try to find the dynamic link loader library available on HP-UX 10.
#  If it is found, this shell variable is set:
#
#    $sim_ac_dld_libs     (link libraries the linker needs for dld lib)
#
#  The $LIBS var will also be modified accordingly.
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_CHECK_DLD], [
  sim_ac_dld_libs="-ldld"

  sim_ac_save_libs=$LIBS
  LIBS="$sim_ac_dld_libs $LIBS"

  AC_CACHE_CHECK([whether the DLD shared library loader is available],
    sim_cv_lib_dld_avail,
    [AC_TRY_LINK([#include <dl.h>],
                 [(void)shl_load("allyourbase", 0, 0L); (void)shl_findsym(0L, "arebelongtous", 0, 0L); (void)shl_unload((shl_t)0);],
                 [sim_cv_lib_dld_avail=yes],
                 [sim_cv_lib_dld_avail=no])])

  if test x"$sim_cv_lib_dld_avail" = xyes; then
    ifelse([$1], , :, [$1])
  else
    LIBS=$sim_ac_save_libs
    ifelse([$2], , :, [$2])
  fi
])


# SIM_AC_CHECK_DYLD([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
# -------------------------------------------------------------------
#
#  Try to use the Mac OS X dynamik link editor method
#  NSLookupAndBindSymbol()
#
# Author: Karin Kosina, <kyrah@sim.no>

AC_DEFUN([SIM_AC_CHECK_DYLD], [
AC_ARG_ENABLE(
  [dyld],
  [AC_HELP_STRING([--disable-dyld],
                  [don't use run-time link bindings under Mac OS X])],
  [case $enableval in
  yes | true ) sim_ac_dyld=true ;;
  *) sim_ac_dyld=false ;;
  esac],
  [sim_ac_dyld=true])

if $sim_ac_dyld; then

  AC_CHECK_HEADERS([mach-o/dyld.h])

  AC_CACHE_CHECK([whether we can use Mach-O dyld],
    sim_cv_dyld_avail,
    [AC_TRY_LINK([
#ifdef HAVE_MACH_O_DYLD_H
#include <mach-o/dyld.h>
#endif /* HAVE_MACH_O_DYLD_H */
],
                 [(void)NSLookupAndBindSymbol("foo");],
                 [sim_cv_dyld_avail=yes],
                 [sim_cv_dyld_avail=no])])

  if test x"$sim_cv_dyld_avail" = xyes; then
    ifelse([$1], , :, [$1])
  else
    ifelse([$2], , :, [$2])
  fi
fi
])

# Usage:
#  SIM_AC_CHECK_X11([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to find the X11 development system. If it is found, these
#  shell variables are set:
#
#    $sim_ac_x11_cppflags (extra flags the compiler needs for X11)
#    $sim_ac_x11_ldflags  (extra flags the linker needs for X11)
#    $sim_ac_x11_libs     (link libraries the linker needs for X11)
#
#  The CPPFLAGS, LDFLAGS and LIBS flags will also be modified accordingly.
#  In addition, the variable $sim_ac_x11_avail is set to "yes" if
#  the X11 development system is found.
#
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_CHECK_X11], [
AC_REQUIRE([AC_PATH_XTRA])

sim_ac_enable_darwin_x11=false

case $host_os in
  darwin* )
    AC_ARG_ENABLE([darwin-x11],
      AC_HELP_STRING([--enable-darwin-x11],
                     [enable X11 on Darwin [[default=--disable-darwin-x11]]]),
      [case "${enableval}" in
        yes | true) sim_ac_enable_darwin_x11=true ;;
        no | false) sim_ac_enable_darwin_x11=false; no_x=yes ;;
        *) SIM_AC_ENABLE_ERROR([--enable-darwin-x11]) ;;
      esac],
      [sim_ac_enable_darwin_x11=false; no_x=yes])
  ;;
esac

sim_ac_x11_avail=no

if test x"$no_x" != xyes; then

  #  *** DEBUG ***
  #  Keep this around, as it can be handy when testing on new systems.
  # echo "X_CFLAGS: $X_CFLAGS"
  # echo "X_PRE_LIBS: $X_PRE_LIBS"
  # echo "X_LIBS: $X_LIBS"
  # echo "X_EXTRA_LIBS: $X_EXTRA_LIBS"
  # echo
  # exit 0

  sim_ac_x11_cppflags="$X_CFLAGS"
  sim_ac_x11_ldflags="$X_LIBS"
  sim_ac_x11_libs="$X_PRE_LIBS -lX11 $X_EXTRA_LIBS"

  sim_ac_save_cppflags=$CPPFLAGS
  sim_ac_save_ldflags=$LDFLAGS
  sim_ac_save_libs=$LIBS

  CPPFLAGS="$CPPFLAGS $sim_ac_x11_cppflags"
  LDFLAGS="$LDFLAGS $sim_ac_x11_ldflags"
  LIBS="$sim_ac_x11_libs $LIBS"

  AC_CACHE_CHECK(
    [whether we can link against X11],
    sim_cv_lib_x11_avail,
    [AC_TRY_LINK([#include <X11/Xlib.h>],
                 [(void)XOpenDisplay(0L);],
                 [sim_cv_lib_x11_avail=yes],
                 [sim_cv_lib_x11_avail=no])])

  if test x"$sim_cv_lib_x11_avail" = x"yes"; then
    sim_ac_x11_avail=yes
    $1
  else
    CPPFLAGS=$sim_ac_save_cppflags
    LDFLAGS=$sim_ac_save_ldflags
    LIBS=$sim_ac_save_libs
    $2
  fi
fi
])

# Usage:
#  SIM_AC_CHECK_X11SHMEM([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to find the X11 shared memory extension. If it is found, this
#  shell variable is set:
#
#    $sim_ac_x11shmem_libs   (link libraries the linker needs for X11 Shm)
#
#  The LIBS flag will also be modified accordingly. In addition, the
#  variable $sim_ac_x11shmem_avail is set to "yes" if the X11 shared
#  memory extension is found.
#
#
# Author: Morten Eriksen, <mortene@sim.no>.
#
# TODO:
#    * [mortene:20000122] make sure this work on MSWin (with
#      Cygwin installation)
#

AC_DEFUN([SIM_AC_CHECK_X11SHMEM], [

sim_ac_x11shmem_avail=no
sim_ac_x11shmem_libs="-lXext"
sim_ac_save_libs=$LIBS
LIBS="$sim_ac_x11shmem_libs $LIBS"

AC_CACHE_CHECK(
  [whether the X11 shared memory extension is available],
  sim_cv_lib_x11shmem_avail,
  [AC_TRY_LINK([#include <X11/Xlib.h>
               #include <X11/extensions/XShm.h>],
               [(void)XShmQueryVersion(0L, 0L, 0L, 0L);],
               [sim_cv_lib_x11shmem_avail=yes],
               [sim_cv_lib_x11shmem_avail=no])])

if test x"$sim_cv_lib_x11shmem_avail" = xyes; then
  sim_ac_x11shmem_avail=yes
  $1
else
  LIBS=$sim_ac_save_libs
  $2
fi
])

# Usage:
#  SIM_AC_CHECK_X11MU([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to find the X11 miscellaneous utilities extension. If it is
#  found, this shell variable is set:
#
#    $sim_ac_x11mu_libs   (link libraries the linker needs for X11 MU)
#
#  The LIBS flag will also be modified accordingly. In addition, the
#  variable $sim_ac_x11mu_avail is set to "yes" if the X11 miscellaneous
#  utilities extension is found.
#  CPPFLAGS and LDFLAGS might also be modified, if library is found in a
#  non-standard location.
#
# Author: Morten Eriksen, <mortene@sim.no>.
#
# TODO:
#    * [mortene:20000122] make sure this work on MSWin (with
#      Cygwin installation)

AC_DEFUN([SIM_AC_CHECK_X11MU], [

sim_ac_x11mu_avail=no
sim_ac_x11mu_cppflags=""
sim_ac_x11mu_ldflags=""
sim_ac_x11mu_libs="-lXmu"

sim_ac_save_libs=$LIBS
sim_ac_save_cppflags=$CPPFLAGS
sim_ac_save_ldflags=$LDFLAGS

LIBS="$sim_ac_x11mu_libs $LIBS"

AC_CACHE_CHECK(
  [whether the X11 miscellaneous utilities library is available],
  sim_cv_lib_x11mu_avail,
  [AC_TRY_LINK([#include <X11/Xlib.h>
                #include <X11/Xmu/Xmu.h>
                #include <X11/Xmu/StdCmap.h>],
               [(void)XmuAllStandardColormaps(0L);],
               [sim_cv_lib_x11mu_avail=yes],
               [sim_cv_lib_x11mu_avail=maybe])])

if test x"$sim_cv_lib_x11mu_avail" = xyes; then
  sim_ac_x11mu_avail=yes
else
  # On HP-UX, Xmu might be located under /usr/contrib/X11R6/
  mudir=/usr/contrib/X11R6
  if test -d $mudir; then
    sim_ac_x11mu_cppflags="-I$mudir/include"
    sim_ac_x11mu_ldflags="-L$mudir/lib"
    CPPFLAGS="$sim_ac_x11mu_cppflags $CPPFLAGS"
    LDFLAGS="$sim_ac_x11mu_ldflags $LDFLAGS"

    AC_CACHE_CHECK(
      [once more whether the X11 miscellaneous utilities library is available],
      sim_cv_lib_x11mu_contrib_avail,
      [AC_TRY_LINK([#include <X11/Xlib.h>
                    #include <X11/Xmu/Xmu.h>
                    #include <X11/Xmu/StdCmap.h>],
                   [(void)XmuAllStandardColormaps(0L);],
                   [sim_cv_lib_x11mu_contrib_avail=yes],
                   [sim_cv_lib_x11mu_contrib_avail=no])])
    if test x"$sim_cv_lib_x11mu_contrib_avail" = xyes; then
      sim_ac_x11mu_avail=yes
    else
      sim_ac_x11mu_cppflags=""
      sim_ac_x11mu_ldflags=""
    fi
  fi
fi

if test x"$sim_ac_x11mu_avail" = xyes; then
  :
  $1
else
  LIBS=$sim_ac_save_libs
  CPPFLAGS=$sim_ac_save_cppflags
  LDFLAGS=$sim_ac_save_ldflags
  $2
fi
])

# Usage:
#  SIM_AC_CHECK_X11XID([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to find the X11 extension device library. Sets this
#  shell variable:
#
#    $sim_ac_x11xid_libs   (link libraries the linker needs for X11 XID)
#
#  The LIBS flag will also be modified accordingly. In addition, the
#  variable $sim_ac_x11xid_avail is set to "yes" if the X11 extension
#  device library is found.
#
# Author: Morten Eriksen, <mortene@sim.no>.
#
# TODO:
#    * [mortene:20000122] make sure this work on MSWin (with
#      Cygwin installation)
#

AC_DEFUN([SIM_AC_CHECK_X11XID], [

sim_ac_x11xid_avail=no
sim_ac_x11xid_libs="-lXi"
sim_ac_save_libs=$LIBS
LIBS="$sim_ac_x11xid_libs $LIBS"

AC_CACHE_CHECK(
  [whether the X11 extension device library is available],
  sim_cv_lib_x11xid_avail,
  [AC_TRY_LINK([#include <X11/extensions/XInput.h>],
               [(void)XOpenDevice(0L, 0);],
               [sim_cv_lib_x11xid_avail=yes],
               [sim_cv_lib_x11xid_avail=no])])

if test x"$sim_cv_lib_x11xid_avail" = x"yes"; then
  sim_ac_x11xid_avail=yes
  $1
else
  LIBS=$sim_ac_save_libs
  $2
fi
])

# Usage:
#  SIM_AC_CHECK_X_INTRINSIC([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to find the Xt intrinsic library. Sets this shell variable:
#
#    $sim_ac_xt_libs   (link library the linker needs for X Intrinsic)
#
#  The LIBS flag will also be modified accordingly. In addition, the
#  variable $sim_ac_xt_avail is set to "yes" if the X11 Intrinsic
#  library is found.
#
# Author: Morten Eriksen, <mortene@sim.no>.
#

AC_DEFUN([SIM_AC_CHECK_X_INTRINSIC], [

sim_ac_xt_avail=no
sim_ac_xt_libs="-lXt"
sim_ac_save_libs=$LIBS
LIBS="$sim_ac_xt_libs $LIBS"

AC_CACHE_CHECK(
  [whether the X11 Intrinsic library is available],
  sim_cv_lib_xt_avail,
  [AC_TRY_LINK([#include <X11/Intrinsic.h>],
               [(void)XtVaCreateWidget("", 0L, 0L);],
               [sim_cv_lib_xt_avail=yes],
               [sim_cv_lib_xt_avail=no])])

if test x"$sim_cv_lib_xt_avail" = xyes; then
  sim_ac_xt_avail=yes
  $1
else
  LIBS=$sim_ac_save_libs
  $2
fi
])

# Usage:
#   SIM_AC_CHECK_LIBXPM( [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND] )
#
# Description:
#   This macro checks for libXpm.
#
# Variables:
#   $sim_ac_xpm_avail      yes | no
#   $sim_ac_xpm_libs       [link-line libraries]
#
# Authors:
#   Lars J. Aas <larsa@sim.no>
#

AC_DEFUN([SIM_AC_CHECK_LIBXPM], [

sim_ac_xpm_avail=no
sim_ac_xpm_libs="-lXpm"

AC_CACHE_CHECK(
  [whether libXpm is available],
  sim_cv_lib_xpm_avail,
  [sim_ac_save_libs=$LIBS
  LIBS="$sim_ac_xpm_libs $LIBS"
  AC_TRY_LINK([#include <X11/xpm.h>],
              [(void)XpmLibraryVersion();],
              [sim_cv_lib_xpm_avail=yes],
              [sim_cv_lib_xpm_avail=no])
  LIBS="$sim_ac_save_libs"])

if test x"$sim_cv_lib_xpm_avail" = x"yes"; then
  sim_ac_xpm_avail=yes
  LIBS="$sim_ac_xpm_libs $LIBS"
  $1
else
  ifelse([$2], , :, [$2])
fi
])


# Usage:
#  SIM_AC_CHECK_X11_XP([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to find the Xp library for printing functionality. Sets this
#  shell variable:
#
#    $sim_ac_xp_libs   (link library the linker needs for the Xp library)
#
#  The LIBS flag will also be modified accordingly. In addition, the
#  variable $sim_ac_xp_avail is set to "yes" if the Xp library is found.
#
# Author: Morten Eriksen, <mortene@sim.no>.
#

AC_DEFUN([SIM_AC_CHECK_X11_XP], [
sim_ac_xp_avail=no
sim_ac_xp_libs="-lXp"
sim_ac_save_libs=$LIBS
LIBS="$sim_ac_xp_libs $LIBS"

AC_CACHE_CHECK(
  [whether the X11 printing library is available],
  sim_cv_lib_xp_avail,
  [AC_TRY_LINK([#include <X11/extensions/Print.h>],
               [XpEndJob(0L);],
               [sim_cv_lib_xp_avail=yes],
               [sim_cv_lib_xp_avail=no])])

if test x"$sim_cv_lib_xp_avail" = xyes; then
  sim_ac_xp_avail=yes
  $1
else
  LIBS=$sim_ac_save_libs
  $2
fi
])

# SIM_AC_CHECK_X11_ATHENA( [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND] )

AC_DEFUN([SIM_AC_CHECK_X11_ATHENA], [
sim_ac_athena_avail=no
sim_ac_athena_libs="-lXaw"
sim_ac_save_libs=$LIBS
LIBS="$sim_ac_athena_libs $LIBS"

AC_CACHE_CHECK(
  [whether the X11 Athena widgets library is available],
  sim_cv_lib_athena_avail,
  [AC_TRY_LINK([#include <X11/Xfuncproto.h>
                #include <X11/Xaw/XawInit.h>],
               [XawInitializeWidgetSet();],
               [sim_cv_lib_athena_avail=yes],
               [sim_cv_lib_athena_avail=no])])

if test x"$sim_cv_lib_athena_avail" = xyes; then
  sim_ac_athena_avail=yes
  $1
else
  LIBS=$sim_ac_save_libs
  $2
fi
])

# SIM_AC_X11_READY( [ACTION-IF-TRUE], [ACTION-IF-FALSE] )

AC_DEFUN([SIM_AC_CHECK_X11_READY],
[AC_CACHE_CHECK(
  [if X11 linkage is ready],
  [sim_cv_x11_ready],
  [AC_TRY_LINK(
    [#include <X11/Xlib.h>],
    [(void)XOpenDisplay(0L);],
    [sim_cv_x11_ready=true],
    [sim_cv_x11_ready=false])])
if ${sim_cv_x11_ready}; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_X11_READY()

# **************************************************************************
# SIM_AC_CHECK_HEADER_SILENT([header], [if-found], [if-not-found], [includes])
#
# This macro will not output any header checking information, nor will it
# cache the result, so it can be used multiple times on the same header,
# trying out different compiler options.

AC_DEFUN([SIM_AC_CHECK_HEADER_SILENT],
[AS_VAR_PUSHDEF([ac_Header], [ac_cv_header_$1])
m4_ifval([$4],
         [AC_COMPILE_IFELSE([AC_LANG_SOURCE([$4
@%:@include <$1>])],
                            [AS_VAR_SET(ac_Header, yes)],
                            [AS_VAR_SET(ac_Header, no)])],
         [AC_PREPROC_IFELSE([AC_LANG_SOURCE([@%:@include <$1>])],
                            [AS_VAR_SET(ac_Header, yes)],
                            [AS_VAR_SET(ac_Header, no)])])
AS_IF([test AS_VAR_GET(ac_Header) = yes], [$2], [$3])
AS_VAR_POPDEF([ac_Header])
])# SIM_AC_CHECK_HEADER_SILENT

# **************************************************************************
# SIM_AC_CHECK_HEADER_GL([IF-FOUND], [IF-NOT-FOUND])
#
# This macro detects how to include the GL header file, and gives you the
# necessary CPPFLAGS in $sim_ac_gl_cppflags, and also sets the config.h
# defines HAVE_GL_GL_H or HAVE_OPENGL_GL_H if one of them is found.

AC_DEFUN([SIM_AC_CHECK_HEADER_GL],
[sim_ac_gl_header_avail=false
AC_MSG_CHECKING([how to include gl.h])
if test x"$with_opengl" != x"no"; then
  sim_ac_gl_save_CPPFLAGS=$CPPFLAGS
  sim_ac_gl_cppflags=

  if test x"$with_opengl" != xyes && test x"$with_opengl" != x""; then
    sim_ac_gl_cppflags="-I${with_opengl}/include"
  else
    # On HP-UX platforms, OpenGL headers and libraries are usually installed
    # at this location.
    sim_ac_gl_hpux=/opt/graphics/OpenGL
    if test -d $sim_ac_gl_hpux; then
      sim_ac_gl_cppflags=-I$sim_ac_gl_hpux/include
    fi
  fi

  # On Mac OS X, GL is part of the optional X11 fraemwork
  case $host_os in
  darwin*)
    AC_REQUIRE([SIM_AC_CHECK_X11])
    if $sim_ac_enable_darwin_x11; then
      sim_ac_gl_darwin_x11=/usr/X11R6
      if test -d $sim_ac_gl_darwin_x11; then
        sim_ac_gl_cppflags=-I$sim_ac_gl_darwin_x11/include
      fi
    fi
    ;;
  esac

  CPPFLAGS="$CPPFLAGS $sim_ac_gl_cppflags"

  # Mac OS X framework (no X11, -framework OpenGL)
  if $sim_ac_enable_darwin_x11; then :
  else
    SIM_AC_CHECK_HEADER_SILENT([OpenGL/gl.h], [
      sim_ac_gl_header_avail=true
      sim_ac_gl_header=OpenGL/gl.h
      AC_DEFINE([HAVE_OPENGL_GL_H], 1, [define if the GL header should be included as OpenGL/gl.h])
    ])
  fi

  if $sim_ac_gl_header_avail; then :
  else
    SIM_AC_CHECK_HEADER_SILENT([GL/gl.h], [
      sim_ac_gl_header_avail=true
      sim_ac_gl_header=GL/gl.h
      AC_DEFINE([HAVE_GL_GL_H], 1, [define if the GL header should be included as GL/gl.h])
    ])
  fi

  CPPFLAGS="$sim_ac_gl_save_CPPFLAGS"
  if $sim_ac_gl_header_avail; then
    if test x"$sim_ac_gl_cppflags" = x""; then
      AC_MSG_RESULT([@%:@include <$sim_ac_gl_header>])
    else
      AC_MSG_RESULT([$sim_ac_gl_cppflags, @%:@include <$sim_ac_gl_header>])
    fi
    $1
  else
    AC_MSG_RESULT([not found])
    $2
  fi
else
  AC_MSG_RESULT([disabled])
  $2
fi
])# SIM_AC_CHECK_HEADER_GL

# **************************************************************************
# SIM_AC_CHECK_HEADER_GLU([IF-FOUND], [IF-NOT-FOUND])
#
# This macro detects how to include the GLU header file, and gives you the
# necessary CPPFLAGS in $sim_ac_glu_cppflags, and also sets the config.h
# defines HAVE_GL_GLU_H or HAVE_OPENGL_GLU_H if one of them is found.

AC_DEFUN([SIM_AC_CHECK_HEADER_GLU],
[sim_ac_glu_header_avail=false
AC_MSG_CHECKING([how to include glu.h])
if test x"$with_opengl" != x"no"; then
  sim_ac_glu_save_CPPFLAGS=$CPPFLAGS
  sim_ac_glu_cppflags=

  if test x"$with_opengl" != xyes && test x"$with_opengl" != x""; then
    sim_ac_glu_cppflags="-I${with_opengl}/include"
  else
    # On HP-UX platforms, OpenGL headers and libraries are usually installed
    # at this location.
    sim_ac_gl_hpux=/opt/graphics/OpenGL
    if test -d $sim_ac_gl_hpux; then
      sim_ac_glu_cppflags=-I$sim_ac_gl_hpux/include
    fi
  fi

  # On Mac OS X, GL is part of the optional X11 fraemwork
  case $host_os in
  darwin*)
    AC_REQUIRE([SIM_AC_CHECK_X11])
    if $sim_ac_enable_darwin_x11; then
      sim_ac_gl_darwin_x11=/usr/X11R6
      if test -d $sim_ac_gl_darwin_x11; then
        sim_ac_gl_cppflags=-I$sim_ac_gl_darwin_x11/include
      fi
    fi
    ;;
  esac

  CPPFLAGS="$CPPFLAGS $sim_ac_glu_cppflags"

  # Mac OS X framework (no X11, -framework OpenGL)
  if $sim_ac_enable_darwin_x11; then :
  else
    SIM_AC_CHECK_HEADER_SILENT([OpenGL/glu.h], [
      sim_ac_glu_header_avail=true
      sim_ac_glu_header=OpenGL/glu.h
      AC_DEFINE([HAVE_OPENGL_GLU_H], 1, [define if the GLU header should be included as OpenGL/glu.h])
    ])
  fi

  if $sim_ac_glu_header_avail; then :
  else
    SIM_AC_CHECK_HEADER_SILENT([GL/glu.h], [
      sim_ac_glu_header_avail=true
      sim_ac_glu_header=GL/glu.h
      AC_DEFINE([HAVE_GL_GLU_H], 1, [define if the GLU header should be included as GL/glu.h])
    ])
  fi

  CPPFLAGS="$sim_ac_glu_save_CPPFLAGS"
  if $sim_ac_glu_header_avail; then
    if test x"$sim_ac_glu_cppflags" = x""; then
      AC_MSG_RESULT([@%:@include <$sim_ac_glu_header>])
    else
      AC_MSG_RESULT([$sim_ac_glu_cppflags, @%:@include <$sim_ac_glu_header>])
    fi
    $1
  else
    AC_MSG_RESULT([not found])
    $2
  fi
else
  AC_MSG_RESULT([disabled])
  $2
fi
])# SIM_AC_CHECK_HEADER_GLU

# **************************************************************************
# SIM_AC_CHECK_HEADER_GLEXT([IF-FOUND], [IF-NOT-FOUND])
#
# This macro detects how to include the GLEXT header file, and gives you the
# necessary CPPFLAGS in $sim_ac_glext_cppflags, and also sets the config.h
# defines HAVE_GL_GLEXT_H or HAVE_OPENGL_GLEXT_H if one of them is found.

AC_DEFUN([SIM_AC_CHECK_HEADER_GLEXT],
[sim_ac_glext_header_avail=false
AC_MSG_CHECKING([how to include glext.h])
if test x"$with_opengl" != x"no"; then
  sim_ac_glext_save_CPPFLAGS=$CPPFLAGS
  sim_ac_glext_cppflags=

  if test x"$with_opengl" != xyes && test x"$with_opengl" != x""; then
    sim_ac_glext_cppflags="-I${with_opengl}/include"
  else
    # On HP-UX platforms, OpenGL headers and libraries are usually installed
    # at this location.
    sim_ac_gl_hpux=/opt/graphics/OpenGL
    if test -d $sim_ac_gl_hpux; then
      sim_ac_glext_cppflags=-I$sim_ac_gl_hpux/include
    fi
  fi

  # On Mac OS X, GL is part of the optional X11 fraemwork
  case $host_os in
  darwin*)
    AC_REQUIRE([SIM_AC_CHECK_X11])
    if $sim_ac_enable_darwin_x11; then
      sim_ac_gl_darwin_x11=/usr/X11R6
      if test -d $sim_ac_gl_darwin_x11; then
        sim_ac_gl_cppflags=-I$sim_ac_gl_darwin_x11/include
      fi
    fi
    ;;
  esac

  CPPFLAGS="$CPPFLAGS $sim_ac_glext_cppflags"

  # Mac OS X framework (no X11, -framework OpenGL)
  if $sim_ac_enable_darwin_x11; then :
  else
    SIM_AC_CHECK_HEADER_SILENT([OpenGL/glext.h], [
      sim_ac_glext_header_avail=true
      sim_ac_glext_header=OpenGL/glext.h
      AC_DEFINE([HAVE_OPENGL_GLEXT_H], 1, [define if the GLEXT header should be included as OpenGL/glext.h])
    ])
  fi

  if $sim_ac_glext_header_avail; then :
  else
    SIM_AC_CHECK_HEADER_SILENT([GL/glext.h], [
      sim_ac_glext_header_avail=true
      sim_ac_glext_header=GL/glext.h
      AC_DEFINE([HAVE_GL_GLEXT_H], 1, [define if the GLEXT header should be included as GL/glext.h])
    ])
  fi

  CPPFLAGS="$sim_ac_glext_save_CPPFLAGS"
  if $sim_ac_glext_header_avail; then
    if test x"$sim_ac_glext_cppflags" = x""; then
      AC_MSG_RESULT([@%:@include <$sim_ac_glext_header>])
    else
      AC_MSG_RESULT([$sim_ac_glext_cppflags, @%:@include <$sim_ac_glext_header>])
    fi
    $1
  else
    AC_MSG_RESULT([not found])
    $2
  fi
else
  AC_MSG_RESULT([disabled])
  $2
fi
])# SIM_AC_CHECK_HEADER_GLEXT


# **************************************************************************
# SIM_AC_CHECK_OPENGL([IF-FOUND], [IF-NOT-FOUND])
#
# This macro detects whether or not it's possible to link against OpenGL
# (or Mesa), and gives you the necessary modifications to the
# pre-processor, compiler and linker environment in the envvars
#
#                $sim_ac_ogl_cppflags
#                $sim_ac_ogl_ldflags
#                $sim_ac_ogl_libs (OpenGL library and all dependencies)
#                $sim_ac_ogl_lib (basename of OpenGL library)
#
# The necessary extra options are also automatically added to CPPFLAGS,
# LDFLAGS and LIBS.
#
# Authors: <larsa@sim.no>, <mortene@sim.no>.

AC_DEFUN([SIM_AC_CHECK_OPENGL], [

sim_ac_ogl_cppflags=
sim_ac_ogl_ldflags=
sim_ac_ogl_lib=
sim_ac_ogl_libs=

AC_ARG_WITH(
  [mesa],
  AC_HELP_STRING([--with-mesa],
                 [prefer MesaGL (if found) over OpenGL [[default=no]]]),
  [],
  [with_mesa=no])


sim_ac_ogl_glnames="GL opengl32"
sim_ac_ogl_mesaglnames=MesaGL

if test "x$with_mesa" = "xyes"; then
  sim_ac_ogl_first=$sim_ac_ogl_mesaglnames
  sim_ac_ogl_second=$sim_ac_ogl_glnames
else
  sim_ac_ogl_first=$sim_ac_ogl_glnames
  sim_ac_ogl_second=$sim_ac_ogl_mesaglnames
fi

AC_ARG_WITH(
  [opengl],
  AC_HELP_STRING([--with-opengl=DIR],
                 [OpenGL/Mesa installation directory]),
  [],
  [with_opengl=yes])

if test x"$with_opengl" != xno; then

  if test x"$with_opengl" != xyes && test x"$with_opengl" != x""; then
    sim_ac_ogl_ldflags=-L$with_opengl/lib
    # $sim_ac_ogl_cppflags is set up in the SIM_AC_CHECK_HEADER_GL
    # invocation further below.
  else
    # On HP-UX platforms, OpenGL headers and libraries are usually installed
    # at this location.
    sim_ac_gl_hpux=/opt/graphics/OpenGL
    if test -d $sim_ac_gl_hpux; then
      sim_ac_ogl_ldflags=-L$sim_ac_gl_hpux/lib
    fi
  fi

  sim_ac_use_framework_option=false;
  case $host_os in
  darwin*)
    AC_REQUIRE([SIM_AC_CHECK_X11])
    if $sim_ac_enable_darwin_x11; then
      # Use X11-based GL instead of OpenGL.framework when building against X11
      sim_ac_gl_darwin_x11=/usr/X11R6
      if test -d $sim_ac_gl_darwin_x11; then
        sim_ac_ogl_cppflags=-I$sim_ac_gl_darwin_x11/include
        sim_ac_ogl_ldflags=-L$sim_ac_gl_darwin_x11/lib
      fi
    else
      SIM_AC_CC_COMPILER_OPTION([-framework OpenGL], [sim_ac_use_framework_option=true])
    fi
    ;;
  esac

  if $sim_ac_use_framework_option; then
    sim_ac_ogl_ldflags="-Wl,-framework,OpenGL"
    sim_ac_ogl_lib=OpenGL
  fi

  sim_ac_save_cppflags=$CPPFLAGS
  sim_ac_save_ldflags=$LDFLAGS
  sim_ac_save_libs=$LIBS

  CPPFLAGS="$CPPFLAGS $sim_ac_ogl_cppflags"
  LDFLAGS="$LDFLAGS $sim_ac_ogl_ldflags"

  SIM_AC_CHECK_HEADER_GL([CPPFLAGS="$CPPFLAGS $sim_ac_gl_cppflags"],
                         [AC_MSG_WARN([could not find gl.h])])

  sim_ac_glchk_hit=false
  for sim_ac_tmp_outerloop in barebones withpthreads; do
    if $sim_ac_glchk_hit; then :; else

      sim_ac_oglchk_pthreadslib=""
      if test "$sim_ac_tmp_outerloop" = "withpthreads"; then
        AC_MSG_WARN([couldn't compile or link with OpenGL library -- trying with pthread library in place...])
        LIBS="$sim_ac_save_libs"
        SIM_AC_CHECK_PTHREAD([
          sim_ac_ogl_cppflags="$sim_ac_ogl_cppflags $sim_ac_pthread_cppflags"
          sim_ac_ogl_ldflags="$sim_ac_ogl_ldflags $sim_ac_pthread_ldflags"
          sim_ac_oglchk_pthreadslib="$sim_ac_pthread_libs"
          ],
          [AC_MSG_WARN([couldn't compile or link with pthread library])
          ])
      fi

      AC_MSG_CHECKING([for OpenGL library dev-kit])
      # Mac OS X uses nada (only LDFLAGS), which is why "" was set first
      for sim_ac_ogl_libcheck in "" $sim_ac_ogl_first $sim_ac_ogl_second; do
        if $sim_ac_glchk_hit; then :; else
          if test -n "${sim_ac_ogl_libcheck}"; then
            LIBS="-l${sim_ac_ogl_libcheck} $sim_ac_oglchk_pthreadslib $sim_ac_save_libs"
          else
            LIBS="$sim_ac_oglchk_pthreadslib $sim_ac_save_libs"
          fi
          AC_TRY_LINK(
            [#ifdef HAVE_WINDOWS_H
             #include <windows.h>
             #endif /* HAVE_WINDOWS_H */
             #ifdef HAVE_GL_GL_H
             #include <GL/gl.h>
             #else /* ! HAVE_GL_GL_H */
             #ifdef HAVE_OPENGL_GL_H
             /* Mac OS X */
             #include <OpenGL/gl.h>
             #endif /* HAVE_OPENGL_GL_H */
             #endif /* ! HAVE_GL_GL_H */
            ],
            [glPointSize(1.0f);],
            [
             sim_ac_glchk_hit=true
             sim_ac_ogl_libs=$sim_ac_oglchk_pthreadslib
             if test -n "${sim_ac_ogl_libcheck}"; then
               sim_ac_ogl_lib=$sim_ac_ogl_libcheck
               sim_ac_ogl_libs="-l${sim_ac_ogl_libcheck} $sim_ac_oglchk_pthreadslib"
             fi
            ]
          )
        fi
      done
      if $sim_ac_glchk_hit; then
        AC_MSG_RESULT($sim_ac_ogl_cppflags $sim_ac_ogl_ldflags $sim_ac_ogl_libs)
      else
        AC_MSG_RESULT([unresolved])
      fi
    fi
  done

  if $sim_ac_glchk_hit; then
    LIBS="$sim_ac_ogl_libs $sim_ac_save_libs"
    $1
  else
    CPPFLAGS="$sim_ac_save_cppflags"
    LDFLAGS="$sim_ac_save_ldflags"
    LIBS="$sim_ac_save_libs"
    $2
  fi
fi
])


# **************************************************************************
# SIM_AC_GLU_READY_IFELSE( [ACTION-IF-TRUE], [ACTION-IF-FALSE] )

AC_DEFUN([SIM_AC_GLU_READY_IFELSE], [
sim_ac_glu_save_CPPFLAGS=$CPPFLAGS
SIM_AC_CHECK_HEADER_GLU(, [AC_MSG_WARN([could not find glu.h])])
if test x"$sim_ac_gl_cppflags" != x"$sim_ac_glu_cppflags"; then
  CPPFLAGS="$CPPFLAGS $sim_ac_gl_cppflags $sim_ac_glu_cppflags"
fi
AC_CACHE_CHECK(
  [if GLU is available as part of GL library],
  [sim_cv_glu_ready],
  [AC_TRY_LINK(
    [
#ifdef HAVE_WINDOWS_H
#include <windows.h>
#endif /* HAVE_WINDOWS_H */
#ifdef HAVE_GL_GL_H
#include <GL/gl.h>
#else
#ifdef HAVE_OPENGL_GL_H
#include <OpenGL/gl.h>
#endif
#endif
#ifdef HAVE_GL_GLU_H
#include <GL/glu.h>
#else
#ifdef HAVE_OPENGL_GLU_H
#include <OpenGL/glu.h>
#endif
#endif
],
    [
gluSphere(0L, 1.0, 1, 1);
/* Defect JAGad01283 of HP's aCC compiler causes a link failure unless
   there is at least one "pure" OpenGL call along with GLU calls. */
glEnd();
],
    [sim_cv_glu_ready=true],
    [sim_cv_glu_ready=false])])

if $sim_cv_glu_ready; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_GLU_READY_IFELSE()

# Usage:
#  SIM_AC_CHECK_GLU([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to use the OpenGL utility library; GLU. If it is found,
#  these shell variables are set:
#
#    $sim_ac_glu_cppflags (extra flags the compiler needs for GLU)
#    $sim_ac_glu_ldflags  (extra flags the linker needs for GLU)
#    $sim_ac_glu_libs     (link libraries the linker needs for GLU)
#
#  The CPPFLAGS, LDFLAGS and LIBS flags will also be modified accordingly.
#  In addition, the variable $sim_ac_glu_avail is set to "yes" if GLU
#  is found.
#
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_CHECK_GLU], [
sim_ac_glu_save_CPPFLAGS=$CPPFLAGS
SIM_AC_CHECK_HEADER_GLU(, [AC_MSG_WARN([could not find glu.h])])
if test x"$sim_ac_gl_cppflags" != x"$sim_ac_glu_cppflags"; then
  CPPFLAGS="$CPPFLAGS $sim_ac_gl_cppflags $sim_ac_glu_cppflags"
fi
sim_ac_glu_avail=no

# It's usually libGLU.so on UNIX systems and glu32.lib on MSWindows.
sim_ac_glu_names="-lGLU -lglu32"
sim_ac_glu_mesanames=-lMesaGLU

# with_mesa is set from the SIM_AC_CHECK_OPENGL macro.
if test "x$with_mesa" = "xyes"; then
  sim_ac_glu_first=$sim_ac_glu_mesanames
  sim_ac_glu_second=$sim_ac_glu_names
else
  sim_ac_glu_first=$sim_ac_glu_names
  sim_ac_glu_second=$sim_ac_glu_mesanames
fi

AC_ARG_WITH(
  [glu],
  AC_HELP_STRING([--with-glu=DIR],
                 [use the OpenGL utility library [[default=yes]]]),
  [],
  [with_glu=yes])

if test x"$with_glu" != xno; then
  if test x"$with_glu" != xyes; then
    # sim_ac_glu_cppflags="-I${with_glu}/include"
    sim_ac_glu_ldflags="-L${with_glu}/lib"
  fi

  sim_ac_save_cppflags=$CPPFLAGS
  sim_ac_save_ldflags=$LDFLAGS
  sim_ac_save_libs=$LIBS

  CPPFLAGS="$CPPFLAGS $sim_ac_glu_cppflags"
  LDFLAGS="$LDFLAGS $sim_ac_glu_ldflags"

  AC_CACHE_CHECK(
    [whether GLU is available],
    sim_cv_lib_glu,
    [sim_cv_lib_glu=UNRESOLVED

    # Some platforms (like BeOS) have the GLU functionality in the GL
    # library (and no GLU library present).
    for sim_ac_glu_libcheck in "" $sim_ac_glu_first $sim_ac_glu_second; do
      if test "x$sim_cv_lib_glu" = "xUNRESOLVED"; then
        LIBS="$sim_ac_glu_libcheck $sim_ac_save_libs"
        AC_TRY_LINK([
#ifdef HAVE_WINDOWS_H
#include <windows.h>
#endif /* HAVE_WINDOWS_H */
#ifdef HAVE_GL_GL_H
#include <GL/gl.h>
#else
#ifdef HAVE_OPENGL_GL_H
#include <OpenGL/gl.h>
#endif
#endif
#ifdef HAVE_GL_GLU_H
#include <GL/glu.h>
#else
#ifdef HAVE_OPENGL_GLU_H
#include <OpenGL/glu.h>
#endif
#endif
],
                    [
gluSphere(0L, 1.0, 1, 1);
/* Defect JAGad01283 of HP's aCC compiler causes a link failure unless
   there is at least one "pure" OpenGL call along with GLU calls. */
glEnd();
],
                    [sim_cv_lib_glu="$sim_ac_glu_libcheck"])
      fi
    done
    if test x"$sim_cv_lib_glu" = x"" &&
       test x`echo $LDFLAGS | grep -c -- "-Wl,-framework,OpenGL"` = x1; then
      # just for the visual representation on Mac OS X
      sim_cv_lib_glu="-Wl,-framework,OpenGL"
    fi
  ])

  LIBS="$sim_ac_save_libs"

  CPPFLAGS=$sim_ac_glu_save_CPPFLAGS
  if test "x$sim_cv_lib_glu" != "xUNRESOLVED"; then
    if test x"$sim_cv_lib_glu" = x"-Wl,-framework,OpenGL"; then
      sim_ac_glu_libs=""
    else
      sim_ac_glu_libs="$sim_cv_lib_glu"
    fi
    LIBS="$sim_ac_glu_libs $sim_ac_save_libs"
    sim_ac_glu_avail=yes
    $1
  else
    CPPFLAGS=$sim_ac_save_cppflags
    LDFLAGS=$sim_ac_save_ldflags
    LIBS=$sim_ac_save_libs
    $2
  fi
fi
])


# Usage:
#  SIM_AC_GLU_NURBSOBJECT([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to find out whether the interface struct against the GLU
#  library NURBS functions is called "GLUnurbs" or "GLUnurbsObj".
#  (This seems to have changed somewhere between release 1.1 and
#  release 1.3 of GLU).
#
#  The variable $sim_ac_glu_nurbsobject is set to the correct name
#  if the nurbs structure is found.
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_GLU_NURBSOBJECT], [
AC_CACHE_CHECK(
  [what structure to use in the GLU NURBS interface],
  sim_cv_func_glu_nurbsobject,
  [sim_cv_func_glu_nurbsobject=NONE
   for sim_ac_glu_structname in GLUnurbs GLUnurbsObj; do
    if test "$sim_cv_func_glu_nurbsobject" = NONE; then
      AC_TRY_LINK([
#ifdef HAVE_WINDOWS_H
#include <windows.h>
#endif /* HAVE_WINDOWS_H */
#ifdef HAVE_GL_GL_H
#include <GL/gl.h>
#else
#ifdef HAVE_OPENGL_GL_H
#include <OpenGL/gl.h>
#endif
#endif
#ifdef HAVE_GL_GLU_H
#include <GL/glu.h>
#else
#ifdef HAVE_OPENGL_GLU_H
#include <OpenGL/glu.h>
#endif
#endif
],
                  [
$sim_ac_glu_structname * hepp = gluNewNurbsRenderer();
gluDeleteNurbsRenderer(hepp);
/* Defect JAGad01283 of HP's aCC compiler causes a link failure unless
   there is at least one "pure" OpenGL call along with GLU calls. */
glEnd();
],
                  [sim_cv_func_glu_nurbsobject=$sim_ac_glu_structname])
    fi
  done
])

if test $sim_cv_func_glu_nurbsobject = NONE; then
  sim_ac_glu_nurbsobject=
  $2
else
  sim_ac_glu_nurbsobject=$sim_cv_func_glu_nurbsobject
  $1
fi
])

# **************************************************************************
# SIM_AC_HAVE_GLXGETCURRENTDISPLAY_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# Check whether the OpenGL implementation includes the method
# glXGetCurrentDisplay().

AC_DEFUN([SIM_AC_HAVE_GLXGETCURRENTDISPLAY_IFELSE], [
AC_CACHE_CHECK(
  [whether glXGetCurrentDisplay() is available],
  sim_cv_have_glxgetcurrentdisplay,
  AC_TRY_LINK([
#include <GL/gl.h>
#include <GL/glx.h>
],
[(void)glXGetCurrentDisplay();],
[sim_cv_have_glxgetcurrentdisplay=true],
[sim_cv_have_glxgetcurrentdisplay=false]))

if ${sim_cv_have_glxgetcurrentdisplay}; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_HAVE_GLXGETCURRENTDISPLAY_IFELSE()

# **************************************************************************
# SIM_AC_HAVE_GLX_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# Check whether GLX is on the system.

AC_DEFUN([SIM_AC_HAVE_GLX_IFELSE], [
AC_CACHE_CHECK(
  [whether GLX is on the system],
  sim_cv_have_glx,
  AC_TRY_LINK(
    [
#include <GL/glx.h>
#include <GL/gl.h>
],
    [
(void)glXChooseVisual(0L, 0, 0L);
/* Defect JAGad01283 of HP's aCC compiler causes a link failure unless
   there is at least one "pure" OpenGL call along with GLU calls. */
glEnd();
],
    [sim_cv_have_glx=true],
    [sim_cv_have_glx=false]))

if ${sim_cv_have_glx=false}; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_HAVE_GLX_IFELSE()

# **************************************************************************
# SIM_AC_HAVE_GLXGETPROCADDRESSARB_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# Check for glXGetProcAddressARB() function.

AC_DEFUN([SIM_AC_HAVE_GLXGETPROCADDRESSARB_IFELSE], [
AC_CACHE_CHECK(
  [for glXGetProcAddressARB() function],
  sim_cv_have_glxgetprocaddressarb,
  AC_TRY_LINK(
    [
#include <GL/glx.h>
#include <GL/gl.h>
],
    [
      glXGetProcAddressARB((const GLubyte *)"glClearColor");
/* Defect JAGad01283 of HP's aCC compiler causes a link failure unless
   there is at least one "pure" OpenGL call along with GLU calls. */
      glEnd();
],
    [sim_cv_have_glxgetprocaddressarb=true],
    [sim_cv_have_glxgetprocaddressarb=false]))

if ${sim_cv_have_glxgetprocaddressarb=false}; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_HAVE_GLXGETPROCADDRESSARB_IFELSE()


# **************************************************************************
# SIM_AC_HAVE_WGL_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# Check whether WGL is on the system.
#
# This macro has one important side-effect: the variable
# sim_ac_wgl_libs will be set to the list of libraries
# needed to link with wgl*() functions.

AC_DEFUN([SIM_AC_HAVE_WGL_IFELSE], [
sim_ac_save_libs=$LIBS
sim_ac_wgl_libs="-lgdi32"
LIBS="$LIBS $sim_ac_wgl_libs"

AC_CACHE_CHECK(
  [whether WGL is on the system],
  sim_cv_have_wgl,
  AC_TRY_LINK(
    [
#include <windows.h>
#include <GL/gl.h>
],
    [(void)wglCreateContext(0L);],
    [sim_cv_have_wgl=true],
    [sim_cv_have_wgl=false]))

LIBS=$sim_ac_save_libs
if ${sim_cv_have_wgl=false}; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_HAVE_WGL_IFELSE()

# **************************************************************************
# SIM_AC_HAVE_AGL_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# Check whether AGL is on the system.

AC_DEFUN([SIM_AC_HAVE_AGL_IFELSE], [
sim_ac_save_ldflags=$LDFLAGS
sim_ac_agl_ldflags="-Wl,-framework,ApplicationServices -Wl,-framework,AGL -Wl,-framework,Carbon"

LDFLAGS="$LDFLAGS $sim_ac_agl_ldflags"

# see comment in Coin/src/glue/gl_agl.c: regarding __CARBONSOUND__ define

AC_CACHE_CHECK(
  [whether AGL is on the system],
  sim_cv_have_agl,
  AC_TRY_LINK(
    [#include <AGL/agl.h>
     #define __CARBONSOUND__
     #include <Carbon/Carbon.h>],
    [AGLContext ctx = NULL;WindowRef wref = aglGetWindowRef(ctx);HIViewRef href = HIViewGetRoot(wref);],
    [sim_cv_have_agl=true],
    [sim_cv_have_agl=false]))

LDFLAGS=$sim_ac_save_ldflags
if ${sim_cv_have_agl=false}; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_HAVE_AGL_IFELSE()


AC_DEFUN([SIM_AC_HAVE_AGL_PBUFFER], [
  AC_CACHE_CHECK([whether we can use AGL pBuffers],
    sim_cv_agl_pbuffer_avail,
    [AC_TRY_LINK([ #include <AGL/agl.h> ],
                 [AGLPbuffer pbuffer;],
                 [sim_cv_agl_pbuffer_avail=yes],
                 [sim_cv_agl_pbuffer_avail=no])])

  if test x"$sim_cv_agl_pbuffer_avail" = xyes; then
    ifelse([$1], , :, [$1])
  else
    ifelse([$2], , :, [$2])
  fi
])

# **************************************************************************
# SIM_AC_HAVE_CGL_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# Check whether CGL is on the system.

AC_DEFUN([SIM_AC_HAVE_CGL_IFELSE], [
sim_ac_save_ldflags=$LDFLAGS
sim_ac_cgl_ldflags="-Wl,-framework,OpenGL"

LDFLAGS="$LDFLAGS $sim_ac_cgl_ldflags"

AC_CACHE_CHECK(
  [whether CGL is on the system],
  sim_cv_have_cgl,
  AC_TRY_LINK(
    [#include <OpenGL/OpenGL.h>],
    [CGLGetCurrentContext();],
    [sim_cv_have_cgl=true],
    [sim_cv_have_cgl=false]))

LDFLAGS=$sim_ac_save_ldflags
if ${sim_cv_have_cgl=false}; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_HAVE_CGL_IFELSE()

# Usage:
#  SIM_AC_CHECK_PTHREAD([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to find the PTHREAD development system. If it is found, these
#  shell variables are set:
#
#    $sim_ac_pthread_cppflags (extra flags the compiler needs for pthread)
#    $sim_ac_pthread_ldflags  (extra flags the linker needs for pthread)
#    $sim_ac_pthread_libs     (link libraries the linker needs for pthread)
#
#  The CPPFLAGS, LDFLAGS and LIBS flags will also be modified accordingly.
#  In addition, the variable $sim_ac_pthread_avail is set to "true" if the
#  pthread development system is found.
#
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_CHECK_PTHREAD], [

AC_ARG_WITH(
  [pthread],
  AC_HELP_STRING([--with-pthread=DIR],
                 [pthread installation directory]),
  [],
  [with_pthread=yes])

sim_ac_pthread_avail=no

if test x"$with_pthread" != xno; then
  if test x"$with_pthread" != xyes; then
    sim_ac_pthread_cppflags="-I${with_pthread}/include"
    sim_ac_pthread_ldflags="-L${with_pthread}/lib"
  fi

  # FIXME: should investigate and document the exact meaning of
  # the _REENTRANT flag. larsa's commit message mentions
  # "glibc-doc/FAQ.threads.html". Also, kintel points to the
  # comp.programming.thrads FAQ, which has an entry on the
  # _REENTRANT define.
  #
  # Preferably, it should only be set up when really needed
  # (as detected by some other configure check).
  #
  # 20030306 mortene.
  sim_ac_pthread_cppflags="-D_REENTRANT ${sim_ac_pthread_cppflags}"

  sim_ac_save_cppflags=$CPPFLAGS
  sim_ac_save_ldflags=$LDFLAGS
  sim_ac_save_libs=$LIBS

  CPPFLAGS="$CPPFLAGS $sim_ac_pthread_cppflags"
  LDFLAGS="$LDFLAGS $sim_ac_pthread_ldflags"

  sim_ac_pthread_avail=false

  AC_MSG_CHECKING([for POSIX threads])
  # At least under FreeBSD, we link to pthreads library with -pthread.
  for sim_ac_pthreads_libcheck in "-lpthread" "-pthread"; do
    if $sim_ac_pthread_avail; then :; else
      LIBS="$sim_ac_pthreads_libcheck $sim_ac_save_libs"
      AC_TRY_LINK([#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif
#include <pthread.h>],
                  [(void)pthread_create(0L, 0L, 0L, 0L);],
                  [sim_ac_pthread_avail=true
                   sim_ac_pthread_libs="$sim_ac_pthreads_libcheck"
                  ])
    fi
  done

  if $sim_ac_pthread_avail; then
    AC_MSG_RESULT($sim_ac_pthread_cppflags $sim_ac_pthread_ldflags $sim_ac_pthread_libs)
  else
    AC_MSG_RESULT(not available)
  fi

  if $sim_ac_pthread_avail; then
    AC_CACHE_CHECK(
      [the struct timespec resolution],
      sim_cv_lib_pthread_timespec_resolution,
      [AC_TRY_COMPILE([#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif
#include <pthread.h>],
                      [struct timespec timeout;
                       timeout.tv_nsec = 0;],
                      [sim_cv_lib_pthread_timespec_resolution=nsecs],
                      [sim_cv_lib_pthread_timespec_resolution=usecs])])
    if test x"$sim_cv_lib_pthread_timespec_resolution" = x"nsecs"; then
      AC_DEFINE([HAVE_PTHREAD_TIMESPEC_NSEC], 1, [define if pthread's struct timespec uses nsecs and not usecs])
    fi
  fi

  if $sim_ac_pthread_avail; then
    ifelse([$1], , :, [$1])
  else
    CPPFLAGS=$sim_ac_save_cppflags
    LDFLAGS=$sim_ac_save_ldflags
    LIBS=$sim_ac_save_libs
    ifelse([$2], , :, [$2])
  fi
fi
]) # SIM_AC_CHECK_PTHREAD

# Usage:
#  SIM_CHECK_OIV_XT([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to compile and link against the Xt GUI glue library for
#  the Open Inventor development system. Sets this shell
#  variable:
#
#    $sim_ac_oivxt_libs     (link libraries the linker needs for InventorXt)
#
#  The LIBS variable will also be modified accordingly. In addition,
#  the variable $sim_ac_oivxt_avail is set to "yes" if the Xt glue
#  library for the Open Inventor development system is found.
#
# Authors:
#   Morten Eriksen, <mortene@sim.no>.
#   Lars J. Aas, <larsa@sim.no>.
#

AC_DEFUN([SIM_CHECK_OIV_XT], [
sim_ac_oivxt_avail=no

sim_ac_oivxt_libs="-lInventorXt"
sim_ac_save_libs=$LIBS
LIBS="$sim_ac_oivxt_libs $LIBS"

AC_CACHE_CHECK([for Xt glue library in the Open Inventor developer kit],
  sim_cv_lib_oivxt_avail,
  [AC_TRY_LINK([#include <Inventor/Xt/SoXt.h>],
               [(void)SoXt::init(0L, 0L);],
               [sim_cv_lib_oivxt_avail=yes],
               [sim_cv_lib_oivxt_avail=no])])

if test x"$sim_cv_lib_oivxt_avail" = xyes; then
  sim_ac_oivxt_avail=yes
  $1
else
  LIBS=$sim_ac_save_libs
  $2
fi
])

# Usage:
#  SIM_CHECK_OIV_QT([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to compile and link against the Qt GUI glue library for
#  the Open Inventor development system. Sets this shell
#  variable:
#
#    $sim_ac_oivqt_libs     (link libraries the linker needs for InventorQt)
#
#  The LIBS variable will also be modified accordingly. In addition,
#  the variable $sim_ac_oivqt_avail is set to "yes" if the Qt glue
#  library for the Open Inventor development system is found.
#
# Authors:
#   Morten Eriksen, <mortene@sim.no>.
#   Lars J. Aas, <larsa@sim.no>.
#

AC_DEFUN([SIM_CHECK_OIV_QT], [
sim_ac_oivqt_avail=no

sim_ac_oivqt_libs="-lInventorQt"
sim_ac_save_libs=$LIBS
LIBS="$sim_ac_oivqt_libs $LIBS"

AC_CACHE_CHECK([for InventorQt glue library],
  sim_cv_lib_oivqt_avail,
  [AC_TRY_LINK([#include <Inventor/Qt/SoQt.h>],
               [(void)SoQt::init(0L, 0L);],
               [sim_cv_lib_oivqt_avail=yes],
               [sim_cv_lib_oivqt_avail=no])])

if test x"$sim_cv_lib_oivqt_avail" = xyes; then
  sim_ac_oivqt_avail=yes
  $1
else
  LIBS=$sim_ac_save_libs
  $2
fi
])

# **************************************************************************
# SIM_AC_WITH_INVENTOR
# This macro just ensures the --with-inventor option is used.

AC_DEFUN([SIM_AC_WITH_INVENTOR], [
: ${sim_ac_want_inventor=false}
AC_ARG_WITH([inventor],
  AC_HELP_STRING([--with-inventor], [use SGI or TGS Open Inventor rather than Coin [[default=no]]])
AC_HELP_STRING([--with-inventor=PATH], [specify where SGI or TGS Open Inventor resides]),
  [case "$withval" in
  no)  sim_ac_want_inventor=false ;;
  yes) sim_ac_want_inventor=true
       test -n "$OIVHOME" &&
         SIM_AC_DEBACKSLASH(sim_ac_inventor_path, "$OIVHOME") ;;
  *)   sim_ac_want_inventor=true; sim_ac_inventor_path="$withval" ;;
  esac])
]) # SIM_AC_WITH_INVENTOR

# **************************************************************************
# SIM_AC_WITH_INVENTORXT
# This macro just ensures the --with-inventor-xt option is used.

AC_DEFUN([SIM_AC_WITH_INVENTORXT], [
: ${sim_ac_want_inventorxt=true}
AC_ARG_WITH([inventor-xt],
  AC_HELP_STRING([--with-inventor-xt], [use InventorXt when using SGI or TGS Open Inventor [[default=yes]]])
AC_HELP_STRING([--with-inventor-xt=PATH], [specify where InventorXt resides]),
  [case "$withval" in
  no)  sim_ac_want_inventorxt=false ;;
  yes) sim_ac_want_inventorxt=true
       test -n "$OIVHOME" &&
         SIM_AC_DEBACKSLASH(sim_ac_inventorxt_path, "$OIVHOME") ;;
  *)   sim_ac_want_inventorxt=true; sim_ac_inventorxt_path="$withval" ;;
  esac])
]) # SIM_AC_WITH_INVENTORXT

# **************************************************************************
# SIM_AC_WITH_INVENTORQT
# This macro just ensures the --with-inventor-qt option is used.

AC_DEFUN([SIM_AC_WITH_INVENTORQT], [
: ${sim_ac_want_inventorqt=false}
AC_ARG_WITH([inventor-qt],
  AC_HELP_STRING([--with-inventor-qt], [use InventorQt when using SGI or TGS Open Inventor [[default=yes]]])
AC_HELP_STRING([--with-inventor-qt=PATH], [specify where InventorQt resides]),
  [case "$withval" in
  no)  sim_ac_want_inventorqt=false ;;
  yes) sim_ac_want_inventorqt=true
       test -n "$OIVHOME" &&
         SIM_AC_DEBACKSLASH(sim_ac_inventorqt_path, "$OIVHOME") ;;
  *)   sim_ac_want_inventorqt=true; sim_ac_inventorqt_path="$withval" ;;
  esac])
]) # SIM_AC_WITH_INVENTORQT

# **************************************************************************
# SIM_AC_HAVE_INVENTOR_IMAGE_IFELSE

AC_DEFUN([SIM_AC_HAVE_INVENTOR_IMAGE_IFELSE], [
AC_REQUIRE([SIM_AC_WITH_INVENTOR])
AC_REQUIRE([SIM_AC_WITH_INVENTORXT])
AC_REQUIRE([SIM_AC_WITH_INVENTORQT])

if $sim_ac_want_inventor; then
  sim_ac_inventor_image_save_CPPFLAGS="$CPPFLAGS"
  sim_ac_inventor_image_save_LDFLAGS="$LDFLAGS"
  sim_ac_inventor_image_save_LIBS="$LIBS"

  if test s${sim_ac_inventor_path+et} = set; then
    sim_ac_inventor_image_cppflags="-I${sim_ac_inventor_path}/include"
    sim_ac_inventor_image_ldflags="-L${sim_ac_inventor_path}/lib"
  fi
  sim_ac_inventor_image_libs="-limage"

  AC_CACHE_CHECK(
    [if linking with libimage is possible],
    sim_cv_have_inventor_image,
    [
    CPPFLAGS="$sim_ac_inventor_image_cppflags $CPPFLAGS"
    LDFLAGS="$sim_ac_inventor_image_ldflags $LDFLAGS"
    LIBS="$sim_ac_inventor_image_libs $LIBS"
    AC_TRY_LINK(
      [],
      [],
      [sim_cv_have_inventor_image=true],
      [sim_cv_have_inventor_image=false])
    CPPFLAGS="$sim_ac_inventor_image_save_CPPFLAGS"
    LDFLAGS="$sim_ac_inventor_image_save_LDFLAGS"
    LIBS="$sim_ac_inventor_image_save_LIBS"
    ])

  if $sim_cv_have_inventor_image; then
    ifelse([$1], , :, [$1])
  else
    ifelse([$2], , :, [$2])
  fi
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_HAVE_INVENTOR_IMAGE_IFELSE

# **************************************************************************
# SIM_AC_HAVE_INVENTOR_IFELSE( [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND] ] )
#
# Defines $sim_ac_inventor_cppflags, $sim_ac_inventor_ldflags and
# $sim_ac_inventor_libs.

AC_DEFUN([SIM_AC_HAVE_INVENTOR_IFELSE], [
AC_REQUIRE([SIM_AC_WITH_INVENTOR])
AC_REQUIRE([SIM_AC_WITH_INVENTORXT])
AC_REQUIRE([SIM_AC_WITH_INVENTORQT])

if $sim_ac_want_inventor; then
  sim_ac_save_CPPFLAGS="$CPPFLAGS"
  sim_ac_save_LDFLAGS="$LDFLAGS"
  sim_ac_save_LIBS="$LIBS"

  SIM_AC_HAVE_INVENTOR_IMAGE_IFELSE([
    sim_ac_inventor_cppflags="$sim_ac_inventor_image_cppflags"
    sim_ac_inventor_ldflags="$sim_ac_inventor_image_ldflags"
  ], [
    if test s${sim_ac_inventor_path+et} = set; then
      sim_ac_inventor_cppflags="-I${sim_ac_inventor_path}/include"
      sim_ac_inventor_ldflags="-L${sim_ac_inventor_path}/lib"
    fi
    sim_ac_inventor_image_libs=
  ])

  # Let's at least test for "libInventor".
  sim_ac_inventor_chk_libs="-lInventor"
  sim_ac_inventor_libs=UNRESOLVED

  CPPFLAGS="$sim_ac_inventor_cppflags $CPPFLAGS"

  AC_CHECK_HEADER([Inventor/SbBasic.h],
                  [sim_ac_sbbasic=true],
                  [AC_MSG_WARN([header file Inventor/SbBasic.h not found])
                   sim_ac_sbbasic=false])

  if $sim_ac_sbbasic; then
  AC_MSG_CHECKING([the Open Inventor version])
  # See if we can get the TGS_VERSION number for including a
  # check for inv{ver}.lib.
  # TGS did not include TGS_VERSION before 2.6, so this may have to be
  # back-ported to SO_VERSION+SO_REVISION usage.  larsa 2001-07-25
    cat <<EOF > conftest.c
#include <Inventor/SbBasic.h>
#ifdef __COIN__
#error Testing for original Open Inventor, but found Coin...
#endif
PeekInventorVersion: TGS_VERSION
EOF
  if test x"$CPP" = x; then
    AC_MSG_ERROR([cpp not detected - aborting.  notify maintainer at coin-support@coin3d.org.])
  fi
  echo "$CPP $CPPFLAGS conftest.c" >&AS_MESSAGE_LOG_FD
  tgs_version_line=`$CPP $CPPFLAGS conftest.c 2>&AS_MESSAGE_LOG_FD | grep "^PeekInventorVersion"`
  if test x"$tgs_version_line" = x; then
    echo "second try..." >&AS_MESSAGE_LOG_FD
    echo "$CPP -DWIN32 $CPPFLAGS conftest.c" >&AS_MESSAGE_LOG_FD
    tgs_version_line=`$CPP -DWIN32 $CPPFLAGS conftest.c 2>&AS_MESSAGE_LOG_FD | grep "^PeekInventorVersion"`
  fi
  rm -f conftest.c
  tgs_version=`echo $tgs_version_line | cut -c22-24`
  tgs_suffix=
  if test x"${enable_inventor_debug+set}" = xset &&
     test x"${enable_inventor_debug}" = xyes; then
    tgs_suffix=d
  fi
  if test x"$tgs_version" != xTGS; then
    sim_ac_inventor_chk_libs="$sim_ac_inventor_chk_libs -linv$tgs_version$tgs_suffix"
    tgs_version_string=`echo $tgs_version | sed 's/\(.\)\(.\)\(.\)/\1.\2.\3/g'`
    AC_MSG_RESULT([TGS Open Inventor v$tgs_version_string])
  else
    AC_MSG_RESULT([probably SGI or older TGS Open Inventor])
  fi

  AC_MSG_CHECKING([for Open Inventor library])

  for sim_ac_iv_cppflags_loop in "" "-DWIN32"; do
    # Trying with no libraries first, as TGS Inventor uses pragmas in
    # a header file to notify MSVC of what to link with.
    for sim_ac_iv_libcheck in "" $sim_ac_inventor_chk_libs; do
      if test "x$sim_ac_inventor_libs" = "xUNRESOLVED"; then
        CPPFLAGS="$sim_ac_iv_cppflags_loop $sim_ac_inventor_cppflags $sim_ac_save_CPPFLAGS"
        LDFLAGS="$sim_ac_inventor_ldflags $sim_ac_save_LDFLAGS"
        LIBS="$sim_ac_iv_libcheck $sim_ac_inventor_image_libs $sim_ac_save_LIBS"
        AC_TRY_LINK([#include <Inventor/SoDB.h>],
                    [SoDB::init();],
                    [sim_ac_inventor_libs="$sim_ac_iv_libcheck $sim_ac_inventor_image_libs"
                     sim_ac_inventor_cppflags="$sim_ac_iv_cppflags_loop $sim_ac_inventor_cppflags"])
      fi
    done
  done

  if test "x$sim_ac_inventor_libs" != "xUNRESOLVED"; then
    AC_MSG_RESULT($sim_ac_inventor_cppflags $sim_ac_inventor_ldflags $sim_ac_inventor_libs)
  else
    AC_MSG_RESULT([unavailable])
  fi

  fi # sim_ac_sbbasic = TRUE

  CPPFLAGS="$sim_ac_save_CPPFLAGS"
  LDFLAGS="$sim_ac_save_LDFLAGS"
  LIBS="$sim_ac_save_LIBS"

  if test "x$sim_ac_inventor_libs" != "xUNRESOLVED"; then
    :
    $1
  else
    :
    $2
  fi
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_HAVE_INVENTOR_IFELSE

# **************************************************************************

# utility macros:
AC_DEFUN([AC_TOUPPER], [translit([$1], [[a-z]], [[A-Z]])])
AC_DEFUN([AC_TOLOWER], [translit([$1], [[A-Z]], [[a-z]])])

# **************************************************************************
# SIM_AC_HAVE_INVENTOR_NODE( NODE, [ACTION-IF-FOUND] [, ACTION-IF-NOT-FOUND])
#
# Check whether or not the given NODE is available in the Open Inventor
# development system.  If so, the HAVE_<NODE> define is set.
#
# Authors:
#   Lars J. Aas  <larsa@sim.no>
#   Morten Eriksen  <mortene@sim.no>

AC_DEFUN([SIM_AC_HAVE_INVENTOR_NODE],
[m4_do([pushdef([cache_variable], sim_cv_have_oiv_[]AC_TOLOWER([$1])_node)],
       [pushdef([DEFINE_VARIABLE], HAVE_[]AC_TOUPPER([$1]))])
AC_CACHE_CHECK(
  [if the Open Inventor $1 node is available],
  cache_variable,
  [AC_TRY_LINK(
    [#include <Inventor/nodes/$1.h>],
    [$1 * p = new $1;],
    cache_variable=true,
    cache_variable=false)])

if $cache_variable; then
  AC_DEFINE(DEFINE_VARIABLE, 1, [Define to enable use of the Open Inventor $1 node])
  $2
else
  ifelse([$3], , :, [$3])
fi
m4_do([popdef([cache_variable])],
      [popdef([DEFINE_VARIABLE])])
]) # SIM_AC_HAVE_INVENTOR_NODE

# **************************************************************************
# SIM_AC_HAVE_INVENTOR_VRMLNODE( VRLMNODE, [ACTION-IF-FOUND] [, ACTION-IF-NOT-FOUND])
#
# Check whether or not the given VRMLNODE is available in the Open Inventor
# development system.  If so, the HAVE_<VRMLNODE> define is set.
#
# Authors:
#   Lars J. Aas  <larsa@sim.no>
#   Morten Eriksen  <mortene@sim.no>

AC_DEFUN([SIM_AC_HAVE_INVENTOR_VRMLNODE],
[m4_do([pushdef([cache_variable], sim_cv_have_oiv_[]AC_TOLOWER([$1])_vrmlnode)],
       [pushdef([DEFINE_VARIABLE], HAVE_[]AC_TOUPPER([$1]))])
AC_CACHE_CHECK(
  [if the Open Inventor $1 VRML node is available],
  cache_variable,
  [AC_TRY_LINK(
    [#include <Inventor/VRMLnodes/$1.h>],
    [$1 * p = new $1;],
    cache_variable=true,
    cache_variable=false)])

if $cache_variable; then
  AC_DEFINE(DEFINE_VARIABLE, 1, [Define to enable use of the Open Inventor $1 VRML node])
  $2
else
  ifelse([$3], , :, [$3])
fi
m4_do([popdef([cache_variable])],
      [popdef([DEFINE_VARIABLE])])
]) # SIM_AC_HAVE_INVENTOR_VRMLNODE

# **************************************************************************
# SIM_AC_HAVE_INVENTOR_FEATURE(MESSAGE, HEADERS, BODY, DEFINE
#                              [, ACTION-IF-FOUND[, ACTION-IF-NOT-FOUND]])
#
# Authors:
#   Morten Eriksen <mortene@sim.no>

AC_DEFUN([SIM_AC_HAVE_INVENTOR_FEATURE],
[m4_do([pushdef([cache_variable], sim_cv_have_oiv_[]AC_TOLOWER([$4]))],
       [pushdef([DEFINE_VARIABLE], AC_TOUPPER([$4]))])
AC_CACHE_CHECK(
  [$1],
  cache_variable,
  [AC_TRY_LINK(
    [$2],
    [$3],
    cache_variable=true,
    cache_variable=false)])

if $cache_variable; then
  AC_DEFINE(DEFINE_VARIABLE, 1, [Define to enable use of Inventor feature])
  $5
else
  ifelse([$6], , :, [$6])
fi
m4_do([popdef([cache_variable])],
      [popdef([DEFINE_VARIABLE])])
]) # SIM_AC_HAVE_INVENTOR_FEATURE

# **************************************************************************
# SIM_AC_INVENTOR_EXTENSIONS( ACTION )
#
# This macro adds an "--with-iv-extensions=..." option to configure, that
# enabes the configurer to enable extensions in third-party libraries to
# be initialized by the library by default.  The configure-option argument
# must be a comma-separated list of link library path options, link library
# options and class-names.
#
# Sample usage is
#   ./configure --with-iv-extension=-L/tmp/mynodes,-lmynodes,MyNode1,MyNode2
#
# TODO:
#   * check if __declspec(dllimport) is needed on Cygwin

AC_DEFUN([SIM_AC_INVENTOR_EXTENSIONS],
[
AC_ARG_WITH(
  [iv-extensions],
  [AC_HELP_STRING([--with-iv-extensions=extensions], [enable extra open inventor extensions])],
  [sim_ac_iv_try_extensions=$withval])

sim_ac_iv_extension_save_LIBS=$LIBS

sim_ac_iv_extension_LIBS=
sim_ac_iv_extension_LDFLAGS=
sim_ac_iv_extension_decarations=
sim_ac_iv_extension_initializations=

sim_ac_iv_extensions=
while test x"${sim_ac_iv_try_extensions}" != x""; do
  sim_ac_iv_extension=`echo ,$sim_ac_iv_try_extensions | cut -d, -f2`
  sim_ac_iv_try_extensions=`echo ,$sim_ac_iv_try_extensions | cut -d, -f3-`
  case $sim_ac_iv_extension in
  sim_ac_dummy ) # ignore
    ;;
  -L* ) # extension library path hint
    sim_ac_iv_extension_LDFLAGS="$sim_ac_iv_extension_LDFLAGS $sim_ac_iv_extension"
    ;;
  -l* ) # extension library hint
    LIBS="$sim_ac_iv_extension_save_LIBS $sim_ac_iv_extension_LIBS $sim_ac_iv_extension"
    AC_MSG_CHECKING([for Open Inventor extension library $sim_ac_iv_extension])
    AC_TRY_LINK([#include <Inventor/SoDB.h>], [SoDB::init();],
      [sim_ac_iv_extension_LIBS="$sim_ac_iv_extension_LIBS $sim_ac_iv_extension"
       AC_MSG_RESULT([linkable])],
      [AC_MSG_RESULT([unlinkable - discarded])])
    ;;
  * )
    AC_MSG_CHECKING([for Open Inventor extension $sim_ac_iv_extension])
    AC_TRY_LINK(
[#include <Inventor/SoDB.h>
// hack up a declaration and see if the mangled name is found by the linker
class $sim_ac_iv_extension {
public:
static void initClass(void);
};], [
  SoDB::init();
  $sim_ac_iv_extension::initClass();
], [
  AC_MSG_RESULT([found])
  sim_ac_iv_extensions="$sim_ac_iv_extensions COIN_IV_EXTENSION($sim_ac_iv_extension)"
], [
  AC_MSG_RESULT([not found])
])
    ;;
  esac
done

AC_DEFINE_UNQUOTED([COIN_IV_EXTENSIONS], [$sim_ac_iv_extensions], [Open Inventor extensions])

LIBS=$sim_ac_iv_extension_save_LIBS

ifelse([$1], , :, [$1])

]) # SIM_AC_INVENTOR_EXTENSIONS


# Convenience macros SIM_AC_DEBACKSLASH and SIM_AC_DOBACKSLASH for
# converting to and from MSWin/MS-DOS style paths.
#
# Example use:
#
#     SIM_AC_DEBACKSLASH(my_ac_reversed, "C:\\mydir\\bin")
#
# will give a shell variable $my_ac_reversed with the value "C:/mydir/bin").
# Vice versa for SIM_AC_DOBACKSLASH.
#
# Author: Marius Bugge Monsen <mariusbu@sim.no>
#         Lars Jørgen Aas <larsa@sim.no>
#         Morten Eriksen <mortene@sim.no>

AC_DEFUN([SIM_AC_DEBACKSLASH], [
eval "$1=\"`echo $2 | sed -e 's%\\\\%\\/%g'`\""
])

AC_DEFUN([SIM_AC_DOBACKSLASH], [
eval "$1=\"`echo $2 | sed -e 's%\\/%\\\\%g'`\""
])

AC_DEFUN([SIM_AC_DODOUBLEBACKSLASH], [
eval "$1=\"`echo $2 | sed -e 's%\\/%\\\\\\\\\\\\\\\\%g'`\""
])


# Usage:
#  SIM_CHECK_MOTIF([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to compile and link against the Motif library. Sets these
#  shell variables:
#
#    $sim_ac_motif_cppflags (extra flags the compiler needs for Motif)
#    $sim_ac_motif_ldflags  (extra flags the linker needs for Motif)
#    $sim_ac_motif_libs     (link libraries the linker needs for Motif)
#
#  The CPPFLAGS, LDFLAGS and LIBS flags will also be modified accordingly.
#  In addition, the variable $sim_ac_motif_avail is set to "yes" if
#  the Motif library development installation is ok.
#
# Author: Morten Eriksen, <mortene@sim.no>.
#

AC_DEFUN([SIM_CHECK_MOTIF], [
AC_PREREQ([2.14.1])

AC_ARG_WITH(
  [motif],
  AC_HELP_STRING([--with-motif=DIR],
                 [use the Motif library [default=yes]]),
  [],
  [with_motif=yes])

sim_ac_motif_avail=no

if test x"$with_motif" != xno; then
  if test x"$with_motif" != xyes; then
    sim_ac_motif_cppflags="-I${with_motif}/include"
    sim_ac_motif_ldflags="-L${with_motif}/lib"
  fi

  sim_ac_motif_libs="-lXm"

  sim_ac_save_cppflags=$CPPFLAGS
  sim_ac_save_ldflags=$LDFLAGS
  sim_ac_save_libs=$LIBS

  CPPFLAGS="$sim_ac_motif_cppflags $CPPFLAGS"
  LDFLAGS="$sim_ac_motif_ldflags $LDFLAGS"
  LIBS="$sim_ac_motif_libs $LIBS"

  AC_CACHE_CHECK(
    [for a Motif development environment],
    sim_cv_lib_motif_avail,
    [AC_TRY_LINK([#include <Xm/Xm.h>],
                 [XmUpdateDisplay(0L);],
                 [sim_cv_lib_motif_avail=yes],
                 [sim_cv_lib_motif_avail=no])])

  if test x"$sim_cv_lib_motif_avail" = xyes; then
    SIM_AC_MOTIF_VERSION
    sim_ac_motif_avail=yes
    $1
  else
    CPPFLAGS=$sim_ac_save_cppflags
    LDFLAGS=$sim_ac_save_ldflags
    LIBS=$sim_ac_save_libs
    $2
  fi
fi
])

# Usage:
#  SIM_CHECK_XMEDRAWSHADOWS([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to compile and link code with the XmeDrawShadows() function
#  from Motif 2.0 (which is used by the InventorXt library). Sets the
#  variable $sim_ac_xmedrawshadows_avail to either "yes" or "no".
#
#
# Author: Morten Eriksen, <mortene@sim.no>.
#

AC_DEFUN([SIM_CHECK_XMEDRAWSHADOWS], [
AC_PREREQ([2.14.1])

sim_ac_xmedrawshadows_avail=no

AC_CACHE_CHECK(
  [for XmeDrawShadows() function in Motif library],
  sim_cv_lib_xmedrawshadows_avail,
  [AC_TRY_LINK([#include <Xm/Xm.h>],
               [XmeDrawShadows(0L, 0L, 0L, 0L, 0, 0, 0, 0, 0, 0);],
               [sim_cv_lib_xmedrawshadows_avail=yes],
               [sim_cv_lib_xmedrawshadows_avail=no])])

if test x"$sim_cv_lib_xmedrawshadows_avail" = xyes; then
  sim_ac_xmedrawshadows_avail=yes
  $1
else
  ifelse([$2], , :, [$2])
fi
])

# Usage:
#   SIM_CHECK_MOTIF_GLWIDGET([ ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND ]])
#
# Description:
#   This macro checks for a GL widget that can be used with Xt/Motif.
#
# Variables:
#   $sim_cv_motif_glwidget         (cached)  class + header + library
#   $sim_cv_motif_glwidget_hdrloc  (cached)  GL | X11/GLw
#
#   $sim_ac_motif_glwidget_class             glwMDrawingAreaWidgetClass |
#                                            glwDrawingAreaWidgetClass
#   $sim_ac_motif_glwidget_header            GLwDrawA.h | GLwMDrawA.h
#   $sim_ac_motif_glwidget_library           GLwM | GLw | MesaGLwM | MesaGLw
#
#   $LIBS = -l$sim_ac_motif_glwidget_library $LIBS
#
# Defines:
#   XT_GLWIDGET                              $sim_ac_motif_glwidget_class
#   HAVE_GL_GLWDRAWA_H                       #include <GL/GLwDrawA.h>
#   HAVE_GL_GLWMDRAWA_H                      #include <GL/GLwMDrawA.h>
#   HAVE_X11_GWL_GLWDRAWA_H                  #include <X11/GLw/GLwDrawA.h>
#   HAVE_X11_GWL_GLWMDRAWA_H                 #include <X11/GLw/GLwMDrawA.h>
#
# Authors:
#   Lars J. Aas <larsa@sim.no>,
#   Loring Holden <lsh@cs.brown.edu>,
#   Morten Eriksen <mortene@sim.no>
#

AC_DEFUN([SIM_CHECK_MOTIF_GLWIDGET], [

AC_CACHE_CHECK(
  [for a GL widget],
  sim_cv_motif_glwidget,
  [SAVELIBS=$LIBS
  sim_cv_motif_glwidget=UNKNOWN
  for lib in GLwM GLw MesaGLwM MesaGLw; do
    if test x"$sim_cv_motif_glwidget" = x"UNKNOWN"; then
      LIBS="-l$lib $SAVELIBS"
      AC_TRY_LINK(
        [#include <X11/Intrinsic.h>
        extern WidgetClass glwMDrawingAreaWidgetClass;],
        [Widget glxManager = NULL;
        Widget glxWidget = XtVaCreateManagedWidget("GLWidget",
          glwMDrawingAreaWidgetClass, glxManager, NULL);],
        [sim_cv_motif_glwidget="glwMDrawingAreaWidgetClass GLwMDrawA.h $lib"],
        [sim_cv_motif_glwidget=UNKNOWN])
    fi
    if test x"$sim_cv_motif_glwidget" = x"UNKNOWN"; then
      LIBS="-l$lib $SAVELIBS"
      AC_TRY_LINK(
        [#include <X11/Intrinsic.h>
        extern WidgetClass glwDrawingAreaWidgetClass;],
        [Widget glxManager = NULL;
        Widget glxWidget = XtVaCreateManagedWidget("GLWidget",
          glwDrawingAreaWidgetClass, glxManager, NULL);],
        [sim_cv_motif_glwidget="glwDrawingAreaWidgetClass GLwDrawA.h $lib"],
        [sim_cv_motif_glwidget=UNKNOWN])
    fi
  done
  LIBS=$SAVELIBS
  ])

if test "x$sim_cv_motif_glwidget" = "xUNKNOWN"; then
  ifelse([$2], , :, [$2])
else
  sim_ac_motif_glwidget_class=`echo $sim_cv_motif_glwidget | cut -d" " -f1`
  sim_ac_motif_glwidget_header=`echo $sim_cv_motif_glwidget | cut -d" " -f2`
  sim_ac_motif_glwidget_library=`echo $sim_cv_motif_glwidget | cut -d" " -f3`

  AC_CACHE_CHECK(
    [the $sim_ac_motif_glwidget_header header location],
    sim_cv_motif_glwidget_hdrloc,
    [sim_cv_motif_glwidget_hdrloc=UNKNOWN
    for location in X11/GLw GL; do
      if test "x$sim_cv_motif_glwidget_hdrloc" = "xUNKNOWN"; then
        AC_TRY_CPP(
          [#include <X11/Intrinsic.h>
          #include <$location/$sim_ac_motif_glwidget_header>],
          [sim_cv_motif_glwidget_hdrloc=$location],
          [sim_cv_motif_glwidget_hdrloc=UNKNOWN])
      fi
    done])

  if test "x$sim_cv_motif_glwidget_hdrloc" = "xUNKNOWN"; then
    ifelse([$2], , :, [$2])
  else
    if test "x$sim_ac_motif_glwidget_header" = "xGLwDrawA.h"; then
      if test "x$sim_cv_motif_glwidget_hdrloc" = "xGL"; then
        AC_DEFINE(HAVE_GL_GLWDRAWA_H, 1,
          [Define this to use OpenGL widget from <GL/GLwDrawA.h>])
      else
        AC_DEFINE(HAVE_X11_GLW_GLWDRAWA_H, 1,
          [Define this to use OpenGL widget from <X11/GLw/GLwDrawA.h>])
      fi
    else
      if test "x$sim_cv_motif_glwidget_hdrloc" = "xGL"; then
        AC_DEFINE(HAVE_GL_GLWMDRAWA_H, 1,
          [Define this to use OpenGL widget from <GL/GLwMDrawA.h>])
      else
        AC_DEFINE(HAVE_X11_GLW_GLWMDRAWA_H, 1,
          [Define this to use OpenGL widget from <X11/GLw/GLwMDrawA.h>])
      fi
    fi

    AC_DEFINE_UNQUOTED(XT_GLWIDGET, $sim_ac_motif_glwidget_class,
      [Define this to the Xt/Motif OpenGL widget class to use])

    LIBS="-l$sim_ac_motif_glwidget_library $LIBS"

    $1
  fi
fi
])

# Usage:
#  SIM_AC_MOTIF_VERSION
#
# Find version number of the Motif library. sim_ac_motif_version will
# contain the full version number string, and
# sim_ac_motif_major_version will contain only the major version
# number. (based on SIM_AC_QT_VERSION)
#
# Authors:
#   Tamer Fahmy <tamer@sim.no>,

AC_DEFUN([SIM_AC_MOTIF_VERSION], [

AC_CACHE_CHECK([version of Motif library], sim_ac_motif_version, [
  AC_RUN_IFELSE(
    [AC_LANG_SOURCE([
#include <stdio.h>
#include <Xm/Xm.h>

int
main(int argc, char **argv)
{
  FILE * fd;
  fd = fopen("conftest.out", "w");
  fprintf(fd, "%d.%d.%d", XmVERSION, XmREVISION, XmUPDATE_LEVEL);
  fclose(fd);

  return 0;
}
  ])],
  [sim_ac_motif_version=`cat conftest.out`],
  [AC_MSG_FAILURE([could not determine the version of the Motif library])])
])

sim_ac_motif_major_version=`echo $sim_ac_motif_version | cut -c1`
])

