ssh truenas "cat /etc/certificates/unifi-core.key" | ssh unifi-udmp "cat > /mnt/data/unifi-os/unifi-core/config/unifi-core.key"
ssh truenas "md5 /etc/certificates/unifi-core.key"
ssh unifi-udmp "md5sum /mnt/data/unifi-os/unifi-core/config/unifi-core.key"
 
 
ssh truenas cat /etc/certificates/unifi-core.crt | ssh unifi-udmp "cat > /mnt/data/unifi-os/unifi-core/config/unifi-core.crt"



ssh unifi-udmp /usr/sbin/unifi-os restart