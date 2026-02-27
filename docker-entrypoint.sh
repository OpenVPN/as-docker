#!/bin/bash
# Copyright 2026 OpenVPN Inc <sales@openvpn.net>
# SPDX-License-Identifier: Apache-2.0

set -ex

if [ ! -c /dev/net/tun ]; then
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200
fi

# clear old sock and pid files
rm -rf /ovpn/sock/*
rm -rf /ovpn/tmp/*.pid

if [ ! -f /openvpn/etc/docker-init ]; then
    rm -rf /openvpn/etc
    cp -a /usr/local/openvpn_as/etc.docker.bak /openvpn/etc
    /usr/local/openvpn_as/bin/ovpn-init --force --batch --no_start
    touch /openvpn/etc/docker-init
else
    cp -a /usr/local/openvpn_as/etc.docker.bak/VERSION /openvpn/etc/VERSION
fi

exec "$@"
