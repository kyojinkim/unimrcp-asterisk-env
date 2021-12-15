#!/bin/bash
set -e

nCPU=$1
if [ -z "$nCPU" ]; then
    nCPU="1"
fi

echo "## Using $nCPU-cpu for build" 

ROOTDIR=`pwd`

build_config() {
    contrib/scripts/get_mp3_source.sh
    contrib/scripts/install_prereq install

    ./configure --with-pjproject-bundled --with-ogg --with-opus --with-resample --with-speex --with-sqlite3
}

build_menuselect() {
    make -j $nCPU menuselect.makeopts
    menuselect/menuselect --enable-category MENUSELECT_ADDONS \
    --enable-category MENUSELECT_APPS \
    --enable-category MENUSELECT_BRIDGES \
    --enable-category MENUSELECT_CDR \
    --enable-category MENUSELECT_CEL \
    --enable-category MENUSELECT_CHANNELS \
    --enable-category MENUSELECT_CODECS \
    --enable-category MENUSELECT_FORMATS \
    --enable-category MENUSELECT_FUNCS \
    --enable-category MENUSELECT_PBX \
    --enable-category MENUSELECT_RES \
    --enable-category MENUSELECT_UTILS \
    --enable-category MENUSELECT_MOH \
    --enable BETTER_BACKTRACES \
    --enable MOH-OPSOUND-WAV \
    --disable MOH-OPSOUND-GSM \
    --disable app_voicemail \
    --disable LOW_MEMORY \
    --enable BUILD_NATIVE \
    --disable MALLOC_DEBUG \
    --enable OPTIONAL_API \
    --disable DONT_OPTIMIZE \
    --disable res_digium_phone
}

build() {
    make -j $nCPU
    make install
    make install-headers
    make install samples
    make config
    ldconfig
}

build_config
build_menuselect
build
