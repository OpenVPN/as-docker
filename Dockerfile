# Copyright 2024 OpenVPN Inc <sales@openvpn.net>
# SPDX-License-Identifier: Apache-2.0
#
FROM ubuntu:24.04

LABEL org.opencontainers.image.authors="pkg@openvpn.net"

ARG TARGETPLATFORM \
    VERSION \
    DEBIAN_FRONTEND="noninteractive"

# Installing system software
RUN apt-get update && \
    apt-get install -y \
        curl \
        net-tools \
        iptables \
        systemctl

# Installing openvpn-as
RUN bash -c 'bash <(curl -fsS https://packages.openvpn.net/as/install.sh) --yes --as-version=$VERSION --without-dco' \
    && echo "Cleaning apt cache" \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configuring openvpn
RUN mkdir -p \
        /openvpn \
        /ovpn/tmp \
        /ovpn/sock \
        && \
    sed -i 's#~/tmp#/ovpn/tmp#g;s#~/sock#/ovpn/sock#g' /usr/local/openvpn_as/etc/as_templ.conf

COPY docker-entrypoint.sh /

EXPOSE 943/tcp 1194/udp 443/tcp
VOLUME /openvpn

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/openvpn_as/scripts/openvpnas", "--nodaemon", "--pidfile=/ovpn/tmp/openvpn.pid"]
