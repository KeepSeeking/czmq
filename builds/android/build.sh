#!/usr/bin/env bash
################################################################################
#  THIS FILE IS 100% GENERATED BY ZPROJECT; DO NOT EDIT EXCEPT EXPERIMENTALLY  #
#  Read the zproject/README.md for information about making permanent changes. #
################################################################################

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
        set -x ;;
esac

function usage {
    echo "Usage ./build.sh [ arm | arm64 | x86 | x86_64 ]"
}

# Use directory of current script as the build directory and working directory
cd "$( dirname "${BASH_SOURCE[0]}" )"
ANDROID_BUILD_DIR="${ANDROID_BUILD_DIR:-`pwd`}"

# Get access to android_build functions and variables
source ./android_build_helper.sh

BUILD_ARCH=$1
if [ -z $BUILD_ARCH ]; then
    usage
    exit 1
fi

case $(uname | tr '[:upper:]' '[:lower:]') in
  linux*)
    export HOST_PLATFORM=linux-x86_64
    ;;
  darwin*)
    export HOST_PLATFORM=darwin-x86_64
    ;;
  *)
    echo "Unsupported platform"
    exit 1
    ;;
esac

# Set default values used in ci builds
export NDK_VERSION=${NDK_VERSION:-android-ndk-r21e}
# With NDK r21e, the minimum SDK version range is [16, 29].
# SDK version 21 is the minimum version for 64-bit builds.
export MIN_SDK_VERSION=${MIN_SDK_VERSION:-21}

# Set up android build environment and set ANDROID_BUILD_OPTS array
android_build_set_env $BUILD_ARCH
android_build_env
android_build_opts

# Use a temporary build directory
cache="/tmp/android_build/${TOOLCHAIN_ARCH}"
rm -rf "${cache}"
mkdir -p "${cache}"

# Check for environment variable to clear the prefix and do a clean build
if [[ $ANDROID_BUILD_CLEAN ]]; then
    echo "Doing a clean build (removing previous build and depedencies)..."
    rm -rf "${ANDROID_BUILD_PREFIX}"/*
fi

##
# Make sure libzmq is built and copy the prefix

(android_build_verify_so "libzmq.so" &> /dev/null) || {
    # Use a default value assuming the libzmq project sits alongside this one
    test -z "$LIBZMQ_ROOT" && LIBZMQ_ROOT="$(cd ../../../libzmq && pwd)"

    if [ ! -d "$LIBZMQ_ROOT" ]; then
        echo "The LIBZMQ_ROOT directory does not exist"
        echo "  ${LIBZMQ_ROOT}" run run
        exit 1
    fi
    echo "Building libzmq in ${LIBZMQ_ROOT}..."

    (bash ${LIBZMQ_ROOT}/builds/android/build.sh $BUILD_ARCH) || exit 1
    UPSTREAM_PREFIX=${LIBZMQ_ROOT}/builds/android/prefix/${TOOLCHAIN_ARCH}
    cp -rn ${UPSTREAM_PREFIX}/* ${ANDROID_BUILD_PREFIX}
}

##
[ -z "$CI_TIME" ] || echo "`date`: Build czmq from local source"

(android_build_verify_so "libczmq.so" "libzmq.so" &> /dev/null) || {
    rm -rf "${cache}/czmq"
    (cp -r ../.. "${cache}/czmq" && cd "${cache}/czmq" \
        && make clean && rm -f configure config.status)

    # Remove *.la files as they might cause errors with cross compiled libraries
    find ${ANDROID_BUILD_PREFIX} -name '*.la' -exec rm {} +

    export LIBTOOL_EXTRA_LDFLAGS='-avoid-version'

    (cd "${cache}/czmq" && $CI_TIME ./autogen.sh 2> /dev/null \
        && $CI_TIME ./configure --quiet "${ANDROID_BUILD_OPTS[@]}" --without-docs \
        && $CI_TIME make -j 4 \
        && $CI_TIME make install) || exit 1
}

##
# Verify shared libraries in prefix

android_build_verify_so "libzmq.so"
android_build_verify_so "libczmq.so" "libzmq.so"
echo "Android (${TOOLCHAIN_ARCH}) build successful"
################################################################################
#  THIS FILE IS 100% GENERATED BY ZPROJECT; DO NOT EDIT EXCEPT EXPERIMENTALLY  #
#  Read the zproject/README.md for information about making permanent changes. #
################################################################################
