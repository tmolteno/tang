#!/bin/bash
sudo apt-get update -y &&  sudo apt-get install -y \
    python3-pip python3-numpy python3-dateutil \
    libftdi1-2 libftdi1-dev libhidapi-libusb0 libhidapi-dev libudev-dev \
    cmake pkg-config make g++ wget unzip

# setup working directory
rm -rf ./tmp_build
mkdir ./tmp_build
pushd ./tmp_build
curl -LJ `curl -s https://api.github.com/repos/trabucayre/openFPGALoader/releases/latest | python3  -c 'import sys, json; print(json.load(sys.stdin)["tarball_url"])'` | tar zxf - --strip=1
#wget https://github.com/trabucayre/openFPGALoader/archive/refs/heads/master.zip
#unzip master.zip
#cd openFPGALoader-master
mkdir -p build
cd build
cmake ..
cmake --build .
sudo make install
popd
sudo mv ./tmp_build/99-openfpgaloader.rules /etc/udev/rules.d/
