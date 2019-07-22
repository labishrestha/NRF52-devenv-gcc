FROM ubuntu:xenial
# Setup
RUN dpkg --add-architecture i386 && \
  apt-get update && apt-get install -y \
            wget \
            curl \
            adb \
            bzip2 \
            checkinstall \
            expect \
            git \
            lib32ncurses5 \
            libc6:i386 \
            libtool \
            libhidapi-dev \
            libhidapi-hidraw0 \
            libusb-0.1-4 \
            libusb-1.0-0 \
            libusb-1.0-0-dev \
            libusb-dev \
            make \
            python2.7 \
            ruby-full \
            automake \
            autotools-dev \
            pkg-config \
            sudo

# Download and install arm-gcc
RUN wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2
RUN tar -xf gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2 -C /usr/local

# Download and install nrfjprog
RUN wget https://www.nordicsemi.com/-/media/Software-and-other-downloads/Desktop-software/nRF-command-line-tools/sw/Versions-10-x-x/nRFCommandLineTools1021Linuxamd64tar.gz
RUN tar -xvzf nRFCommandLineTools1021Linuxamd64tar.gz
RUN dpkg -R --install *.deb

# Download and install openocd
RUN mkdir -p /usr/src/; cd /usr/src/ \
    && git clone --depth 1 https://github.com/ntfreak/openocd.git \
    && cd openocd \
    && ./bootstrap \
    && ./configure --enable-stlink --enable-jlink --enable-ftdi --enable-cmsis-dap \
    && make -j"$(nproc)" \
    && make install-strip \
    && cp /usr/src/openocd/contrib/60-openocd.rules /etc/udev/rules.d/60-openocd.rules \
    && cd .. \
    && rm -rf openocd \
    && echo 'set auto-load safe-path /' >> ~/.gdbinit

# Clone CMSIS libraries
RUN cd /usr/src/ && git clone https://github.com/ARM-software/CMSIS.git

# Install pip
RUN cd /usr/local/ && wget https://bootstrap.pypa.io/get-pip.py && python2.7 get-pip.py
RUN pip install nrfutil
