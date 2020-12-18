#!/bin/bash

# echo all the variabls
echo "VERSION: $VERSION"
echo "DOCKER_COMPOSE: $DOCKER_COMPOSE"

# if VERSION is not set, get it from git repo
if [ -z "$VERSION" ]; then
    VERSION=$(/scripts/version.sh)
fi

echo "VERSION: $VERSION"

/scripts/publish.sh $VERSION $DOCKER_COMPOSE
