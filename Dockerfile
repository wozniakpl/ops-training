FROM python:3.8-slim AS base

RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y \
    python3 python3-dev python3-pip \
    && apt clean && rm -rf /var/lib/apt/lists/*

WORKDIR /code

COPY requirements.txt .
RUN pip3 install -r requirements.txt

FROM base AS app1
COPY app1/ /code/

FROM base AS app1
COPY app2/ /code/
