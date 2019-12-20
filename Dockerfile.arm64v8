# djaydev/glass-isc-dhcp:arm64v8

FROM arm64v8/alpine:3.11 AS builder

COPY --from=balenalib/aarch64-alpine /usr/bin/qemu-aarch64-static /usr/bin/qemu-aarch64-static
COPY --from=balenalib/aarch64-alpine /usr/bin/resin-xbuild /usr/bin/resin-xbuild
COPY --from=balenalib/aarch64-alpine /usr/bin/cross-build-start /usr/bin/cross-build-start
COPY --from=balenalib/aarch64-alpine /usr/bin/cross-build-end /usr/bin/cross-build-end

RUN [ "cross-build-start" ]

RUN apk add git wget libtool automake autoconf unzip build-base libc6-compat coreutils

WORKDIR /tmp

RUN git clone https://github.com/Akkadius/dhcpd-pools.git && \
    wget https://github.com/troydhanson/uthash/archive/master.zip && \
    unzip master.zip

RUN cd /tmp/dhcpd-pools && \
    cp README.md README && \
    ./bootstrap && \
    ./configure --with-uthash=/tmp/uthash-master/include && \
    make && \
    make check && \
    make install

RUN [ "cross-build-end" ]

FROM arm64v8/alpine:3.11

COPY --from=balenalib/aarch64-alpine /usr/bin/qemu-aarch64-static /usr/bin/qemu-aarch64-static
COPY --from=balenalib/aarch64-alpine /usr/bin/resin-xbuild /usr/bin/resin-xbuild
COPY --from=balenalib/aarch64-alpine /usr/bin/cross-build-start /usr/bin/cross-build-start
COPY --from=balenalib/aarch64-alpine /usr/bin/cross-build-end /usr/bin/cross-build-end

RUN [ "cross-build-start" ]

WORKDIR /opt
RUN apk --no-cache add dhcp git bash tzdata libtool npm libc6-compat && \
    git clone https://github.com/Akkadius/glass-isc-dhcp.git && \
    cd glass-isc-dhcp && \
    mkdir logs && \
    chmod u+x ./bin/ -R && \
    chmod u+x *.sh && \
    npm config set unsafe-perm true && \
    npm install && \
    npm install forever -g && \
    apk del git libtool && \
    rm -rf /var/cache/apk/* /tmp/* /tmp/.[!.]* /opt/glass-isc-dhcp/.git

COPY --from=builder /usr/local/bin/dhcpd-pools /opt/glass-isc-dhcp/bin/

ENV ADMINPASSWORD=glassadmin \
    WEBSOCKETPORT=8080 \
    WEBADMINPORT=3000

# Copy the start script.
COPY startapparm.sh /startapp.sh
RUN chmod +x /startapp.sh

EXPOSE 67/udp 67/tcp 3000/tcp
ENTRYPOINT ["/startapp.sh"]

RUN [ "cross-build-end" ]
