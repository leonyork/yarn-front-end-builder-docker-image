#!/usr/bin/env sh
#######################################################################
# Build, test and push the images
# Creates multiple versions so that there's some choice about versions
# to use
#######################################################################
set -eux
version=1.0.0

# Number of releases to go back from the latest version
number_of_yarn_releases=3
number_of_node_releases=5

# Creates tags of the form {version}-{YARN_VERSION}-{NODE_VERSION} (e.g. 1.0.0-yarn1.22.0-node13.3.0-alpine3.11)
# First gets the last $number_of_node_releases alpine tags where the tag looks like a version number (there were some odd tags that look like dates)
# For each of those tags gets the last $number_of_yarn_releases of non-release candidate versions of the AWS CLI and builds an image
docker run leonyork/docker-tags library/node \
    | grep -E '^[0-9.]+-alpine[0-9.]+$' \
    | tail -n $number_of_node_releases \
    | xargs -I{NODE_VERSION} -n1 \
        sh -c "docker run leonyork/npm-versions yarn \
        | grep -E '^[0-9.]\.[0-9.]+$' \
        | tail -n $number_of_yarn_releases \
        | xargs -I{YARN_VERSION} -n1 sh build-image.sh {NODE_VERSION} {YARN_VERSION} ${version}-yarn{YARN_VERSION}-node{NODE_VERSION} || exit 255" || exit 255

# Generates the latest tag
yarn_latest_version=`docker run leonyork/npm-versions yarn | grep -E '^[0-9.]\.[0-9.]+$' | tail -n 1`
sh build-image.sh alpine latest latest