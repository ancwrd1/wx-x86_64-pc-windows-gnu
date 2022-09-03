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
    git clone --recurse-submodules --depth 1 --branch $gitref https://github.com/wxWidgets/wxWidgets.git 2>>$buildlog >>$buildlog
    if [[ "$?" != "0" ]]; then
    echo "FATAL: error while running git clone, check $buildlog"
        exit 1
    fi
fi

echo "Patching wxWidgets"
sed -i 's/if(wxUSE_XRC)/if(FALSE)/g' wxWidgets/build/cmake/utils/CMakeLists.txt

mkdir -p mingw64
cd mingw64

echo "Configuring for cmake build"
cmake -DCMAKE_INSTALL_PREFIX=$target/target \
      -DCMAKE_SYSTEM_NAME=Windows \
      -DCMAKE_CXX_STANDARD=14 \
      -DCMAKE_C_COMPILER=x86_64-w64-mingw32-gcc \
      -DCMAKE_CXX_COMPILER=x86_64-w64-mingw32-g++ \
      -DCMAKE_BUILD_TYPE=Release \
      -DwxBUILD_COMPATIBILITY=3.1 \
      -DwxBUILD_MONOLITHIC=ON \
      -DwxBUILD_USE_STATIC_RUNTIME=ON \
      -DwxBUILD_OPTIMISE=ON \
      -DwxBUILD_SHARED=OFF \
      -DwxBUILD_DEBUG_LEVEL=0 \
      -DwxUSE_STL=ON \
      -DwxUSE_WEBVIEW=ON \
      -DwxUSE_WEBVIEW_EDGE=ON \
      -DwxUSE_HTML=ON \
      -DwxUSE_LIBMSPACK=OFF \
      -DwxUSE_LOG=OFF \
      -DwxUSE_LOGGUI=OFF \
      -DwxUSE_LOGWINDOW=OFF \
      -DwxUSE_LOG_DIALOG=OFF \
      -DwxUSE_DOC_VIEW_ARCHITECTURE=OFF \
      -DwxUSE_HELP=OFF \
      -DwxUSE_MS_HTML_HELP=OFF \
      -DwxUSE_WXHTML_HELP=OFF \
      -DwxUSE_AUI=OFF \
      -DwxUSE_PROPGRID=OFF \
      -DwxUSE_RIBBON=OFF \
      -DwxUSE_STC=OFF \
      -DwxUSE_MDI=OFF \
      -DwxUSE_MDI_ARCHITECTURE=OFF \
      -DwxUSE_MEDIACTRL=OFF \
      -DwxUSE_RICHTEXT=OFF \
      -DwxUSE_POSTSCRIPT=OFF \
      -DwxUSE_AFM_FOR_POSTSCRIPT=OFF \
      -DwxUSE_PRINTING_ARCHITECTURE=OFF \
      -G Ninja \
      ../wxWidgets 2>>$buildlog >>$buildlog

if [[ "$?" != "0" ]]; then
    echo "FATAL: error while running cmake, check $buildlog"
    exit 1
fi

echo "Building wxWidgets for mingw64"
ninja install 2>>$buildlog >>$buildlog

if [[ "$?" != "0" ]]; then
    echo "FATAL: error while running ninja, check $buildlog"
    exit 1
fi

echo "Replacing headers and libraries"
rm -rf $basedir/include
rm -rf $basedir/lib

rsync -a $target/target/include $basedir/
rsync -a $target/target/lib/gcc_x64_lib/* $basedir/lib/
