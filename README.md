# uw-docker

Docker containers curated by University of Washington
Fisheries Acoustic Research Lab (uw-farlab)

The images are hosted at [hub.docker.com/jcerma](https://hub.docker.com/repositories/jcerma).

## dev images

### jcerma/jammy

The first base image created is based on Ubuntu 22.04.3LTS.  Please
see [details](docs/jammy/22.04.3LTS.md) for more information.

### jcerma/dev:jammy-2204

This is the base image plus curl, file, git, less, unzip and vim.
Build [details](docs/dev/jammy-2204.md).

### jcerma/dev:erddap-maven

This image is based off this [Dockerfile](https://github.com/uw-farlab/erddap/blob/main/development/docker/Dockerfile)
but makes it interactive.  Build [details](docs/dev/erddap-maven.md).

### echotools

This is a *private* image.  Please contact the UW-FAR lab for access.
Build [details and instructions](docs/echotools/echotools.md).
