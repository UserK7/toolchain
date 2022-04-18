#!/bin/bash
#
# Realtek Semiconductor Corp.
#
# Tony Wu (tonywu@realtek.com)
# Dec. 7, 2010
#

if [ $# -lt 3 ]; then
    echo "usage: $0 dir_wrapper target_name cflags"
    exit 1
fi

DIR_WRAPPER=$1; shift
TARGET_NAME=$1; shift
TARGET_CFLAGS=$*
TARGET_PREFIX=${TARGET_NAME}-

DIR_LIBC=${DIR_WRAPPER}/config/glibc
DIR_SUMP=${DIR_WRAPPER}/sump
DIR_TMPFS=${DIR_WRAPPER}/tmpfs
DIR_SYSROOT=${DIR_WRAPPER}/${TARGET_NAME}

if [[ ${TARGET_PREFIX} =~ ^mips.* ]]; then
	CONFIG_SPECIFIC="--with-mips-plt"
fi

with_fp="true"
(echo | ${TARGET_PREFIX}gcc ${TARGET_CFLAGS} -dM -E - | grep "\(__mips_soft_float\|__SOFTFP__\)" 2>&1 > /dev/null) && with_fp="false"
if [ x${with_fp} = x'false' ]; then
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
AR="${TARGET_PREFIX}ar"
AS="${TARGET_PREFIX}gcc -c ${TARGET_CFLAGS}"
LD="${TARGET_PREFIX}ld"
NM="${TARGET_PREFIX}nm"
CPP="${TARGET_PREFIX}cpp ${TARGET_CFLAGS}"
CC="${TARGET_PREFIX}gcc ${TARGET_CFLAGS}"
CXX="${TARGET_PREFIX}g++ ${TARGET_CFLAGS}"
RANLIB="${TARGET_PREFIX}ranlib"
CFLAGS="-O2 -pipe -funit-at-a-time"
export BUILD_CC AR AS LD NM CC CPP CXX RANLIB CFLAGS

##
## config
##
mkdir -p ${DIR_SUMP}
#cp ${DIR_LIBC}/option-groups.defaults ${DIR_SUMP}/option-groups.config

cd ${DIR_SUMP}
libc_cv_slibdir="/lib"					\
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
	${CONFIG_SPECIFIC}				\
	--without-gd					\
	--without-cvs					\
	--enable-obsolete-rpc				\
	--enable-add-ons

##
## compile and install
##
make all || exit 1
make install DESTDIR=${DIR_SYSROOT} || exit 1

for f in ${DIR_SYSROOT}/lib/libc.so ${DIR_SYSROOT}/lib/libpthread.so ; do
    if [ "$(file --mime-type -b $f)" = "text/plain" ]; then
        sed -i -e 's,/lib/,,g' "$f"
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
