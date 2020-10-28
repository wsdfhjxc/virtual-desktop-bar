#!/bin/sh
mkdir -p build && \
cd build && \
cmake .. && \
make && \
sudo make install
cd ..
