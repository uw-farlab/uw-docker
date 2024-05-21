FROM maven:3.9.6-eclipse-temurin-17 AS build

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y curl git less vim unzip

RUN mkdir /app/
WORKDIR /app/

RUN git clone https://github.com/ERDDAP/erddap.git

RUN ln -s erddap/pom.xml . \
    && ln -s erddap/development . \
    && ln -s erddap/download . \
    && ln -s erddap/images . \
    && ln -s erddap/src . \
    && ln -s erddap/WEB-INF .

COPY ./base/bin/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
