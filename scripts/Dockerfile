FROM ubuntu:bionic

########################
# Download dependencies
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y upgrade && \
    apt-get -y dist-upgrade && \
    apt-get update

RUN apt-get -y install \
    software-properties-common build-essential sudo git curl binutils unzip bzip2 vim gawk sox \
    openssl make autoconf automake libtool gcc g++ pkg-config subversion

RUN apt-get -y install \
    libedit-dev libjansson-dev libsqlite3-dev libssl-dev uuid-dev libxml2-dev libsrtp2-dev \
    libogg-dev libopus-dev libspeex-dev libspeexdsp-dev libresample1 libspeexdsp1 libsrtp2-1\
    sqlite3 ffmpeg odbc-postgresql


##############
# Environment
ENV UNIMRCP_DEPS_URL "https://www.unimrcp.org/project/component-view/unimrcp-deps-1-6-0-tar-gz/download"
ENV UNIMRCP_URL "https://github.com/unispeech/unimrcp/archive/refs/tags/unimrcp-1.7.0.tar.gz"
ENV ASTERISK_UNIMRCP_URL "https://github.com/unispeech/asterisk-unimrcp/archive/refs/tags/asterisk-unimrcp-1.8.0.tar.gz"
ENV ASTERISK_URL "http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-18-current.tar.gz"
#ENV ASTERISK_URL "http://downloads.asterisk.org/pub/telephony/asterisk/old-releases/asterisk-18.6.0.tar.gz"

ENV PATH /sources:$PATH

RUN export nCPU=$(cat /proc/cpuinfo  | grep processor | wc -l)


###################
# Download sources

# Asterisk
WORKDIR /sources
RUN curl -o asterisk.tar.gz "$ASTERISK_URL" && \
    tar zxf asterisk.tar.gz && \
    mv asterisk-* asterisk

# UniMRCP dependencie
WORKDIR /sources
RUN curl -o unimrcp-deps.tar.gz "$UNIMRCP_DEPS_URL" && \
    tar zxf unimrcp-deps.tar.gz && \
    mv unimrcp-deps-* unimrcp-deps

# UniMRCP
WORKDIR /sources
RUN curl -L -# -o unimrcp.tar.gz "$UNIMRCP_URL" && \
    tar zxf unimrcp.tar.gz && \
    mv unimrcp-unimrcp-* unimrcp

# Asterisk-UniMRCP
WORKDIR /sources
RUN curl -L -# -o asterisk-unimrcp.tar.gz "$ASTERISK_UNIMRCP_URL" && \
    tar zxf asterisk-unimrcp.tar.gz && \
    mv asterisk-unimrcp-asterisk-unimrcp-* asterisk-unimrcp


########
# Build

# Asterisk
WORKDIR /sources/asterisk
ADD build_asterisk.sh /sources/asterisk
RUN ./build_asterisk.sh ${nCPU}

# UniMRCP dependencies
WORKDIR /sources/unimrcp-deps
RUN ./build-dep-libs.sh -s

# UniMRCP
WORKDIR /sources/unimrcp
RUN ./bootstrap && \
    ./configure && \
    make -j ${nCPU} && \
    make install

# Asterisk-UniMRCP
WORKDIR /sources/asterisk-unimrcp
RUN ./bootstrap && \
    ./configure && \
    make -j ${nCPU} && \
    make install


#############
# Docker Env

WORKDIR /root
RUN echo "export LD_LIBRARY_PATH=/usr/local/lib" >> /root/.bashrc
RUN echo "export PATH=\$PATH:/usr/local/unimrcp/bin" >> /root/.bashrc

RUN echo "alias unimrcpserver='unimrcpserver -r /usr/local/unimrcp'" >> /root/.bashrc
RUN echo "alias unimrcpclient='unimrcpclient -r /usr/local/unimrcp'" >> /root/.bashrc
RUN echo "alias umc='umcp -r /usr/local/unimrcp'" >> /root/.bashrc
RUN echo "alias asrclient='asrclient -r /usr/local/unimrcp'" >> /root/.bashrc

# Regardless of the EXPOSE settings, it can be overrided by using the -p flag
EXPOSE 5060/udp
EXPOSE 10000-14000/udp
EXPOSE 3737/udp
EXPOSE 3747/tcp
