# djaydev/glass-isc-dhcp

FROM alpine AS builder

RUN apk add git wget libtool automake autoconf unzip build-base libc6-compat uthash coreutils

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

FROM node:8.16-alpine

WORKDIR /opt
RUN apk --no-cache add dhcp tini git bash libtool libc6-compat && \
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
COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

EXPOSE 67/udp 67/tcp 3000/tcp
ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/startapp.sh"]
