FROM rust:1.63 AS librespot
#1.63/latest


RUN apt-get update \
    && apt-get -y install build-essential libasound2-dev pkg-config curl unzip \
    && apt-get clean && rm -fR /var/lib/apt/lists

ARG LIBRESPOTVERSION=0.4.2
RUN cd /tmp \
    && wget 'https://github.com/librespot-org/librespot/archive/refs/tags/v'$LIBRESPOTVERSION'.zip' \
    && unzip 'v'$LIBRESPOTVERSION'.zip' \
    && mv librespot-${LIBRESPOTVERSION} librespot-master \
    && cd librespot-master \
    && cargo build --release \
    && chmod +x /tmp/librespot-master/target/release/librespot

FROM debian:testing-slim as release

RUN apt-get update \
    && apt-get -y install libasound2 \
    && apt-get clean && rm -fR /var/lib/apt/lists

COPY --from=librespot /tmp/librespot-master/target/release/librespot /usr/local/bin/

ENV LIBRESPOT_CACHE /tmp
ENV LIBRESPOT_NAME librespot
ENV LIBRESPOT_DEVICE /tmp/librespotfifo
ENV LIBRESPOT_BACKEND pipe
ENV LIBRESPOT_BITRATE 320
ENV LIBRESPOT_INITVOL 100

CMD librespot \
    --name "$LIBRESPOT_NAME" \
    --device "$LIBRESPOT_DEVICE" \
    --backend "$LIBRESPOT_BACKEND" \
    --bitrate "$LIBRESPOT_BITRATE" \
    --initial-volume "$LIBRESPOT_INITVOL" \
    --cache "$LIBRESPOT_CACHE" 