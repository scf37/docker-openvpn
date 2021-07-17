FROM scf37/base:latest

ENV OPENVPN_VERSION 2.5.2
ENV OPENSSL_VERSION 1.1.1h

RUN apt-get update && \
    apt-get install -y dnsutils iptables lsof openvpn easy-rsa gettext make g++ liblz4-dev liblzo2-dev libpam-dev && \
    cd /tmp && \
    wget https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz && \
    tar xfz openssl-$OPENSSL_VERSION.tar.gz && \
    cd openssl-$OPENSSL_VERSION && \
    ./config && \
    make && \
    make install && \
    cd /tmp && \
    wget https://swupdate.openvpn.org/community/releases/openvpn-$OPENVPN_VERSION.tar.xz && \
    tar xf openvpn-$OPENVPN_VERSION.tar.xz && \
    cd openvpn-$OPENVPN_VERSION && ./configure  && \
    make && make install && \
    ldconfig && \
    apt-get remove -y make g++ && \
    #remove artifacts not covered by previous command (for some reasons)
    apt-get remove -y cpp-4.8 gcc-4.8 manpages manpages-dev && \
    apt-get autoremove -y && \
    find /usr/lib -name "*.a" -exec rm -rf {} \; && \
    rm -rf /usr/include && \
    rm -rf /usr/share/doc && \
    rm -rf /usr/share/man && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

COPY etc /opt/conf/etc
COPY start.sh /start.sh

ENTRYPOINT /start.sh