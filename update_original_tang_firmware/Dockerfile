# https://qiita.com/ciniml/items/05ac7fd2515ceed3f88d

FROM debian:bullseye
MAINTAINER Tim Molteno "tim@elec.ac.nz"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y &&  apt-get install -y \
    python3-pip python3-numpy python3-dateutil \
    libftdi1-2 libftdi1-dev libhidapi-libusb0 libhidapi-dev libudev-dev \
    cmake pkg-config make g++ wget unzip \
    git sdcc make binutils

RUN apt-get install -y usbutils libusb-dev
RUN apt-get clean -y
RUN rm -rf /var/lib/apt/lists/*

# setup working directory
WORKDIR /src
RUN git clone --recursive https://github.com/diodep/ch55x_jtag
WORKDIR /src/ch55x_jtag/src
RUN make
# File resides in ch55x_jtag/src/usb_jtag.bin

WORKDIR /src
RUN git clone https://github.com/trabucayre/jump_ch552_to_bl

RUN pip3 install ch55xtool


WORKDIR /work
RUN cp /src/jump_ch552_to_bl/jump_ch552_to_bl.py .
COPY to_dfu.py .
COPY update_tang.sh .
RUN ls
CMD ./update_tang.sh
