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

RUN apt-get update && apt-get install -y --no-install-recommends python3 python3-toml && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /docker-entrypoint-initdb.d/entrypoint.sh
COPY telegraf.conf /shared/telegraf/telegraf.conf
COPY telegraf.py /shared/telegraf/telegraf.py

RUN chmod +x /shared/telegraf/telegraf.py
RUN chmod +x /docker-entrypoint-initdb.d/entrypoint.sh

ENTRYPOINT ["/docker-entrypoint-initdb.d/entrypoint.sh"]