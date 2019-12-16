#!/bin/bash
set -e

g++ -g -c -O2 -fPIC -o plugin.o main.cpp
g++ -shared -o so-plugin.so plugin.o
objcopy --only-keep-debug so-plugin.so so-plugin.debug
strip --strip-debug so-plugin.so
