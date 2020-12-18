# Docker-Compose Publish

A GitHub Action that builds and publishes containers from docker-compose file

## Features

No need to manually build and publish each dockerfile. Simply publish the files that you are using.

Automatically publishes images to github repo

Each dockerfile target must have a `LABEL name="<name>`. This is used to name the published file


## Example Usage
```
    - name: publish
      uses: pennsignals/publish_docker-compose@v1.0.0
      with:
        version: '0.2.6-rc.1' # optional
        docker_compose: 'docker-compose.build.yml' # required
        repo_token: "${{ secrets.GITHUB_TOKEN }}"
```

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

