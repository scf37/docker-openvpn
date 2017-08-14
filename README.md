# OpenVPN
OpenVPN Docker image.

## What is this

Docker image containing working OpenVPN VPN server using key authentication.

## Howto

1. edit /etc/sysctl.conf:

    `net.ipv4.ip_forward = 1`
2. refresh sysctl

    `sysctl -p`
3. if you want to access Internet via this VPN, run

    `iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE`

    otherwise, remove `push "redirect-gateway def1"` from server.conf

4. `docker create --name copenvpn --restart always --privileged --net=host -v /lib/modules:/lib/modules -v /data/openvpn:/data scf37/openvpn`
5. container will automaticall generate client config file at /data/openvpn/client.conf. Do not forget to put correct IP and optionally port in there before use.

## Advanced topics

### Configuration

Container will copy default configuration to /data/conf NOT overwriting existing files. So feel free to modify configs at /data/openvpn/conf on host as you wish.
Additional container command line parameters will be passed to openvpn binary.

### Limitations

Not as widespread as L2TP. For example, most home routers do not have OpenVPN client.
