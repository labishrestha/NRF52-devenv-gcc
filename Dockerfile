FROM ubuntu:xenial

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

RUN wget https://launchpad.net/gcc-arm-embedded/4.9/4.9-2015-q3-update/+download/gcc-arm-none-eabi-4_9-2015q3-20150921-linux.tar.bz2
RUN mkdir -p /usr/local/ && tar -xf gcc-arm-none-eabi-4_9-2015q3-20150921-linux.tar.bz2 -C /usr/local

RUN wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2
RUN tar -xf gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2 -C /usr/local

RUN wget https://www.segger.com/downloads/jlink/JLink_Linux_V632g_x86_64.deb --post-data='submit=1&accept_license_agreement=accepted'
RUN dpkg -i JLink_Linux_V632g_x86_64.deb

RUN mkdir -p /usr/local/nrfjprog && wget -qO- https://www.nordicsemi.com/eng/nordic/download_resource/58852/29/98625018/94917 | tar -C /usr/local/nrfjprog/ -xvf -

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
RUN cd /usr/src/ && git clone https://github.com/ARM-software/CMSIS.git
RUN cd /usr/local/ && wget https://bootstrap.pypa.io/get-pip.py && python2.7 get-pip.py
RUN pip install nrfutil
