#!/usr/bin/env bash

set -x
set -o errexit
set -o nounset
set -o pipefail
set -o errtrace

script_dir=$(dirname "$(readlink -f "$0")")
uid=$(id -u ${USER})
gid=$(id -g ${USER})
http_proxy="${http_proxy:-}"
https_proxy="${https_proxy:-}"
RUSTUP_DIST_SERVER="${RUSTUP_DIST_SERVER:-}"
RUSTUP_UPDATE_ROOT="${RUSTUP_UPDATE_ROOT:-}"
ARCH=${ARCH:-$(uname -m)}
CITA_REPO="${CITA_REPO:-}"
docker_gid=$(getent group docker | cut -d: -f3 || { echo >&2 "Missing docker group, docker needs to be installed" && false; })
if [ ${docker_gid} == ${gid} ]; then
	docker_gid=""
fi

docker build -t build-cita \
	--build-arg IMG_USER="${USER}" \
	--build-arg UID=${uid} \
	--build-arg GID=${gid} \
	--build-arg http_proxy="${http_proxy}" \
	--build-arg https_proxy="${https_proxy}" \
	--build-arg HOST_DOCKER_GID=${docker_gid} \
	--build-arg ARCH="${ARCH}" \
    --build-arg CITA_REPO="${CITA_REPO}" \
    --build-arg RUSTUP_DIST_SERVER=${RUSTUP_DIST_SERVER} \
    --build-arg RUSTUP_UPDATE_ROOT=${RUSTUP_UPDATE_ROOT} \
	"${script_dir}"