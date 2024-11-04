# Copyright 2024 OpenVPN Inc <sales@openvpn.net>
# SPDX-License-Identifier: Apache-2.0
#
FROM ubuntu:22.04

LABEL org.opencontainers.image.authors="pkg@openvpn.net"

ARG TARGETPLATFORM \
    VERSION \
    DEBIAN_FRONTEND="noninteractive"

# Installing system software
RUN apt-get update && \
    apt-get install -y \
        ca-certificates \
        wget \
        gnupg \
        net-tools \
        iptables \
        systemctl

# Adding openvpn repository + Installing openvpn-as
RUN wget https://as-repository.openvpn.net/as-repo-public.asc -qO /etc/apt/keyrings/as-repository.asc \
    && echo "deb [arch=${TARGETPLATFORM#linux/} signed-by=/etc/apt/keyrings/as-repository.asc] http://as-repository.openvpn.net/as/debian jammy main">/etc/apt/sources.list.d/openvpn-as-repo.list \
    && apt-get update \
    && apt-get -y install openvpn-as=$VERSION && \

    echo "Cleaning apt cache" \
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
