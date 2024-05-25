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

```
# docker build -t jcerma/dev:jammy-2204 -f base/ubuntu/Dockerfile .
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

To capture the full build output for debugging:
```
# docker build --no-cache --progress=plain -t jcerma/dev:echotools \
      -f echotools/Dockerfile . >& build.log
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

```
# docker exec -it echotools-run bash
```

Within the container, verify that you can access one of the
scripts:
```
$ sudo docker exec -it echotools-run gosu portal bash
$ cd
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

 * [entrypoint.sh](https://github.com/Unidata/tomcat-docker/blob/latest/entrypoint.sh)
