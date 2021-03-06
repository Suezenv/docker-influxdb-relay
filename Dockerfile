FROM appcelerator/alpine:20160928
MAINTAINER Nicolas Degory <ndegory@axway.com>

#ENV INFLUXDB_VERSION 1.0.1

RUN apk update && apk upgrade && \
    apk --virtual build-deps add go>1.6 curl git gcc musl-dev make && \
    export GOPATH=/go && \
    go get -v github.com/influxdata/influxdb-relay && \
    cd $GOPATH/src/github.com/influxdata/influxdb-relay && \
    #git checkout -q --detach "v${INFLUXDB_VERSION}" && \
    python ./build.py && \
    chmod +x ./build/influx* && \
    ls -l ./build/* && \
    mv ./build/influx* /bin/ && \
    apk del build-deps && cd / && rm -rf $GOPATH/ /var/cache/apk/*

EXPOSE 9096

COPY relay.toml /etc/relay.toml.tpl
COPY run.sh /bin/

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["/bin/run.sh"]

#HEALTHCHECK --interval=5s --retries=24 --timeout=1s CMD curl -sI localhost:8086/ping | grep -q "204 No Content"

LABEL axway_image="influxdb-relay"
