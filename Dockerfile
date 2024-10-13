# Copyright 2024 OpenVPN Inc <sales@openvpn.net>
# SPDX-License-Identifier: Apache-2.0
#
FROM --platform=$TARGETPLATFORM ubuntu:22.04

ARG TARGETPLATFORM
ARG VERSION
ARG DEBIAN_FRONTEND="noninteractive"
ENV PROTOCOL udp
LABEL maintainer="pkg@openvpn.net"

RUN apt-get update && \
    apt-get install -y \
    ca-certificates \
    wget \
    gnupg \
    net-tools \
    iptables \
    systemctl

RUN wget https://as-repository.openvpn.net/as-repo-public.asc -qO /etc/apt/keyrings/as-repository.asc && \
    echo "deb [arch=${TARGETPLATFORM#linux/} signed-by=/etc/apt/keyrings/as-repository.asc] http://as-repository.openvpn.net/as/debian jammy main">/etc/apt/sources.list.d/openvpn-as-repo.list && \
    apt update && apt -y install openvpn-as=$VERSION && \
    apt clean

RUN mkdir -p /openvpn /ovpn/tmp /ovpn/sock && \
    sed -i 's#~/tmp#/ovpn/tmp#g;s#~/sock#/ovpn/sock#g' /usr/local/openvpn_as/etc/as_templ.conf

EXPOSE 943/tcp 1194/${PROTOCOL} 443/tcp
VOLUME /openvpn

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/openvpn_as/scripts/openvpnas", "--nodaemon", "--pidfile=/ovpn/tmp/openvpn.pid"]
