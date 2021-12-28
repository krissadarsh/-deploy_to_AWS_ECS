FROM ubuntu:focal

LABEL LABEL "for testing"

ARG RDS_PRIMARY_ROOT_CA_SRC=https://s3.amazonaws.com/rds-downloads/rds-ca-2019-root.pem
ARG RDS_PRIMARY_ROOT_CA_DEST=/usr/local/share/ca-certificates/rds-ca-2019-root.crt
ARG RDS_SECONDARY_ROOT_CA_SRC=https://s3.amazonaws.com/rds-downloads/rds-ca-2015-root.pem
ARG RDS_SECONDARY_ROOT_CA_DEST=/usr/local/share/ca-certificates/rds-ca-2015-root.crt

ENV DEBIAN_FRONTEND=noninteractive

RUN \
  echo "**** install apt packages ****" && \
    apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl vim-tiny gnupg apt-transport-https && \
  echo "**** update OS repos ****" && \
    apt-get clean && apt-get update && apt-get dist-upgrade -y && apt-get clean && apt-get autoremove && \
  echo "**** install AWS RDS root CA ****" && \
    curl -sL ${RDS_PRIMARY_ROOT_CA_SRC} -o ${RDS_PRIMARY_ROOT_CA_DEST} && chmod 0644 ${RDS_PRIMARY_ROOT_CA_DEST} && \
    curl -sL ${RDS_SECONDARY_ROOT_CA_SRC} -o ${RDS_SECONDARY_ROOT_CA_DEST} && chmod 0644 ${RDS_SECONDARY_ROOT_CA_DEST} && update-ca-certificates && \
  echo "**** done ****"