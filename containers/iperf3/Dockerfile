FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends iperf3 passwd \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --system --uid 10001 --no-create-home iperf

USER 10001:10001

EXPOSE 5201

CMD ["iperf3", "--server"]
