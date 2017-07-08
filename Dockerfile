FROM alpine

MAINTAINER Artem Yasinskiy <shkrid@gmail.com>

WORKDIR /mp

RUN \
    apk add --no-cache --virtual .build-deps go git libc-dev && \
    go get github.com/thekvs/microproxy && \
    cp $(go env GOPATH)/bin/microproxy /usr/local/bin/ && \
    rm -rf $(go env GOPATH) && \
    apk del .build-deps

RUN echo $'listen="0.0.0.0:3128"\n\
access_log="/dev/stdout"\n\
activity_log="/dev/stderr"\n\
allowed_connect_ports=[443, 80]\n\
auth_file="auth.txt"\n\
auth_type="basic"\n\
forwarded_for_header="delete"\n\
via_header="delete"\n\
allowed_networks=["0.0.0.0/0"]\n\
' > microproxy.toml

EXPOSE 3128

ENV MP_USER=microproxy \
    MP_PASS=microproxy

CMD [ -f auth.txt ] || echo "$MP_USER:$MP_PASS" > auth.txt && exec microproxy -config microproxy.toml
