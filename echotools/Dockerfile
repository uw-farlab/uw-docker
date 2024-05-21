FROM jcerma/dev:jammy-2204

RUN mkdir /src/
WORKDIR /src/

# Temp dir required for unit tests.
RUN mkdir /temp/

# Load private resources
COPY echotools.zip .
COPY gutils.zip .

# Add and build dependencies


# Make this container runnable
COPY ./base/bin/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
