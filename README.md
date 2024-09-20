# Archived

Consider using version and publish scripts:

version.sh

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ "${GITHUB_REF}" == refs/tags/* ]]; then
    version=$(basename "${GITHUB_REF}")
else
    version=${GITHUB_SHA}
fi

echo $version
```

publish.sh

```bash
#!/usr/bin/env bash
set -euo pipefail

function usage {
    echo ""
    echo "Publish labeled images from docker compose."
    echo ""
    echo "usage: --build -b bool --registry -r string --username -u string --password -p string"
    echo ""
    echo "  --build -b bool          build images"
    echo "                           (default: false"
    echo "  --registry -c string     registry"
    echo "                           (default: ghcr.io)"
    echo "  --username -u string     username GITHUB_REF"
    echo "  --password -p string     password GITHUB_TOKEN"
    echo "  --repository -r string   repository GITHUB_REPOSITORY"
    echo "  --version -v string      version"
    echo "                           (example: 4.0.0-rc.1)"
    echo "  --help -h                Print usage and exit"
    echo ""
}


while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
        ;;
        -b|--build)
            build="$2"
        ;;
        -c|--registry)
            registry="$2"
        ;;
        -u|--username)
            username="$2"
        ;;
        -p|--password)
            password="$2"
        ;;
        -r|--repository)
            repository="$2"
        ;;
        -v|--version)
            version="$2"
        ;;
        *)
            invalid_parameter $1
    esac
    shift
    shift
done

build="${build:-false}"
registry="${registry:-ghcr.io}"
username="${username:=$GITHUB_REF}"
password="${password:=$GITHUB_TOKEN}"
repository="${repository:=$GITHUB_REPOSITORY}"
repository=$(echo "$repository" | tr '[:upper:]' '[:lower:]')

docker login "${registry}" -u "${username}" -p "${password}"

if [[ "${build}" == true ]]; then
    docker compose -f docker-compose.yml build --no-cache
fi

echo "version: ${version}"
images=$(docker images --filter "label=name" --format='{{.ID}}')

echo "images: ${images}"
for image in $images; do
    name=$(basename "${repository}").$(docker inspect --format '{{ index .Config.Labels "name" }}' "${image}")
    tag="${registry}/${repository}/${name}:${version}"

    echo "image: ${image}; tag: ${tag}"
    docker tag "${image}" "${tag}"
    docker push "${tag}"
done
```

Along with this fragment for your github workflow:

.github/workflows/release.yml

```yaml

jobs:
  publish:
    runs-on: ubuntu-latest
    outputs:
      version: ${{ steps.version.outputs.version }}
    steps:
      - id: checkout
        uses: actions/checkout@v4

      - id: version
        run: |
          version=$(./scripts/version.sh)
          echo "version = ${version}"
          echo "version=${version}" >> $GITHUB_OUTPUT

      - id: publish
        run: |
          ./scripts/publish.sh -b true -p "${{ secrets.GITHUB_TOKEN }}" -v "${{ steps.version.outputs.version }}"
```

---

# Docker-Compose Publish

A GitHub Action that builds and publishes containers from docker-compose file to the current github repository

## Features

No need to manually build and publish each dockerfile. Simply publish the files that you are using.

Automatically publishes images to github repo

Each dockerfile target must have a `LABEL name="<name>`. This is used to name the published file

If version is blank (recommended), the release tag version is used.

## Example Usage
```
    - name: publish
      uses: pennsignals/publish_docker-compose@v0.1.0
      with:
        version: '0.2.6-rc.1' # optional
        docker_compose: 'docker-compose.build.yml' # required
        repo_token: "${{ secrets.GITHUB_TOKEN }}"
```

## Input

Below is a breakdown of the expected action inputs.

### `version`

Tag to be published


### `docker_compose`

docker-compose file to use

### `repo_token`

repository token: ${{ secrets.GITHUB_TOKEN }}

## Docker-compose file
```
# docker-compose.build.yml

version: "3.8"

services:

  postgres:
    build:
      context: ./postgres
      target: postgres

  predict:
    build:
      context: .
      dockerfile: predict/dockerfile
      target: predict

  predict.jupyter:
    build:
      context: .
      dockerfile: ./predict/dockerfile
      target: predict.jupyter
```

