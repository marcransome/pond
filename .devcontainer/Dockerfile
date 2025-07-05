ARG BUILD_TYPE=codespaces
ARG BASE_IMAGE_VERSION=9.6-minimal
FROM rockylinux/rockylinux:${BASE_IMAGE_VERSION} AS base

ENV TIMEZONE=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo $TIMEZONE > /etc/timezone

RUN microdnf update -y \
  && microdnf install -y epel-release \
  && microdnf install -y npm git curl vim tar pandoc findutils \
  && cd /etc/yum.repos.d \
  && curl -O -L https://download.opensuse.org/repositories/shells:fish:release:3/CentOS_8/shells:fish:release:3.repo \
  && microdnf install -y fish \
  && microdnf clean all -y

RUN npm install -g tap-diff
RUN rm -rf /usr/share/doc
RUN /usr/bin/fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; and fisher install jorgebucaran/{fisher,fishtape}"

FROM base AS codespaces-build

COPY motd /etc/motd
COPY fish_greeting.fish /root/.config/fish/functions

FROM base AS docker-build

COPY .devcontainer/motd /etc/motd
COPY .devcontainer/fish_greeting.fish /root/.config/fish/functions
COPY . /workspaces/pond

FROM ${BUILD_TYPE}-build AS final

ARG BASE_IMAGE_VERSION
RUN sed -i "s/{{BASE_IMAGE_VERSION}}/$BASE_IMAGE_VERSION/" /etc/motd
WORKDIR /workspaces/pond
ENTRYPOINT ["/usr/bin/fish"]
