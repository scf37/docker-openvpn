FROM ubuntu:14.04


RUN apt-get update \
    && apt-get install -y wget dnsutils nano mc iptables lsof openvpn easy-rsa gettext \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY etc /opt/conf/etc
COPY start.sh /start.sh

CMD /start.sh