# Yarn front-end Docker images

Images for running [Yarn](https://yarnpkg.com/) but with tools installed for front end development (e.g. To optimize images)

## Build

```docker build --build-arg NODE_VERSION=13.3.0-alpine3.11 --build-arg YARN_VERSION=1.22.0 -t leonyork/yarn-front-end-builder .```

## Test

```docker run leonyork/yarn-front-end-builder --version```