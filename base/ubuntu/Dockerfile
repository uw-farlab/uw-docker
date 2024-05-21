FROM jcerma/jammy:22.04.3LTS AS build

SHELL ["/bin/bash", "-c"]
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/bin

RUN apt-get -qq update \
    && DEBIAN_FRONTEND="noninteractive" apt-get -qq install -y curl git less vim

RUN curl -L micro.mamba.pm/install.sh | bash \
    && echo ${PATH} \
    && source  ~/.bashrc \
    && micromamba self-update

COPY ./base/bin/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
