FROM ubuntu:24.04

COPY ./24.04/ .
RUN chmod +x /setup.sh

RUN ./setup.sh

