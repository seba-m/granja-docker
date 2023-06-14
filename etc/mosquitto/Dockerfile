FROM eclipse-mosquitto:2.0.15

COPY mosquitto.conf /mosquitto/config/mosquitto.conf

RUN mkdir -p /mosquitto/log/ && chown -R mosquitto:mosquitto /mosquitto/log/

CMD ["/usr/sbin/mosquitto", "-c", "/mosquitto/config/mosquitto.conf", "-v"]
