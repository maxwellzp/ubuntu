FROM ubuntu:24.04

COPY ./24.04/ .
RUN chmod +x /setup.sh

ENV PATH="$PATH:/usr/local/go/bin"
RUN ./setup.sh

