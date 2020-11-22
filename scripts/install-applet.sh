#!/bin/sh
mkdir -p build && \
cd build && \
cmake .. && \
make clean && \
make && \
sudo make install
cd ..
