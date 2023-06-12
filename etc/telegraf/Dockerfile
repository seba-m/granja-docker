FROM telegraf:1.26.3

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

COPY modify_telegraf_config.py /modify_telegraf_config.py

RUN chmod +x /modify_telegraf_config.py

CMD ["python3", "/modify_telegraf_config.py"]
