# Creates an image that can be used for building the client app. Since there are multiple variables (e.g. Cognito urls)
# that are needed for the build, we create a builder image rather than a traditional archive. These variables are passed
# in as environment variables when running the build
ARG NODE_VERSION
FROM node:${NODE_VERSION} AS base

RUN \
  apk add --no-cache autoconf automake bash g++ libtool libc6-compat libjpeg-turbo-dev libpng-dev make nasm python libwebp libxi mesa-gl gconf && \
  apk add vips-dev fftw-dev gdal gdal-dev --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community --repository http://dl-3.alpinelinux.org/alpine/edge/main && \
  rm -fR /var/cache/apk/*

ARG YARN_VERSION
RUN npm install yarn@${YARN_VERSION}

ENTRYPOINT [ "yarn" ]
CMD ["--help"]