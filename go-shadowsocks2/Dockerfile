FROM golang:alpine3.11 AS builder

RUN apk upgrade \
    && apk add git \
    && go get github.com/shadowsocks/go-shadowsocks2 \
    && go get github.com/shadowsocks/v2ray-plugin

FROM alpine:3.11 AS dist

LABEL maintainer="Juntao Wu <wujuntaocn@outlook.com>"

ARG TZ="Asia/Shanghai"

ENV TZ ${TZ}

RUN apk upgrade --update \
    && apk add tzdata \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && rm -rf /var/cache/apk/*

COPY --from=builder /go/bin/go-shadowsocks2 /usr/bin/go-shadowsocks2
COPY --from=builder /go/bin/v2ray-plugin /usr/bin/v2ray
COPY ./entrypoint.sh /

ENTRYPOINT ["sh", "/entrypoint.sh"]