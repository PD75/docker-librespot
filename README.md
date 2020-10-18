# Librespot Docker
**v 0.1.3**

This container contains [librespot](https://github.com/librespot-org/librespot) which is a headless Spotify daemon. It can be controlled from any spotify client as other spotify compatible devices through Spotify Connect.

This requires a Spotify premium account but does not require a Spotify developer key or libspotify binary. 

Audio is output to a pipe that can be consumed by other services such as [SnapCast](https://github.com/badaix/snapcast), etc. The default stream is:

    /tmp/librespotfifo

To run the conained if default mode:

    sudo docker run --init -d \
      -v [you path to tmp]/librespotfifo:/tmp/librespotfifo \
      --restart=unless-stopped \
      --net=host \
      tiger75/librespot


The followin options are set per default:

    --name "$LIBRESPOT_NAME" \              # librespot
    --device "$LIBRESPOT_DEVICE" \          # /tmp/librespotfifo
    --backend "$LIBRESPOT_BACKEND" \        # pipe
    --bitrate "$LIBRESPOT_BITRATE" \        # 320
    --initial-volume "$LIBRESPOT_INITVOL" \ # 100
    --cache "$LIBRESPOT_CACHE"              # /tmp

To change these values use the -e flag for the docker container. E.g. 

    sudo docker run --init -d \
      --name=librespot \
      -v [you path to tmp]/librespotfifo:/tmp/librespotfifo \
      -e LIBRESPOT_CACHE=/tmp \
      -e LIBRESPOT_NAME=librespot \
      -e LIBRESPOT_DEVICE=/tmp/librespotfifo \
      -e LIBRESPOT_BACKEND=pipe \
      -e LIBRESPOT_BITRATE=320 \
      -e LIBRESPOT_INITVOL=100 \
      --restart=unless-stopped \
      --net=host \
      tiger75/librespot --other_options options_value
      
As in the example, you can add additional options to the image that will be added to librespot. Check the wiki for more info and possible [usage options](https://github.com/librespot-org/librespot/wiki/Options)

Please post bugs to GitHub.