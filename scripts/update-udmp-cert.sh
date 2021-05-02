#!/bin/bash

# Install the UDM Pro's acme certificate from the truenas
#

# The UDM Pro requires a password for SSH, even with Key Authentication enabled so it is 
# messy to setup copying the certificate over securely, without a proper secret store in place.
# 
# This is intended to be a quick way to copy it over ad-hoc, when we don't have that available.
#
# Quick as it may be, it should be fairly security concious:
# - We pipe the tar directly from one ssh command to the other, so no temp files are created 
#   or persisted.
# - Blink.sh securely stores the host configurations, including the UDM Pro password, in the
#   secure enclave. It also allows for requiring Face/Touch ID to unlock the console.
# - SSH keeps the network transfer encrypted.
#
# The TrueNAS has a native ACME certificate manager, so we let that handle renewal
# and copy the resulting certificate files from there.
# 
# The TrueNAS stores the certificates in the '/etc/certificates/' folder
# The UDM Pro stores the certificates in the '/mnt/data/unifi-os/unifi-core/config/' folder.
#
# The UDM Pro Captive Portal stores stores certificates in the '/mnt/data/unifi-os/unifi/data' folder.
# The UDM Pro Captive Portal can be viewed at https://fqdn_controller:8843/guest/s/default/#/
# TODO: Configure the Captive Portal certificate.
# 
# We have FreeBSD, Blink.sh, and BusyBox in the mix, so there are probably better ways
# for some of these commands, but we had to account for compatibility between them all.
#
# For example,
# We could probably use --transform to handle changing the paths instead of stripping it, but
# the BusyBox tar didn't support that.
#
# In additiona we are also trying to keep it contained to a single line, that we can copy-paste,
# as Blink.sh from the App Store doesn't support running shell scripts (at least not that I've found)
#
#
# Fix 'tar: Skipping to next headers' incompatibility between bsdtar and busybox tar:
# Prepend the source commands with 'stty -onlcr; '
# See https://www.cyberciti.biz/faq/howto-use-tar-command-through-network-over-ssh-session/comment-657056
# 
# Fix 'tar: invalid tar magic'
# Do not use the -v flag on creation side of tar, it polutes the pipeline.
# 

ssh truenas 'stty -onlcr; find /etc/certificates/ -name "unifi-core.*" | tar --strip-components 3 -c -f - --files-from - ' | ssh unifi-udmp 'tar -C /mnt/data/unifi-os/unifi-core/config/ --overwrite -x -v -f -'

# Restart
ssh unifi-udmp '/usr/sbin/unifi-os restart'