#https://github.com/microscaling/microscaling/blob/master/Makefile
IMAGE_NAME = shkrid/docker-microproxy

default: build

build:
	docker build --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
    --build-arg VCS_REF=`git rev-parse --short HEAD` \
    -t $(IMAGE_NAME) .

push:
	docker push $(IMAGE_NAME)

debug:
	docker run --rm -ti $(IMAGE_NAME) /bin/sh

run:
	docker run --rm -ti -p 3128:3128 $(IMAGE_NAME)

release: build push