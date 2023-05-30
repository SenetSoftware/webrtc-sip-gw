BUILD   ?= $(shell date +%Y%m%d%H%M)
TAG     ?= $(shell git describe --abbrev=0)
VERSION := $(TAG)-$(BUILD)

build:
	docker buildx build --network=host --platform linux/amd64 -t webrtc-sip-gw:latest --rm .

run:
	docker-compose up -d

stop:
	docker-compose down

login:
	docker exec -it webrtc-sip-gw /bin/bash

logs:
	docker-compose logs --follow


# 11/6
# 19 112
# 10 2-5