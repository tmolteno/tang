FROM debian:bullseye
MAINTAINER Tim Molteno "tim@elec.ac.nz"
ARG DEBIAN_FRONTEND=noninteractive

# curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

RUN apt-get update -y &&  apt-get install -y \
    python3-pip python3-numpy python3-dateutil \
    libftdi1-2 libftdi1-dev libhidapi-libusb0 libhidapi-dev libudev-dev cmake pkg-config make g++

RUN apt-get install -y tree wget unzip
RUN apt-get clean -y
RUN rm -rf /var/lib/apt/lists/*

# setup working directory
WORKDIR /src
RUN wget https://github.com/trabucayre/openFPGALoader/archive/refs/heads/master.zip
RUN unzip master.zip
RUN ls
WORKDIR /src/openFPGALoader-master/build
RUN cmake ..
RUN cmake --build .
RUN make install
CMD openFPGALoader -v -b ${BOARD} /files/${BIN}
# RUN mkdir -p dist/etc/udev/rules.d/
# RUN cp ../99-openfpgaloader.rules dist/etc/udev/rules.d/
# RUN mkdir -p dist/usr/local/share/licenses/openFPGALoader
# RUN install -m 644 ../LICENSE dist/usr/local/share/licenses/openFPGALoader
