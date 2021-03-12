# Start with a foundation of Ubuntu 20.04
FROM ubuntu:focal

# Allow for setting up locale without intervention
ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NONINTERACTIVE_SEEN=true
COPY ./conf /conf/

# Install necessary software
RUN debconf-set-selections /conf/debconf.conf && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        tzdata \
        wget curl git \
        ca-certificates build-essential autoconf libtool \
        python2.7 python3.8 python3-pip && \
    apt-get clean && \
    pip3 install numpy sklearn pandas matplotlib seaborn && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./code /code/
WORKDIR /code
ENTRYPOINT ["/code/run.sh"]
