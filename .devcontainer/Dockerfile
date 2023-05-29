ARG BASE_IMAGE_VERSION=9.2-minimal
FROM rockylinux:${BASE_IMAGE_VERSION}

ENV TIMEZONE=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo $TIMEZONE > /etc/timezone

RUN microdnf update -y \
  && microdnf install -y epel-release \
  && microdnf install -y fish npm git curl vim tar pandoc findutils \
  && microdnf clean all -y

RUN npm install -g tap-diff

RUN rm -rf /usr/share/doc

RUN /usr/bin/fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; and fisher install jorgebucaran/{fisher,fishtape}"

ARG BASE_IMAGE_VERSION
COPY motd /etc/motd
RUN sed -i "s/{{BASE_IMAGE_VERSION}}/$BASE_IMAGE_VERSION/" /etc/motd

COPY fish_greeting.fish /root/.config/fish/functions

ENTRYPOINT ["/usr/bin/fish"]

