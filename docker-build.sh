#!/bin/bash
# Copyright 2024 OpenVPN Inc <sales@openvpn.net>
# SPDX-License-Identifier: Apache-2.0

set -eu

as_version=""
registry_image_name="openvpn/openvpn-as"

usage() {
    echo
    echo "Usage: $0 -v <as_version> [-r <registry_image_name>]"
    echo
    echo "as_version - version of 'openvpn-as' DEB package"
    echo "example: '$0 2.12.1-bc070def-Ubuntu22'"
    echo "it is used as a docker image tag too"
    echo
    echo "registry_image_name - custom image registry to tag and push"
    echo "by default it pushes into Docker Hub: 'openvpn/openvpn-as'"
    echo
    echo "Please note: the multi-platform image build is used"
    echo "https://docs.docker.com/build/building/multi-platform/"
}

while getopts ":v:r:" opt; do
    case $opt in
        v)
            as_version="$OPTARG"
            ;;
        r)
            registry_image_name="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

if [ -z "$as_version" ]; then
    echo "Error: AS version is required." >&2
    usage
    exit 1
fi

docker buildx build --no-cache --platform linux/amd64,linux/arm64 -f Dockerfile --build-arg="VERSION=$as_version" -t $registry_image_name:$as_version -t $registry_image_name:latest --push .
