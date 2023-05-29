FROM rockylinux:9.2-minimal

ENV TIMEZONE=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo $TIMEZONE > /etc/timezone

RUN microdnf update -y \
  && microdnf install -y epel-release \
  && microdnf install -y fish npm git curl vim tar pandoc findutils \
  && microdnf clean all -y

RUN npm install -g tap-diff

RUN rm -rf /usr/share/doc

RUN /usr/bin/fish -c "curl -sL git.io/fisher | source; and fisher install jorgebucaran/{fisher,fishtape}"

COPY motd /etc/motd
COPY fish_greeting.fish /root/.config/fish/functions

ENTRYPOINT ["/usr/bin/fish"]

