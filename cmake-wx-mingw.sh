#!/bin/bash

cmake -DCMAKE_INSTALL_PREFIX=/opt/wx/x86_64-w64-mingw32 \
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
      ../wxWidgets
