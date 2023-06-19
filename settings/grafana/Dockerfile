FROM grafana/grafana:8.2.6

COPY grafana.ini /etc/grafana/grafana.ini
COPY datasources/ /shared/grafana/provisioning/datasources
COPY dashboards/ /shared/grafana/provisioning/dashboards

USER root
RUN rm -r /etc/grafana/provisioning && ln -s /shared/grafana/provisioning /etc/grafana/provisioning
USER grafana

CMD ["grafana-server", "--config=/etc/grafana/grafana.ini"]
