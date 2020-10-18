FROM rust:1.47 AS librespot

RUN apt-get update \
    && apt-get -y install build-essential libasound2-dev pkg-config curl unzip \
    && apt-get clean && rm -fR /var/lib/apt/lists

RUN cd /tmp \
    # && curl -sLO https://github.com/librespot-org/librespot/archive/master.zip \
    && wget https://github.com/librespot-org/librespot/archive/v0.1.3.zip \
    && unzip v0.1.3.zip \
    && mv librespot-0.1.3 librespot-master \
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