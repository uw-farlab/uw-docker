FROM jcerma/dev:jammy-2204

RUN mkdir /src/
WORKDIR /src/

# Ignore pip run as root warnings
ENV PIP_ROOT_USER_ACTION=ignore

# Temp dir required for unit tests.
RUN mkdir /temp/

# Create deployments directory for 
# data processing
RUN mkdir /deployments/

# Load private resources
COPY echotools.zip .
COPY gutils.zip .

# Unpack private resources
RUN unzip -q echotools.zip
RUN unzip -q gutils.zip

# Development packages
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y \
    gcc

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
RUN git clone --branch uwmain https://github.com/uw-farlab/pocean-core.git
RUN cd pocean-core && \
    eval "$(micromamba shell hook --shell bash)" && \
    micromamba activate py311 && \
    micromamba install -q -y \
        --file requirements.txt \
        --file requirements-dev.txt && \
    python -m pip install .

RUN git clone --branch ek80validation https://github.com/jr3cermak/pyEcholab.git
RUN cd pyEcholab && \
    eval "$(micromamba shell hook --shell bash)" && \
    micromamba activate py311 && \
    micromamba install -q -y \
        --file requirements.txt && \
    python -m pip install .

# Install IOOS Compliance Checker and plugins

# Install gutils
RUN cd gutils && \
    eval "$(micromamba shell hook --shell bash)" && \
    micromamba activate py311 && \
    micromamba install -q -y \
        --file requirements.txt \
        --file requirements-dev.txt && \
    python -m pip install .

# Install echotools-lib
RUN cd echotools/echotools-libs && \
    eval "$(micromamba shell hook --shell bash)" && \
    micromamba activate py311 && \
    micromamba install -q -y \
        --file requirementsConda.txt && \
    pyb && \
    cd target/dist/echotools-0.2.1 && \
    python -m pip install .

# Make this container runnable
COPY ./base/bin/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
