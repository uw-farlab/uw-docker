# Use --build-arg to override defaults, works like
# bash USER_NAME=${USER_NAME:-cuser}. ARG has to be
# before any FROM statement.

ARG USER_NAME=cuser
ARG GROUP_NAME=cdata
ARG USER_ID=1000
ARG GROUP_ID=1000

FROM jcerma/dev:jammy-2204

ARG USER_NAME
ARG GROUP_NAME
ARG USER_ID
ARG GROUP_ID

ENV USER_NAME=${USER_NAME}
ENV GROUP_NAME=${GROUP_NAME}
ENV USER_ID=${USER_ID}
ENV GROUP_ID=${GROUP_ID}

SHELL ["/bin/bash", "-c"]

# Switch to non-root user as the default user
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

ENV PATH=/home/${USER_NAME}/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin
ENV MAMBA_ROOT_PREFIX=/home/${USER_NAME}/micromamba

# Create directories
#   * Unit tests /temp
#   * Processing glider data /deployments
#   * Create user src directory
RUN sudo mkdir /temp/ && \
    sudo mkdir /deployments/ && \
    mkdir /home/${USER_NAME}/src

# Copy private resources
COPY echotools.zip src/
COPY gutils.zip src/ 

# Unpack private resources
RUN cd src && unzip -q echotools.zip && unzip -q gutils.zip

# Add development packages
RUN sudo DEBIAN_FRONTEND="noninteractive" apt-get install -y \
    gcc && \
    sudo apt-get -y autoremove && \
    sudo apt-get -y clean

# Create environment
RUN micromamba create -q -y --name py311 python=3.11

# dbdreader dependencies
RUN eval "$(micromamba shell hook --shell bash)" && \
    micromamba activate py311 && \
    micromamba install \
    iniconfig lz4 packaging numpy pluggy pytest
RUN eval "$(micromamba shell hook --shell bash)" && \
    micromamba activate py311 && \
    python -m pip install dbdreader

# Load git based resources
RUN cd src && git clone --branch uwmain https://github.com/uw-farlab/pocean-core.git && \
    cd pocean-core && \
    eval "$(micromamba shell hook --shell bash)" && \
    micromamba activate py311 && \
    micromamba install -q -y \
        --file requirements.txt \
        --file requirements-dev.txt && \
    python -m pip install .

RUN cd src && git clone --branch ek80validation https://github.com/jr3cermak/pyEcholab.git && \
    cd pyEcholab && \
    eval "$(micromamba shell hook --shell bash)" && \
    micromamba activate py311 && \
    micromamba install -q -y \
        --file requirements.txt && \
    python -m pip install .

# Install IOOS Compliance Checker and plugins
RUN cd src && \
    git clone --branch develop https://github.com/uw-farlab/compliance-checker.git && \
    git clone --branch main https://github.com/uw-farlab/cc-plugin-glider.git && \
    git clone --branch main https://github.com/uw-farlab/cc-plugin-ncei.git && \
    git clone --branch main https://github.com/uw-farlab/cc-plugin-og && \
    git clone --branch main https://github.com/uw-farlab/cc-plugin-ugrid.git && \
    eval "$(micromamba shell hook --shell bash)" && \
    micromamba activate py311 && \
    cd cc-plugin-glider && \
    micromamba install -q -y --file requirements.txt && \
    python -m pip install . && \
    cd .. && \
    cd cc-plugin-ncei && \
    micromamba install -q -y --file requirements.txt && \
    python -m pip install . && \
    cd .. && \
    cd cc-plugin-og && \
    micromamba install -q -y --file requirements.txt && \
    python -m pip install . && \
    cd .. && \
    cd cc-plugin-ugrid && \
    micromamba install -q -y --file requirements.txt && \
    python -m pip install .

# Install gutils
RUN cd src/gutils && \
    eval "$(micromamba shell hook --shell bash)" && \
    micromamba activate py311 && \
    micromamba install -q -y \
        --file requirements.txt \
        --file requirements-dev.txt && \
    python -m pip install .

# Install echotools-lib
RUN cd src/echotools/echotools-libs && \
    eval "$(micromamba shell hook --shell bash)" && \
    micromamba activate py311 && \
    micromamba install -q -y \
        --file requirementsConda.txt && \
    pyb && \
    cd target/dist/echotools-0.2.1 && \
    python -m pip install .

# Reinstall compliance checker
RUN cd src && \
    eval "$(micromamba shell hook --shell bash)" && \
    micromamba activate py311 && \
    cd compliance-checker && \
    micromamba install -q -y --file requirements.txt && \
    python -m pip install .

# Cleanup
RUN eval "$(micromamba shell hook --shell bash)" && \
    micromamba clean --all -y -f && \
    micromamba activate py311 && \
    python -m pip cache purge

# Make this container runnable
COPY ./echotools/bin/*.sh /
ENTRYPOINT ["/entrypoint.sh"]
