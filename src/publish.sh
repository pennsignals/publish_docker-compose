VERSION="$1"
DOCKER_COMPOSE="$2"
REPO_TOKEN="$3"

echo "VERSION=$VERSION"
echo "DOCKER_COMPOSE=$DOCKER_COMPOSE"

# echo ${REPO_TOKEN} | docker login docker.pkg.github.com -u ${GITHUB_REF} --password-stdin
docker login docker.pkg.github.com -u ${GITHUB_REF} -p ${REPO_TOKEN}

# build and run the docker images
docker-compose -f $DOCKER_COMPOSE up --no-start

# get all built IDs
IMAGE_IDs=$(docker-compose -f $DOCKER_COMPOSE images -q)

echo "IMAGE_IDs: $IMAGE_IDs"

while read -r IMAGE_ID; do

    echo "IMAGE_ID: $IMAGE_ID"
    # get the name label
    NAME=$(basename ${GITHUB_REPOSITORY}).$(docker inspect --format '{{ index .Config.Labels.name }}' $IMAGE_ID)
    PUSH="docker.pkg.github.com/${GITHUB_REPOSITORY}/$NAME:$VERSION"

    # tag and push
    docker tag $IMAGE_ID $PUSH
    docker push $PUSH

done <<< "$IMAGE_IDs"