#!/bin/bash
################################################################################
#  THIS FILE IS 100% GENERATED BY ZPROJECT; DO NOT EDIT EXCEPT EXPERIMENTALLY  #
#  Read the zproject/README.md for information about making permanent changes. #
################################################################################
#   Build JNI interface for Android
#
#   Requires these environment variables be set, e.g.:
#
#     ANDROID_NDK_ROOT=$HOME/android-ndk-r24
#
#   Exit if any step fails
set -e

# Set this to enable verbose profiling
[ -n "${CI_TIME-}" ] || CI_TIME=""
case "$CI_TIME" in
    [Yy][Ee][Ss]|[Oo][Nn]|[Tt][Rr][Uu][Ee])
        CI_TIME="time -p " ;;
    [Nn][Oo]|[Oo][Ff][Ff]|[Ff][Aa][Ll][Ss][Ee])
        CI_TIME="" ;;
esac

# Set this to enable verbose tracing
[ -n "${CI_TRACE-}" ] || CI_TRACE="no"
case "$CI_TRACE" in
    [Nn][Oo]|[Oo][Ff][Ff]|[Ff][Aa][Ll][Ss][Ee])
        set +x ;;
    [Yy][Ee][Ss]|[Oo][Nn]|[Tt][Rr][Uu][Ee])
        set -x
        MAKE_OPTIONS=VERBOSE=1
        ;;
esac

function usage {
    echo "Usage ./build.sh [ arm | arm64 | x86 | x86_64 ]"
}

BUILD_ARCH=$1
if [ -z $BUILD_ARCH ]; then
    usage
    exit 1
fi

source ../../../../builds/android/android_build_helper.sh

export MIN_SDK_VERSION=21
export ANDROID_BUILD_DIR=/tmp/android_build

#   Build any dependent libraries
#   Use a default value assuming that dependent libraries sits alongside this one

#   Ensure we've built dependencies for Android
echo "********  Building CZMQ Android native libraries"
( cd ../../../../builds/android && ./build.sh $BUILD_ARCH )

#   Ensure we've built JNI interface
echo "********  Building CZMQ JNI interface & classes"
( cd ../.. && TERM=dumb ./gradlew build jar -PbuildPrefix=$BUILD_PREFIX --info )

echo "********  Building CZMQ JNI for Android"
rm -rf build && mkdir build && cd build
# Export android build's environment variables for cmake
android_build_set_env $BUILD_ARCH
(
    VERBOSE=1 \
    cmake \
        -DANDROID_ABI=$TOOLCHAIN_ABI \
        -DANDROID_PLATFORM=$MIN_SDK_VERSION \
        -DANDROID_STL=c++_shared \
        -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake \
        -DCMAKE_FIND_ROOT_PATH=$ANDROID_BUILD_PREFIX \
        ..
)

#   CMake wrongly searches current directory and then toolchain path instead
#   of lib path for these files, so make them available temporarily
ln -s $ANDROID_SYS_ROOT/usr/lib/crtend_so.o
ln -s $ANDROID_SYS_ROOT/usr/lib/crtbegin_so.o

make $MAKE_OPTIONS

echo "********  Building jar for $TOOLCHAIN_ABI"
#   Copy class files into org/zeromq/etc.
find ../../build/libs/ -type f -name 'czmq-jni-*.jar' ! -name '*javadoc.jar' ! -name '*sources.jar' -exec unzip -q {} +

#   Copy native libraries into lib/$TOOLCHAIN_ABI
mkdir -p lib/$TOOLCHAIN_ABI
cp libczmqjni.so lib/$TOOLCHAIN_ABI
cp $ANDROID_BUILD_PREFIX/lib/*.so lib/$TOOLCHAIN_ABI
cp $ANDROID_NDK_ROOT/sources/cxx-stl/llvm-libc++/libs/$TOOLCHAIN_ABI/libc++_shared.so lib/$TOOLCHAIN_ABI

#   Build android jar
zip -r -m ../czmq-android-$TOOLCHAIN_ABI-4.2.2.jar lib/ org/ META-INF/
cd ..
rm -rf build

echo "********  Merging ABI jars"
mkdir build && cd build
#   Copy contents from all ABI jar - overwriting class files and manifest
unzip -qo '../czmq-android-*4.2.2.jar'
#   Build merged jar
zip -r -m ../czmq-android-4.2.2.jar lib/ org/ META-INF/
cd ..
rm -rf build

echo "********  Complete"
