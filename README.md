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

