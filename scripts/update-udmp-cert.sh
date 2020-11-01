ssh truenas cat /etc/certificates/unifi-core.key| pbcopy
pbpaste | ssh unifi-udmp "cat > /mnt/data/unifi-os/unifi-core/config/unifi-core.key"
 
ssh truenas cat /etc/certificates/unifi-core.crt | pbcopy
pbpaste | ssh unifi-udmp "cat > /mnt/data/unifi-os/unifi-core/config/unifi-core.crt"

ssh unifi-udmp /usr/sbin/unifi-os restart