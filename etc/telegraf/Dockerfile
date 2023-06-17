FROM telegraf:1.26.3

RUN apt-get update && apt-get install -y --no-install-recommends python3 python3-toml && rm -rf /var/lib/apt/lists/*

COPY telegraf.py /shared/telegraf/telegraf.py
COPY entrypoint.sh /docker-entrypoint-initdb.d/entrypoint.sh

RUN chmod +x /shared/telegraf/telegraf.py
RUN chmod +x /docker-entrypoint-initdb.d/entrypoint.sh

ENTRYPOINT ["/docker-entrypoint-initdb.d/entrypoint.sh"]