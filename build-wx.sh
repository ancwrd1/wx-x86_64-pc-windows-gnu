#!/bin/bash

basedir="$(cd $(dirname $0) && pwd -P)"
target="$basedir/build"
gitref=$(cat "$basedir/git-ref")
buildlog="$target/build.log"

mkdir -p $target
cd $target

rm -f $buildlog

if [[ ! -e "$target/wxWidgets/.git" ]]; then
    echo "Cloning wxWidgets repository"
    git clone --recurse-submodules https://github.com/wxWidgets/wxWidgets.git 2>>$buildlog >>$buildlog
    if [[ "$?" != "0" ]]; then
    echo "FATAL: error while running git clone, check $buildlog"
        exit 1
    fi
fi

echo "Checking out $gitref"
git -C wxWidgets checkout $gitref 2>>$buildlog >>$buildlog
git -C wxWidgets submodule update --recursive 2>>$buildlog >>$buildlog

mkdir -p mingw64
cd mingw64

echo "Configuring for cmake build"
cmake -DCMAKE_INSTALL_PREFIX=$target/target \
      -DCMAKE_SYSTEM_NAME=Windows \
      -DCMAKE_CXX_STANDARD=14 \
      -DCMAKE_C_COMPILER=x86_64-w64-mingw32-gcc \
      -DCMAKE_CXX_COMPILER=x86_64-w64-mingw32-g++ \
      -DCMAKE_BUILD_TYPE=Release \
      -DwxBUILD_MONOLITHIC=ON \
      -DwxUSE_STL=ON \
      -DwxUSE_WEBVIEW=ON \
      -DwxUSE_WEBVIEW_EDGE=ON \
      -DwxBUILD_VENDOR=eop \
      -DwxBUILD_COMPATIBILITY=3.1 \
      -DwxBUILD_USE_STATIC_RUNTIME=ON \
      -DwxBUILD_OPTIMISE=ON \
      -DwxBUILD_SHARED=OFF \
      -DwxUSE_LIBMSPACK=OFF \
      -G Ninja \
      ../wxWidgets 2>>$buildlog >>$buildlog

if [[ "$?" != "0" ]]; then
    echo "FATAL: error while running cmake, check $buildlog"
    exit 1
fi

echo "Building wxWidgets for mingw64"
ninja install 2>>$buildlog >>$buildlog

echo "Replacing headers and libraries"
rm -rf $basedir/include
rm -rf $basedir/lib

rsync -a $target/target/include $basedir/
rsync -a $target/target/lib/gcc_x64_lib/* $basedir/lib/
