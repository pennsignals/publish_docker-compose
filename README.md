# Docker-Compose Publish

A GitHub Action that builds and publishes containers ffrom docker-compose file
## Features



## Example Usage
```
    - name: publish
      uses: pennsignals/publish_docker-compose@v1.0.0
      with:
        version: '0.2.6-rc.1' # optional
        docker_compose: 'docker-compose.build.yml' # required
```