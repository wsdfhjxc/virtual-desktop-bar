#!/bin/sh

DIR=$(pwd)
SCRIPTS_DIR=$(dirname "$0")
BUILD_DIR="$SCRIPTS_DIR/../build"

mkdir -p "$BUILD_DIR" && \
cd "$BUILD_DIR" && \
cmake .. && \
make clean && \
make

CODE=$?
cd "$DIR"
exit $CODE
