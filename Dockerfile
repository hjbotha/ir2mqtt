ARG BUILD_FROM
FROM debian:buster-slim

ENV LANG C.UTF-8

# Copy data for add-on
RUN apt-get update && apt-get install -y --no-install-recommends bash ca-certificates jq
#    && mkdir -p /tmp/bashio \
#    && curl -L -s https://github.com/hassio-addons/bashio/archive/v${BASHIO_VERSION}.tar.gz | tar -xzf - --strip 1 -C /tmp/bashio \
#    && mv /tmp/bashio/lib /usr/lib/bashio \
#    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
#    && rm -rf /tmp/bashio

RUN apt-get install --no-install-recommends -y mosquitto-clients lirc task-spooler net-tools vim-tiny
#RUN apt-get install -y vim-tiny

RUN rm -rf /var/lib/apt/lists/*

# Copy data for add-on
COPY queue_message_and_show_output.sh /
RUN chmod a+x /queue_message_and_show_output.sh

COPY handle_message.sh.template /
COPY mceusb.conf /etc/lirc/lircd.conf.d/
COPY irexec.lircrc /etc/lirc/irexec.lircrc
COPY lirc_options.conf /etc/lirc/

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
