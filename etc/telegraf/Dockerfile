FROM telegraf:1.26.3

COPY telegraf.conf /etc/telegraf/telegraf.conf

CMD [ "telegraf", "--config", "/etc/telegraf/telegraf.conf", "--config-directory", "/etc/telegraf/telegraf.d" ]