# Copyright 2026 OpenVPN Inc <sales@openvpn.net>
# SPDX-License-Identifier: Apache-2.0
#
FROM ubuntu:24.04

LABEL org.opencontainers.image.authors="pkg@openvpn.net"

ARG TARGETPLATFORM \
    VERSION \
    DEBIAN_FRONTEND="noninteractive"

# This creates 'openvpn_as/etc.docker.bak' backup from initial AS setup
# for re-init AS from scratch cases
RUN apt-get update \
    && apt-get install -y curl systemctl \
    && bash -c 'bash <(curl -fsS https://packages.openvpn.net/as/install.sh) --yes --as-version=$VERSION --without-dco' \
    && echo "Cleaning apt cache" \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p \
        /openvpn \
        /ovpn/tmp \
        /ovpn/sock \
    && sed -i 's#~/tmp#/ovpn/tmp#g;s#~/sock#/ovpn/sock#g' /usr/local/openvpn_as/etc/as_templ.conf \
    && rm -rf /usr/local/openvpn_as/etc/sock/* \
    && rm -rf /usr/local/openvpn_as/etc/pid/* \
    && mv /usr/local/openvpn_as/etc /usr/local/openvpn_as/etc.docker.bak \
    && ln -s /openvpn/etc /usr/local/openvpn_as/etc

COPY docker-entrypoint.sh /

EXPOSE 943/tcp 1194/udp 443/tcp
VOLUME /openvpn

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/openvpn_as/scripts/openvpnas", "--nodaemon", "--pidfile=/ovpn/tmp/openvpn.pid"]
