FROM alpine AS build-env

MAINTAINER Artem Yasinskiy <shkrid@gmail.com>

RUN apk add --no-cache --virtual .build-deps go git libc-dev
RUN CGO_ENABLED=0 GOOS=linux go get -a -installsuffix cgo -buildmode=exe github.com/thekvs/microproxy


#FROM scratch - does not work as tools needed
FROM busybox

WORKDIR /mp

COPY --from=build-env /root/go/bin/microproxy /

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

CMD [ -f auth.txt ] || echo "$MP_USER:$MP_PASS" > auth.txt && /microproxy -config microproxy.toml
