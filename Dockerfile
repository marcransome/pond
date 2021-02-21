FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && apt-add-repository -yn ppa:fish-shell/release-3 \
    && apt-get install -y curl fish npm git

RUN npm install -g tap-diff

RUN /bin/fish -c "curl -sL git.io/fisher | source && fisher install jorgebucaran/{fisher,fishtape}"

ENTRYPOINT ["/bin/fish"]
