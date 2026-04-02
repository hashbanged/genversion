FROM alpine:3.23.3 AS alpine

COPY ./bin/genversion /tmp/genversion

RUN apk update && apk add --no-cache \
        bash \
        busybox \ 
        git \
        openssh-client \
        zlib=1.3.2-r0; \
    mv /tmp/genversion /usr/local/bin/genversion \
    && chmod 744 /usr/local/bin/genversion \
    && mkdir /app
WORKDIR /app

ENTRYPOINT [ "/bin/bash", "/usr/local/bin/genversion" ]
