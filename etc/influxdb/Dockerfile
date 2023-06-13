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

ARG TOKEN
ENV INFLUXDB_TOKEN=${TOKEN}

ENV MARKER_FILE="/shared/.initialized"
ENV TOKEN_FILE="/shared/token"

COPY influx_setup.sh /docker-entrypoint-initdb.d/influx_setup.sh

RUN chmod +x /docker-entrypoint-initdb.d/influx_setup.sh
