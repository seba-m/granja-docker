FROM grafana/grafana:9.5.5

COPY grafana.ini /etc/grafana/grafana.ini
COPY datasources/ /shared/grafana/provisioning/datasources
COPY dashboards/ /shared/grafana/provisioning/dashboards
COPY entrypoint.sh /docker-entrypoint-initdb.d/entrypoint.sh

USER root
RUN rm -r /etc/grafana/provisioning && ln -s /shared/grafana/provisioning /etc/grafana/provisioning
RUN chmod +x /docker-entrypoint-initdb.d/entrypoint.sh
USER grafana

#CMD [ "grafana-server",  "--config=/etc/grafana/grafana.ini" ]

ENTRYPOINT ["/docker-entrypoint-initdb.d/entrypoint.sh"]