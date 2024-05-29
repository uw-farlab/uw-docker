# jcerma/dev:jammy-2204

## Build details

```
# docker build -t jcerma/dev:jammy-2204 -f base/ubuntu/Dockerfile .
```

This container is [customizable](../notes.md).

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


