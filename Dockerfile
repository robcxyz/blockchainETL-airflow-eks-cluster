FROM apache/airflow:1.10.10-python3.6

USER root
# install binary dependancies
RUN apt-get update \
 && apt-get -y install \
    gcc \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

USER airflow
