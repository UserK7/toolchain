#!/bin/bash
#
# Realtek Semiconductor Corp.
#
# Tony Wu (tonywu@realtek.com)
# Dec. 7, 2010
#

if [ $# -lt 3 ]; then
    echo "usage: $0 DIR_WRAPPER TARGET_NAME CFLAGS"
    exit 1
fi

DIR_WRAPPER=$1; shift
TARGET_NAME=$1; shift
CFLAGS=$*
TARGET_PREFIX=${TARGET_NAME}-

DIR_LIBC=${DIR_WRAPPER}/config/glibc
DIR_SUMP=${DIR_WRAPPER}/sump/glibc
DIR_SYSROOT=${DIR_WRAPPER}/${TARGET_NAME}

# Check hard-float for MIPS/RLX
# (this option is removed since glibc-2.27).
with_fp="true"
(echo \
    | ${TARGET_PREFIX}gcc ${CFLAGS} -dM -E - \
    | grep "\(__mips_soft_float\|__SOFTFP__\)" > /dev/null 2>&1) && with_fp="false"
if [[ "${with_fp}" == 'false' ]]; then
	CONFIG_FLOAT="--without-fp"
else
	CONFIG_FLOAT="--with-fp"
fi

# auto-detect build name
HOST_NAME=$(uname | tr '[:upper:]' '[:lower:]' \
               | sed -e 's,\(linux\|darwin\|cygwin\).*,\1,')

HOST_ARCH=$(uname -m)

if [ x${HOST_NAME} = x'darwin' ]; then
	HOST_TYPE=apple
else
	HOST_TYPE=pc
fi

BUILD_NAME=${HOST_ARCH}-${HOST_TYPE}-${HOST_NAME}
BUILD_CC="gcc"
# From crosstool-ng:
# CFLAGS are only applied when compiling .c files. .S files are compiled with ASFLAGS,
# but they are not passed by configure. Thus, pass everything in CC instead.
CC="${TARGET_PREFIX}gcc ${CFLAGS}"
# The CFLAGS variable needs to be cleared, else the default "-g -O2"
# would override previous flags.
CFLAGS=""
AR="${TARGET_PREFIX}ar"
RANLIB="${TARGET_PREFIX}ranlib"

export BUILD_CC CC AR RANLIB CFLAGS

##
## config
##
PATH=${DIR_WRAPPER}/bin:$PATH
mkdir -p ${DIR_SUMP}
#cp ${DIR_LIBC}/option-groups.defaults ${DIR_SUMP}/option-groups.config

cd ${DIR_SUMP}
libc_cv_slibdir="/usr/lib"				\
use_ldconfig=no						\
${DIR_LIBC}/configure					\
	--prefix=					\
	--bindir=/usr/bin				\
	--sbindir=/usr/sbin				\
	--datarootdir=/usr/share			\
	--build=${BUILD_NAME}				\
	--host=${TARGET_NAME}				\
	--with-headers=${DIR_SYSROOT}/include		\
	--disable-werror				\
	--disable-profile				\
	${CONFIG_FLOAT}					\
	--without-gd					\
	--without-cvs					\
	--enable-obsolete-rpc				\
	--enable-add-ons

##
## compile and install
##
make all || exit 1
make install DESTDIR=${DIR_SYSROOT} || exit 1

for f in ${DIR_SYSROOT}/usr/lib/libc.so ${DIR_SYSROOT}/usr/lib/libpthread.so ; do
    if [ "$(file --mime-type -b $f)" = "text/plain" ]; then
        sed -i -e 's,/usr/lib/,,g' "$f"
    fi
done

for f in ${DIR_SYSROOT}/usr/bin/tzselect ${DIR_SYSROOT}/usr/bin/ldd ; do
    if [ "$(file --mime-type -b $f)" = "text/plain" ]; then
        sed -i -e 's,/usr/bin,/bin,' "$f" ;
    fi
done

##
## postifx
##
mkdir -p ${DIR_SYSROOT}/usr/lib/libpthread_pic
mkdir -p ${DIR_SYSROOT}/usr/sbin
cp ${DIR_SUMP}/nptl/libpthread_pic.a ${DIR_SYSROOT}/usr/lib/libpthread_pic.a
cp ${DIR_SUMP}/libpthread.map ${DIR_SYSROOT}/usr/lib/libpthread_pic.map
cp ${DIR_SUMP}/nptl/crt*.o ${DIR_SYSROOT}/usr/lib/libpthread_pic
for f in ${DIR_SYSROOT}/sbin/* ; do
    n=`basename $f`
    if [ $n != 'sln' -a $n != 'ldconfig' ] ; then
        mv ${DIR_SYSROOT}/sbin/$n ${DIR_SYSROOT}/usr/sbin ;
    fi
done
