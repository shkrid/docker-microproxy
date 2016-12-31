FROM alpine

MAINTAINER Artem Yasinskiy <shkrid@gmail.com>

WORKDIR /mp

RUN \
    apk add --no-cache --virtual .build-deps go git && \
    export GOPATH=/go && \
    go get github.com/thekvs/microproxy && \
    cp /go/bin/microproxy /usr/local/bin/ && \
    rm -rf /go && \
    apk del .build-deps

RUN echo $'{ \n\
    "listen": "0.0.0.0:3128", \n\
    "access_log": "/dev/stdout", \n\
    "activity_log": "/dev/stderr", \n\
    "allowed_connect_ports": [443, 80], \n\
    "auth_file": "auth.txt", \n\
    "auth_type": "basic", \n\
    "forwarded_for_header": "delete", \n\
    "via_header": "delete", \n\
    "allowed_networks": ["0.0.0.0/0"] \n\
}' > microproxy.json

EXPOSE 3128

ENV MP_USER=microproxy \
    MP_PASS=microproxy

CMD [ -f auth.txt ] || echo "$MP_USER:$MP_PASS" > auth.txt && exec microproxy
