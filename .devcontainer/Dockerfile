FROM amazonlinux:2022.0.20220504.1 as base

WORKDIR /

ARG home_dir=/root
ARG host_resources_dir=.devcontainer/resources

RUN yum update -y && yum install -y \
    kernel \
    util-linux \
    iptables \
    iptables-nft \
    nftables \
    sudo \
    zip \
    findutils \
    tar \
    patch \
    make \
    git \
    openssl \
    zsh \
    python3 \
    jq \
    procps  \
    man \
    gcc \
    g++ \
    zlib-devel \
    bzip2 \
    bzip2-devel \
    readline-devel \
    sqlite \
    sqlite-devel \
    openssl-devel \
    tk-devel \
    libffi-devel \
    xz \
    xz-devel \
    python-devel \
    python3-devel

# asdf tool version manager
RUN git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.10.2 && \
    source $HOME/.asdf/asdf.sh && asdf update

# ohmyzsh cli framework
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash && \
    git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# default bash and zsh .dotfile setup
COPY ${host_resources_dir}/bash/.bashrc ${home_dir}/.bashrc
COPY ${host_resources_dir}/bash/bashrc.d ${home_dir}/bashrc.d
COPY ${host_resources_dir}/zsh/.zshrc ${home_dir}/.zshrc
COPY ${host_resources_dir}/zsh/zshrc.d ${home_dir}/zshrc.d
RUN ls -al /root

# docker + buildx and compose plugins
RUN yum install -y docker
COPY --from=docker:20.10 /usr/libexec/docker/cli-plugins /usr/libexec/docker/cli-plugins
RUN dockerd --version && \
    docker --version && \
    docker buildx version && \
    docker compose version

# add docker daemon configuration
COPY ${host_resources_dir}/etc/docker /etc/docker

# s6-overlay service manager
ARG S6_OVERLAY_VERSION=3.1.0.1
RUN curl -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz | tar -Jxp -C / && \
    curl -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-$(uname -m).tar.xz | tar -Jxp -C /
RUN groupadd nogroup && usermod -aG nogroup nobody
ENV S6_KEEP_ENV=1

# copy dockerd s6-overlay service configuration
COPY ${host_resources_dir}/etc/s6-overlay /etc/s6-overlay

# directory for command history
# this can later be used to persist container history between
# sessions
RUN mkdir -p /commandhistory
RUN mkdir -p $HOME/bin

ENV PATH=${PATH}:${home_dir}/bin
ENV EDITOR=vi
ENV TERM=xterm-256color
ENV SHELL=zsh
ENV HOME=/root
ENV PROMPT_COMMAND='history -a'
ENV HISTFILE='/commandhistory/shell_history'
ENV HISTTIMEFORMAT='%d-%m-%y %T '
ENV RESOURCES_PATH=/resources


USER root
WORKDIR /root
ENTRYPOINT [ "/init" ]

# isolate build tools in stage
# why? to prevent build language tools like rust from polluting final image
FROM base as build_tools

WORKDIR /

ARG home_dir=/root
ARG host_resources_dir=.devcontainer/resources
ARG host_buildscript_dir=${host_resources_dir}/scripts/build
ARG container_resources_dir=/resources
ARG container_buildscript_dir=${container_resources_dir}/scripts/build

# add buildscript libs
COPY ${host_resources_dir}/scripts/libs ${container_resources_dir}/scripts/libs

# install build tools
COPY ${host_resources_dir}/buildtools/.tool-versions ${home_dir}/.tool-versions
ARG buildscript=install_tools
COPY ${host_buildscript_dir}/${buildscript} ${container_buildscript_dir}/${buildscript}
RUN chmod +x ${container_buildscript_dir}/${buildscript} && ${container_buildscript_dir}/${buildscript}

FROM base as devcontainer

WORKDIR /

ARG home_dir=/root
ARG host_resources_dir=.devcontainer/resources
ARG host_buildscript_dir=${host_resources_dir}/scripts/build
ARG container_resources_dir=/resources
ARG container_buildscript_dir=${container_resources_dir}/scripts/build

# add buildscript libs
COPY ${host_resources_dir}/scripts/libs ${container_resources_dir}/scripts/libs

# install default tools (i.e. aws cli v2)
ARG buildscript=install_default_tools
COPY ${host_buildscript_dir}/${buildscript} ${container_buildscript_dir}/${buildscript}
RUN chmod +x ${container_buildscript_dir}/${buildscript} && ${container_buildscript_dir}/${buildscript}

# add direnv config
COPY ${host_resources_dir}/direnv.toml /root/.config/direnv/direnv.toml

# copy asdf tools configuration file
# these tools will be installed by the init startup script
# when the devcontainer is started
COPY ${host_resources_dir}/scripts/startup/init ${container_resources_dir}/scripts/startup/init
RUN chmod +x ${container_resources_dir}/scripts/startup/init
