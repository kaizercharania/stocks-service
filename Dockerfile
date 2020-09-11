FROM ubuntu:18.04

EXPOSE 8080 8081 443

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.6 \
    nginx \
    python3.6-dev \
    git \
    python-virtualenv \
    python-pip \
    python-setuptools \
    libjemalloc1 \
    libjemalloc-dev \
    libssl-dev \
    libffi-dev \
    libxslt-dev \
    libxml2-dev \
    libpq-dev \
    gcc \
    curl \
    make \
    wget \
    sudo && \
    apt-get -o Dpkg::Options::="--force-confmiss" install -y --reinstall netbase && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /apps && mkdir /apps/deploy mkdir /apps/scripts_and_mappings

RUN python -m virtualenv env -p python3.6 && \
    . env/bin/activate && \
    pip install -U pip && \
    pip install --upgrade pip

COPY requirements.txt /apps/requirements.txt

RUN pip install -r /apps/requirements.txt

RUN mkdir /apps/app
COPY app/ /apps/app/
COPY deploy/  apps/deploy/
COPY setup.sh /apps/setup.sh

RUN mkdir /apps/settings && \
    mkdir /apps/settings/env && \
    mkdir /apps/settings/secrets && \
    mkdir /apps/settings/test


RUN chmod +x /apps/setup.sh

WORKDIR /apps/app