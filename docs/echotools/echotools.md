# echotools

# Image construction

This allows distribution of an echotools and GUTILS container for data
processing.

NOTE: UW maintains private versions of echotools and GUTILS until
      IP attribution are appropriately managed.

Prepare echotools.zip and gutils.zip from respective repositories and
branches.  These need to be distributed with the provided Dockerfile
for this image.

Once the zip files are installed with the clone of the repository, a
base image may be built using:

```
# docker build -t jcerma/dev:echotools -f echotools/Dockerfile .
```

A [customized](../notes.md) build with a different user and group may be done as well.
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
# An error should be returned if the container is
# not yet initialized.

# docker exec -u portal -w /home/portal -it echotools-run ls
ls: cannot open directory '.': Permission denied

# The container log can be consulted to verify that the
# container is initialized after the first initial use.
# docker container logs echotools-run
START: Initializing container for first use.
portal 1063 users 100
Adding system user `portal' (UID 1063) ...
Adding new user `portal' (UID 1063) with group `users' ...
Creating home directory `/home/portal' ...
DONE: Container initialized.

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

## Processing a deployment using GUTILS

Near real time processing identical to delayed mode
processing.  The only thing that is different is
the directory paths.

In this example, we have a deployment (`20230321`) for glider (`unit_507`)
that we wish to process into netCDF files to inject into the data
management pipeline.

In the example above, the directory on the host is
`/home/portal/glider/test`. This is mounted to the container
using the directory `/deployments`.  Both directories have
the same information and provides the pathway of communication
between the host and the container.

The `/deployments` directory will be referred to as the
deployment root (DR).

The following directory hierarchy is now observed within
the deployment root:

```
${DR}/${GLIDER}/${DEPLOYMENT}

DR: Deployment Root
GLIDER: Glider name (unit_507)
DEPLOYMENT: Typically the first day of a deployment
```

The directory hierarch within the `${DEPLOYMENT}` is:

```
config/
log/
${PROCESS}/${MODE}/
                   ascii
                   binary
                   netcdf
```

The two available processing methods are `echotools`
and `gutils`.

### Setup

For each deployment, a set of configuration files
needs to be placed into the `config` directory.

The following files are required:
 * Glider cache files (`*.cac`)
 * echotools.json
 * deployment.json
 * instruments.json

A `gutilsProcessRT.sh` can be copied to the deployment
directory.  The environment variables need to be
adjusted to match the deployment being processed.

```
DR="/deployments"
FT="Glider 507 March 2023 GOA Survey"
DEP="20230321"
GLIDER="unit_507"
```

### Staging

Raw glider files should be copied into the binary
directory.

For near real time glider files, the files should
reside in the directory `gutils/rt/binary`.  For
post processing delayed mode data, the binary files
need to be in the `gutils/rt/delayed` directory.

### Processing

To process the above deployment from the host using the container:
```
$ sudo docker exec -u portal -w /home/portal -it echotools-run bash /deployments/unit_507/20230321/gutilsProcessRT.sh
```

If all goes well, the binary data is processed into netCDF files which
can be found in the `gutils/{rt,delayed}/netcdf` directory.

If there is a processing error, those will be noted in the log
directory with a log file called `gutils.log`.
