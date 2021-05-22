FROM alpine:latest

RUN apk update \
    && apk add --no-cache fish curl git npm

RUN npm install -g tap-diff

RUN /usr/bin/fish -c "curl -sL git.io/fisher | source; and fisher install jorgebucaran/{fisher,fishtape}"

RUN /usr/bin/fish -c "curl -L https://get.oh-my.fish | fish"

ENTRYPOINT ["/usr/bin/fish"]
