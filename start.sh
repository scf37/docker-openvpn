#!/bin/bash

function head {
    echo "OpenVPN VPN service"
    echo "https://github.com/scf37/l2tp"
    echo
}

function help {
    head

    echo "Runs OpenVPN VPN service in docker container. Intended for home usage."
    echo "Run string: docker run -it --rm --privileged --net=host -v /lib/modules:/lib/modules -v /data/openvpn:/data scf37/openvpn"
}


if [ ! -d "/lib/modules" ]; then
    echo "Error: container requires privileged mode"
    echo
    help

    exit 1
fi

mkdir -p /data/conf/etc/openvpn

if [ -d "/data/conf/etc/openvpn/keys" ]; then
    cp -r /data/conf/etc/openvpn/keys /usr/share/easy-rsa
fi

cd /usr/share/easy-rsa

source vars

if [ ! -e "keys/serial" ]; then
    ./clean-all
fi

if [ ! -e "keys/ca.crt" ]; then
    ./pkitool --initca
fi

if [ ! -e "keys/server.key" ]; then
    ./pkitool --server server
fi

if [ ! -e "keys/client.key" ]; then
    ./pkitool client
fi

if [ ! -e "keys/dh2048.pem" ]; then
    ./build-dh
fi

cp -rn keys /data/conf/etc/openvpn/keys


cp -rn /opt/conf/* /data/conf/


cd /data/conf
find . -type f | while read N
do
      mkdir -p /`dirname $N`
      cat $N | envsubst '$OPENVPN_PORT;' > /$N
done

ca_cert=`cat /data/conf/etc/openvpn/keys/ca.crt`
client_cert=`cat /data/conf/etc/openvpn/keys/client.crt`
client_key=`cat /data/conf/etc/openvpn/keys/client.key`

if [ ! -e "/data/conf/client.ovpn" ]; then

    cat >/data/conf/client.ovpn  << EOF
client

dev tun

proto udp

remote <VPN SERVER IP HERE> <VPN SERVER PORT HERE>

resolv-retry infinite

nobind

persist-key
persist-tun

<ca>
${ca_cert}
</ca>

<cert>
${client_cert}
</cert>

<key>
${client_key}
</key>
comp-lzo

# Set log file verbosity.
verb 3

EOF

fi

head

mkdir /data/logs

cd /etc/openvpn

openvpn --config server.conf $@
