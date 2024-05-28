# uw-docker
docker containers curated by uw-farlab

## dev images

### jammy-2204-dev

Source image from operating system:
```
# debootstrap jammy jammy > jammy.txt
# tar -C jammy -c . | docker image import - jammy:22.04.3LTS
# docker image ls
REPOSITORY   TAG          IMAGE ID       CREATED         SIZE
jammy        22.04.3LTS   7dde64393ab3   6 minutes ago   374MB
```

The build of this container contains four environment variables that
can be overridden to allow matching UID/GIDs of the user utilizing
these containers for work.  The four environment variables are:
 * `USER_NAME`: The user name for the container (default: cuser).
 * `GROUP_NAME`: The group name for the container (default: cdata).
 * `USER_ID`: The user id for the container (default: 1000).
 * `GROUP_ID`: The groud id for the container (default: 1000).

NOTE: These variables in bash need to be exported prior to running
sudo to allow them to be passed to docker.

```bash
export USER_NAME=${USER}
export GROUP_ID=`id -g`
export USER_ID=`id -u`
IFS=":" read -ra GROUPDATA <<< `getent group ${GROUP_ID}`
export GROUP_NAME=${GROUPDATA[0]}
```

```
# docker build -t jcerma/dev:jammy-2204 -f base/ubuntu/Dockerfile .
```

To modify the build environment using one or more of the variables
above, they are added as build arguments.  Do not pass unset
variables.

```
# docker build -t jcerma/dev:jammy-2204 -f base/ubuntu/Dockerfile \
  --build-arg USER_NAME=${USER_NAME} \
  --build-arg GROUP_NAME=${GROUP_NAME} \
  --build-arg USER_ID=${USER_ID} \
  --build-arg GROUP_ID=${GROUP_ID} \
  .
```

To capture debugging information:
```
# docker build --no-cache --progress=plain -t jcerma/dev:jammy-2204 \
  -f base/ubuntu/Dockerfile . 2>&1 | tee jammy.log
```


```
# docker run --name jammy-inter -d jcerma/dev:jammy-2204
```

```
# docker exec -it jammy-inter bash
```

### erddap-maven-dev

```
# docker build -t jcerma/dev:erddap-maven -f base/maven/Dockerfile .
```

```
# docker run --name erddap-inter -d jcerma/dev:erddap-maven
```

```
# docker exec -it erddap-inter bash
```

## echotools

This allows distribution of an echotools and GUTILS container for data
processing.

NOTE: UW maintains private versions of echotools and GUTILS until
      IP issues are appropriately managed.

Prepare echotools.zip and gutils.zip from respective repositories and
branches.

```
# docker build -t jcerma/dev:echotools -f echotools/Dockerfile .
```

A customized build with a different user and group may be done as well.
```
# docker build -t jcerma/dev:echotools -f echotools/Dockerfile \
  --build-arg USER_NAME=${USER_NAME} \
  --build-arg GROUP_NAME=${GROUP_NAME} \
  --build-arg USER_ID=${USER_ID} \
  --build-arg GROUP_ID=${GROUP_ID} \
  .
```


To capture the full build output for debugging:
```
# docker build --no-cache --progress=plain -t jcerma/dev:echotools \
  -f echotools/Dockerfile . 2>&1 | tee echo.log
```

With custom arguments:
```
# docker build --no-cache --progress=plain -t jcerma/dev:echotools \
  --build-arg USER_NAME=${USER_NAME} \
  --build-arg GROUP_NAME=${GROUP_NAME} \
  --build-arg USER_ID=${USER_ID} \
  --build-arg GROUP_ID=${GROUP_ID} \
  -f echotools/Dockerfile . 2>&1 | tee build.log
```

Run the container and mount the directory for processing glider files.
Pass any optional metadata to help with setting appropriate permissions
on the passed directory.
```
# docker run \
      --mount type=bind,source=/home/portal/glider/test,target=/deployments \
      --env USER_ID=1063 --env GROUP_ID=100 \
      --env USER_NAME=portal --env GROUP_NAME=users \
      --name echotools-run -d jcerma/dev:echotools
```

If you use a specified user name and group name, use following
exec command to enter the container.  NOTE: The first time
running the container, the /home directory has to be adjusted.
It may be a minute or so before the home directory is usable.
```
# Check that things are usable without error.  Run the 
# command below until no error is returned.

# docker exec -u portal -w /home/portal -it echotools-run ls
ls: cannot open directory '.': Permission denied

# This is what it should return
# docker exec -u portal -w /home/portal -it echotools-run ls
micromamba  src

# docker exec -u portal -w /home/portal -it echotools-run bash
```

Within the container, verify that you can access one of the
scripts:
```
$ sudo docker exec -it echotools-run bash
$ micromamba activate py311
$ mkGIS.py --help
usage: mkGIS.py [-h] [--deploymentDir DEPLOYMENTDIR] [-u U] [-d D] [-p P] [-t T] [--portalJson] [--bathy] [--evl] [--gps] [--outDir OUTDIR] [--evlOut EVLOUT] [--gpsOut GPSOUT]
                [--logFile LOGFILE] [--preload]

mkGIS.py: This program produces several types of metadata files from processed glider data.

options:
  -h, --help            show this help message and exit
  --deploymentDir DEPLOYMENTDIR
                        full or relative path to deployment config files
  -u U                  glider name
  -d D                  deployment name
  -p P                  processing pipeline: echotools or gutils
  -t T                  glider file type: rt, rtd or delayed
  --portalJson          generate portal json gis output
  --bathy               generate subset bathymetric datasets
  --evl                 generate EVL file
  --gps                 generate GPS.CSV file
  --outDir OUTDIR       alternate output directory for all requested files
  --evlOut EVLOUT       alternate output filename for EVL file
  --gpsOut GPSOUT       alternate output filename for GPS.CSV file
  --logFile LOGFILE     Allows saving of output to a log file
  --preload             Load glider data fully into memory before use
```

## References

 * [Dockerfile](https://docs.docker.com/reference/dockerfile/)
 * [docker exec](https://docs.docker.com/reference/cli/docker/container/exec/)
 * [docker run](https://docs.docker.com/reference/cli/docker/container/run/)
 * [thredds-docker](https://github.com/Unidata/thredds-docker)
 * [tomcat-docker](https://github.com/Unidata/tomcat-docker)
