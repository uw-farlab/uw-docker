FROM jcerma/jammy:22.04.3LTS AS build

SHELL ["/bin/bash", "-c"]
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/bin

# Base packages
RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y curl git less unzip vim

RUN curl -L micro.mamba.pm/install.sh | bash \
    && echo ${PATH} \
    && source  ~/.bashrc \
    && micromamba self-update

COPY ./base/bin/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
