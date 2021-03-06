#!/bin/bash

#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of 'mingw-builds' project.
# Copyright (c) 2011,2012,2013 by niXman (i dotty nixman doggy gmail dotty com)
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

[[ ! -d $PREFIX/mingw ]] && mkdir -p $PREFIX/mingw
[[ ! -d $PREFIX/$TARGET ]] && mkdir -p $PREFIX/$TARGET

[[ -f $BUILDS_DIR/mingw-w64-runtime-post.marker && ! -d $BUILDS_DIR/$GCC_NAME ]] && {
	rm -f $BUILDS_DIR/mingw-w64-runtime-post.marker
}

[[ ! -f $BUILDS_DIR/mingw-w64-runtime-post.marker ]] && {
	[[ $USE_MULTILIB == yes ]] && {
		RUNTIMEPREFIX=$RUNTIME_DIR/$ARCHITECTURE-mingw-w64-multi
	} || {
		RUNTIMEPREFIX=$RUNTIME_DIR/$ARCHITECTURE-mingw-w64-nomulti
	}
	
	cp -rf $RUNTIMEPREFIX/* $PREFIX/$TARGET || exit 1
	cp -rf $RUNTIMEPREFIX/* $PREFIX/mingw || exit 1
	
	[[ $USE_MULTILIB == yes ]] && {
		[[ $ARCHITECTURE == x32 ]] && {
			mkdir -p $PREFIX/bin $PREFIX/$TARGET/{lib,lib64,include}
			
			cp -f $PREREQ_DIR/libiconv-x32-$LINK_TYPE_SUFFIX/lib/*.a $PREFIX/$TARGET/lib/ || exit 1
			cp -f $PREREQ_DIR/libiconv-x64-$LINK_TYPE_SUFFIX/lib/*.a $PREFIX/$TARGET/lib64/ || exit 1
			cp -f $PREREQ_DIR/libiconv-x32-$LINK_TYPE_SUFFIX/include/*.h $PREFIX/$TARGET/include/ || exit 1

			cp -f $RUNTIME_DIR/winpthreads-x32/bin/libwinpthread-1.dll $PREFIX/bin/ || exit 1
			cp -f $RUNTIME_DIR/winpthreads-x32/bin/libwinpthread-1.dll $PREFIX/$TARGET/lib/ || exit 1
			cp -f $RUNTIME_DIR/winpthreads-x64/bin/libwinpthread-1.dll $PREFIX/$TARGET/lib64/ || exit 1

			cp -f $RUNTIME_DIR/winpthreads-x32/lib/*.a $PREFIX/$TARGET/lib/ || exit 1
			cp -f $RUNTIME_DIR/winpthreads-x64/lib/*.a $PREFIX/$TARGET/lib64/ || exit 1

			cp -f $RUNTIME_DIR/winpthreads-x32/include/*.h $PREFIX/$TARGET/include/ || exit 1

			mkdir -p $BUILDS_DIR/$GCC_NAME/$TARGET/64/{libgcc,libgfortran,libgomp,libitm,libquadmath,libssp,libstdc++-v3}
			echo $BUILDS_DIR/$GCC_NAME/$TARGET/64/{libgcc,libgfortran,libgomp,libitm,libquadmath,libssp,libstdc++-v3} \
				| xargs -n 1 cp $PREFIX/$TARGET/lib64/libwinpthread-1.dll || exit 1
		} || {
			mkdir -p $PREFIX/bin $PREFIX/$TARGET/{lib,lib32,include}
			
			cp -f $PREREQ_DIR/libiconv-x32-$LINK_TYPE_SUFFIX/lib/*.a $PREFIX/$TARGET/lib32/ || exit 1
			cp -f $PREREQ_DIR/libiconv-x64-$LINK_TYPE_SUFFIX/lib/*.a $PREFIX/$TARGET/lib/ || exit 1
			cp -f $PREREQ_DIR/libiconv-x32-$LINK_TYPE_SUFFIX/include/*.h $PREFIX/$TARGET/include/ || exit 1

			cp -f $RUNTIME_DIR/winpthreads-x32/bin/libwinpthread-1.dll $PREFIX/$TARGET/lib32/ || exit 1
			cp -f $RUNTIME_DIR/winpthreads-x64/bin/libwinpthread-1.dll $PREFIX/bin/ || exit 1
			cp -f $RUNTIME_DIR/winpthreads-x64/bin/libwinpthread-1.dll $PREFIX/$TARGET/lib/ || exit 1

			cp -f $RUNTIME_DIR/winpthreads-x32/lib/*.a $PREFIX/$TARGET/lib32/ || exit 1
			cp -f $RUNTIME_DIR/winpthreads-x64/lib/*.a $PREFIX/$TARGET/lib/ || exit 1

			cp -f $RUNTIME_DIR/winpthreads-x64/include/*.h $PREFIX/$TARGET/include/ || exit 1

			mkdir -p $BUILDS_DIR/$GCC_NAME/$TARGET/32/{libgcc,libgfortran,libgomp,libitm,libquadmath,libssp,libstdc++-v3}
			echo $BUILDS_DIR/$GCC_NAME/$TARGET/32/{libgcc,libgfortran,libgomp,libitm,libquadmath,libssp,libstdc++-v3} \
				| xargs -n 1 cp $PREFIX/$TARGET/lib32/libwinpthread-1.dll || exit 1
		}

		cp -rf $PREFIX/$TARGET/* $PREFIX/mingw/ || exit 1
	} || {
		mkdir -p $PREFIX/bin $PREFIX/$TARGET/{lib,include}
		
		[[ $ARCHITECTURE == x32 ]] && {
			cp -f $PREREQ_DIR/libiconv-x32-$LINK_TYPE_SUFFIX/lib/*.a $PREFIX/$TARGET/lib/ || exit 1
			cp -f $PREREQ_DIR/libiconv-x32-$LINK_TYPE_SUFFIX/include/*.h $PREFIX/$TARGET/include/ || exit 1

			cp -f $RUNTIME_DIR/winpthreads-x32/bin/libwinpthread-1.dll $PREFIX/bin/ || exit 1
			cp -f $RUNTIME_DIR/winpthreads-x32/bin/libwinpthread-1.dll $PREFIX/$TARGET/lib/ || exit 1
			cp -f $RUNTIME_DIR/winpthreads-x32/lib/*.a $PREFIX/$TARGET/lib/ || exit 1
			cp -f $RUNTIME_DIR/winpthreads-x32/include/*.h $PREFIX/$TARGET/include/ || exit 1
		} || {
			cp -f $PREREQ_DIR/libiconv-x64-$LINK_TYPE_SUFFIX/lib/*.a $PREFIX/$TARGET/lib/ || exit 1
			cp -f $PREREQ_DIR/libiconv-x64-$LINK_TYPE_SUFFIX/include/*.h $PREFIX/$TARGET/include/ || exit 1

			cp -f $RUNTIME_DIR/winpthreads-x64/bin/libwinpthread-1.dll $PREFIX/bin/ || exit 1
			cp -f $RUNTIME_DIR/winpthreads-x64/bin/libwinpthread-1.dll $PREFIX/$TARGET/lib/ || exit 1
			cp -f $RUNTIME_DIR/winpthreads-x64/lib/*.a $PREFIX/$TARGET/lib/ || exit 1
			cp -f $RUNTIME_DIR/winpthreads-x64/include/*.h $PREFIX/$TARGET/include/ || exit 1
		}

		cp -rf $PREFIX/$TARGET/* $PREFIX/mingw/ || exit 1
	}
	
	[[ $GCC_DEPS_LINK_TYPE == *--enable-shared* ]] && {
		cp -f $PREREQ_DIR/$HOST-$LINK_TYPE_SUFFIX/bin/*.dll $PREFIX/bin/
		cp -f $PREREQ_DIR/libiconv-$ARCHITECTURE-$LINK_TYPE_SUFFIX/bin/*.dll $PREFIX/bin/
	}

	touch $BUILDS_DIR/mingw-w64-runtime-post.marker || exit 1
}
# **************************************************************************
