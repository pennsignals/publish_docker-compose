
FROM docker/compose:debian-1.27.3 as publish
LABEL name="publish"

ADD entrypoint.sh /entrypoint.sh

ADD ./src/publish.sh /scripts/publish.sh
ADD ./src/version.sh /scripts/version.sh

RUN chmod -R 555 /scripts

ENTRYPOINT [ "/entrypoint.sh" ]
