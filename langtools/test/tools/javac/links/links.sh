#!/bin/sh

#
# Copyright (c) 2001, 2008, Oracle and/or its affiliates. All rights reserved.
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
#
# This code is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 only, as
# published by the Free Software Foundation.
#
# This code is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# version 2 for more details (a copy is included in the LICENSE file that
# accompanied this code).
#
# You should have received a copy of the GNU General Public License version
# 2 along with this work; if not, write to the Free Software Foundation,
# Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
#
# Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
# or visit www.oracle.com if you need additional information or have any
# questions.
#

# @test
# @bug 4266026
# @summary javac no longer follows symlinks
#
# @run shell links.sh


if [ "${TESTSRC}" = "" ]
then
  echo "TESTSRC not set.  Test cannot execute.  Failed."
  exit 1
fi
echo "TESTSRC=${TESTSRC}"
if [ "${TESTJAVA}" = "" ]
then
  echo "TESTJAVA not set.  Test cannot execute.  Failed."
  exit 1
fi
echo "TESTJAVA=${TESTJAVA}"
if [ "${TESTCLASSES}" = "" ]
then
  echo "TESTCLASSES not set.  Test cannot execute.  Failed."
  exit 1
fi
echo "TESTCLASSES=${TESTCLASSES}"
echo "CLASSPATH=${CLASSPATH}"

# set platform-dependent variables
OS=`uname -s`
case "$OS" in
  SunOS | Linux | Darwin )
    NULL=/dev/null
    PS=":"
    FS="/"
    ;;
  * )
    echo "Unrecognized system - test skipped."
    exit 0;
    ;;
esac

mkdir tmp
cp ${TESTSRC}/b/B.java tmp

rm -rf T.class B.class b/B.class "${TESTCLASSES}/a" "${TESTCLASSES}/classes"
ln -s `pwd`/tmp "${TESTCLASSES}/a"
mkdir "${TESTCLASSES}/classes"

"${TESTJAVA}/bin/javac" ${TESTTOOLVMOPTS} -sourcepath "${TESTCLASSES}" -d "${TESTCLASSES}/classes" "${TESTSRC}/T.java" 2>&1
