#!/bin/bash
# set -e

g++ -g -c -O2 -fPIC -o ../Build/plugin.o ../CPP/$1 -I/opt/ros/melodic/include -L/opt/ros/melodic/lib \
-Wl,-rpath,/opt/ros/melodic/lib -lroscpp -lrosconsole -lrostime \
-lroscpp_serialization -lboost_system -lboost_thread -pthread -lactionlib

# g++ -g -c -O2 -fPIC -o plugin.o main.cpp

g++ -shared -o ../Build/so-plugin.so ../Build/plugin.o
objcopy --only-keep-debug ../Build/so-plugin.so ../Build/so-plugin.debug
strip --strip-debug ../Build/so-plugin.so
sudo rm -rf ../Assets/Plugins/Linux/*
sudo cp ../Build/so-plugin.debug ../../Assets/Plugins/
sudo cp ../Build/so-plugin.so ../../Assets/Plugins/
