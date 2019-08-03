#!/usr/bin/with-contenv sh
sed -i "/admin_password/s/glassadmin/$ADMINPASSWORD/g" /opt/glass-isc-dhcp/config/glass_config.json
sed -i "/ws_port/s/8080/$WEBSOCKETPORT/g" /opt/glass-isc-dhcp/config/glass_config.json
sed -i "/normalizePort/s/3000/$WEBADMINPORT/g" /opt/glass-isc-dhcp/bin/www
touch /var/log/dhcp.log
chown $USER_ID:$GROUP_ID /var/log/dhcp.log
touch /var/lib/dhcp/dhcpd.leases
chown $USER_ID:$GROUP_ID /var/lib/dhcp/dhcpd.leases
chown $USER_ID:$GROUP_ID /etc/dhcp/dhcpd.conf
