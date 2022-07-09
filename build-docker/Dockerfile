FROM alpine:3.16 AS build

RUN apk add build-base rustup \
  && rustup-init -y \
  && /root/.cargo/bin/cargo install shadowsocks-rust \
    --features \
      local-redir,local-tun \
    --target \
      x86_64-unknown-linux-musl \
    --root \
      /shadowdist

FROM alpine:3.16 AS build-v2ray

RUN apk add go git \
  && git clone https://github.com/shadowsocks/v2ray-plugin -b v1.3.1 \
  && cd v2ray-plugin \
  && go build

FROM alpine:3.16 AS dist

COPY --from=build /shadowdist/bin /usr/local/bin

COPY --from=build-v2ray /v2ray-plugin/v2ray-plugin /usr/local/bin/v2ray-plugin

RUN apk add --no-cache nginx jq libqrencode
