# Use --build-arg to override defaults, works like
# bash USER_NAME=${USER_NAME:-cuser}. ARG has to be
# before any FROM statement.

ARG USER_NAME=cuser
ARG GROUP_NAME=cdata
ARG USER_ID=1000
ARG GROUP_ID=1000

FROM jcerma/jammy:22.04.3LTS AS build

# Pull in variables into this build context

ARG USER_NAME
ARG GROUP_NAME
ARG USER_ID
ARG GROUP_ID

ENV USER_NAME=${USER_NAME}
ENV GROUP_NAME=${GROUP_NAME}
ENV USER_ID=${USER_ID}
ENV GROUP_ID=${GROUP_ID}

SHELL ["/bin/bash", "-c"]
ENV PATH=/home/${USER_NAME}/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin

COPY ./base/bin/setgroup.sh /

# Base packages
# Save the default user name and group name for the container
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y curl git less unzip vim && \
    ./setgroup.sh && \
    adduser --system --uid ${USER_ID} --gid ${GROUP_ID} --gecos "" \
        --home /home/${USER_NAME} ${USER_NAME} && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo ${USER_NAME} > /etc/container.user && \
    echo ${GROUP_NAME} > /etc/container.group && \
    apt-get clean

# Switch to non-root user as the default user
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

# Mamba
# REF: https://mamba.readthedocs.io/en/latest/installation/micromamba-installation.html
RUN curl -L micro.mamba.pm/install.sh | bash && \
    source  ~/.bashrc && \
    micromamba self-update

COPY ./base/bin/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
