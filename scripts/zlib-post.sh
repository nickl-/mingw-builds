#!/bin/bash

#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of 'mingw-builds' project.
# Copyright (c) 2011,2012, by niXman (i dotty nixman doggy gmail dotty com)
# All rights reserved.
#
# Project: mingw-builds ( http://sourceforge.net/projects/mingwbuilds/ )
#
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
# - Redistributions of source code must retain the above copyright 
#     notice, this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright 
#     notice, this list of conditions and the following disclaimer in 
#     the documentation and/or other materials provided with the distribution.
# - Neither the name of the 'mingw-builds' nor the names of its contributors may 
#     be used to endorse or promote products derived from this software 
#     without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
# A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY 
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS 
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# **************************************************************************

[[ ! -f $BUILDS_DIR/zlib-post.marker ]] && {
	
	ZLIB_VERSION=$( grep 'VERSION=' $TOP_DIR/scripts/zlib.sh | sed 's|VERSION=||' )
	mkdir -p $BUILDS_DIR/zlib-${ZLIB_VERSION}

	cp -rf $SRCS_DIR/zlib-${ZLIB_VERSION} $BUILDS_DIR || exit 1
	
	cd $BUILDS_DIR/zlib-${ZLIB_VERSION}
	
	make -f win32/Makefile.gcc \
		CC=$HOST-gcc \
		AR=ar \
		RC=windres \
		DLLWRAP=dllwrap \
		STRIP=strip \
		-j$JOBS \
		all > $CURR_LOGS_DIR/zlib-${ZLIB_VERSION}/make.log || exit 1
	
	make -f win32/Makefile.gcc \
		INCLUDE_PATH=$PREFIX/include \
		LIBRARY_PATH=$PREFIX/lib \
		BINARY_PATH=$PREFIX/bin \
		SHARED_MODE=1 \
		install > $CURR_LOGS_DIR/zlib-${ZLIB_VERSION}/install.log || exit 1
	
	rm -rf $PREFIX/lib/libz.a
	
	touch $BUILDS_DIR/zlib-post.marker
}

# **************************************************************************
