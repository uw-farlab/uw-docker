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

NOTE: UW maintains private versions of echotools and GUTILS due until
      IP issues are apprporiately managed.

Prepare echotools.zip and gutils.zip from appropriate respository and
branches.

```
# docker build -t jcerma/dev:echotools -f echotools/Dockerfile .
```

```
# docker run --name echotools-run -d jcerma/dev:echotools
```

```
# docker exec -it echotools-run bash
```
