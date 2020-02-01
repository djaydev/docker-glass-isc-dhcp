#!/bin/bash
touch /var/lib/dhcp/dhcpd.leases &
sed -i "/admin_password/s/glassadmin/$ADMINPASSWORD/g" /opt/glass-isc-dhcp/config/glass_config.json
sed -i "/ws_port/s/8080/$WEBSOCKETPORT/g" /opt/glass-isc-dhcp/config/glass_config.json
sed -i "/normalizePort/s/3000/$WEBADMINPORT/g" /opt/glass-isc-dhcp/bin/www
/usr/sbin/service isc-dhcp-server start &
npm start --prefix /opt/glass-isc-dhcp
