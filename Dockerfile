FROM scf37/base:latest


RUN apt-get update \
    && apt-get install -y dnsutils iptables lsof openvpn easy-rsa gettext \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY etc /opt/conf/etc
COPY start.sh /start.sh

ENTRYPOINT /start.sh