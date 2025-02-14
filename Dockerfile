FROM debian:11-slim

# Basic build-time metadata as defined at http://label-schema.org
LABEL org.label-schema.docker.dockerfile="/Dockerfile" \
  org.label-schema.license="MIT" \
  org.label-schema.name="WebRTC SIP Gateway" \
  org.label-schema.description="A WebRTC-SIP gateway for Fritzbox based on Kamailio and rtpengine" \
  org.label-schema.url="https://github.com/florian-h05/webrtc-sip-gw" \
  org.label-schema.vcs-type="Git" \
  org.label-schema.vcs-url="https://github.com/florian-h05/webrtc-sip-gw.git" \
  maintainer="Florian Hotze <florianh_dev@icloud.com>"

# Install requirements
RUN \
  apt-get update \
  && apt-get install -y --no-install-recommends wget curl gnupg2 ca-certificates iproute2 supervisor nano

# Add rtpengine source
RUN \
  wget https://dfx.at/rtpengine/latest/pool/main/r/rtpengine-dfx-repo-keyring/rtpengine-dfx-repo-keyring_1.0_all.deb \
  && dpkg -i rtpengine-dfx-repo-keyring_1.0_all.deb \
  && echo 'deb [signed-by=/usr/share/keyrings/dfx.at-rtpengine-archive-keyring.gpg] https://dfx.at/rtpengine/10.5 bullseye main' > /etc/apt/sources.list.d/rtpengine.list
# Install Kamailio and rtpengine
RUN \
  apt-get update \
  && apt-get install -y --no-install-recommends rtpengine \
  && apt-get install -y --no-install-recommends kamailio kamailio-websocket-modules kamailio-tls-modules kamailio-presence-modules

# Do not persist /tmp in a volume to allow clearing it by restarting the container
# VOLUME ["/tmp"]

# Expose rtpengine UDP ports
EXPOSE 23400-23500/udp
# Expose Kamailio TCP ports for unsecured and secured SIP over WebSocket
EXPOSE 8090 4443

# Set healthcheck
HEALTHCHECK --interval=1m --timeout=5s --retries=3 CMD bash /healthcheck.sh

COPY ./entrypoint.sh /entrypoint.sh
COPY ./healthcheck.sh /healthcheck.sh
# Copy configuration
COPY ./config/supervisor-rtpengine.conf /etc/supervisor/conf.d/rtpengine.conf
COPY ./config/supervisor-kamailio.conf /etc/supervisor/conf.d/kamailio.conf
COPY ./config/rtpengine/rtpengine.conf /etc/rtpengine/rtpengine.conf
COPY ./config/kamailio/kamailio.cfg /etc/kamailio/kamailio.cfg
COPY ./config/kamailio/kamctlrc /etc/kamailio/kamctlrc
COPY ./config/kamailio/tls.cfg /etc/kamailio/tls.cfg

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf -u root"]


			# $xavp(Via=>branch) = "FILL_VPN_IP";
			# via_use_xavp_fields("1");