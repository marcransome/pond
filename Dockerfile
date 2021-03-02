FROM alpine:latest

RUN apk update \
    && apk add --no-cache fish curl git npm

RUN npm install -g tap-diff

RUN /usr/bin/fish -c "curl -sL git.io/fisher | source; and fisher install jorgebucaran/{fisher,fishtape}"

ENTRYPOINT ["/usr/bin/fish"]
