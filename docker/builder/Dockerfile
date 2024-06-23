FROM quay.io/chengyu_zhu/ubuntu:22.04
ENV TZ=Etc/UTC

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

## Install system dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends -y install \
    build-essential \ 
    ca-certificates \
    curl \
    gcc \
    g++ \
    git \
    gnupg2 \
    libssl-dev \
    make \
    makedev \
    musl-tools \
    openssl \
    perl \
    protobuf-compiler \
    pkg-config \
    sudo && \
    apt-get clean && rm -rf /var/lib/apt/lists/

ENV http_proxy=${http_proxy:-}
ENV https_proxy=${http_proxy:-}
ENV RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static/
ENV RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

COPY ./rust.config /root/.cargo/config.toml
RUN curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSLf | \
    sh -s -- -y --default-toolchain 1.72.0 -t x86_64-unknown-linux-musl && \ 
    $([ "$(whoami)" != "root" ] && echo sudo) ln -sf /usr/bin/g++ /bin/musl-g++
RUN . /root/.cargo/env; cargo install cargo-when
ENV PATH="/root/.cargo/bin:${PATH}"

ARG IMG_USER=builder
ARG UID=1000
ARG GID=1000
# gid of the docker group on the host, required for running docker in docker builds.
ARG HOST_DOCKER_GID

RUN if [ ${IMG_USER} != "root" ]; then sed -i -e "/:${GID}:/d" /etc/group; groupadd --gid=${GID} ${IMG_USER};fi
RUN if [ ${IMG_USER} != "root" ]; then adduser ${IMG_USER} --uid=${UID} --gid=${GID};fi
RUN if [ ${IMG_USER} != "root" ] && [ ! -z ${HOST_DOCKER_GID} ] && [ ! $(getent group | grep :${HOST_DOCKER_GID}:) ]; then groupadd --gid=${HOST_DOCKER_GID} docker_on_host;fi
RUN if [ ${IMG_USER} != "root" ] && [ ! -z ${HOST_DOCKER_GID} ]; then usermod -a -G ${HOST_DOCKER_GID} ${IMG_USER};fi
RUN sh -c "echo '${IMG_USER} ALL=NOPASSWD: ALL' >> /etc/sudoers"

## Build CITA binaries
ARG CITA_REPO
RUN mkdir -p /opt/cita-code && git clone ${CITA_REPO} /opt/cita-code
WORKDIR /opt/cita-code
RUN git submodule init && git submodule update
RUN make release

## Install CITA release here
RUN mkdir -p /opt/cita

WORKDIR /opt/cita

# Keep tar package here for md5 test
RUN mv /opt/cita-code/target/install/* /opt/cita

# Set CITA_HOME
ENV CITA_HOME=/opt/cita
# Set PATH to cita binary
ENV PATH=/opt/cita/bin:${PATH}
## End of install CITA release

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

WORKDIR /opt/cita-run

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["cita", "bebop", "help"]
