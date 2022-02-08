FROM ubuntu:latest

ENV TIMEZONE=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo $TIMEZONE > /etc/timezone

RUN apt update && \
    apt install -y software-properties-common && \
    apt-add-repository -y ppa:fish-shell/release-3 && \
    apt update && \
    apt install -y fish

RUN apt install -y npm && \
    npm install -g tap-diff

RUN apt install -y git curl vim

RUN /usr/bin/fish -c "curl -sL git.io/fisher | source; and fisher install jorgebucaran/{fisher,fishtape}"

ENTRYPOINT ["/usr/bin/fish"]
