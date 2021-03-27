FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    make \
    openjdk-17-jdk \
    nginx \
    supervisor

RUN apt-get clean && apt-get autoclean

COPY nginx.conf         /etc/nginx/nginx.conf
COPY supervisor.conf    /etc/supervisor/conf.d/supervisor.conf

WORKDIR /app

EXPOSE 80
