FROM rockylinux:9.0-minimal

ENV TIMEZONE=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo $TIMEZONE > /etc/timezone

RUN microdnf update -y \
  && microdnf install -y epel-release \
  && microdnf install -y fish npm git curl vim tar \
  && microdnf clean all -y

RUN npm install -g tap-diff

RUN rm -rf /usr/share/doc

RUN /usr/bin/fish -c "curl -sL git.io/fisher | source; and fisher install jorgebucaran/{fisher,fishtape}"

ENTRYPOINT ["/usr/bin/fish"]
