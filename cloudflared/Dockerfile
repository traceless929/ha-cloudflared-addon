ARG BUILD_FROM
ARG CLOUDFLARED_IMAGE="cloudflare/cloudflared:2026.2.0"

FROM ${CLOUDFLARED_IMAGE} AS cloudflared

FROM $BUILD_FROM

ENV LANG=C.UTF-8

COPY --from=cloudflared /usr/local/bin/cloudflared /usr/bin/cloudflared

RUN apk add --no-cache curl \
    && chmod 755 /usr/bin/cloudflared \
    && /usr/bin/cloudflared --version

COPY rootfs /
