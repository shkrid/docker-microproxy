FROM alpine AS build-env
RUN apk add --no-cache --virtual .build-deps go git libc-dev
RUN CGO_ENABLED=0 GOOS=linux go get -a -installsuffix cgo -buildmode=exe github.com/thekvs/microproxy


#FROM scratch - does not work as tools needed
FROM busybox

LABEL maintainer "Artem Yasinskiy <shkrid@gmail.com>"

COPY --from=build-env /root/go/bin/microproxy /
WORKDIR /mp
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


# Build-time metadata as defined at http://label-schema.org
ARG "BUILD_DATE=unknown"
ARG "VCS_REF=unknown"
LABEL org.label-schema.build-date=$BUILD_DATE \
	  org.label-schema.name="Docker-microproxy" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/shkrid/docker-microproxy" \
      org.label-schema.schema-version="1.0"
