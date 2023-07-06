FROM grafana/grafana:9.5.5

ARG USERNAME
ENV GRAFANA_USERNAME=${USERNAME}

ARG PASSWORD
ENV GRAFANA_PASSWORD=${PASSWORD}

RUN apt-get update && apt-get install -y python3 python3-yaml

COPY grafana.ini /etc/grafana/grafana.ini
COPY datasources/ /shared/grafana/provisioning/datasources
COPY dashboards/ /shared/grafana/provisioning/dashboards
COPY entrypoint.sh /docker-entrypoint-initdb.d/entrypoint.sh
COPY grafana.py /shared/grafana/grafana.py

USER root
RUN rm -r /etc/grafana/provisioning && ln -s /shared/grafana/provisioning /etc/grafana/provisioning
RUN chmod +x /docker-entrypoint-initdb.d/entrypoint.sh
RUN chown +x /shared/grafana/grafana.py
RUN python3 /shared/grafana/grafana.py
USER grafana

ENTRYPOINT ["/docker-entrypoint-initdb.d/entrypoint.sh"]