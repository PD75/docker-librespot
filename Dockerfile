FROM rust:1.43 AS librespot

RUN apt-get update \
    && apt-get -y install build-essential portaudio19-dev curl unzip \
    && apt-get clean && rm -fR /var/lib/apt/lists

RUN cd /tmp \
    && curl -sLO https://github.com/librespot-org/librespot/archive/master.zip \
    && unzip master.zip \
    && cd librespot-master \
    && cargo build --release \
    && chmod +x /tmp/librespot-master/target/release/librespot

FROM debian:testing-slim as release

RUN apt-get update \
    && apt-get -y install libportaudio2 libvorbis0a libavahi-client3 libflac8 libvorbisenc2 libvorbisfile3 \
    && apt-get clean && rm -fR /var/lib/apt/lists

COPY --from=librespot /tmp/librespot-master/target/release/librespot /usr/local/bin/

ENV LIBRESPOT_CACHE /tmp
ENV LIBRESPOT_NAME librespot
ENV LIBRESPOT_DEVICE /tmp/librespotfifo
ENV LIBRESPOT_BACKEND pipe
ENV LIBRESPOT_BITRATE 320
ENV LIBRESPOT_INITVOL 15

CMD librespot \
    --name "$LIBRESPOT_NAME" \
    --device "$LIBRESPOT_DEVICE" \
    --backend "$LIBRESPOT_BACKEND" \
    --bitrate "$LIBRESPOT_BITRATE" \
    --initial-volume "$LIBRESPOT_INITVOL" \
    --cache "$LIBRESPOT_CACHE" 