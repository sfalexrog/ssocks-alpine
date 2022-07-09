FROM ghcr.io/sfalexrog/ssocks-alpine:main

COPY conf/ /conf

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
