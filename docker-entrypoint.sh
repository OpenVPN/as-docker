#!/bin/bash
# Copyright 2024 OpenVPN Inc <sales@openvpn.net>
# SPDX-License-Identifier: Apache-2.0

set -ex

if [ ! -c /dev/net/tun ]; then
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200
fi

# clear old sock and pid files
rm -rf /usr/local/openvpn_as/etc/sock/* /ovpn/sock/*
rm -rf /usr/local/openvpn_as/etc/pid/* /ovpn/tmp/*.pid

if [ ! -f /openvpn/etc/docker-init ]; then
    cp -a /usr/local/openvpn_as/etc /openvpn/
fi

rm -rf /usr/local/openvpn_as/etc
ln -s /openvpn/etc /usr/local/openvpn_as/etc

if [ ! -f /openvpn/etc/docker-init ]; then
    /usr/local/openvpn_as/bin/ovpn-init --force --batch --no_start
    touch /openvpn/etc/docker-init
fi

exec "$@"
