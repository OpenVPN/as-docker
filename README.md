![openvpn-as](https://openvpn.net/images/logo-ovpn-dark.svg)
# OpenVPN Access Server

[OpenVPN Access Server](https://openvpn.net/access-server/), the OpenVPN self-hosted solution, simplifies the rapid deployment of a secure remote access solution with a web-based graphic user interface and OpenVPN Connect client installers.

Get Technical Support 24/7 and Schedule a Live Demo at openvpn.com.

Our products are based on the market-proven OpenVPN protocol and trusted by some of the world's most renowned brands for their unmatched flexibility, scalability, and ease of use.

OpenVPN Access Server delivers the enterprise VPN your business has been looking for. Protect your data communications, secure IoT resources, and provide encrypted remote access to on-premise, hybrid, and public cloud resources.

Access Server provides you with a powerful and easy-to-use web-based admin site that makes VPN management and configuration simple for anybody (with or without Linux knowledge). Access Server integrates OpenVPN server capabilities, access management, and OpenVPN client software that accommodates Windows, macOS, Linux, Android, iOS, and ChromeOS environments.

Our licensing model is based on the number of concurrent connected devices, so it's affordable for any size business and can easily grow with your company. Without a license key installed, OpenVPN Access Server will allow 2 concurrent connections at no additional cost (excepting infrastructure costs to run the Docker container).


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
  --name=openvpn-as --device /dev/net/tun \
  --cap-add=MKNOD --cap-add=NET_ADMIN \
  -p 943:943 -p 443:443 -p 1194:1194/udp \
  -v <path to data>:/openvpn \
  openvpn/openvpn-as
```
Please note: For interacting with the network stack  `--cap-add=NET_ADMIN`, `--cap-add=MKNOD` and `--device /dev/net/tun` should be used.

### docker-compose:
Compatible with docker-compose v2 schemas.
```
---
version: "2.1"
services:
  openvpn-as:
    image: openvpn/openvpn-as
    container_name: openvpn-as
    devices:
      - /dev/net/tun:/dev/net/tun
    cap_add:
      - NET_ADMIN
      - MKNOD
    ports:
      - 943:943
      - 443:443
      - 1194:1194/udp
    volumes:
      - <path to data>:/openvpn
    restart: unless-stopped
```

## Application Setup

The admin interface is available at `https://DOCKER-HOST-IP:943/admin` (assuming bridge mode) with a default user 'openvpn' and the password can be found in the docker logs (on the first initial run):
```
docker logs -f openvpn-as
```

To ensure your devices can connect to your VPN properly, go to Configuration -> Network Settings -> and change the "Hostname or IP Address" section to either your domain name or public ip address.

---

## Testing/Debugging

To debug the container:
```
docker logs -f openvpn-as
```
To get an interactive shell:
```
docker exec -it openvpn-as /bin/bash
```

To set your own password on the 'openvpn' administrative user, while in the container shell:
```
sacli --user "openvpn" --new_pass "WhateverPasswordYouWant" SetLocalPassword
```

## Docker image build script

Code contributions for the Docker image build are most welcome. Please submit pull request for review to:

https://github.com/OpenVPN/as-docker

## Contact support

You can contact the support team for OpenVPN Access Server here:

https://support.openvpn.com/hc/en-us/categories/360006075631-Access-Server

### [EULA and legal information.](https://openvpn.net/legal/)
