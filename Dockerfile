FROM ubuntu:xenial
MAINTAINER Suwat Saisema <suwat_sai@hotmail.com>

# Update system
RUN apt-get update 
RUN apt-get -y install apt-utils git

# Install RTPEngine package depedency
RUN apt-get -y install iptables-dev libxmlrpc-core-c3-dev libglib2.0-dev zlib1g-dev libssl-dev libpcre3-dev \
libcurl4-openssl-dev libevent-dev libjson-glib-dev pkg-config gperf libpcap-dev libhiredis-dev libavcodec-dev \
libavfilter-dev libswresample-dev libspandsp-dev markdown libmysqlclient-dev \
libbencode-perl libcrypt-openssl-rsa-perl libcrypt-rijndael-perl libdigest-crc-perl libdigest-hmac-perl \
libio-multiplex-perl libio-socket-inet6-perl libiptcdata0-dev libnet-interface-perl libsocket6-perl libsystemd-dev \
libjson-glib-1.0-0

# Build
RUN cd /usr/local/src \
  && git clone https://github.com/sipwise/rtpengine.git \
  && cd rtpengine \
  && make \
  && cp ./daemon/rtpengine /usr/local/sbin

# Clean
RUN rm -Rf /usr/local/src/rtpengine \
  && apt-get purge -y --quiet --auto-remove gcc g++ make build-essential git markdown \
  && rm -rf /var/lib/apt/* \
  && rm -rf /var/lib/dpkg/* \
  && rm -rf /var/lib/cache/* \
  && rm -Rf /var/log/* \
  && rm -Rf /usr/local/src/* \
  && rm -Rf /var/lib/apt/lists/* 

# Mount point
VOLUME ["/tmp"]

# Configuration
COPY ./rtpengine.conf /etc

EXPOSE 7722/udp

CMD ["/usr/local/sbin/rtpengine", "--config-file", "/etc/rtpengine.conf"]

