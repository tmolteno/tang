#!/bin/bash
sudo apt-get update -y &&  sudo apt-get install -y \
    python3-pip python3-numpy python3-dateutil \
    libftdi1-2 libftdi1-dev libhidapi-libusb0 libhidapi-dev libudev-dev \
    cmake pkg-config make g++ wget unzip

# setup working directory
mkdir ./tmp_build
pushd ./tmp_build
wget https://github.com/trabucayre/openFPGALoader/archive/refs/heads/master.zip
unzip master.zip
cd openFPGALoader-master
mkdir -p build
cd build
cmake ..
cmake --build .
sudo make install
popd
