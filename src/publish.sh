VERSION="$1"
OVERRIDE="$2"
REPO_TOKEN="$3"

echo "VERSION=$VERSION"
echo "OVERRIDE=$OVERRIDE"

docker login ghcr.io -u ${GITHUB_REF} -p ${REPO_TOKEN}

VERSION=$VERSION docker-compose -f docker-compose.yml -f $OVERRIDE up --no-start --remove-orphans
IMAGES=$(docker inspect --format='{{.Image}}' $(docker ps -aq))

echo "IMAGES: $IMAGES"
for IMAGE in $IMAGES; do
    echo "IMAGE: $IMAGE"
    NAME=$(docker inspect --format '{{index .Config.Labels "name"}}' $IMAGE)
    TAG="ghcr.io/${{ github.repository }}/$NAME:$VERSION"
    LATEST="ghcr.io/${{ github.repository }}/$NAME:latest"
    echo "NAME: $NAME, IMAGE: $IMAGE, TAG: $TAG, LATEST: $LATEST"
    docker tag $IMAGE $TAG
    docker tag $IMAGE $LATEST
    docker push $TAG
    docker push $LATEST
done
