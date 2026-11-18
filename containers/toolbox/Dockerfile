FROM ubuntu:24.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       nmap \
       iproute2 \
       iputils-ping \
       curl \
       iperf3 \
    && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
