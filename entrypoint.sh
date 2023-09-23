#!/bin/bash
set -e

#MY_IP=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`
MY_IP=10.10.19.28 #$(ip a | grep vpn |  grep 172 | awk  '{print $2}' | head -c -4)
VPN_IP=10.10.19.28 #$(ip a | grep vpn |  grep 172 | awk  '{print $2}' | head -c -4)
MY_DOMAIN=api-noor.senetlab.com

sed -i -e "s/FILL_MY_IP/${MY_IP}/g" /etc/rtpengine/rtpengine.conf
sed -i -e "s/FILL_MY_IP/${MY_IP}/g" /etc/kamailio/kamailio.cfg

sed -i -e "s/FILL_VPN_IP/${VPN_IP}/g" /etc/kamailio/kamailio.cfg
sed -i -e "s/FILL_VPN_IP/${VPN_IP}/g" /etc/rtpengine/rtpengine.conf


sed -i -e "s/FILL_MY_IP/${MY_IP}/g" /healthcheck.sh


sed -i -e "s/FILL_MY_DOMAIN/${MY_DOMAIN}/g" /etc/kamailio/kamailio.cfg
sed -i -e "s/FILL_MY_DOMAIN/${MY_DOMAIN}/g" /etc/kamailio/kamctlrc

# Allow disabling TLS by setting the TLS_DISABLE env variable to true
if [ "$TLS_DISABLE" == true ]; then
  sed -i -e "s/#!define WITH_TLS/##!define WITH_TLS/" /etc/kamailio/kamailio.cfg
fi

# shellcheck disable=SC2068
exec $@
