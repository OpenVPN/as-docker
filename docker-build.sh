#!/bin/bash

usage() {
    echo
    echo "Usage: $0 <as_version>"
    echo
    echo "as_version - version of 'openvpn-as' DEB package"
    echo "example: '$0 2.12.1-bc070def-Ubuntu22'"
    echo "it is used as a docker image tag too"
    echo
    echo "Please note: the multi-platform image build is used"
    echo "https://docs.docker.com/build/building/multi-platform/"
    echo "It also pushes images so please make sure the correct Docker Hub account is used"
}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

VERSION=$1

docker buildx build --no-cache --platform linux/amd64,linux/arm64 -f Dockerfile --build-arg="VERSION=$VERSION" -t openvpn/openvpn-as:$VERSION -t openvpn/openvpn-as:latest --push .
