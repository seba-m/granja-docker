FROM chronograf:1.10.1

ARG URL
ENV INFLUXDB_URL=${URL}

ARG ORG
ENV INFLUXDB_ORG=${ORG}

COPY entrypoint.sh /docker-entrypoint-initdb.d/entrypoint.sh
RUN chmod +x /docker-entrypoint-initdb.d/entrypoint.sh

ENTRYPOINT ["/docker-entrypoint-initdb.d/entrypoint.sh"]