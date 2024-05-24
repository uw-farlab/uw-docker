FROM jcerma/dev:jammy-2204

RUN mkdir /src/
WORKDIR /src/

# Temp dir required for unit tests.
RUN mkdir /temp/

# Load private resources
COPY echotools.zip .
COPY gutils.zip .

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

# Load needed git resources
RUN git clone --branch uwmain https://github.com/uw-farlab/pocean-core.git
RUN cd pocean-core && \
    eval "$(micromamba shell hook --shell bash)" && \
    micromamba activate py311 && \
    micromamba install -q -y \
        --file requirements.txt \
        --file requirements-dev.txt && \
    python -m pip install .

# Make this container runnable
COPY ./base/bin/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
