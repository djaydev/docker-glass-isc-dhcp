# docker-glass-isc-dhcp
Includes ISC DHCP Server and Glass Web Management tool.

The GUI of the application is accessed through a modern web browser (no installation or configuration needed on client side). Default port 3000.

For more info on Glass, see https://github.com/Akkadius/glass-isc-dhcp#features

NOTE: Requires DHCP server config file in appdata/glass-isc-dhcp folder.

For a sample config file, see https://github.com/djaydev/docker-glass-isc-dhcp/blob/master/sample.dhcpd.conf

Host or MACVLAN networking is recommended.

```
docker run -d \
    --name=glass-isc-dhcp \
    --network="host" \
    -v /docker/appdata/glass-isc-dhcp:/etc/dhcp:rw \
    -v /docker/appdata/glass-isc-dhcp/leases:/var/lib/dhcp:rw \
    -e ADMINPASSWORD=glassadmin \
    -e WEBSOCKETPORT=8080 \
    -e WEBADMINPORT=3000 \
    djaydev/glass-isc-dhcp
```
Where:
- `/docker/appdata/glass-isc-dhcp`: dhcpd.conf folder
- `/docker/appdata/glass-isc-dhcp/leases`: optional folder for persistent leases
- `ADMINPASSWORD`: optional Glass Web password, default glassadmin
- `WEBSOCKETPORT`: optional Glass Websocket Port, default 8080
- `WEBADMINPORT`: optional Glass Web UI Port, default 3000

Browse to http://your-host-ip:3000 to access the Glass Web GUI.

# Projects used:
- https://hub.docker.com/_/node
- https://github.com/Akkadius/glass-isc-dhcp
- https://hub.docker.com/r/frolvlad/alpine-glibc
- https://hub.docker.com/r/joebiellik/dhcpd
- https://hub.docker.com/u/balenalib (debian, alpine, ubuntu, and node images for ARM platforms)
- https://github.com/athalonis/docker-alpine-rpi-glibc-builder
