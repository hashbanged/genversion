FROM alpine:3.22.2 AS alpine

COPY ./bin/genversion /tmp/genversion

RUN apk add --no-cache \
        bash \
        git \
        openssh-client \
    && mv /tmp/genversion /usr/local/bin/genversion \
    && chmod 744 /usr/local/bin/genversion \
    && mkdir /app
WORKDIR /app

ENTRYPOINT [ "/bin/bash", "/usr/local/bin/genversion" ]
