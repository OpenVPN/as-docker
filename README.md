![openvpn-as](https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/OpenVPN_logo.svg/2560px-OpenVPN_logo.svg.png)
# OpenVPN Access Server

[Openvpn-as](https://openvpn.net/access-server/) OpenVPN Access Server, our self-hosted solution, simplifies the rapid deployment of a secure remote access and site-to-site solution with a web-based administration interface and built-in OpenVPN Connect app distribution with bundled connection profiles.

We built OpenVPN Access Server using the OpenVPN open source core and additional open source software like OpenSSL. This provides full transparency of the critical security and protocol functionality. The community edition creates secure VPN connections using a custom security protocol that utilizes SSL/TLS. With over 60 million downloads to date, the community edition is a community-supported OSS (open-source software) project.

OpenVPN Access Server maintains compatibility with the open source project, making the deployed VPN immediately usable with OpenVPN protocol-compatible software on various routers and operating systems, as well as Linux. The official OpenVPN Inc.- developed client, OpenVPN Connect, is available for Windows, macOS, Linux, and mobile OS (Android and iOS) environments.

## Supported Architectures

| Tag | Architecture |
| :----: | --- |
| latest | amd64, arm64 |

## Parameters

| Parameter | Description |
| :----: | --- |
| `-p 943` | Admin GUI port. |
| `-p 443` | TCP port. |
| `-p 1194/udp` | UDP port. |
| `-v /openvpn` | Where openvpn-as should store configuration files. |

## Usage

Launch this image:
```bash
docker run -d \
  --name=openvpn-as \
  --cap-add=NET_ADMIN \
  -p 943:943 \
  -p 443:443 \
  -p 1194:1194/udp \
  -v <path to data>:/openvpn \
  openvpn/openvpn-as
```
Please note: For interacting with the network stack  `--cap-add=NET_ADMIN` should be used.

### Application Setup

The admin interface is available at `https://DOCKER-HOST-IP:943/admin` (assuming bridge mode) with a default user 'openvpn' and the password can be found in the docker logs or in the `/usr/local/openvpn_as/init.log` file inside container (on the first initial run).

To ensure your devices can connect to your VPN properly, go to Configuration -> Network Settings -> and change the "Hostname or IP Address" section to either your domain name or public ip address.

### Testing/Debugging

To debug the container:
```
docker logs -f openvpn-as
```
To get an interactive shell:
```
docker exec -it openvpn-as /bin/bash
```
## Bugs and feature requests

If you find a bug in our image, please file a bug here:

https://support.openvpn.com/hc/en-us/categories/360006075631-Access-Server
