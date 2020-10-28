#!/bin/sh
mkdir -p build && \
cd build

if [ ! -f install_manifest.txt ]; then
    cmake .. && \
    make && \
    sudo make install
fi

if [ $? -eq 0 ]; then
    sudo make uninstall
fi

cd ..
