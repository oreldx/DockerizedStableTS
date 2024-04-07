# Dockerized Stable TS

```
docker build -t dockerized-stable-ts .

docker run -v $PWD/models:/usr/src/app/models -p 80:5000 dockerized-stable-ts:latest
```
