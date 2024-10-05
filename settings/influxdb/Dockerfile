FROM influxdb:2.7.1

ARG URL
ENV INFLUXDB_URL=${URL}

ARG USERNAME
ENV INFLUXDB_USERNAME=${USERNAME}

ARG PASSWORD
ENV INFLUXDB_PASSWORD=${PASSWORD}

ARG DB
ENV INFLUXDB_DATABASE=${DB}

ARG ORG
ENV INFLUXDB_ORG=${ORG}

ARG MOSQUITTO_URL
ENV MOSQUITTO_URL=${MOSQUITTO_URL}

ARG MOSQUITTO_TOPICS
ENV MOSQUITTO_TOPICS=${MOSQUITTO_TOPICS}

ARG MOSQUITTO_FORMAT
ENV MOSQUITTO_FORMAT=${MOSQUITTO_FORMAT}

RUN apt-get update && apt-get install -y python3 python3-toml python3-yaml

COPY entrypoint.sh /docker-entrypoint-initdb.d/entrypoint.sh
COPY config/telegraf.conf /shared/telegraf/telegraf.conf
COPY config/config.py /shared/config.py

RUN chmod +x /shared/config.py
RUN chmod +x /docker-entrypoint-initdb.d/entrypoint.sh

ENTRYPOINT ["/docker-entrypoint-initdb.d/entrypoint.sh"]