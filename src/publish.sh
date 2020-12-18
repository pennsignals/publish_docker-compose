VERSION="$1"
DOCKER_COMPOSE="$2"

echo ${{ secrets.GITHUB_TOKEN }} | docker login docker.pkg.github.com -u ${{ github.actor }} --password-stdin

# build and run the docker images
docker-compose -f $DOCKER_COMPOSE up --no-start

# get all built IDs
IMAGE_IDs=$(docker-compose -f $DOCKER_COMPOSE images -q)

echo "IMAGE_IDs: $IMAGE_IDs"

while read -r IMAGE_ID; do

    echo "IMAGE_ID: $IMAGE_ID"
    # get the name label
    NAME=$(basename ${{ github.repository }}).$(docker inspect --format '{{ index .Config.Labels.name }}' $IMAGE_ID)
    PUSH="docker.pkg.github.com/${{ github.repository }}/$NAME:$VERSION"

    # tag and push
    docker tag $IMAGE_ID $PUSH
    docker push $PUSH

done <<< "$IMAGE_IDs"